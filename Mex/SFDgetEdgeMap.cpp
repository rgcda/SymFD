#include "mex.h"
#include "tmwtypes.h"

#if NAN_EQUALS_ZERO
#define IsNonZero(d) ((d)!=0.0 || mxIsNaN(d))
#else
#define IsNonZero(d) ((d)!=0.0)
#endif

#define CS1(a,b,c,d) coeffsSymmetry1[(a-1) + (b-1)*nRows + (c-1)*nRows*nCols + (d-1)*nRows*nCols*nOris] //odd symmetric coefficients
#define CS2(a,b,c,d) coeffsSymmetry2[(a-1) + (b-1)*nRows + (c-1)*nRows*nCols + (d-1)*nRows*nCols*nOris] //even symmetric coefficients
#define PO(a,b) mostSignificantOris[(a-1) + (b-1)*nRows] //mostSignificant orientations
#define PS(a,b) mostSignificantScales[(a-1) + (b-1)*nRows] //mostSignificant scales
#define FM(a,b) featureMap[(a-1) + (b-1)*nRows] //feature map

double fmax(double a, double b){
    return a > b ? a : b;
}
double fmin(double a, double b){
    return a < b ? a : b;
}
double fabs(double a){
    return a > 0.0 ? a : -a;
}

                  
//featureMap = CMFDgetEdgeMap(coeffsSym1,coeffsSym2,mostSignificantOris,mostSignificantScales,minContrast,integralX)
void mexFunction(int nlhs,       mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
    const mwSize * dimsCoeffs;
    uint16_T nOris,nScales,nRows,nCols;
    uint16_T r,c,po,s,ps;
    uint16_T * mostSignificantOris, * mostSignificantScales;
    double * coeffsSymmetry2,* coeffsSymmetry1;
    double * featureMap;
    double halfSpaceIntegral;
    double minContrast,normalizationFactor,pci;
    double moleculeContrast;
    if (nrhs != 6) {
        mexErrMsgTxt("Six input arguments required.");
    } 
    // read input   
    coeffsSymmetry1 = mxGetPr(prhs[0]);
    coeffsSymmetry2 = mxGetPr(prhs[1]);
    mostSignificantOris = (uint16_T *)mxGetData(prhs[2]);
    mostSignificantScales = (uint16_T *)mxGetData(prhs[3]);
    minContrast = mxGetPr(prhs[4])[0];
    halfSpaceIntegral = mxGetPr(prhs[5])[0];
    
   
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
    
    featureMap = mxGetPr(plhs[0]);    
        
    for(r = 1; r <= nRows;r++){        
        for(c = 1;c <= nCols;c++){
            // compute featureMap
            po = PO(r,c);
            ps = PS(r,c);
            pci = CS1(r,c,po,ps);     
            normalizationFactor = 0.0;
            for(s = 1;s<=nScales;s++){
                FM(r,c) += CS1(r,c,po,s);
                normalizationFactor += fmax(fabs(CS1(r,c,po,s)),fabs(pci));
            }
            FM(r,c) = fabs(FM(r,c));
            for(s = 1;s<=nScales;s++){
                FM(r,c) = FM(r,c) - CS2(r,c,po,s) - minContrast*fabs(halfSpaceIntegral);
            }
            FM(r,c) = fmax(0.0,FM(r,c))/normalizationFactor;
        }
    }
}

/*Written by Rafael Reisenhofer

 Part of SymFD Toolbox v 1.0
 Built on September 3, 2018
 Published under the MIT License*/
