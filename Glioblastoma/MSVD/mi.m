function [MI] = ent(I,J)

% takes two images I and J and returns the joint entropy,
% mutual information and the individual entropies
%
% NOTE: images must be scaled from 0 to 255 (uint8)
%
% I is image 1
% J is image 2

% error check
if any(size(I)~=size(J))
error('Images must be same size')
end
if max(max(I))>255 | max(max(J))>255
error('Images not scaled correctly')
end
% if min(min(I))<0 | min(min(J))<0
% error('Images contain negative values')
% end

% convert to uint8 (256 grey scales)
I = uint8(I);
J = uint8(J);

% joint histogram
H = zeros(256);
for k = 1:numel(I)
  H(I(k)+1,J(k)+1) = H(I(k)+1,J(k)+1)+1;
end
H = H/sum(sum(H));
nz = find(H);
JE = -sum(H(nz).*(log2(H(nz))));

% entropy of the images
p = sum(H,1);
nz = find(p);
EJ = -sum(p(nz).*(log2(p(nz))));
p = sum(H,2);
nz = find(p);
EI = -sum(p(nz).*(log2(p(nz))));

% mutual information
MI = entropy(I)+entropy(J)-JE;