import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Color? backgroundColor;

  const CachedImageWidget({
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
  Widget build(BuildContext context) {
    // Use a try-catch approach with fallback to regular Image.network
    return _buildCachedImageWithFallback();
  }

  Widget _buildCachedImageWithFallback() {
    // Use Image.network directly since we removed cached_network_image
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    Widget imageWidget = Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildDefaultPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultErrorWidget();
      },
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.grey[800],
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
      width: width,
      height: height,
      color: backgroundColor ?? Colors.grey[800],
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

// Specialized widgets for common use cases
class NFTImageWidget extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isVerified;

  const NFTImageWidget({
    super.key,
    required this.imageUrl,
    required this.size,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedImageWidget(
          imageUrl: imageUrl,
          width: size,
          height: size,
          borderRadius: BorderRadius.circular(8),
        ),
        if (isVerified)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
      ],
    );
  }
}

class FeaturedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const FeaturedImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CachedImageWidget(
      imageUrl: imageUrl,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
