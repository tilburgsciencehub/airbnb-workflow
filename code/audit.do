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
cap log close

foreach i in temp input output {
	cap mkdir `i'
} 
foreach i in log figure table {
	cap mkdir audit/`i'
}
log using "audit/log/audit", text replace



use "temp/listings.dta", clear

foreach i of varlist price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month {
	quietly sum `i', detail
	matrix TABLE1=(nullmat(TABLE1)\(r(p10), r(mean), r(p90), r(sd), r(N)))	
}
mat2txt, m(TABLE1) saving("audit/table/audit.txt") title("{tab:auditT1}") replace
matrix drop TABLE1

		
foreach i of varlist price review_scores_rating reviews_per_month {
	hist `i'
	graph export "audit/figure/`i'.pdf", replace
}

scatter price accommodates || lfit price accommodates
graph export "audit/figure/pri_accom.pdf", replace
scatter price review_scores_rating || lfit price review_scores_rating
graph export "audit/figure/pri_rating.pdf", replace
scatter review_scores_rating reviews_per_month || lfit review_scores_rating reviews_per_month
graph export "audit/figure/rating_review.pdf", replace


use "temp/calendar", clear
collapse (sum) available (count) listing_id, by(date)
mkmat available listing_id, matrix(TABLE2)
mat2txt, m(TABLE2) saving("audit/table/audit.txt") title("{tab:auditT2}") append
matrix drop TABLE2


gen avail_r = available/listing_id

tsset date
tsline avail_r
graph export "audit/figure/available.pdf", replace

