local p={}

----自机改动
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
                            ..'<li style="margin-left: 5rem>'..value[changeskillNum][1]..'</li>'
                end
            end
            re=re..'</div>'
        end
    end
    return f:preprocess(re)
end

----兵种改动
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
                          ..'<li style="margin-left: 5rem>'..value[changeskillNum][1]..'</li>'
                end
            end
            re=re..'</div>'
        end
    end
    return f:preprocess(re)
end

----显示当前自机所有改动
function p.show_hero_change(f)
    --参数
    local pagename
    if(f.args[2]==nil or f.args[2]=="")then
        pagename=f.args[1]
    else
        pagename=f.args[2]
    end
    --查找更新日志
    local query={
        ['category']='更新日志'
    }
    local options={
        ['category']=1
    }
    db=mw.huiji.db.find(query,options)
    --获取当前自机数据
    local heroname='英雄'..string.sub(pagename,1,-9)
    local herodb=mw.huiji.db.find({["unitId"]=heroname})[1]
    --开始生成页面
    re='<h2>历史改动</h2>'
    ..'{{HuijiCollapsed|title=展开|ID=1|text='
    for key,value in pairs(db) do
        for i in ipairs(value['changeData']) do
            if value['changeData'][i]['toPage']==pagename then
                --版本
                re=re..'<h3>[['..value['version']..'版本更新|'..value['version']..']]</h3>'
                --显示改动
                if value['changeData'][i]['change'] then
                    for _key,_value in pairs(value['changeData'][i]["change"]) do
                        re=re..'<li>'.._value..'</li>'
                    end
                end
                for j=1,3,1 do
                    local changeskillNum='changeSkill'..j
                    if  value['changeData'][i][changeskillNum][1] then
                        re=re..'<div>'..string.sub(herodb["skillData"][j]["skillName"][1],1,-4)..'</div>'
                                ..'<li style="margin-left: 5rem>'..value['changeData'][i][changeskillNum][1]..'</li>'
                    end
                end
            end
        end
    end
    re=re..'}}'
    return f:preprocess(re)
end

----显示当前兵种所有改动
function p.show_card_change(f)
    --参数
    local pagename
    if(f.args[2]==nil or f.args[2]=="")then
        pagename=f.args[1]
    else
        pagename=f.args[2]
    end
    --查找更新日志
    local query={
        ['category']='更新日志'
    }
    db=mw.huiji.db.find(query)
    --获取当前兵种数据
    local carddb=mw.huiji.db.find({["catagory"]="兵种",["cardID"]=pagename})[1]
    local skillIcon={}
    for i=1,2,1 do
        if carddb["upgradeSkill"][i]["icon"]==carddb["upgradeSkill"][i]["view"] then
            skillIcon[i]=string.sub(carddb["upgradeSkill"][i]["view"],1,-5)..'icon.png'
        else
            skillIcon[i]=carddb["upgradeSkill"][i]["icon"]
        end
    end
    --开始生成页面
    re='<h2>历史改动</h2>'
            ..'{{HuijiCollapsed|title=展开|ID=1|text='
    for key,value in pairs(db) do
        for i in ipairs(value['changeData']) do
            if value['changeData'][i]['toPage']==pagename then
                --版本
                re=re..'<h3>[['..value['version']..'版本更新|'..value['version']..']]</h3>'
                --显示改动
                if value['changeData'][i]["change"] then
                    for _key,_value in pairs(value['changeData'][i]["change"]) do
                        re=re..'<li>'.._value..'</li>'
                    end
                end
                for j=1,2,1 do
                    local changeskillNum='changeSkill'..j
                    if  value['changeData'][i][changeskillNum][1] then
                        re=re..'<div style="display:flex;flex-direction:row;justify-content: flex-start;align-items:center;">[[file:'..skillIcon[2]..'|x60px|link=]]'
                                ..'<div>'..carddb["upgradeSkill"][j]["name"]..'</div></div>'
                                ..' <li style="margin-left: 5rem">'..value['changeData'][i][changeskillNum][1]..'</li>'
                    end
                end
            end
        end
    end
    re=re..'}}'
    return f:preprocess(re)
end
return p

