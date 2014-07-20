function [A,B] = analyze_task_for_monica()
%Analyzes the impact of the relative distractor location on performance

d = uigetdir('Data directory:');
cd(d);
file = dir('*.mat');
i=0;
sh = [3 4 1 2];
oh = [2 1 4 3];
oe = [4 3 2 1]; 

B.S = zeros(4);
B.T = zeros(4);

for ii = 1:length(file);
    load(file(ii).name,'OUT','SUCC','STIMPROP');
    display(file(ii).name)
    display(STIMPROP.bias)
    if ~STIMPROP.bias
        i=i+1;
        for jj=1:4
            for kk = 1:4
               total = sum(SUCC.index(OUT.stim_positions==jj&OUT.dist_position'==kk) >-3);
               succ = sum(SUCC.index(OUT.stim_positions==jj&OUT.dist_position'==kk) >0);
                A(i).T(kk,jj) = total;
                A(i).S(kk,jj) = succ;
                A(i).P(kk,jj) = succ/total;
            end
            A(i).HP(jj,1) = A(i).P(sh(jj),jj);
            A(i).HP(jj,2) = A(i).P(oh(jj),jj);
            A(i).HP(jj,3) = A(i).P(oe(jj),jj);
        end
        B.relPerf(:,:,i) = A(i).HP;    
        B.S = B.S + A(i).S;
        B.T = B.T + A(i).T;
    end
end

B.P = B.S./B.T;
for jj = 1:4
    B.HP(jj,1) = B.P(sh(jj),jj);
    B.HP(jj,3) = B.P(oh(jj),jj);
    B.HP(jj,2) = B.P(oe(jj),jj);
end

