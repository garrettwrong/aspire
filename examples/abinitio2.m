% Basic abinitio reconstruction - example 2.
%
% The script demonstrates calling various functions of the aspire package.
%
% Follow comments below.
%
% Yoel Shkolnisky, September 2013.

clear;

%% Generate simulated projections
% Generate 200 simulated projections of size 65x65.
% For simplicity, the projections are centered.
n=65;
K=200;
SNR=1/4;
%SNR=1000; % No noise
[projs,noisy_projs,~,refq]=cryo_gen_projections(n,K,SNR);
viewstack(noisy_projs,5,5) % Show some noisy projections

masked_projs=mask_fuzzy(noisy_projs,33); % Applly circular mask
viewstack(masked_projs,5,5) % Show some noisy projections

% Compute polar Fourier transform, using radial resolution n_r and angular
% resolution n_theta. n_theta is the same as above.
n_theta=360;
n_r=65;
[npf,sampling_freqs]=cryo_pft(masked_projs,n_r,n_theta,'single');  % take Fourier transform of projections   

% Find common lines from projections
max_shift=0;
shift_step=1;
clstack = commonlines_gaussian(npf,max_shift,shift_step);

% Find reference common lines and compare
[ref_clstack,~]=clmatrix_cheat_q(refq,n_theta);
prop=comparecl( clstack, ref_clstack, n_theta, 10 );
fprintf('Percentage of correct common lines: %f%%\n\n',prop*100);

%% Estimate orientations using sychronization.
 
S=cryo_syncmatrix_vote(clstack,n_theta);
[rotations,diff,mse]=cryo_syncrotations(S,refq);
fprintf('MSE of the estimated rotations: %f\n\n',mse);
%fprintf('MSE of the estimated rotations: %f\n\n',check_MSE(rotations,refq));


%% 3D inversion
params = struct();
params.rot_matrices = rotations;
params.ctf = ones(size(noisy_projs, 1)*ones(1, 2));
params.ctf_idx = ones(size(noisy_projs, 3), 1);
params.shifts = zeros(2, size(noisy_projs, 3));
params.ampl = ones(size(noisy_projs, 3), 1);

basis = dirac_basis(size(noisy_projs, 1)*ones(1, 3));

v = cryo_estimate_mean(noisy_projs, params, basis);

WriteMRC(v,1,'example2.mrc'); % Output density map reconstructed from projections.
