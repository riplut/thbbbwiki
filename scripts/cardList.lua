local p = {}

-- 通用
local getArgs = require('Module:Arguments').getArgs
local card_link = require('Module:Util/Link').card_link

-- 获取数据
local get_card_data = require('Module:Util/Data').get_card_data

function p.card_list(frame)
    local card_data=get_card_data(frame)
    -- 输出列表
    local html = mw.html.create()
    -----------------------------------------------------------------------------
    -- 过滤器
    -----------------------------------------------------------------------------
    local filter_div = html:tag('div'):addClass('filter-div'):attr('data-target', 'card-list')
    local group_div, ul
    group_div = filter_div:tag('div'):addClass('filter-group')
    --稀有度过滤
    ul = group_div:tag('ul'):addClass('filter-div--bgroup filter-list')
    ul:tag('li'):tag('div'):addClass('filter-list--title'):wikitext('稀有度')
    ul:tag('li'):tag('div'):addClass('filter-div--button selected'):attr('data-type', 'all'):wikitext('全部')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'rank'):attr('data-rank', 'S'):wikitext('S')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'rank'):attr('data-rank', 'A'):wikitext('A')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'rank'):attr('data-rank', 'B'):wikitext('B')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'rank'):attr('data-rank', 'C'):wikitext('C')
    --按来源过滤
    ul = group_div:tag('ul'):addClass('filter-div--bgroup filter-list')
    ul:tag('li'):tag('div'):addClass('filter-list--title'):wikitext('来源')
    ul:tag('li'):tag('div'):addClass('filter-div--button selected'):attr('data-type', 'all'):wikitext('全部')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'origin'):attr('data-origin', '妖妖梦'):wikitext('妖妖梦')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'origin'):attr('data-origin', '永夜抄'):wikitext('永夜抄')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'origin'):attr('data-origin', '花映冢'):wikitext('花映冢')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'origin'):attr('data-origin', '风神录'):wikitext('风神录')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'origin'):attr('data-origin', '妖妖梦'):wikitext('地灵殿')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'origin'):attr('data-origin', '永夜抄'):wikitext('神灵庙')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'origin'):attr('data-origin', '花映冢'):wikitext('其他')
    --按飞行/地面过滤
    ul = group_div:tag('ul'):addClass('filter-div--bgroup filter-list')
    ul:tag('li'):tag('div'):addClass('filter-list--title'):wikitext('单位')
    ul:tag('li'):tag('div'):addClass('filter-div--button selected'):attr('data-type', 'all'):wikitext('全部')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features1'):attr('data-features1', '飞行'):wikitext('飞行')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features1'):attr('data-features1', '地面'):wikitext('地面')
    --按远程/近战过滤
    ul = group_div:tag('ul'):addClass('filter-div--bgroup filter-list')
    ul:tag('li'):tag('div'):addClass('filter-list--title'):wikitext('类型')
    ul:tag('li'):tag('div'):addClass('filter-div--button selected'):attr('data-type', 'all'):wikitext('全部')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features2'):attr('data-features2', '远程'):wikitext('远程')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features2'):attr('data-features2', '近战'):wikitext('近战')
    --按类型过滤
    ul = group_div:tag('ul'):addClass('filter-div--bgroup filter-list')
    ul:tag('li'):tag('div'):addClass('filter-list--title'):wikitext('定位')
    ul:tag('li'):tag('div'):addClass('filter-div--button selected'):attr('data-type', 'all'):wikitext('全部')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features3'):attr('data-features3', '肉盾'):wikitext('肉盾')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features3'):attr('data-features3', '战士'):wikitext('战士')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features3'):attr('data-features3', '刺客'):wikitext('刺客')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features3'):attr('data-features3', '射手'):wikitext('射手')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features3'):attr('data-features3', '施法者'):wikitext('施法者')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features3'):attr('data-features3', '召唤师'):wikitext('召唤师')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features3'):attr('data-features3', '辅助'):wikitext('辅助')
    ul:tag('li'):tag('div'):addClass('filter-div--button'):attr('data-type', 'features3'):attr('data-features3', '特殊'):wikitext('特殊')


    -- 输出表格
    local table_html = html:tag('table'):addClass('wikitable sortable filterable'):cssText('width:100%;'):attr('id', 'card-list'):cssText('margin-top: 20px;')
    -----------------------------------------------------------------------------
    -- 表头
    -----------------------------------------------------------------------------
    -- 正式部分
    local header_tr = table_html:tag('tr'):cssText('background-color: #ec8100;color: #000;')
    header_tr
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):addClass('filterable-head'):wikitext('兵种'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('造价'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('攻击力'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('生命值'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('护甲'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('攻击速度'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('移动速度'):done()
            --:tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('视野'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('射程'):done()
            :tag('th'):cssText('width:10%;'):attr('data-sort-type', 'number'):wikitext('冲刺速度'):done()
    -- 整理数据
    for card_index,card_info in pairs(card_data) do
        local tr= table_html:tag('tr'):addClass('filter-div--item')
        --if card_index%2==0 then
        --    tr:cssText('background-color: rgba(255,255,255,0.1);')
        --end
        tr:attr('data-rank', card_info.rank)
        tr:attr('data-origin', card_info.origin)
        tr:attr('data-features1', card_info["features"][2])
        tr:attr('data-features2', card_info["features"][3])
        tr:attr('data-features3', card_info["features"][4])
        tr:tag('td'):attr('data-sort-value', card_info.cardID):addClass('small'):cssText('text-align:left;'):wikitext(card_link(card_info.cardID))
        tr:tag('td'):attr('data-sort-value', card_info.price):addClass('small'):cssText('text-align:center;'):wikitext(card_info.price)
        tr:tag('td'):attr('data-sort-value', card_info.attack):addClass('small'):cssText('text-align:center;'):wikitext(card_info.attack)
        tr:tag('td'):attr('data-sort-value', card_info.hp):addClass('small'):cssText('text-align:center;'):wikitext(card_info.hp)
        tr:tag('td'):attr('data-sort-value', card_info.armor):addClass('small'):cssText('text-align:center;'):wikitext(card_info.armor)
        tr:tag('td'):attr('data-sort-value', card_info.attackSpeed):addClass('small'):cssText('text-align:center;'):wikitext(card_info.attackSpeed)
        tr:tag('td'):attr('data-sort-value', card_info.slowspeed):addClass('small'):cssText('text-align:center;'):wikitext(card_info.slowspeed)
        --tr:tag('td'):attr('data-sort-value', card_info.sight):addClass('small'):cssText('text-align:center;'):wikitext(card_info.sight)
        tr:tag('td'):attr('data-sort-value', card_info.attackDistance):addClass('small'):cssText('text-align:center;'):wikitext(card_info.distance)
        tr:tag('td'):attr('data-sort-value', card_info.speed):addClass('small'):cssText('text-align:center;'):wikitext(card_info.speed):done()
    end
    return tostring(html)
end

return p