const fs = require('fs');
const xlsx = require('xlsx');
const Papa = require('papaparse');
const _ = require('lodash');
const path = require('path');
const version=20190923;//版本号
module.exports.version = version;
function loadlog(filename, sheetname) {
    const dir = path.join('database', 'changelog');
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
    let changelog={};
    changelog.changeData=result;
    changelog.version=filename.replace(/[^0-9]/ig,"");
    changelog.category='更新日志';
    return changelog;
}
function save(filename, data){
    const dir = 'wikidata';
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir);
    }
    fs.writeFileSync(`${dir}/${filename}.json`, JSON.stringify(data, null, 2));
}


const changelog=loadlog(`changelog(${version})`);
save(`${changelog.version}`,changelog);
