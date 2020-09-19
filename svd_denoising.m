function [X_denoised] = svd_denoising(X,Modes)
dims=size(X);

X=X-repmat(mean(X,1),[dims(1) ones(1,length(dims)-1)]);
%Reshapes X
X=reshape(X,dims(1),prod(dims(2:end)));
%Performs SVD
[U, S, V]=svd(X.','econ');
%Compresses X
X_denoised=U(:,Modes)*S(Modes,Modes)*V(:,Modes).';
X_denoised=X_denoised.';
%Reshapes X_denoised back
X_denoised=reshape(X_denoised,dims);
