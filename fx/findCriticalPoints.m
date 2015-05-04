function [tidx,bidx,idx] = findCriticalPoints(x,y)
  avg = 5;
  fibol1 = 0.382;
  [tpks tidx] = findpeaks(y,"MinPeakDistance",7,"MinPeakWidth",2);
  flipy=2-y;
  [bpks bidx] = findpeaks(flipy,"MinPeakDistance",7,"MinPeakWidth",2);
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
  
  %plot(x,y,x(sidx),y(sidx),'oc',"markersize", 20, x(vidx),y(vidx),'*r',"markersize", 30, x(vidx),y(vidx),"linewidth",2,"color","k");

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
endfunction
