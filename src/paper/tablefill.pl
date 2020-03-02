 #################################################
# Tablefill.pl   -   Fill "empty" Lyx or Tex table file with specialized output from Stata
#  Created by: PD, Sept 09
#################################################

######################
#Extremely robust input control from command line
######################
$tabledata="";
$empty_tablefile="";
$output_tablefile="";
$iflag, $tflag, $oflag, $mflag = (0,0,0,0);
#Reads the arguments one by one
foreach $argnum (0 .. $#ARGV) {
	$arg = $ARGV[$argnum];
	
	# if the argument is -i, -t or -o, then I start the "this is going to be the file name" (for input, template, and output respectively)
	# This is so that we can have spaces in the argument names.
	if ($arg =~ /^\(?-i/i) {
		$iflag =1;
		$tflag =0;
		$oflag =0;
		$mflag =0;
		# Decided multiple -i files are worth killing program over.
		if ($tabledata ne ""){
			die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: command line for $0 has two -i arguments.  $0 only takes one -i input for now.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
		}
		# Old way:  reset the $tabledata input so that it will keep only the last one.
		#$tabledata = "";
	}
	elsif ($arg =~ /^\(?-t/i){
		$iflag =0;
		$tflag =1;
		$oflag =0;
		$mflag =0;
		# Decided multiple -t files are worth killing program over.
		if ($empty_tablefile ne ""){
			die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: command line for $0 has two -t arguments.  $0 only takes one -t input for now.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
		}
		# Old way:  reset the template file so that it will keep only the last one.
		#$empty_tablefile = "";
	}
	elsif ($arg =~ /^\(?-o/i){
		$iflag =0;
		$tflag =0;
		$oflag =1;
		$mflag =0;
		# Decided multiple -o files are worth killing program over.
		if ($output_tablefile ne ""){
			die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: command line for $0 has two -o arguments.  $0 only takes one -o input for now.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
		}
		# Old way:  Reset output file so it keeps only the last one.
		#$output_tablefile = "";
	}
	elsif ($arg =~ /^\(?-m/i){
		$iflag =0;
		$tflag =0;
		$oflag =0;
		$mflag =1;
		# Decided multiple -m files are worth killing program over.
		if ($master_file ne ""){
			die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: command line for $0 has two -o arguments.  $0 only takes one -o input for now.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
		}
		# Old way:  Reset output file so it keeps only the last one.
		#$output_tablefile = "";
	}
	elsif ($iflag==1){
		$tabledata .= " $ARGV[$argnum]";
	}
	elsif ($tflag==1){
		$empty_tablefile .= " $ARGV[$argnum]";
	}
	elsif ($oflag==1){
		$output_tablefile .= " $ARGV[$argnum]";
	}
	elsif ($mflag==1){
		$master_file .= " $ARGV[$argnum]";
	}
	# A little cleaning up of the name (incase people are careless with input/output names)
	#and so we can have things like "(-i hello.txt)" and not have ")" appear in the file name.
	$tabledata =~ s/(\(|\))$//;
	$empty_tablefile =~ s/(\(|\))$//;
	$output_tablefile =~ s/(\(|\))$//;
	$master_file =~ s/(\(|\))$//;
	$tabledata =~ s/^ //;
	$empty_tablefile =~ s/^ //;
	$output_tablefile =~ s/^ //;
	$master_file =~ s/^ //;
}

###########
# Alternative way of doing it - use reg-expression and do 
#while ($line =~ /\(?-([iot])\s+(.*?)\s*\)?\s-([iot])?/ig){
#     $filename = $2; 
#     $inputtype = $1;
# }
#or something close to that.
##########

############################
#   INPUTS/OUTPUTS ERROR CHECKING 
############################

#handle cases in which the user left input/template/output blank.
if ($tabledata eq "") {
	$tabledata = "tables.txt";
}
if ($empty_tablefile eq "") {
	$empty_tablefile = "tables.tex";
}
if ($output_tablefile eq ""){
	$output_tablefile = $empty_tablefile;
	$output_tablefile =~s/(.*?)\.(.{1,4})$/$1_fill\.$2/;
}

#Make sure template is either .lyx or .tex
if ($empty_tablefile =~ /\.lyx/i){
	$LYX_SWITCH =1;
} elsif ($empty_tablefile =~ /\.tex/i){
	$LYX_SWITCH =0;
} else { 
	die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Empty table file must be either .lyx or .tex!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
}

#If the user doesn't specify an ending to the output file, add .lyx or .tex respectively for the user.
if ($output_tablefile !~ /(.*?)\.(.{1,4})$/){
	if ($LYX_SWITCH){ $output_tablefile .= ".lyx";}
	else {$output_tablefile .= ".tex";}
}

#If the output_table file isn't of the expected type, then it should die!!!
if ($LYX_SWITCH) {
	if ($output_tablefile !~ /\.lyx/i){
		die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Output table file $output_tablefile must be the same type as the input file (.lyx in this case)\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
	}
}
if (not($LYX_SWITCH)) {
	if ($output_tablefile !~ /\.tex/i){
		die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Output table file $output_tablefile must be the same type as the input file (.tex in this case)\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
	}
	if ($master_file ne ""){
		die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Master file not blank (\"$master_file\")!  Master files are irrelevant when using .tex as template/output.\nAre you sure you don't mean to be using a .lyx file?\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
	}
}
#Print out the names of the files so people can understand what's going on.
print "$0 argument parsing\nData: $tabledata\nTemplate: $empty_tablefile\nOutput: $output_tablefile\nMaster File: $master_file\n";
if ($output_tablefile eq $empty_tablefile){
	die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Woah we were about to overwrite your input template!\nYou need to change something, or if you think it's a bug, contact Pat after checking documentation.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
}
if ($output_tablefile eq $tabledata){
	die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Woah we were about to overwrite your input data!\nYou need to change something, or if you think it's a bug, contact Pat after checking documentation.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
}
if ($master_file eq $empty_tablefile){
	die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Master file is the same as template file?!\nYou need to change something, or if you think it's a bug, contact Pat after checking documentation.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
}
if ($master_file eq $output_tablefile){
	die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Master file is the same as output file?!\nYou need to change something, or if you think it's a bug, contact Pat after checking documentation.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
}
############################
#  READING .txt file for table data.
############################
#open inputs and outputs all at once, so that the program will crash right away if something's not right.
open(TABLES, $empty_tablefile) || die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Cannot open input $empty_tablefile\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
open (OUTPUT, ">$output_tablefile") || die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Cannot open output $output_tablefile\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";


%tablehash = ();
while ($tabledata =~ /([^\s]+)/ig){
	$table = $1;
	print "Here is the table $table\n";
	open (INPUT, $table) || die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Cannot open input $table!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";

	# %tablehash = used to store data from the tabledata file (i.e. the real numbers)
	#  FORMAT:   $tablehash{table}{row}{column} = value from table file.
	while ($line = <INPUT>){
		$line =~ s/[\r\n]//g;
		if ($line =~ /^\s*\<(.*?)\>\s*/) {
			#Make all table names uppercase incase there are slight differences across the lyx/tex and table files.  (i.e. for human error)
			$label = uc($1);
			$row=1;
			if (defined($tablehash{$label})){
				die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: table $label appears twice.  It appears in $table and in one of the following:\n" . $tabledata . "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
			}
		}
		#if line is anything but blank or a line of spaces, then we split on tab.  We cannot use the more traditional
		#   $line !~ /^\s*$/  because a line of tabs would then not be looked at (as \s includes tabs).  Therefore, we use just the space.
		elsif ($line !~ /^ *$/){
		#elsif ($line ne ""){
			@terms = split /\t/, $line;
			$size = @terms;
			$counter = 1;
			for $term (@terms){
				#Matt wants missings (".") to be treated as if they don't even exist
				if ($term !~ /^ *(\.|NaN) *$/i){
					$tablehash{$label}{$row}{$counter} = $term;
					$counter++;
				}
			}
			#if a row is entirely missing, it will not be itialized; we ignore the entire row
			if ((exists $tablehash{$label}{$row})==0) {
				$row--;
			}
			$row++;
		}
	}
	close(INPUT);
}

############################
#  LYX INPUT/OUTPUT
############################
if ($LYX_SWITCH){
	$tablebegin=0;
	#more sophisticated error handling - program doesn't die if there's only something wrong with table.
	$origtable ="";
	$alteredtable ="";
	$origtable_flag = 0;
	$alreadysaid=0;
	$lastlabel = "";
	$master_file =~ s/\\/\//g;
	while($line = <TABLES>){
		$line =~ s/[\r\n]//g;
		if ($line =~ /\\end_header/i){
			$line = "\\master $master_file\n" . $line;
		}
		$origtable .= "$line\n";
		#Look for the beginning of a table.
		if ($line =~ /\\begin_body/i){
			$temp1 = $empty_tablefile;
			$temp2 = $tabledata;
			$temp0 = $0;
			$temp1 =~ s/\\/\//g;
			$temp2 =~ s/\\/\//g;
			$temp0 =~ s/\\/\//g;
			$niceline = "\n\\begin_layout Standard\n\\begin_inset Note Note\nstatus open\n\n\\begin_layout Plain Layout";
			$niceline .= "\nThis file was produced by $temp0 from template file $temp1 and input file $temp2.";
			$niceline.= "  To make changes in this file, edit the input and template files.\n  Do not edit this file directly.\n";
			$niceline .= "\\end_layout\n\n\\end_inset\n\n\\end_layout";
			$origtable .= "$niceline\n";
			$line .= "\n$niceline";
		}
		if ($line =~ /\\begin_inset CommandInset label/i){
			$tablebegin=1;
			$lastlabel = $label;
			$label = "";
			if ($origtable_flag){
				#Print out the original table if the origtable_flag is set (i.e. if there's been an error somewhere);
				print OUTPUT "$origtable";
				$origtable ="";
				$line = "";
			}
			else {
				#Otherwise print out the alteredtable.
				print OUTPUT "$alteredtable";
				$origtable ="$line\n";
			}
			$alteredtable ="";
			$origtable_flag = 0;
			$alreadysaid=0;
		}
		#If the line has some name and a table has begun, then let's use that as the name of the table.  
		#It's possible but strange if there was something that is given a name before the table but is started after the \begin_inset Float table.  Not much I can do in that case.
		elsif ($line =~ /^name\s+\"(.*)\"\s*$/){
			if ($tablebegin){
				$label = uc($1);
				if ($label eq ""){
					$origtable_flag=1;
					print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: table in template lyx file has no name! see line:\n$line\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
				}
				if (not(defined($tablehash{$label}))){
					$alreadysaid=1;
					$origtable_flag=1;
					print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: $tabledata does not have table with label \"$label\" (ignore uppercase)\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
				}
				$tablebegin=0;
				$row =1;
				$realrow=0;
				$column=1;
			}
			# I put this line in originally but I think things other than tables might get names?  
			#else {die "Something funky going on with table $1.  Table was not preceeded with begin_inset?"}
		}
		
		#If the line in lyx is ### or #(numbers)#
		elsif ($line =~ /(#{3,3}|#\d*?\.?\d+\,?#)/){
			if ($label eq "") {
				if (not($alreadysaid)){
					$origtable_flag =1;
					$alreadysaid=1;
					if ($lastlabel eq ""){
						print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: For one of the tables of $empty_tablefile, I cannot find the label!\nI believe it is the first table in $empty_tablefile.\n(Less likely but possible: a table that follows another table in which I couldn't find the label.)\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
					}
					else{
						print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: For the table after \"$lastlabel\" in $empty_tablefile, I cannot find the table's label!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
					}
				}
			}
			elsif (defined($tablehash{$label})){
				if (defined($tablehash{$label}{$row})){
					if (defined($tablehash{$label}{$row}{$column})) {
						#$line = $tablehash{$label}{$row}{$column};
						if ($line =~ /#{3,3}/){
							$line =~ s/\#{3,3}/$tablehash{$label}{$row}{$column}/;
						}
						# otherwise we need to truncate the tablehash term, if its #(numbers)#
						elsif ($line =~ /#((\d*)\.)?(\d+)(\,)?#/){
							$number = &truncate($tablehash{$label}{$row}{$column}, $2,$3,$4);
							if ($number eq "Error"){
								$origtable_flag=1;
							}
							$line =~ s/#(\d*\.)?\d+\,?#/$number/;
						}
						$realrow=1;
						$column++;
					}
					else {
						#Different error messages based on the "real" problem - i.e. if label is empty or if that table doesn't have the necessary rows.
						$origtable_flag =1;
						print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: $tabledata for table \"$label\" , row $row does not enough columns! It needs at least $column columns.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
					}
				}
				else {
					#Different error messages based on the "real" problem - i.e. if label is empty or if that table doesn't have the necessary rows.
					$origtable_flag =1;
					print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: $tabledata for table \"$label\" does not have enough rows! It needs at least $row rows.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
				}
			}
			else {
				if (not($alreadysaid)){
					$origtable_flag=1;
					$alreadysaid = 1;
					print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: table \"$label\" does not exist in $tabledata but does exist in $empty_tablefile.  Alternatively: $tabledata is being parsed incorrectly somehow.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
				}
			}
		}
		# If we hit the end of a row in which we replaced at least one thing, then we increment the row counter.
		elsif (($line =~ /\<\/row\>/) and ($realrow==1)){
			if (defined($tablehash{$label}{$row}{$column})){
				$origtable_flag =1;
				print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: $tabledata for table $label has extra columns for row $row when compared to $empty_tablefile!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
			}
			$row++;
			$realrow=0;
			$column=1;
		}
		
		####################
		# TODO : Add "extra row" detection here - if $tablehash{$label} has extra rows after the table "finishes" then it needs to die.
		#    "Issue":  Not super easy to detect when the table ends.  Will probably have to count \begin_insets and \end_insets with $insetcounter.  Not great but will implement.
		####################
		
		#Add the altered line to the alteredtable string.
		$alteredtable .= "$line\n";
	}
	if ($origtable_flag){
		print OUTPUT "$origtable";
	}
	else {
		print OUTPUT "$alteredtable";
	}
}

############################
#  TEX INPUT/OUTPUT
############################
if (not($LYX_SWITCH)){
	$tablebegin=0;
	$tableend=1;
	$origtable ="";
	$alteredtable ="";
	$origtable_flag = 1;
	$alreadysaid=0;
	$lastlabel = "";
	while($line = <TABLES>){
		$line =~ s/[\r\n]//g;
		$origtable .= "$line\n";
		#If table begins, then set tablebegin1 to 1, unless the last table didn't finish.
		if ($line =~ /\\begin\{document\}/i){
			$temp1 = $empty_tablefile;
			$temp2 = $tabledata;
			$temp0 = $0;
			$temp1 =~ s/\\/\//g;
			$temp2 =~ s/\\/\//g;
			$temp0 =~ s/\\/\//g;
			$niceline = "\n\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%";
			$niceline .= "!IMPORTANT!\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\n";
			$niceline .= "\%\% This file was produced by $temp0 from template file $temp1 and input file $temp2.\n";
			$niceline .= "\%\% To make changes in this file, edit the input and template files.  Do not edit this file directly.\n";
			$niceline .= "\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%";
			$niceline .= "!IMPORTANT!\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\n";
			$origtable .= "$niceline\n";
			$line .= "\n$niceline";
		}
		if ($line =~ /\\begin\{table\}/i){
			if ($tableend==0){
				$origtable_flag=1;
				print OUTPUT "$origtable";
				die "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Woah!  Something going wrong in the .tex file, a table is starting, but the last table ($label) didn't finish!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
			}
			if ($origtable_flag){
				print OUTPUT "$origtable";
				$origtable = "";
			}
			else {
				print OUTPUT "$alteredtable";
				$origtable = "$line\n";
			}
			$alteredtable = "";
			$origtable_flag=0;
			$tablebegin=1;
			$tableend=0;
			$alreadysaid =0;
			#reset the label - this is so if we can't find a label for this table, we don't start putting in values from the last table!
			$lastlabel = $label;
			$label = "";
		}
		#Read in the label
		if ($line =~ /^\\caption\{.*?\\label\{(.*?)\}.*?\}$/){
			if ($tablebegin){
				$label = uc($1);
				if ($label eq ""){
					$alreadysaid=1;
					$origtable_flag = 1;
					print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: table in template tex file has no name! see line:\n$line\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
				}
				#Uh oh, table data didn't have a table by this label!
				if (not(defined($tablehash{$label}))){
					$alreadysaid =1;
					$origtable_flag = 1;
					print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: $tabledata does not have table with label \"$label\" (ignore uppercase)\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
				}
				$tablebegin=0;
				$row =1;
				$column=1;
			}
			# Originally I had it die if I couldn't find a \begin(table) statement before the caption statement.  But other things than table may have captions!
			#else {die "Something funky going on with table $1.  Table was not preceeded with \begin{table}?"}
		}
		#Tableend==0 so that we don't try to keep adding values after a table has ended and before the next one has started.
		if (($line =~ /#/) and ($tableend ==0)){
			$newline ="";
			#split the line as in .tex, there will be multiple table cells in a single "line".
			@terms = split /\&/, $line;
			foreach $term (@terms){
				# If term is ### or #(digits)# then that means we are going to be substituing stuff
				if ($term =~ /(#{3,3}|#\d*?\.?\d+\,?#)/){
					if ($label eq "") {
						if (not($alreadysaid)){
							$alreadysaid=1;
							$origtable_flag = 1;
							if ($lastlabel eq ""){
								print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: For one of the tables of $empty_tablefile, I cannot find the label!\nI believe it is the first table in $empty_tablefile.\n(Less likely but possible: a table that follows another table in which I couldn't find the label.)\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
							}
							else{
								print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: For the table after \"$lastlabel\" in $empty_tablefile, I cannot find the table's label!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
							}
						}
					}
					elsif (defined($tablehash{$label})){
						if (defined($tablehash{$label}{$row})){
							if (defined($tablehash{$label}{$row}{$column})){
								#Now we need to handle the substitution cases seperately.  I replace things exactly if its ###
								if ($term =~ /#{3,3}/){
									$term =~ s/\#{3,3}/$tablehash{$label}{$row}{$column}/;
								}
								# Otherwise I first truncate and then replace.
								elsif ($term  =~ /#((\d*)\.)?(\d+)(\,)?#/){
									$number = &truncate($tablehash{$label}{$row}{$column}, $2,$3,$4);
									if ($number eq "Error"){
										$origtable_flag=1;
									}
									$term =~ s/#(\d*\.)?\d+\,?#/$number/;
								}
								$column++;
								#add the term back to the line.
								$newline .= "$term&";
							}
							# If you can't find the appropriate number, than either the table's label was not found or the table does not have the number of rows/columns necessary.
							else {
								#Different error messages based on the "real" problem - i.e. if label is empty or if that table doesn't have the necessary rows.
								$origtable_flag =1;
								print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: $tabledata for table \"$label\" , row $row does not enough columns! It needs at least $column columns.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
							}
						}
						else {
							#Different error messages based on the "real" problem - i.e. if label is empty or if that table doesn't have the necessary rows.
							$origtable_flag =1;
							print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: $tabledata for table \"$label\" does not have enough rows! It needs at least $row rows.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
						}
					}
					else {
						if (not($alreadysaid)){
							$origtable_flag=1;
							$alreadysaid = 1;
							print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: table \"$label\" does not exist in $tabledata but does exist in $empty_tablefile.  Alternatively: $tabledata is being parsed incorrectly somehow.\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
						}
					}
				}
				#Otherwise, if the term doesn't have ### or #(digits)# then just add it as it was, with a & afterward.
				else {
					$newline .= "$term&";
				}
			}
			if (defined($tablehash{$label}{$row}{$column})){
				$origtable_flag =1;
				print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: $tabledata for table $label has an extra column that was not used in the tex document!\nRow:$row\nColumn:$column\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
			}
			$row++;
			$column=1;
			# The last term added to the line has an extra & added, so we need to remove that.
			$newline =~ s/\&$//;
			$line = $newline;
		}
		# If the end of a talbe is found, make sure all the rows were used from the data_table file (or equivalent)
		if ($line =~ /\\end{table}/i){
			if (defined($tablehash{$label}{$row+1})){
				$origtable_flag = 1;
				print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: $tabledata for table $label has an extra row that was not used in the tex document!\nRow:$row\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
			}
			$tableend=1;
		}
		#Add the altered line to the altered version of the table.
		$alteredtable .= "$line\n";
	}
	if ($origtable_flag){
		print OUTPUT "$origtable";
	}
	else {
		print OUTPUT "$alteredtable";
	}
}

#Some truncate tests (many more were tried)
# $test1 = &truncate("09234223.230549",3,3);
# print "$test1\n";
# $test1 = &truncate("-534.5532e-2",3,3);
#if ($test1 eq "Error"){ print "oh boy";}
# print "$test1\n";
#$test1 = &truncate(".9689e-3",3,5, "");
#print "$test1\n";
#$test1 = &truncate("-9945.9993",3,2,",");
#print "Hello! $test1\n";


#############################################
#SUB truncate (Number_to_truncate, digits_left_of_decimal_to_truncate, digits_right_of_decimal_to_truncate)
#  Takes a number and shaves it down to number of digits after the demical.
# I also have it so we can shave digits to the left of the decimal, but I haven't implemented this
# because I can't see a situation in which you'd want to...
#############################################
sub truncate {
	#the number in question.
	$num = @_[0];
	# Left is currently not being used.
	$left = @_[1];
	#Right is the number of digits right of the decimal to truncate
	$right = @_[2];
	$commas = @_[3];
	
	if ($right ne ""){
		$right = int($right);
		
		############
		# Handling Regular Notation here:
		############
		#This is the case of a regular (non-scientific notation) number
		# We want to break it up based on the decimal point and deal with the right side seperately.
		if ($num =~ /^\s*(\-?)([0-9]*?)(\.([0-9]*))?\s*$/) {
			$pos = $1;
			$leftnum = $2;
			$rightnum = $4;
			# if right is zero, we don't want any of the right number appearing.  Otherwise we alter the rightnumber.
			if ($right !=0){
				$len = length($rightnum);
				#If the right number is longer than the number of digits to show, then we're going to discard a portion of it (w/ rounding)
				if ($len>$right){
					$num = &rounder($leftnum, $rightnum, $right);
				}
				#If the right number is shorter than(or equal to)  the number of digits, then we have to add additional zeroes at the end.
				else {
					#adding zeroes.
					$temp = "";
					for (local $n=0; $n < $right-$len; $n++){
						$temp .= "0";
					}
					$num = "$leftnum\.$rightnum$temp";
				}
			}
			# if the number of digits to show is zero, we want to possibly round the number left of the decimal point, and then return that.
			else {
				$num = &rounder($leftnum, $rightnum, $right);
			}
			if ($commas ne ""){
				$num = &commify($num);
			}
			$num = $pos . $num;
		}
		############
		# Handling Scientific Notation here:
		############
		elsif ($num =~ /^\s*(\-?)([0-9]*?)(\.([0-9]*))?e([\-\+])([0-9]*)\s*$/) {
			$pos =$1;
			$leftnum = $2;
			$rightnum = $4;
			$pospower = $5;
			$power = int($6);
			if ($pos eq "") {$pos_flag=1;}
			else {$pos_flag =0;}
			if ($pospower eq "+"){$pospower=1;}
			else {$pospower=0;}
			
			# If the power is positive:
			if ($pospower){
				$len = length($rightnum);
				#If there are more digits to the right than there are digits to be on the right at the end,
				#  push the decimal point the right number of places to the right, then call truncate recursively to deal with it in the non-sci-notation section.
				if ($len > $power){
					$temp = (substr($rightnum,0,$power));
					$temp2 = (substr($rightnum,$power,$len));
					$num = "$pos$leftnum$temp\.$temp2";
					# "e" will never appear in $num at this point, so we can safely not worry about infinite loop.
					$num = &truncate($num, $left, $right, $commas);
				}
				else {
					#Add the additional zeros after the numbers.
					$temp = "";
					if ($power > $len){
						for (local $n=0; $n < $power-$len;$n++){
							$temp .= "0";
						}
					}
					$num = "$pos$leftnum$rightnum$temp";
					# "e" will never appear in $num at this point, so we can safely not worry about infinite loop.
					$num = &truncate($num, $left, $right, $commas);
				}
			}
			# If the power is negative:
			else {
				$len = length($leftnum);
				# If there are more digits to the left than the negative power (e.g. 3203.2e-2) then that means somethings wrong - either with the parser or with stata and program should die.
				if ($len > $power){
					#should never happen  3203.3e-2 doesn't make sense to be written that way.
					print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n$0 Error: Strange scientific notation! Number: $num from $tabledata\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
					return("Error");
				}
				# Otherwise if the numbers to the left of the decimal place are less than the negative power, we need to add some zeroes.
				else {
					#adding the zeroes
					$temp = "";
					if ($power-$len >0){
						for (local $n=0; $n < $power-$len;$n++){
							$temp .= "0";
						}
					}
					#Putting in the zeroes and then sending for the non-sci-notation part of truncate to handle.
					$num = "$pos"."0.$temp$leftnum$rightnum";
					$num = &truncate($num, $left, $right, $commas);
				}
			}
		}
	}
	# Return the number after concatenation is done.
	return($num);
}

#SUB Commify (number)
# will add commas to a number (left side of decimal only).
sub commify {
	local $number = @_[0];
	if ($number =~ /^\s*(\-?)([0-9]*?)(\.([0-9]*))?\s*$/) {
		local $leftnum = $2;
		local $rightnum = $3;
		local $input = reverse $leftnum;
		$input =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
		$number= reverse $input;
		$number .= $rightnum;
	}
	return ($number);
}

#SUB Rounder (leftnum, rightnum, digits to truncate to)
#  Rounds leftnum.rightnum and truncates.
# The nice rounder using reg exp.  
sub rounder{
	local $leftnum = @_[0];
	local $rightnum = @_[1];
	local $start =@_[2];
	local $number = "$leftnum\.$rightnum";
	if ($number =~ /^(\d*\.[0-9]{$start,$start})([0-9]).*$/){
		local $newnum = $1;
		local $rounder = int($2);
		if ($rounder >= 5){
			if ($newnum =~ /^([0-9\.]*?)([0-8\.]*)([9\.]*)$/){
				local $left=$1;
				local $middle = $2;
				local $right = $3;
				$right =~ s/9/0/g;
				if ($middle =~ /([0-8])\.?$/){
					$temp= int($1);
					$temp++;
					$middle =~ s/[0-8](\.?)$/$temp$1/;
				}
				else {
					$middle =~ s/(\.?)$/1$1/;
				}
				$newnum = $left . $middle . $right;
			}
		}
		$newnum =~ s/\.$//;
		return ($newnum);
	}
	$number =~ s/\.$//;
	return($number);
}



