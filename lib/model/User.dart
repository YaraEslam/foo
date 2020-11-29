
class UserData {
  final String userId;
  final String userName;
  final String phoneNum;

  UserData({this.userId, this.userName, this.phoneNum});

  Map<String, Object> toJson() {
    return {
      'user_id': this.userId,
      'user_name': this.userName,
      'phone_num': this.phoneNum,
    };
  }

  static UserData fromJson(Map<String, Object> json) {
    return UserData(
        userId: json['user_id'],
        userName: json['user_name'],
        phoneNum: json['phone_num']
    );
  }

}