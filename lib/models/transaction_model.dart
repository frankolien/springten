enum TransactionType {
  buy,
  sell,
  send,
  receive,
  swap,
  recurring,
}

enum TransactionStatus {
  success,
  pending,
  failed,
}

class Transaction {
  final String id;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime date;
  final String amount;
  final String currency;
  final String? description;
  final String? method;
  final String? provider;
  final String? youPaid;
  final String? youReceived;
  final String? network;
  final String? networkFee;
  final String? transactionId;

  Transaction({
    required this.id,
    required this.type,
    required this.status,
    required this.date,
    required this.amount,
    required this.currency,
    this.description,
    this.method,
    this.provider,
    this.youPaid,
    this.youReceived,
    this.network,
    this.networkFee,
    this.transactionId,
  });

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String get formattedTime {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get fullFormattedDate {
    return '${date.day}/${date.month}/${date.year} / ${formattedTime}';
  }
}

// Sample transaction data
class TransactionData {
  static List<Transaction> getTransactions() {
    return [
      Transaction(
        id: '1',
        type: TransactionType.buy,
        status: TransactionStatus.success,
        date: DateTime(2024, 11, 11, 23, 5),
        amount: '7.43',
        currency: 'LINK',
        method: 'Google Pay',
        provider: 'Blockchain.com',
        youPaid: '\$110.98',
        youReceived: '+7.4308 LINK',
        network: 'Ethereum',
        networkFee: '0.0029 ETH',
        transactionId: '4uZ3TVEZcjEeZ7..',
      ),
      Transaction(
        id: '2',
        type: TransactionType.sell,
        status: TransactionStatus.success,
        date: DateTime(2024, 11, 10, 15, 30),
        amount: '36.02',
        currency: 'USDC',
        method: 'Google Pay',
        provider: 'Blockchain.com',
        youPaid: '\$36.02',
        youReceived: '+36.02 USDC',
        network: 'Ethereum',
        networkFee: '0.0015 ETH',
        transactionId: '7xK9MNPQfGhR2..',
      ),
      Transaction(
        id: '3',
        type: TransactionType.receive,
        status: TransactionStatus.success,
        date: DateTime(2024, 11, 9, 10, 15),
        amount: '0.0',
        currency: 'ETH',
        description: 'Get crypto from others',
        network: 'Ethereum',
        networkFee: '0.0 ETH',
        transactionId: '2aB5CDEfGhI3..',
      ),
      Transaction(
        id: '4',
        type: TransactionType.swap,
        status: TransactionStatus.success,
        date: DateTime(2024, 11, 8, 14, 20),
        amount: '0.521',
        currency: 'ETH',
        description: '0.521 ETH for 0.01813402 BTC',
        network: 'Ethereum',
        networkFee: '0.0032 ETH',
        transactionId: '9mN8OPQrStU4..',
      ),
      Transaction(
        id: '5',
        type: TransactionType.recurring,
        status: TransactionStatus.success,
        date: DateTime(2024, 11, 7, 9, 0),
        amount: '11.00',
        currency: 'ETH',
        description: '11.00 ETH - 30d',
        network: 'Ethereum',
        networkFee: '0.001 ETH',
        transactionId: '5vW6XYZaBcD7..',
      ),
      Transaction(
        id: '6',
        type: TransactionType.send,
        status: TransactionStatus.success,
        date: DateTime(2024, 10, 15, 16, 45),
        amount: '2.5',
        currency: 'ETH',
        description: 'Sent to 0x742d...',
        network: 'Ethereum',
        networkFee: '0.0021 ETH',
        transactionId: '3cF8GHIjKlM9..',
      ),
      Transaction(
        id: '7',
        type: TransactionType.buy,
        status: TransactionStatus.success,
        date: DateTime(2024, 10, 10, 11, 30),
        amount: '150.0',
        currency: 'USDC',
        method: 'Bank Transfer',
        provider: 'Coinbase',
        youPaid: '\$150.00',
        youReceived: '+150.0 USDC',
        network: 'Ethereum',
        networkFee: '0.001 ETH',
        transactionId: '8dE9FGHjKlM2..',
      ),
    ];
  }
}
