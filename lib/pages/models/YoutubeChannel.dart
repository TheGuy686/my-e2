import 'Video.dart';

class YoutubeChannel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final String videoCount;
  final String uploadPlaylistId;
  List<Video> videos;

  YoutubeChannel({
    this.id,
    this.title,
    this.profilePictureUrl,
    this.subscriberCount,
    this.videoCount,
    this.uploadPlaylistId,
    this.videos,
  });

  factory YoutubeChannel.fromMap(Map<String, dynamic> map) {
    return YoutubeChannel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriberCount: map['statistics']['subscriberCount'],
      videoCount: map['statistics']['videoCount'],
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
    );
  }
}
