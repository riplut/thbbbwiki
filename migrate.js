// const version = require('./migrate-wiki');
const version={ version: 20200716};
const fs = require('fs');
const xlsx = require('xlsx');
const Papa = require('papaparse');
const path = require('path');
const _ = require('lodash');
console.log(version);
//加载数据
const constructions = load('data', 'constructions');
const skills = load('data', 'skills');
const units = load('data', 'units');
const tips = load('data', 'tips');
const publishedCard = load('lobby/publishedCard');
const heroes = load('heroes','heroes');
const goods = load('lobby/Goods','Sheet1');
const cardSkin = load('lobby/CardSkin','Sheet1');
const live2D = load('lobby/Kanbanmusume','Sheet1');
const adventure_item=load('wiki/Item_Config','Sheet1');

function load(filename, sheetname) {
  const dir = path.join('database', 'production');
  const workbook = xlsx.readFile(`${dir}/${filename}.xlsx`);
  const sheet = workbook.Sheets[sheetname || workbook.SheetNames[0]];
  const data = xlsx.utils.sheet_to_csv(sheet);
  const result = Papa.parse(data, {
    dynamicTyping: true,
    header: true,
    skipEmptyLines: true,
    comments: true,
    trimHeaders: true
  }).data.map(row => _.omitBy(_.omit(row, ''), _.isNull));

  // 不能用 transform 函数，[0] 会变成 0
  for (const item of result) {
    for (const [key, value] of Object.entries(item)) {
      if (/^0x[0-9a-f]+$/i.test(value)) {
        // hex
        item[key] = parseInt(value);
      } else if (typeof value === 'string' && /^\{.*\}$|^\[.*\]$/.test(value)) {
        // object or array
        item[key] = JSON.parse(value);
      } else if (typeof value === 'string' && /%$/.test(value)) {
        // percentage
        item[key] = parseFloat(value) / 100;
      }
    }
  }

  return result;
}

function save(filename, data) {
  const dir = 'wikidata';
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
  }
  fs.writeFileSync(`${dir}/${filename}.json`, JSON.stringify(data, null, 2));
  console.log(filename);
}

function getKey(data, key1,cardID, key2) {
  for (const item of data) {
    if (item[key1] === cardID) {
      return item[key2];
    }
  }
}
//data数据中id跟cardID匹配,返回_key的值
function getVal(cardID, data, _key) {
  for (const item of data) {
    if (item.id === cardID) {
      return item[_key];
    }
  }
}

function getGold(cardID, data, _key) {
    for (const item of data) {
      if(item['itemId']){
        if (item['itemId'][0] === cardID) {
          return item[_key];
        }
      }
    }
}

function getItem(cardID, data) {
  for (const item of data) {
    if (item.id === cardID) {
      return item;
    }
  }
}

const level = new Map([[0, 'C'], [1, 'B'], [2, 'A'], [3, 'S']]);
//兵种
for (const item of publishedCard) {
  let itemtemp = {
    cardID: []
  };
  itemtemp.id=item.id;
  itemtemp.oderID=item.cardID;
  itemtemp.cardID = item.cardName;
  itemtemp.shortName = getVal(item.cardName, constructions, '短名');
  itemtemp.fullName = getVal(item.cardName, constructions, '全名');
  itemtemp.rank = level.get(getVal(item.cardName, constructions, '级别'));
  itemtemp.origin = getVal(item.cardName, constructions, '作品') || '其他';
  itemtemp.price = getVal(item.cardName, constructions, 'price');
  itemtemp.description = getVal(item.cardName, constructions, 'description');
  itemtemp.speech = getVal(item.cardName, constructions, 'speech');
  itemtemp.features = [];
  itemtemp.passiveSkillCount=0;
  itemtemp.passiveSkill=[];

  //特性
  let i = 0;
  for (let index = 0; index < 12; index++) {
    const key = `特性${index}`;
    if (getVal(item.cardName, constructions, key) !== undefined || null) {

      if(!getKey(tips,"id",getVal(item.cardName, constructions, key),"技能")){
        itemtemp.features[i] = getVal(item.cardName, constructions, key);
        ++i;
      }
      else{
        //被动技能
        let passiveSkillObj={};
        passiveSkillObj.name=getKey(tips,"id",getVal(item.cardName, constructions, key),"id");
        passiveSkillObj.passiveIcon=getKey(tips,"id",getVal(item.cardName, constructions, key),"大厅图标").slice(10);
        itemtemp.passiveSkill.push(passiveSkillObj);
        itemtemp.passiveSkillCount++;
      }
    }
  }


  //

  const unit=getVal(item.cardName, constructions, 'unit');
  itemtemp.hp = getVal(unit, units, 'hp');
  itemtemp.armor = getVal(unit, units, '减法护甲');
  itemtemp.slowspeed = getVal(unit, units, 'slowspeed');
  itemtemp.speed = getVal(unit, units, 'speed');
  itemtemp.sight = getVal(unit, units, '视野');
  const attackName=getVal(unit, units, 'skill_0_id');
  itemtemp.attack = getVal(attackName, skills, 'atk');

  itemtemp.attackSpeed = getVal(getVal(unit, units, 'skill_0_id'), skills, 'agi');
  itemtemp.distance = getVal(getVal(unit, units, 'skill_0_id'), skills, 'distance');
  itemtemp.upgradeSkill = [{}, {}];
  //升级技能
  for (i = 0; i < 2; i++) {
    itemtemp.upgradeSkill[i].name = getVal(`${item.cardName}${i + 1}`, constructions, '升级名字');
    itemtemp.upgradeSkill[i].introduction = getVal(`${item.cardName}${i + 1}`, constructions, '升级说明');
    itemtemp.upgradeSkill[i].icon = getVal(`${item.cardName}${i + 1}`, constructions, '升级图标');
    itemtemp.upgradeSkill[i].view = getVal(`${item.cardName}${i + 1}`, constructions, '升级示意图');
    itemtemp.upgradeSkill[i].cost = getVal(`${item.cardName}${i + 1}`, constructions, '信仰');
  }
  //商店价格
  itemtemp.bbbStarAmount=getGold(item.itemId,goods,'currencyAmount');
  itemtemp.goldAmount=getGold(item.itemId,goods,'goldAmount');
  //
  itemtemp.rankDescription=getGold(item.itemId,goods,'description')
  //皮肤
  const skinId=getKey(cardSkin,'cardId',item.cardName,'itemId');
  if(skinId){
    itemtemp.isSkin=true;
    itemtemp.skinName=getGold(skinId,goods,'name');
    itemtemp.skinBbbStarAmount=getGold(skinId,goods,'currencyAmount');
    itemtemp.skinGoldAmount=getGold(skinId,goods,'goldAmount');
  }
  else itemtemp.isSkin=false;
  //看板娘
  const live2DId=getKey(live2D,'cardID',item.cardName,'itemId');
  if(live2DId){
    itemtemp.isLive2D=true;
    itemtemp.live2DBbbStarAmount=getGold(live2DId,goods,'currencyAmount');
    itemtemp.live2DGoldAmount=getGold(live2DId,goods,'goldAmount');
  }
  else itemtemp.isLive2D=false;
  //
  itemtemp.category = '兵种';

  const outputName = item.cardName;
  if (outputName === undefined) {
    continue;
  }
  save(`${outputName}`, itemtemp);
}

//英雄
for (const item of heroes) {
  if (item.itemId) {
    let itemtemp = {
      id: []
    };
    itemtemp.id=item.gameID;
    itemtemp.face=item.face;
    itemtemp.name=item.unit;
    itemtemp.unitId=item.id;
    itemtemp.standingPicture=item.standingPicture;
    itemtemp.skillIcon=[];
    itemtemp.skillData=[{},{},{}];
    let skill=[];
    for (let i=0;i<3;i++){
      itemtemp.skillData[i].skillName=[];
      itemtemp.skillData[i].skillCost=[];
      itemtemp.skillData[i].skillDesc=[];
      itemtemp.skillData[i].cooldown=[];
      skill[i] = getItem( getVal(item.unit, units, `skill_${i+9}_id`),skills);
      itemtemp.skillIcon.push(skill[i].image);
      do {
        itemtemp.skillData[i].skillName.push(skill[i].name);
        itemtemp.skillData[i].skillCost.push(skill[i].mp);
        itemtemp.skillData[i].skillDesc.push(skill[i].技能介绍);
        itemtemp.skillData[i].cooldown.push(skill[i].cooldown);
        skill[i]=getItem(  skill[i].levelUp,skills);
        skill[i]=skill[i]||[];
      }while (skill[i].id);
    }

    const outputName = item.id;
    save(`${outputName}`, itemtemp);
  }
}

//翻译
const tips_描述 = load('data', 'tips_描述');
//描述id跟一般id有个区分
for (const item of tips_描述) {
  if (item.id !== null && item.id !== undefined) {
    item.id = item.id + '描述';
  }
}
const _locales = {
  system: load('locales', 'system'),
  constructions_短名: load('locales', 'constructions_短名'),
  constructions_全名: load('locales', 'constructions_全名'),
  constructions_升级名字: load('locales', 'constructions_升级名字'),
  constructions_升级说明: load('data', 'constructions_升级说明'),
  constructions_description: load('locales', 'constructions_description'),
  constructions_speech: load('locales', 'constructions_speech'),
  tips_名字: load('locales', 'tips_名字'),
  skills_name: load('locales', 'skills_name'),
  tips_描述: tips_描述,
  skills_技能介绍: load('data', 'skills_技能介绍'),
  wiki: load('wiki/wiki_Locales' )
};
for (let data of [...Object.values(_locales)]) {
  _.remove(data, item => item.id === null || item.id === undefined);
}

//冒险
for(let item of adventure_item){
  outputName=item['名字'];
  let itemtemp = {
    '类别': []
  };
  itemtemp['类别']=item['类别'];
  itemtemp['名字']=item['名字'];
  itemtemp['图标']=item['图标'];
  itemtemp['说明']=item['说明'];
  itemtemp['价格']=item['价格'];
  itemtemp['系数']=item['系数'];
  if(item['英雄限制'])
  itemtemp['英雄限制']=item['英雄限制'];
  if(item['分类'])
  //itemtemp['分类']=item['分类'].replace(/普通|稀有|后期/g, '').replace(/(.).*\1/g,"$1").split(',');
  item['分类'].split("，").forEach((item, index, array) => {
    if(item=="事件获取(固定)")itemtemp[`分类0`] = item
  });
  itemtemp['吐槽和俏皮话']=item['吐槽和俏皮话'];
  itemtemp['DLC']=item['DLC']?`终极审判`:'非DLC道具';
  itemtemp['Category']='冒险道具';
  //console.log(item);
  save(`item_1_${outputName}`, itemtemp);
}
//被动图标表
/*_.remove(tips, item => item.id === null || item.id === undefined);
for (let data of [...Object.values(tips)]) {
  delete data.描述;
  delete data.名字;
  delete data["技能？"];
  delete data["类型？"];
  if(data["大厅图标"]){
    data.大厅图标=data["大厅图标"].slice(10);
  }
}
const _tips={
  tips:tips
}*/

save('locales', _locales);
//save('tips',_tips);
save('version',version);



