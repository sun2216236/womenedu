clear all
set more off
capture log close

global data "H:\stata\data"
global output "H:\stata\output"

log using "$output\children", replace

cd "$output"

use "$stata\charls11\family_information.dta"
*family information

keep householdID ID communityID cb049_1_ cb049_2_ cb049_3_ cb049_4_ cb049_5_ cb049_6_ cb049_7_ cb049_8_ cb049_9_ cb049_10_ cb049_11_ cb049_12_ cb049_13_ cb049_14_ cb051_1_1_ cb051_1_2_ cb051_1_3_ cb051_1_4_  ///
             cb051_1_5_ cb051_1_6_ cb051_1_7_ cb051_1_8_ cb051_1_9_  ///
			 cb051_1_10_ cb051_1_11_ cb051_1_12_ cb051_1_13_ cb051_1_14_ /// 
			 cb051_2_1_ cb051_2_2_ cb051_2_3_ cb051_2_4_ cb051_2_5_ cb051_2_6_  ///
			 cb051_2_7_ cb051_2_8_ cb051_2_9_ cb051_2_10_ cb051_2_11_ cb051_2_12_ cb051_2_13_ cb051_2_14_  ///
			 cb052_1_ cb052_2_ cb052_3_ cb052_4_ cb052_5_ /// 
             cb052_6_ cb052_7_ cb052_8_ cb052_9_ cb052_10_ cb052_11_ cb052_12_  ///
			 cb052_13_ cb052_14_ cb059_1_ cb059_2_ cb059_3_ cb059_4_ cb059_5_ cb059_6_ cb059_8_  /// 
			 cb059_9_ cb060_1_ cb060_2_ cb060_3_ cb060_4_ cb060_5_ cb060_6_ cb060_7_ cb060_8_ cb060_9_ cb060_10_ ///
			 cb064_1_ cb064_2_ cb064_3_ cb064_4_ cb064_5_ cb064_6_ cb064_7_ cb064_8_ cb064_9_ /// 
			 cb064_10_ cb069_1_ cb069_2_ cb069_3_ cb069_4_ cb069_5_ cb069_6_ cb069_7_ cb069_8_ cb069_9_ ///
			 cb069_10_ cb069_11_ cb069_12_ cb069_13_ cb069_14_ cb069_15_ cb069_23_ cb069_25_

forvalues i=1/14{
rename cb051_1_`i'_ cb051_1`i' 
rename cb051_2_`i'_ cb052_2`i' 
rename cb052_`i'_  cb052`i' 
rename cb049_`i'_ cb049`i'
}

forvalues i=1/9{
rename cb059_`i'_ cb059`i'
}
rename cb059_8_ cb0598
rename cb059_9_ cb0599

forvalues i=1/10{
rename cb060_`i'_ cb060`i'
rename cb064_`i'_ cb064`i'
}

forvalues i=1/15{
rename cb069_`i'_ cb069`i'
}
rename cb069_23_ cb06923
rename cb069_25_ cb06925

reshape long cb049 cb051_1 cb052_2 cb052 cb059 cb060 cb064 cb069,i(householdID) j(individual)
save feizhuhui	,replace

use "$stata\charls11\household_roster.dta"		 

keep  householdID ID communityID a002_1_ a002_2_ a002_3_ a002_4_ a002_5_ a002_6_ a002_7_ a002_8_ a002_9_ a002_10_ a002_11_ a002_12_ a002_13_ a002_14_ a002_15_ a002_16_ a003_1_1_ a003_1_2_ a003_1_3_ a003_1_4_ a003_1_5_ a003_1_6_ a003_1_7_ a003_1_8_ a003_1_9_ a003_1_10_ a003_1_11_ a003_1_12_ a003_1_13_ a003_1_14_ a003_1_15_ a003_1_16_ a003_2_1_ a003_2_2_ a003_2_3_ a003_2_4_ a003_2_5_ a003_2_6_ a003_2_7_ a003_2_8_ a003_2_9_ a003_2_10_ a003_2_11_ a003_2_12_ a003_2_13_ a003_2_14_ a003_2_15_ a003_2_16_ a014_1_ a014_2_ a014_3_ a014_4_ a014_5_ a014_6_ a014_7_ a014_8_ a014_9_ a014_10_ a014_11_ a014_12_ a014_13_ a015_1_ a015_2_ a015_3_ a015_4_ a015_5_ a015_6_ a015_7_ a015_8_ a015_9_ a015_10_ a015_11_ a015_12_ a015_13_ a015_14_ a015_15_ a015_16_ ///
       a006_1_ a006_2_ a006_3_ a006_4_ a006_5_ a006_6_ a006_7_ a006_8_ a006_9_ a006_10_ a006_11_ a006_12_ a006_13_ a006_14_ a006_15_ a006_16_

forvalues i=1/16{
rename a002_`i'_ a002`i'
rename a003_1_`i'_ a003_1`i'
rename a003_2_`i'_ a003_2`i'
rename a015_`i'_ a015`i'
rename a006_`i'_ a006`i'
}

forvalues i=1/13{
rename a014_`i'_ a014`i'
}

reshape long a002 a006 a003_1 a003_2 a014 a015,i(householdID) j(individual)

save zhuhu,replace

gen financialsupport=.
gen childincome=.
gen lunar=.
gen inhome=1

save m1,replace
use zhuhu
save m2,replace
append using m1

save merge,replace
sort householdID
xtset householdID individual
replace month=month+1 if lunar==2
replace year=year+1 if month==13
replace month=1 if mmonth==13

keep if sex==1
save temp,replace
keep householdID individual ID community ID sex year
reshape wide sex year,i(householdID) j(individual)
