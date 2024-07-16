class Candidate {
  int age;
  String election_programm;
  int group;
  int id;
  String name;
  String picture_name;
  String remarck;
  List<String> pictUrl = [];

  Candidate(
      {required this.age,
      required this.election_programm,
      required this.group,
      required this.id,
      required this.name,
      required this.picture_name,
      required this.remarck});

  factory Candidate.fromJson(Map<dynamic, dynamic> json) {
    return Candidate(
        age: json['Age'],
        election_programm: json['ElectionProgramm'],
        group: json['Group'],
        id: json['Id'],
        name: json['Name'],
        picture_name: json['PictureName'],
        remarck: json['Remarck']);
  }
}
