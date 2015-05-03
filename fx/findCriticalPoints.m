function [idx] = findCriticalPoints(x,y)
  tP=findpeaksG(x,y,0,-1,5,5,1);
  tidx=int32(tP(:,2));
  flipy=1.7-y;
  %bP=findvalleys(x,y,0,-1,5,5,1);
  bP=findpeaksG(x,flipy,0,-1,5,5,1);
  bidx=int32(bP(:,2));
  bidxp=bidx > 0;
  bidx = bidx(bidxp);
  sidx=sort(cat(1,tidx,bidx));
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
  i=1;
  idx=[1];
  while(i < count-1)
    trend = y(vidx(i+1)) - y(vidx(i)) > 0;
    nexttrend = y(vidx(i+2)) - y(vidx(i+1)) > 0;
    if(trend == nexttrend)
      i++;
    else
      idx=[idx i+1];
      i++;
    endif
  endwhile
  idx=[idx count];
  idx=vidx(idx);
end
