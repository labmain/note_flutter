class NoteModel {
  /// 笔记id
  String id;

  /// 关联的书本id
  String note_book_id;

  /// 笔记本标题
  String title;

  /// 笔记内容
  String content;
  double create_time;
  double update_time;
  String user_id;

  NoteModel(
      {this.id,
      this.title,
      this.content,
      this.create_time,
      this.update_time,
      this.user_id});

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note_book_id = json['note_book_id'];
    content = json['content'];
    create_time = json['create_time'];
    update_time = json['create_time'];
    user_id = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['note_book_id'] = this.note_book_id;
    data['content'] = this.content;
    data['create_time'] = this.create_time;
    data['update_time'] = this.update_time;
    data['user_id'] = this.user_id;

    return data;
  }
}
