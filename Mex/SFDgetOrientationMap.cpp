#define _USE_MATH_DEFINES

#include "mex.h"
#include "tmwtypes.h"
#include <math.h>

#if NAN_EQUALS_ZERO
#define IsNonZero(d) ((d)!=0.0 || mxIsNaN(d))
#else
#define IsNonZero(d) ((d)!=0.0)
#endif

#define CS1(a,b,c,d) coeffsSymmetry1[(a-1) + (b-1)*nRows + (c-1)*nRows*nCols + (d-1)*nRows*nCols*nOris] //symmetry1 coefficients
#define PO(a,b) mostSignificantOris[(a-1) + (b-1)*nRows] //mostSignificant orientations
#define PS(a,b) mostSignificantScales[(a-1) + (b-1)*nRows] //mostSignificant scales
#define OM(a,b) orientationMap[(a-1) + (b-1)*nRows] //orientation Map

double fmax(double a, double b){
    return a > b ? a : b;
}
double fmin(double a, double b){
    return a < b ? a : b;
}
// double fabs(double a){
//     return a > 0.0 ? a : -a;
// }

                  
//orientationMap = CMFDgetHeightAndWidthMap(coeffsSym1,mostSignificantOris,mostSignificantScales,isShear)
void mexFunction(int nlhs,       mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
    const mwSize * dimsCoeffs;
    uint16_T nOris,nScales,nRows,nCols;
    uint16_T nIntegralX;
    uint16_T r,c,po,s,ps;
    uint16_T shearPoDec;
    uint16_T isShear;
    uint16_T * mostSignificantOris, * mostSignificantScales;
    double * coeffsSymmetry1;
    double * orientationMap;
    double mostSignificantCoeff,leftCoeff,rightCoeff;

    if (nrhs != 4) {
        mexErrMsgTxt("Four input arguments required.");
    } 
    // read input   
    coeffsSymmetry1 = mxGetPr(prhs[0]);
    mostSignificantOris = (uint16_T *)mxGetData(prhs[1]);
    mostSignificantScales = (uint16_T *)mxGetData(prhs[2]);
    isShear = ((uint16_T*)mxGetData(prhs[3]))[0];
    
    dimsCoeffs = mxGetDimensions(prhs[0]);
    nRows = dimsCoeffs[0];
    nCols = dimsCoeffs[1];
    nOris = dimsCoeffs[2];
    
    if(mxGetNumberOfDimensions(prhs[0]) > 3){
        nScales = dimsCoeffs[3];
    }else{
        nScales = 1;
    }        
   
    // create output
    
    plhs[0] = mxCreateDoubleMatrix(nRows,nCols,mxREAL);    
    
    orientationMap = mxGetPr(plhs[0]);    
       
    for(r = 1; r <= nRows;r++){        
        for(c = 1;c <= nCols;c++){
            // compute scale coefficient
            ps = PS(r,c);
            po = PO(r,c);
            mostSignificantCoeff = CS1(r,c,po,ps);            

            if(po == 1){
                    leftCoeff = fabs(CS1(r,c,nOris,ps));
                    rightCoeff = fabs(CS1(r,c,po+1,ps));
            }else if(po == nOris){
                    leftCoeff = fabs(CS1(r,c,po-1,ps));
                    rightCoeff = fabs(CS1(r,c,1,ps));
            }else{
                     leftCoeff = fabs(CS1(r,c,po-1,ps));
                     rightCoeff = fabs(CS1(r,c,po+1,ps));
            }
            OM(r,c) = po + (rightCoeff - leftCoeff)/(4*fabs(mostSignificantCoeff) - 2*(rightCoeff + leftCoeff));     
            if(OM(r,c) < 1.0){
                OM(r,c) = OM(r,c) + (nOris-6*isShear);
            }
            if(isShear){
                if(po > nOris/2){
                    OM(r,c) -= nOris/2;
                    OM(r,c) = 180.0*atan((OM(r,c) - (nOris/4)-1)/((nOris-6)/4))/M_PI;   
                    if(OM(r,c) < 0.0){
                        OM(r,c) += 180;
                    }
                }else{
                    OM(r,c) = 90.0+180.0*atan((OM(r,c) - (nOris/4)-1)/((nOris-6)/4))/M_PI;  
                }
                
                /*if(po < nOris/2){
                    OM(r,c) -= 1;
                }else if(po < nOris - 1){
                    OM(r,c) -= 4;
                }else{
                    OM(r,c) -= (nOris-2);
                }*/
            }else{            
                OM(r,c) = ((OM(r,c)-1.0)/((double)(nOris)))*180.0;
            }
        }
    }
}

/*Written by Rafael Reisenhofer

 Part of SymFD Toolbox v 1.0
 Built on September 3, 2018
 Published under the MIT License*/
