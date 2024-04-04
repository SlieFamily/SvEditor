/// A placeholder class that represents an entity or model.
class Item {
  String text; // 文本内容
  int id; //唯一标识符
  String icon; //对话框头像
  String tag; //标签表
  bool isClick = true; //是否点击触发
  bool ctlStream = true; //默认串行

  // 文本类选项
  String textStyle = "旁白";
  String textRole = "";
  int textSpeed = 30; //每秒弹出的字数
  int textFontSize = 34; //字号大小，1-100
  double textTime = 0.5; //透明度变化时间
  List<double> textP = [0, 1];

  // 镜头类选项
  String camera = "恢复正常";
  double shine = 0.5;

  // 滤镜类选项
  String filter = "无滤镜";

  // 立绘层选项
  String liveState = "选中图片";
  String livePath = "A04_A04_时乃_装傻.png";
  int liveRock = 0;
  String liveName = "abc";
  List<Map<String, String>> liveCache = [
    {"nike": "abc", "path": "粉_B01_A01_心弥_平常.png"},
    {"nike": "def", "path": "A04_A04_时乃_装傻.png"}
  ];
  List<double> liveScale = [1, 1];
  double liveScaleTime = 0;
  List<double> liveMove = [0, 0, 0, 0];
  double liveMoveTime = 0;
  List<double> liveRGB = [0, 0, 0];

  String code = //代码段
      '文本,点击触发,串行,头像,1;1;0;,本马 秀和,说起来，今晚赚了不少金币来着。,34,灰_D01_A01_本马_平常.png,30';

  Item.withParam(
      {this.text = "El Psy Kongroo!",
      this.id = -1,
      this.icon = "粉_B01_A01_心弥_平常.png",
      this.tag = '文本'});
}
