function [bw,edges] = skin(img)
%	输入RGB图像
%   输出经皮肤检测、二值分割后的最大连通区域,并剪切

img=im2double(img);

YCbCr=rgb2ycbcr(img); %转为YUV颜色空间

Y=YCbCr(:,:,1);
Cb=YCbCr(:,:,2);
Cr=YCbCr(:,:,3);

gaussian=fspecial('gaussian',191,2);    %高斯平滑模板
Cr_gaussian=imfilter(Cr,gaussian,'conv','symmetric','same');    %对Cr通道进行高斯平滑



T=graythresh(Cr_gaussian);  %Otsu算法计算最佳阈值
BW=im2bw(Cr_gaussian,T); %利用最佳阈值进行二值分割


se=strel('rectangle',[9,9]);

BW=imopen(BW,se);%腐蚀操作

imLabel = bwlabel(BW,8);% 对连通区域进行标记
stats = regionprops(imLabel,'Area');
area=cat(1,stats.Area);
index=find(area==max(area));%求最大连通域

img=ismember(imLabel,index);
bw=imfill(img,'holes');



imLabel = bwlabel(bw,8);
STATS = regionprops(imLabel,'BoundingBox');
rect=STATS.BoundingBox;
crop=imcrop(BW,rect);%图像裁剪

crop=imresize(crop,500/size(crop,1));

[m,n]=size(crop);
BW=zeros(m+2,n+2);%加入安全边框
BW(2:m+1,2:n+1)=crop;

edges=edge(BW,'canny');%边缘算子

end