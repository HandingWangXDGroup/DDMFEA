function PopObj = ROOTObj(PopDec, Model, Allnets, Curx)
    global Global
    ns = min(Global.t, 15); Phi = min(ns-1, 5); 
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
            [Obj,~,~]   = predictor(PopDec(i,:),Model);
            PopObj(i,3) = -Obj;     
        end
        for i = 1:N
            CurDec  = PopDec(i,:);
            CurObjs = zeros(ns,1); CurObjs(ns) = -PopObj(i,3);
            for ti = 1:ns-1
                CurObjs(ns-ti) = predictor(CurDec, Allnets(Global.t-ti).net);
            end
            SurTime = 0;
            while CurObjs(end) >= Global.mu && SurTime <= (Global.T-Global.t)
                SurTime  = SurTime+1;
                ARmodel  = ar(CurObjs, Phi, 'yw');
                LastObj  = CurObjs(end:-1:end-Phi+1); 
                Prevalue = -sum(ARmodel.a(2:end) * LastObj);
                CurObjs  = [CurObjs;Prevalue];
            end
            PopObj(i,1)  = -SurTime;
        end
    end
end