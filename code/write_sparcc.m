function write_sparcc(sH, sV, s)

[NS, N, NQ] = size(sH);

% sparcc works on compositional data -- normalize each sampled timepoint
sH = sH./repmat(sum(sH,2),[1 N 1]);
sV = sV./repmat(sum(sV,2),[1 N 1]);

% write each time-series to an individual .txt file
head_format = ['OTU_id' repmat('\t%d',1,NS) '\n'];
row_format = @(i) [sprintf('%d',i) repmat('\t%f',1,NS) '\n'];
for q = 1:NQ
    filename = sprintf('sparcc/input/S%d_N%d_Q%02d.txt',s,N,q);
    fileID = fopen(filename,'w');
    fprintf(fileID,head_format,1:NS);
    for i = 1:N
        fprintf(fileID,row_format(i),sH(1:NS,i,q)');
    end
    for i = 1:N
        fprintf(fileID,row_format(i+N),sV(1:NS,i,q)');
    end
    fclose(fileID);
end

end
