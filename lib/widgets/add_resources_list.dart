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

  /// key for add link form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    isAdding = false;
    _titleController = TextEditingController();
    _urlController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    Widget header = Row(
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
            _titleController.clear();
            _urlController.clear();
            _showDialog(context);
          }
        )
      ],
    );

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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.arrow_back_ios, color: Colors.black,),
                      SizedBox(width: 10,),
                      Text("Back", style: _textStyle(color: Colors.black))
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Title", style: _textStyle(),),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _titleController,
                      maxLines: 1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Title cannot be empty";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20,),
                    Text("Url", style: _textStyle(),),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _urlController, 
                      maxLines: 1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Url cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20) 
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Done", style: _textStyle(color: Colors.black)),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffffd500)
                        ),
                        child: Icon(Icons.arrow_forward, color: Colors.white,)
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    dataStructure.add({"title": _titleController.text, "url": _urlController.text});
                    setState((){});
                    Navigator.pop(context);
                  }
                }
              )
            ],
          ),
        );
      }
    );
  }

  TextStyle _textStyle({Color color}) {
    return TextStyle(
      color: color,
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