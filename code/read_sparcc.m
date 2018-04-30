function R = read_sparcc(s, n)

load('sparcc/analysis_setup');

R = zeros(N(n),N(n),NQ); % matrix of SparCC scores
NR = 2*N(n); % number of SparCC scores computed

% read data from individual SparCC .txt files
row_format = ['%*d' repmat(' %f',1,NR)];
for q = 1:NQ
    filename = sprintf('sparcc/output/S%d_N%d_Q%02d.txt',s,N(n),q);
    fileID = fopen(filename,'r');
    fgetl(fileID); % skip header row
    tmpR = fscanf(fileID,row_format,[NR,NR]);
    fclose(fileID);
    R(:,:,q) = tmpR(1:N(n),(N(n)+1):end); % only keep host-virus part
end

end