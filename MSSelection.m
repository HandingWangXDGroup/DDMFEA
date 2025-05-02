function Curx = MSSelection(PopDec,PreCurx,Model)
    global Global
    PopObj      = zeros(2,2);
    PopObj(:,2) = pdist2(PopDec,PreCurx);
    for i = 1:2
        [Obj,~,~]   = predictor(PopDec(i,:),Model);
        % Obj = eval([Global.Problem '.obj(PopDec(i,:), PreCurx)']);
        PopObj(i,1) = Obj(1);
    end
    [~,idx]= max(PopObj(:,1)-Global.alpha*PopObj(:,2));
    % [~,idx]= max(PopObj(:,1));
    Curx   = PopDec(idx,:);
end