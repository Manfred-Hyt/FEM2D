function J = jacobi2D(x,y,N_ks,N_yt)
% ��jacobi ����
% �Ľڵ��ı���

% [N_ks,N_yt] = dfun2D(ks,yt); ��elemB���Ѿ����
J = [N_ks,N_yt]'*[x,y];
