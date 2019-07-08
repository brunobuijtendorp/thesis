function [datasorted,params]=readsonnetIDC(file,numheaders,showit)
% file is without extension!
% corrects non equal F spacing SONNET
% if program crashes, it most likely that SONNET messees with the #
% headerlines
% data from 1 port open ended IDC sim: SONNET: save SYZ parameter file, Z param, real - imag, spreadsheet
% format 
% make sure youi have only 1 parameter in the sonnet sim!!!!
% datasorted{param} = 3 cols with Freq (GHz), Real, Imag for each parameter
% param is the IDC totat width in microns
%% Input and data read
%CHECK THESE!
psort = 1;
numparam = 1;

%%%%%%%
if nargin == 2
    showit = 0;
end
format('long','e');
fid=fopen([file '.csv']);
n=1;

params=zeros(100,numparam);
tdata=cell(1,100);
data=tdata;
textscan(fid,'%*[^\r\n]',1);
while n<100
    clear temp;
    textscan(fid,'%*[^\r\n]',numheaders-1);
    for m=1:numparam
        temp(m)=textscan(fid,'%*s%*s%f',1);
        if showit == 1
            disp(temp{m});
        end
        
    end
    if isempty(temp{m})
            break
    end
    params(n,:)=cell2mat(temp);
    %clear temp
    format longE
    nn=1;dff=1e12;
    while ~isempty(temp{1})
       temp=textscan(fid,'%f %f %f',1,'Delimiter',',');%1 ports
       
        %[temp{1} ;temp{2}; temp{3}]
        if ~isempty(temp{1})
            tdata{n}(nn,1)=temp{1};%F;
            tdata{n}(nn,2)=temp{2};%
            tdata{n}(nn,3)=temp{3};
            textscan(fid,'%*[^\r\n]',1);
            %now we must correct for &*%^SONNEt that not makes dF equal!
            if nn>2
                df=abs(tdata{n}(nn,1)-tdata{n}(nn-1,1));
                if df<dff
                    dff=df;
                end
            end
            nn=nn+1;
        end
        
    end
    
    %removing non identical df to get homogeneous F range
    data{n}(:,1)=min(tdata{n}(:,1)):dff:max(tdata{n}(:,1));
    data{n}(:,2)=interp1(tdata{n}(:,1),tdata{n}(:,2),data{n}(:,1),'spline');
    data{n}(:,3)=interp1(tdata{n}(:,1),tdata{n}(:,3),data{n}(:,1),'spline');
    n=n+1;
end

data(n:end)=[];
params(n:end,:)=[];
fclose(fid);
%sorting with inverse dL
%sorting
params(:,psort)=params(:,psort);%dL is not KID length but lengtsh kid is shorter
if numparam>1
    [params,indi]=sortrows(params,psort);
    for nn=1:length(data)
        datasorted(nn)=data(indi(nn));
    end
    
else
    datasorted=data;
end
%save(file,'data','params') 
end
%%%%

