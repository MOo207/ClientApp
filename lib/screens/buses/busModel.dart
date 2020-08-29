// To parse this JSON data, do
//
//     final bus = busFromJson(jsonString);

import 'dart:convert';

List<Bus> busFromJson(String str) => List<Bus>.from(json.decode(str).map((x) => Bus.fromJson(x)));

String busToJson(List<Bus> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bus {
    Bus({
        this.id,
        this.status,
        this.maxCap,
        this.currentCap,
        this.lat,
        this.long,
        this.source,
        this.destination,
        this.v,
    });

    String id;
    String status;
    int maxCap;
    int currentCap;
    String lat;
    String long;
    String source;
    String destination;
    int v;

    factory Bus.fromJson(Map<String, dynamic> json) => Bus(
        id: json["_id"],
        status: json["status"],
        maxCap: json["maxCap"],
        currentCap: json["currentCap"],
        lat: json["lat"],
        long: json["long"],
        source: json["source"],
        destination: json["destination"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "maxCap": maxCap,
        "currentCap": currentCap,
        "lat": lat,
        "long": long,
        "source": source,
        "destination": destination,
        "__v": v,
    };
}
