/// Model for a selectable date
class SelectableDate {
  final DateTime date;
  bool isSelected;

  SelectableDate({required this.date, this.isSelected = false});
}
