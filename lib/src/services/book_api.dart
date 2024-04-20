import 'dart:convert';

import 'package:flutter_booklibrary/src/services/network_helper.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String summary;
  final int year;
  final String genre;
  final DateTime createdAt;
  final DateTime updatedAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.summary,
    required this.year,
    required this.genre,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      summary: json['summary'] ?? '',
      year: json['year'] ?? 0,
      genre: json['genre'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['createdAt'] as Map<String, dynamic>)['_seconds'] * 1000)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['updatedAt'] as Map<String, dynamic>)['_seconds'] * 1000)
          : DateTime.now(),
    );
  }
}

class BooksApi {
  static Future<List<Book>> fetchBooks(
    int pageSize,
    int offset, {
    String? author,
    // int? year,
    // String? genre,
  }) async {
    // Construct query parameters
    Map<String, dynamic> queryParams = {
      'pageSize': pageSize.toString(),
      'offset': offset.toString(),
    };
    if (author != null) queryParams['author'] = author;
    // if (year != null) queryParams['year'] = year.toString();
    // if (genre != null) queryParams['genre'] = genre;

    // Construct query string
    String queryString = Uri(queryParameters: queryParams).query;

    try {
      final response = await NetworkHelper.request(
        '/books?$queryString',
        method: HttpMethod.GET,
        accessToken: true,
      );
      // Parse response and return list of books
      List<Book> books = [];
      for (var item in response) {
        books.add(Book.fromJson(item));
      }
      return books;
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  static Future<Book> fetchBookDetails(String bookId) async {
    final response = await NetworkHelper.request(
      '/books/$bookId',
      method: HttpMethod.GET,
      accessToken: true,
    );
    // Parse response and return book details
    return Book.fromJson(response);
  }

  static Future<void> updateBook(
      String bookId, Map<String, dynamic> updatedData) async {
    final response = await NetworkHelper.request(
      '/books/$bookId',
      method: HttpMethod.PATCH,
      data: updatedData,
      accessToken: true,
    );
    // Handle response
  }

  static Future<void> createBook(Map<String, dynamic> bookData) async {
    final response = await NetworkHelper.request(
      '/books',
      method: HttpMethod.POST,
      data: bookData,
      accessToken: true,
    );
    // Handle response
  }

  static Future<void> deleteBook(String bookId) async {
    final response = await NetworkHelper.request(
      '/books/$bookId',
      method: HttpMethod.DELETE,
      accessToken: true,
    );
    // Handle response
  }
}
