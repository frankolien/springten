import 'package:flutter/material.dart';

class SafeCachedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;

  const SafeCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
  });

  @override
  State<SafeCachedImage> createState() => _SafeCachedImageState();
}

class _SafeCachedImageState extends State<SafeCachedImage> {
  bool _useFallback = false;

  @override
  void initState() {
    super.initState();
    // Try to initialize cached_network_image
    _initializeCachedImage();
  }

  void _initializeCachedImage() {
    // This will be called when the widget is built
    // If there's a platform exception, we'll catch it in the build method
  }

  @override
  Widget build(BuildContext context) {
    if (_useFallback) {
      return _buildFallbackImage();
    }

    try {
      return _buildCachedImage();
    } catch (e) {
      // Debug print removed since we're not using cached_network_image
      // Set state to use fallback on next build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _useFallback = true;
          });
        }
      });
      return _buildFallbackImage();
    }
  }

  Widget _buildCachedImage() {
    // Use Image.network directly since we removed cached_network_image
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    Widget imageWidget = Image.network(
      widget.imageUrl,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildDefaultPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultErrorWidget();
      },
    );

    if (widget.borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: widget.borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor ?? Colors.grey[800],
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor ?? Colors.grey[800],
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }
}
