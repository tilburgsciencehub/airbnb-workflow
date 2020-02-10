/*
This do file
1. implements some regression analysis
2. generates summary statistics
*/
foreach i in estout ftools reghdfe {
	which `i'
	if _rc {
		ssc install `i'
	}
}


clear all
cap log close
cap log using "output/log/log", text replace

cap mkdir temp
foreach i in log figure table {
	cap mkdir output/`i'
} 


cap program drop analyze_listings
program analyze_listings
	use "temp/listings.dta", clear

	estpost tabstat price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month, ///
			stat(count mean sd min p50 max) c(s)
	esttab . using "output/table/sum_listings.txt", cells("count mean(fmt(a3)) sd(fmt(a3)) min p50 max") replace

	foreach i of varlist property_type room_type {
	encode `i', gen(`i'_i) 
	}

	eststo: reg price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month
	eststo: reghdfe price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month, absorb(property_type_i)
	eststo: reghdfe price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month, absorb(room_type_i)
	esttab using "output/table/reg_price.txt", nogaps replace
	eststo clear
end

cap program drop analyze_calendar
program analyze_calendar
	use "temp/calendar.dta", clear
	gen dweek = dow(date)
	replace dweek = 7 if dweek==0

	preserve
	collapse (mean) available, by(dweek)
	twoway bar available dweek
	graph export "output/figure/available.pdf", replace
	restore

	eststo: probit available i.dweek
	esttab using "output/table/probit_avail.txt", nogaps replace
	eststo clear
end


analyze_listings
analyze_calendar
