function SD = standarddeviation(A)

A=double(A);


[m,n]=size(A);

%To calculate the mean of the matrix
totmean=sum(A(:))/(m*n);

 %To calculate the variance and standard deviation

totdiff=(A-totmean).^2;
totsum=sum(totdiff(:));
nele=(m*n)-1;
totvar=totsum/nele;
%display(totvar);
totstd=sqrt(totvar);
SD = totstd;

