import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* ================= APP ROOT ================= */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const LoginScreen(),
    );
  }
}

/* ================= LOGIN SCREEN ================= */

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _adminLogin(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Admin Login"),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Admin Password",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text == "adminpass123") {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(isAdmin: true),
                  ),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Wrong Password")),
                );
              }
            },
            child: const Text("LOGIN"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 90, color: Colors.indigo),
            const SizedBox(height: 20),
            const Text(
              "Smart College Assistant",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            _loginButton(
              text: "Admin Login",
              onTap: () => _adminLogin(context),
            ),

            const SizedBox(height: 20),

            _loginButton(
              text: "Student Login",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(isAdmin: false),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton({required String text, required VoidCallback onTap}) {
    return SizedBox(
      width: 260,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

/* ================= HOME SCREEN ================= */

class HomeScreen extends StatelessWidget {
  final bool isAdmin;
  const HomeScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? "Admin Dashboard" : "Student Dashboard"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _menuCard(
              context,
              icon: Icons.smart_toy,
              title: "Chatbot",
              screen: const ChatbotScreen(),
            ),
            const SizedBox(height: 20),
            _menuCard(
              context,
              icon: Icons.map,
              title: "Route Finder",
              screen: const RouteFinderScreen(),
            ),
            const SizedBox(height: 20),
            _menuCard(
              context,
              icon: Icons.notifications,
              title: "Notice Board",
              screen: const NoticeBoardScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(BuildContext context,
      {required IconData icon,
      required String title,
      required Widget screen}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon, size: 35, color: Colors.indigo),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= CHATBOT ================= */

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _ChatBubble(
                  text: "Hi! Ask me anything 😊",
                  isBot: true,
                ),
                _ChatBubble(
                  text: "What is Artificial Intelligence?",
                  isBot: false,
                ),
                _ChatBubble(
                  text:
                      "Artificial Intelligence is the simulation of human intelligence in machines.",
                  isBot: true,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type your question...",
                suffixIcon: Icon(Icons.send),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isBot;

  const _ChatBubble({required this.text, required this.isBot});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isBot ? Colors.grey.shade300 : Colors.indigo,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: TextStyle(color: isBot ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}

/* ================= ROUTE FINDER ================= */

class RouteFinderScreen extends StatelessWidget {
  const RouteFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Route Finder")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _RouteTile("Library → CSE Block", "Distance: 300m"),
          _RouteTile("Main Gate → Admin Block", "Distance: 500m"),
          _RouteTile("Hostel → Cafeteria", "Distance: 200m"),
        ],
      ),
    );
  }
}

class _RouteTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _RouteTile(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.place, color: Colors.indigo),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

/* ================= NOTICE BOARD ================= */

class NoticeBoardScreen extends StatelessWidget {
  const NoticeBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notice Board")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _NoticeCard(
            title: "Internal Exam",
            content: "DBMS internal exam on Monday",
          ),
          _NoticeCard(
            title: "Holiday Notice",
            content: "College will be closed tomorrow",
          ),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final String title;
  final String content;

  const _NoticeCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }
}