function [deep_Var,count]=hullTop5(img)

img=imresize(img,360/size(img,1));


[~,edges]=skin(img);   %获取二值图、边缘
[B,~] = bwboundaries(edges,'noholes');  %边缘矩阵变成细胞体
edges_arr=cell2mat(B);  %边缘细胞体变为数组n*2;

STATS = regionprops(edges,'ConvexHull');
hull=STATS.ConvexHull;
for i=1:size(hull)  %将浮点值得full移到4邻域内的白点处
   x=hull(i,1);
   y=hull(i,2);
   if x~=floor(x)
       if edges(y,floor(x))==1
           hull(i,1)=floor(x);
       else
           hull(i,1)=floor(x)+1;
       end
   else
       if edges(floor(y),x)==1
           hull(i,2)=floor(y);
       else
           hull(i,2)=floor(y)+1;
       end
   end
end

len=size(hull,1);   %删除太靠近的hull点
for i=1:len
    if i==len
        point1=[hull(i,1),hull(i,2)];
        point2=[hull(1,1),hull(1,2)];
    else
        point1=[hull(i,1),hull(i,2)];
        point2=[hull(i+1,1),hull(i+1,2)];
    end
    if abs(point1(1)-point2(1))+abs(point1(2)-point2(2))<0
        hull(i,:)=0;    %太靠近就置0
    end
end

index=hull(:,1)==0;   %将0的删掉
hull(index,:)=[];
hull=flip(hull,1);%倒序

leng=length(hull);
hull(leng+1,:)=hull(1,:);

d_maxs=[];
rates=[];
end_indexs=[];
for i=1:length(hull)-1

    if end_indexs
        star_index=end_indexs(end);
    else
        a=edges_arr(:,2)==hull(i,1);
        b=edges_arr(:,1)==hull(i,2);

        star_index=find(a.*b==1);
        star_index=star_index(1);
    end

    a=edges_arr(:,2)==hull(i+1,1);
    b=edges_arr(:,1)==hull(i+1,2);
    end_index=find(a.*b==1);
    end_index=end_index(1);
    end_indexs=[end_indexs,end_index];

    d_max=-1;
    if star_index>end_index
        for j=1:end_index
            p0=[edges_arr(j,2),edges_arr(j,1)];
            p1=[hull(i,1),hull(i,2)];
            p2=[hull(i+1,1),hull(i+1,2)];
            d=distance(p1,p2,p0);
            if d>d_max
                d_max=d;
            end
        end
    else 
        for j=star_index:end_index
            p0=[edges_arr(j,2),edges_arr(j,1)];
            p1=[hull(i,1),hull(i,2)];
            p2=[hull(i+1,1),hull(i+1,2)];
            d=distance(p1,p2,p0);
            if d>d_max
                d_max=d;
            end
        end
    end
    d2=sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);   %始终点距离
    if d_max>0
        d_maxs=[d_maxs,d_max];
        rates=[rates,d_max/d2];
        
    %         p1s=[p1s,p1];
    %         p2s=[p2s,p2];
    %         p0s=[p0s,p0];
    end
end
deep_Var=var(d_maxs);
% deep_Mean=mean(d_maxs);
count=sum((rates>0.49));
