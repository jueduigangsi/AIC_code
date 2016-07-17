function [ hat_y ] = CS_OMP( y,A,K )

[A_rows,A_columns] = size(A);
    if A_rows<A_columns
        N=A_columns;
        M=A_rows;
    else
        N=A_rows;
        M=A_columns;
    end
hat_y=zeros(1,N);                                 %  ���ع�������(�任��)����                     
Aug_t=[];                                         %  ��������(��ʼֵΪ�վ���)
r_n=y;                                            %  �в�ֵ

for times=1:K;                                    %  ��������(�������������,�õ�������ΪK)
    for col=1:N;                                  %  �ָ����������������
        product(col)=abs(A(:,col)'*r_n);          %  �ָ�������������Ͳв��ͶӰϵ��(�ڻ�ֵ) 
    end
    [val,pos]=max(product);                       %  ���ͶӰϵ����Ӧ��λ��
    Aug_t=[Aug_t,A(:,pos)];                       %  ��������
    A(:,pos)=zeros(M,1);                          %  ѡ�е�������
    aug_y=(Aug_t'*Aug_t)^(-1)*Aug_t'*y;           %  ��С����,ʹ�в���С
    r_n=y-Aug_t*aug_y;                            %  �в�
    pos_array(times)=pos;                         %  ��¼���ͶӰϵ����λ��
end
hat_y(pos_array)=aug_y;                           %  �ع�����������
                    
end