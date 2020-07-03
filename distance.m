function dist=distance(point1,point2,var_point)
%定义三个点
x1=point1(1);
y1=point1(2);

x2=point2(1);
y2=point2(2);

x=var_point(1);
y=var_point(2);

A=(y1-y2)./(x1-x2);
B=-1;
C=y1-x1*(y1-y2)./(x1-x2);
dist=abs(A*x+B*y+C)./sqrt(A^2+B^2);
