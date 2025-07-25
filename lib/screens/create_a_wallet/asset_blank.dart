import 'package:flutter/material.dart';
class AssetBlank extends StatefulWidget {
  const AssetBlank({super.key});

  @override
  State<AssetBlank> createState() => _AssetBlankState();
}

class _AssetBlankState extends State<AssetBlank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'lib/images/logo.png',
                      height: 22,
                    ),
                    Spacer(),
        
                    Row(
                      children: [
                        Image.asset(
                          'lib/images/eth.png',
                          width: 30,
                          height: 30,
                        ),
                        Text(
                          'Ethereum Main Network',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        IconButton(onPressed: (){}, icon: Icon(Icons.arrow_drop_down))
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.qr_code_scanner,
                      color: Colors.grey,
                      )
        
                  ],
                        
                ),
              ),
              Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              //color: const Color(0xFF1E1E1E),
              color: const Color(0xFF2A2B35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Asset Value',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '\$2,654.3',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '+98.02% (24h)',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                //const SizedBox(height: 16),
                Divider(),
                 const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children:  [
                          Text(
                            "Address",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                        
                            
                            ),
                    SizedBox(width: 10,),
                          Image.asset('lib/images/eth.png'),
                          SizedBox(width: 4),
                          Text(
                            '0x71C7656EC7ab88..',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.copy, color: Colors.white54, size: 16),
                  ],
                ),
                
                Divider(),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(Icons.emoji_emotions, color: Colors.yellow),
                    SizedBox(width: 8),
                    Text(
                      'Jordan Avery Taylor',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: const Text(
            "Token Balance",
            style: TextStyle(
              fontSize: 17,fontWeight: FontWeight.w500,
            ),
          )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '3 stored',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('lib/images/Group.png'),
                const SizedBox(width: 12), // Add spacing here
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ETH'),
                    const Text('Ethereum',style: TextStyle(color: Colors.grey),)
                  ],
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
                  children: [
                    const Text('1.042'),
                    const Text(
                      '\$3259.38',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
            ],
          ),
        ) ,
           Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('lib/images/bnb.png'),
                const SizedBox(width: 12), // Add spacing here
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('BNB'),
                    const Text('Binance Coin',style: TextStyle(color: Colors.grey),)
                  ],
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
                  children: [
                    const Text('0.314922'),
                    const Text(
                      '\$197.29',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
            ],
          ),
        ) ,
           Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('lib/images/usdc.png'),
                const SizedBox(width: 12), // Add spacing here
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('USDC'),
                    const Text('USD Coin',style: TextStyle(color: Colors.grey),)
                  ],
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
                  children: [
                    const Text('1.042'),
                    const Text(
                      '\$3259.38',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
            ],
          ),
        ) ,
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '0 Stored',
            style: TextStyle(
              color: Colors.grey
            ),
          ),
        ),Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 6),
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child:  Center(
                    child: Text(
                      '#',
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.grey[200]
                      ),
                      
                    ),
                  ),
                ),
              const SizedBox(width: 12), // Add spacing here
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('-'),
                  const Text('-')
                ],
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
                children: [
                  const Text('-'),
                  const Text(
                    '-',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    ],
  ),
)
          ],
          ),
        ),
      ),
    );
  }
}