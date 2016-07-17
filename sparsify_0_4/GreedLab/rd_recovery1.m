function [x_hat,X_hat,freq_hat]=rd_recovery1(y3,t,S,N,M,Tx,m)
% This script accepts as input the compressed samples y and returns estimates (if not the 
% exact values) of the original signal x (specifically returns estimates of frequency support,
% amplitudes of Fouries series coefficients, and amplitudes of time domain signal).

% Usage: [x_hat,X_hat,freq_hat]=rd_recovery(y,t,S,N,M,Tx)
% y: sampled output (for this simulation, y is a sub-sampled version of x)
% t: time interval (vector) over which signal is observed (sec)
% S: vector of random +/- 1's 
% N: number of Nyquist periods within [0,Tx]
% M: the ratio M/N specifies rate of sampling process relative to Nyquist rate 
% Tx: length of observation interval 
% x_hat: recovered (estimated) spectrally sparse multitone signal
% X_hat: recovered (estimated) FS coefficients
% freq_hat: recovered frequencies (support)

% Copyright (c) 2010 by Michael A Lexa, Mike E Davies, John S Thompson
% Institute of Digital Communications, University of Edinburgh
%
% This work is licenced under the Creative Commons Attribution 3.0
% Unported License. To view a copy of this licence, visit
% http://creativecommons.org/licenses/by/3.0/ or send a letter to
% Creative Commons, 171 Second Street, Suite 300, San Francisco,
% California 94105, USA.

% create matrices characterizing the RD samples/measurements; see the 
% technical report "Sampling Sparse Multitone Signals with a Random Demodulator" 
% included with the CTSS Sampling Toolbox
l=0:N-1;   n=-N/2:N/2-1;
Psi=exp(1i*(2*pi/N)*l'*n); 
D=[];
%D=diag(S);
H=zeros(M,N);
H(1,1:N/M)=ones(1,N/M);
for i=2:M
 H(i,:)=circshift(H(i-1,:),[0 N/M]);
end
A=zeros(m*M,N);
for ch=1:m
    D(:,:,m)=diag(S(:,m));
    A(((ch-1)*M+1):(ch*M),:)=H*D(:,:,m)*Psi;
end
%A=H*D*Psi; % in accompanying technical report, H*D=Phi
J=10;
p=2;
y5=reshape(y3,(m*M),1);
[hat_y,hat_y_norm,pos_array] = omp_mmv(y5,A,J,p,M,m);



          
%s=greed_omp(y,A,N,'stopTol',N,'verbose',true); % support and FS coeffiecient recovery (T. Blumensath's OMP algorithm)  
%index=sort(find(abs(hat_y_norm)>0),'ascend');
index=pos_array;
X_hat=N*hat_y_norm; 

% Convert indices into corresponding frequencies (Hz)
tones=(-N/2:N/2-1)';
freq_hat=tones(index);

% Reconstruct Nyquist-rate samples
x_hat=(1/N)*sum(diag(X_hat(index))*exp(1i*(2*pi)/Tx*-freq_hat*t),1)';
%% OMP_MMV funtion
% input   :  Y          �� �۲�������
%            J          ���������� ��
%            p          : p������p>=1��,�����Ծ���ĳһ�н���P norm Լ����
% output  : hat_y       : �ع�MMVʸ����
%           hat_y_norm  :�� hat_y ���� p norm Լ����һάʸ����
% �ο����� ��J. Chen and X. Huo. Theoretical results on sparse representations of multiple-measurement vectors. IEEE Trans. Signal Process.,2006, 54(12): 4634�C4643.
%%

function [hat_y,hat_y_norm,pos_array] = omp_mmv(Y,A,J,p,M,m)
         [c,n]  = size(A);                                      %  ��������Ĵ�С����Ҫ�õ�����n,��A������  
         [c,n1] = size(Y);                                      %  ��Ҫ�õ�����n,��Y������
          Aug_t = [];                                           % �������     
          R     = Y;                                            % ��ʼ����
         hat_y  = zeros(n,n1);
         
      for times = 1:J                                          %  ��������
          for    col = 1:n                                     %  �ָ����������������
                product(col) = norm((R'*A(:,col)),p);                     %  �ָ�������������Ͳв��ͶӰϵ��(�ڻ�ֵ) 
          end
     [val,pos]        = max(product);                           %  ���ͶӰϵ����Ӧ��λ��
     Aug_t            = [Aug_t,A(:,pos)];                       %  ��������
     aug_y            = (Aug_t'*Aug_t)^(-1)*Aug_t'*Y;           %  ��С����,ʹ�в���С
     R                = Y-Aug_t*aug_y;                          %  �в����
     pos_array(times) = pos;                                    %  ��¼���ͶӰϵ����λ��
      end
     for k=1:J
hat_y(pos_array(k),:) = aug_y(k,:);                             %  �ع�������
     end
  for c=1:n
                x(c) = norm(hat_y(c,:),p);                      % �� hat_y ���� p norm Լ����һάʸ����
  end
          hat_y_norm = x;