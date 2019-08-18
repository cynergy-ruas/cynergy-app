import 'package:flutter/material.dart';

class HomeTabView extends StatefulWidget{

  final int initialPage;  // index of the initial page
  final int length;  // total number of tabs
  final List<Widget> pages;  // list containing the page contents
  final List<CustomTab> tabs;  // list containing the tabs
  final double padding;  // padding between each tab

  HomeTabView({@required this.length, @required this.tabs, @required this.pages, this.initialPage = 0, this.padding = 0});

  @override
  _HomeTabViewState createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {

  int length;  // the total number of tabs
  double padding;  // padding between each tab
  List<Widget> pages;  // the list containing the page contents
  List<CustomTab> tabs;  // the list containing the tabs

  PageController _controller;

  @override
  void initState() {
    super.initState();
    print("Init state");
    length = widget.length;
    padding = widget.padding;
    pages = widget.pages;
    tabs = widget.tabs;

    tabs[widget.initialPage].isSelected = true; // marking the currently viewed page as selected
    _controller = PageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> wrappedTabs = [];
    for (int i=0;i<length;i++) {
      // wrapping each tab around an animated switcher and inkwell
      // the core part is the [onTap] of the inkwell. it 'deselects'
      // the previously selected tab, 'selects' the new tab,
      // changes the page in [PageView] and calls [setState] to render 
      // the tabs again.
      wrappedTabs.add(
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: InkWell(
            key: UniqueKey(),
            child: tabs[i],
            onTap: () {
              tabs[_controller.page.toInt()].isSelected = false;
              tabs[i].isSelected = true;
              _controller.animateToPage(i, duration: Duration(milliseconds: 750), curve: Curves.easeInOutQuint);
              setState(() {});
            },
          ),
        )
      );

      if (padding != 0) {
        // if padding is not zero, add a [SizedBox] with width = padding
        wrappedTabs.add(SizedBox(width: padding,));
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // the tabs
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 24,),
          ] + wrappedTabs,
        ),
        SizedBox(height: 8,),
        Flexible(
          child: PageView(
            physics: new NeverScrollableScrollPhysics(),
            controller: _controller,
            children: pages,
          ),
        )
      ],
    );
  }
}

class CustomTab extends StatefulWidget {

  final String text;

  CustomTab({Key key, @required this.text}) : 
    super(key: key);
    bool isSelected = false;

  @override
  _CustomTabState createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {

  String get text => widget.text;
  bool get isSelected => widget.isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // the name of the tab
          Text(
            text, 
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500
            )
          ),
          // the underline part
          Container(
            height: 6,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isSelected ? Color(0xFFFF5A1D) : Colors.white
            ),
          )
        ],
      ),
    );
  }
}