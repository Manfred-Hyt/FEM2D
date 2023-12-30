% function  main()
clear;
tic
% read the element and boundary condation 
fprintf(1,'read the modal\n')
node = load('NLIST.DAT');
sumNode = size(node,1);
elem = load('ELIST.DAT');
sumElem = size(elem,1);
fixNode = load('fixNode.dat');
nodeForce = load('nodeForce.dat'); % �ڵ���
nodeForce(1,:) = [];

% -------------------------------------------------------------------------
mat = [200000,0.3;]; % ����ģ�������ɱ�, ���ֲ�����Ҫ����
ndim = 2;isStress = 1; % ƽ��Ӧ������ƽ��Ӧ�䣬Ϊ1ʱΪƽ��Ӧ��

h = 1;   % Ӧ���ڶ�ά���⣬Ĭ����1

matID  = elem(:,2); % elem�ĵڶ���Ϊ���ϱ��
EX = mat(matID,1); % ÿ����Ԫ������ģ��
mu = mat(matID,2); % ÿ����Ԫ�Ĳ��ɱ�

elem(:,1:2) = [];
node(:,1)   = [];
node = node(:,1:ndim);

mnode = size(elem,2);  % ��Ԫ����

if mnode == 4
    reduce = 0;  % �Ƿ���ü������֣�Ϊ1��ʾ�Ͳ��ü������֣�0��ʾȫ���֡�
else
    reduce = 1;  
end

% ---------------------------ת��ѹǿ---------------------------------------
if exist('press.dat','file')
    fprintf(1,'trans the pressure\n')
    nodeForceNew = transPres(node,elem,ndim,mnode);
    nodeForce = [nodeForce;nodeForceNew];
end

% ----------------------------�γ�����ն���--------------------------------
fprintf(1,'sort the global K\n')
if ndim == 2
    [GK_u,GK_v,GK_a,B,D] = globalK2D(EX,mu,h,elem,node,isStress,reduce,mnode);
end
% ----------------------------��һ��߽�����-----------------------------------
fprintf(1,'boundary condition\n')

% �Խ�Ԫ��1��ʩ�ӵ�һ��߽�����
[GK,force] = boundary_chang_one(GK_u,GK_v,GK_a,fixNode,nodeForce,sumNode,ndim);

% ----------------------------��ⷽ��--------------------------------------
fprintf(1,'solve the equation\n')
u = GK\force;
% ���������ý���ĳɷ�ϡ����ʽ
[nodeNdfID,~,rst] = find(u);
u = zeros(ndim*sumNode,1);
u(nodeNdfID) = rst;
u = reshape(u,ndim,[]);
if mnode == 4 && reduce == 0
    [s,mises] = getStress(B,D,u,elem,ndim,sumNode,sumElem,mnode);
elseif mnode == 8 && reduce == 1
    [s,mises] = getStress(B,D,u,elem,ndim,sumNode,sumElem,mnode);
else
    fprintf(1,'������Ӧ��\n')
end
u = u';

% ��ʾ���
% ux
figure
axis equal;
showContour(node,elem,u(:,1));
axis off;
% uy
figure
axis equal;
showContour(node,elem,u(:,2));
axis off;
% von-Mises stress
figure
axis equal;
showContour(node,elem,mises);
axis off;
disp('solution is done')