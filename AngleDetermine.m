function Ang=AngleDetermine(Af,Ap,PQuadrant)
%Takes in the fish angle, and pellet angle, and the quadrant and outputs
%the angle between the fish and the pellet. If the pellet is within 180
%degrees of the fish's left it will be positive and if it is within 180
%degrees of the fish's right it will be negative. quadrants are standard
%cartesian quadrant numbering.

if(Af<90)
    FQuadrant=2;
    if(PQuadrant==1)
        Ang=Ap-Af-360;
    elseif(PQuadrant==2)
        Ang=Ap-Af;
    elseif(PQuadrant==3)
        Ang=Ap-Af;
    else
        Ang=Ap-Af;
        if(Ang>180)
            Ang=Ang-360;
        end
    end
elseif(Af<180)
    FQuadrant=3;
    if(PQuadrant==2)
        Ang=Ap-Af;
    elseif(PQuadrant==3)
        Ang=Ap-Af;
    elseif(PQuadrant==4)
        Ang=Ap-Af;
    else
        Ang=Ap-Af;
        if(Ang>180)
            Ang=Ang-360;
        end
    end
elseif(Af<270)
    FQuadrant=4;
    if(PQuadrant==3)
        Ang=Ap-Af;
    elseif(PQuadrant==4)
        Ang=Ap-Af;
    elseif(PQuadrant==1)
        Ang=Ap-Af;
    else
        Ang=Ap-Af;
        if(abs(Ang)>180)
            Ang=Ang+360;
        end
    end
    
else
    FQuadrant=1;
    if(PQuadrant==4)
        Ang=Ap-Af;
    elseif(PQuadrant==1)
        Ang=Ap-Af;
    elseif(PQuadrant==2)
        Ang=Ap-Af+360;
    else
        Ang=Af-Ap;
        if(Ang<180)
            Ang=Ang+360;
        end
        if(Ang>180)
            Ang=360-Ang;
        end
        
       
    end    
end

if((Ang>180)||(Ang<-180))
    keyboard
    PQuadrant
    FQuadrant
end

return

