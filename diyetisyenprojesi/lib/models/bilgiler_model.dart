class Bilgiler {
  Bilgiler({required this.index, required this.yas});
  int index;
  int yas;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['yas'] = yas;
    return toJson();
  }
}
