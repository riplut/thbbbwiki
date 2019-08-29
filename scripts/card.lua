local p={}

function p.card_page_show(f)
    local pagename
    if(f.args[2]==nil or f.args[2]=="")then
        pagename=f.args[1]
    else
        pagename=f.args[2]
    end
    local version=mw.huiji.db.find({['_id'] ='Data:Version.json'})[1]
    local features=mw.huiji.db.find({['_id'] ='Data:Feature.json'})[1]["features"]
    local db=mw.huiji.db.find({["catagory"]="兵种",["cardID"]=pagename})[1]
    local feature=db["features"]
    local feature_Max=table.getn(feature)
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
        ..'<div style="float:right">当前版本：'..version["version"]..'</div>'
        ..'<div class="cardinfo">'
        ..'<div class="cardinfo-maininfo">'
        ..'<div class="cardinfo-maininfo-group1">'
        ..'<div class="cardinfo-avatar">{{characterbox2|'..pagename..'}}</div>'
        ..'</div>'
        ..'<div class="cardinfo-maininfo-group2">'
        ..'<div class="cardinfo-maininfo-group2-line1">'
        ..'<div class="cardinfo-rank">[[file:rank'..db["rank"]..'.png|x48px|link=]]</div>'
        ..'<div class="cardinfo-name">[[name::'..pagename..']]</div>'
        ..'</div>'
        ..'<div class="cardinfo-maininfo-group2-line2">'
        ..'<div class="cardinfo-shortName">'..db["fullName"]..'</div>'
        ..'<div class="cardinfo-origin">'..db["origin"]..'</div>'
        ..'<div class="cardinfo-bluepoint">[[file:货币 蓝点.png|x25px|link=]]</div>'
        ..'<div class="cardinfo-price">'..db["price"]..'</div>'
        ..'</div>'
        ..'<div class="cardinfo-maininfo-group2-line3">'
        ..'{{RichTab'
    for i=1,feature_Max,1 do
        local id=feature[i]
        if id==0 then
            re=re
                 ..'|'..features[id+1]["name"]..''
                    ..'|'..features[id+1]["introduction"]..''
        elseif id>116 then
            re=re..'|'..features[id-2]["name"]..''
                    ..'|'..features[id-2]["introduction"]..''
        elseif id>90 then
            re=re..'|'..features[id-1]["name"]..''
                    ..'|'..features[id-1]["introduction"]..''
        else
        re=re..'|'..features[id]["name"]..''
                ..'|'..features[id]["introduction"]..''
        end
    end
    re=re..'}}'
        ..'</div>'
        ..'</div>'
        ..'</div>'
        ..'<div class="cardinfo-speech">'..string.gsub(db["description"],'●','<br>')..'</div>'
        ..'</div>'
        ..'<div class="row meta-container">'
        ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
        ..'<div class="meta-item-label">生命值</div>'
        ..'<div class="meta-item-value">'..db["hp"]..'</div>'
        ..'</div>'
        ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
        ..'<div class="meta-item-label">攻击力</div>'
        ..'<div class="meta-item-value">'..db["attack"]..'</div>'
        ..'</div>'
        ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
        ..'<div class="meta-item-label">护甲</div>'
        ..'<div class="meta-item-value">'..db["armor"]..'</div>'
        ..'</div>'
        ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
        ..'<div class="meta-item-label">攻击速度</div>'
        ..'<div class="meta-item-value">'..db["attackSpeed"]..'/s</div>'
        ..'</div>'
        ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
        ..'<div class="meta-item-label">移动速度</div>'
        ..'<div class="meta-item-value">'..db["slowspeed"]..'/s</div>'
        ..'</div>'
        ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
        ..'<div class="meta-item-label">视野</div>'
        ..'<div class="meta-item-value">'..db["sight"]..'</div>'
        ..'</div>'
        ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
        ..'<div class="meta-item-label">射程</div>'
        ..'<div class="meta-item-value">'..db["attackDistance"]..'</div>'
        ..'</div>'
        ..'<div class="col-md-4 col-sm-4 col-xs-6 meta-item">'
        ..'<div class="meta-item-label">冲刺速度</div>'
        ..'<div class="meta-item-value">'..db["speed"]..'/s</div>'
        ..'</div>'
        ..'</div>'
    re=re..'<h2>台词</h2>'
    re=re..db["speech"]
    re=re..'<h2>技能</h2>'
        ..'<div class="cardinfo-group">'
        ..'<div class="cardinfo-group1">'
        ..'<div class="cardinfo-skill-img">[[file:'..db["upgradeSkill"][1]["view"]..'|x175px|link=]]</div>'
        ..'</div>'
        ..'<div class="cardinfo-group2">'
        ..'<div class="cardinfo-group2-line1">'
        ..'<div class="cardinfo-skill-icon">[[file:'..skillIcon[1]..'|x60px|link=]]</div>'
        ..'<div class="cardinfo-skill-title">'..db["upgradeSkill"][1]["name"]..'</div>'
        ..'<div class="cardinfo-skill-belief">[[file:货币 信仰.png|x25px|link=]]</div>'
        ..'<div class="cardinfo-skill-cost">'..db["upgradeSkill"][1]["cost"]..'</div>'
        ..'</div>'
        ..'<div class="cardinfo-group2-line2">'
        ..'<div class="cardinfo-skill-title">'..db["upgradeSkill"][1]["introduction"]..'</div>'
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
            ..'<div class="cardinfo-skill-title">'..db["upgradeSkill"][2]["name"]..'</div>'
            ..'<div class="cardinfo-skill-belief">[[file:货币 信仰.png|x25px|link=]]</div>'
            ..'<div class="cardinfo-skill-cost">'..db["upgradeSkill"][2]["cost"]..'</div>'
            ..'</div>'
            ..'<div class="cardinfo-group2-line2">'
            ..'<div class="cardinfo-skill-title">'..db["upgradeSkill"][2]["introduction"]..'</div>'
            ..'</div>'
            ..'</div>'
            ..'</div>'
    for i=1,feature_Max,1 do
        local id=feature[i]
        if id==0 then
            re=re..'[[category:'..features[id+1]["name"]..']]'
        elseif id>116 then
            re=re..'[[category:'..features[id-2]["name"]..']]'
        elseif id>90 then
            re=re..'[[category:'..features[id-1]["name"]..']]'
        else
            re=re..'[[category:'..features[id]["name"]..']]'
        end
    end
    re=re..'[[category:'..db["rank"]..']]'
    ..'[[category:'..db["catagory"]..']]'
    if db["origin"]~='' then
        re=re..'[[category:'..db["origin"]..']]'
    end
    re=re..'{{#set:|name zh='..pagename..'}}'
    return f:preprocess(re)
end

return p

