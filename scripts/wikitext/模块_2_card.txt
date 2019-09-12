local p={}
---翻译模块
local ch=require('Module:Translate').ch
local en=require('Module:Translate').en
local jp=require('Module:Translate').jp
local ko=require('Module:Translate').ko
--查找对应feature的文本,feature_key为对应键名:'name'or'introduction'
--function get_feature(dictionary,id,feature_key)
--    for key,info in pairs(dictionary) do
--        if info.id==id then
--            return info[feature_key]
--        end
--    end
--end
function p.card_page_show(f)
    local pagename
    local tr
    pagename=f.args[1]
    if(f.args[2]==nil or f.args[2]=="")then
        tr=ch
    end

    if f.args[2]=='ch' then tr=ch
    else if f.args[2]=='en' then tr=en
    else if f.args[2]=='jp' then tr=jp
        else if f.args[2]=='ko' then tr=ko
            end
        end
    end
    end
    local version=mw.huiji.db.find({['_id'] ='Data:Version.json'})[1]
    local db=mw.huiji.db.find({["category"]="兵种",["cardID"]=pagename})[1]
    local skillIcon={}----防止技能icon跟技能view重名
    local re
    for i=1,2,1 do
        if db["upgradeSkill"][i]["icon"]==db["upgradeSkill"][i]["view"] then
            skillIcon[i]=string.sub(db["upgradeSkill"][i]["view"],1,-5)..'icon.png'
        else
            skillIcon[i]=db["upgradeSkill"][i]["icon"]
        end
    end
    re='__无标题__'
            ..'__HIDDENCAT__'
    if(f.args[2]==nil or f.args[2]=="" or f.args[2]=="ch")then
        re=re..'<ul class="tbui-nav-pills nav nav-pills"><li role="presentation" class="active">[['..pagename..'|中文]]</li>'
    ..'<li role="presentation" >[['..pagename..'/EN|EN]]</li></ul>'
    --..'<li role="presentation" >[['..pagename..'/JP|日本語]]</li></ul>'
    --..'<li role="presentation" >[['..pagename..'/KO|한국어]]</li></ul>'
    end

    if f.args[2]=='en' then
        re=re..'<ul class="tbui-nav-pills nav nav-pills"><li role="presentation">[['..pagename..'|中文]]</li>'
    ..'<li role="presentation" class="active">[['..pagename..'/EN|EN]]</li></ul>'
    end
    re=re..'<div style="float:right">'..tr('版本')..':'..version["version"]..'</div>'
            ..'<div class="cardinfo">'
            ..'<div class="cardinfo-maininfo">'
            ..'<div class="cardinfo-maininfo-group1">'
            ..'<div class="cardinfo-avatar">{{characterbox2|'..pagename..'}}</div>'
            ..'</div>'
            ..'<div class="cardinfo-maininfo-group2">'
            ..'<div class="cardinfo-maininfo-group2-line1">'
            ..'<div class="cardinfo-rank">[[file:rank'..db["rank"]..'.png|x48px|link=]]</div>'
            ..'<div class="cardinfo-name">[[name::'..pagename..'|'..tr(pagename)..']]</div>'
            ..'</div>'
            ..'<div class="cardinfo-maininfo-group2-line2">'
            ..'<div class="cardinfo-shortName">'..tr(db["fullName"])..'</div>'
            ..'<div class="cardinfo-origin">'..tr(db["origin"])..'</div>'
            ..'<div class="cardinfo-bluepoint">[[file:货币 蓝点.png|x25px|link=]]</div>'
            ..'<div class="cardinfo-price">'..db["price"]..'</div>'
            ..'</div>'
            ..'<div class="cardinfo-maininfo-group2-line3">'
            ..'{{RichTab'
    for _,feature_id in pairs(db["features"]) do
            re=re
                    ..'|'..tr(feature_id)
                    ..'|'..tr(feature_id..'描述')
    end
    re=re..'}}'
            ..'</div>'
            ..'</div>'
            ..'</div>'
            ..'<div class="cardinfo-speech">'..tr(db["description"])..'</div>'
            ..'</div>'
            ..'<div class="row meta-container">'
            ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
            ..'<div class="meta-item-label">'..tr('生命值')..'</div>'
            ..'<div class="meta-item-value">'..db["hp"]..'</div>'
            ..'</div>'
            ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
            ..'<div class="meta-item-label">'..tr('攻击力')..'</div>'
            ..'<div class="meta-item-value">'..db["attack"]..'</div>'
            ..'</div>'
            ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
            ..'<div class="meta-item-label">'..tr('护甲')..'</div>'
            ..'<div class="meta-item-value">'..db["armor"]..'</div>'
            ..'</div>'
            ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
            ..'<div class="meta-item-label">'..tr('攻击速度')..'</div>'
            ..'<div class="meta-item-value">'..db["attackSpeed"]..'/s</div>'
            ..'</div>'
            ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
            ..'<div class="meta-item-label">'..tr('移动速度')..'</div>'
            ..'<div class="meta-item-value">'..db["slowspeed"]..'/s</div>'
            ..'</div>'
            ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
            ..'<div class="meta-item-label">'..tr('视野')..'</div>'
            ..'<div class="meta-item-value">'..db["sight"]..'</div>'
            ..'</div>'
            ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
            ..'<div class="meta-item-label">'..tr('射程')..'</div>'
            ..'<div class="meta-item-value">'..db["distance"]..'</div>'
            ..'</div>'
            ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
            ..'<div class="meta-item-label">'..tr('冲刺速度')..'</div>'
            ..'<div class="meta-item-value">'..db["speed"]..'/s</div>'
            ..'</div>'
            ..'</div>'
    re=re..'<h2>'..tr('台词')..'</h2>'
    re=re..tr(db["speech"])
    re=re..'<h2>'..tr('技能')..'</h2>'
            ..'<div class="cardinfo-group">'
            ..'<div class="cardinfo-group1">'
            ..'<div class="cardinfo-skill-img">[[file:'..db["upgradeSkill"][1]["view"]..'|x175px|link=]]</div>'
            ..'</div>'
            ..'<div class="cardinfo-group2">'
            ..'<div class="cardinfo-group2-line1">'
            ..'<div class="cardinfo-skill-icon">[[file:'..skillIcon[1]..'|x60px|link=]]</div>'
            ..'<div class="cardinfo-skill-title">'..tr(db["upgradeSkill"][1]["name"])..'</div>'
            ..'<div class="cardinfo-skill-belief">[[file:货币 信仰.png|x25px|link=]]</div>'
            ..'<div class="cardinfo-skill-cost">'..db["upgradeSkill"][1]["cost"]..'</div>'
            ..'</div>'
            ..'<div class="cardinfo-group2-line2">'
            ..'<div class="cardinfo-skill-title">'..tr(db["upgradeSkill"][1]["introduction"])..'</div>'
            ..'</div>'
            ..'</div>'
            ..'</div>'
    re=re..'<div class="cardinfo-group">'
            ..'<div class="cardinfo-group1">'
            ..'<div class="cardinfo-skill-img">[[file:'..db["upgradeSkill"][2]["view"]..'|x175px|link=]]</div>'
            ..'</div>'
            ..'<div class="cardinfo-group2">'
            ..'<div class="cardinfo-group2-line1">'
            ..'<div class="cardinfo-skill-icon">[[file:'..skillIcon[2]..'|x60px|link=]]</div>'
            ..'<div class="cardinfo-skill-title">'..tr(db["upgradeSkill"][2]["name"])..'</div>'
            ..'<div class="cardinfo-skill-belief">[[file:货币 信仰.png|x25px|link=]]</div>'
            ..'<div class="cardinfo-skill-cost">'..db["upgradeSkill"][2]["cost"]..'</div>'
            ..'</div>'
            ..'<div class="cardinfo-group2-line2">'
            ..'<div class="cardinfo-skill-title">'..tr(db["upgradeSkill"][2]["introduction"])..'</div>'
            ..'</div>'
            ..'</div>'
            ..'</div>'
    for _,feature_id in pairs(db["features"]) do
        re=re..'[[category:'..tr(feature_id)..']]'
    end
    re=re..'[[category:'..db["rank"]..']]'
            ..'[[category:'..tr(db["category"])..']]'
    if db["origin"]~='' then
        re=re..'[[category:'..tr(db["origin"])..']]'
    end
    re=re..'{{#set:|name tr='..pagename
    if(f.args[2]~=nil and f.args[2]~="")then
            re=re..'/'..string.upper(f.args[2] or '')
    end
    re=re..'|id='..db["id"]
            ..'|tr='..(f.args[2] or 'ch')
            ..'}}'
    return f:preprocess(re)
end

return p
