local p={}

function p.hero_skill_show(f)
    local pagename
    if(f.args[2]==nil or f.args[2]=="")then
        pagename=f.args[1]
    else
        pagename=f.args[2]
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
                        ..'|冷却时间：'..db["skillData"][j]["cooldown"][i]..'s<br>'..db["skillData"][j]["skillDesc"][i]

            end
        else
            for i=1,2,1 do
                re=re..'|'..string.sub(db["skillData"][j]["skillName"][i],-3)
                        ..'|冷却时间：'..db["skillData"][j]["cooldown"][i]..'s<br>'..db["skillData"][j]["skillDesc"][i]

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

