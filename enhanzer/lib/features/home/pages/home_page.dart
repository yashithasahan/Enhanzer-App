import 'package:enhanzer/features/auth/pages/login_page.dart';
import 'package:enhanzer/features/home/controllers/home_controller.dart';
import 'package:enhanzer/services/database_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _homeController;
  List<Map<String, dynamic>>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(DatabaseService());
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _homeController.initDatabase();
    final users = await _homeController.getUser();
    setState(() {
      _userData = users;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enhanzer',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF5D3FD3),
        iconTheme:
            const IconThemeData(color: Colors.white), // Set drawer icon color
      ),
      drawer: _buildSidePane(),
      body: _isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : _buildUserList(),
    );
  }

  Widget _buildUserList() {
    if (_userData != null) {
      return ListView.builder(
        itemCount: _userData!.length,
        itemBuilder: (context, index) {
          final user = _userData![index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF5D3FD3),
                child: Text(
                  user['name'][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(user['name']),
              subtitle: Text(user['email']),
            ),
          );
        },
      );
    } else {
      return Text("Page not found");
    }
  }

  Widget _buildSidePane() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF5D3FD3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Developer Info',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Name: Yashitha Sahan',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  'Email: yashithashan@gmail.com',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  'Website: yashitha.me',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFF5D3FD3)),
            title: const Text('About App'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF5D3FD3)),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Color(0xFF5D3FD3)),
            title: const Text('LogOut'),
            onTap: () {
              _homeController.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
