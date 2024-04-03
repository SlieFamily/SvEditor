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
  int textSpeed = 1;
  int textFontSize = 1;
  List<double> textP = [0, 0, 0];

  String code = //代码段
      '文本,点击触发,串行,头像,1;1;0;,本马 秀和,说起来，今晚赚了不少金币来着。,34,灰_D01_A01_本马_平常.png,30';

  Item.withParam(
      {this.text = "请输入脚本",
      this.id = -1,
      this.icon = "粉_B01_A01_心弥_平常.png",
      this.tag = '未知'});
}
