class CookingStep {
  CookingStep({required this.description, required this.duration});

  String description;
  String duration;

  factory CookingStep.fromJson(Map<String, dynamic> json) {
    return CookingStep(
        description: json['description'] ?? '',
        duration: json['duration'] ?? '');
  }

  @override
  String toString() {
    return 'CookingStep{description: $description, duration: $duration}';
  }
}
