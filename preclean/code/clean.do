/* # load ../temp files and clean
# clean; prep
# output a final, merged csv file in ..\output\dataset */

clear all
cap log close

cap log using "../input/clean_raw", text replace

cap drop mkdir ../temp

cap program drop import_calendar
program import_calendar
	import delimited using "../input/calendar.csv", delimit(",") varn(1) clear
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
	*keep listing_id date price available
	*save ../temp/calendar, replace


cap program drop import_listings
program import_listings
	import excel using "../input/listings.xlsx", firstrow clear
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

	save ../temp/listings, replace

cap program drop import_reviews
program import_reviews
	import excel using "../input/reviews.xlsx", firstrow clear
	drop A id
	gen temp=date(date,"YMD")
	drop date
	rename temp date
	format date %td
	save ../temp/reviews, replace

import_calendar
import_listings
import_reviews
