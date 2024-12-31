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

@Component
export struct AliasListView {
  navPathStack?: NavPathStack
  aliasArray: string[] = []
  onSelect: (value: string) => void = () => {
  }

  build() {
    NavDestination() {
      RelativeContainer() {
        this.navBarBuilder()

        Text('别名列表')
          .font({
            size: 18,
            weight: 500
          })
          .fontColor('#1F2024')
          .margin({
            top: 32
          })
          .id('aliasText')
          .alignRules({
            top: {
              anchor: "aliasTitle",
              align: VerticalAlign.Bottom
            },
            left: {
              anchor: "__container__",
              align: HorizontalAlign.Start
            },
          })
          .margin({
            top: 32,
            left: 16
          })

        List() {
          ForEach(this.aliasArray, (alias: string) => {
            ListItem() {
              this.cellBuilder(alias, () => {
                this.onSelect(alias)
                this.navPathStack?.pop()
              })
            }
          })
        }
        .alignRules({
          top: {
            anchor: "aliasText",
            align: VerticalAlign.Bottom
          },
          left: {
            anchor: "__container__",
            align: HorizontalAlign.Start
          },
          right: {
            anchor: "__container__",
            align: HorizontalAlign.End
          },
          bottom: {
            anchor: "__container__",
            align: VerticalAlign.Bottom
          },
        })
        .margin({
          top: 16,
          bottom: 20
        })
        .alignListItem(ListItemAlign.Start)
      }
      .backgroundColor(Color.White)
      .width('100%')
      .height('100%')
      .padding({
        bottom: 20
      })
      .borderRadius({
        topLeft: 12,
        topRight: 12
      })
    }
    .hideTitleBar(true)
    .onReady((ctx) => {
      this.navPathStack = ctx.pathStack
    })
    .backgroundColor(Color.Transparent)
  }

  @Builder
  cellBuilder(text: string, onClick: () => void) {
    Column() {
      Text(text)
        .font({
          size: 16,
          weight: 400
        })
        .fontColor('#4B4D52')
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .maxLines(1)

      Divider()
        .vertical(false)
        .strokeWidth(0.5)
        .color('#E6E8EB')
        .margin({
          top: 16
        })
    }
    .height(52)
    .width('100%')
    .padding({
      left: 16,
      right: 16
    })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .onClick(onClick)
  }

  @Builder
  navBarBuilder() {
    Text('别名标签')
      .font({
        size: 18,
        weight: 600
      })
      .fontColor('#4B4D52')
      .alignRules({
        top: {
          anchor: "__container__",
          align: VerticalAlign.Top
        },
        middle: {
          anchor: "__container__",
          align: HorizontalAlign.Center
        },
      })
      .id('aliasTitle')
      .height(25)
      .margin({
        top: 20
      })

    Image($r('app.media.ic_back'))
      .width(24)
      .height(24)
      .objectFit(ImageFit.Contain)
      .onClick(() => {
        this.navPathStack?.pop()
      })
      .alignRules({
        center: {
          anchor: "aliasTitle",
          align: VerticalAlign.Center
        },
        left: {
          anchor: "__container__",
          align: HorizontalAlign.Start
        },
      })
      .id('aliasBackImage')
      .margin({
        left: 8
      })
  }
}