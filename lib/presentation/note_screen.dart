import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_cubic.dart'; // ✅ Apne file name ke mutabiq check kar lein
import '../domain/note_model.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  // Edit Dialog Function
  void _showEditDialog(BuildContext context, Note note) {
    final editController = TextEditingController(text: note.title);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Edit Note"),
        content: TextField(
          controller: editController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(hintText: "Update your note..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<NoteCubit>().updateNote(note.id!, editController.text);
              Navigator.pop(dialogContext);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notes App"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // 1. SEARCH SECTION
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  context.read<NoteCubit>().searchNotes(value);
                },
                decoration: InputDecoration(
                  hintText: "Search notes...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),

            // 2. ADD NOTE SECTION
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: "Enter note...",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        context.read<NoteCubit>().addNote(_controller.text);
                        _controller.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                  )
                ],
              ),
            ),

            // 3. LIST SECTION
            Expanded(
              child: BlocBuilder<NoteCubit, List<Note>>(
                builder: (context, notes) {
                  if (notes.isEmpty) {
                    return const Center(child: Text("No notes found"));
                  }

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              note.title,
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                              softWrap: true,
                              maxLines: null,
                            ),
                          ),
                          // ✅ Buttons ki width fix kar di taake nazar ayen
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.green),
                                  onPressed: () => _showEditDialog(context, note),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    context.read<NoteCubit>().deleteNote(note.id!);
                                  },
                                ),
                              ],
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
      ),
    );
  }
}