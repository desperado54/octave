pkg load signal
wnd = 210;
avg = 5;

fibol1 = 0.382;

data = csvread('eurusd_t.csv');
for m = 1:200
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
  dist = abs(y(sidx(2)) - y(sidx(1)));
  vidx = [1,2];
  count = length(sidx);
  i = 2;
  while(i < count)  
    j = i+1;
    while(j <= count)
      nextdist = abs(y(sidx(j)) - y(sidx(i)));
      if(nextdist/dist < fibol1)
        j++;
      else
        vidx = [vidx j];
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
  vidx=sidx(vidx);
  count = length(vidx);
  k=1;
  idx=[1];
  while(k < count-1)
    trend = y(vidx(k+1)) - y(vidx(k)) > 0;
    nexttrend = y(vidx(k+2)) - y(vidx(k+1)) > 0;
    if(trend == nexttrend)
      k++;
    else
      idx=[idx k+1];
      k++;
    endif
  endwhile
  idx=[idx count];
  idx=vidx(idx);
  
%idx = findCriticalPoints(x,y);
plot(x,y,x(tidx),y(tidx),'oc',x(bidx),y(bidx),'+m',x(idx),y(idx));
sleep(5);
endfor

