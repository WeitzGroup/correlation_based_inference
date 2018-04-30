function R = read_elsa(s, n)

load('elsa/analysis_setup');

head_format = repmat('%s',1,27);
row_format = ['%s %s' repmat(' %f',1,25)];

% read data from individual eLSA .txt files
R = zeros(N(n),N(n),NQ); % matrix of LS scores
delays = zeros(N(n),N(n),NQ); % matrix of delay indices (V_start_index - H_start_index)
sample_lengths = zeros(N(n),N(n),NQ); % matrix of sample lengths
NR = (2*N(n))*(2*N(n)-1)/2; % number of LS scores computed
for q = 1:NQ
    filename = sprintf('elsa/output/S%d_N%d_Q%02d.txt',s,N(n),q);
    fileID = fopen(filename,'r');
    Vs = textscan(fileID,head_format,1);
    V = textscan(fileID,row_format,NR);
    fclose(fileID);

    % put LS scores into bipartite matrix
    tmpR = zeros(2*N(n),2*N(n),3);
    for k = 1:NR
        tmpi = V{end-1}(k);                    % X index
        tmpj = V{end}(k);                      % Y index
        tmpR(tmpi,tmpj,1) = V{3}(k);           % LS score
        tmpR(tmpi,tmpj,2) = V{7}(k)-V{6}(k);   % delay index
        tmpR(tmpi,tmpj,3) = V{8}(k);           % sample length
    end
    R(:,:,q) = tmpR(1:N(n),(N(n)+1):end,1);
    delays(:,:,q) = tmpR(1:N(n),(N(n)+1):end,2);
    sample_lengths(:,:,q) = tmpR(1:N(n),(N(n)+1):end,3);

end

end