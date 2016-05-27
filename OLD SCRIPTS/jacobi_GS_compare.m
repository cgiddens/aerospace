function jacobi_GS_compare = jacobi_GS_compare(A,x,B)
    xact = A\B;
    for i = 1:10
        jerr(i) = norm(xact - jacobi(A,x,B,i), 1);
        gerr(i) = norm(xact - gauss_seidel(A,x,B,i), 1);
    end
    i = 1:10;
    plot(i,log(jerr))
    hold on
    plot(i,log(gerr))
    title('Jacobi vs. Gauss-Seidel - Relative error in a tridiagonal matrix');
    xlabel('Iterations');
    ylabel('Relative error (logarithmically linearized)');
end