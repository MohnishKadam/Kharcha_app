import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/chat_provider.dart';
// Chat service is accessed through providers
import '../../models/chat_message.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showQuickResponses = true;

  @override
  void initState() {
    super.initState();
    // Initialize chat session if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(currentChatSessionProvider);
      if (session == null) {
        ref.read(currentChatSessionProvider.notifier).startNewSession();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isApiConfigured = ref.watch(isApiKeyConfiguredProvider);

    if (!isApiConfigured) {
      return _buildApiSetupScreen();
    }

    final messages = ref.watch(chatMessagesProvider);
    final isTyping = ref.watch(isTypingProvider);
    final quickResponses = ref.watch(quickResponsesProvider);
    final contextualSuggestions = ref.watch(contextualSuggestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.psychology,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kharcha AI',
                  style: AppTypography.callout.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isTyping)
                  Text(
                    'Typing...',
                    style: AppTypography.caption2.copyWith(
                      color: AppColors.success,
                    ),
                  )
                else
                  Text(
                    'Online',
                    style: AppTypography.caption2.copyWith(
                      color: AppColors.success,
                    ),
                  ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Clear Chat'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Refresh Context'),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState()
                : DashChat(
                    currentUser: ChatUsers.user,
                    onSend: _onSendMessage,
                    messages:
                        messages.map((msg) => msg.toDashChatMessage()).toList(),
                    messageOptions: MessageOptions(
                      currentUserContainerColor: AppColors.accent,
                      currentUserTextColor: Colors.white,
                      containerColor: AppColors.surface,
                      textColor: AppColors.primaryText,
                      borderRadius: 16,
                      messagePadding: const EdgeInsets.all(AppSpacing.md),
                      showTime: true,
                      timeFormat: DateFormat('HH:mm'),
                    ),
                    messageListOptions: MessageListOptions(
                      scrollController: _scrollController,
                    ),
                    inputOptions: InputOptions(
                      sendButtonBuilder: _buildSendButton,
                      inputTextStyle: AppTypography.body,
                      inputDecoration: InputDecoration(
                        hintText: 'Ask about your expenses...',
                        hintStyle: AppTypography.body.copyWith(
                          color: AppColors.secondaryText,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
          ),

          // Quick responses section
          if (_showQuickResponses &&
              (quickResponses.isNotEmpty || contextualSuggestions.isNotEmpty))
            _buildQuickResponsesSection(quickResponses, contextualSuggestions),

          // Custom input area (if needed for additional features)
          _buildCustomInputArea(),
        ],
      ),
    );
  }

  Widget _buildApiSetupScreen() {
    final helpMessage = ref.watch(apiHelpMessageProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Chat Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.api,
                    size: 64,
                    color: AppColors.warning,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'API Setup Required',
                    style: AppTypography.title2.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    helpMessage,
                    style: AppTypography.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                ),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.psychology,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Welcome to Kharcha AI!',
              style: AppTypography.title2.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Your personal finance assistant is ready to help you understand your spending, plan budgets, and make smarter financial decisions.',
              style: AppTypography.callout.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () =>
                  _sendQuickMessage('Hello! Show me my spending summary'),
              icon: const Icon(Icons.chat_bubble),
              label: const Text('Start Chatting'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickResponsesSection(
      List<String> quickResponses, List<String> contextualSuggestions) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Quick Actions',
                style: AppTypography.caption1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _showQuickResponses = false),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Contextual suggestions first
          if (contextualSuggestions.isNotEmpty) ...[
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: contextualSuggestions
                  .map(
                    (suggestion) =>
                        _buildQuickResponseChip(suggestion, isContextual: true),
                  )
                  .toList(),
            ),
            if (quickResponses.isNotEmpty)
              const SizedBox(height: AppSpacing.sm),
          ],

          // Regular quick responses
          if (quickResponses.isNotEmpty)
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: quickResponses
                  .map(
                    (response) => _buildQuickResponseChip(response),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickResponseChip(String text, {bool isContextual = false}) {
    return GestureDetector(
      onTap: () => _sendQuickMessage(text),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isContextual
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: isContextual
                ? AppColors.accent.withValues(alpha: 0.3)
                : AppColors.divider,
          ),
        ),
        child: Text(
          text,
          style: AppTypography.caption1.copyWith(
            color: isContextual ? AppColors.accent : AppColors.primaryText,
            fontWeight: isContextual ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          if (!_showQuickResponses)
            GestureDetector(
              onTap: () => setState(() => _showQuickResponses = true),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 16,
                  color: AppColors.accent,
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Powered by Gemini AI',
            style: AppTypography.caption2.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildMessageText(ChatMessage message, ChatMessage? previousMessage,
      ChatMessage? nextMessage) {
    final customProps = message.customProperties;
    final messageType = customProps?['type'];

    if (messageType == 'error') {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 16,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                message.text,
                style: AppTypography.callout.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (messageType == 'typing') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Thinking...',
            style: AppTypography.callout.copyWith(
              color: AppColors.secondaryText,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    return Text(message.text,
        style: AppTypography.body); // Default text rendering
  }

  Widget _buildSendButton(Function() onSend) {
    return GestureDetector(
      onTap: onSend,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Icon(
          Icons.send,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _onSendMessage(ChatMessage message) {
    _sendMessage(message.text);
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final sendMessage = ref.read(sendMessageProvider);
    sendMessage(text);

    setState(() {
      _showQuickResponses = false;
    });

    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendQuickMessage(String text) {
    _sendMessage(text);
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'clear':
        _clearChat();
        break;
      case 'refresh':
        _refreshContext();
        break;
    }
  }

  Future<void> _clearChat() async {
    final clearChat = ref.read(clearChatProvider);
    await clearChat();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Chat cleared'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _refreshContext() async {
    final refreshContext = ref.read(refreshContextProvider);
    await refreshContext();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Context refreshed with latest expense data'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
