import 'package:flutter/material.dart';

class AnimatedPriceChange extends StatefulWidget {
  final double value;
  final String prefix;
  final String suffix;
  final TextStyle? textStyle;
  final Duration animationDuration;

  const AnimatedPriceChange({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedPriceChange> createState() => _AnimatedPriceChangeState();
}

class _AnimatedPriceChangeState extends State<AnimatedPriceChange>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;
  
  double _previousValue = 0.0;
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _previousValue = widget.value;
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: _previousValue,
      end: _currentValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: _getColorForValue(_previousValue),
      end: _getColorForValue(_currentValue),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedPriceChange oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _currentValue;
      _currentValue = widget.value;
      
      _animation = Tween<double>(
        begin: _previousValue,
        end: _currentValue,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      
      _colorAnimation = ColorTween(
        begin: _getColorForValue(_previousValue),
        end: _getColorForValue(_currentValue),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      
      _controller.forward(from: 0.0);
    }
  }

  Color _getColorForValue(double value) {
    if (value > 0) {
      return Colors.green;
    } else if (value < 0) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Text(
              '${widget.prefix}${_animation.value.toStringAsFixed(2)}${widget.suffix}',
              style: (widget.textStyle ?? const TextStyle()).copyWith(
                color: _colorAnimation.value,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        );
      },
    );
  }
}

class AnimatedPriceIndicator extends StatefulWidget {
  final double value;
  final String prefix;
  final String suffix;
  final TextStyle? textStyle;
  final Duration animationDuration;

  const AnimatedPriceIndicator({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedPriceIndicator> createState() => _AnimatedPriceIndicatorState();
}

class _AnimatedPriceIndicatorState extends State<AnimatedPriceIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;
  
  double _previousValue = 0.0;
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _previousValue = widget.value;
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: _previousValue,
      end: _currentValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: _getColorForValue(_previousValue),
      end: _getColorForValue(_currentValue),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedPriceIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _currentValue;
      _currentValue = widget.value;
      
      _animation = Tween<double>(
        begin: _previousValue,
        end: _currentValue,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      
      _colorAnimation = ColorTween(
        begin: _getColorForValue(_previousValue),
        end: _getColorForValue(_currentValue),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      
      _controller.forward(from: 0.0);
    }
  }

  Color _getColorForValue(double value) {
    if (value > 0) {
      return Colors.green;
    } else if (value < 0) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _animation.value > 0 ? Icons.trending_up : 
                  _animation.value < 0 ? Icons.trending_down : Icons.trending_flat,
                  color: _colorAnimation.value,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.prefix}${_animation.value.toStringAsFixed(1)}%${widget.suffix}',
                  style: (widget.textStyle ?? const TextStyle()).copyWith(
                    color: _colorAnimation.value,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
