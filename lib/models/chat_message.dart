import 'package:dash_chat_2/dash_chat_2.dart';

/// Chat message model for Gemini chatbot
class ChatMessageModel {
  final String id;
  final String text;
  final DateTime createdAt;
  final bool isFromUser;
  final MessageType type;
  final String? error;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.isFromUser,
    this.type = MessageType.text,
    this.error,
  });

  /// Convert to DashChat message format
  ChatMessage toDashChatMessage() {
    return ChatMessage(
      text: text,
      user: isFromUser ? ChatUsers.user : ChatUsers.gemini,
      createdAt: createdAt,
      customProperties: {
        'id': id,
        'type': type.name,
        if (error != null) 'error': error!,
      },
    );
  }

  /// Create from DashChat message
  factory ChatMessageModel.fromDashChatMessage(ChatMessage message) {
    return ChatMessageModel(
      id: message.customProperties?['id'] ??
          message.createdAt.millisecondsSinceEpoch.toString(),
      text: message.text,
      createdAt: message.createdAt,
      isFromUser: message.user.id == ChatUsers.user.id,
      type: MessageType.values.firstWhere(
        (type) => type.name == message.customProperties?['type'],
        orElse: () => MessageType.text,
      ),
      error: message.customProperties?['error'],
    );
  }

  /// Create error message
  factory ChatMessageModel.error({
    required String errorText,
    required DateTime createdAt,
  }) {
    return ChatMessageModel(
      id: 'error_${createdAt.millisecondsSinceEpoch}',
      text: errorText,
      createdAt: createdAt,
      isFromUser: false,
      type: MessageType.error,
      error: errorText,
    );
  }

  /// Create typing indicator message
  factory ChatMessageModel.typing() {
    return ChatMessageModel(
      id: 'typing_${DateTime.now().millisecondsSinceEpoch}',
      text: 'Thinking...',
      createdAt: DateTime.now(),
      isFromUser: false,
      type: MessageType.typing,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
        'isFromUser': isFromUser,
        'type': type.name,
        'error': error,
      };

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        id: json['id'],
        text: json['text'],
        createdAt: DateTime.parse(json['createdAt']),
        isFromUser: json['isFromUser'],
        type: MessageType.values.firstWhere(
          (type) => type.name == json['type'],
          orElse: () => MessageType.text,
        ),
        error: json['error'],
      );
}

enum MessageType {
  text,
  error,
  typing,
  system,
}

/// Predefined chat users
class ChatUsers {
  static final ChatUser user = ChatUser(
    id: 'user_1',
    firstName: 'MOHNISH',
    lastName: '',
    profileImage: 'https://api.dicebear.com/7.x/avataaars/png?seed=user',
  );

  static final ChatUser gemini = ChatUser(
    id: 'gemini',
    firstName: 'Kharcha',
    lastName: 'AI',
    profileImage: 'https://api.dicebear.com/7.x/bottts/png?seed=gemini',
  );
}

/// Chat session model
class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final List<ChatMessageModel> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastUpdated,
    required this.messages,
  });

  ChatSession copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? lastUpdated,
    List<ChatMessageModel>? messages,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'lastUpdated': lastUpdated.toIso8601String(),
        'messages': messages.map((msg) => msg.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'],
        title: json['title'],
        createdAt: DateTime.parse(json['createdAt']),
        lastUpdated: DateTime.parse(json['lastUpdated']),
        messages: (json['messages'] as List)
            .map((msg) => ChatMessageModel.fromJson(msg))
            .toList(),
      );
}
