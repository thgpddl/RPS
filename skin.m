function [bw,edges] = skin(img)
%	����RGBͼ��
%   �����Ƥ����⡢��ֵ�ָ��������ͨ����,������

img=im2double(img);

YCbCr=rgb2ycbcr(img); %תΪYUV��ɫ�ռ�

Y=YCbCr(:,:,1);
Cb=YCbCr(:,:,2);
Cr=YCbCr(:,:,3);

gaussian=fspecial('gaussian',191,2);    %��˹ƽ��ģ��
Cr_gaussian=imfilter(Cr,gaussian,'conv','symmetric','same');    %��Crͨ�����и�˹ƽ��



T=graythresh(Cr_gaussian);  %Otsu�㷨���������ֵ
BW=im2bw(Cr_gaussian,T); %���������ֵ���ж�ֵ�ָ�


se=strel('rectangle',[9,9]);

BW=imopen(BW,se);%��ʴ����

imLabel = bwlabel(BW,8);% ����ͨ������б��
stats = regionprops(imLabel,'Area');
area=cat(1,stats.Area);
index=find(area==max(area));%�������ͨ��

img=ismember(imLabel,index);
bw=imfill(img,'holes');



imLabel = bwlabel(bw,8);
STATS = regionprops(imLabel,'BoundingBox');
rect=STATS.BoundingBox;
crop=imcrop(BW,rect);%ͼ��ü�

crop=imresize(crop,500/size(crop,1));

[m,n]=size(crop);
BW=zeros(m+2,n+2);%���밲ȫ�߿�
BW(2:m+1,2:n+1)=crop;

edges=edge(BW,'canny');%��Ե����

end