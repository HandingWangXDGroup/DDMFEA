function PopObj = ROOTObjSingle(PopDec, Model)
    N      = size(PopDec,1);
    PopObj = zeros(N,1);
    for i = 1:N
        [Obj,~,~]   = predictor(PopDec(i,:),Model);
        PopObj(i)   = Obj;     
    end
end