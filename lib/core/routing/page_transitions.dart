import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Fintech & Executive-Grade Page Transitions
/// Provides silky smooth, polished transitions conforming to Product Design heuristics.
class SmoothPageTransitions {
  /// Silky horizontal slide transition with cubic easing and gentle parallax exit.
  /// Ideal for detail pages, forms, and secondary screens.
  static CustomTransitionPage<T> slideHorizontal<T>({
    required LocalKey key,
    required Widget child,
    String? name,
    Duration duration = const Duration(milliseconds: 320),
    Duration reverseDuration = const Duration(milliseconds: 280),
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Incoming page slide from right
        final slideIn = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ));

        // Incoming page subtle fade
        final fadeIn = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
        ));

        // Outgoing page subtle parallax push left
        final slideOut = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.20, 0.0),
        ).animate(CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ));

        return SlideTransition(
          position: slideOut,
          child: SlideTransition(
            position: slideIn,
            child: FadeTransition(
              opacity: fadeIn,
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Silky vertical slide-up modal transition with soft scale and fade.
  /// Ideal for payment success receipt, celebratory views, and modal screens.
  static CustomTransitionPage<T> modalSlideUp<T>({
    required LocalKey key,
    required Widget child,
    String? name,
    Duration duration = const Duration(milliseconds: 380),
    Duration reverseDuration = const Duration(milliseconds: 280),
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
          reverseCurve: Curves.easeInQuart,
        );

        final slideIn = Tween<Offset>(
          begin: const Offset(0.0, 0.16),
          end: Offset.zero,
        ).animate(curved);

        final scaleIn = Tween<double>(
          begin: 0.96,
          end: 1.0,
        ).animate(curved);

        final fadeIn = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
        ));

        return SlideTransition(
          position: slideIn,
          child: ScaleTransition(
            scale: scaleIn,
            child: FadeTransition(
              opacity: fadeIn,
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Gentle fade with subtle micro-scale for top-level root screens.
  /// Ideal for splash, login, register, and main dashboard shells.
  static CustomTransitionPage<T> fadeScale<T>({
    required LocalKey key,
    required Widget child,
    String? name,
    Duration duration = const Duration(milliseconds: 260),
    Duration reverseDuration = const Duration(milliseconds: 220),
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final scaleIn = Tween<double>(
          begin: 0.98,
          end: 1.0,
        ).animate(curved);

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: scaleIn,
            child: child,
          ),
        );
      },
    );
  }
}
