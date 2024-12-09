import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String posterPath;

  MovieCard({
    required this.title,
    required this.posterPath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(posterPath),
          Text(title),
        ],
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String message;

  ErrorDialog({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
