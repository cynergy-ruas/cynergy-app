import 'package:flutter/material.dart';

class AddResourcesList extends StatefulWidget {

  /// the underlying data structure
  final List dataStructure;

  AddResourcesList({@required this.dataStructure});

  @override
  _AddResourcesListState createState() => _AddResourcesListState();
}

class _AddResourcesListState extends State<AddResourcesList> {

  List get dataStructure => widget.dataStructure;

  /// specifies whether the user is trying to add a link or not
  bool isAdding;

  /// The controller for the title
  TextEditingController _titleController;

  /// The controller for the url
  TextEditingController _urlController;

  @override
  void initState() {
    super.initState();

    isAdding = false;
    _titleController = TextEditingController();
    _urlController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    Widget header;

    if (isAdding) {
      // if user press add, change ui to text form fields
      header = ListView(
        shrinkWrap: true,
        children: <Widget>[
          Text("Resources", style: _textStyle(),),
          SizedBox(height: 20,),
          Text("Title", style: _textStyle(),),
          SizedBox(height: 20,),
          TextFormField(controller: _titleController, maxLines: 1),

          SizedBox(height: 20,),
          Text("Url", style: _textStyle(),),
          SizedBox(height: 20,),
          TextFormField(controller: _urlController, maxLines: 1,),

          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                color: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  setState(() {
                    isAdding = false;
                  });
                },
              ),
              FlatButton(
                child: Text("Done"),
                color: Color(0xffffd500),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  setState(() {
                    dataStructure.add({"title": _titleController.text, "url": _urlController.text}); 
                    isAdding = false;
                  });
                },
              )
            ],
          )
        ],
      );
    } else {
      // else change ui to add button
      header = Row(
        children: <Widget>[
          Expanded(
            child: Text("Resources", style: _textStyle(),),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffffd500),
              ),
              child: Icon(Icons.add, color: Colors.white,),
            ),
            onTap: () {
              setState(() {
                isAdding = true;
              });
            }
          )
        ],
      );
    }


    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: header,
        ),
        SizedBox(height: 20,),

        // The list view of links
        Container(
          height: 200,
          color: Color(0xff4c4c4c),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: dataStructure.length,
            itemBuilder: (BuildContext context, int position) {
              return Dismissible(
                child: _Tile(data: dataStructure[position]),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white,),
                ),
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                    dataStructure.removeAt(position);
                  });
                },
              );
            },
            separatorBuilder: (BuildContext context, int position) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              );
            },
          ),
        ),
      ],
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins"
    );
  }
}

class _Tile extends StatelessWidget {

  final Map<String, String> data;

  _Tile({@required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.link),
      title: Text(data["title"], style: _textStyle(),),
      subtitle: Text(data["url"], style: _textStyle(),),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins"
    );
  }
}