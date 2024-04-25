function type = h5getDatasetType(filepath, datasetname, convert_to_matlab)    
    if(nargin < 3)
        convert_to_matlab = false;
    end

    info = h5info(filepath, datasetname);
    
    type = info.Datatype.Type;

    if(convert_to_matlab) type = rw.h5typeToMatlab(type); end
end
