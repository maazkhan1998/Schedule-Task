import 'package:flutter/material.dart';
import 'package:newui/provider/todayProvider.dart';
import 'package:newui/screens/timepage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'calendarscreen.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

BuildContext testContext;
class _HomePageState extends State<HomePage> {
 PersistentTabController _controller;
  bool _hideNavBar;
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    getData();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  getData()async{
    try{
   await  Provider.of<TodayProvider>(context,listen: false).getTodayData();
   setState(()=>isLoading=false);
    }catch(e){
      print(e);
    }
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        // title: "Home",
        activeColorPrimary: Color(0xff7654f6),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_today),
        // title: ("Search"),
        activeColorPrimary:   Color(0xff7654f6),
        inactiveColorPrimary: Colors.grey,
      ),
    
    ];
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child:CircularProgressIndicator()): PersistentTabView(
        context,
        controller: _controller,
        screens: [
      TimePage(),
      CalendarScreen()
        ],
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color(0xffF9F9F9),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        //  margin: EdgeInsets.only(bottom: 10.0),
        popActionScreens: PopActionScreensType.once,
        bottomScreenMargin: 0.0,

        selectedTabScreenContext: (context) {
          testContext = context;
        },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
            colorBehindNavBar: Colors.black,
            borderRadius: BorderRadius.circular(0)),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style13, // Choose the nav bar style with this property
      )
    ;
  }
}
