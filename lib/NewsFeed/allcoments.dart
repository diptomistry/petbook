import 'package:flutter/material.dart';

class AllCommentsScreen extends StatelessWidget {
  final String postId;
  final List<String> comments; // Pass the list of comments to this screen

  AllCommentsScreen(this.postId, this.comments);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(comments[index]),
                  // You can add more information about the comments here, such as the user who made the comment, timestamp, etc.
                );
              },
            ),
          ),
          // Comment input field at the bottom of the screen
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                    onSubmitted: (comment) {
                      // Implement a function to post the comment to Firestore.
                      // postComment(postId, comment);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Post the comment to Firestore when the send button is pressed.
                    // Call the postComment function here.
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
