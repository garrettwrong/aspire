
%Input:  rots_grid=rotations grid from which common lines table was
%        generated
%        lin_idx=linear indexes of common lines estimates from search
%        table
%Output: Rijs_est=The actual relative rotations matching to estimated
%        common lines

function [Rijs_est]=getRijsFromLinIdxOct1(lookup_data,lin_idx)

ntheta=lookup_data.ntheta;
n_lookup_pairs=lookup_data.npairs;
%npairs=nchoosek(nrot,2);
nrot=lookup_data.nrot;

inplane_rotated_grid=lookup_data.inplane_rotated_grid;
[inplane_j,inplane_i,p_idx]=...
    ind2sub([0.5*ntheta,ntheta,2*n_lookup_pairs],lin_idx);
%lin2ij_table=lin2sub_map(nrot);
transpose_idx=p_idx>n_lookup_pairs;
p_idx(transpose_idx)=p_idx(transpose_idx)-n_lookup_pairs;
s=size(inplane_rotated_grid);
inplane_rotated_grid=reshape(inplane_rotated_grid,[3,3,prod(s(3:4))]);

npairs=length(lin_idx);
Rijs_est=zeros(3,3,4,npairs);

%% Convert linear idx of unique table to linear idx of full table
unique_pairs=lookup_data.unique_pairs';
one2n=1:numel(unique_pairs);
unique_lin_idx=one2n(unique_pairs(:));
[J,I]=ind2sub([nrot,nrot],unique_lin_idx);
est_idx=[I(p_idx)',J(p_idx)'];
clearvars I J

%%
Ris_lin_idx=sub2ind(s(3:4),inplane_i,est_idx(:,1));
Rjs_lin_idx=sub2ind(s(3:4),inplane_j,est_idx(:,2));
Ris=inplane_rotated_grid(:,:,Ris_lin_idx);
Rjs=inplane_rotated_grid(:,:,Rjs_lin_idx);

Ris=permute(Ris,[2,1,3]);
Rijs_est(:,:,1,:)=multiprod(Ris,Rjs);

gRjs=Rjs;
gRjs(2:3,:,:)=-gRjs(2:3,:,:);
Rijs_est(:,:,2,:)=multiprod(Ris,gRjs);

gRjs=Rjs;
gRjs([1,3],:,:)=-gRjs([1,3],:,:);
Rijs_est(:,:,3,:)=multiprod(Ris,gRjs);

gRjs=Rjs;
gRjs(1:2,:,:)=-gRjs(1:2,:,:);
Rijs_est(:,:,4,:)=multiprod(Ris,gRjs);

Rijs_est(:,:,:,transpose_idx)=permute(Rijs_est(:,:,:,transpose_idx),[2,1,3,4]);
