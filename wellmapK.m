  function F=f();


r=7; %.7 cm radius of well




for i=1:360
   theta=i/57.3;
   x=r*cos(theta);
   y=r*sin(theta);
   plot(x,y,'.g')
   hold on
end
   
   axis square
   
   
   for i=1:36
      btheta=(i*10)/57.3;
      btheta;
      sx=8*(cos(btheta));
      sy=8*(sin(btheta));
       mth=105;
%       mx=sx+(.8*cos(((mth+(i*10)))/57.7));
%       my=sy+(.8*sin(((mth+(i*10)))/57.7));
%       plot(mx,my,'*');
      plot(7*cos(btheta),7*sin(btheta),'*');
      for ii=1:72
         theta=(ii*5)/57.3;
         x=8*(cos(theta))+sx; %0.8 is the distance between the center of top piece and the guide tube (i.e. radius)
         y=8*(sin(theta))+sy;
         switch mod(i,4) 
         case 0 
             plot(x,y,'.r');
         case 1
             plot(x,y,'.m');
         case 2 
             plot(x,y,'.c');
         case 3
             plot(x,y,'.k');
         end
      end
  end
      
  axis([-r r -r r])  ;
  xlabel('Medial <---> Lateral');
  ylabel('Posterior <---> Anterior');