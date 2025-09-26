class SolarFlareData {
  SolarFlareData({
    required this.flrId,
    required this.catalog,
    required this.instruments,
    required this.beginTime,
    required this.peakTime,
    required this.endTime,
    required this.classType,
    required this.sourceLocation,
    required this.activeRegionNum,
    required this.note,
    required this.submissionTime,
    required this.versionId,
    required this.link,
    required this.linkedEvents,
    required this.sentNotifications,
  });

  final String? flrId;
  final String? catalog;
  final List<Instrument> instruments;
  final String? beginTime;
  final String? peakTime;
  final String? endTime;
  final String? classType;
  final String? sourceLocation;
  final int? activeRegionNum;
  final String? note;
  final String? submissionTime;
  final int? versionId;
  final String? link;
  final List<LinkedEvent> linkedEvents;
  final dynamic sentNotifications;

  factory SolarFlareData.fromJson(Map<String, dynamic> json) {
    return SolarFlareData(
      flrId: json["flrID"],
      catalog: json["catalog"],
      instruments:
          json["instruments"] == null
              ? []
              : List<Instrument>.from(
                json["instruments"]!.map((x) => Instrument.fromJson(x)),
              ),
      beginTime: json["beginTime"],
      peakTime: json["peakTime"],
      endTime: json["endTime"],
      classType: json["classType"],
      sourceLocation: json["sourceLocation"],
      activeRegionNum: json["activeRegionNum"],
      note: json["note"],
      submissionTime: json["submissionTime"],
      versionId: json["versionId"],
      link: json["link"],
      linkedEvents:
          json["linkedEvents"] == null
              ? []
              : List<LinkedEvent>.from(
                json["linkedEvents"]!.map((x) => LinkedEvent.fromJson(x)),
              ),
      sentNotifications: json["sentNotifications"],
    );
  }

  Map<String, dynamic> toJson() => {
    "flrID": flrId,
    "catalog": catalog,
    "instruments": instruments.map((x) => x?.toJson()).toList(),
    "beginTime": beginTime,
    "peakTime": peakTime,
    "endTime": endTime,
    "classType": classType,
    "sourceLocation": sourceLocation,
    "activeRegionNum": activeRegionNum,
    "note": note,
    "submissionTime": submissionTime,
    "versionId": versionId,
    "link": link,
    "linkedEvents": linkedEvents.map((x) => x?.toJson()).toList(),
    "sentNotifications": sentNotifications,
  };

  @override
  String toString() {
    return "$flrId, $catalog, $instruments, $beginTime, $peakTime, $endTime, $classType, $sourceLocation, $activeRegionNum, $note, $submissionTime, $versionId, $link, $linkedEvents, $sentNotifications, ";
  }
}

class Instrument {
  Instrument({required this.displayName});

  final String? displayName;

  factory Instrument.fromJson(Map<String, dynamic> json) {
    return Instrument(displayName: json["displayName"]);
  }

  Map<String, dynamic> toJson() => {"displayName": displayName};

  @override
  String toString() {
    return "$displayName, ";
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
