function DDMFEA
    global Global
    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
    Global.D  = 2;
    ParameterInitial('TP1')
    
    Curx      = zeros(1,Global.D);
    Allnets   = struct();
    RFits     = zeros(1,Global.T);
    RCosts    = zeros(1,Global.T);
    NonSatis  = zeros(1,Global.T);
    THETA     = 5.*ones(1,Global.D);
    ARTHETA   = 5.*ones(1,Global.D);
    Global.MSNum = zeros(1,Global.T);
    disp(['*******Time step:', num2str(Global.t), '********'])
    while Global.t <= Global.T
        %%%Preparation
        IniData = LHS_sam(Global.IniNum, Curx);
        TrainDec  = decs(IniData);
        TrainObj  = objs(IniData);

        Model     = dacefit(TrainDec,TrainObj(:,1),'regpoly1','corrgauss',THETA,1e-5.*ones(1,Global.D),10^5.*ones(1,Global.D));
        THETA     = Model.theta;  
        Allnets(Global.t).net = Model;

        Population= LHS_sam(Global.N, Curx);
        PopDec    = decs(Population);
        IniPopDec = PopDec;
        CurObj    = eval([Global.Problem '.obj(Curx, Curx)']);
        PreCurx   = Curx;
        
        %% Multi-objective optimization
        %%%Construct Kriging model for the ARModel
        if Global.t >= Global.ARStart
            ARPop = LHS_sam(Global.D*100, Curx);
            DBDec = decs(ARPop);  
            DBObj = ROOTObj(DBDec, Model, Allnets, Curx);
            DB    = PopStruct(DBDec,-DBObj(:,1));
            ARModel    = dacefit(decs(DB),objs(DB),'regpoly1','corrgauss',ARTHETA,1e-5.*ones(1,Global.D),10^5.*ones(1,Global.D));
            ARTHETA    = ARModel.theta;            
            PopObj     = ROOTObjAR(PopDec, Model, ARModel, Curx);
        else
            PopObj     = ROOTObj(PopDec, Model, Allnets, Curx);
        end
        Population = PopStruct(PopDec, PopObj);
        [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,length(Population));

        %%%Start the evolutionary optimization
        for gen = 1:Global.Gen
            MatingPool  = TournamentSelection(2,length(Population),FrontNo,-CrowdDis);
            OffDec      = GA(decs(Population(MatingPool)));
            if Global.t >= Global.ARStart
                OffObj  = ROOTObjAR(OffDec, Model, ARModel, Curx);
            else
                OffObj  = ROOTObj(OffDec, Model, Allnets, Curx);
            end
            Offspring   = PopStruct(OffDec, OffObj);
            [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population,Offspring],Global.N);
        end

        %%%Final solution selection
        if CurObj(1) < Global.mu
            MCandiCurx = EnvironmentalSelection_Final(Population);
        else
            MCandiCurx = MuEnvironmentalSelection_Final(Population,PreCurx,Model);  
        end

        %% Single Objective optimizaiton
        PopDec     = IniPopDec;
        PopObj     = ROOTObjSingle(PopDec, Model);
        Population = PopStruct(PopDec, PopObj);
        %%%Start the evolutionary optimization
        for gen = 1:Global.Gen
            OffDec      = GA(decs(Population));
            OffObj      = ROOTObjSingle(OffDec, Model);
            Offspring   = PopStruct(OffDec, OffObj);
            Population  = EnvironmentalSelectionSingle([Population,Offspring],Global.N);
        end
        PopObj          = objs(Population);
        PopDec          = decs(Population);
        [~,idx]         = max(PopObj);
        SCandiCurx      = PopDec(idx,:);


        %% Multi-Single optimal solution selection
        if Global.t < Global.ARStart
            Curx = MSSelection([MCandiCurx;SCandiCurx],PreCurx,Model);
        else
            Curx = MS2Selection([MCandiCurx;SCandiCurx],PreCurx,Model,ARModel);
        end

        if all(SCandiCurx == Curx)
            Global.MSNum(Global.t) = 2;
        elseif all(PreCurx == Curx)
            Global.MSNum(Global.t) = 0;
        else
            Global.MSNum(Global.t) = 1;
        end

        %% performance evaluation
        RFinObj   = eval([Global.Problem '.obj(Curx, PreCurx)']);
        RFits(Global.t) = RFinObj(1);  
        RCosts(Global.t)= RFinObj(2); 
        if RFinObj(1) < Global.mu
            NonSatis(Global.t) = 1;
        end  
        Global.t = Global.t+1;
        disp(['*******Time step:', num2str(Global.t), '********'])
    end
    AverFit  = mean(RFits);
    AverCost = mean(RCosts);
    Find1 = AverFit-Global.alpha*AverCost;
    Nind2 = sum(NonSatis);
end