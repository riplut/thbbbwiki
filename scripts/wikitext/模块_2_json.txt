local p={}
---翻译模块
local ch=require('Module:Translate').ch
local en=require('Module:Translate').en
local jp=require('Module:Translate').jp
local ko=require('Module:Translate').ko
function p.hero_skill_show(f)
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
    local db=mw.huiji.db.find({["unitId"]=pagename})[1]
    local re
    re='<h2>技能</h2>'
    for j=1,3,1 do
        re=re..'<div class="cardinfo-group">'
        ..'<div class="cardinfo-group1">'
        ..'<div class="cardinfo-skill-img">{{HeroSkillbox|'..db["skillIcon"][j]..'}}</div>'
        ..'</div>'
        ..'<div class="cardinfo-group2">'
        ..'<div class="cardinfo-group2-line1">'
        ..'<div class="cardinfo-skill-title">'..string.sub(db["skillData"][j]["skillName"][1],1,-4)..'</div>'
        ..'<div class="cardinfo-skill-belief">[[file:P.png|x25px|link=[[p点]]]]</div>'
        ..'<div class="cardinfo-skill-cost">'..db["skillData"][j]["skillCost"][1]..'</div>'
        ..'</div>'
        ..'<div class="cardinfo-group2-line2">'
        ..'<div class="cardinfo-skill-title">{{RichTab'
        if j<=2 then
            for i=1,4,1 do
                re=re..'|'..string.sub(db["skillData"][j]["skillName"][i],-3)
                        ..'|冷却时间：'..db["skillData"][j]["cooldown"][i]..'s<br>'..tr(db["skillData"][j]["skillDesc"][i])

            end
        else
            for i=1,2,1 do
                re=re..'|'..string.sub(db["skillData"][j]["skillName"][i],-3)
                        ..'|冷却时间：'..db["skillData"][j]["cooldown"][i]..'s<br>'..tr(db["skillData"][j]["skillDesc"][i])

            end
        end
        re=re..'}}'
        ..'</div>'
        ..'</div>'
        ..'</div>'
        ..'</div>'
    end
    re=re..'{{#set:|name zh='..pagename..'}}'
    return f:preprocess(re)
end

return p

