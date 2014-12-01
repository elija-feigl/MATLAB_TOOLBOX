function imageData = load_gel_image(varargin)
%% Loads image, fits lanes according to step function convolved with gaussian
%   INPUTS: 
%   'data_dir' (optional parameter) = initial directory, where data is
%   stored
%   OUTPUT:
%   imageData struct with .images .pathnames .filenames .nrImages
%   .nrImages is number of images
%   .images is cell array {nr_image} of image data
%   .pathnames is cell array {nr_image} of pathnames to each image
%   .filenames is cell array {nr_image} of filenames of each image
%
% Example: myImageData = load_gel_image('data_dir', '~/Documents/Images');

%% parse input
p = inputParser;
default_data_dir = userpath; % default data directory is userpath
default_data_dir=default_data_dir(1:end-1);
addParameter(p,'data_dir',default_data_dir, @isstr); 

parse(p,  varargin{:});    
data_dir = p.Results.data_dir;  % default data location

%% select image data
init_path = cd; %remember initial/current path
temp = inputdlg({'How many images (channels) do you want to load:'}, 'How many images (channels) do you want to load?', 1, {'1'});
nrImages = str2double(temp(1));

filenames = cell(nrImages, 1);
pathnames = cell(nrImages, 1);

lastDirectory = data_dir;
for i=1:nrImages
    cd(lastDirectory)
    [filenames{i}, pathnames{i}]=uigetfile('*.tif','Select image:');
    lastDirectory = pathnames{i};
end
cd(init_path) % cd to initial directory

%% load image data
images = cell(nrImages, 1);

for i=1:nrImages
    images{i} = double(imread([pathnames{i} filesep filenames{i}]));             %load image data  
end

%% create imageData structure, return imageData structure

imageData=struct('images',{images},'pathnames',{pathnames},'filenames',{filenames},'nrImages',nrImages);