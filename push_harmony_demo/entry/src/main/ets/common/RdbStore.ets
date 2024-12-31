/**
 MIT License

 Copyright (c) 2024 Alibaba Cloud

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { TagInfo, TagsType } from './TagInfo';

const TABLE_TAGS_INFO = 'TAGS_INFO'
const COL_ID = 'ID'
const COL_NAME = 'NAME'
const COL_TYPE = 'TYPE'
const COL_ACCOUNT = 'ACCOUNT'
const COL_ALIAS = 'ALIAS'

const SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS ${TABLE_TAGS_INFO} (`
  + `${COL_ID} INTEGER PRIMARY KEY AUTOINCREMENT, `
  + `${COL_NAME} TEXT NOT NULL,`
  + `${COL_TYPE} INTEGER,`
  + `${COL_ALIAS} TEXT,`
  + `${COL_ACCOUNT} TEXT`
  + `)`

const VERSION = 1

const COLUMNS = [
  COL_ID,
  COL_NAME,
  COL_TYPE,
  COL_ALIAS,
  COL_ACCOUNT
]

export class RdbStore {
  private context: common.UIAbilityContext
  private storeConfig: relationalStore.StoreConfig

  constructor(context: common.UIAbilityContext) {
    this.context = context
    this.storeConfig = {
      name: 'demo.db',
      securityLevel: relationalStore.SecurityLevel.S3,
      encrypt: false,
      customDir: 'aliyunPush'
    }
  }

  getRdbStore(succeedCallback: (store: relationalStore.RdbStore) => void) {
    relationalStore.getRdbStore(this.context, this.storeConfig, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`Succeeded in getting RdbStore. store.version: ${store.version}`);

      if (store.version === 0) {
        store.executeSql(SQL_CREATE_TABLE, (err) => {
          if (err) {
            console.error(`Failed to execute Sql. Code:${err.code}, message:${err.message}`);
            return
          }
          store.version = VERSION
          succeedCallback(store)
        })
        return;
      }

      succeedCallback(store)
    })
  }

  insertTag(info: TagInfo, account?: string) {
    const valueBucket: relationalStore.ValuesBucket = {
      NAME: info.name,
      TYPE: info.type.valueOf(),
      ALIAS: info.alias ?? '',
      ACCOUNT: account ?? ''
    };

    this.getRdbStore((store) => {
      store.insert(TABLE_TAGS_INFO, valueBucket, (err, rowId) => {
        if (err) {
          console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`Succeeded in inserting data. rowId:${rowId}`);
      })
    })
  }

  deleteTag(info: TagInfo, account?: string) {
    const predicates = new relationalStore.RdbPredicates(TABLE_TAGS_INFO);
    predicates.equalTo(COL_NAME, info.name)
      .and()
      .equalTo(COL_TYPE, info.type.valueOf())

    if (info.type == TagsType.accountTags
      && (account?.length ?? 0) > 0) {
      predicates.and()
        .equalTo(COL_ACCOUNT, account)
    } else if (info.type == TagsType.aliasTags
      && (info.alias?.length ?? 0) > 0) {
      predicates.and()
        .equalTo(COL_ALIAS, info.alias)
    }
    this.getRdbStore((store) => {
      store.delete(predicates, (err, rows) => {
        if (err) {
          console.error(`Failed to delete data. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`Delete rows: ${rows}`);
      })
    })
  }

  queryTag(type: TagsType, succeedCallback: (tags: TagInfo[]) => void, account?: string) {
    const predicates = new relationalStore.RdbPredicates(TABLE_TAGS_INFO);
    predicates.equalTo(COL_TYPE, type.valueOf());
    if ((account?.length ?? 0) > 0) {
      predicates.and()
        .equalTo(COL_ACCOUNT, account)
    }
    let tags: TagInfo[] = []
    this.getRdbStore((store) => {
      store.query(predicates, COLUMNS, (err, resultSet) => {
        if (err) {
          console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
        while (resultSet.goToNextRow()) {
          const id = resultSet.getLong(resultSet.getColumnIndex(COL_ID));
          const name = resultSet.getString(resultSet.getColumnIndex(COL_NAME));
          const type = resultSet.getLong(resultSet.getColumnIndex(COL_TYPE));
          const alias = resultSet.getString(resultSet.getColumnIndex(COL_ALIAS));
          const account = resultSet.getString(resultSet.getColumnIndex(COL_ACCOUNT));
          console.info(`id=${id}, name=${name}, type=${type}, alias=${alias}, account=${account}`);
          tags.unshift({
            name: name,
            type: type as TagsType,
            alias: alias,
          });
        }
        resultSet.close();
        succeedCallback(tags)
      })
    })
  }
}