class Task {
  String id;
  String name;
  String startTime;
  String endTime;
  String priority;
  String reminderTime;

  Task({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.priority,
    required this.reminderTime,
  });

  // ✅ Convert Task to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "startTime": startTime,
      "endTime": endTime,
      "priority": priority,
      "reminderTime": reminderTime,
    };
  }

  // ✅ Factory method to create Task from Firestore
  factory Task.fromJson(Map<String, dynamic> json, String id) {
    return Task(
      id: id,
      name: json["name"] ?? "",
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      priority: json["priority"] ?? "Medium",
      reminderTime: json["reminderTime"] ?? "",
    );
  }
}
