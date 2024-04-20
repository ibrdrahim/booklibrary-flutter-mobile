import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_booklibrary/src/books/add_book_screen.dart';
import 'package:flutter_booklibrary/src/services/book_api.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final int _pageSize = 10;
  List<Book> _books = [];
  bool _isLazyLoading = false;
  bool _isLoading = false;
  bool _isFiltering = false;
  int _offset = 0;
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _loadBooks();

    // Add listener for scroll controller
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks({bool isLazyLoading = false}) async {
    setState(() {
      _isLazyLoading = isLazyLoading;
      _isLoading =
          !isLazyLoading; // Show loading indicator except for lazy loading
    });

    try {
      final books = await BooksApi.fetchBooks(
        _pageSize,
        _offset,
        author: _isFiltering ? _searchController.text : null,
        // year: _isFiltering ? int.tryParse(_searchController.text) : null,
        // genre: _isFiltering ? _searchController.text : null,
      );
      setState(() {
        if (isLazyLoading) {
          // Append books for lazy loading
          _books.addAll(books);
        } else {
          // Reset book list for filtering or initial loading
          _books = books;
        }
        _isLazyLoading = false;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLazyLoading = false;
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Reached the bottom of the list
      _offset += _pageSize;
      _loadBooks(isLazyLoading: true);
    }
  }

  Future<void> _deleteBook(String bookId) async {
    try {
      await BooksApi.deleteBook(bookId);
      // Refresh book list
      setState(() {
        _books.removeWhere((book) => book.id == bookId);
      });
    } catch (e) {
      // Handle error
      print('Failed to delete book: $e');
    }
  }

  void _confirmDeleteBook(String bookId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform delete action here
                Navigator.of(context).pop();
                // Call your delete function
                _deleteBook(bookId);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform logout action here
                Navigator.of(context).pop();
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } catch (e) {
                  print('Error signing out: $e');
                }
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddBookScreen({Book? book}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: AddBookScreen(
          bookToUpdate: book,
          onUpdated: () {
            // Refresh book list if book was updated or added
            setState(() {
              _books.clear();
              _offset = 0; // Reset offset for initial loading
              _loadBooks();
            });
          },
        ),
      ),
    );
  }

  void _applyFilter(String query) {
    setState(() {
      _isFiltering = query.isNotEmpty;
    });
    _books.clear();
    _offset = 0; // Reset offset for initial loading
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _showSearch
            ? TextField(
                controller: _searchController,
                onChanged: _applyFilter,
                decoration: InputDecoration(
                  hintText: 'Search by author',
                  border: InputBorder.none,
                ),
              )
            : Text('Book List'),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.cancel : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
              });
              if (!_showSearch) {
                _applyFilter('');
              }
            },
          ),
          if (!_showSearch)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _confirmLogout(context);
              },
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: _books.length + 1, // +1 for progress indicator
              itemBuilder: (context, index) {
                if (index < _books.length) {
                  final book = _books[index];
                  return ListTile(
                    iconColor: Colors.red,
                    title: Text(book.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text('author : ${book.author} ${book.year}'),
                    onTap: () {
                      _navigateToAddBookScreen(book: book);
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _confirmDeleteBook(book.id);
                      },
                    ),
                  );
                } else {
                  return Offstage(
                      offstage: !_isLazyLoading,
                      child: Center(child: CircularProgressIndicator()));
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddBookScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
