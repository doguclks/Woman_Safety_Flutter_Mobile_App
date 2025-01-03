import 'package:flutter/material.dart';
import '../colors/colors.dart';

class RecordButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isRecording;

  const RecordButtonWidget({
    super.key,
    required this.onPressed,
    required this.isRecording,
  });

  @override
  State<RecordButtonWidget> createState() => _RecordButtonWidgetState();
}

class _RecordButtonWidgetState extends State<RecordButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dalgalar
            if (widget.isRecording) ...[
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    width: 150 * _animationController.value,
                    height: 150 * _animationController.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    width: 120 * _animationController.value,
                    height: 120 * _animationController.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
            ],
            // Ana kayıt butonu
            GestureDetector(
              onTap: widget.onPressed,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color:
                      widget.isRecording ? Colors.red : AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
