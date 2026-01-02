import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

class LearningHubScreen extends ConsumerStatefulWidget {
  const LearningHubScreen({super.key});

  @override
  ConsumerState<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends ConsumerState<LearningHubScreen> {
  int _selectedCategory = 0;

  final List<Map<String, dynamic>> categories = [
    {'title': 'All', 'icon': Icons.grid_view},
    {'title': 'Safety', 'icon': Icons.shield},
    {'title': 'Health', 'icon': Icons.favorite},
    {'title': 'Career', 'icon': Icons.work},
    {'title': 'Skills', 'icon': Icons.school},
  ];

  final List<Map<String, dynamic>> learningModules = [
    {
      'title': 'Self-Defense Basics',
      'category': 'Safety',
      'duration': '15 min',
      'lessons': 8,
      'icon': Icons.sports_martial_arts,
      'color': Color(0xFFFF6B35),
      'description': 'Learn essential self-defense techniques',
      'topics': ['Awareness', 'Escape Tactics', 'Basic Strikes', 'Defense Postures'],
    },
    {
      'title': 'Know Your Rights',
      'category': 'Safety',
      'duration': '20 min',
      'lessons': 12,
      'icon': Icons.gavel,
      'color': Color(0xFF6366F1),
      'description': 'Understand your legal rights as a woman',
      'topics': ['Workplace Rights', 'Legal Protection', 'Filing Complaints', 'Support Systems'],
    },
    {
      'title': 'Digital Safety',
      'category': 'Safety',
      'duration': '10 min',
      'lessons': 6,
      'icon': Icons.security,
      'color': Color(0xFF06B6D4),
      'description': 'Protect yourself online',
      'topics': ['Privacy Settings', 'Scam Detection', 'Password Security', 'Safe Browsing'],
    },
    {
      'title': 'Mental Health & Wellness',
      'category': 'Health',
      'duration': '25 min',
      'lessons': 10,
      'icon': Icons.psychology,
      'color': Color(0xFF8B5CF6),
      'description': 'Manage stress and build resilience',
      'topics': ['Stress Management', 'Meditation', 'Self-Care', 'Seeking Help'],
    },
    {
      'title': 'First Aid Essentials',
      'category': 'Health',
      'duration': '18 min',
      'lessons': 9,
      'icon': Icons.medical_services,
      'color': Color(0xFFEF4444),
      'description': 'Basic first aid everyone should know',
      'topics': ['CPR', 'Wound Care', 'Burns', 'Emergency Response'],
    },
    {
      'title': 'Financial Literacy',
      'category': 'Career',
      'duration': '30 min',
      'lessons': 15,
      'icon': Icons.account_balance_wallet,
      'color': Color(0xFF10B981),
      'description': 'Manage money and build wealth',
      'topics': ['Budgeting', 'Saving', 'Investing', 'Credit Score'],
    },
    {
      'title': 'Career Development',
      'category': 'Career',
      'duration': '22 min',
      'lessons': 11,
      'icon': Icons.trending_up,
      'color': Color(0xFFF59E0B),
      'description': 'Advance your professional journey',
      'topics': ['Resume Building', 'Interview Skills', 'Networking', 'Leadership'],
    },
    {
      'title': 'Communication Skills',
      'category': 'Skills',
      'duration': '12 min',
      'lessons': 7,
      'icon': Icons.chat,
      'color': Color(0xFF3B82F6),
      'description': 'Improve verbal and written communication',
      'topics': ['Public Speaking', 'Active Listening', 'Body Language', 'Assertiveness'],
    },
    {
      'title': 'Time Management',
      'category': 'Skills',
      'duration': '15 min',
      'lessons': 8,
      'icon': Icons.schedule,
      'color': Color(0xFFEC4899),
      'description': 'Master productivity and planning',
      'topics': ['Goal Setting', 'Prioritization', 'Focus Techniques', 'Work-Life Balance'],
    },
  ];

  List<Map<String, dynamic>> get filteredModules {
    if (_selectedCategory == 0) return learningModules;
    String selectedCat = categories[_selectedCategory]['title'];
    return learningModules.where((m) => m['category'] == selectedCat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8B5CF6),
                      Color(0xFF6366F1),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Learn & Grow',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Empower yourself with knowledge',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategory == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () => setState(() => _selectedCategory = index),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [AppColors.primary, AppColors.accent],
                                )
                              : null,
                          color: isSelected ? null : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : AppColors.primary.withOpacity(0.2),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              categories[index]['icon'],
                              color: isSelected ? Colors.white : AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              categories[index]['title'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('${filteredModules.length}', 'Courses'),
                    Container(width: 1, height: 30, color: AppColors.primary.withOpacity(0.2)),
                    _buildStat('85+', 'Lessons'),
                    Container(width: 1, height: 30, color: AppColors.primary.withOpacity(0.2)),
                    _buildStat('Free', 'Access'),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final module = filteredModules[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildModuleCard(module),
                  );
                },
                childCount: filteredModules.length,
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    return InkWell(
      onTap: () => _showModuleDetails(module),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [module['color'], module['color'].withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(module['icon'], color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.play_circle_outline, size: 14, color: module['color']),
                        const SizedBox(width: 4),
                        Text(
                          '${module['lessons']} lessons',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.timer_outlined, size: 14, color: module['color']),
                        const SizedBox(width: 4),
                        Text(
                          module['duration'],
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  void _showModuleDetails(Map<String, dynamic> module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [

            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [module['color'], module['color'].withOpacity(0.7)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(module['icon'], color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                module['title'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: module['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  module['category'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: module['color'],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Text(
                      module['description'],
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        _buildDetailStat(Icons.play_circle_outline, '${module['lessons']} Lessons'),
                        const SizedBox(width: 20),
                        _buildDetailStat(Icons.timer_outlined, module['duration']),
                        const SizedBox(width: 20),
                        _buildDetailStat(Icons.star, 'Beginner'),
                      ],
                    ),
                    const SizedBox(height: 28),

                    const Text(
                      'What You\'ll Learn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(
                      (module['topics'] as List).length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: module['color'].withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.check, color: module['color'], size: 16),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                module['topics'][index],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Coming Soon: ${module['title']} course'),
                              backgroundColor: module['color'],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: module['color'],
                          padding: const EdgeInsets.all(18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Start Learning',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
