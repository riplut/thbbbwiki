-- 名称转换模块

local p = {}
local get_dict = require('Module:Util/Data').get_dict
dict=get_dict(frame)
-- 单个词语转换（不分大小写）
function trans(dictionary, srclang,  distLang)
    for key,info in pairs(dictionary) do
        if type(info)=="table" then
            for _key,_info in pairs(info) do
                if _info.id==srclang then
                    return _info[distLang]
                end
            end
        end
    end
end

function p.ch(frame)
    return trans(dict, frame,  'zh-Hans')
end
function p.ch_(frame)
    return trans(dict, frame.args[1],  'zh-Hans')
end

function p.en(frame)
    return trans(dict, frame, 'en-US')
end
function p.en_(frame)
    return trans(dict, frame.args[1], 'en-US')
end

function p.jp(frame)
    return trans(dict, frame,  'ja-JP')
end
function p.jp_(frame)
    return trans(dict, frame.args[1],  'ja-JP')
end

function p.ko(frame)
    return trans(dict, frame, 'ko-KR')
end
function p.ko_(frame)
    return trans(dict, frame.args[1], 'ko-KR')
end

return p
