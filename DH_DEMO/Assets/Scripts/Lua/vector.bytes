
vector = {}
vector.__index = vector;
 
--构造函数
function vector:new()
	local ret = {}
	setmetatable(ret, vector)
	ret.tempVec = {}
	return ret
end
function vector:at(index)
	return self.tempVec[index]
end
 
function vector:push_back(val)
	table.insert(self.tempVec,val)
end
 
function vector:erase(index)
	table.remove(self.tempVec,index)
end
 
function vector:size()
    return #self.tempVec;
end
 
function vector:iter()
	local i = 0
	return function ()
        i = i + 1
        return self.tempVec[i]
    end
end
