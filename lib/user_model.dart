class UserData {
  String? message;
  User? data;
  bool? status;

  UserData({this.message, this.data, this.status});

  UserData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = json['data'] != null ? new User.fromJson(json['data']) : null;
    } else {
      data = null;
    }

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class User {
  String? id;
  String? status;
  String? userId;
  String? inTime;
  String? outTime;
  String? checkedBy;
  String? note;
  String? location;
  String? checkedAt;
  String? rejectReason;
  String? deleted;
  String? userType;
  String? clientId;
  String? password;
  String? firstName;
  String? lastName;
  String? isAdmin;
  String? email;

  User(
      {this.id,
      this.status,
      this.userId,
      this.inTime,
      this.outTime,
      this.checkedBy,
      this.note,
      this.userType,
      this.clientId,
      this.password,
      this.firstName,
      this.lastName,
      this.isAdmin,
      this.email,
      this.location,
      this.checkedAt,
      this.rejectReason,
      this.deleted});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    userId = json['user_id'];
    inTime = json['in_time'];
    outTime = json['out_time'];
    checkedBy = json['checked_by'];
    note = json['note'];
    location = json['location'];
    checkedAt = json['checked_at'];
    rejectReason = json['reject_reason'];
    deleted = json['deleted'];
    userType = json['user_type'];
    clientId = json['client_id'];
    password = json['password'];
    firstName = json['first_name'];
    firstName = json['name'];
    lastName = json['last_name'];
    isAdmin = json['is_admin'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['in_time'] = this.inTime;
    data['out_time'] = this.outTime;
    data['checked_by'] = this.checkedBy;
    data['note'] = this.note;
    data['location'] = this.location;
    data['checked_at'] = this.checkedAt;
    data['reject_reason'] = this.rejectReason;
    data['deleted'] = this.deleted;
    data['user_type'] = this.userType;
    data['client_id'] = this.clientId;
    data['password'] = this.password;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['is_admin'] = this.isAdmin;
    data['email'] = this.email;
    return data;
  }
}

// class User {
//   String? id;
//   String? userType;
//   String? clientId;
//   String? password;
//   String? firstName;
//   String? lastName;
//   String? isAdmin;
//   String? email;
//
//   User(
//       {this.id,
//         this.userType,
//         this.clientId,
//         this.password,
//         this.firstName,
//         this.lastName,
//         this.isAdmin,
//         this.email});
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userType = json['user_type'];
//     clientId = json['client_id'];
//     password = json['password'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     isAdmin = json['is_admin'];
//     email = json['email'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_type'] = this.userType;
//     data['client_id'] = this.clientId;
//     data['password'] = this.password;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['is_admin'] = this.isAdmin;
//     data['email'] = this.email;
//     return data;
//   }
// }
