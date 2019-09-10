# thbbbwiki
用于更新[东方大战争灰机维基](https://thbbb.huijiwiki.com/wiki/首页)<br>
### 开始
打包生成更新日志用的json文件<br>
运行前需要修改`migrate-wiki.js`中第5行的版本号
```bash
# 安装依赖模块
npm install

# 打包生成更新日志用的json文件
npm run migrate-log
```
会生成临时文件夹wikidata，可用[wiki数据更新器](https://www.huijiwiki.com/wiki/%E5%B8%AE%E5%8A%A9:%E7%81%B0%E6%9C%BAWiki%E6%95%B0%E6%8D%AE%E6%9B%B4%E6%96%B0%E5%99%A8)将这个文件夹传到维基上。<br>
<br>
scripts文件夹存放是维基用的lua脚本。