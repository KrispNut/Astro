class GeomagneticData {
  GeomagneticData({
    required this.gstId,
    required this.startTime,
    required this.allKpIndex,
    required this.link,
    required this.linkedEvents,
    required this.submissionTime,
    required this.versionId,
    required this.sentNotifications,
  });

  final String? gstId;
  final String? startTime;
  final List<AllKpIndex> allKpIndex;
  final String? link;
  final List<LinkedEvent> linkedEvents;
  final String? submissionTime;
  final int? versionId;
  final List<SentNotification> sentNotifications;

  factory GeomagneticData.fromJson(Map<String, dynamic> json) {
    return GeomagneticData(
      gstId: json["gstID"],
      startTime: json["startTime"],
      allKpIndex:
          json["allKpIndex"] == null
              ? []
              : List<AllKpIndex>.from(
                json["allKpIndex"]!.map((x) => AllKpIndex.fromJson(x)),
              ),
      link: json["link"],
      linkedEvents:
          json["linkedEvents"] == null
              ? []
              : List<LinkedEvent>.from(
                json["linkedEvents"]!.map((x) => LinkedEvent.fromJson(x)),
              ),
      submissionTime: json["submissionTime"],
      versionId: json["versionId"],
      sentNotifications:
          json["sentNotifications"] == null
              ? []
              : List<SentNotification>.from(
                json["sentNotifications"]!.map(
                  (x) => SentNotification.fromJson(x),
                ),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "gstID": gstId,
    "startTime": startTime,
    "allKpIndex": allKpIndex.map((x) => x?.toJson()).toList(),
    "link": link,
    "linkedEvents": linkedEvents.map((x) => x?.toJson()).toList(),
    "submissionTime": submissionTime,
    "versionId": versionId,
    "sentNotifications": sentNotifications.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString() {
    return "$gstId, $startTime, $allKpIndex, $link, $linkedEvents, $submissionTime, $versionId, $sentNotifications, ";
  }
}

class AllKpIndex {
  AllKpIndex({
    required this.observedTime,
    required this.kpIndex,
    required this.source,
  });

  final String? observedTime;
  final double? kpIndex;
  final String? source;

  factory AllKpIndex.fromJson(Map<String, dynamic> json) {
    return AllKpIndex(
      observedTime: json["observedTime"],
      kpIndex: json["kpIndex"],
      source: json["source"],
    );
  }

  Map<String, dynamic> toJson() => {
    "observedTime": observedTime,
    "kpIndex": kpIndex,
    "source": source,
  };

  @override
  String toString() {
    return "$observedTime, $kpIndex, $source, ";
  }
}

class LinkedEvent {
  LinkedEvent({required this.activityId});

  final String? activityId;

  factory LinkedEvent.fromJson(Map<String, dynamic> json) {
    return LinkedEvent(activityId: json["activityID"]);
  }

  Map<String, dynamic> toJson() => {"activityID": activityId};

  @override
  String toString() {
    return "$activityId, ";
  }
}

class SentNotification {
  SentNotification({
    required this.messageId,
    required this.messageIssueTime,
    required this.messageUrl,
  });

  final String? messageId;
  final String? messageIssueTime;
  final String? messageUrl;

  factory SentNotification.fromJson(Map<String, dynamic> json) {
    return SentNotification(
      messageId: json["messageID"],
      messageIssueTime: json["messageIssueTime"],
      messageUrl: json["messageURL"],
    );
  }

  Map<String, dynamic> toJson() => {
    "messageID": messageId,
    "messageIssueTime": messageIssueTime,
    "messageURL": messageUrl,
  };

  @override
  String toString() {
    return "$messageId, $messageIssueTime, $messageUrl, ";
  }
}
