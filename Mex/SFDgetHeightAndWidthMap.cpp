#include "mex.h"
#include "tmwtypes.h"
#include <cmath>

#if NAN_EQUALS_ZERO
#define IsNonZero(d) ((d)!=0.0 || mxIsNaN(d))
#else
#define IsNonZero(d) ((d)!=0.0)
#endif

#define CS1(a,b,c,d) coeffsSymmetry1[(a-1) + (b-1)*nRows + (c-1)*nRows*nCols + (d-1)*nRows*nCols*nOris] //symmetry1 coefficients
#define PO(a,b) mostSignificantOris[(a-1) + (b-1)*nRows] //mostSignificant orientations
#define PS(a,b) mostSignificantScales[(a-1) + (b-1)*nRows] //mostSignificant scales
#define HM(a,b) heightMap[(a-1) + (b-1)*nRows] //height map
#define WM(a,b) widthMap[(a-1) + (b-1)*nRows] //width map (row,col)
#define INT(a) integral[(uint16_T)((double)(a)*(double)(nIntegral-1))] //integral
#define MolW(a,b) moleculeWidths[(a-1) + (b-1)*nOris] //width map (ori,scale)

double fmax(double a, double b){
    return a > b ? a : b;
}
double fmin(double a, double b){
    return a < b ? a : b;
}
// double fabs(double a){
//     return a > 0.0 ? a : -a;
// }

                  
//[heightMap,widthMap] = CMFDgetHeightAndWidthMap(coeffsSym1,mostSignificantOris,mostSignificantScales,integral,integralReferenceWidth,moleculeWidths,feature)
//feature: 1 = edges, 2 = ridges, 3 = blobs
void mexFunction(int nlhs,       mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
    const mwSize * dimsCoeffs;
    uint16_T nOris,nScales,nRows,nCols;
    uint16_T nIntegral;
    uint16_T r,c,po,s,ps;
    uint16_T * mostSignificantOris, * mostSignificantScales;
    uint16_T feature;
    double * coeffsSymmetry1;
    double * integral;
    double * widthMap;
    double * heightMap;
    double * moleculeWidths;
    double integralReferenceWidth; 
    double integralHelp;
    double mostSignificantCoeff,mostSignificantFactor,leftCoeff,rightCoeff;

    if (nrhs != 7) {
        mexErrMsgTxt("Seven input arguments required.");
    } 
    // read input   
    coeffsSymmetry1 = mxGetPr(prhs[0]);
    mostSignificantOris = (uint16_T *)mxGetData(prhs[1]);
    mostSignificantScales = (uint16_T *)mxGetData(prhs[2]);
    integral = mxGetPr(prhs[3]);
    integralReferenceWidth = mxGetPr(prhs[4])[0];
    moleculeWidths = mxGetPr(prhs[5]);    
    feature = ((uint16_T*)mxGetData(prhs[6]))[0];

    
    nIntegral = mxGetNumberOfElements(prhs[3]);

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
    plhs[1] = mxCreateDoubleMatrix(nRows,nCols,mxREAL);    
    
    heightMap = mxGetPr(plhs[0]);    
    widthMap = mxGetPr(plhs[1]);    
       
    for(r = 1; r <= nRows;r++){        
        for(c = 1;c <= nCols;c++){
            // compute scale coefficient
            ps = PS(r,c);
            po = PO(r,c);
            mostSignificantCoeff = CS1(r,c,po,ps);
            if(ps == 1 || ps == nScales){
                WM(r,c) = ps;
            }else{                
                leftCoeff = fabs(CS1(r,c,po,ps-1));
                rightCoeff = fabs(CS1(r,c,po,ps+1));
                WM(r,c) = ps + (rightCoeff - leftCoeff)/(4*fabs(mostSignificantCoeff) - 2*(rightCoeff + leftCoeff));
            }    
            //compute width
            WM(r,c) = pow((MolW(1,1)/MolW(1,2)),ps-WM(r,c))*MolW(po,ps);
            //compute height
            if(feature == 1){
                HM(r,c) = (mostSignificantCoeff/integral[0]); //edges
            }else{
                integralHelp = (WM(r,c)/MolW(po,ps))*integralReferenceWidth/(2.0*(double)nIntegral);
                if(feature == 3){
                    HM(r,c) = mostSignificantCoeff/INT(integralHelp); //blobs
                }else{
                    HM(r,c) = mostSignificantCoeff/(INT(0.5+integralHelp) - INT(0.5-integralHelp)); //ridges
                }
            }
        }
    }
}

/*Written by Rafael Reisenhofer

 Part of SymFD Toolbox v 1.0
 Built on September 3, 2018
 Published under the MIT License*/
