class Expense {
  final int? id;
  final String title;
  final String category;
  final DateTime date;
  final double price;
  final String? note;

  const Expense({
    this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.price,
    this.note,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date']),
      price: json['price'],
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'title': title,
      'category': category,
      'price': price,
      'date': date.toIso8601String(),
      'note': note,
    };
  }
}
