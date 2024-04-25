function mtype = h5typeToMatlab(h5type)
    persistent typeH5toM_map;
    
    if(isempty(typeH5toM_map))
        typeH5toM_map = createMapTypeH5toM();
    end

    mtype = typeH5toM_map(h5type);
end

function typeH5toM_map = createMapTypeH5toM()

    typeH5toM_map = containers.Map;
    typeH5toM_map('H5T_C_S1') = 'char';
    typeH5toM_map('H5T_IEEE_F64LE')='double';
    typeH5toM_map('H5T_IEEE_F32LE')='single';
    typeH5toM_map('H5T_STD_U8LE')='logical';
    typeH5toM_map('H5T_STD_U8LE')='uint8';
    typeH5toM_map('H5T_STD_I8LE')='int8';
    typeH5toM_map('H5T_STD_U16LE')='uint16';
    typeH5toM_map('H5T_STD_I16LE')='int16';
    typeH5toM_map('H5T_STD_U32LE')='uint32';
    typeH5toM_map('H5T_STD_I32LE')='int32';
    typeH5toM_map('H5T_STD_U64LE')='uint64';
    typeH5toM_map('H5T_STD_I64LE')='int64';

end