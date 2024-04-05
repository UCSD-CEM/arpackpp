/*
   ARPACK++ v1.2 2/20/2000
   c++ interface to ARPACK code.

   MODULE debug.h.
   Interface to ARPACK FORTRAN debugging facilities.

   ARPACK Authors
      Richard Lehoucq
      Danny Sorensen
      Chao Yang
      Dept. of Computational & Applied Mathematics
      Rice University
      Houston, Texas
*/

#ifndef DEBUG_H
#define DEBUG_H

#include "arch.h"
#include "arpackf.h"


inline void TraceOff()

/*
  This function sets all ARPACK FORTRAN debug variables to zero.
*/

{

  DEBUG_MACRO_.logfil = 6;
  DEBUG_MACRO_.ndigit = 0;
  DEBUG_MACRO_.mgetv0 = 0;
  DEBUG_MACRO_.msaupd = 0;
  DEBUG_MACRO_.msaup2 = 0;
  DEBUG_MACRO_.msaitr = 0;
  DEBUG_MACRO_.mseigt = 0;
  DEBUG_MACRO_.msapps = 0;
  DEBUG_MACRO_.msgets = 0;
  DEBUG_MACRO_.mseupd = 0;
  DEBUG_MACRO_.mnaupd = 0;
  DEBUG_MACRO_.mnaup2 = 0;
  DEBUG_MACRO_.mnaitr = 0;
  DEBUG_MACRO_.mneigt = 0;
  DEBUG_MACRO_.mnapps = 0;
  DEBUG_MACRO_.mngets = 0;
  DEBUG_MACRO_.mneupd = 0;
  DEBUG_MACRO_.mcaupd = 0;
  DEBUG_MACRO_.mcaup2 = 0;
  DEBUG_MACRO_.mcaitr = 0;
  DEBUG_MACRO_.mceigt = 0;
  DEBUG_MACRO_.mcapps = 0;
  DEBUG_MACRO_.mcgets = 0;
  DEBUG_MACRO_.mceupd = 0;

} // TraceOff.


inline void sTraceOn(const ARint digit, const ARint getv0, const ARint aupd, 
                     const ARint aup2, const ARint aitr, const ARint eigt,
                     const ARint apps, const ARint gets, const ARint eupd)

/*
  This function sets the values of all ARPACK FORTRAN debug 
  variables corresponding to real symmetric eigenvalue problems.
*/

{

  DEBUG_MACRO_.logfil = 6;
  DEBUG_MACRO_.ndigit = digit;
  DEBUG_MACRO_.mgetv0 = getv0;
  DEBUG_MACRO_.msaupd = aupd;
  DEBUG_MACRO_.msaup2 = aup2;
  DEBUG_MACRO_.msaitr = aitr;
  DEBUG_MACRO_.mseigt = eigt;
  DEBUG_MACRO_.msapps = apps;
  DEBUG_MACRO_.msgets = gets;
  DEBUG_MACRO_.mseupd = eupd;

} // sTraceOn.


inline void nTraceOn(const ARint digit, const ARint getv0, const ARint aupd, 
                     const ARint aup2, const ARint aitr, const ARint eigt,
                     const ARint apps, const ARint gets, const ARint eupd)

/*
  This function sets the values of all ARPACK FORTRAN debug 
  variables corresponding to real nonsymmetric eigenvalue problems.
*/

{

  DEBUG_MACRO_.logfil = 6;
  DEBUG_MACRO_.ndigit = digit;
  DEBUG_MACRO_.mgetv0 = getv0;
  DEBUG_MACRO_.mnaupd = aupd;
  DEBUG_MACRO_.mnaup2 = aup2;
  DEBUG_MACRO_.mnaitr = aitr;
  DEBUG_MACRO_.mneigt = eigt;
  DEBUG_MACRO_.mnapps = apps;
  DEBUG_MACRO_.mngets = gets;
  DEBUG_MACRO_.mneupd = eupd;

} // nTraceOn.


inline void cTraceOn(const ARint digit, const ARint getv0, const ARint aupd, 
                     const ARint aup2, const ARint aitr, const ARint eigt,
                     const ARint apps, const ARint gets, const ARint eupd)

/*
  This function sets the values of all ARPACK FORTRAN debug 
  variables corresponding to complex eigenvalue problems.
*/

{

  DEBUG_MACRO_.logfil = 6;
  DEBUG_MACRO_.ndigit = digit;
  DEBUG_MACRO_.mgetv0 = getv0;
  DEBUG_MACRO_.mcaupd = aupd;
  DEBUG_MACRO_.mcaup2 = aup2;
  DEBUG_MACRO_.mcaitr = aitr;
  DEBUG_MACRO_.mceigt = eigt;
  DEBUG_MACRO_.mcapps = apps;
  DEBUG_MACRO_.mcgets = gets;
  DEBUG_MACRO_.mceupd = eupd;

} // cTraceOn.


#endif // DEBUG_H
