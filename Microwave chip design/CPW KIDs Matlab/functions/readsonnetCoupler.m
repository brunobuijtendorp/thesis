function Qdesign = readsonnetCoupler(file, psort, numparam, numheaders)
    % readsonnetCoupler
    %reads coupler sim and outputs the standard matrix needed for my script
    %% Input and data read
    % CHECK THESE!
    % use 3 port simulation, with port 3 to the coupler, and linear frequency range%
    % plot data and export as :SYZ param file
    % spreadsheet format, (dB)-angle
    % high precision, exclude adaptive data, exclude comments
    % example
    % for this file, using ,td, as parameter:
    %
    % R 50.00000
    % Lc = 240.0
    % gap = 8.0
    % Line = 20.0
    % td = 2.0
    % 3.00000000,0.001831,-495.927,0.001831,-498.676,1.990e-4,-54.1383,0.001831,-498.676,0.001831,-495.927,1.990e-4,-54.1383,1.990e-4,-54.1383,1.990e-4,-54.1383,0.003176,-862.452
    % 3.50000000,0.001569,-424.517,0.001569,-427.726,1.706e-4,-46.4140,0.001569,-427.726,0.001569,-424.517,1.706e-4,-46.4140,1.706e-4,-46.4140,1.706e-4,-46.4140,0.002723,-738.921
    % 4.00000000,0.001373,-370.884,0.001373,-374.552,1.492e-4,-40.6220,0.001373,-374.552,0.001373,-370.884,1.492e-4,-40.6220,1.492e-4,-40.6220,1.492e-4,-40.6220,0.002382,-646.229
    % ....
    %
    % The Qdesign matrix can be copy-pasted into the main script
    % first col = F in GHz
    % first row = coupler length.
    %
    % NB: Coupler length is defined as the TOTAL length of the central line,
    % incl vertical piece
    %
    %clear variables
    %file = 'SuperkidV1_Coupler3';
    %psort = 3;      % variable that has the coupler length
    %numparam = 4;   % total # of parameters of the SONNEt file
    %numheaders = 1; % 1 or 2, SONNET bitches around with this one

    %%%%%%%
    format('long','e');
    fid=fopen([file '.csv']);
    n=1;
    close all;
    params=zeros(1,100);frequencies=zeros(1,100);
    tdata=zeros(100,100);
    textscan(fid,'%*[^\r\n]',1);
    while n<100
        clear temp;
        textscan(fid,'%*[^\r\n]',numheaders-1);
        for m=1:numparam
            temp(m)=textscan(fid,'%*s%*s%f',1);
            disp(temp{m});
        end
        if isempty(temp{m})
                break
        end
        tparams=cell2mat(temp);
        params(n) = tparams(psort);
        %clear temp
        format longE
        nn=1;dff=1e12;
        while ~isempty(temp{1})
           temp=textscan(fid,'%f %*f %*f %*f %*f %f  ',1,'Delimiter',',');%1 ports
           %textscan(fid,'%f',1);ans{1}
            %[temp{1} ;temp{2}; temp{3}]
            if ~isempty(temp{1})
                if n == 1
                    frequencies(nn)=temp{1};%F;
                end
                tdata(nn,n)=-temp{2}/10 + log10(pi/2);%
                textscan(fid,'%*[^\r\n]',1);
                nn=nn+1;%frequencies
            else
                textscan(fid,'%*[^\r\n]',1);
            end

        end
        n=n+1;
    end
    params(n:end) = []; 
    frequencies(nn:end) = [];
    tdata(nn:end,:)=[];%nn = frequencies
    tdata(:,n:end)=[];%n is parameter tdata = (frequencies (rows), params(cols))
    fclose(fid);
    nfreqs = length(frequencies);
    nparams = length(params);
    %sorting
    [params,indi]=sort(params);
    for n=1:nparams
        datasorted(:,n)=tdata(:,indi(n));
    end
    data = zeros(nfreqs+1,nparams+1);
    data(1,:) = [0 params];
    data(:,1) = [0 frequencies]';
    data(2:end,2:end) = datasorted;
    Qdesign=data;

    %%%%

end