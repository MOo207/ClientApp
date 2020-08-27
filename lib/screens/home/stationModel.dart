// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

List<Station> stationFromJson(String str) => List<Station>.from(json.decode(str).map((x) => Station.fromJson(x)));

String stationToJson(List<Station> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Station {
    Station({
        this.id,
        this.name,
        this.cameras,
        this.longitude,
        this.latitude,
        this.maxCapacity,
    });

Station.de(
        this.id,
        this.name,
        this.cameras,
        this.longitude,
        this.latitude,
        this.maxCapacity,
    );

    String id;
    String name;
    List<Camera> cameras;
    String longitude;
    String latitude;
    int maxCapacity;

    factory Station.fromJson(Map<String, dynamic> json) => Station(
        id: json["_id"],
        name: json["name"] == null ? null : json["name"],
        cameras: List<Camera>.from(json["cameras"].map((x) => Camera.fromJson(x))),
        longitude: json["longitude"],
        latitude: json["latitude"],
        maxCapacity: json["maxCapacity"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name == null ? null : name,
        "cameras": List<dynamic>.from(cameras.map((x) => x.toJson())),
        "longitude": longitude,
        "latitude": latitude,
        "maxCapacity": maxCapacity,
    };
}

class Camera {
    Camera({
        this.lastImage,
        this.id,
        this.key,
        this.peopleCount,
    });

    DateTime lastImage;
    String id;
    String key;
    int peopleCount;

    factory Camera.fromJson(Map<String, dynamic> json) => Camera(
        lastImage: DateTime.parse(json["lastImage"]),
        id: json["_id"],
        key: json["Key"],
        peopleCount: json["peopleCount"],
    );

    Map<String, dynamic> toJson() => {
        "lastImage": lastImage.toIso8601String(),
        "_id": id,
        "Key": key,
        "peopleCount": peopleCount,
    };
}
