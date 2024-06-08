import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class AnimatedCardWidget extends StatefulWidget {
  final Image image;
  final VoidCallback onTap;

  const AnimatedCardWidget({
    required this.image,
    required this.onTap,
    super.key,
  });

  @override
  _AnimatedCardWidgetState createState() => _AnimatedCardWidgetState();
}

class _AnimatedCardWidgetState extends State<AnimatedCardWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    super.initState();
    const multiplier = 5;

    controller = AnimationController(
      duration: const Duration(milliseconds: 500 * multiplier),
      vsync: this,
    );

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 1, end: 0.55),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 200 * multiplier),
          tag: 'scale',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0.9, end: 1),
          from: const Duration(milliseconds: 200 * multiplier),
          to: const Duration(milliseconds: 500 * multiplier),
          curve: Curves.elasticOut,
          tag: 'bouncing',
        )
        .animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: ScaleTransition(
          scale: sequenceAnimation['scale'] as Animation<double>,
          child: ScaleTransition(
            scale: sequenceAnimation['bouncing'] as Animation<double>,
            child: buildCard(onClicked: handleAnimation),
          ),
        ),
      );

  void handleAnimation() {
    if (controller.isCompleted) {
      controller.reset();
    } else {
      controller.forward();
    }
  }

  Widget buildCard({required VoidCallback onClicked}) => GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: widget.image,
        ),
        onTap: () {
          //handleAnimation();
          widget.onTap();
        },
        onHorizontalDragEnd: (details) {
          // Додайте тут логіку свайпа
          if (details.primaryVelocity! > 0) {
            print('Swiped right');
          } else if (details.primaryVelocity! < 0) {
            print('Swiped left');
          }
        },
      );
}
