import 'package:flutter/material.dart';

enum CartStep {
  items,
  address,
  payment,
}

class CartProgressIndicator extends StatelessWidget {
  final CartStep currentStep;

  const CartProgressIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        children: [
          _buildStepIndicator(
            context: context,
            step: CartStep.items,
            currentStep: currentStep,
            label: 'Корзина',
            isFirst: true,
          ),
          
          _buildConnectingLine(
            context: context,
            isActive: currentStep == CartStep.address || currentStep == CartStep.payment,
          ),
          
          _buildStepIndicator(
            context: context,
            step: CartStep.address,
            currentStep: currentStep,
            label: 'Адрес',
          ),
          _buildConnectingLine(
            context: context,
            isActive: currentStep == CartStep.payment,
          ),
          _buildStepIndicator(
            context: context,
            step: CartStep.payment,
            currentStep: currentStep,
            label: 'Оплата',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required BuildContext context,
    required CartStep step,
    required CartStep currentStep,
    required String label,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isCompleted = step.index < currentStep.index;
    final isActive = step == currentStep || isCompleted;
    
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive ? Colors.deepOrange : Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : Text(
                      '${step.index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.deepOrange : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectingLine({
    required BuildContext context,
    required bool isActive,
  }) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.deepOrange : Colors.grey[700],
      ),
    );
  }
}