clc;clear;%close all;
A=input('Enter the A:');
B=input('Enter the B:');
read_ffe_s7([1,A,B],'H') %��FEKO7�е�ffe�ļ�
% read_ffe([1,101,101],'H')  %��FEKO6�е�ffe�ļ�
load('farfield.mat')%��������  
VH=getfield(phdata,'VH');                                                %��ȡVH��ֵ
HH=getfield(phdata,'HH');
%  VH=getfield(phdata,'data_VH');                                                %��ȡVH��ֵ
%  HH=getfield(phdata,'data_HH');
c=3e8;
image_1=zeros(101,101);
image_2=zeros(101,101);
VH=reshape(VH,101,101); %��VH�������Ϊ101*101�ľ� �󣬽Ƕȵı仯��Ƶ�ʵı仯
HH=reshape(HH,101,101); %��VH�������Ϊ101*101�ľ��󣬽Ƕȵı仯��Ƶ�ʵı仯
image=HH;
for k=1:101
    image_1(102-k,:)=image(:,k);
end
for k=1:101
    image_2(:,k)=image_1(:,102-k);
end
% window=kaiser(101,2.5);
window=hamming(101);%hamming window is better
window=window'; % ����hamming window
for t1=1:101
    for t2=1:101
        g(t1,t2)=window(t2)*image_2(t1,t2); %������Ӵ�
    end
end

for t3=1:101
    for t4=1:101
        g(t3,t4)=window(t3)*g(t3,t4);%��λ��Ӵ�
    end
end
F_0=18e9:8e7:26e9;  %Ƶ�ʱ仯�ռ�
F_1=2*pi*F_0/c; %����k
M_0=ones(101,1);
M_1=ones(1,101);
matrix_k=M_0*F_1;    %k�ռ�
A_0=-20:0.4:20;  %�Ƕȱ仯
A_1=A_0';
matrix_angle=A_1*M_1;    %�Ƕȿռ�
kx=zeros(101,101);
ky=zeros(101,101);
for m=1:101
    for n=1:101
        kx(m,n)=matrix_k(m,n)*cos(matrix_angle(m,n));    %����kx����,x����Ĳ���
    end 
end
for k=1:101
    for l=1:101
        ky(k,l)=matrix_k(k,l)*sin(matrix_angle(k,l));    %����ky����y����Ĳ���
    end 
end
kxmin=F_1(1,1);       %����x����С�Ĳ���
kymax=kxmin*tan(pi/9);%����y�����Ĳ���
kymin=-kymax;         %����y����С�Ĳ���  
kxmax=sqrt(F_1(1,101)^2-kymax^2); %����x�����Ĳ���
kx_1=linspace(kxmin,kxmax,101);    %����ֱ������ϵ�µľ���Ԫ��
ky_1=linspace(kymin,kymax,101);
kx_2=M_0*kx_1;
ky_2=ky_1'*M_1;     %��չ����
K=zeros(101,101);
H=zeros(101,101);
for r0=1:101
    for c0=1:101
        K(102-r0,102-c0)=sqrt(kx_2(r0,c0)^2+ky_2(r0,c0)^2);   %���ԭͼ�е�Kֵ
    end
end
for r1=1:101
    for c1=1:101
        H(r1,c1)=atan(ky_2(r1,c1)/kx_2(r1,c1))*(180/pi);  %����Ƕ�
    end
end
% t1=M_0*A_0;
% t2=M_0*F_1;%���о�����չ
[t1,t2]=meshgrid(A_0,F_1);   %���ɼ�����ϵ�µ�����
v1=t1;
v2=[];
for r2=1:101
    v2(r2,:)=t2(102-r2,:);
end
H_1=[];
for c2=1:101
    H_1(102-c2,:)=H(:,c2);   %����ֱ������ϵ�µĽǶ�
end
K_1=[];
for r3=1:101
    K_1(:,r3)=K(102-r3,:);    %����ֱ������ϵ�µĲ���
end  
f_8=interp2(v1,v2,g,H_1,K_1,'spline');   %��ά��ֵ
M_0=fftshift(ifft2(f_8));      %��ά����Ҷ�仯
M_1=10*log(abs(M_0));
X=linspace(-1,1,101);
Y=linspace(-1,1,101);
figure;
imagesc(X,Y,M_1);       %��ʾͼ��
colorbar;
%%

%%
M_2=abs(M_0);
min_M_2=min(min(M_2));
max_M_2=max(max(M_2));
M_3=(M_2-min_M_2)./(max_M_2-min_M_2)*256;
figure;imagesc(M_2);colorbar;
figure;imshow(M_3);colorbar;