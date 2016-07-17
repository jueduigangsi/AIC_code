function [ theta ] = CS_ROMP( y,A,K )  
%CS_ROMP Summary of this function goes here  
%Version: 1.0 written by jbb0523 @2015-04-24  
%   Detailed explanation goes here  
%   y = Phi * x  
%   x = Psi * theta  
%   y = Phi*Psi * theta  
%   �� A = Phi*Psi, ��y=A*theta  
%   ������֪y��A����theta  
%   Reference:Needell D��Vershynin R��Signal recovery from incomplete and  
%   inaccurate measurements via regularized orthogonal matching pursuit[J]��  
%   IEEE Journal on Selected Topics in Signal Processing��2010��4(2)��310��316.  
    [y_rows,y_columns] = size(y);  
    if y_rows<y_columns  
        y = y';%y should be a column vector  
    end  
    [M,N] = size(A);%���о���AΪM*N����  
    theta = zeros(N,1);%�����洢�ָ���theta(������)  
    At = zeros(M,3*K);%�������������д洢A��ѡ�����  
    Pos_theta = zeros(1,2*K);%�������������д洢A��ѡ��������  
    Index = 0;  
    r_n = y;%��ʼ���в�(residual)Ϊy  
    %Repeat the following steps K times(or until |I|>=2K)  
    for ii=1:K%����K��  
        product = A'*r_n;%���о���A������в���ڻ�  
        %[val,pos] = max(abs(product));%�ҵ�����ڻ�����ֵ������в�����ص���  
        [val,pos] = Regularize(product,K);%�����򻯹���ѡ��ԭ��  
        At(:,Index+1:Index+length(pos)) = A(:,pos);%�洢�⼸��  
        Pos_theta(Index+1:Index+length(pos)) = pos;%�洢�⼸�е����  
        if Index+length(pos)<=M%At������������������Ϊ��С���˵Ļ���(�������޹�)  
            Index = Index+length(pos);%����Index��Ϊ�´�ѭ����׼��  
        else%At�����������������б�Ϊ������ص�,At(:,1:Index)'*At(:,1:Index)��������  
            break;%����forѭ��  
        end  
        A(:,pos) = zeros(M,length(pos));%����A���⼸��(��ʵ���п��Բ�Ҫ��Ϊ������в�����)  
        %y=At(:,1:Index)*theta��������theta����С���˽�(Least Square)  
        theta_ls = (At(:,1:Index)'*At(:,1:Index))^(-1)*At(:,1:Index)'*y;%��С���˽�  
        %At(:,1:Index)*theta_ls��y��At(:,1:Index)�пռ��ϵ�����ͶӰ  
        r_n = y - At(:,1:Index)*theta_ls;%���²в�  
        if norm(r_n)<1e-6%Repeat the steps until r=0  
            break;%����forѭ��  
        end  
        if Index>=2*K%or until |I|>=2K  
            break;%����forѭ��  
        end  
    end  
    theta(Pos_theta(1:Index))=theta_ls;%�ָ�����theta  
end  