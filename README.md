
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Build
Status](https://travis-ci.org/anhoej/cprr.svg?branch=master)](https://travis-ci.org/anhoej/cprr)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/cprr)](https://cran.r-project.org/package=cprr)

# cprr

Calculate date of birth, age, and gender, and generate anonymous
sequence numbers from CPR numbers. Also modulo 11 check is available,
though this function is only relevant for cpr numbers until 2007.

## Examples

``` r
# Load cprr.
library(cprr)

# Make vector of example cpr numbers.
cpr <- c('1508631111', '020962-4444', '131076-2222', '1508631111', '2110625629')

# Caluculate dates of birth from cpr numbers.
dob(cpr)
#> [1] "1963-08-15" "1962-09-02" "1976-10-13" "1963-08-15" "1862-10-21"

# Calculate ages from cpr numbers.
age(cpr)
#> [1]  60.77207  61.72211  47.60849  60.77207 161.58522

# Calculate genders from cpr numbers.
gender(cpr)
#> [1] 1 0 0 1 1

# Generate anonymous sequence numbers from cpr numbers.
scramble(cpr)
#> [1] 3 4 2 3 1

# Perform modulo 11 check of cpr numbers.
mod11(cpr)
#> [1] FALSE FALSE FALSE FALSE  TRUE

# Format cpr numbers correctly
format(cpr, add_hyphen=TRUE)
#> [1] "150863-1111" "020962-4444" "131076-2222" "150863-1111" "211062-5629"

# Make data frame from build in data set of official test cpr numbers.
cpr <- test_cpr$cpr
data.frame(
  cpr    = cpr,
  id     = scramble(cpr),
  dob    = dob(cpr),
  gender = gender(cpr),
  mod11  = mod11(cpr)
)
#>           cpr id        dob gender mod11
#> 1  0104909995  3 1990-04-01      1 FALSE
#> 2  0104909989  4 1990-04-01      1 FALSE
#> 3  0107729995 26 1972-07-01      1 FALSE
#> 4  0108589995  1 1958-08-01      1 FALSE
#> 5  0108629996  8 1962-08-01      0 FALSE
#> 6  0201609995  6 1960-01-02      1 FALSE
#> 7  0201609996 10 1960-01-02      0 FALSE
#> 8  0201919990 17 1991-01-02      0 FALSE
#> 9  0201919995 20 1991-01-02      1 FALSE
#> 10 0201919996 15 1991-01-02      0 FALSE
#> 11 0211223989 23 1922-11-02      1 FALSE
#> 12 0212159995 28 2015-12-02      1 FALSE
#> 13 0504909989 13 1990-04-05      1 FALSE
#> 14 0504909995 14 1990-04-05      1 FALSE
#> 15 0506889996  5 1988-06-05      0 FALSE
#> 16 1007059995  7 2005-07-10      1 FALSE
#> 17 1110109996 16 2010-10-11      0 FALSE
#> 18 1310169995  9 2016-10-13      1 FALSE
#> 19 1310169996 22 2016-10-13      0 FALSE
#> 20 1502779995 27 1977-02-15      1 FALSE
#> 21 1502799995 21 1979-02-15      1 FALSE
#> 22 1502829995 19 1982-02-15      1 FALSE
#> 23 1509819996 25 1981-09-15      0 FALSE
#> 24 2103009996 11 2000-03-21      0 FALSE
#> 25 2311143995 18 1914-11-23      1 FALSE
#> 26 2509479989 12 1947-09-25      1 FALSE
#> 27 2512489996 29 1948-12-25      0 FALSE
#> 28 2911829996  2 1982-11-29      0 FALSE
#> 29 3001749995 24 1974-01-30      1 FALSE
#> 30 3103979995 30 1997-03-31      1 FALSE
```

## Installation

You can install development version from github:

``` r
# install.packages("devtools")
devtools::install_github("anhoej/cprr")
```

Or stable version from CRAN:

``` r
install.packages("cprr")
```

## About CPR numbers

The Danish Personal Identification number (Danish: *CPR-nummer* or
*personnummer*) is a national identification number, which is part of
the personal information stored in the Civil Registration System
(Danish: *[Det Centrale Personregister](https://www.cpr.dk/)*).

It is a ten-digit number with the format DDMMYY-SSSS, where DDMMYY is
the date of birth and SSSS is a sequence number. The first digit of the
sequence number encodes the century of birth (so that centenarians are
distinguished from infants), and the last digit of the sequence number
is odd for males and even for females.

The civil register lists only persons who:

- Are born in Denmark of a mother already registered in the civil
  register, or
- have their birth or baptism registered in a ’Dansk Elektronisk
  Kirkebog (DNK)’ (Danish electronic church-book), or
- reside legally in Denmark for 3 months or more (non-Nordic citizens
  must also have a residence permit).

Danish citizens, including newborn babies, who are entitled to Danish
citizenship, but are living abroad, do not receive a personal ID number,
unless they move to Denmark.

Source:
<https://en.wikipedia.org/wiki/Personal_identification_number_(Denmark)>
