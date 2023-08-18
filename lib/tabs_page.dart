import 'package:flutter/material.dart';
import 'package:my_cart/pages/home/home_page.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _generateTabs().length,
      initialIndex: 0,
      child: Scaffold(
        body: _createBody(),
        bottomNavigationBar: _createTabs(),
      ),
    );
  }

  Widget _createTabs() {
    return Container(
      color: Colors.blue,
      height: 55,
      child: TabBar(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.blue.shade800,
        ),
        tabs: _generateTabs(),
      ),
    );
  }

  Widget _createBody() {
    return const TabBarView(
      children: <Widget>[
        Center(child: HomePage()),
      ],
    );
  }

  List<Widget> _generateTabs() => <Widget>[
        const Tab(icon: Icon(Icons.home)),
      ];
}
