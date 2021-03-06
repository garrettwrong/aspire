% Take a centered volume/image, shift it (by integral and non-integral
% shifts), and center back according to the center of mass.
% The resulting object is verified to be perfectly centered.
% Tests both even and odd sized volume/image.
%
% Yoel Shkolnisky, November 2014.
 

fprintf('Alignment estimation errors\n');

%% Odd sized test
clear;
voldef='one_ball';  % A simple centered phantom.
n=65;               % Size of the volume.
rmax=1;              % The volume is generated by sampling the phantom on 
                     % a 3D Cartesian grid where each dimension has n
                     % samples on [-rmax,rmax]
vol=cryo_gaussian_phantom_3d(voldef,n,rmax);  % Generate the nxnxn volume.

vol_shifted=reshift_vol(vol,[1 1 1]); % Shift by integral step
cmv=CenterOfMass(vol_shifted);
vol_aligned=reshift_vol(vol_shifted,cmv);
cmv_aligned=CenterOfMass(vol_aligned);
assert(norm(cmv_aligned)<1.0e-13); % Error should be tiny 
fprintf('\t Odd volume %6.4e\n',norm(cmv_aligned));


vol_shifted=reshift_vol(vol,[1.25 1.25 1.25]); % Shift by NON-integral step
cmv=CenterOfMass(vol_shifted);
vol_aligned=reshift_vol(vol_shifted,cmv);
cmv_aligned=CenterOfMass(vol_aligned);
assert(norm(cmv_aligned)<1.0e-13) 
fprintf('\t Odd volume %6.4e\n',norm(cmv_aligned));


proj=sum(vol,3);
proj_shifted=reshift_image(proj,[1 1]); % Shift by integral step
cmp=CenterOfMass(proj_shifted);
proj_aligned=reshift_image(proj_shifted,cmp);
cmp_aligned=CenterOfMass(proj_aligned);
assert(norm(cmp_aligned)<1.0e-13); % Error should be tiny 
fprintf('\t Odd image %6.4e\n',norm(cmv_aligned));


proj_shifted=reshift_image(proj,[1.25 1.25]); % Shift by NON-integral step
cmp=CenterOfMass(proj_shifted);
proj_aligned=reshift_image(proj_shifted,cmp);
cmp_aligned=CenterOfMass(proj_aligned);
assert(norm(cmp_aligned)<1.0e-13); % Error should be tiny 
fprintf('\t Odd image %6.4e\n',norm(cmv_aligned));

%% Even sized test
clear;
voldef='one_ball';  % A simple centered phantom.
n=64;               % Size of the volume.
rmax=1;              % The volume is generated by sampling the phantom on 
                     % a 3D Cartesian grid where each dimension has n
                     % samples on [-rmax,rmax]
vol=cryo_gaussian_phantom_3d(voldef,n,rmax);  % Generate the nxnxn volume.

vol_shifted=reshift_vol(vol,[1 1 1]); % Shift by integral step
cmv=CenterOfMass(vol_shifted);
vol_aligned=reshift_vol(vol_shifted,cmv);
cmv_aligned=CenterOfMass(vol_aligned);
assert(norm(cmv_aligned)<1.0e-13); % Error should be tiny 
fprintf('\t Even volume %6.4e\n',norm(cmv_aligned));


vol_shifted=reshift_vol(vol,[1.25 1.25 1.25]); % Shift by NON-integral step
cmv=CenterOfMass(vol_shifted);
vol_aligned=reshift_vol(vol_shifted,cmv);
cmv_aligned=CenterOfMass(vol_aligned);
assert(norm(cmv_aligned)<1.0e-13) 
fprintf('\t Even volume %6.4e\n',norm(cmv_aligned));


proj=sum(vol,3);
proj_shifted=reshift_image(proj,[1 1]); % Shift by integral step
cmp=CenterOfMass(proj_shifted);
proj_aligned=reshift_image(proj_shifted,cmp);
cmp_aligned=CenterOfMass(proj_aligned);
assert(norm(cmp_aligned)<1.0e-13); % Error should be tiny 
fprintf('\t Even image %6.4e\n',norm(cmv_aligned));


proj_shifted=reshift_image(proj,[1.25 1.25]); % Shift by NON-integral step
cmp=CenterOfMass(proj_shifted);
proj_aligned=reshift_image(proj_shifted,cmp);
cmp_aligned=CenterOfMass(proj_aligned);
assert(norm(cmp_aligned)<1.0e-13); % Error should be tiny 
fprintf('\t Even image %6.4e\n',norm(cmv_aligned));

%% Print OK.
fprintf('Test OK\n'); % No assertions have been violated.