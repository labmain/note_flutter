class User {
  /// 用户id
  String id = "0";

  /// 用户名称
  String name = "临时用户";

  /// 登录成功之后的token
  String? token;

  User();
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
