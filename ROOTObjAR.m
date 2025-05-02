function PopObj = ROOTObjV50(PopDec, Model, ARModel, Curx)
    global Global
    N      = size(PopDec,1);
    PopObj = zeros(N,3);
    PopObj(:,2) = pdist2(PopDec, Curx);
    if Global.t < Global.ARStart
        for i = 1:N
            [Obj,~,~]   = predictor(PopDec(i,:),Model);
            PopObj(i,1) = -Obj;     
        end
    else
        for i = 1:N
            [Obj,~,~]     = predictor(PopDec(i,:),Model);
            [SurTime,~,~] = predictor(PopDec(i,:),ARModel);
            
            PopObj(i,3) = -Obj;  
            PopObj(i,1) = -round(SurTime);
        end
    end
end