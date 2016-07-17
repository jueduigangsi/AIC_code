function [ A ] = OMP( D,X,L)

%===================================================
%���������
%   D -- ���걸�ֵ䡣ע�⣺�ֵ�ĸ��б��뾭���˹淶��
%   X -- �ź�
%   L -- ϵ���з���Ԫ���������ֵ����ѡ��Ĭ��ΪD��������
%�������
%   A -- ϡ��ϵ��
%===================================================

if(nargin==2)
    L=size(D,2);
end

P=size(X,2);
K=size(D,2);
for k=1:1:P
    a=[];
    x=X(:,k);
    residual=x;
    indx=zeros(L,1);
    
    for j=1:1:L
        proj=D'*residual;
        [~,pos]=max(abs(proj));
        pos=pos(1);
        indx(j)=pos;
        a=pinv(D(:,indx(1:j)))*x;
        residual=x-D(:,indx(1:j))*a;
        if(sum(residual.^2)<1e-6)
            break;
        end
    end
    temp=zeros(K,1);
    temp(indx(1:j))=a;
    A(:,k)=sparse(temp);
end

return;


