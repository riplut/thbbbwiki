local p = {}
local inArray = require('Module:Util').inArray
local OrderedTable = require('Module:OrderedTable')
-----------------------------------------------------------------------------
-- 常量
-----------------------------------------------------------------------------

function p.card_link(card_id)
    -- 查询指定兵种数据


    local html = mw.html.create()
    html
            :tag('div'):addClass('huiji-tt hvr-float-shadow'):cssText('display:inline-block;margin:0 0.2em;')
            :tag('span'):wikitext('[[File:'..card_id..'icon'..'.png|22x22px|link='..card_id..']]'):done()
            :tag('span'):wikitext('[['..card_id..']]'):done()
    return tostring(html)
end



return p