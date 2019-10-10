-----------------------------------------------------------------------------
-- 通用功能模块
-----------------------------------------------------------------------------

local util = {}
local getArgs = require('Module:Arguments').getArgs


-- 用于引用的样例
-- local getArgs = require('Module:Arguments').getArgs
-- local OrderedTable = require('Module:OrderedTable')
-- local inArray = require('Module:Util').inArray
-- local flatten_table = require('Module:Util').flatten_table

-----------------------------------------------------------------------------
-- 通用功能
-----------------------------------------------------------------------------

function util.ref(ref_text, frame)
    return frame:callParserFunction('#tag', 'ref', ref_text)
end

function util.tooltip(frame, tt_text)
    local text

    if frame == mw.getCurrentFrame() then
        args = getArgs(frame)
        text = args[1]
        tt_text = args[2]
    else
        text = frame or 'Example'
        tt_text = tt_text or 'Example text'
    end

    local html = mw.html.create()

    html:tag('span'):cssText('cursor:help; border-bottom:1px dotted;'):attr('title', tt_text):wikitext(text)

    return tostring(html)
end

-- 检查一个值是否在一个列表中
function util.inArray(array, key)
    for _, v in ipairs(array) do
        if v == key then
            return true
        end
    end

    return false
end

--string.split函数
function util.split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    if szFullString==nil or szFullString=='' then
        return {''}
    end
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

return util
