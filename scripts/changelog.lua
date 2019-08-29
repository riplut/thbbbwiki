local p={}

function p.hero_change_show(f)
    local pagename
    if(f.args[2]==nil or f.args[2]=="")then
        pagename=f.args[1]
    else
        pagename=f.args[2]
    end
    local dataname='Data:'..pagename..'.json'
    local re----生成页面
    local changelog=mw.huiji.db.find({['_id'] =dataname})[1]["changeData"]
    re='<h2>自机改动</h2>'
    for key,value in pairs(changelog) do
        if value["changeType"]=="自机改动" then
            local heroname='英雄'..string.sub(value["toPage"],1,-9)
            local db=mw.huiji.db.find({["unitId"]=heroname})[1]
            re=re..'<h3 class="bg-primary" style="padding:6px; overflow:hidden;font-size:14px;">'
                ..'[[file:'..string.sub(value["toPage"],1,-9)..'.png|24px|link=]]&nbsp;'
                ..'[['..value["toPage"]..']]'
                ..'</h3>'
                ..'<div style="padding:1em 0 1em 1em;margin-bottom:0.5em;">'
            if value["change"] then
                for _key,_value in pairs(value["change"]) do
                    re=re..'<li>'.._value..'</li>'
                end
            end
            for i=1,3,1 do
                local changeskillNum='changeSkill'..i
                if  value[changeskillNum][1] then
                    re=re..'<div>'..string.sub(db["skillData"][i]["skillName"][1],1,-4)..'</div>'
                            ..'<li>'..value[changeskillNum][1]..'</li>'
                end
            end
            re=re..'</div>'
        end
    end
    return f:preprocess(re)
end

function p.card_change_show(f)
    local pagename
    if(f.args[2]==nil or f.args[2]=="")then
        pagename=f.args[1]
    else
        pagename=f.args[2]
    end
    local dataname='Data:'..pagename..'.json'
    local re----生成页面
    local changelog=mw.huiji.db.find({['_id'] =dataname})[1]["changeData"]
    re='<h2>兵种改动</h2>'
    for key,value in pairs(changelog) do
        if value["changeType"]=="兵种改动" then
            local db=mw.huiji.db.find({["catagory"]="兵种",["cardID"]=value["toPage"]})[1]
            local skillIcon={}
            for i=1,2,1 do
                if db["upgradeSkill"][i]["icon"]==db["upgradeSkill"][i]["view"] then
                    skillIcon[i]=string.sub(db["upgradeSkill"][i]["view"],1,-5)..'icon.png'
                else
                    skillIcon[i]=db["upgradeSkill"][i]["icon"]
                end
            end
            re=re..'<h3 class="bg-primary" style="padding:6px; overflow:hidden;font-size:14px;">'
                    ..'[[file:'..value["toPage"]..'.png|24px|link=]]&nbsp;'
                    ..'[['..value["toPage"]..']]'
                    ..'</h3>'
                    ..'<div style="padding:1em 0 1em 1em;margin-bottom:0.5em;">'
            if value["change"] then
                for _key,_value in pairs(value["change"]) do
                    re=re..'<li>'.._value..'</li>'
                end
            end
            for i=1,2,1 do
                local changeskillNum='changeSkill'..i
                if  value[changeskillNum][1] then
                    re=re..'<div style="display:flex;flex-direction:row;justify-content: flex-start;align-items:center;">[[file:'..skillIcon[2]..'|x60px|link=]]'
                          ..'<div>'..db["upgradeSkill"][i]["name"]..'</div></div>'
                          ..'<li>'..value[changeskillNum][1]..'</li>'
                end
            end
            re=re..'</div>'
        end
    end
    return f:preprocess(re)
end
function p.show_full_change(f)

end

return p

