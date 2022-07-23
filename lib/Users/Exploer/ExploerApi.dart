class TrendExplorer {
  bool? success;
  Data? data;
  Message? message;

  TrendExplorer({this.success, this.data, this.message});

  TrendExplorer.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Data {
  int? pageCount;
  List<Explorer>? explorer;

  Data({this.pageCount, this.explorer});

  Data.fromJson(Map<String, dynamic> json) {
    pageCount = json['page_count'];
    if (json['explorer'] != null) {
      explorer = <Explorer>[];
      json['explorer'].forEach((v) {
        explorer!.add(new Explorer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_count'] = this.pageCount;
    if (this.explorer != null) {
      data['explorer'] = this.explorer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Explorer {
  int? id;
  String? title;
  String? description;
  String? image;
  String? type;
  int? likes;
  int? views;

  Explorer(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.type,
        this.likes,
        this.views});

  Explorer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    type = json['type'];
    likes = json['likes'];
    views = json['views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['type'] = this.type;
    data['likes'] = this.likes;
    data['views'] = this.views;
    return data;
  }
}

class Message {
  String? en;
  String? ar;

  Message({this.en, this.ar});

  Message.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}