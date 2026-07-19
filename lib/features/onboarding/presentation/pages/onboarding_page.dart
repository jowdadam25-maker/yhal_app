import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yhla/core/constants/app_strings.dart';
import 'package:yhla/core/theme/app_colors.dart';
import 'package:yhla/core/theme/app_text_styles.dart';
import '../models/onboarding_page_data.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_illustration.dart';
import '../widgets/onboarding_title.dart';
import '../widgets/onboarding_description.dart';
import '../widgets/onboarding_bottom_navigation.dart';
import '../widgets/onboarding_primary_cta_button.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  final VoidCallback onOnboardingComplete;

  const OnboardingPage({
    required this.onOnboardingComplete,
    super.key,
  });

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _backgroundAnimationController;
  late AnimationController _illustrationAnimationController;
  late AnimationController _contentAnimationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupAnimations();
    _precacheImages();
  }

  void _setupAnimations() {
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _illustrationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _backgroundAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _illustrationAnimationController.forward();
        _contentAnimationController.forward();
      }
    });
  }

  void _precacheImages() {
    for (final page in onboardingPages) {
      precacheImage(AssetImage(page.imagePath), context);
    }
  }

  void _handleNext() {
    if (_pageController.page?.toInt() == onboardingPages.length - 1) {
      _handleOnboardingComplete();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleSkip() {
    _handleOnboardingComplete();
  }

  Future<void> _handleOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    
    if (mounted) {
      ref.read(isOnboardingCompleteProvider.notifier).state = true;
      widget.onOnboardingComplete();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundAnimationController.dispose();
    _illustrationAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(currentOnboardingPageProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          _buildBackgroundGradient(),
          // Content
          SafeArea(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                ref.read(currentOnboardingPageProvider.notifier).state = index;
                // Reset animations for new page
                _illustrationAnimationController.reset();
                _contentAnimationController.reset();
                _illustrationAnimationController.forward();
                _contentAnimationController.forward();
              },
              itemCount: onboardingPages.length,
              itemBuilder: (context, index) {
                return _buildPageContent(
                  onboardingPages[index],
                  index,
                  currentPage,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundTop,
            AppColors.backgroundBottom,
          ],
        ),
      ),
      child: FadeTransition(
        opacity: _backgroundAnimationController,
        child: Container(
          decoration: BoxDecoration(
            radialGradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                AppColors.purpleGlow.withOpacity(0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(
    OnboardingPageData page,
    int pageIndex,
    int currentPage,
  ) {
    final isLastPage = pageIndex == onboardingPages.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Illustration
          ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(
                parent: _illustrationAnimationController,
                curve: Curves.easeOutBack,
              ),
            ),
            child: OnboardingIllustration(
              imagePath: page.imagePath,
              semanticLabel: 'Onboarding illustration for ${page.title}',
              heightPercentage: 0.40,
            ),
          ),
          const SizedBox(height: 20),
          // Step Indicator
          _buildStepIndicator(currentPage),
          const SizedBox(height: 24),
          // Title
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.02),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _contentAnimationController,
                curve: Curves.easeOut,
              ),
            ),
            child: _buildTitle(page.title),
          ),
          const SizedBox(height: 16),
          // Description
          FadeTransition(
            opacity: _contentAnimationController,
            child: OnboardingDescription(
              description: page.description,
              textColor: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          // Bottom Navigation or CTA
          if (isLastPage)
            _buildLastPageContent()
          else
            OnboardingBottomNavigation(
              totalPages: onboardingPages.length,
              currentPage: currentPage,
              isLastPage: false,
              onSkip: _handleSkip,
              onNext: _handleNext,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int currentPage) {
    return Semantics(
      label: 'الخطوة ${currentPage + 1} من ${onboardingPages.length} خطوات',
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryPurple,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            '${currentPage + 1}',
            style: AppTextStyles.stepIndicator,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    // Split title to highlight last word (النقاط, النقاط, النقاط)
    final parts = title.split(' ');
    if (parts.length > 1) {
      final mainText = parts.sublist(0, parts.length - 1).join(' ');
      final highlightedText = parts.last;

      return OnboardingTitle(
        richTextSpan: TextSpan(
          children: [
            TextSpan(
              text: '$mainText ',
              style: const TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: highlightedText,
              style: const TextStyle(color: AppColors.gold),
            ),
          ],
        ),
      );
    }

    return OnboardingTitle(title: title);
  }

  Widget _buildLastPageContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OnboardingPrimaryCTAButton(
          label: AppStrings.onboardingStart,
          onPressed: _handleOnboardingComplete,
          trailingEmoji: '🚀',
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _handleSkip,
          child: Text(
            AppStrings.onboardingSkip,
            style: AppTextStyles.skipButton.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}
