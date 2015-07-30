% Test the function recenter
%
% Generate an image, center it, and compare the estimated shift to the true
% one.
% Yoel Shkolnisky, November 2014

clear;
voldef='one_ball';  % A simple centered phantom.
n=65;               % Size of the volume. Can be odd or even.
rmax=1;              % The volume is generated by sampling the phantom on 
                     % a 3D Cartesian grid where each dimension has n
                     % samples on [-rmax,rmax]
vol=cryo_gaussian_phantom_3d(voldef,n,rmax);  % Generate the nxnxn volume.
proj=sum(vol,3);

shift=[2.1 2.1];
proj_shifted=reshift_image(proj,shift); % Shift by NON-integral step

[proj_aligned,cm]=recenter(proj_shifted);

assert(norm(shift+cm)<1.0e-13);
err=norm(proj(:)-proj_aligned(:))/norm(proj(:));
assert(err<1.0e-14);
fprintf('True shift [%6.4e %6.4e]\n',shift(1),shift(2));
fprintf('Est shift [%6.4e %6.4e]\n',-cm(1),-cm(2));
fprintf('Volumes discrepancy %6.4e\n',err);