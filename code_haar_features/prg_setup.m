%% Setup
% 
% Description:
%   This function adds the program paths and compiles the mex files.
%
% Contact:
%   Michael Villamizar
%   mvillami-at-iri.upc.edu
%   Institut de Robòtica i Informática Industrial CSIC-UPC
%   Barcelona - Spain
%   2014
%

%% Main function
function prg_setup()
% clc,close all,clear all

% message
fun_messages('Program Setup','presentation');
fun_messages('Setup','title');

% root path
fun_messages('adding program paths','process');
[root,~,~] = fileparts(mfilename('fullpath'));

% add paths: root and mex files
fun_messages('adding root path','information');
addpath(root);
fun_messages('adding mex files path','information');
addpath(fullfile(root,'/mex'));

% root path
cd(root);

% compile mex files
fun_messages('compiling mex files','process');
cd('./mex/');
fun_messages('compiling mex_img2II.cc','information');
mex mex_img2II.cc;
fun_messages('compiling mex_haar_features.cc','information');
mex mex_haar_features.cc;
cd('../../');

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

