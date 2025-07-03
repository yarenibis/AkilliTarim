import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'module_detail_screen.dart';

class ModuleListScreen extends StatelessWidget {
  final CollectionReference modulesRef =
      FirebaseFirestore.instance.collection('sustainability_modules');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sürdürülebilir Tarım Modülleri'),backgroundColor: Colors.green[800]),
      body: StreamBuilder<QuerySnapshot>(
        stream: modulesRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final modules = snapshot.data!.docs;

          return ListView.builder(
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.eco, color: Colors.green),
                  title: Text(module['title']),
                  subtitle: Text(module['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ModuleDetailScreen(moduleId: module.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
