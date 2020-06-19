/*
This do file
1. implements some regression analysis
2. generates summary statistics
*/

foreach i in ftools reghdfe tabstatmat mat2txt {
	cap which `i'
	if _rc {
		ssc install `i'
	}
}


clear all
*cap log close
*cap log using "output/log/analysis", text replace

global DIR_DATA "gen/analysis"

* ERROR

cap program drop analyze_listings
program analyze_listings
	use "gen/data_preparation/temp/listings.dta", clear

	foreach i of varlist price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month {
		quietly sum `i', detail
		matrix TABLE1=(nullmat(TABLE1)\(r(p10), r(mean), r(p90), r(sd), r(N)))	
	}
	mat2txt, m(TABLE1) saving("$DIR_DATA/output/table/analysis.txt") title("{tab:analysisT1}") replace
	matrix drop TABLE1

	foreach i of varlist property_type room_type {
	encode `i', gen(`i'_i) 
	}

	reg price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month
	matrix TABLE2=(nullmat(TABLE2),(_b[age] \ _se[age] \  _b[host_acceptance_rate] \ _se[host_acceptance_rate] \  _b[accommodates] \ _se[accommodates] \ e(r2) \ e(N) ))
	reghdfe price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month, absorb(property_type_i)
	matrix TABLE2=(nullmat(TABLE2),(_b[age] \ _se[age] \  _b[host_acceptance_rate] \ _se[host_acceptance_rate] \  _b[accommodates] \ _se[accommodates] \ e(r2) \ e(N) ))
	reghdfe price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month, absorb(room_type_i)
	matrix TABLE2=(nullmat(TABLE2),(_b[age] \ _se[age] \  _b[host_acceptance_rate] \ _se[host_acceptance_rate] \  _b[accommodates] \ _se[accommodates] \ e(r2) \ e(N) ))
	mat2txt, m(TABLE2) saving("$DIR_DATA/output/table/analysis.txt") title("{tab:analysisT2}") append
	matrix drop TABLE2
end

cap program drop analyze_calendar
program analyze_calendar
	use "gen/data_preparation/temp/calendar.dta", clear
	gen dweek = dow(date)
	replace dweek = 7 if dweek==0

	preserve
	collapse (mean) available, by(dweek)
	twoway bar available dweek
	graph export "$DIR_DATA/output/figure/available.pdf", replace
	restore

	probit available i.dweek
	matrix TABLE3=(nullmat(TABLE3),(_b[2.dweek] \ _se[2.dweek] \_b[3.dweek] \ _se[3.dweek] \_b[4.dweek] \ _se[4.dweek] \_b[5.dweek] \ _se[5.dweek] \_b[6.dweek] \ _se[6.dweek] \_b[7.dweek] \ _se[7.dweek] \ e(ll) \ e(N) ))
	mat2txt, m(TABLE3) saving("$DIR_DATA/output/table/analysis.txt") title("{tab:analysisT3}") append
	matrix drop TABLE3
	
	
end


analyze_listings
analyze_calendar


