function Yint=langrangeINTERPOLATION(x,y,Xint)
n = length(x);
for i =1:n
    L(i) =1;
    for j = 1:n
        if j ~= i
            L(i)= L(i)*(Xint-x(j))/(x(i)-x(j));
        end
    end
end
Yint = sum(y.*L);