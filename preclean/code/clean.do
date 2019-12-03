/* # load ../temp files and clean
# clean; prep
# output a final, merged csv file in ..\output\dataset */

clear all
log close

log using "input/clean_raw", text replace

import delimited using "input/calendar.csv", delimit(",") varn(1) clear
gen temp=date(date,"YMD")
drop date
rename temp date
format date %td
replace price=subinstr(price, "$","",1)
gen temp=real(price)
drop price
rename temp price
collapse (last) price available,by(listing_id date)
foreach i of varlist available {
gen temp = (`i'=="t")
drop `i'
rename temp `i'
}
keep listing_id date price available
save temp/calendar, replace


import excel using "input/listings.xlsx", firstrow clear
drop A 
rename id listing_id
*listing_url-xl_picture_url host_url host_name host_location host_about ///
*	host_thumbnail_url host_neighbourhood street-state market-country calendar_updated 
foreach i of varlist price-cleaning_fee extra_people {
	replace `i'=subinstr(`i', "$","",1)
	gen temp=real(`i')
	drop `i'
	rename temp `i'
}
gen temp=date(host_since,"YMD")
drop host_since
rename temp host_since
format host_since %td

foreach i of varlist host_response_rate host_acceptance_rate {
 replace `i' = subinstr(`i',"%","",1)
 gen temp = real(`i')
 drop `i'
 rename temp `i'
}

gen age = (date(last_scraped,"YMD")-host_since)/365.25

foreach i of varlist host_is_superhost host_identity_verified {
gen temp = (`i'=="t")
drop `i'
rename temp `i'
}

save temp/listings, replace

import excel using "input/reviews.xlsx", firstrow clear
drop A id
gen temp=date(date,"YMD")
drop date
rename temp date
format date %td
save temp/reviews, replace

/*use temp/calendar, clear
*merge 1:m listing_id date using temp/reviews
*drop _m
merge m:1 listing_id using temp/listings, update
drop _m
save /output/dataset/main_airbnb, replace

cap erase temp/calerdar
cap erase temp/listings
cap erase temp/reviews*/



