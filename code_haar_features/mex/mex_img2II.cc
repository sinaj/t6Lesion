/* mex_img2II
   
  Description:
    This function computes the integral image (II) over the input image (img).
    
  Input:
    prhs[0] <- image (img)

  Output:
    plhs[0] -> integral image (II)
   
  Contact:   
    Michael Villamizar
    mvillami@iri.upc.edu
    Institut de Robòtica i Informàtica Industrial CSIC-UPC
    Barcelona - Spain
    2014

*/

#include <math.h>
#include "mex.h"
#include <stdio.h>

// main function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) { 

  // check
  if(nrhs!=1) 
    mexErrMsgTxt("One input required: input image (img)");
  if(nlhs!=1) 
    mexErrMsgTxt("One output required: integral image (II)");

  // input image
  double *img = (double *)mxGetPr(prhs[0]);  // image data
  const int *imgSize = mxGetDimensions(prhs[0]);  // image dimensions

  // image size
  int sy = imgSize[0];
  int sx = imgSize[1];

  // num. image dimensions
  int nd = mxGetNumberOfDimensions(prhs[0]);
  
  // num. image channels
  int nc = 1;  // gray-scale image
  if (nd==3){ nc = imgSize[2];}  // color image
 
  // output data: integral image
  int out[3] = {sy,sx,nc}; 
  plhs[0] = mxCreateNumericArray(3, out, mxDOUBLE_CLASS, mxREAL);
  double *II = (double *)mxGetPr(plhs[0]);
  
  // variables
  double value,xo,yo,xoyo;
  
  // integral image computation -recursive computation-
  for (int c=0; c<nc; c++) {
    for (int x=0; x<sx; x++) {
      for (int y=0; y<sy; y++) {
      
        // pixel intensity value at (x,y,c)
        value = *(img + y + x*sy + c*sy*sx);

        // previous integral image values
        if (x>0) {
          if (y>0) {
            xo = *(II + y + (x-1)*sy + c*sy*sx);
            yo = *(II + (y-1) + x*sy + c*sy*sx);
            xoyo = *(II + (y-1) + (x-1)*sy + c*sy*sx);
          } 
          else {
            xo = *(II + y + (x-1)*sy + c*sy*sx);
            yo = 0;
            xoyo = 0;
          }
        }
        else {
          if(y>0) {
            xo = 0;
            yo = *(II + (y-1) + x*sy + c*sy*sx);
            xoyo = 0;
          }     
          else {
            xo = 0;
            yo = 0;
            xoyo = 0;
          }
        }

        // integral image value at (x,y,c)
        *(II + y + x*sy + c*sy*sx) = value - xoyo + xo + yo;
  
      }
    }
  }
}

