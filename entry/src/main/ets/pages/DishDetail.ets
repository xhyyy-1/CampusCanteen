import { router, promptAction } from '@kit.ArkUI'; // 引入 router 和 promptAction

@Entry
@Component
struct DishDetail {
  // 状态变量：接收传过来的菜名和价格
  @State dishName: string = '未知菜品';
  @State price: number = 0;

  // 页面出现时接收传过来的参数（第四次实验已有）
  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      const name = params['name'] as string;
      const price = params['price'] as number;
      if (name) {
        this.dishName = name;
      }
      if (price !== undefined) {
        this.price = price;
      }
    }
  }

  build() {
    Column() {
      // 顶部返回栏
      Row() {
        Text('返回')
          .fontSize(18)
          .fontColor(Color.White)
          .onClick(() => {
            router.back(); // 返回上一页（Index）
          })
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FF8C42')

      // 内容展示
      Column() {
        Text('🍽️')
          .fontSize(80)
          .margin({ top: 60, bottom: 20 })

        Text(`您选择了：${this.dishName}`)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })

        Text(`价格：￥${this.price}`)
          .fontSize(20)
          .fontColor('#FF6B00')

        // “我要下单”按钮及弹窗
        Button('我要下单')
          .width('80%')
          .height(45)
          .margin({ top: 50 })
          .backgroundColor('#FF8C42')
          .onClick(() => {
            // 对话框组件：确认是否下单
            AlertDialog.show({
              title: '下单确认',
              message: `您已选择菜品：\n${this.dishName}\n总价：￥${this.price}\n\n是否确认下单？`,
              primaryButton: { // 取消按钮
                value: '取消',
                action: () => {
                  console.info('用户取消了操作');
                }
              },
              secondaryButton: { // 确认按钮
                value: '确认下单',
                action: () => {
                  promptAction.showToast({ message: '下单成功！' });
                  router.back(); // 提示后返回首页
                }
              }
            });
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F7')
  }
}