function Curx = EnvironmentalSelection_Final(Population)
    global Global
    PopDec = decs(Population);
    PopObj = objs(Population);
    %%%Prefilter the solutions with lower objective values and lower survival
    %%%times
    if Global.t >= Global.ARStart
        maxt   = min(PopObj(:,1));
        idx    = ((PopObj(:,1)==maxt) & (-PopObj(:,3)>Global.mu));
        if ~all(idx==0)
            Population = Population(idx);
            PopObj     = objs(Population);
        end
        PopObj = [-PopObj(:,3),PopObj(:,2)];

        [~,idx]= max(PopObj(:,1)-PopObj(end,1)-Global.alpha*PopObj(:,2));
        Curx   = PopDec(idx,:);
    else
        PopObj = [-PopObj(:,1),PopObj(:,2)];

        [~,idx]= max(PopObj(:,1)-PopObj(end,1)-Global.alpha*PopObj(:,2));
        Curx   = PopDec(idx,:);
    end
end

