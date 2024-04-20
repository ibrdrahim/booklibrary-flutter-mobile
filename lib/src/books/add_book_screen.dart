import 'package:flutter/material.dart';
import 'package:flutter_booklibrary/src/services/book_api.dart';

class AddBookScreen extends StatefulWidget {
  final Book? bookToUpdate;
  final Function? onUpdated;

  AddBookScreen({Key? key, this.bookToUpdate, this.onUpdated})
      : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _summaryController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _genreController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.bookToUpdate != null) {
      _titleController.text = widget.bookToUpdate!.title;
      _authorController.text = widget.bookToUpdate!.author;
      _summaryController.text = widget.bookToUpdate!.summary;
      _yearController.text = widget.bookToUpdate!.year.toString();
      _genreController.text = widget.bookToUpdate!.genre;
    }
  }

  Future<void> _saveBook() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (widget.bookToUpdate != null) {
        // Update book
        await BooksApi.updateBook(widget.bookToUpdate!.id, {
          'title': _titleController.text,
          'author': _authorController.text,
          'summary': _summaryController.text,
          'year': int.tryParse(_yearController.text) ?? 0,
          'genre': _genreController.text,
        });
        widget.onUpdated?.call();
      } else {
        // Create book
        await BooksApi.createBook({
          'title': _titleController.text,
          'author': _authorController.text,
          'summary': _summaryController.text,
          'year': int.tryParse(_yearController.text) ?? 0,
          'genre': _genreController.text,
        });
        widget.onUpdated?.call();
      }
      Navigator.pop(context); // Close add book screen
    } catch (e) {
      // Handle error
      print('Failed to save book: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.bookToUpdate != null ? 'Edit Book' : 'Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: _summaryController,
                decoration: InputDecoration(labelText: 'Summary'),
                maxLines: 3,
              ),
              TextField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _genreController,
                decoration: InputDecoration(labelText: 'Genre'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveBook,
                child: _isLoading ? CircularProgressIndicator() : Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
