# copy is more performant than deepcopy, but use deepcopy if copy fails
function trycopy(data)
    try
        copy(data)
    catch
        deepcopy(data)
    end
end
