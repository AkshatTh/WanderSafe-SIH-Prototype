import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CryptoGatewayScreen extends StatefulWidget {
  const CryptoGatewayScreen({super.key});

  @override
  State<CryptoGatewayScreen> createState() => _CryptoGatewayScreenState();
}

class _CryptoGatewayScreenState extends State<CryptoGatewayScreen> {
  // --- Hardcoded State for the Prototype ---
  double _inrBalance = 10000.00;
  double _cryptoUsdValue = 500.00;
  
  // Mock conversion rates
  final Map<String, double> _conversionRates = {
    'USDT': 83.50,
    'BTC': 5500000.00,
    'ETH': 280000.00,
  };

  // State for the currency toggle buttons
  List<bool> _isSelected = [true, false, false];
  String _selectedCrypto = 'USDT';

  final TextEditingController _amountController = TextEditingController();
  double _calculatedInr = 0.0;

  // Number formatters for clean currency display
  final inrFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  final usdFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  @override
  void initState() {
    super.initState();
    // Add a listener to the text field to calculate conversion in real-time
    _amountController.addListener(_calculateConversion);
  }

  void _calculateConversion() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final rate = _conversionRates[_selectedCrypto]!;
    setState(() {
      _calculatedInr = amount * rate;
    });
  }

  void _performConversion() {
    final amountToConvert = double.tryParse(_amountController.text) ?? 0.0;
    if (amountToConvert <= 0) return;

    // In a real app, you'd convert crypto value to USD equivalent first.
    // For this prototype, we'll just subtract the USDT value for simplicity.
    if (_cryptoUsdValue < amountToConvert) {
      // Show error snackbar
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient Crypto Balance!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _cryptoUsdValue -= amountToConvert;
      _inrBalance += _calculatedInr;
    });

    _amountController.clear();

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conversion Successful!'), backgroundColor: Colors.green),
    );
  }


  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Crypto Gateway', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // --- Balances Section ---
              Row(
                children: [
                  _buildBalanceCard('Available INR Balance', inrFormatter.format(_inrBalance), Icons.currency_rupee, Colors.green),
                  const SizedBox(width: 16),
                  _buildBalanceCard('Crypto Wallet (USD)', usdFormatter.format(_cryptoUsdValue), Icons.account_balance_wallet, Colors.blue),
                ],
              ),
              const SizedBox(height: 30),

              // --- Conversion Section ---
              _buildConversionCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String title, String amount, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)),
              ],
            ),
            const SizedBox(height: 8),
            Text(amount, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: HSLColor.fromColor(color).withLightness(0.3).toColor())),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Create Transaction', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          // Currency Selector
          Center(
            child: ToggleButtons(
              isSelected: _isSelected,
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    _isSelected[i] = i == index;
                  }
                  _selectedCrypto = _conversionRates.keys.elementAt(index);
                  _calculateConversion(); // Recalculate when currency changes
                });
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: const Color(0xFF364F6B),
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('USDT')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('BTC')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('ETH')),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Crypto Input
          TextField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'You send',
              suffixText: _selectedCrypto,
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          
          // INR Output
          TextField(
            readOnly: true,
            controller: TextEditingController(text: inrFormatter.format(_calculatedInr)),
            decoration: const InputDecoration(
              labelText: 'You receive (approx.)',
              suffixText: 'INR',
              border: OutlineInputBorder(),
              fillColor: Color(0xFFF0F4F8),
              filled: true,
            ),
          ),
          const SizedBox(height: 24),

          // Convert Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _performConversion,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: const Color(0xFF364F6B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Convert & Update Balance', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}

