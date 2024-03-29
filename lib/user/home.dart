import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/chat/chat_menu.dart';
import 'package:matchdotdog/chat/chat_menu_contd.dart';
import 'package:matchdotdog/dogs/my_dogs.dart';
import 'package:matchdotdog/map/map.dart';
import 'package:matchdotdog/user/auth_page.dart';
import '../models/dog_model.dart';
import '../models/owner_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.owner, required this.referrer});

  final Owner owner;
  final String referrer;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Owner _currentOwner;
  int _selectedIndex = 1;
  bool _chatPage = false;
  late Dog _chatBuddy; //New
  late String _currentReferrer;

  @override
  void initState() {
    super.initState();
    _currentReferrer = widget.referrer;
    _currentOwner = widget.owner;
    _chatPage = false;

    if (_currentReferrer == 'chatView_back') {
      _selectedIndex = 3;
    }

    if (_currentReferrer == 'chatViewContd') {
      _selectedIndex = 3;
    }

    if (_currentReferrer == 'chatView_profile') {
      _selectedIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      print('selected index ' + index.toString());
      setState(() {
        _selectedIndex = index;
      });
    }

    List<Widget> _bottomNavPages = <Widget>[
      AuthPage(),
      MyDogs(owner: _currentOwner),
      MapScreen(owner: _currentOwner),
      _chatPage
          ? ChatMenuContd(owner: _currentOwner, buddy: _chatBuddy)
          : ChatMenu(
              owner: _currentOwner,
              next: (bool? value) {
                setState(() {
                  _chatPage = value!;
                });
              },
              buddy: (Dog? value) {
                setState(() {
                  _chatBuddy = value!;
                });
              },
            ),
    ];

    return Scaffold(
      body: SafeArea(child: _bottomNavPages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 144, 211, 214), fontSize: 14),
        unselectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthPage()
                        //MyDogsRedirect(user: user)
                        ),
                  );
                },
                icon: Icon(
                  Icons.exit_to_app_outlined,
                  color: Theme.of(context).primaryColor,
                )),
            label: 'Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: Theme.of(context).primaryColor,
            ),
            activeIcon: Icon(
              Icons.list,
              color: Theme.of(context).splashColor,
            ),
            label: 'My Dogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on,
              color: Theme.of(context).primaryColor,
            ),
            activeIcon: Icon(
              Icons.location_on,
              color: Theme.of(context).splashColor,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: Theme.of(context).primaryColor,
            ),
            activeIcon: Icon(
              Icons.chat_bubble_outline,
              color: Theme.of(context).splashColor,
            ),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
