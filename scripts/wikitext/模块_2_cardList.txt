local p = {}

-- 通用
local getArgs = require('Module:Arguments').getArgs
local inArray = require('Module:Util').inArray
local OrderedTable = require('Module:OrderedTable')

-- 获取数据
local get_card_data = require('Module:Util/Data').get_card_data

function p.card_list(frame)
    local frame_args = getArgs(frame)
    local card_data=get_card_data(frame)
    -- 输出列表
    local html = mw.html.create()
    -----------------------------------------------------------------------------
    -- 过滤器
    -----------------------------------------------------------------------------
    -- 输出表格
    local table_html = html:tag('table'):addClass('wikitable sortable'):cssText('width:100%;'):attr('id', 'card-list'):cssText('margin-top: 20px;')
    -----------------------------------------------------------------------------
    -- 表头
    -----------------------------------------------------------------------------
    -- 正式部分
    local header_tr = table_html:tag('tr'):cssText('background-color: #ec8100;color: #000;')
    header_tr
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'all'):wikitext('兵种'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('造价'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('攻击力'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('生命值'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('护甲'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('攻击速度'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('移动速度'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('视野'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('射程'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('冲刺速度'):done()
    -- 整理数据
    for card_index,card_info in pairs(card_data) do
        local tr= table_html:tag('tr'):addClass('filter-div--item')
        --if card_index%2==0 then
        --    tr:cssText('background-color: rgba(255,255,255,0.1);')
        --end
        local re=card_info["cardID"]
        tr:tag('td'):attr('data-sort-value', card_info.cardID):addClass('small'):cssText('text-align:center;'):wikitext(re)
        tr:tag('td'):attr('data-sort-value', card_info.price):addClass('small'):cssText('text-align:center;'):wikitext(card_info.price)
        tr:tag('td'):attr('data-sort-value', card_info.attack):addClass('small'):cssText('text-align:center;'):wikitext(card_info.attack)
        tr:tag('td'):attr('data-sort-value', card_info.hp):addClass('small'):cssText('text-align:center;'):wikitext(card_info.hp)
        tr:tag('td'):attr('data-sort-value', card_info.armor):addClass('small'):cssText('text-align:center;'):wikitext(card_info.armor)
        tr:tag('td'):attr('data-sort-value', card_info.attackSpeed):addClass('small'):cssText('text-align:center;'):wikitext(card_info.attackSpeed)
        tr:tag('td'):attr('data-sort-value', card_info.slowspeed):addClass('small'):cssText('text-align:center;'):wikitext(card_info.slowspeed)
        tr:tag('td'):attr('data-sort-value', card_info.sight):addClass('small'):cssText('text-align:center;'):wikitext(card_info.sight)
        tr:tag('td'):attr('data-sort-value', card_info.attackDistance):addClass('small'):cssText('text-align:center;'):wikitext(card_info.attackDistance)
        tr:tag('td'):attr('data-sort-value', card_info.speed):addClass('small'):cssText('text-align:center;'):wikitext(card_info.speed):done()
    end
    return tostring(html)
end

return p