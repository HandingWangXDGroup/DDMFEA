function Population = EnvironmentalSelectionSingle(Population,N)
    PopObj = objs(Population);
    PopDec = decs(Population);

    [~,idx] = sort(-PopObj);
    PopObj = PopObj(idx,:);
    PopDec = PopDec(idx,:);

    PopDec = PopDec(1:N,:);
    PopObj = PopObj(1:N);
    Population = PopStruct(PopDec,PopObj);
end

