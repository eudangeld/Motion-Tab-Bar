import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionBadgeWidget.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

void main() => runApp(const DynamicIconsApp());

class DynamicIconsApp extends StatelessWidget {
  const DynamicIconsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Icons Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DynamicIconsPage(),
    );
  }
}

class DynamicIconsPage extends StatefulWidget {
  const DynamicIconsPage({Key? key}) : super(key: key);

  @override
  _DynamicIconsPageState createState() => _DynamicIconsPageState();
}

class _DynamicIconsPageState extends State<DynamicIconsPage>
    with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  // Different states for icon updates
  bool _useColoredIcons = false;
  bool _useLargeIcons = false;
  bool _useDifferentIcons = false;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  // Dynamic icons based on state
  List<Widget> get _icons {
    final List<Text> iconData = _useDifferentIcons
        ? [Text('ADT'), Text('ADT'), Text('ADT'), Text('ADT')]
        : [Text('CHG'), Text('CHG'), Text('CHG'), Text('CHG')];

    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];

    return List.generate(4, (index) {
      double size = _useLargeIcons ? 32.0 : 24.0;
      Color color = _useColoredIcons ? colors[index] : Colors.grey;

      return iconData[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Icons Example'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _useColoredIcons = !_useColoredIcons;
              });
            },
            icon:
                Icon(_useColoredIcons ? Icons.palette : Icons.palette_outlined),
            tooltip: 'Toggle Colors',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _useLargeIcons = !_useLargeIcons;
              });
            },
            icon: Icon(_useLargeIcons ? Icons.zoom_in : Icons.zoom_out),
            tooltip: 'Toggle Size',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _useDifferentIcons = !_useDifferentIcons;
              });
            },
            icon: Icon(_useDifferentIcons ? Icons.swap_horiz : Icons.swap_vert),
            tooltip: 'Toggle Icons',
          ),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        useSafeArea: true,
        labels: const ["Dashboard", "Home", "Profile", "Settings"],
        icons: _icons,
        badges: [
          const MotionBadgeWidget(
            text: '10+',
            textColor: Colors.white,
            color: Colors.red,
            size: 18,
          ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(2),
            child: const Text(
              '48',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          null,
          const MotionBadgeWidget(
            isIndicator: true,
            color: Colors.red,
            size: 5,
            show: true,
          ),
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.blue[600],
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Colors.blue[900],
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: <Widget>[
          _buildPageContent("Dashboard Page", _motionTabBarController!),
          _buildPageContent("Home Page", _motionTabBarController!),
          _buildPageContent("Profile Page", _motionTabBarController!),
          _buildPageContent("Settings Page", _motionTabBarController!),
        ],
      ),
    );
  }

  Widget _buildPageContent(String title, MotionTabBarController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text('Current Icon State:',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Text('Colored: $_useColoredIcons',
              style: const TextStyle(fontSize: 14)),
          Text('Large: $_useLargeIcons', style: const TextStyle(fontSize: 14)),
          Text('Different: $_useDifferentIcons',
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 50),
          const Text('Go to "X" page programmatically'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => controller.index = 0,
            child: const Text('Dashboard Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 1,
            child: const Text('Home Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 2,
            child: const Text('Profile Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 3,
            child: const Text('Settings Page'),
          ),
        ],
      ),
    );
  }
}
