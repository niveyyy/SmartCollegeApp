import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: const LoginScreen(), // ✅ LOGIN FIRST
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
          decoration: const InputDecoration(labelText: "Admin Password"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text == "admin123") {
                Navigator.pop(context);
                Navigator.pushReplacement(
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
            const Icon(Icons.school, size: 90, color: Color.fromARGB(255, 0, 0, 0)),
            const SizedBox(height: 20),
            const Text(
              "Smart College App",
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
                Navigator.pushReplacement(
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
      height: 60,
      child: ElevatedButton(
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

        // 🔙 BACK TO LOGIN
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
      ),

      // 🔥 CENTER ALIGN FIX
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // ⭐ IMPORTANT
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
              screen: NoticeBoardScreen(isAdmin: isAdmin),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        width: 300, // 🔥 optional – looks clean
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8),
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
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
      appBar: AppBar(
        title: const Text("Campus Route Finder"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🗺️ MAP PLACEHOLDER
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map, size: 60, color: Colors.black54),
                    SizedBox(height: 10),
                    Text(
                      "Campus Map Preview",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📍 FROM
            TextField(
              decoration: InputDecoration(
                labelText: "From",
                prefixIcon: const Icon(Icons.my_location),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 📍 TO
            TextField(
              decoration: InputDecoration(
                labelText: "To",
                prefixIcon: const Icon(Icons.location_on),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🚀 FIND ROUTE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions),
                label: const Text("Find Route"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Demo Mode"),
                      content: const Text(
                        "Map routing requires Google Maps Billing Account.\n\n"
                        "In full version, real-time navigation & directions "
                        "inside the campus will be shown here.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ℹ️ INFO TEXT
            const Text(
              "⚠️ Demo Version\n"
              "Live navigation will be enabled after Google Maps API billing activation.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= GEMINI API ================= */

const String GEMINI_API_KEY = "AIzaSyBsRL4WEj12cSfuIcOM4G5Z1X3Nr9AUeuA";

Future<String> getGeminiResponse(String message) async {
  final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$GEMINI_API_KEY");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": message}
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  return data["candidates"][0]["content"]["parts"][0]["text"];
} else {
  print("STATUS CODE: ${response.statusCode}");
  print("BODY: ${response.body}");
  return "AI error: ${response.statusCode}";
}
}

/* ================= CHATBOT ================= */

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  late stt.SpeechToText _speech;
  bool _isListening = false;

  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  /* ---------- SEND MESSAGE ---------- */
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
      _controller.clear();
    });

    final reply = await getGeminiResponse(text);

    setState(() {
      _messages.add({"sender": "bot", "text": reply});
    });

    await _tts.speak(reply);
  }

  /* ---------- VOICE INPUT ---------- */
  Future<void> _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("College Chatbot"),
        centerTitle: true,
      ),

      // 🔥 keyboard safe UI
      body: SafeArea(
        child: Column(
          children: [
            /* ---------- CHAT AREA ---------- */
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg["sender"] == "user";

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints:
                          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.indigo : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        msg["text"]!,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            /* ---------- INPUT BAR ---------- */
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
              child: Row(
                children: [
                  // 🎤 MIC
                  IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.red : Colors.indigo,
                    ),
                    onPressed: _toggleListening,
                  ),

                  // ✏ TEXT FIELD
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: "Ask anything...",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // 📤 SEND
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.indigo),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= NOTICE BOARD ================= */

class NoticeBoardScreen extends StatelessWidget {
  final bool isAdmin;
  const NoticeBoardScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notice Board")),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddNoticeScreen(),
                  ),
                );
              },
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notices")
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No notices available"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final date = (data["date"] as Timestamp).toDate();

              return Card(
  margin: const EdgeInsets.all(12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  ),
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // 🔹 TITLE + DELETE ICON ROW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                data["title"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 🗑️ DELETE ICON (ADMIN ONLY)
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("notices")
                      .doc(docs[index].id)
                      .delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Notice deleted")),
                  );
                },
              ),
          ],
        ),

        const SizedBox(height: 6),
        Text(data["content"]),

        const SizedBox(height: 8),

        // 🖼️ IMAGE (if exists)
        if (data["imageUrl"] != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              data["imageUrl"],
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

        const SizedBox(height: 8),
        Text(
          DateFormat("dd MMM yyyy, hh:mm a")
              .format((data["date"] as Timestamp).toDate()),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    ),
  ),
);
            },
          );
        },
      ),
    );
  }
}
/* ================= ADD NOTICE SCREEN ================= */
class AddNoticeScreen extends StatefulWidget {
  const AddNoticeScreen({super.key});

  @override
  State<AddNoticeScreen> createState() => _AddNoticeScreenState();
}

class _AddNoticeScreenState extends State<AddNoticeScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _loading = false;

  Future<void> pickImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<String?> uploadImage() async {
    if (_image == null) return null;

    const cloudName = "ds6orx9bu";
    const uploadPreset = "UniGuide"; // 🔥 YOUR PRESET NAME

    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        "file",
        _image!.path,
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = jsonDecode(resStr);
      return data["secure_url"];
    } else {
      print("Cloudinary upload failed: ${response.statusCode}");
      return null;
    }
  }

  Future<void> saveNotice() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty) return;

    setState(() => _loading = true);

    String? imageUrl = await uploadImage();

    await FirebaseFirestore.instance.collection("notices").add({
      "title": titleController.text,
      "content": contentController.text,
      "imageUrl": imageUrl,
      "date": Timestamp.now(),
    });

    setState(() => _loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Notice")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Content"),
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _image == null
                    ? const Center(child: Text("Tap to upload image"))
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: saveNotice,
                    child: const Text("Save Notice"),
                  ),
          ],
        ),
      ),
    );
  }
}
