function A0 = index3D(A, ID)
% Grabs entries from A (3D) indexed by ID (2D).
% A is a 3D array with dims nx by ny by nz.
% ID is a 2D array with dims nx by ny, and contains integers within [1 nz].

nx = size(A,1);
ny = size(A,2);
A0 = zeros(nx,ny);

for i = 1:nx
    for j = 1:ny
        A0(i,j) = A(i,j,ID(i,j));
    end
end

end
