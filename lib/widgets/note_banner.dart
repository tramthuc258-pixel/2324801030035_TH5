import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NoteBanner extends StatelessWidget {
  const NoteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.bannerBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            const _GradientLayer(
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.bannerStart,
                  AppColors.bannerMiddle,
                  AppColors.bannerEnd,
                ],
                stops: [0, 0.48, 1],
              ),
            ),
            const _GradientLayer(
              RadialGradient(
                center: Alignment(0.7, -1.1),
                radius: 1.25,
                colors: [Color(0xCCDCEFFC), Color(0x00DCEFFC)],
              ),
            ),
            const _GradientLayer(
              RadialGradient(
                center: Alignment(0.85, 1.1),
                radius: 1.05,
                colors: [Color(0xA6ECAEC2), Color(0x00ECAEC2)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.edit_note_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Ghi chú cá nhân',
                                  style: TextStyle(
                                    color: AppColors.bannerInk,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Ghi lại điều cần nhớ.',
                            style: TextStyle(
                              fontSize: constraints.maxWidth < 420 ? 22 : 30,
                              fontWeight: FontWeight.w700,
                              color: AppColors.bannerInk,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: constraints.maxWidth < 420 ? 12 : 24),
                    SizedBox(
                      key: const ValueKey('banner-notebook'),
                      width: constraints.maxWidth < 420 ? 70 : 96,
                      height: constraints.maxWidth < 420 ? 70 : 88,
                      child: const FittedBox(child: _NotebookIllustration()),
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
}

class _GradientLayer extends StatelessWidget {
  const _GradientLayer(this.gradient);

  final Gradient gradient;

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
  );
}

class _NotebookIllustration extends StatelessWidget {
  const _NotebookIllustration();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 96,
        height: 88,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(100),
              ),
            ),
            Transform.rotate(
              angle: -0.12,
              child: Container(
                width: 60,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6BA7CD), Color(0xFF3B7BA9)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(35),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 8,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.white.withAlpha(70),
                      ),
                    ),
                    const Positioned(
                      right: 10,
                      top: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFF2CCD6),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(3),
                          ),
                        ),
                        child: SizedBox(width: 8, height: 18),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _NotebookLine(width: 25),
                          SizedBox(height: 7),
                          _NotebookLine(width: 25),
                          SizedBox(height: 7),
                          _NotebookLine(width: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 5,
              bottom: 2,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bannerBorder),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotebookLine extends StatelessWidget {
  const _NotebookLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(210),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
