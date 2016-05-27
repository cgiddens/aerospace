function qf = quadform(a,b,c)

if(a==0 & b==0 & c==0)
    string1=sprintf('The root of this equation is 0.\n');
    string2=sprintf('\n');
    
elseif(a==0 & b==0)
    string1=sprintf('This equation has no root.\n');
    string2=sprintf('\n');
    
elseif(a==0)
    Q = -c/b;
    string1=sprintf('The root of this equation is %f.\n',Q);
    string2=sprintf('\n');
    
else
    Q1 = (-b + sqrt(b^2 - 4*a*c))/(2*a);
    Q2 = (-b - sqrt(b^2 - 4*a*c))/(2*a);
    
    if(Q1==Q2)
        string1=sprintf('The root of this equation is %s.\n',num2str(Q1));
        string2=sprintf('\n');
    
    elseif(Q1~=Q2)
        string1=sprintf('The first root of this equation is %s.\n',num2str(Q1));
        string2=sprintf('The second root of this equation is %s.\n',num2str(Q2));
    end
end

qf = [string1, string2];
end