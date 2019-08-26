import 'package:cynergy_app/bloc/data_load_bloc.dart';
import 'package:cynergy_app/pages/events_page.dart';
import 'package:cynergy_app/services/events_handler.dart';
import 'package:cynergy_app/widgets/home_page_dots.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  static final routeName = "/events";

  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  /// The bloc that handles the loading of events
  DataLoadBloc _eventsBloc;

  /// The events handler
  EventsHandler _handler;

  /// The page controller for the Home Page
  PageController _pageController;

  /// The current page to be displayed. used for the bottom 
  /// navigation bar
  int _currentIndex = 0;

  @override
  void initState() {
    _handler = EventsHandler();
    _eventsBloc = DataLoadBloc(handler: _handler);
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*
    Events page.

    Returns:
      Scaffold: The home page contents.
    */

    List pages = [
      buildHome(),
      EventsPage(eventsBloc: _eventsBloc,),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff373737),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Container()
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Container()
          )
        ],
        selectedIconTheme: IconThemeData(color: Theme.of(context).accentColor),
        unselectedIconTheme: IconThemeData(color: Color(0xff9f9f9f)),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        child: pages[_currentIndex],
      ),
    );
  }

  Widget buildHome() {
    /**
     * Builds the Home page contents.
     * 
     * Returns
     *  Widget: The home page contents.
     */
    
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                page1(context),
                page2(context)
              ],
            )
          ),
        ),
        Center(
          child: HomePageDots(controller: _pageController,)
        )
      ],
    );
  }

  Widget page1(BuildContext context) {
    /**
     * Build the first page in the page view.
     * 
     * Returns:
     *  Widget: The contents.
     */
    
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: height * 0.07,),
          Text(
            "Hi, this is Cynergy !",
            style: _style(fontSize: 28,),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Divider(
              color: Colors.white,
            ),
          ),
          Text(
            "Bigger, Better, Open Source and Free for all.",
            style: _style(fontSize: 14, color: Theme.of(context).disabledColor),
          ),
          SizedBox(height: height * 0.3,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Always code as if the guy who ends up maintaining your code will be a violent "
              "psychopath who knows where you live.\n\n~ John Woods",
              textAlign: TextAlign.left,
              style: _style(fontSize: 14, color: Theme.of(context).disabledColor),
            ),
          )
        ],
      )
    );
  }

  Widget page2(BuildContext context) {

    /**
     * Build the second page in the [PageView].
     * 
     * Returns:
     *  Widget: The contents.
     */

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 70),
            child: Text(
              "What is Cynergy?",
              style: _style(fontSize: 28)
            )
          ),

          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 40, left: 10, right: 10),
            child: Text(
              "Cynergy is the first of its kind coding club at RUAS. The purpose of Cynergy is embodied in "
              "its core open principles - Collaboration, Innovation and Competition. Cynergy is a platform "
              "to promote learning and development of programming skills through activities like Hackathons "
              "and Share sessions.",
              textAlign: TextAlign.center,
              style: _style(fontSize: 16, color: Theme.of(context).disabledColor, height: 1.15),
            ),
          ),

          // the grid part
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.white),
                        bottom: BorderSide(color: Colors.white)
                      ),
                    ),
                    height: height * 0.15,
                    width: width * 0.4,
                    child: Center(
                      child: Text(
                        "Collaborate",
                        style: _style(fontSize: 16)
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white)
                      ),
                    ),
                    height: height * 0.15,
                    width: width * 0.4,
                    child: Center(
                      child: Text(
                        "Compete",
                        style: _style(fontSize: 16)
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.white),
                      ),
                    ),
                    height: height * 0.15,
                    width:width * 0.4,
                    child: Center(
                      child: Text(
                        "Innovate",
                        style: _style(fontSize: 16)
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.15,
                    width: width * 0.4,
                    child: Center(
                      child: Text(
                        "Open",
                        style: _style(fontSize: 16)
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      )
    );
  }

  TextStyle _style({@required double fontSize, Color color = Colors.white, double height = 1}) {
    /**
     * Constructs a text style given the arguments.
     * 
     * Returns:
     *  TextStyle: The constructed text style.
     */
    
    return TextStyle(
      color: color,
      fontFamily: "Poppins",
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      height: height
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

