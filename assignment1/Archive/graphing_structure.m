if enablePlot == true
    subplot(1,2,1);
    stem(n,x1,'b','DisplayName','x1');
    hold on;
    stem(n,x2,'g','DisplayName','x2');
    stem(n,x3,'r','DisplayName','x3');
    title([name, ' Inputs']);
    xlabel('n');
    ylabel('Input Amplitude'); 
    legend;
    annotation('textbox', [0.47,0.78,0.1,0.1], 'String' ,sprintf('Scaling\na = %d\nb = %d',a,b), 'HorizontalAlignment', 'center');
    hold off;
    subplot(1,2,2);
    stem(n,y1,'b','DisplayName','y1');
    hold on;
    stem(n,y2,'g','DisplayName','y2');
    stem(n,y3,'r','DisplayName','y3');
    stem(n,a*y1+b*y2,'p','DisplayName','a*y1+b*y2');
    title([name, ' Outputs']);
    xlabel('n');
    ylabel('Output Amplitude');
    legend;
    hold off;
    sgtitle(['Test Case Proving Non-Linearity for ', name], 'FontWeight', 'bold');
end