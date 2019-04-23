%%  GENERATE 2D Pierson-Moskowitz Distribution
close all;clc;clear all;
%  Parameters
clear;
NX=512;    % number in x direction
NY=512;    % number in y direction

avg_x=0.1;  % sampling size in x=dm
avg_y=0.1;  % sampling size in y=dm

%  NX=600;    % number in x direction
%  NY=600;    % number in y direction
%  avg_x=0.005;  % sampling size in x
%  avg_y=0.005;  % sampling size in y

TOTAL_NUM=NX*NY;

%% ѡ������ģʽ
% mode_input = input('����������ģʽ��A,����߶�(m)��B,����\n','s');
% if mode_input == 'A'
hrms=input('Input the rms height of the surface (suggest: 0.01 to 1) =   ');
U=sqrt( sqrt(hrms*hrms/8.1e-3*4*0.74*9.81*9.81)  );
fprintf('Equivalent Wind speed (corresponding to the rms) = %f(m/s) \n',U);
% else
%     U = double(input('Wind speed(m/s): \n'));
%     hrms = sqrt()
% end
%%  %------generating white noise
%randn('state',0);
randn('state',sum(10*clock))
noisetmp=randn(1,TOTAL_NUM);
% plot(noise)

for j=1:NY
    for i=1:NX
        noise(j,i)=(noisetmp((j-1)*NX+i));
    end
end

%----- statistic of the nosie
rms=0.0;
mean=0.0;

for j=1:NY
    for i=1:NX
        mean=mean+noise(j,i);
    end
end
mean=mean/TOTAL_NUM;

for j=1:NY
    for i=1:NX
        rms=rms+(abs(noise(j,i)-mean) )^2;
    end
end
rms=sqrt(rms/TOTAL_NUM);
fprintf('\n')
%  fprintf('Mean of the input noise=%f,  RMS=%f\n',mean,rms)
%---spectrum of the input noise

noise=noise/sqrt(TOTAL_NUM);
spec_noise=fft2(noise);  % transform into spectrum domain

delkx=2.0*pi/(avg_x*NX);
delky=2.0*pi/(avg_y*NY);

for j=0:NY-1
    for i=0:NX-1
        if(i<=NX/2) ii=i;
        else ii=i-NX;
        end
        if(j<=NY/2) jj=j;
        else jj=j-NY;
        end
        
        kx=ii*delkx;
        ky=jj*delky;
        K=sqrt(kx*kx+ky*ky);
        
        filterout(j+1,i+1)=spec_noise(j+1,i+1)*sqrt( Two_PM(U,K)*delkx/2.0/pi*delky/2.0/pi);
    end
end


rough=ifft2(filterout);
outsurface=real(rough);   %output surface
outsurface=outsurface*TOTAL_NUM;
figure('NumberTitle', 'off', 'Name', 'outsurface result');

surf(outsurface)
title(sprintf('����Ϊ %3.2f (m/s)��PM�׺���ֲ�',U));       %����
x1=xlabel('X��(dm)');                    %x�����
x2=ylabel('Y��(dm)');                    %y�����
x3=zlabel('�˸�(m)');                    %z�����
set(x1,'Rotation',30);               %x��������ת
set(x2,'Rotation',-30);              %y��������ת
[x2,y2]=meshgrid(1:NX,1:NY);
stlwrite('outsurface.stl',x2,y2,outsurface*10);
shading interp
figure('NumberTitle', 'off', 'Name', '2D image');
imshow(outsurface)
set(gcf,'color','w');
FG=getframe(gcf);
imwrite(FG.cdata,'FG.jpg')
%     figure('NumberTitle', 'off', 'Name', 'mesh result');
%     [x,y]=meshgrid(1:NX);
%     mesh(x,y,outsurface);
%     stlwrite('FG.stl',x,y,outsurface*100);
%% slice of the full pic
figure('NumberTitle', 'off', 'Name', 'slice result');
x1=input('start x point:');
y1=input('start y point:');
size_1=input('the size of slice(dm):');
[x1,y1]=meshgrid(1:size_1);
outsurface_slice=outsurface(x1:(x1+size_1-1),y1:(y1+size_1-1));
surf(outsurface_slice);
stlwrite('outsurface_slice.stl',x1,y1,outsurface_slice*10);
%because x and y direction has been dividec by 10 due to avg_x&y
%%    %----- statistic of the output surface
rms=0.0;
mean=0.0;

for j=1:NY
    for i=1:NX
        mean=mean+outsurface(j,i);
    end
end
mean=mean/TOTAL_NUM;
meanofroughsurface=mean;

for j=1:NY
    for i=1:NX
        rms=rms+(abs(outsurface(j,i)-mean) )^2;
        %            pause
    end
end

rmsofroughsurface=sqrt(rms/TOTAL_NUM);
fprintf('Output surface mean=%f,  RMS=%f\n',meanofroughsurface,rmsofroughsurface);
fprintf('The Presumed RMS is %f\n',hrms);
wave_top=max(max(outsurface));
wave_min=min(min(outsurface));
fprintf('wave_top=%f,  wave_min=%f\n',wave_top,wave_min);
fprintf('END OF GENERATING PERSON-MOSKWITZ DISTRIBUTION\n')








