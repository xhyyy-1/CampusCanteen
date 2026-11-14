// 接口
// 菜品数据模型
export interface Dish {
  id: number;      // 编号：ForEach 的 key，用来区分每一项
  name: string;    // 菜名
  emoji: string;   // 菜的图标
  price: number;   // 价格
  desc: string;    // 描述
}

// 轮播图数据模型
export interface BannerItem {
  id: number;
  title: string;
  subTitle: string;
  emoji: string;
  bgColor: string; // 每张轮播图的背景色
}

// 底部导航数据模型
export interface TabItem {
  id: number;
  name: string;
  icon: string;
}

// 页面跳转时传给 DishDetail 的数据格式
export interface RouterParams {
  name: string;
  price: number;
}

// 登录成功后传给首页的数据格式
export interface LoginParams {
  name: string;       // 学生姓名
  studentId: string;  // 学号
}