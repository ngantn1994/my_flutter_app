import 'package:flutter/material.dart';
import 'package:my_flutter_app/components/menu_drawer.dart';
import 'package:my_flutter_app/data/note.dart';
import 'package:my_flutter_app/data/shared_preferences_helper.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<Note> notes = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  @override
  void initState() {
    sharedPreferencesHelper.init().then((value) {
      updateScreen();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      drawer: MenuDrawer(),
      body: ListView(
        children: getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note_add_outlined),
        onPressed: () {
          addNoteDialog(context);
        },
      ),
    );
  }

  Future<dynamic> addNoteDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Create new note'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(hintText: 'Content'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                  titleController.text = '';
                  contentController.text = '';
                },
              ),
              ElevatedButton(
                child: Text('Save'),
                onPressed: saveNote,
              ),
            ],
          );
        });
  }

  Future saveNote() async {
    int id = sharedPreferencesHelper.getLatestNoteId();

    Note newNote = Note(id, titleController.text, contentController.text);

    sharedPreferencesHelper.storeNote(newNote).then((_) {
      updateScreen();
      sharedPreferencesHelper.increaseLatestNoteId();
    });
    titleController.text = '';
    contentController.text = '';

    Navigator.pop(context);
  }

  List<Widget> getContent() {
    List<Widget> tiles = [];
    notes.forEach((note) {
      tiles.add(Dismissible(
        key: UniqueKey(),
        onDismissed: (_) {
          sharedPreferencesHelper.deleteNote(note.id).then((value) => updateScreen());
        },
        child: ListTile(
          title: Text(note.title),
          subtitle: Text(note.content),
        ),
      ));
    });

    return tiles;
  }

  void updateScreen() {
    notes = sharedPreferencesHelper.getStoredNotes();
    setState(() {});
  }
}
