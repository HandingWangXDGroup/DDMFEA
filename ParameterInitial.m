function ParameterInitial(ProName)
    global Global
    Global.Problem   = ProName;  
    Global.Gen       = 100;             %%%Population generation of EA
    Global.T         = 100;             %%%Total time steps

    Global.alpha = 1;                   %%%weights of fitness and switch cost
    Global.m     = 5;                   %%%Problem peaks
    Global.t     = 1;                   %%%Current time
    Global.M     = 3;
    Global.ns    = 100;                 %%%Training data number of prediction RBFN
    %%%Threshold of solution performance
    Global.mu = 10;
    Global.N     = 100;                 %%%Population size
    Global.nt    = [1,2];               %%%Change severity range
    Global.ARStart = 6;                 %%%Time for the AR model start to be used
    Global.IniNum  = 20*Global.D;       %%%Initial offline data


    switch ProName
        case 'TP1'
            Hmin = 30; Hmax = 70; Hini = 50; Hphi = [1,10];   phis = 2;
            Wmin = 1;  Wmax = 12; Wini = 6;  Wphi = [0.1,1];  alp  = 0.04;
            Global.Lower = zeros(1,Global.D);
            Global.Upper = 30*ones(1,Global.D);
            Ct = repmat(linspace(1,30,Global.T)',1,Global.D);
            Ht = zeros(100,Global.m); Ht(1,:) = Hini; Hr = rand(100,Global.m)*2-1;
            Wt = zeros(100,Global.m); Wt(1,:) = Wini; Wr = rand(100,Global.m)*2-1;
            for i = 2:Global.T
                for j = 1:Global.m
                    derH   = alp*(Hphi(2)-Hphi(1))*Hr(i,j)*phis;
                    Ht(i,j)= min(max(Hmin,Ht(i-1,j)+derH),Hmax);
                    derW   = alp*(Wphi(2)-Wphi(1))*Wr(i,j)*phis;
                    Wt(i,j)= min(max(Wmin,Wt(i-1,j)+derW),Wmax);    
                end
            end
            Global.Ct = Ct; Global.Ht = Ht; Global.Wt = Wt;


        case 'TP2'
            Hmin = 30; Hmax = 70; Hini = 50; phis = 2;
            Wmin = 1;  Wmax = 12; Wini = 6;  
            Global.Lower = zeros(1,Global.D);
            Global.Upper = 30*ones(1,Global.D);
            Ct = repmat(linspace(1,30,Global.T)',1,Global.D);
            Ht = zeros(100,Global.m); Ht(1,:) = Hini; Hn = randn(100,Global.m);
            Wt = zeros(100,Global.m); Wt(1,:) = Wini; Wn = randn(100,Global.m);
            for i = 2:Global.T
                for j = 1:Global.m
                    derH   = Hn(i,j)*phis;
                    Ht(i,j)= min(max(Hmin,Ht(i-1,j)+derH),Hmax);
                    derW   = Wn(i,j)*phis;
                    Wt(i,j)= min(max(Wmin,Wt(i-1,j)+derW),Wmax);    
                end
            end
            Global.Ct = Ct; Global.Ht = Ht; Global.Wt = Wt;


        case 'TP3'
            Hmin = 30; Hmax = 70; Hini = 50; Hphi = [1,10];  
            Wmin = 1;  Wmax = 12; Wini = 6;  Wphi = [0.1,1];  p    = 12;
            Global.Lower = zeros(1,Global.D);
            Global.Upper = 30*ones(1,Global.D);
            Ct = repmat(linspace(1,30,Global.T)',1,Global.D);
            Ht = zeros(100,Global.m); Ht(1,:) = Hini;
            Wt = zeros(100,Global.m); Wt(1,:) = Wini; 
            for i = 2:Global.T
                for j = 1:Global.m
                    derH   = Hphi(1)+(Hphi(2)-Hphi(1))*(sin(2*pi/p*i+pi/4))/2;
                    Ht(i,j)= min(max(Hmin,Ht(i-1,j)+derH),Hmax);
                    derW   = Wphi(1)+(Wphi(2)-Wphi(1))*(sin(2*pi/p*1+pi/4))/2;
                    Wt(i,j)= min(max(Wmin,Wt(i-1,j)+derW),Wmax);    
                end
            end
            Global.Ct = Ct; Global.Ht = Ht; Global.Wt = Wt;
        case 'GPF'
            Global.Lower = zeros(1,Global.D);
            Global.Upper = 10*ones(1,Global.D);

    end
end