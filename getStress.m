function [stress,mises] = getStress(B,D,u,elem,ndim,sumNode,sumElem,mnode)


if ndim == 2
    nip = 4;
else
    nip = 8;
end
ndimB = ndim*3-3;  % ��ԪB�����ά������άΪ3����άΪ6
s = zeros(sumElem*nip*ndimB,1);

% [nodeNdfID,~,rst] = find(u);
% u = zeros(ndim*sumNode,1);
% u(nodeNdfID) = rst;
% u = reshape(u,ndim,[]);

dbu = zeros(nip*ndimB,1);

for n = 1:sumElem
    elemU = u(:,elem(n,:));
    elemU = elemU(:);
    BU = B(ndimB*nip*(n-1)+1:ndimB*nip*n,:)*elemU;
    for m = 1:nip
        dbu((m-1)*ndimB+1:m*ndimB) = D((n-1)*ndimB+1:n*ndimB,:)*BU((m-1)*ndimB+1:m*ndimB);
    end
    s(ndimB*nip*(n-1)+1:ndimB*nip*n) = dbu;
end

s = reshape(s,ndimB,[])';
if ndim == 2
        a = 1+sqrt(3)/2;b = -1/2;c = 1-sqrt(3)/2;
        invs = [a,b,b,c;b,a,c,b;c,b,b,a;b,c,a,b];
        % invs = [1,0,0,0;0,1,0,0;0,0,0,1;0,0,1,0];
end

for n = 1:sumElem
    s(nip*(n-1)+1:nip*n,:) = invs*s(nip*(n-1)+1:nip*n,:);  % ����Ԫ�����Ӧ��ֵ
end

stress = zeros(sumNode,ndimB);
nodeMes = zeros(sumNode,1);
for n = 1:sumElem
    nodeMes(elem(n,:)) = nodeMes(elem(n,:))+1;
    stress(elem(n,1:nip),:) = stress(elem(n,1:nip),:)+s(nip*(n-1)+1:nip*n,:);
end

stress = stress./nodeMes;
if ndim == 2
    if mnode == 8
        stress(elem(:,5),:) = (stress(elem(:,1),:)+stress(elem(:,2),:))/2;
        stress(elem(:,6),:) = (stress(elem(:,2),:)+stress(elem(:,3),:))/2;
        stress(elem(:,7),:) = (stress(elem(:,3),:)+stress(elem(:,4),:))/2;
        stress(elem(:,8),:) = (stress(elem(:,4),:)+stress(elem(:,1),:))/2;
    end
end

% mises = zeros(sumNode,1);
smax = (stress(:,1)+stress(:,2))./2+sqrt(((stress(:,1)-stress(:,2))./2).^2+stress(:,3).^2);
smin = (stress(:,1)+stress(:,2))./2-sqrt(((stress(:,1)-stress(:,2))./2).^2+stress(:,3).^2);


mises = sqrt((smax.^2+smin.^2+(smax-smin).^2)./2);


