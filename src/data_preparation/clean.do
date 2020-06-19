/* 
This do file
1. clean the raw data
*/

clear all
*cap log close
*cap log using "output/log/clean", text replace

cap mkdir generated
foreach j in data_preparation analysis paper {
	cap mkdir generated/`j'
	foreach i in temp input output {
		cap mkdir generated/`j'/`i'
	}
} 
foreach i in log figure table {
	cap mkdir generated/data_preparation/output/`i'
	cap mkdir generated/analysis/output/`i'
} 

global DIR_DATA "generated/data_preparation"

cap program drop import_calendar
program import_calendar
	import delimited using "data/calendar.csv", delimit(",") varn(1) clear
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
	save $DIR_DATA/temp/calendar, replace
end

cap program drop import_listings
program import_listings
	import excel using "data/listings.xlsx", firstrow clear
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

	save $DIR_DATA/temp/listings, replace
end

cap program drop import_reviews
program import_reviews
	import excel using "data/reviews.xlsx", firstrow clear
	drop A id
	gen temp=date(date,"YMD")
	drop date
	rename temp date
	format date %td
	save $DIR_DATA/temp/reviews, replace
end

import_calendar
import_listings
import_reviews


