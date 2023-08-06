import 'package:flutter/material.dart';
import 'package:notes_app/Provider/note_provider.dart';
import 'package:notes_app/Provider/user_provider.dart';
import 'package:notes_app/Screens/add_update_screen.dart';
import 'package:notes_app/Services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final userProvider = Provider.of<UserProvider>(context).user;

    // final height = MediaQuery.sizeOf(context).height;
    // final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes List ${userProvider.name}"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                AuthService().signOut(context);
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: FutureBuilder(
        future: notesProvider.getNote(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: notesProvider.notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    // Go to Update Screen:

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUpdateScreen(
                            isUpdate: true,
                            id: notesProvider.notes[index].id.toString(),
                            title: notesProvider.notes[index].title.toString(),
                            content:
                                notesProvider.notes[index].content.toString(),
                          ),
                        ));
                  },
                  leading: CircleAvatar(
                    child: Text(index.toString()),
                  ),
                  title: Text(notesProvider.notes[index].title.toString()),
                  subtitle: Text(
                    notesProvider.notes[index].content.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      notesProvider
                          .deleteNote(notesProvider.notes[index].id.toString());
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Go to add new Note Screen:

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddUpdateScreen(
                        isUpdate: false,
                      )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
