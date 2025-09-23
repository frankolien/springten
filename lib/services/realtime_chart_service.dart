import 'dart:async';
import 'dart:math';

class RealtimeChartService {
  static final RealtimeChartService _instance = RealtimeChartService._internal();
  factory RealtimeChartService() => _instance;
  RealtimeChartService._internal();

  final StreamController<List<ChartDataPoint>> _chartDataController = 
      StreamController<List<ChartDataPoint>>.broadcast();
  
  Timer? _updateTimer;
  final List<ChartDataPoint> _currentData = [];
  double _basePrice = 0.0;

  Stream<List<ChartDataPoint>> get chartDataStream => _chartDataController.stream;

  void startRealtimeUpdates(String symbol, double basePrice) {
    _basePrice = basePrice;
    
    // Generate initial data points (last 24 hours)
    _generateInitialData();
    
    // Start real-time updates every 2 seconds
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updateChartData();
    });
  }

  void stopRealtimeUpdates() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  void _generateInitialData() {
    _currentData.clear();
    final now = DateTime.now();
    final random = Random();
    
    // Generate 24 hours of data (1440 minutes)
    for (int i = 1439; i >= 0; i--) {
      final timestamp = now.subtract(Duration(minutes: i));
      final variation = (random.nextDouble() - 0.5) * 0.1; // ±5% variation
      final price = _basePrice * (1 + variation);
      
      _currentData.add(ChartDataPoint(
        timestamp: timestamp,
        price: price,
        volume: random.nextDouble() * 1000000,
      ));
    }
    
    _chartDataController.add(List.from(_currentData));
  }

  void _updateChartData() {
    if (_currentData.isEmpty) return;
    
    final random = Random();
    final lastPrice = _currentData.last.price;
    
    // Generate new price with realistic movement
    final change = (random.nextDouble() - 0.5) * 0.02; // ±1% change
    final newPrice = lastPrice * (1 + change);
    
    // Add new data point
    final newPoint = ChartDataPoint(
      timestamp: DateTime.now(),
      price: newPrice,
      volume: random.nextDouble() * 1000000,
    );
    
    _currentData.add(newPoint);
    
    // Keep only last 24 hours of data
    if (_currentData.length > 1440) {
      _currentData.removeAt(0);
    }
    
    _chartDataController.add(List.from(_currentData));
  }

  List<ChartDataPoint> getCurrentData() => List.from(_currentData);
  
  double getCurrentPrice() => _currentData.isNotEmpty ? _currentData.last.price : _basePrice;
  
  double getPriceChange() {
    if (_currentData.length < 2) return 0.0;
    final current = _currentData.last.price;
    final previous = _currentData[_currentData.length - 2].price;
    return ((current - previous) / previous) * 100;
  }

  void dispose() {
    _updateTimer?.cancel();
    _chartDataController.close();
  }
}

class ChartDataPoint {
  final DateTime timestamp;
  final double price;
  final double volume;

  ChartDataPoint({
    required this.timestamp,
    required this.price,
    required this.volume,
  });
}
