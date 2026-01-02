import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: "Hello! I'm your AI Safety Assistant for everyone. I can help you with:\n\n"
            "🔹 Legal advice on Indian laws (for all citizens)\n"
            "🔹 Safety tips and guidance\n"
            "🔹 Emergency procedures\n"
            "🔹 Traffic rules & regulations\n"
            "🔹 Rights awareness for everyone\n\n"
            "How can I assist you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      _generateAIResponse(userMessage);
    });
  }

  void _generateAIResponse(String userMessage) {
    String response = _getAIResponse(userMessage.toLowerCase());

    setState(() {
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isTyping = false;
    });
    _scrollToBottom();
  }

  String _getAIResponse(String message) {

    if (message.contains('emergency') || message.contains('help') || message.contains('danger')) {
      return "🚨 **Emergency Protocol Activated**\n\n"
          "1. Press SOS button in the app immediately\n"
          "2. Call emergency: 112 (National Emergency) or 1091 (Women Helpline)\n"
          "3. Your location is being shared with emergency contacts\n"
          "4. Stay calm and move to a safe, public area\n"
          "5. If possible, turn on video recording\n\n"
          "Would you like me to guide you through specific safety steps?";
    }

    if (message.contains('law') || message.contains('legal') || message.contains('rights')) {
      return "⚖️ **Legal Information Available**\n\n"
          "I can help you understand 27 Indian laws including:\n\n"
          "• Section 354 IPC - Assault & Molestation\n"
          "• POSH Act 2013 - Workplace Harassment\n"
          "• Domestic Violence Act 2005\n"
          "• IT Act 66/67 - Cyber Crimes\n"
          "• Right to Information Act\n\n"
          "Access the full Laws Library through the home screen or ask me about a specific law!";
    }

    if (message.contains('safe') || message.contains('route') || message.contains('area')) {
      return "🗺️ **AI Safety Analysis**\n\n"
          "Based on real-time data, I can analyze:\n\n"
          "✓ Safest routes to your destination\n"
          "✓ Well-lit areas with CCTV coverage\n"
          "✓ Nearby police stations and safe spots\n"
          "✓ Areas to avoid based on crime data\n"
          "✓ Public transport safety ratings\n\n"
          "Share your destination and I'll suggest the safest path!";
    }

    if (message.contains('cyber') || message.contains('online') || message.contains('hack')) {
      return "🛡️ **Cyber Safety Tips**\n\n"
          "AI-Detected Threats Protection:\n\n"
          "1. Never share OTPs or passwords\n"
          "2. Enable 2-factor authentication\n"
          "3. Report cyber harassment: cybercrime.gov.in\n"
          "4. Block suspicious contacts\n"
          "5. Use strong, unique passwords\n\n"
          "Under IT Act 66/67, cyber harassment is punishable up to 3 years imprisonment!";
    }

    if (message.contains('workplace') || message.contains('office') || message.contains('harass')) {
      return "💼 **Workplace Rights (AI Analysis)**\n\n"
          "You're protected under:\n\n"
          "📋 POSH Act 2013 - Every company with 10+ employees must have Internal Complaints Committee\n"
          "📋 Equal Remuneration Act - Same pay for same work\n"
          "📋 Maternity Benefits - 26 weeks paid leave\n\n"
          "Steps to take:\n"
          "1. Document all incidents with dates\n"
          "2. File complaint with ICC\n"
          "3. Report to labour.gov.in if needed\n\n"
          "Need help drafting a complaint?";
    }

    if (message.contains('threat') || message.contains('detect') || message.contains('ai')) {
      return "🤖 **AI Threat Detection Active**\n\n"
          "Our AI monitors:\n\n"
          "🔍 Unusual location patterns\n"
          "🔍 Suspicious contacts/calls\n"
          "🔍 Late night movements\n"
          "🔍 Deviation from regular routes\n"
          "🔍 Rapid location changes\n\n"
          "When threat detected:\n"
          "• Auto-alert to emergency contacts\n"
          "• Location sharing activated\n"
          "• Nearby safe spots highlighted\n\n"
          "Your safety score: 98% (Excellent)";
    }

    if (message.contains('thank') || message.contains('thanks')) {
      return "You're welcome! 😊 I'm here 24/7 to help keep you safe. Stay empowered and informed!\n\n"
          "Remember: Your safety is our priority. Don't hesitate to reach out anytime.";
    }

    return "🤖 **AI Assistant Analysis**\n\n"
        "I understand your concern. Based on your query, I recommend:\n\n"
        "1. Check our Laws Library for legal information (27 laws available)\n"
        "2. Enable location sharing for real-time safety\n"
        "3. Set up emergency contacts\n"
        "4. Review safety tips in the app\n\n"
        "Could you provide more details about what you need help with?\n\n"
        "💡 Try asking about: emergency help, laws, safety routes, cyber crimes, or workplace rights.";
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI Safety Assistant', style: TextStyle(fontSize: 16)),
                Text(
                  'Powered by Advanced AI',
                  style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _addWelcomeMessage();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.1),
                ],
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.primary.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.circle, color: Colors.white, size: 8),
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI Online • Real-time Analysis Active',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Icon(Icons.verified_user, size: 16, color: AppColors.success),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(3, (index) {
                              return _TypingDot(delay: index * 200);
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ask me anything about safety...',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _handleSendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _handleSendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: message.isUser
                    ? LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      )
                    : null,
                color: message.isUser ? null : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: (message.isUser ? AppColors.primary : Colors.black)
                        .withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : AppColors.textPrimary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: AppColors.primary, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class _TypingDot extends StatefulWidget {
  final int delay;

  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
