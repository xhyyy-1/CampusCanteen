@Component
export struct SectionHeader {//Index第259行
  // 成员变量
  title: string = '';// 标题文字
  count: number = 0;// 数量
  countUnit: string = '道';// 数量单位

  // @BuilderParam：声明一个“UI插槽”
  @BuilderParam extraBuilder: () => void = this.defaultExtra;

  // 默认UI：什么都不显示
  @Builder
  defaultExtra() {
    Text('')
      .width(0)
      .height(0)
  }

  // 成员函数：根据 count 和 countUnit 拼出“共X道”
  getCountText(): string {
    return `共${this.count}${this.countUnit}`;
  }

  build() {
    Row() {
      // 左边：标题
      Text(this.title)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)

      // 中间：弹簧，把后面的内容推到右边
      Blank()

      // 数量文字
      Text(this.getCountText())
        .fontSize(12)
        .fontColor('#999999')

      //用外部传进来的UI，Index第239行
      this.extraBuilder()
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 20, bottom: 10 })
  }
}