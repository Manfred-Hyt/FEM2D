function [K,elemB,D] = elemK2D4(EX,mu,h,x1,y1,x2,y2,x3,y3,x4,y4,isStress,reduce)
% ���㵥Ԫ�նȾ���
% �Ľڵ��ı��ε�Ԫ
% ���ö����˹���֣�ȫ���ָ�˹��λ��+0.577350269189626,-0.577350269189626��Ȩϵ��Ϊ1
% ����ȡ�������֣����ֵ�λ��Ϊ0��Ȩϵ��Ϊ2
% ���Բ��ø��߽׵ĸ�˹����
% mnode == 4
% 4----3
% |    |
% |    |
% 1----2

K = zeros(8,8);
if reduce == 0
   elemB = zeros(12,8);
else
    elemB = 0;
end
if isStress == 1  % ƽ��Ӧ��
    D = EX/(1-mu^2)*[1,mu,0;mu,1,0;0,0,(1-mu)/2];
else              % ƽ��Ӧ��
    D = EX*(1-mu)/((1+mu)*(1-2*mu))*[1,mu/(1-mu),0;mu/(1-mu),1,0;0,0,(1-2*mu)/(2*(1-mu))];
end
 
if reduce == 0 % ������ȫ����
    nip = 2; % ��ά����Ļ��ֵ���
    x = [-0.577350269189626,0.577350269189626]; % ���ֵ�
    w = [1,1]; % Ȩϵ��
else
    nip = 1;
    x = 0; % ���ֵ�
    w = 2; % Ȩϵ��
end


for m = 1:nip
    for n = 1:nip
        [J,B] = elemB2D4(x1,y1,x2,y2,x3,y3,x4,y4,x(n),x(m));
        if reduce == 0
            elemB(6*m+3*n-8:6*m+3*n-6,:) = B;
        end
        K = K + w(m)*w(n)*B'*D*B*det(J)*h;
    end
end


