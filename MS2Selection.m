function Curx = MS2Selection(PopDec,PreCurx,Model,ARModel)
    global Global
    PopObj      = zeros(2,2);
    ARObj       = zeros(2,1);
    PopObj(:,2) = pdist2(PopDec,PreCurx);
    for i = 1:2
        [ARObj(i),~,~] = predictor(PopDec(i,:),ARModel);
        ARObj(i)    = round(ARObj(i));
        [Obj,~,~]   = predictor(PopDec(i,:),Model);
        PopObj(i,1) = Obj;
    end

    if ARObj(1) > ARObj(2)
        Curx = PopDec(1,:);
    elseif ARObj(1) < ARObj(2)
        Curx = PopDec(2,:);
    else
        [~,idx]= max(PopObj(:,1)-Global.alpha*PopObj(:,2));
        Curx   = PopDec(idx,:);
    end
end