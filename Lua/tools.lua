--- 格式化table为一个字符串
local string_format = string.format
local table_insert = table.insert
function dump_tostring(t)
    local sp = '    '
    local list = {}
    local function addline(str)
        table_insert(list, str)
    end

    local function do_tostring(tt, l, ln)
        local tp = type(tt);
        if (tp == 'table') then
            l = l + 4;
            if (l - 4 == 0) then
                addline('{');
            end
            for k, v in pairs(tt) do
                local pp = type(v);
                if (pp == 'table') then
                    addline(string_format('%'..l..'s[%s]={',sp,k));
                    do_tostring(v, l);
                    addline(string_format('%'..l..'s},',sp));
                elseif pp == 'string' then
                    addline(string_format('%'..l..'s[%s]=%s,',sp,k,'\'' .. tostring(v) .. '\''));
                else
                    addline(string_format('%'..l..'s[%s]=%s,',sp,k,tostring(v)));
                end

            end
            if (l - 4 == 0) then
                addline('}');
            end
        elseif tp == 'string' then
            addline(string_format('%'..l..'s=%s,',sp, '\'' .. tostring(tt) .. '\''));
        else
            addline(string_format('%'..l..'s=%s,',sp,tostring(tt)));
        end
    end
    do_tostring(t, 0);
    return table.concat(list, '\n');
end

local mem = 0
function testMem(info)
    collectgarbage("collect")
    local newMem = collectgarbage("count")
    if info then
        print("because " .. info)
    end
    print((newMem - mem) .. " kb, now memory " .. math.floor(newMem) .. " kb ")
    mem = newMem
    print("====================")
end