#' Date of birth
#'
#' Calculate dates of birth from CPR numbers.
#'
#' @param cpr Character vector of CPR numbers with or without hyphens.
#'
#' @return Vector of dates of birth.
#'
#' @examples
#'   dob(c('1508631111', '1310762222'))
#'
#' @export
#'
dob <- function(cpr) {
  cpr <- clean(cpr)

  # d <- lapply(cpr, dobone)
  d <- lapply(cpr, function(cpr) {
    dd <- as.numeric(substr(cpr, 1, 2))
    mm <- as.numeric(substr(cpr, 3, 4))
    yy <- as.numeric(substr(cpr, 5, 6))
    x7 <- as.numeric(substr(cpr, 7, 7))

    if(is.na(cpr) | is.na(x7)) {
      NA
    } else {
      if(x7 < 4) {
        yyyy <- 1900
      } else if(x7 == 4 & yy < 37) {
        yyyy <- 2000
      } else if(x7 == 4) {
        yyyy <- 1900
      } else if(x7 == 5 & yy < 58) {
        yyyy <- 2000
      } else if(x7 == 5) {
        yyyy <- 1800
      } else if(x7 == 6 & yy < 58) {
        yyyy <- 2000
      } else if(x7 == 6) {
        yyyy <- 1800
      } else if(x7 == 7 & yy < 58) {
        yyyy <- 2000
      } else if(x7 == 7) {
        yyyy <- 1800
      } else if(x7 == 8 & yy < 58) {
        yyyy <- 2000
      } else if(x7 == 8) {
        yyyy <- 1800
      } else if(x7 == 9 & yy < 37) {
        yyyy <- 2000
      } else {
        yyyy <- 1900
      }

      yyyy <- yyyy + yy
      dob  <- paste(yyyy, mm, dd, sep = '-')
      dob  <- tryCatch(as.Date(dob),
                       error = function(e) NA)

      if(is.na(dob)) {
        warning(paste(cpr, 'is not a valid CPR number. NA returned.'),
                call. = FALSE)
      }

      return(dob)
    }
  })

  d <- unlist(d)
  as.Date(d, origin = '1970-01-01')
}

#' Age
#'
#' Calculate ages from CPR numbers.
#'
#' @param cpr Character vector of CPR numbers with or without hyphens.
#' @param date Character or date vector of dates used in computation of ages.
#'   Dates provided as characters must follow the ISO standard, 'yyyy-mm-dd'.
#' @param unit Character indicating the unit representing ages. Possible values
#'   are: 'year', 'month', 'week', 'day'.
#'
#' @return Numeric vector of ages. By default ages are computed in years.
#'   Note that year and month units are calculated by approximaion, 1 year =
#'   365.25 days, 1 month = 30.44 days.
#'
#' @examples
#'   age(c('1508631111', '1310762222'))
#'
#' @export
#'
age <- function(cpr, date = Sys.Date(), unit = 'year') {
  cpr <- clean(cpr)

  u <- switch(unit,
              'year'  = 365.25,
              'month' = 30.44,
              'week'  = 7,
              'day'   = 1)

  d1 <- dob(cpr)
  d2 <- as.Date(date)
  a  <- as.numeric(d2 - d1, units = 'days')
  a / u
}

#' Gender
#'
#' Calculate genders from CPR numbers.
#'
#' @param cpr Character vector of CPR numbers with or without hyphens.
#'
#' @return Integer vector of genders: 0 = female, 1 = male.
#'
#' @examples
#'   gender(c('1508631111', '1310762222'))
#'
#' @export
#'
gender <- function(cpr) {
  cpr <- clean(cpr)
  as.numeric(substring(cpr, 10)) %% 2
}

#' Scramble
#'
#' Make "anonymous" random numbers from CPR numbers.
#'
#' @param cpr Character vector of CPR numbers with or without hyphens.
#'
#' @return Integer vector. Each integer represents one unique CPR number.
#'
#' @examples
#'   scramble(c('1508631111', '1310762222', '1508631111'))
#'
#' @export
#'
scramble <- function(cpr) {
  x        <- seq_along(unique(cpr))
  names(x) <- sample(unique(cpr))
  x        <- x[cpr]
  names(x) <- NULL
  x
}

clean <- function(cpr) {
  if(typeof(cpr) != 'character') {
    stop('CPR numbers must be provided as character strings.')
  }

  # :digit: instead of :alnum: removes any hyphens, trailing white spaces, etc.
  cpr <- gsub('[^[:digit:]]+', '', cpr)

  if(any(nchar(cpr[!is.na(cpr)]) != 10)) {
    warning('One or more CPR numbers of incorrect length replaced with NA.')
    cpr[nchar(cpr) != 10] <- NA
  }

  # Check valid date in first 4 digits
  if(any(is.na(as.Date(substr(cpr,1,6), format="%d%m%y")))) {
    warning('One or more CPR numbers with invalid DOB replaced with NA.')
    cpr[is.na(as.Date(substr(cpr,1,6), format="%d%m%y"))] <- NA
  }

  cpr
}

format <- function(cpr, add_hyphen=FALSE) {
  cpr <- clean(cpr)
  if (add_hyphen) {
    cpr <- paste0(substr(cpr,1,6),"-",substr(cpr,7,10))
  }
  cpr
}


#' Modulo 11 check
#'
#' Check if CPR numbers conform to modulo 11 check. Note, modulo 11 check was
#' deprecated in 2007.
#'
#' @param cpr Character vector of CPR numbers with or without hyphens.
#'
#' @return Logical vector of check results, NA if CPR number includes characters
#'   (temporary CPR number).
#'
#' @examples
#'   mod11(c('1508631111', '1310762222', '2110625629'))
#'
#' @export
#'
mod11 <- function(cpr) {
  cpr <- clean(cpr)
  cpr <- strsplit(cpr, NULL)

  cpr <- lapply(cpr, function(cpr) {
    tryCatch(as.integer(cpr), warning = function(e) NA)
  })

  cpr <- lapply(cpr, function(cpr) {
    if(length(cpr) == 10) {
      x <- c(4, 3, 2, 7, 6, 5, 4, 3, 2, 1)
      sum(cpr * x) %% 11 == 0
    } else {
      FALSE
    }
  })

  unlist(cpr)
}
