%% exercise 0.5.1
x = 0:0.1:1;
f = exp(x); 

figure(1)
    plot(x,f);
    xlabel('x')
    ylabel('f(x)=exp(x)')
    title('The exponential function')