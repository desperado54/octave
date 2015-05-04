pkg load signal
wnd = 210;
avg = 5;


data = csvread('eurusd_t.csv');
for m = 3:3
  start = 1+5*(m-1);
  y = data([start:wnd-1+start],4);
  x = [1:wnd]';
  %y = imfilter(oy, fspecial('average', [avg 1]));
  %skipped = int32(avg/2);
  %y = y(skipped : wnd - skipped);
  %x = x(skipped : wnd - skipped);

[tidx,bidx,idx]=findCriticalPoints(x,y);
  
%idx = findCriticalPoints(x,y);
%plot(x,y,x(tidx),y(tidx),'oc',x(bidx),y(bidx),'+m',x(idx),y(idx));
plot(x,y,x(tidx),y(tidx),'oc',"markersize", 15, x(bidx),y(bidx),'*r',"markersize", 15, x(idx),y(idx),"linewidth",2,"color","r");

sleep(5);
endfor

