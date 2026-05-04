# 🔍 Wallet Activity Visualizer

A premium Flutter app for exploring Ethereum wallet activity — built with Alchemy API, Riverpod state management, and smooth animations.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Alchemy](https://img.shields.io/badge/Powered%20by-Alchemy-363FF9)
![Riverpod](https://img.shields.io/badge/State-Riverpod-00C896)

---

## ✨ Features

- **Wallet Input** — paste any Ethereum address with live validation
- **Balance Display** — ETH balance with count-up animation
- **Transaction History** — filterable list (All / Received / Sent / Tokens)
- **Token Holdings** — ERC-20 token balances
- **Charts** — TX frequency line chart + token distribution pie chart
- **Skeleton Loaders** — shimmer loading states
- **Staggered Animations** — fade + slide entry for all list rows
- **Dark Terminal UI** — premium dark theme with `JetBrains Mono` + `Sora`

---

## 🚀 Getting Started

### Prerequisites

- Flutter 3.x+
- Dart 3.0+
- An [Alchemy](https://alchemy.com) account (free tier works)

### Setup

1. **Clone the repo**
   ```bash
   git clone https://github.com/abundance999/wallet-activity-visualizer.git
   cd wallet-activity-visualizer
   ```

2. **Create your `.env` file** (copy from example)
   ```bash
   cp .env.example .env
   ```

3. **Add your Alchemy API key** to `.env`
   ```
   ALCHEMY_API_KEY=your_key_here
   ALCHEMY_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/your_key_here
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Tech Stack

| Layer | Package |
|-------|---------|
| State management | `flutter_riverpod` |
| HTTP | `http` |
| Charts | `fl_chart` |
| Animations | `flutter_animate` |
| Skeletons | `shimmer` |
| Fonts | `google_fonts` |
| Env | `flutter_dotenv` |

---

## 🗂 Project Structure

```
lib/
├── main.dart
├── theme.dart
├── models/
│   ├── transfer.dart
│   ├── token_balance.dart
│   └── wallet_info.dart
├── services/
│   └── wallet_service.dart       # Alchemy RPC calls
├── providers/
│   └── wallet_providers.dart     # Riverpod providers
├── screens/
│   └── home_screen.dart          # Main dashboard
└── widgets/
    ├── animations/
    │   ├── skeletons.dart
    │   └── count_up.dart
    ├── cards/
    │   ├── stat_cards.dart
    │   ├── tx_row.dart
    │   ├── token_row.dart
    │   └── wallet_input_widget.dart
    └── charts/
        └── wallet_charts.dart
```

---

## 🔑 Alchemy API Methods Used

| Method | Purpose |
|--------|---------|
| `eth_getBalance` | ETH balance |
| `alchemy_getAssetTransfers` | Sent + received transactions |
| `alchemy_getTokenBalances` | ERC-20 holdings |
| `alchemy_getTokenMetadata` | Token name/symbol/decimals |

---

## 📸 Demo Addresses

Try these well-known Ethereum addresses:

- **Vitalik Buterin** — `0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045`
- **Ethereum Foundation** — `0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe`

---

## 🛡 Security Note

Your Alchemy API key is stored in `.env` which is git-ignored. Never commit your `.env` file.

---

Built by [@abundance999](https://github.com/abundance999)
