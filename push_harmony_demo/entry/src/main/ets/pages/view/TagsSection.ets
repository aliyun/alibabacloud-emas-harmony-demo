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

import { TagInfo } from "../../common/TagInfo"

@Component
export struct TagsSection {
  private itemHeight = 36
  private itemGap = 8
  private maxShowItems = 9
  private maxColumn = 3
  @Prop title: string = ''
  @Link @Watch('didChangeDataSources') dataSources: TagInfo[]
  @State gridHeight: number = this.itemHeight
  onClickShowAll: () => void = () => {
  }
  onClickDeleteItem: (item: TagInfo) => void = () => {
  }

  getDisPlayDataSources() {
    let tags = this.dataSources.slice(0, this.maxShowItems)
    return tags
  }

  didChangeDataSources() {
    this.calculationGridHeight()
  }

  calculationGridHeight() {
    const cell = Math.ceil(this.getDisPlayDataSources().length / this.maxColumn)
    if (cell > 0) {
      this.gridHeight = cell * this.itemHeight + (cell - 1) * this.itemGap
    }
  }

  aboutToAppear(): void {
    this.calculationGridHeight()
  }

  build() {
    Column() {
      Row() {
        Text(this.title)
          .font({
            size: 14,
            weight: 400
          })
          .fontColor('#999CA3')

        if (this.dataSources.length > this.maxShowItems) {
          Row() {
            Text('查看全部')
              .font({
                size: 12,
                weight: 400
              })
              .fontColor('#999CA3')

            Image($r('app.media.ic_arrow_right_gray'))
              .width(16)
              .height(16)
              .objectFit(ImageFit.Contain)
          }
          .alignItems(VerticalAlign.Center)
          .onClick(this.onClickShowAll)
        }
      }
      .margin({
        bottom: 12
      })
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Grid() {
        ForEach(this.getDisPlayDataSources(), (item: TagInfo) => {
          GridItem() {
            Row() {
              Text(item.name)
                .font({
                  size: 14,
                  weight: 400
                })
                .fontColor('#424FF7')
                .maxLines(1)
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
                .constraintSize({
                  maxWidth: '85%'
                })

              Image($r('app.media.ic_delete'))
                .width(12)
                .height(12)
                .objectFit(ImageFit.Contain)
                .onClick(() => {
                  this.onClickDeleteItem(item)
                })
            }
            .borderRadius(4)
            .backgroundColor('#F0F1FE')
            .width('100%')
            .height(this.itemHeight)
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              left: 8,
              right: 8
            })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(this.itemGap)
      .rowsGap(this.itemGap)
      .width('100%')
      .height(this.gridHeight)
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .padding(16)
  }
}