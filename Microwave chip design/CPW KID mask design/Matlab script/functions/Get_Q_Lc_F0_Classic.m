function [input,figs] = Get_Q_Lc_F0_Classic(Qdesign,Finalarray,Q,Lc_const,epsilon_substrate,makescaledQ, Fcenter, toplot)
% creates input matrix cols: 1Lres 2Lcoupler 3F0[GHz] 4Q using input(:,3)
% input(:,3) has F(GHz) for v
%optional making scaled Q
% Q factors and Lc

global Fshift;
narrayKIDs = size(Finalarray,1);
input = zeros(narrayKIDs,6);
input(:,3) = Finalarray;
eps_eff=(epsilon_substrate+1)/2;

for n=1:narrayKIDs %creating input matrix
    
    if makescaledQ == 1 %hyperbolic scaling
        Qf=Q*Fcenter/input(n,3);
    elseif length(Q)==1
        Qf=Q;
    else
        Qf=Q(n);
    end
    
    if Lc_const == 1
        input(n,2)=getLcgeneral(Fcenter,Qf,Qdesign,0);
    else
        input(n,2)=getLcgeneral(input(n,3),Qf,Qdesign,0);
    end
    input(n,1)=1/4*299792458E-3/input(n,3)/sqrt(eps_eff);
    
    input(n,4)=Qf;
end


if toplot==1
    figs=figure('OuterPosition',[100, 100, 800, 800]);
    subplot(2,2,1)
    plot(input(:,3)*Fshift,'.');ylabel('Fres');xlabel('index');title(['Fres including Fshift due to Lk etc: ' num2str(Fshift)])
    subplot(2,2,2)
    plot(input(:,3)*Fshift,abs(deltaf)*Fshift,'.');xlabel(['Fres including Fshift due to Lk etc: ' num2str(Fshift)]);
    ylabel('abs(dFres) including Fshift ')
    subplot(2,2,3)
    plot(input(:,3)*Fshift,input(:,4),'.');ylabel('Q');xlabel(['Fres including Fshift due to Lk etc: ' num2str(Fshift)]);
    subplot(2,2,4)
    plot(input(:,3),input(:,3)*Fshift,'.');xlabel('Fdesign');ylabel('Fres expected');
else
    figs=[];
end
end
