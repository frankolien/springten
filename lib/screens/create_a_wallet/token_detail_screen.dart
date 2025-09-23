import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/services/realtime_chart_service.dart';

class TokenDetailScreen extends ConsumerStatefulWidget {
  final String tokenSymbol;
  final String tokenName;
  final double price;
  final double change24h;
  final String imageUrl;

  const TokenDetailScreen({
    super.key,
    required this.tokenSymbol,
    required this.tokenName,
    required this.price,
    required this.change24h,
    required this.imageUrl,
  });

  @override
  ConsumerState<TokenDetailScreen> createState() => _TokenDetailScreenState();
}

class _TokenDetailScreenState extends ConsumerState<TokenDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final RealtimeChartService _chartService = RealtimeChartService();
  List<ChartDataPoint> _chartData = [];
  double _currentPrice = 0.0;
  double _priceChange = 0.0;
  String _selectedTimeRange = '24H';

  @override
  void initState() {
    super.initState();
    _currentPrice = widget.price;
    _priceChange = widget.change24h;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _animationController.forward();
    
    // Start real-time chart updates
    _chartService.startRealtimeUpdates(widget.tokenSymbol, widget.price);
    _chartService.chartDataStream.listen((data) {
      if (mounted) {
        setState(() {
          _chartData = data;
          _currentPrice = _chartService.getCurrentPrice();
          _priceChange = _chartService.getPriceChange();
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chartService.stopRealtimeUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2B35),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          widget.tokenSymbol,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[800],
                          child: Text(
                            widget.tokenSymbol.substring(0, 1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.tokenName,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Text(
                                    '\$${_currentPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _priceChange >= 0 ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_priceChange >= 0 ? '+' : ''}${_priceChange.toStringAsFixed(2)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Chart Section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Real-time Price Chart
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2B35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Live Price Chart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: ['1H', '24H', '7D', '30D'].map((range) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedTimeRange = range;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _selectedTimeRange == range 
                                              ? Colors.blue 
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: _selectedTimeRange == range 
                                                ? Colors.blue 
                                                : Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          range,
                                          style: TextStyle(
                                            color: _selectedTimeRange == range 
                                                ? Colors.white 
                                                : Colors.grey,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: _buildRealtimeChart(),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Market Stats
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2B35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Market Statistics',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildStatRow('Market Cap', '\$${_formatMarketCap()}'),
                            _buildStatRow('Volume 24h', '\$${_formatVolume()}'),
                            _buildStatRow('Circulating Supply', '${_formatSupply()} ${widget.tokenSymbol}'),
                            _buildStatRow('All Time High', '\$${_formatATH()}'),
                            _buildStatRow('All Time Low', '\$${_formatATL()}'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Buy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Sell',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeChart() {
    if (_chartData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: RealtimeChartPainter(
          data: _chartData,
          isPositive: _priceChange >= 0,
        ),
      ),
    );
  }

  String _formatMarketCap() {
    // Realistic market cap based on token symbol
    switch (widget.tokenSymbol.toUpperCase()) {
      case 'BTC':
        return '1.2T';
      case 'ETH':
        return '280B';
      case 'ADA':
        return '15B';
      case 'DOT':
        return '8B';
      case 'LINK':
        return '6B';
      case 'UNI':
        return '4B';
      default:
        return '2.5B';
    }
  }

  String _formatVolume() {
    // Realistic 24h volume
    switch (widget.tokenSymbol.toUpperCase()) {
      case 'BTC':
        return '25B';
      case 'ETH':
        return '12B';
      case 'ADA':
        return '800M';
      case 'DOT':
        return '400M';
      case 'LINK':
        return '300M';
      case 'UNI':
        return '200M';
      default:
        return '150M';
    }
  }

  String _formatSupply() {
    // Realistic circulating supply
    switch (widget.tokenSymbol.toUpperCase()) {
      case 'BTC':
        return '19.5M';
      case 'ETH':
        return '120M';
      case 'ADA':
        return '35B';
      case 'DOT':
        return '1.1B';
      case 'LINK':
        return '500M';
      case 'UNI':
        return '600M';
      default:
        return '1B';
    }
  }

  String _formatATH() {
    // All-time high (realistic)
    return (_currentPrice * 1.8).toStringAsFixed(2);
  }

  String _formatATL() {
    // All-time low (realistic)
    return (_currentPrice * 0.2).toStringAsFixed(2);
  }
}

class RealtimeChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final bool isPositive;

  RealtimeChartPainter({
    required this.data,
    required this.isPositive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Calculate price range
    final prices = data.map((point) => point.price).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final priceRange = maxPrice - minPrice;

    if (priceRange == 0) return;

    // Convert data points to screen coordinates
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i].price - minPrice) / priceRange) * size.height;
      points.add(Offset(x, y));
    }

    // Draw grid lines
    _drawGrid(canvas, size);

    // Draw area under the curve
    _drawArea(canvas, size, points, minPrice, priceRange);

    // Draw the main line
    _drawLine(canvas, points);

    // Draw data points
    _drawDataPoints(canvas, points);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5;

    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (i / 4) * size.height;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Vertical grid lines
    for (int i = 0; i <= 4; i++) {
      final x = (i / 4) * size.width;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
  }

  void _drawArea(Canvas canvas, Size size, List<Offset> points, double minPrice, double priceRange) {
    if (points.isEmpty) return;

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isPositive 
            ? [Colors.green.withOpacity(0.3), Colors.green.withOpacity(0.05)]
            : [Colors.red.withOpacity(0.3), Colors.red.withOpacity(0.05)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final areaPath = Path();
    areaPath.moveTo(0, size.height);
    areaPath.lineTo(points.first.dx, points.first.dy);
    
    for (int i = 1; i < points.length; i++) {
      areaPath.lineTo(points[i].dx, points[i].dy);
    }
    
    areaPath.lineTo(points.last.dx, size.height);
    areaPath.close();

    canvas.drawPath(areaPath, areaPaint);
  }

  void _drawLine(Canvas canvas, List<Offset> points) {
    if (points.isEmpty) return;

    final linePaint = Paint()
      ..color = isPositive ? Colors.green : Colors.red
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, linePaint);
  }

  void _drawDataPoints(Canvas canvas, List<Offset> points) {
    final pointPaint = Paint()
      ..color = isPositive ? Colors.green : Colors.red
      ..style = PaintingStyle.fill;

    // Draw only the last few points to avoid clutter
    final startIndex = points.length > 10 ? points.length - 10 : 0;
    for (int i = startIndex; i < points.length; i++) {
      canvas.drawCircle(points[i], 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant RealtimeChartPainter oldDelegate) {
    return data != oldDelegate.data || isPositive != oldDelegate.isPositive;
  }
}
