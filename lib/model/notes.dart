class NotesModel {
  int? id;
  String subject;
  String note;

  NotesModel({this.id, required this.subject, required this.note});
  NotesModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        subject = res['subject'],
        note = res['note'];

  Map<String, Object?> toMap() {
    return {'id': id, 'subject': subject, 'note': note};
  }
}
