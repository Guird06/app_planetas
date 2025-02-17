class Planet {
  int? id;
  String name;
  double size;
  double distance;
  String? nickname;

// Constructor
  Planet({
    this.id,
    required this.name,
    required this.size,
    required this.distance,
    this.nickname,
  });

// Alternative Constructor
  Planet.empty():
        name = '',
        size = 0,
        distance = 0,
        nickname = '';

// Method fromMap
  factory Planet.fromMap(Map<String, dynamic> map) {
    return Planet(
      id: map['id'],
      name: map['name'],
      size: map['size'],
      distance: map['distance'],
      nickname: map['nickname'],
    );
  }

// Method toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'distance': distance,
      'nickname': nickname,
    };
  }
}