#include "mex.h"
#include "tmwtypes.h"
#include <cmath>

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
#define INT(a) integral[(uint16_T)((double)(a)*(double)(nIntegral-1))] //integral X
#define WM(a,b) widthMap[(a-1) + (b-1)*nRows] //width map (row,col)
#define HM(a,b) heightMap[(a-1) + (b-1)*nRows] //heightMap map (row,col)
#define MolW(a,b) moleculeWidths[(a-1) + (b-1)*nOris] //moleculeWidth map (scale,ori)


double fmax(double a, double b){
    return a > b ? a : b;
}
double fmin(double a, double b){
    return a < b ? a : b;
}
double fsign(double a){
    if(a == 0.0) return 0.0;
    return a > 0.0 ? 1.0 : -1.0;
}
                  
//featureMap = CMFDgetRidgeMap(coeffsSym1,coeffsSym2,mostSignificantOris,mostSignificantScales,minContrast,integral,integralReferenceWidth,widthMap,moleculeWidths,heightMap)
void mexFunction(int nlhs,       mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
    const mwSize * dimsCoeffs;
    uint16_T nOris,nScales,nRows,nCols,nIntegral;
    uint16_T r,c,po,s,ps,o;
    uint16_T * mostSignificantOris, * mostSignificantScales;
    double * coeffsSymmetry2,* coeffsSymmetry1;
    double * featureMap;
    double * integral;
    double * widthMap;
    double * heightMap;
    double * moleculeWidths;
    double minContrast,normalizationFactor,pcs1;
    double moleculeContrast;
    double integralReferenceWidth;
    double integralHelp;
    double cs1Min,cs2Max;
    if (nrhs != 10) {
        mexErrMsgTxt("Ten input arguments required.");
    } 
    // read input   
    coeffsSymmetry1 = mxGetPr(prhs[0]);
    coeffsSymmetry2 = mxGetPr(prhs[1]);
    mostSignificantOris = (uint16_T *)mxGetData(prhs[2]);
    mostSignificantScales = (uint16_T *)mxGetData(prhs[3]);
    minContrast = mxGetPr(prhs[4])[0];
    integral = mxGetPr(prhs[5]);
    integralReferenceWidth = mxGetPr(prhs[6])[0];
    widthMap = mxGetPr(prhs[7]);
    moleculeWidths = mxGetPr(prhs[8]);
    heightMap = mxGetPr(prhs[9]);
    
    nIntegral = mxGetNumberOfElements(prhs[5]);
    
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
            pcs1 = CS1(r,c,po,ps);     
            normalizationFactor = 0.0;
            for(s = 1;s<=nScales;s++){                
                integralHelp = (WM(r,c)/MolW(po,s))*integralReferenceWidth/(2.0*(double)nIntegral);
                if(integralHelp > 1.0) integralHelp = 1.0;     
                cs2Max = 0.0;
                cs1Min = fsign(HM(r,c))*CS1(r,c,1,s);                
                for(o = 1;o<=nOris;o++){
                    if(fsign(HM(r,c))*CS1(r,c,o,s) < cs1Min){
                        cs1Min = fsign(HM(r,c))*CS1(r,c,o,s);
                    }
                    if (fabs(CS2(r,c,o,s)) > cs2Max) {
                            cs2Max = fabs(CS2(r,c,o,s));
                    }                    
                }
                FM(r,c) += (cs1Min - cs2Max);
                FM(r,c) -= minContrast*fabs(INT(integralHelp));
                normalizationFactor += fmax(fabs(CS1(r,c,po,s)),fabs(HM(r,c)*INT(integralHelp)));
            }
            FM(r,c) = fmax(0.0,FM(r,c))/normalizationFactor;
        }
    }
}

/*Written by Rafael Reisenhofer

 Part of SymFD Toolbox v 1.0
 Built on September 3, 2018
 Published under the MIT License*/
