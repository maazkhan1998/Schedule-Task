class Task {
  String id;
  String date;
  String name;
  int isDone;

  Task({this.date, this.name, this.isDone,this.id});

  Task.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    date = json['date'];
    name = json['name'];
    isDone = json['isDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['name'] = this.name;
    data['isDone'] = this.isDone;
    data['id']=this.id;
    return data;
  }
}