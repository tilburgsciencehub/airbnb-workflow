cap ssc install distinct
cap ssc install estout
clear all
cap log close

cap mkdir ../audit
foreach i in log figure table {
	cap mkdir ../audit/`i'
}


log using "../audit/log/audit", text replace

use "../temp/listings.dta", clear

estpost tabstat price age host_response_rate host_acceptance_rate host_is_superhost host_identity_verified accommodates review_scores_rating reviews_per_month, ///
		stat(count mean sd min p50 max) c(s)
esttab . using "../audit/table/sum_listings.txt", cells("count mean(fmt(a3)) sd(fmt(a3)) min p50 max") replace
		
foreach i of varlist price review_scores_rating reviews_per_month {
	hist `i'
	graph export "../audit/figure/`i'.pdf", replace
}

scatter price accommodates || lfit price accommodates
graph export "../audit/figure/pri_accom.pdf", replace
scatter price review_scores_rating || lfit price review_scores_rating
graph export "../audit/figure/pri_rating.pdf", replace
scatter review_scores_rating reviews_per_month || lfit review_scores_rating reviews_per_month
graph export "../audit/figure/rating_review.pdf", replace


use "../temp/calendar", clear
collapse (sum) available (count) listing_id, by(date)
export delim using "../audit/table/sum_cal.txt", delim(tab) replace

gen avail_r = available/listing_id

tsset date
tsline avail_r
graph export "../audit/figure/available.pdf", replace

