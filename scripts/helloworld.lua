local p = {}

-- 通用
local getArgs = require('Module:Arguments').getArgs
local inArray = require('Module:Util').inArray
local OrderedTable = require('Module:OrderedTable')

-- 获取数据
local get_card_data = require('Module:Util/Data').get_card_data

function p.test(f)
    local card_data=get_card_data(frame)
    local re
    re='<h2>测试</h2>'
    for card_index,card_info in pairs(card_data) do
            re=re..card_info["features"][2]
    end
    return f:preprocess(re)
end

return p
