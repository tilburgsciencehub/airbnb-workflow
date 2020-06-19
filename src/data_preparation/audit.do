/*
This do file
1. audits the quality of data
*/


foreach i in distinct tabstatmat mat2txt {
	cap which `i'
	if _rc {
		ssc install `i'
	}
}

clear all
*cap log close

cap mkdir generated
cap mkdir generated/data_preparation
foreach i in temp output audit {
	cap mkdir generated/data_preparation/`i'
} 
foreach i in log figure table {
	cap mkdir generated/data_preparation/audit/`i'
}

global DIR_DATA "generated/data_preparation"


use "$DIR_DATA/temp/listings.dta", clear

foreach i of varlist price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month {
	quietly sum `i', detail
	matrix TABLE1=(nullmat(TABLE1)\(r(p10), r(mean), r(p90), r(sd), r(N)))	
}
mat2txt, m(TABLE1) saving("$DIR_DATA/audit/table/audit.txt") title("{tab:auditT1}") replace
matrix drop TABLE1

		
foreach i of varlist price review_scores_rating reviews_per_month {
	hist `i'
	graph export "$DIR_DATA/audit/figure/`i'.pdf", replace
}

scatter price accommodates || lfit price accommodates
graph export "$DIR_DATA/audit/figure/pri_accom.pdf", replace
scatter price review_scores_rating || lfit price review_scores_rating
graph export "$DIR_DATA/audit/figure/pri_rating.pdf", replace
scatter review_scores_rating reviews_per_month || lfit review_scores_rating reviews_per_month
graph export "$DIR_DATA/audit/figure/rating_review.pdf", replace


use "$DIR_DATA/temp/calendar", clear
collapse (sum) available (count) listing_id, by(date)
mkmat available listing_id, matrix(TABLE2)
mat2txt, m(TABLE2) saving("$DIR_DATA/audit/table/audit.txt") title("{tab:auditT2}") append
matrix drop TABLE2


gen avail_r = available/listing_id

tsset date
tsline avail_r
graph export "$DIR_DATA/audit/figure/available.pdf", replace

