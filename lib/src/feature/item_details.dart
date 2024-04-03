import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'item.dart';

class ItemDetails extends StatefulWidget {
  final Item item;
  const ItemDetails({super.key, required this.item});
  static const routeName = '/item';
  @override
  State<ItemDetails> createState() => _ItemDetailsCfg();
}

class _ItemDetailsCfg extends State<ItemDetails> {
  late final Item _item;
  _ItemDetailsCfg();

  @override
  void initState() {
    super.initState();
    _item = widget.item; // 获取传递的item对象
    // 初始化时尝试从文件加载配置
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    // 从本地存储或其他持久化位置加载配置
    // final savedConfig = await loadFromFileSystem();
    // setState(() {
    //   _configuration = savedConfig ?? UserConfiguration.defaultConfig();
    // });
  }

  // ...其他方法，如保存配置到文件系统
  Future<void> _saveConfig() async {
    // 将_configuration保存到指定目录下
    // await saveToFileSystem(_configuration);
  }

  // 触发方式决策
  // ignore: non_constant_identifier_names
  Widget _IsClick(Item item) {
    return CupertinoSlidingSegmentedControl(
        //子标签
        children: const <bool, Widget>{
          true: Row(children: [Icon(Icons.ads_click_rounded), Text("点击触发")]),
          false:
              Row(children: [Icon(Icons.autofps_select_rounded), Text("无条件触发")])
        },
        //当前选中的索引
        groupValue: item.isClick,
        //点击回调
        onValueChanged: (bool? index) {
          setState(() {
            item.isClick = index!;
          });
        });
  }

  // 串并行决策
  // ignore: non_constant_identifier_names
  Widget _CtlStream(Item item) {
    return CupertinoSlidingSegmentedControl(
        //子标签
        children: const <bool, Widget>{
          false: Row(children: [Icon(Icons.line_axis_rounded), Text("并行")]),
          true: Row(children: [Icon(Icons.linear_scale_rounded), Text("串行")])
        },
        //当前选中的索引
        groupValue: item.ctlStream,
        //点击回调
        onValueChanged: (bool? index) {
          setState(() {
            item.ctlStream = index!;
          });
        });
  }

  // 标志选择
  // ignore: non_constant_identifier_names
  Widget _TagSelected(Item item) {
    List<Tuple2<String, Widget>> tags = const [
      Tuple2("文本", Icon(Icons.text_snippet_outlined)),
      Tuple2("镜头", Icon(Icons.camera_indoor_outlined)),
      Tuple2("滤镜", Icon(Icons.screenshot_monitor_rounded)),
      Tuple2("立绘", Icon(Icons.person_pin)),
      Tuple2("图片", Icon(Icons.image)),
      Tuple2("UI", Icon(Icons.app_registration_rounded)),
      Tuple2("背景", Icon(Icons.imagesearch_roller_outlined)),
      Tuple2("BGM", Icon(Icons.music_note_rounded)),
      Tuple2("SE", Icon(Icons.library_music_outlined)),
      Tuple2("程序", Icon(Icons.code_rounded)),
      Tuple2("特殊", Icon(Icons.new_releases_outlined)),
    ];

    return SizedBox(
        height: 300, // 限定高度
        child: ListView(
          shrinkWrap: true, // 防止超出屏幕高度
          children: tags.map((option) {
            return RadioListTile<String>(
              title: Row(children: [option.item2, Text(option.item1)]),
              value: option.item1,
              groupValue: item.tag,
              onChanged: (value) {
                setState(() {
                  item.tag = value!;
                });
              },
            );
          }).toList(),
        ));
  }

  // 文本设置
  Widget textSetting(Item item) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 使两端对齐
        children: [
          Column(
            children: [
              Text(
                item.icon,
                style: const TextStyle(color: Colors.black54, fontSize: 12.0),
              ),
              const SizedBox(height: 15),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/${item.icon}'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(4), // 可选，添加圆角
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedAvatar = await showAvatarPickerDialog(context);
                  if (selectedAvatar != null) {
                    setState(() {
                      item.icon = selectedAvatar;
                    });
                  }
                },
                child: const Text('更换头像'),
              ),
            ],
          ),
          const SizedBox(width: 100), // 添加间距
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("文本框样式"),
                    const SizedBox(width: 20),
                    Expanded(
                      child: // 为了让DropdownButtonFormField自动调整宽度
                          DropdownButton<String>(
                        value: item.textStyle,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            item.textStyle = value!;
                          });
                        },
                        items: const ['旁白', '台词', '头像']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(), // 下拉菜单项
                      ),
                    ),
                    const SizedBox(width: 100),
                    const Text("角色名"),
                    const SizedBox(width: 20),
                    Expanded(
                        child: TextFormField(
                      initialValue: item.textRole,
                      onChanged: (textRole) {
                        setState(() {
                          item.textRole = textRole;
                        });
                      },
                      // enabled: false, // 若为只读文本框，禁用编辑
                    )),
                  ],
                ),
                const SizedBox(height: 40),
                Row(children: [
                  Expanded(
                      child: Column(children: [
                    TextField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Text Speed',
                        labelText: '弹字速度',
                      ),
                      controller:
                          TextEditingController(text: '${item.textSpeed}'),
                      onChanged: (value) {
                        setState(() {
                          item.textSpeed = int.tryParse(value)!;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TextField(
                        maxLines: 1, // 设置最小行数
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Text FontSize',
                          labelText: '字号大小',
                        ),
                        controller:
                            TextEditingController(text: '${item.textFontSize}'),
                        onChanged: (value) {
                          setState(() {
                            item.textSpeed = int.tryParse(value)!;
                          });
                        }),
                  ])),
                  const SizedBox(width: 20),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildSliderRow(item, 0, '透明度A', 0, 100, 50),
                      const SizedBox(height: 3),
                      _buildSliderRow(item, 1, '透明度B', 0, 100, 25),
                      const SizedBox(height: 3),
                      _buildSliderRow(item, 2, '透明度C', 0, 100, 75),
                    ],
                  )),
                ])
              ],
            ),
          )

          // const SizedBox(width: 100), // 添加间距

          // const SizedBox(width: 20),
        ],
      ),
      const SizedBox(height: 18),
      TextField(
        maxLines: 4, // 自动适应多行
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Text Input',
          labelText: '输入文本',
        ),
        controller: TextEditingController(text: item.text),
        onChanged: (value) {
          setState(() {
            item.text = value;
          });
        },
      ),
    ]);
  }

  // 头像预览弹窗
  Future<String?> showAvatarPickerDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('选择头像'),
          children: [
            "粉_B01_A01_心弥_平常.png",
            "粉_B02_A01_铃羽_微笑.png",
            "flutter_logo.png"
          ].map((avatarName) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, avatarName),
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/$avatarName'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(4), // 可选，添加圆角使其看起来更美观
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // 透明度变化条
  Widget _buildSliderRow(Item item, int key, String label, double min,
      double max, double initValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Expanded(
          child: Slider(
            value: item.textP[key],
            min: min,
            max: max,
            onChanged: (newValue) {
              setState(() {
                item.textP[key] = newValue;
              });
            },
            activeColor: Theme.of(context).primaryColor,
          ),
        ),
        Text('${item.textP[key].round()}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('本行详情'),
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧全局设置
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        _TagSelected(_item),
                        const SizedBox(height: 10),
                        _CtlStream(_item),
                        const SizedBox(height: 10),
                        _IsClick(_item),
                      ])),
                ),
              ),

              // 右侧详细配置
              Expanded(
                flex: 3, // 按照1:3的比例分配宽度
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: textSetting(_item), //Text("???"), //
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25), // 添加间距

          // 代码段显示
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                maxLines: null, // 自动适应多行
                readOnly: true,
                showCursor: false, // 隐藏光标
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Sample code snippet',
                  labelText: 'Line Code Preview',
                ),
                controller: TextEditingController(text: _item.code),
              ),
            ),
          ),

          // 图片预览
          // Image.asset('assets/images/${_item.icon}'),
          // 音乐预览，这里仅作示意，实际可能需要使用audio_service等包来处理音频播放
          // RaisedButton(
          //   onPressed: () {
          //     // playMusic(_configuration.musicUrl);
          //   },
          //   child: const Text('播放音乐'),
          // ),
          // 其他设置项...
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveConfig,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget switchPage(Item item) {
    return textSetting(item);
  }
}
