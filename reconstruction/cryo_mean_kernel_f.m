% CRYO_MEAN_KERNEL_F Calculate convolution kernel for mean volume
%
% Usage
%    mean_kernel_f = cryo_mean_kernel_f(L, params, mean_est_opt);
%
% Input
%    L: The resolution of the volumes and images. That is, the images are
%       expected to be of size L-by-L while the volumes as L-by-L-by-L.
%    params: An imaging parameters structure containing the fields:
%          - rot_matrices: A 3-by-3-by-n array containing the rotation
%             matrices of the various projections.
%          - ctf: An L-by-L-by-K array of CTF images (centered Fourier
%             transforms of the point spread functions of the images)
%             containing the CTFs used to generate the images.
%          - ctf_idx: A vector of length n containing the indices in the
%             `ctf` array corresponding to each projection image.
%          - ampl: A vector of length n specifying the amplitude multiplier
%             of each image.
%    mean_est_opt: A struct containing the fields:
%          - 'precision': The precision of the kernel. Either 'double'
%             (default) or 'single'.
%
% Output
%    mean_kernel_f: A 2*L-by-2*L-by-2*L array containing the centered Fourier
%       transform of the mean reconstruction kernel. Convolving a volume with
%       this kernel is equal to projecting and backprojecting that volume in
%       each of the projection directions (with the appropriate amplitude
%       multipliers and CTFs) and averaging over the whole dataset.

function mean_kernel_f = cryo_mean_kernel_f(L, params, mean_est_opt)
    if nargin < 3 || isempty(mean_est_opt)
        mean_est_opt = struct();
    end

    check_imaging_params(params, L, []);

    n = size(params.rot_matrices, 3);

    mean_est_opt = fill_struct(mean_est_opt, ...
        'precision', 'double');

    pts_rot = rotated_grids(L, params.rot_matrices);

    filter = abs(params.ctf(:,:,params.ctf_idx)).^2;

    filter = bsxfun(@times, filter, reshape(params.ampl.^2, [1 1 n]));

    if mod(L, 2) == 0
        pts_rot = pts_rot(:,2:end,2:end,:);

        filter = filter(2:end,2:end,:);
    end

    filter = im_to_vec(filter);

    % Reshape inputs into appropriate sizes and apply adjoint NUFFT.
    pts_rot = reshape(pts_rot, 3, []);
    filter = reshape(filter, [], 1);

    mean_kernel = 1/n*(1/L)^2*(2/L)^2*anufft3(filter, pts_rot, ...
        2*L*ones(1, 3));

    % Ensure symmetric kernel
    mean_kernel(1,:,:) = 0;
    mean_kernel(:,1,:) = 0;
    mean_kernel(:,:,1) = 0;

    % Take the Fourier transform since this is what we want to use when
    % convolving.
    mean_kernel = ifftshift(ifftshift(ifftshift(mean_kernel, 1), 2), 3);
    mean_kernel_f = fftn(mean_kernel);
    mean_kernel_f = fftshift(fftshift(fftshift(mean_kernel_f, 1), 2), 3);

    mean_kernel_f = real(mean_kernel_f);
end