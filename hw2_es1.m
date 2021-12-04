clear
close all
clc


for i=1:5
n = 100*i;

C=zeros(n/2, n/2);
    C(n/2, 1) = 1;
    Wc=ones(n/2, n/2);
    Wc=Wc-eye(n/2);
    W=[Wc, C;
       C',Wc];
    G=graph(W);
    deegre_centrality = G.degree';
    P = diag(deegre_centrality.^-1)*W;
    Q = 0.5*P + 0.5*eye(n);
    
    e=ones(n,1);
    x_0 = zeros(n,1);
    y_0 = zeros(n,1);
    x_0(1:2:n)=e(1:2:n); %convergenza veloce
    y_0(1:n/2)=e(1:n/2); %convergenza lenta
    
    
    
   %---SIMULAZIONE DELLA DINAMICA---------------
    toll=10^-8;
   %--simulazione convergenza veloce------------
   x=x_0;
   x_new=Q*x;
   x_counter=1;
   x_consensus = 0.5*ones(n,1);
   while norm(x_consensus-x_new)>toll
       x=x_new;
       x_new = Q*x;
       x_counter=x_counter+1;
   end
   x_counter_seq(i)=x_counter;
   
  %--simulazione convergenza lenta------------
   y=y_0;
   y_new=Q*y;
   y_counter=1;
   while norm(x_consensus-y_new)>toll
       y=y_new;
       y_new = Q*y;
       y_counter=y_counter+1;
   end
   y_counter_seq(i)=y_counter;
end

%--plot----------------------------------------
x=linspace(0,600);
figure(1)
bar(100:100:500, [x_counter_seq',y_counter_seq']); hold on
plot(x, x.^2, 'linewidth', 2);
title('Convergenza al consenso per due diverse condizioni iniziali')
legend('Tempo di conv. per la cond. iniziale x(0)','Tempo di conv. per la cond. iniziale y(0)', 'y=n^2'); 
xlabel('Numero di nodi');
ylabel('Tempo di convergenza al consenso')
    