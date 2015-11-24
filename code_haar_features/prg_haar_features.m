%% Haar-like Features
% 
% Description:
%   This program computes Haar-like features over a given input image (img) in 
%   order to extract contours. The Haar-like features are used as local derivative 
%   operators. Particularly, the program computes horizontal (Hx) and vertical (Hy) 
%   oriented features (Haar-like features) using the integral image (II) of the 
%   input image (img). This initial pre-processing step is done in advance using a 
%   mex file (mex_img2II.cc). 
%
%   If you make use of this code for research articles, we kindly encourage
%   to cite the reference [1], listed below. This code is only for research
%   and educational purposes.
%
% References:
%    [1] Computation of Rotation Local Invariant Features Using the Integral Image 
%        for Real Time Object Detection
%        M. Villamizar, A. Sanfeliu and J. Andrade-Cetto
%        International Conference on Pattern Recognition (ICPR), 2006.
%
% Contact:
%   Michael Villamizar
%   mvillami-at-iri.upc.edu
%   Institut de Robòtica i Informática Industrial CSIC-UPC
%   Barcelona - Spain
%   2014
%

%% Main function
function [Hx, Hy, mag] = prg_haar_features(img)
%clc,close all,clear all

% message
fun_messages('Haar-like Features','presentation');
fun_messages('Haar-like Features','title');

% parameters
hs = 6;  % Haar filter size (integer and even)
fs = 6;  % font size
%imgPath = './images/window.jpg';  % image file path
%imgPath = './images/kio_tower.jpg';  % image file path

% check filter size
if (mod(hs,2)~=0), fun_messages('the filter size must be even and integer','error'); end

% input image
%img = imread(imgPath);

% image size
[sy,sx,nc] = size(img);

% message
fun_messages('input image:','process');
fun_messages(sprintf('image size -> [%d x %d]',sy,sx),'information');
fun_messages(sprintf('num.channels -> %d',nc),'information');

% show image
%figure,imshow(img),title('Input Image','fontsize',fs),xlabel(sprintf('Size -> [%d x %d]',sy,sx),'fontsize',fs);

% convert to gray-scale image
if (nc==3), img = rgb2gray(img); end

% compute the integral image over the input image: img->II
tic; II = mex_img2II(double(img)); t1 = toc;

% compute the Haar-like features in the integral image (II)
tic; [Hx,Hy] = mex_haar_features(II,hs); t2 = toc;

% gradient magnitud: the Haar-like features are used as local 
% derivative operators
mag = sqrt(Hx.^2 + Hy.^2);

% messages
fun_messages('times:','process');
fun_messages(sprintf('img -> II : %.5f [sec.]',t1),'information');
fun_messages(sprintf('II -> {Hx,Hy} : %.5f [sec.]',t2),'information');

% show image
% figure,subplot(131),imagesc(Hx),colormap(gray),xlabel('Hx','fontsize',fs);
% subplot(132),imagesc(Hy),colormap(gray),xlabel('Hy','fontsize',fs);
% subplot(133),imagesc(mag),colormap(gray),xlabel('Magnitude','fontsize',fs);
% figure,imagesc(mag),colormap(hot),xlabel('Magnitude','fontsize',fs);

% message
fun_messages('end','title');

end

%% messages
% This function prints a specific message on the command window
function fun_messages(text,message)
return;
if (nargin~=2), error('incorrect input parameters'); end

% types of messages
switch (message)
    case 'presentation'
        fprintf('****************************************************\n');
        fprintf(' %s\n',text);
        fprintf('****************************************************\n');
        fprintf(' Michael Villamizar\n mvillami@iri.upc.edu\n');
        fprintf(' http://www.iri.upc.edu/people/mvillami/\n');
        fprintf(' Institut de Robòtica i Informàtica Industrial CSIC-UPC\n');
        fprintf(' c. Llorens i Artigas 4-6\n 08028 - Barcelona - Spain\n 2014\n');
        fprintf('****************************************************\n\n');
    case 'title'
        fprintf('****************************************************\n');
        fprintf('%s\n',text);
        fprintf('****************************************************\n');
    case 'process'
        fprintf('-> %s\n',text);
    case 'information'
        fprintf('->     %s\n',text);
    case 'warning'
        fprintf('-> %s !!!\n',text);
    case 'error'
        fprintf(':$ ERROR : %s\n',text);
        error('program error');
end
end

