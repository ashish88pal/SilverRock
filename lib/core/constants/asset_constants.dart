// All market seed instruments live here so nothing else needs to know raw
// numbers. To add or rename an asset, edit only this file.
//
// Fields: id, symbol, name, emoji, price, vol (24h volume), cap (market cap),
//         pct (24h % change), category string matching AssetCategory values.

typedef AssetSeed = ({
  String id,
  String symbol,
  String name,
  String emoji,
  double price,
  double vol,
  double cap,
  double pct,
  String category,
});

const List<AssetSeed> kAssetSeeds = [
  (
    id: 'btc',
    symbol: 'BTC',
    name: 'Bitcoin',
    emoji: '₿',
    price: 67234.50,
    vol: 28450000000,
    cap: 1320000000000,
    pct: 2.34,
    category: 'crypto',
  ),
  (
    id: 'eth',
    symbol: 'ETH',
    name: 'Ethereum',
    emoji: 'Ξ',
    price: 3512.80,
    vol: 14200000000,
    cap: 422000000000,
    pct: -1.12,
    category: 'crypto',
  ),
  (
    id: 'sol',
    symbol: 'SOL',
    name: 'Solana',
    emoji: '◎',
    price: 178.45,
    vol: 3100000000,
    cap: 79000000000,
    pct: 5.67,
    category: 'crypto',
  ),
  (
    id: 'bnb',
    symbol: 'BNB',
    name: 'BNB',
    emoji: '⬡',
    price: 594.30,
    vol: 1800000000,
    cap: 87000000000,
    pct: 0.89,
    category: 'crypto',
  ),
  (
    id: 'xrp',
    symbol: 'XRP',
    name: 'XRP',
    emoji: '✕',
    price: 0.62,
    vol: 2300000000,
    cap: 33000000000,
    pct: -3.21,
    category: 'crypto',
  ),
  (
    id: 'ada',
    symbol: 'ADA',
    name: 'Cardano',
    emoji: '₳',
    price: 0.58,
    vol: 890000000,
    cap: 20000000000,
    pct: 1.45,
    category: 'crypto',
  ),
  (
    id: 'aapl',
    symbol: 'AAPL',
    name: 'Apple Inc.',
    emoji: '🍎',
    price: 189.75,
    vol: 72000000,
    cap: 2940000000000,
    pct: 0.54,
    category: 'stocks',
  ),
  (
    id: 'tsla',
    symbol: 'TSLA',
    name: 'Tesla Inc.',
    emoji: '⚡',
    price: 248.42,
    vol: 120000000,
    cap: 790000000000,
    pct: -2.87,
    category: 'stocks',
  ),
  (
    id: 'googl',
    symbol: 'GOOGL',
    name: 'Alphabet',
    emoji: '🔍',
    price: 175.23,
    vol: 25000000,
    cap: 2200000000000,
    pct: 1.23,
    category: 'stocks',
  ),
  (
    id: 'msft',
    symbol: 'MSFT',
    name: 'Microsoft',
    emoji: '🪟',
    price: 415.80,
    vol: 18000000,
    cap: 3090000000000,
    pct: 0.76,
    category: 'stocks',
  ),
  (
    id: 'xauusd',
    symbol: 'XAU/USD',
    name: 'Gold',
    emoji: '🥇',
    price: 2034.50,
    vol: 15000000000,
    cap: 13000000000000,
    pct: 0.32,
    category: 'commodities',
  ),
  (
    id: 'eurusd',
    symbol: 'EUR/USD',
    name: 'Euro / Dollar',
    emoji: '€',
    price: 1.0845,
    vol: 20000000000,
    cap: 0,
    pct: -0.12,
    category: 'forex',
  ),
];

// Default assets shown on the watchlist screen.
const Set<String> kDefaultWatchedIds = {
  'btc',
  'eth',
  'aapl',
  'tsla',
  'sol',
  'xauusd',
};

// Market page category tabs — label and the local asset path for each icon.
typedef CategoryTab = ({String label, String imagePath});

const List<CategoryTab> kMarketCategoryTabs = [
  (label: 'Indian Market', imagePath: 'assets/ig.png'),
  (label: 'International', imagePath: 'assets/int.png'),
  (label: 'Forex Futures', imagePath: 'assets/forex.png'),
  (label: 'Crypto Futures', imagePath: 'assets/crpto.png'),
];

// Market page sub-tabs.
const List<String> kMarketSubTabs = [
  'NSE FUTURES',
  'NSE OPTION',
  'MCX FUTURES',
  'MCX OPTIONS',
];

// Portfolio seed holdings. Prices here are the initial buy prices; live
// prices are updated by the market feed as soon as the app loads.
typedef HoldingSeed = ({
  String assetId,
  String symbol,
  String name,
  String emoji,
  double quantity,
  double avgBuyPrice,
  double currentPrice,
});

const List<HoldingSeed> kPortfolioSeeds = [
  (
    assetId: 'btc',
    symbol: 'BTC',
    name: 'Bitcoin',
    emoji: '₿',
    quantity: 0.45,
    avgBuyPrice: 52000.00,
    currentPrice: 67234.50,
  ),
  (
    assetId: 'eth',
    symbol: 'ETH',
    name: 'Ethereum',
    emoji: 'Ξ',
    quantity: 3.2,
    avgBuyPrice: 2800.00,
    currentPrice: 3512.80,
  ),
  (
    assetId: 'sol',
    symbol: 'SOL',
    name: 'Solana',
    emoji: '◎',
    quantity: 25.0,
    avgBuyPrice: 120.00,
    currentPrice: 178.45,
  ),
  (
    assetId: 'aapl',
    symbol: 'AAPL',
    name: 'Apple Inc.',
    emoji: '🍎',
    quantity: 10.0,
    avgBuyPrice: 175.00,
    currentPrice: 189.75,
  ),
  (
    assetId: 'tsla',
    symbol: 'TSLA',
    name: 'Tesla Inc.',
    emoji: '⚡',
    quantity: 5.0,
    avgBuyPrice: 280.00,
    currentPrice: 248.42,
  ),
];

// Starting cash balance for the demo portfolio.
const double kInitialCashBalance = 122450;
