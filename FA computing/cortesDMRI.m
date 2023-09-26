function cortesDMRI(V,escala)
if(nargin<2)
    escala = [];
else
    if(isempty(escala))
        escala = quantile(V(:),[0.025,0.975]);
    end
end
%z   = [3,9,14];
z = 1:3;
IMG = [V(:,:,z(1))',V(:,:,z(2))',V(:,:,z(3))'];
imshow(IMG,escala);
end