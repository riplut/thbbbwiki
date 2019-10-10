// const version = require('./migrate-wiki');
const version={ version: 20190929 };
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
const publishedCard = load('lobby/publishedCard');
const heroes = load('heroes','heroes');

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

function getVal(cardID, data, _key) {
  for (const item of data) {
    if (item.id === cardID) {
      return item[_key];
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
  //特性
  let i = 0;
  for (let index = 0; index < 12; index++) {
    const key = `特性${index}`;
    if (getVal(item.cardName, constructions, key) !== undefined || null) {
      itemtemp.features[i] = getVal(item.cardName, constructions, key);
      ++i;
    }
  }
  itemtemp.hp = getVal(item.cardName, constructions, '血量');
  itemtemp.armor = getVal(item.cardName, constructions, '护甲');
  const unit=getVal(item.cardName, constructions, 'unit');
  itemtemp.slowspeed = getVal(unit, units, 'slowspeed');
  itemtemp.speed = getVal(unit, units, 'speed');
  itemtemp.sight = getVal(unit, units, '视野');
  itemtemp.attack = getVal(item.cardName, constructions, '攻击');

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
  if (item.gameId <= 5) {
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

save('locales', _locales);
save('version',version);
