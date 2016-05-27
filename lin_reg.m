function lin_reg(x,y)
    X = [ones(length(x),1) x];
    B = X\y;
    fprintf('\ny = %f + %f * x\n\n', B(1), B(2));
end