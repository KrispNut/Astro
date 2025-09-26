class AsteroidData {
  AsteroidData({
    required this.links,
    required this.elementCount,
    required this.nearEarthObjects,
  });

  final AsteroidDataLinks? links;
  final int? elementCount;
  final Map<String, List<NearEarthObject>> nearEarthObjects;

  factory AsteroidData.fromJson(Map<String, dynamic> json) {
    return AsteroidData(
      links:
          json["links"] == null
              ? null
              : AsteroidDataLinks.fromJson(json["links"]),
      elementCount: json["element_count"],
      nearEarthObjects: Map.from(json["near_earth_objects"]).map(
        (k, v) => MapEntry<String, List<NearEarthObject>>(
          k,
          v == null
              ? []
              : List<NearEarthObject>.from(
                v!.map((x) => NearEarthObject.fromJson(x)),
              ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "links": links?.toJson(),
    "element_count": elementCount,
    "near_earth_objects": Map.from(nearEarthObjects).map(
      (k, v) =>
          MapEntry<String, dynamic>(k, v.map((x) => x?.toJson()).toList()),
    ),
  };

  @override
  String toString() {
    return "$links, $elementCount, $nearEarthObjects, ";
  }
}

class AsteroidDataLinks {
  AsteroidDataLinks({
    required this.next,
    required this.previous,
    required this.self,
  });

  final String? next;
  final String? previous;
  final String? self;

  factory AsteroidDataLinks.fromJson(Map<String, dynamic> json) {
    return AsteroidDataLinks(
      next: json["next"],
      previous: json["previous"],
      self: json["self"],
    );
  }

  Map<String, dynamic> toJson() => {
    "next": next,
    "previous": previous,
    "self": self,
  };

  @override
  String toString() {
    return "$next, $previous, $self, ";
  }
}

class NearEarthObject {
  NearEarthObject({
    required this.links,
    required this.id,
    required this.neoReferenceId,
    required this.name,
    required this.nasaJplUrl,
    required this.absoluteMagnitudeH,
    required this.estimatedDiameter,
    required this.isPotentiallyHazardousAsteroid,
    required this.closeApproachData,
    required this.isSentryObject,
    required this.sentryData,
  });

  final NearEarthObjectLinks? links;
  final String? id;
  final String? neoReferenceId;
  final String? name;
  final String? nasaJplUrl;
  final double? absoluteMagnitudeH;
  final EstimatedDiameter? estimatedDiameter;
  final bool? isPotentiallyHazardousAsteroid;
  final List<CloseApproachDatum> closeApproachData;
  final bool? isSentryObject;
  final String? sentryData;

  factory NearEarthObject.fromJson(Map<String, dynamic> json) {
    return NearEarthObject(
      links:
          json["links"] == null
              ? null
              : NearEarthObjectLinks.fromJson(json["links"]),
      id: json["id"],
      neoReferenceId: json["neo_reference_id"],
      name: json["name"],
      nasaJplUrl: json["nasa_jpl_url"],
      absoluteMagnitudeH: json["absolute_magnitude_h"],
      estimatedDiameter:
          json["estimated_diameter"] == null
              ? null
              : EstimatedDiameter.fromJson(json["estimated_diameter"]),
      isPotentiallyHazardousAsteroid: json["is_potentially_hazardous_asteroid"],
      closeApproachData:
          json["close_approach_data"] == null
              ? []
              : List<CloseApproachDatum>.from(
                json["close_approach_data"]!.map(
                  (x) => CloseApproachDatum.fromJson(x),
                ),
              ),
      isSentryObject: json["is_sentry_object"],
      sentryData: json["sentry_data"],
    );
  }

  Map<String, dynamic> toJson() => {
    "links": links?.toJson(),
    "id": id,
    "neo_reference_id": neoReferenceId,
    "name": name,
    "nasa_jpl_url": nasaJplUrl,
    "absolute_magnitude_h": absoluteMagnitudeH,
    "estimated_diameter": estimatedDiameter?.toJson(),
    "is_potentially_hazardous_asteroid": isPotentiallyHazardousAsteroid,
    "close_approach_data": closeApproachData.map((x) => x?.toJson()).toList(),
    "is_sentry_object": isSentryObject,
    "sentry_data": sentryData,
  };

  @override
  String toString() {
    return "$links, $id, $neoReferenceId, $name, $nasaJplUrl, $absoluteMagnitudeH, $estimatedDiameter, $isPotentiallyHazardousAsteroid, $closeApproachData, $isSentryObject, $sentryData, ";
  }
}

class CloseApproachDatum {
  CloseApproachDatum({
    required this.closeApproachDate,
    required this.closeApproachDateFull,
    required this.epochDateCloseApproach,
    required this.relativeVelocity,
    required this.missDistance,
    required this.orbitingBody,
  });

  final DateTime? closeApproachDate;
  final String? closeApproachDateFull;
  final int? epochDateCloseApproach;
  final RelativeVelocity? relativeVelocity;
  final MissDistance? missDistance;
  final String? orbitingBody;

  factory CloseApproachDatum.fromJson(Map<String, dynamic> json) {
    return CloseApproachDatum(
      closeApproachDate: DateTime.tryParse(json["close_approach_date"] ?? ""),
      closeApproachDateFull: json["close_approach_date_full"],
      epochDateCloseApproach: json["epoch_date_close_approach"],
      relativeVelocity:
          json["relative_velocity"] == null
              ? null
              : RelativeVelocity.fromJson(json["relative_velocity"]),
      missDistance:
          json["miss_distance"] == null
              ? null
              : MissDistance.fromJson(json["miss_distance"]),
      orbitingBody: json["orbiting_body"],
    );
  }

  Map<String, dynamic> toJson() => {
    "close_approach_date":
        "${closeApproachDate?.year.toString().padLeft(4, '0')}-${closeApproachDate?.month.toString().padLeft(2, '0')}-${closeApproachDate?.day.toString().padLeft(2, '0')}",
    "close_approach_date_full": closeApproachDateFull,
    "epoch_date_close_approach": epochDateCloseApproach,
    "relative_velocity": relativeVelocity?.toJson(),
    "miss_distance": missDistance?.toJson(),
    "orbiting_body": orbitingBody,
  };

  @override
  String toString() {
    return "$closeApproachDate, $closeApproachDateFull, $epochDateCloseApproach, $relativeVelocity, $missDistance, $orbitingBody, ";
  }
}

class MissDistance {
  MissDistance({
    required this.astronomical,
    required this.lunar,
    required this.kilometers,
    required this.miles,
  });

  final String? astronomical;
  final String? lunar;
  final String? kilometers;
  final String? miles;

  factory MissDistance.fromJson(Map<String, dynamic> json) {
    return MissDistance(
      astronomical: json["astronomical"],
      lunar: json["lunar"],
      kilometers: json["kilometers"],
      miles: json["miles"],
    );
  }

  Map<String, dynamic> toJson() => {
    "astronomical": astronomical,
    "lunar": lunar,
    "kilometers": kilometers,
    "miles": miles,
  };

  @override
  String toString() {
    return "$astronomical, $lunar, $kilometers, $miles, ";
  }
}

class RelativeVelocity {
  RelativeVelocity({
    required this.kilometersPerSecond,
    required this.kilometersPerHour,
    required this.milesPerHour,
  });

  final String? kilometersPerSecond;
  final String? kilometersPerHour;
  final String? milesPerHour;

  factory RelativeVelocity.fromJson(Map<String, dynamic> json) {
    return RelativeVelocity(
      kilometersPerSecond: json["kilometers_per_second"],
      kilometersPerHour: json["kilometers_per_hour"],
      milesPerHour: json["miles_per_hour"],
    );
  }

  Map<String, dynamic> toJson() => {
    "kilometers_per_second": kilometersPerSecond,
    "kilometers_per_hour": kilometersPerHour,
    "miles_per_hour": milesPerHour,
  };

  @override
  String toString() {
    return "$kilometersPerSecond, $kilometersPerHour, $milesPerHour, ";
  }
}

class EstimatedDiameter {
  EstimatedDiameter({
    required this.kilometers,
    required this.meters,
    required this.miles,
    required this.feet,
  });

  final Feet? kilometers;
  final Feet? meters;
  final Feet? miles;
  final Feet? feet;

  factory EstimatedDiameter.fromJson(Map<String, dynamic> json) {
    return EstimatedDiameter(
      kilometers:
          json["kilometers"] == null ? null : Feet.fromJson(json["kilometers"]),
      meters: json["meters"] == null ? null : Feet.fromJson(json["meters"]),
      miles: json["miles"] == null ? null : Feet.fromJson(json["miles"]),
      feet: json["feet"] == null ? null : Feet.fromJson(json["feet"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "kilometers": kilometers?.toJson(),
    "meters": meters?.toJson(),
    "miles": miles?.toJson(),
    "feet": feet?.toJson(),
  };

  @override
  String toString() {
    return "$kilometers, $meters, $miles, $feet, ";
  }
}

class Feet {
  Feet({
    required this.estimatedDiameterMin,
    required this.estimatedDiameterMax,
  });

  final double? estimatedDiameterMin;
  final double? estimatedDiameterMax;

  factory Feet.fromJson(Map<String, dynamic> json) {
    return Feet(
      estimatedDiameterMin: json["estimated_diameter_min"],
      estimatedDiameterMax: json["estimated_diameter_max"],
    );
  }

  Map<String, dynamic> toJson() => {
    "estimated_diameter_min": estimatedDiameterMin,
    "estimated_diameter_max": estimatedDiameterMax,
  };

  @override
  String toString() {
    return "$estimatedDiameterMin, $estimatedDiameterMax, ";
  }
}

class NearEarthObjectLinks {
  NearEarthObjectLinks({required this.self});

  final String? self;

  factory NearEarthObjectLinks.fromJson(Map<String, dynamic> json) {
    return NearEarthObjectLinks(self: json["self"]);
  }

  Map<String, dynamic> toJson() => {"self": self};

  @override
  String toString() {
    return "$self, ";
  }
}
