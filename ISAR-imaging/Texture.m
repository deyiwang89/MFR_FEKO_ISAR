function [ss1,ss2,ss3,ss4,ss5,sENL,sRadiometric_Resolution]=Texture(I)%[res] = ImgEntropy(I)   
%求图像的纹理特征：s1对比度,s2相关性,s3熵,s4平稳度,s5二阶矩（能量）
%% ENL 等效视数； Radiometric_Resolution 辐射分辨率
sENL=mean(I(:))*mean(I(:))/var(I(:));
sRadiometric_Resolution =10*log10(1/(sENL^(0.5)+1));
%%
I=double(I);%测试看看是否会对下一行的round有影响 
I_gray = round(mapminmax(I,0,256));% rgb2gray(I);
[ROW,COL] = size(I_gray);
%%
glcms1=graycomatrix(I_gray,'numlevels',64,'offset',[0 1;-1 1;-1 0;-1 -1]);
%纹理特征统计值 对比度 相关性 熵 平温度 二阶矩（能量）
stats = graycoprops(glcms1,{'Contrast','Correlation','Energy','Homogeneity'});
ga1=glcms1(:,:,1);      %0
ga2=glcms1(:,:,2);      %45
ga3=glcms1(:,:,3);      %90
ga4=glcms1(:,:,4);      %135
energya1=0;energya2=0;energya3=0;energya4=0;
for i = 1:64
    for j = 1:64
        energya1=energya1 + sum(ga1(i,j)^2);
        energya2=energya2 + sum(ga2(i,j)^2);
        energya3=energya3 + sum(ga3(i,j)^2);
        energya4=energya4 + sum(ga4(i,j)^2);
        j=j+1;
    end
    i=i+1;
end
ss1=0;ss2=0;ss3=0;ss4=0;ss5=0;
for m=1:4
    ss1 = stats.Contrast(1,m)+ss1;
    m=m+1;
end
for m=1:4
    ss2 = stats.Correlation(1,m)+ss2;
    m=m+1;
end
for m=1:4
    ss3 = stats.Energy(1,m)+ss3;
    m=m+1;
end
for m=1:4
    ss4 = stats.Homogeneity(1,m)+ss4;
    m=m+1;
end
ss5=ImgEntropy(I);%二阶矩（能量）

