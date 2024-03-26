/// A placeholder class that represents an entity or model.
class Item {
  const Item(this.id, this.text, this.icon, this.tagLst);
  final String text; // 文本内容
  final int id; //唯一标识符
  final String icon; //对话框头像
  final List<String> tagLst; //标签表
}
