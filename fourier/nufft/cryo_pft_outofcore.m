function freqs=cryo_pft_outofcore(instack,outstack,n_r,n_theta)
%
% Compute the polar Fourier transform of projections with resolution n_r in
% the radial direction and resolution n_theta in the angular direction.
%
% Input parameters:
%   instack    Name of MRC file containing the projections to transform.
%              Images must be real-valued.
%   outstack   Name of MRC file with Fourier transforms of the projections
%              (complex-valued). Use imagestackReaderComplex to read this
%              file.
%   n_r        Number of samples along each ray (in the radial direction).
%   n_theta    Angular resolution. Number of Fourier rays computed for each
%              projection.
%   precision  'single' or 'double'. Default is 'single'. The polar Fourier
%              samples for 'single' are computed to accuracy of 1.e-6.
%
% Output parameters:
%   freqs   Frequencies at which the polar Fourier samples were computed. A
%           matrix with n_rxn_theta rows and two columns (omega_x and
%           omega_y).
%          
% Yoel Shkolnisky, April 2017.

% NOTE: Only sigle precision is supported.
precision='single';

   
%n_uv=size(p,1);
omega0=2*pi/(2*n_r-1);
dtheta=2*pi/n_theta;

freqs=zeros(n_r*n_theta,2); % sampling points in the Fourier domain
for j=1:n_theta
    for k=1:n_r
        freqs((j-1)*n_r+k,:)=[(k-1)*omega0*sin((j-1)*dtheta),...
            (k-1)*omega0*cos((j-1)*dtheta)];
    end
end

%   freqs is the frequencies on [-pi,pi]x[-pi,pi] on which we sample the
%   Fourier transform of the projections. An array of size n_r*n_theta by 2
%   where each row corresponds to a frequnecy at which we sample the
%   Fourier transform of the projections. The first column is omega_x, the
%   second is omega_y. 

in=imagestackReader(instack);
% precomputed interpolation weights once for the give polar grid. This is
% used below for computing the polar Fourier transform of all slices
n=in.dim(1);
n_proj=in.dim(3);
precomp=nufft_t_2d_prepare(freqs,n,precision);

pf=imagestackWriterComplex(outstack,n_proj);
for k=1:n_proj
    tmp=in.getImage(k);
%    tmp=(2/n_uv)^2*nufft_t_v3(tmp,precomp);    
    tmp=nufft_t_2d_execute(tmp,precomp);    
    pf.append(reshape(tmp,n_r,n_theta));   
end
pf.close;