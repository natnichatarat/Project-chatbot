import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class MessagesScreen extends StatefulWidget {
  final List messages;
  final Function(String) onChipSelected;

  const MessagesScreen({
    Key? key,
    required this.messages,
    required this.onChipSelected,
  }) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return ListView.separated(
      controller: _scrollController,
      itemBuilder: (context, index) {
        var isUserMessage = widget.messages[index]['isUserMessage'];
        return _buildMessageRow(
            isUserMessage, w, widget.messages[index]['message']);
      },
      separatorBuilder: (_, i) => SizedBox(height: 10),
      itemCount: widget.messages.length,
    );
  }

  Widget _buildMessageRow(bool isUserMessage, double width, Message message) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(isUserMessage ? 0 : 20),
                topLeft: Radius.circular(isUserMessage ? 20 : 0),
              ),
              color: isUserMessage ? Color(0xFFB6E8FF) : Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            constraints: BoxConstraints(maxWidth: width * 0.85),
            child: _buildMessageContent(message, isUserMessage),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(Message message, bool isUserMessage) {
    List<Widget> contentWidgets = [];

    // Handle text messages
    if (message.text?.text?.isNotEmpty ?? false) {
      contentWidgets.add(
        Text(
          message.text!.text![0],
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      );
    }

    // Handle rich content
    if (message.payload?['richContent'] != null) {
      var richContent = message.payload!['richContent'] as List;

      for (var contentGroup in richContent) {
        for (var content in contentGroup) {
          Widget? contentWidget = _buildRichContentWidget(content);
          if (contentWidget != null) {
            if (contentWidgets.isNotEmpty) {
              contentWidgets.add(SizedBox(height: 12));
            }
            contentWidgets.add(contentWidget);
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: contentWidgets.isNotEmpty
          ? contentWidgets
          : [Text("Unsupported message type")],
    );
  }

  Widget? _buildRichContentWidget(Map<String, dynamic> content) {
    switch (content['type']) {
      case 'info':
        return _buildInfoCard(content);
      case 'carousel':
        return _buildCarousel(content);
      case 'chips':
        return _buildChips(content);
      default:
        return null;
    }
  }

  Widget _buildInfoCard(Map<String, dynamic> content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content['title'] != null)
              Text(
                content['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (content['subtitle'] != null) ...[
              SizedBox(height: 8),
              Text(
                content['subtitle'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(Map<String, dynamic> content) {
    if (content['items'] == null) return SizedBox.shrink();

    return Container(
      height: 340,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: content['items'].length,
        itemBuilder: (context, index) {
          var item = content['items'][index];
          return _buildCarouselItem(item);
        },
      ),
    );
  }

  Widget _buildCarouselItem(Map<String, dynamic> item) {
    return Container(
      width: 260,
      margin: EdgeInsets.only(right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 160,
                width: double.infinity,
                child: Image.network(
                  item['image']?['src']?['rawUrl'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: Icon(
                        Icons.home,
                        size: 50,
                        color: Colors.white70,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    item['subtitle'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/dorm-detail',
                        arguments: {
                          'title': item['title'],
                          'image': item['image']?['src']?['rawUrl'],
                          'subtitle': item['subtitle'],
                          'details': item['details'],
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      item['text'] ?? 'ดูรายละเอียด',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChips(Map<String, dynamic> content) {
    List<Widget> chips = [];

    if (content['options'] != null) {
      chips = (content['options'] as List).map<Widget>((option) {
        return Padding(
          padding: EdgeInsets.only(right: 8, bottom: 8),
          child: ActionChip(
            label: Text(
              option['text'] ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            backgroundColor: Colors.deepPurple,
            elevation: 2,
            shadowColor: Colors.black26,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onPressed: () => widget.onChipSelected(option['text'] ?? ''),
          ),
        );
      }).toList();
    } else if (content['text'] != null) {
      chips = [
        ActionChip(
          label: Text(
            content['text'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          elevation: 2,
          shadowColor: Colors.black26,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          onPressed: () => widget.onChipSelected(content['text']),
        ),
      ];
    }

    return Wrap(
      children: chips,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
