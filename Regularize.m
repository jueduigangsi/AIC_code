function [val,pos] = Regularize(product,Kin)
%Regularize Summary of this function goes here
%   Detailed explanation goes here
%   product = A'*r_n;%���о���A������в���ڻ�
%   KΪϡ���
%   posΪѡ���ĸ������
%   valΪѡ���ĸ�����в���ڻ�ֵ
%   Reference:Needell D��Vershynin R. Uniform uncertainty principle and
%   signal recovery via regularized orthogonal matching pursuit. 
%   Foundations of Computational Mathematics, 2009,9(3): 317-334.  
    productabs = abs(product);%ȡ����ֵ
    [productdes,indexproductdes] = sort(productabs,'descend');%��������
    for ii = length(productdes):-1:1
        if productdes(ii)>1e-6%�ж�productdes�з���ֵ����
            break;
        end
    end
    %Identify:Choose a set J of the K biggest coordinates
    if ii>=Kin
        J = indexproductdes(1:Kin);%����J
        Jval = productdes(1:Kin);%����J��Ӧ������ֵ
        K = Kin;
    else%or all of its nonzero coordinates,whichever is smaller
        J = indexproductdes(1:ii);%����J
        Jval = productdes(1:ii);%����J��Ӧ������ֵ
        K = ii;
    end
    %Regularize:Among all subsets J0��J with comparable coordinates
    MaxE = -1;%ѭ�������д洢�������ֵ
    for kk = 1:K
        J0_tmp = zeros(1,K);iJ0 = 1;
        J0_tmp(iJ0) = J(kk);%��J(kk)Ϊ����Ѱ��J0�Ļ�׼(���ֵ)
        Energy = Jval(kk)^2;%����Ѱ��J0������
        for mm = kk+1:K
            if Jval(kk)<2*Jval(mm)%�ҵ�����|u(i)|<=2|u(j)|��
                iJ0 = iJ0 + 1;%J0�Ա�����1
                J0_tmp(iJ0) = J(mm);%����J0
                Energy = Energy + Jval(mm)^2;%��������
            else%������|u(i)|<=2|u(j)|��
                break;%��������Ѱ�ң���Ϊ�����С��ֵҲ�������Ҫ��
            end
        end
        if Energy>MaxE%��������J0����������ǰһ��
            J0 = J0_tmp(1:iJ0);%����J0
            MaxE = Energy;%����MaxE��Ϊ�´�ѭ����׼��
        end
    end
    pos = J0;
    val = productabs(J0);
end

