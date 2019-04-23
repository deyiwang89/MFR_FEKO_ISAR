function [res] = ImgEntropy(I)
%求灰度矩阵的熵值
%输出图片的图像熵值

I_gray = round(mapminmax(I,0,256));% rgb2gray(I);
[ROW,COL] = size(I_gray);


%%
%新建一个size =256的矩阵，用于统计256个灰度值的出现次数
temp = zeros(256);
for i= 1:ROW
    
    for j = 1:COL
        %统计当前灰度出现的次数
        temp(I_gray(i,j)+1)= temp(I_gray(i,j)+1)+1;
        
    end
end

%%

res = 0.0 ;
for  i = 1:256
    %计算当前灰度值出现的概率
    temp(i) = temp(i)/(ROW*COL);
    
    %如果当前灰度值出现的次数不为0
    if temp(i)~=0.0
        
        res = res - temp(i) * (log(temp(i)) / log(2.0));
    end
end
% disp(res);
% fprintf('The Entropy is: %f\n',res);
end