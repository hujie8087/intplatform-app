class BusTimetable {
  String? routeId;
  String? name;
  List<Stops>? stops;
  List<Directions>? directions;

  BusTimetable({this.routeId, this.name, this.stops, this.directions});

  BusTimetable.fromJson(Map<String, dynamic> json) {
    routeId = json['routeId'];
    name = json['name'];
    if (json['stops'] != null) {
      stops = <Stops>[];
      json['stops'].forEach((v) {
        stops!.add(new Stops.fromJson(v));
      });
    }
    if (json['directions'] != null) {
      directions = <Directions>[];
      json['directions'].forEach((v) {
        directions!.add(new Directions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['routeId'] = this.routeId;
    data['name'] = this.name;
    if (this.stops != null) {
      data['stops'] = this.stops!.map((v) => v.toJson()).toList();
    }
    if (this.directions != null) {
      data['directions'] = this.directions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stops {
  String? stopId;
  String? name;
  String? idName;
  int? order;

  Stops({this.stopId, this.name, this.idName, this.order});

  Stops.fromJson(Map<String, dynamic> json) {
    stopId = json['stopId'];
    name = json['name'];
    idName = json['idName'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stopId'] = this.stopId;
    data['name'] = this.name;
    data['idName'] = this.idName;
    data['order'] = this.order;
    return data;
  }
}

class Directions {
  String? directionId;
  String? name;
  List<Trips>? trips;

  Directions({this.directionId, this.name, this.trips});

  Directions.fromJson(Map<String, dynamic> json) {
    directionId = json['directionId'];
    name = json['name'];
    if (json['trips'] != null) {
      trips = <Trips>[];
      json['trips'].forEach((v) {
        trips!.add(new Trips.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['directionId'] = this.directionId;
    data['name'] = this.name;
    if (this.trips != null) {
      data['trips'] = this.trips!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trips {
  String? tripId;
  String? departureTime;
  String? arrivalTime;

  Trips({this.tripId, this.departureTime, this.arrivalTime});

  Trips.fromJson(Map<String, dynamic> json) {
    tripId = json['tripId'];
    departureTime = json['departureTime'];
    arrivalTime = json['arrivalTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tripId'] = this.tripId;
    data['departureTime'] = this.departureTime;
    data['arrivalTime'] = this.arrivalTime;
    return data;
  }
}
