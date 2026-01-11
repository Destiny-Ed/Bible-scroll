import 'package:flutter/material.dart';

class ErrorOrOfflineWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool isOffline;

  const ErrorOrOfflineWidget({
    super.key,
    this.errorMessage,
    this.onRetry,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with subtle animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: Icon(
                      isOffline
                          ? Icons.cloud_off_rounded
                          : Icons.error_outline_rounded,
                      size: 90,
                      color: isOffline ? Colors.orange : Colors.redAccent,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            Text(
              isOffline
                  ? "No Internet Connection"
                  : "Oops! Something went wrong",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              isOffline
                  ? "Don't worry! You can still read previously loaded chapters.\nWe'll sync when you're back online."
                  : (errorMessage ?? "Please try again later."),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),

            if (onRetry != null) ...[
              const SizedBox(height: 40),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(200, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],

            if (isOffline) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
