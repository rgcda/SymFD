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
#define IX(a) integralX[(uint16_T)((double)(a)*(double)(nIntegralX-1))] //integral X
#define WM(a,b) widthMap[(a-1) + (b-1)*nRows] //width map (row,col)
#define HM(a,b) heightMap[(a-1) + (b-1)*nRows] //heightMap map (row,col)
#define MolW(a,b) moleculeWidths[(a-1) + (b-1)*nOris] //moleculeWidth map (scale,ori)


double fmax(double a, double b){
    return a > b ? a : b;
}
double fmin(double a, double b){
    return a < b ? a : b;
}
double fabs(double a){
    return a > 0.0 ? a : -a;
}
double fsign(double a){
    if(a == 0.0) return 0.0;
    return a > 0.0 ? 1.0 : -1.0;
}

//featureMap = CMFDgetRidgeMap(coeffsSym1,coeffsSym2,mostSignificantOris,mostSignificantScales,minContrast,integralX,integralXWidth,widthMap,moleculeWidths,heightMap)
void mexFunction(int nlhs,       mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    const mwSize * dimsCoeffs;
    uint16_T nOris,nScales,nRows,nCols,nIntegralX;
    uint16_T r,c,po,s,ps;
    uint16_T * mostSignificantOris, * mostSignificantScales;
    double * coeffsSymmetry2,* coeffsSymmetry1;
    double * featureMap;
    double * integralX;
    double * widthMap;
    double * heightMap;
    double * moleculeWidths;
    double minContrast,normalizationFactor,pcs1;
    double moleculeContrast;
    double integralXWidth;
    double integralHelp;
    if (nrhs != 10) {
        mexErrMsgTxt("Eleven input arguments required.");
    }
    // read input
    coeffsSymmetry1 = mxGetPr(prhs[0]);
    coeffsSymmetry2 = mxGetPr(prhs[1]);
    mostSignificantOris = (uint16_T *)mxGetData(prhs[2]);
    mostSignificantScales = (uint16_T *)mxGetData(prhs[3]);
    minContrast = mxGetPr(prhs[4])[0];
    integralX = mxGetPr(prhs[5]);
    integralXWidth = mxGetPr(prhs[6])[0];
    widthMap = mxGetPr(prhs[7]);
    moleculeWidths = mxGetPr(prhs[8]);
    heightMap = mxGetPr(prhs[9]);

    nIntegralX = mxGetNumberOfElements(prhs[5]);
    
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
                integralHelp = (WM(r,c)/MolW(po,s))*integralXWidth/(2.0*(double)nIntegralX);
                if(integralHelp > 0.5) integralHelp = 0.5;
                FM(r,c) += fsign(HM(r,c))*fsign(IX(0.5+integralHelp)-IX(0.5-integralHelp))*CS1(r,c,po,s);
                FM(r,c) -= (CS2(r,c,po,s) + minContrast*fabs(IX(0.5+integralHelp)-IX(0.5-integralHelp)));
                normalizationFactor += fmax(fabs(CS1(r,c,po,s)),fabs(HM(r,c)*(IX(0.5+integralHelp)-IX(0.5-integralHelp))));
            }
            FM(r,c) = fmax(0.0,FM(r,c))/normalizationFactor;
        }
    }
}

/*Written by Rafael Reisenhofer

 Part of SymFD Toolbox v 1.0
 Built on September 3, 2018
 Published under the MIT License*/
