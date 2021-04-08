class NotebookModel {
  String id;
  String name;
  List<String> note_list;
  double create_time;
  double update_time;
  String user_id;

  NotebookModel(
      {this.id,
      this.name,
      this.note_list,
      this.create_time,
      this.update_time,
      this.user_id});

  NotebookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    create_time = json['create_time'];
    update_time = json['create_time'];
    user_id = json['user_id'];
    if (json['note_list'] != null) {
      note_list = <String>[];
      json['note_list'].forEach((v) {
        note_list.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['create_time'] = this.create_time;
    data['update_time'] = this.update_time;
    data['user_id'] = this.user_id;
    if (this.note_list != null) {
      data['note_list'] = this.note_list;
    }
    return data;
  }
}
