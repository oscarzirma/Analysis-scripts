function [Tc,Tu,Sc,Su,Pdc,Pdu,scv,dp] = analyze_form_detection_task(OUT,SUCC)
%This function will analyze cueing effect in the form detection task

%%
%Pull data from structs
sp = OUT.stim_positions;
cu = OUT.cue;
si = SUCC.index;
rt = OUT.reaction_time;
sc = OUT.stim_contrast;

t = length(si);%num trials
dp = zeros(1,t);
for ii = 1:t
    dpi = cell2mat(OUT.dist_position(ii));
    dp(ii) = dpi(1);
end

n = max(sp);%num stim positions
scv = unique(sc);%contrast vals
nscv = length(scv);%#contrast vals


%%
%Assess performance for each stim-dist pair
Tc = zeros(n,n,nscv);%Cued totals
Tu = zeros(n,n,nscv);%Uncud totals
Sc = zeros(n,n,nscv);%Cued successes
Su = zeros(n,n,nscv);%Uncud successes
for ii = 1:nscv
    for jj = 1:n
        for k = 1:n
            in = (sc == scv(ii) & sp == jj & dp == k & cu == 1);
            Tc(jj,k,ii) = sum(si(in) == -3 | si(in) == 1);
            Sc(jj,k,ii) = sum(si(in) == 1);
            
            in = (sc == scv(ii) & sp == jj & dp == k & cu ~= 1);
            Tu(jj,k,ii) = sum(si(in) == -3 | si(in) == 1);
            Su(jj,k,ii) = sum(si(in) == 1);
        end
    end
end

%%
%Figure comparing cued/uncued as a function of contrast for each
%discrimination

%Get performance for each discrim location (L,U,R,D)
%The Pd matrices have increasing contrasts in rows and discrim locations
%in columns (LURD)
Pdc(:,1) = (Sc(1,3,:) + Sc(3,1,:))./(Tc(1,3,:) + Tc(3,1,:));
Pdc(:,2) = (Sc(4,3,:) + Sc(3,4,:))./(Tc(4,3,:) + Tc(3,4,:));
Pdc(:,3) = (Sc(4,2,:) + Sc(2,4,:))./(Tc(4,2,:) + Tc(2,4,:));
Pdc(:,4) = (Sc(2,1,:) + Sc(1,2,:))./(Tc(2,1,:) + Tc(1,2,:));

Pdu(:,1) = (Su(1,3,:) + Su(3,1,:))./(Tu(1,3,:) + Tu(3,1,:));
Pdu(:,2) = (Su(4,3,:) + Su(3,4,:))./(Tu(4,3,:) + Tu(3,4,:));
Pdu(:,3) = (Su(4,2,:) + Su(2,4,:))./(Tu(4,2,:) + Tu(2,4,:));
Pdu(:,4) = (Su(2,1,:) + Su(1,2,:))./(Tu(2,1,:) + Tu(1,2,:));

% scatter(repmat(scv,1,4),Pdc(:),'rx');
% hold on;
% scatter(repmat(scv,1,4),Pdu(:),'bx');
% errorbar(scv,mean(Pdc,2),std(Pdc,[],2)/2,'r')
% errorbar(scv,mean(Pdu,2),std(Pdu,[],2)/2,'b')

