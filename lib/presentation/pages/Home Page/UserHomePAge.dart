import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/presentation/pages/Home%20Page/HomePage.dart';

class Userhomepage extends StatefulWidget {
  const Userhomepage({super.key});

  @override
  State<Userhomepage> createState() => _UserhomepageState();
}

class _UserhomepageState extends State<Userhomepage> {
  TextEditingController _searchController = TextEditingController();

  String _searchQuery = "";

  void _searchTasks(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: _searchController,
              onChanged: _searchTasks,
              decoration: InputDecoration(
                fillColor: Color(0xff272727),
                filled: true,
                hintStyle: TextStyle(color: Colors.white),
                hintText: "Search for a task...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Task List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/homepage pic.png"),
                        Text(
                          "What do you want to do today?",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Tap + to add your tasks",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  );
                }

                final tasks = snapshot.data!.docs.where((task) {
                  final title = task['title'].toString().toLowerCase();
                  return title.contains(_searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (ctx, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff363636),
                            borderRadius: BorderRadius.circular(5)),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('tasks')
                                  .doc(task.id)
                                  .delete();
                            },
                          ),
                          title: Text(
                            task['title'],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['description'],
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                "Due Date: ${DateFormat('yyyy-MM-dd').format(task['dueDate'].toDate())}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Time: ${task['dueTime']}",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit,
                                color: Colors.white), // Düzenleme ikonu
                            onPressed: () {},
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
