clc;clear;close all;
%% ���������������������λ�ǡ�Ƶ�ʵ���ʼ����ֵֹ
A = 221;%input('Enter the frequency sample number: ');
B = 221;%input('Enter the angle smaple number: ');
ang_start = -20.899080900742;%input('Enter the starting angle: ');
ang_end = 20.899080900742;%input('Enter the ending angle: ');
f_start = 3907820344.7955;%input('Enter the starting frequency: ');
f_end = 7051860784.4328;%input('Enter the ending frequency: ');
pol = 1;%input('Enter the polarization type:H=1 or V=2: ');
n_ang = B;
if pol == 1
    pol = 'H';
else
    pol = 'V';
end
read_ffe_s7([1,A,B],pol);       %��FEKO7�е�ffe�ļ�
load('farfield.mat');           %��������
if pol=='H'
    HV=getfield(phdata,'HV');   %��ȡVH��ֵ
    HH=getfield(phdata,'HH');
else
    VH = getfield(phdata,'VH');   %��ȡVH��ֵ
    VV = getfield(phdata,'VV');
end
image_1 = zeros(A,B);
image_2 = zeros(A,B);
% ----ѡ���Ӧ�ļ������ݣ�HH HV VV VH
if pol=='H'
    HV = reshape(HV,A,B); %��VH�������ΪA*B�ľ��󣬽Ƕȵı仯��Ƶ�ʵı仯
    HH = reshape(HH,A,B); %��VH�������ΪA*B�ľ��󣬽Ƕȵı仯��Ƶ�ʵı仯
    image_1 = HV;
    STR_1 = 'HV';
    image_2=HH;
    STR_2='HH';
else
    VH=reshape(VH,A,B);
    VV=reshape(VV,A,B);
    image_1=VH;
    STR_1='VH';
    image_2=VV;
    STR_2='VV';
end
figure('Name','cross pol');imagesc(abs(image_1));colormap(gray);colorbar;
set(gcf,'color','w');saveas(gcf,'VH ECHO','tif');

figure('Name','co pol');imagesc(abs(image_2));colormap(gray);colorbar;
set(gcf,'color','w');saveas(gcf,'VV ECHO','tif');

title('VV pol Backscatter data');xlabel('x(m)');ylabel('y(m)');
%% ��ͼ
% ---
x = 5;% input('Enter the x rangle ');
y = 5;% input('Enter the y rangle ');
X=linspace(-x,x,A);
Y=linspace(-y,y,B);
% --- % same polarization  HH or VV
image=image_2;
M_0 = isar_image(image,A,B,ang_start,ang_end,f_start,f_end,n_ang);
M_SP = M_0;
M_1_SP=20*log10(abs(M_SP));
% figure('Name',STR_2);imagesc(X,Y,M_1_SP);colormap(gray);colorbar;set(gcf,'color','w');saveas(gcf,'hhdb.jpg');%��ʾͼ��
% M_2_SP=abs(M_SP);
% figure('Name',STR_2);imagesc(X,Y,M_2_SP);colormap(gray);colorbar;set(gcf,'color','w');saveas(gcf,'hhreal.jpg');
% title('ISAR pic VV pol');xlabel('x(m)');ylabel('y(m)');
% --- % cross polarization  HV or VH
image=image_1;
M_0 = isar_image(image,A,B,ang_start,ang_end,f_start,f_end,n_ang);
M_CP = M_0;
M_1_CP=20*log10(abs(M_CP));
% figure('Name',STR_1);imagesc(X,Y,M_1_CP);colormap(gray);colorbar;set(gcf,'color','w');saveas(gcf,'hvdb.jpg');%��ʾͼ��
% M_2_CP=abs(M_CP);
% figure('Name',STR_1);imagesc(X,Y,M_2_CP);colorbar;set(gcf,'color','w');saveas(gcf,'hvreal.jpg');
% --- % combine
% M_3=abs(M_CP+M_SP);% combine isar true value figure
% figure('Name','COMBINE REAL VALUE');imagesc(X,Y,M_3);colorbar;set(gcf,'color','w');
% M_4=(M_1_CP+M_1_SP);% combine isar db figure
% figure('Name','COMBINE REAL VALUE DB');imagesc(X,Y,M_4);colorbar;set(gcf,'color','w');
%% trim
[M_5,rect] = imcrop(imagesc(M_1_SP));
rect = round(rect);
%M_5 = M_1_SP ; 
%load rect.mat;
M_5 = imcrop(M_1_SP,rect);
figure;imagesc(M_5);colormap(gray);colorbar;
figure_name = cell2mat(inputdlg('input the name of new pic','for example: abc',...
    1,{'same polar db'}));
fprintf('The parameters of %s are: std = %f ; avegrad = %f ; mean = %f\n ',...
    figure_name,std2(M_5),avegrad(M_5),mean(M_5(:)));
[ss1_M5,ss2_M5,ss3_M5,ss4_M5,ss5_M5,sENL_M5,sRadiometric_Resolution_M5]=Texture(M_5);
fprintf('The parameters of %s are:contrast=%f;correlation=%f;energy=%f;homogeneity=%f;entropy=%f;ENL=%f;Radiometric Resolution=%f\n',...
    figure_name,ss1_M5,ss2_M5,ss3_M5,ss4_M5,ss5_M5,sENL_M5,sRadiometric_Resolution_M5);
set(gcf,'color','w');saveas(gcf,figure_name,'fig');
figure;imcontour(M_5);colormap(jet);colorbar;
figure_name_2 = cell2mat(inputdlg('input the name of new contour pic','for example: abc',1,{'same polar db'}));
set(gcf,'color','w');saveas(gcf,figure_name_2,'fig');
%-------------------------
% M_6 = M_1_CP ;
M_6 = imcrop(M_1_CP,rect);
figure;imagesc(M_6);colormap(gray);colorbar;
figure_name = cell2mat(inputdlg('input the name of new pic','for example: abc',1,{'cross polar db'}));
fprintf('\n\nThe parameters of %s are: std = %f ; avegrad = %f ; mean = %f\n ',...
    figure_name,std2(M_6),avegrad(M_6),mean(M_6(:)));
[ss1_M6,ss2_M6,ss3_M6,ss4_M6,ss5_M6,sENL_M6,sRadiometric_Resolution_M6]=Texture(M_6);
fprintf('The parameters of %s are:contrast=%f;correlation=%f;energy=%f;homogeneity=%f;entropy=%f;ENL=%f;Radiometric Resolution=%f\n',...
    figure_name,ss1_M6,ss2_M6,ss3_M6,ss4_M6,ss5_M6,sENL_M6,sRadiometric_Resolution_M6);
set(gcf,'color','w');saveas(gcf,figure_name,'fig');
figure;imcontour(M_6);colormap(jet);colorbar;
figure_name_2 = cell2mat(inputdlg('input the name of new contour pic','for example: abc',1,{'same polar db'}));
set(gcf,'color','w');saveas(gcf,figure_name_2,'fig');