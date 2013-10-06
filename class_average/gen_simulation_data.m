%gen_simulation_data
%Generate 10^4 clean projection images from 70S ribosome volume (in ./simulation/volume.mat). Image size
%is 129x129 pixels.

K = 10000; %K is the number of images
max_shift = 4; %maximum shift range
step_size = 1;
initstate;
q = qrand(K);
shifts=round((rand(K,2)-1/2)*2*max_shift/step_size)*step_size;
load volume.mat
projections=cryo_project(vol,q);
save('/simulation/clean_data', '-v7.3', 'projections', 'q', 'shifts')
clear all;


