pkg load signal
wnd = 210;
avg = 5;

fibol1 = 0.382;

data = csvread('eurusd_t.csv');
for m = 1:1
  start = 1+5*(m-1);
  y = data([start:wnd-1+start],4);
  x = [1:wnd]';
  %y = imfilter(oy, fspecial('average', [avg 1]));
  %skipped = int32(avg/2);
  %y = y(skipped : wnd - skipped);
  %x = x(skipped : wnd - skipped);

  [tpks tidx] = findpeaks(y,"MinPeakDistance",3);
  flipy=2-y;
  [bpks bidx] = findpeaks(flipy,"MinPeakDistance",3);
  sidx=sort(cat(1,tidx',bidx'));
  if(length(sidx) < 2)
    ;%continue;
  endif
  trend = (y(sidx(2)) - y(sidx(1))) > 0;
  %trend filtering
  count = length(sidx);
  k=1;
  trendidx=[1];
  while(k < count-1)
    trend = y(sidx(k+1)) - y(sidx(k)) > 0;
    nexttrend = y(sidx(k+2)) - y(sidx(k+1)) > 0;
    if(trend == nexttrend)
      k++;
    else
      trendidx=[trendidx k+1];
      k++;
    endif
  endwhile
  trendidx=[trendidx count];
  trendidx=sidx(trendidx);

  
  dist = abs(y(trendidx(2)) - y(trendidx(1)));
  fiboidx = [1,2];
  count = length(trendidx);
  i = 2;
  while(i < count)  
    j = i+1;
    while(j <= count)
      nextdist = abs(y(trendidx(j)) - y(trendidx(i)));
      if(nextdist/dist < fibol1)
        j++;
      else
        fiboidx = [fiboidx j];
        i = j;
        dist = nextdist;
        break;
      endif
      if(j > count)
        i=j;
        break;
      endif  
    endwhile
  endwhile
  fiboidx=trendidx(fiboidx);

  idx = fiboidx;
%idx = findCriticalPoints(x,y);
plot(x,y,x(tidx),y(tidx),'oc',x(bidx),y(bidx),'+m',x(idx),y(idx));
sleep(5);
endfor

