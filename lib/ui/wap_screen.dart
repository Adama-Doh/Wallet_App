import 'package:flutter/material.dart';
import 'package:wap/model/wap_item.dart';
import 'package:wap/util/database_client.dart';

class WapScreen extends StatefulWidget {
  @override
  _WapScreenState createState() => _WapScreenState();
}

class _WapScreenState extends State<WapScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var db = DatabaseHelper();
  final List<WapItem> _itemList = <WapItem>[];

  @override
  void initState() {
    super.initState();
    _readWapList();
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();

    WapItem wapItem = WapItem(text, DateTime.now().toIso8601String());
    int savedItemId = await db.saveItem(wapItem);

    // print("Item saved id: $savedItemId");

    WapItem addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black87,
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(8),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  return Card(
                    color: Colors.black26,
                    child: ListTile(
                      title: _itemList[index],
                      onLongPress: () => {},
                      trailing: Listener(
                        key: Key(_itemList[index].itemName),
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPointerDown: (pointerEvent) => debugPrint(""),
                      ),
                    ),
                  );
                }),
          ),
          Divider(height: 1.0),
        ],
      ),

      floatingActionButton: FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: ListTile(
            title: Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Item",
                hintText: "somrthing goes here",
                icon: Icon(Icons.note_add)),
          ))
        ],
      ),
      actions: [
        FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readWapList() async {
    List items = await db.getItems();
    items.forEach((item) {
      WapItem wapItem = WapItem.map(item);
      setState(() {
        _itemList.add(WapItem.map(item));
      });
      print("Db items: ${wapItem.itemName + " " + wapItem.dateCreated}");
    });
  }
}
