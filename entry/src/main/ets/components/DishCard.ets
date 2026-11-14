import { Dish } from '../model/FoodModels';
//整体被使用在Index103行

@Extend(Text)
function dishNameText() {
  .fontSize(16)
  .fontWeight(FontWeight.Medium)
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
}

@Component
export struct DishCard {

  // 菜品对象
  dish: Dish = {
    id: 0,
    name: '',
    emoji: '🍽️',
    price: 0,
    desc: ''
  };

  // 是否显示描述：父组件可以传 false 来隐藏
  showDesc: boolean = true;

  // 点击回调：
  // 默认值写成空函数，保证外部不传时点击也不会崩溃
  onSelect: (dish: Dish) => void = (dish: Dish) => {};

  // 价格格式化：默认返回 “￥价格”，Index第130行
  priceFormatter: (price: number) => string = (price: number) => `￥${price}`;

  // 成员函数 1：处理点击
  handleClick(): void {
    this.onSelect(this.dish);
  }

  // 成员函数 2：得到要显示的价格文本
  getPriceText(): string {
    return this.priceFormatter(this.dish.price);
  }

  //UI
  build() {
    Column() {
      //上半菜品 emoji
      Column() {
        Text(this.dish.emoji)
          .fontSize(40)
      }
      .width('100%')
      .height(90)
      .justifyContent(FlexAlign.Center)          // 让里面的 Emoji 居中
      .backgroundColor('#FFF3E6')
      .borderRadius({ topLeft: 16, topRight: 16 }) // 只圆上面两个角

      //下半：菜名、描述、价格
      Column() {
        // 菜名：使用 @Extend 扩展的样式
        Text(this.dish.name)
          .dishNameText()
          .margin({ top: 8 })

        // 描述：由showDesc 成员变量控制显示/隐藏
        if (this.showDesc) {
          Text(this.dish.desc)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 4 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }

        // 弹簧组件：把价格顶到底部
        Blank()

        Row() {
          Text(this.getPriceText())// 价格调用成员函数
            .fontSize(16)
            .fontColor('#FF6B00')
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .margin({ top: 6 })
      }
      .width('100%')
      .layoutWeight(1)                       // 占据下半部分剩余的所有高度
      .padding(10)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(170)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: '#10000000',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      // 点击时调用成员函数，而不是直接写跳转逻辑
      this.handleClick();
    })
  }
}