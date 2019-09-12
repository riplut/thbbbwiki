local p = {}
local inArray = require('Module:Util').inArray
local OrderedTable = require('Module:OrderedTable')
-----------------------------------------------------------------------------
-- 常量
-----------------------------------------------------------------------------

function p.get_special_card_data(card_id)
    -- 查询指定兵种数据
    local query = {
        ['category'] = '兵种',
        ['cardID'] = card_id,
    }

    local result = mw.huiji.db.find(query)
    if #result == 1 then
        return result[1]
    elseif #result == 0 then
        return { error='没有找到结果', result={} }
    else
        -- 使用时会报错，到时再检查
        return { error='有超过1个的同名结果', result=result }
    end
end

function p.get_card_data(frame)
    local query = {
        ['category'] = '兵种',
    }
    local options = {
        ['sort'] = OrderedTable(),
    }

    options['sort']['cardID'] = 1
    local result = mw.huiji.db.find(query, options)
    return result
end
function p.get_dict(frame)
    local query = {
        ['_id'] ='Data:Locales.json'
    }
    local result = mw.huiji.db.findOne(query)
    return result
end
function p.get_version(frame)
    local query = {
        ['_id'] ='Data:Version.json'
    }
    local result = mw.huiji.db.findOne(query).version
    return result
end
return p