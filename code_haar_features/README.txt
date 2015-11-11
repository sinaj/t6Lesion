 Haar-like Features
 
 Description:
   This program computes Haar-like features over a given input image (img) in 
   order to extract contours. The Haar-like features are used as local derivative 
   operators. Particularly, the program computes horizontal (Hx) and vertical (Hy) 
   oriented features (Haar-like features) using the integral image (II) of the 
   input image (img). This initial pre-processing step is done in advance using a 
   mex file (mex_img2II.cc). 

   If you make use of this code for research articles, we kindly encourage
   to cite the reference [1], listed below. This code is only for research
   and educational purposes.

 Steps:
   Steps to exucute the program:
     1. Run the prg_setup.m file to configure the program paths and compile the mex 
        files.
     2. Run the prg_haar_features.m file to compute the Haar-like features and to 
        extract edges in the input image. 

 References:
    [1] Computation of Rotation Local Invariant Features Using the Integral Image 
        for Real Time Object Detection
        M. Villamizar, A. Sanfeliu and J. Andrade-Cetto
        International Conference on Pattern Recognition (ICPR), 2006.

 Contact:
   Michael Villamizar
   mvillami-at-iri.upc.edu
   Institut de Robòtica i Informática Industrial CSIC-UPC
   Barcelona - Spain
   2014

