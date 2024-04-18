class NotesModel {
  String title;
  String content;

  NotesModel({required this.title, required this.content});

  static NotesModel deefault() {
  return NotesModel(title: '', content: ''); // Default values
  }
}
