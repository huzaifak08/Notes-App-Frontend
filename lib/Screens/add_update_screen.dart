import 'dart:core';
import 'package:flutter/material.dart';
import 'package:notes_app/Provider/note_provider.dart';
import 'package:provider/provider.dart';

import '../Models/notes_model.dart';

class AddUpdateScreen extends StatefulWidget {
  final bool isUpdate;
  final String? id;
  final String? title;
  final String? content;
  const AddUpdateScreen(
      {super.key, required this.isUpdate, this.id, this.title, this.content});

  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController contentController;

  FocusNode contentFocus = FocusNode();

  @override
  void initState() {
    titleController = TextEditingController();
    contentController = TextEditingController();

    if (widget.isUpdate) {
      titleController.text = widget.title.toString();
      contentController.text = widget.content.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: widget.isUpdate
            ? const Text('Update Note')
            : const Text('Add New Note'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.01),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  labelText: 'Title',
                  labelStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onFieldSubmitted: (value) {
                  // For Focus Node to Work:
                  if (value != "") {
                    contentFocus.requestFocus();
                  }
                },
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: contentController,
                focusNode: contentFocus,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  labelText: 'Content',
                ),
                maxLength: 250,
                maxLines: 5,
              ),
              SizedBox(height: height * 0.03),
              SizedBox(
                  width: width * 0.5,
                  child: ElevatedButton(
                      onPressed: () {
                        if (widget.isUpdate == true) {
                          // Update Note:
                          Provider.of<NotesProvider>(context, listen: false)
                              .updateNote(
                                  widget.id.toString(),
                                  NotesModel(
                                    email: 'huzaifa@gmail.com',
                                    title: titleController.text,
                                    content: contentController.text,
                                    dateAdded: DateTime.now(),
                                  ));
                          Navigator.pop(context);
                        } else {
                          // Add new Note:

                          NotesModel newNote = NotesModel(
                            email: 'huzaifa@gmail.com',
                            title: titleController.text,
                            content: contentController.text,
                            dateAdded: DateTime.now(),
                          );
                          Provider.of<NotesProvider>(context, listen: false)
                              .addNote(newNote);
                          Navigator.pop(context);
                        }
                      },
                      child: widget.isUpdate
                          ? const Text('Update Note')
                          : const Text('Create Note')))
            ],
          ),
        ),
      ),
    );
  }
}
