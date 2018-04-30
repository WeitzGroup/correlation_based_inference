function write_elsa(sH, sV, s)

[NS, N, NQ] = size(sH);

% write each time-series to an individual .txt file
head_format = ['#F/T' repmat('\tt%d',1,NS) '\n'];
row_format = @(A,i) [sprintf('%s%d',A,i) repmat('\t%f',1,NS) '\n'];
for q = 1:NQ
    filename = sprintf('elsa/input/S%d_N%d_Q%02d.txt',s,N,q);
    fileID = fopen(filename,'w');
    fprintf(fileID,head_format,1:NS);
    for i = 1:N
        fprintf(fileID,row_format('H',i),sH(1:NS,i,q)');
    end
    for i = 1:N
        fprintf(fileID,row_format('V',i),sV(1:NS,i,q)');
    end
    fclose(fileID);
end

end