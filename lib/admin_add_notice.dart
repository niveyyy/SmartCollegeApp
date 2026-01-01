import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddNoticeScreen extends StatefulWidget {
  const AdminAddNoticeScreen({super.key});

  @override
  State<AdminAddNoticeScreen> createState() => _AdminAddNoticeScreenState();
}

class _AdminAddNoticeScreenState extends State<AdminAddNoticeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool isLoading = false;

  Future<void> addNotice() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    await FirebaseFirestore.instance.collection('notices').add({
      'title': titleController.text,
      'content': contentController.text,
      'date': Timestamp.now(),
    });

    setState(() => isLoading = false);

    titleController.clear();
    contentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notice added successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Notice (Admin)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Notice Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Notice Content",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: addNotice,
                    child: const Text("ADD NOTICE"),
                  ),
          ],
        ),
      ),
    );
  }
}
