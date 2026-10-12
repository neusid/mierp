import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom top-floating snackbar matching API BAYAR Mobile Design.
/// Features:
/// - Dark charcoal surface (#242C32) with 10.r rounded corners
/// - Circular icon container (#303746) with vibrant status glyphs
/// - Ambient radial glow radiating from behind the icon
/// - Two-tier typography: Bold white title + #C8C5C5 body description
/// - Glowing bottom countdown/progress indicator bar
/// - Smooth entrance sliding from right edge + swipe-to-right to dismiss
/// - Supports awaiting / `onDismissed` callback so redirect happens AFTER toast is gone
class CustomTopSnackbar {
  static OverlayEntry? _currentEntry;
  static Completer<void>? _currentCompleter;

  /// Show custom top snackbar.
  /// Returns a [Future] that completes once the toast has fully disappeared.
  /// Fully backwards-compatible with existing calls:
  /// `CustomTopSnackbar.show(context, message, isError: true/false)`
  static Future<void> show(
    BuildContext context,
    String message, {
    String? title,
    bool isError = true,
    bool isWarning = false,
    Duration duration = const Duration(milliseconds: 4500),
    VoidCallback? onDismissed,
  }) {
    // Dismiss any existing snackbar smoothly
    _dismissCurrent();

    final completer = Completer<void>();
    _currentCompleter = completer;

    final overlay = Overlay.of(context, rootOverlay: true);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return _TopSnackbarWidget(
          message: message,
          title: title,
          isError: isError,
          isWarning: isWarning,
          duration: duration,
          onDismiss: () {
            if (entry.mounted) {
              entry.remove();
              if (_currentEntry == entry) {
                _currentEntry = null;
              }
            }
            try {
              onDismissed?.call();
            } catch (e) {
              debugPrint("Error in CustomTopSnackbar onDismissed: $e");
            }
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);

    return completer.future;
  }

  /// Convenience helper for success notifications
  static Future<void> success(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(milliseconds: 4500),
    VoidCallback? onDismissed,
  }) {
    return show(
      context,
      message,
      title: title,
      isError: false,
      isWarning: false,
      duration: duration,
      onDismissed: onDismissed,
    );
  }

  /// Convenience helper for error notifications
  static Future<void> error(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(milliseconds: 4500),
    VoidCallback? onDismissed,
  }) {
    return show(
      context,
      message,
      title: title,
      isError: true,
      isWarning: false,
      duration: duration,
      onDismissed: onDismissed,
    );
  }

  /// Convenience helper for warning notifications
  static Future<void> warning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(milliseconds: 4500),
    VoidCallback? onDismissed,
  }) {
    return show(
      context,
      message,
      title: title,
      isError: false,
      isWarning: true,
      duration: duration,
      onDismissed: onDismissed,
    );
  }

  static void _dismissCurrent() {
    if (_currentEntry != null && _currentEntry!.mounted) {
      _currentEntry!.remove();
      _currentEntry = null;
    }
    if (_currentCompleter != null && !_currentCompleter!.isCompleted) {
      _currentCompleter!.complete();
      _currentCompleter = null;
    }
  }
}

class _TopSnackbarWidget extends StatefulWidget {
  final String message;
  final String? title;
  final bool isError;
  final bool isWarning;
  final Duration duration;
  final VoidCallback onDismiss;

  const _TopSnackbarWidget({
    required this.message,
    required this.title,
    required this.isError,
    required this.isWarning,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_TopSnackbarWidget> createState() => _TopSnackbarWidgetState();
}

class _TopSnackbarWidgetState extends State<_TopSnackbarWidget>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  late final AnimationController _progressController;

  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    // Slide in from the right edge with smooth cubic deceleration
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.2, 0.0), // Muncul dari samping kanan
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    // Progress bar countdown animation
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _handleDismiss();
      }
    });

    // Start animations
    _slideController.forward();
    _progressController.forward();
  }

  Future<void> _handleDismiss() async {
    if (_isDismissing || !mounted) return;
    _isDismissing = true;
    _progressController.stop();

    await _slideController.reverse();
    if (mounted) {
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Design tokens based on API Bayar mobile specs
    final Color accentColor = widget.isWarning
        ? const Color(0xFFFFD21E)
        : (widget.isError ? const Color(0xFFF04248) : const Color(0xFF00DF80));

    final IconData iconData = widget.isWarning
        ? Icons.error_outline_rounded
        : (widget.isError
            ? Icons.cancel_outlined
            : Icons.check_circle_outline_rounded);

    // Default titles disesuaikan
    final String displayTitle = widget.title ??
        (widget.isWarning
            ? 'Peringatan'
            : (widget.isError ? 'Terjadi Kesalahan' : 'Berhasil'));

    // Format pesan agar tidak menampilkan raw exception teknis
    String formattedMessage = widget.message.trim();
    if (formattedMessage.startsWith('Exception: ')) {
      formattedMessage = formattedMessage.substring(11).trim();
    }
    if (formattedMessage.isEmpty) {
      formattedMessage = widget.isError
          ? 'Terjadi kendala pada sistem. Silakan coba lagi.'
          : 'Aksi berhasil dilakukan.';
    }

    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 12.h,
      left: 16.w,
      right: 16.w,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          // Geser ke kanan untuk menutup
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta != null && details.primaryDelta! > 3) {
              _handleDismiss();
            }
          },
          // Geser ke atas juga dapat menutup
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta != null && details.primaryDelta! < -3) {
              _handleDismiss();
            }
          },
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF242C32),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1.w,
                  ),
                  boxShadow: [
                    // Triple drop shadow from Figma filter0_ddd
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.20),
                      blurRadius: 10,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 24,
                      offset: const Offset(0, 16),
                    ),
                    // Ambient colored glow
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.16),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Ambient Radial Glow behind the icon area
                    Positioned(
                      top: -45.w,
                      left: -25.w,
                      child: IgnorePointer(
                        child: Container(
                          width: 150.w,
                          height: 150.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.18),
                                accentColor.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Main Content Body
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 14.h, 12.w, 15.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left Icon Circle (#303746 container)
                          Container(
                            width: 34.w,
                            height: 34.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF303746),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              iconData,
                              color: accentColor,
                              size: 20.w,
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Text Content (Title & Subtitle)
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayTitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.25,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  formattedMessage,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC8C5C5),
                                    height: 1.35,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),

                          // Subtle Close Button
                          GestureDetector(
                            onTap: _handleDismiss,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 14.w,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Glowing Countdown / Progress Bar
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, _) {
                          final double progress =
                              (1.0 - _progressController.value).clamp(0.0, 1.0);
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 3.2.h,
                                  width: constraints.maxWidth * progress,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            accentColor.withValues(alpha: 0.7),
                                        blurRadius: 4,
                                        offset: const Offset(0, -1),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
