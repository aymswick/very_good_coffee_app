import 'package:equatable/equatable.dart';

/// Stores the URL for a coffee on the web.
class Coffee extends Equatable {
  final Uri url;
  final String name;

  const Coffee({required this.url, required this.name});

  @override
  List<Object?> get props => [url, name];

  @override
  bool get stringify => true;
}
