class Announcement {
  String announcement;
  int endTimestamp;

  Announcement({this.announcement, this.endTimestamp});

  factory Announcement.fromJson(Map<dynamic, dynamic> json) {
    return Announcement(
        announcement: json['announcement'], endTimestamp: json['endTs']);
  }
}
