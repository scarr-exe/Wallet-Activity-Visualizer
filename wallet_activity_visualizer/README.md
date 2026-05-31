# 🔍 Wallet Activity Visualizer

Wallet Activity Visualizer is a premium Flutter dashboard for inspecting Ethereum wallet activity in one place. It combines Alchemy's JSON-RPC APIs, Riverpod state management, and polished motion design to turn a raw wallet address into a readable activity overview.

The app is designed for quick analysis: paste an address, view the ETH balance, inspect transfers, review token holdings, and scan charts that summarize wallet behavior over time.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Alchemy](https://img.shields.io/badge/Powered%20by-Alchemy-363FF9)
![Riverpod](https://img.shields.io/badge/State-Riverpod-00C896)

---

## Overview

This project focuses on presentation as much as data. The interface uses a dark terminal-inspired visual style, with animated counters, shimmer placeholders, and staggered transitions so the experience feels responsive while data is loading.

The main dashboard brings together four core wallet views:

- Current ETH balance with animated count-up feedback
- Transaction history with filters for all, received, sent, and token activity
- ERC-20 token balances with metadata lookup
- Lightweight charts for activity frequency and token distribution

---

## Features

### Wallet lookup

- Paste any Ethereum address into the input field
- Validate addresses before making requests
- Load wallet data from Alchemy-backed endpoints

### Balance and activity

- Show ETH balance in a prominent summary card
- Animate balance changes for a smoother first impression
- Display transfer history in a compact, readable list

### Filtering and analysis

- Filter transactions by category:
  - All
  - Received
  - Sent
  - Tokens
- Summarize activity with charts instead of relying only on long lists
- Inspect token holdings with symbol, amount, and metadata details

### Loading and motion

- Use shimmer skeletons while data is being fetched
- Reveal rows with staggered fade and slide animations
- Keep transitions subtle enough for dashboard use, not distracting

### Visual system

- Dark premium UI with a terminal-inspired feel
- Typography pairing based on JetBrains Mono and Sora
- High contrast cards, soft glow accents, and clean spacing

---

## Getting Started

### Prerequisites

Before running the app, make sure you have:

- Flutter 3.x or later
- Dart 3.0 or later
- An [Alchemy](https://alchemy.com) account
- An Alchemy API key for Ethereum mainnet

### Installation

1. Clone the repository.

   ```bash
   git clone https://github.com/abundance999/wallet-activity-visualizer.git
   cd wallet-activity-visualizer
   ```

2. Create a local environment file.

   ```bash
   cp .env.example .env
   ```

3. Add your Alchemy credentials to `.env`.

   ```env
   ALCHEMY_API_KEY=your_key_here
   ALCHEMY_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/your_key_here
   ```

4. Install dependencies.

   ```bash
   flutter pub get
   ```

5. Launch the application.

   ```bash
   flutter run
   ```

---

## Environment Configuration

The app expects environment values to be available through `flutter_dotenv`.

At minimum, configure:

- `ALCHEMY_API_KEY` for API access
- `ALCHEMY_RPC_URL` for Ethereum mainnet requests

Keep the `.env` file local to your machine. It should remain out of version control.

---

## Tech Stack

| Layer | Package | Purpose |
|-------|---------|---------|
| State management | `flutter_riverpod` | App state and async data flow |
| HTTP | `http` | API requests |
| Charts | `fl_chart` | Wallet activity visualizations |
| Animations | `flutter_animate` | Staggered UI motion |
| Skeletons | `shimmer` | Loading placeholders |
| Fonts | `google_fonts` | Typography styling |
| Env config | `flutter_dotenv` | Local secret loading |

---

## Data Flow

The app uses Alchemy as the data source and transforms the raw RPC responses into UI-friendly models.

Typical request flow:

1. User enters an Ethereum address.
2. The address is validated.
3. Riverpod triggers the wallet fetch logic.
4. The service layer calls Alchemy endpoints.
5. Model objects are populated and passed to the dashboard.
6. Cards, lists, and charts render the results.

This separation keeps UI code focused on presentation and service code focused on data fetching.

---

## Project Structure

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

### What each area does

- `models/` contains typed data classes for wallet data
- `services/` handles Alchemy requests and response parsing
- `providers/` exposes state to the UI with Riverpod
- `screens/` contains the main application surface
- `widgets/` contains reusable UI pieces, animations, and charts

---

## Alchemy Methods Used

| Method | Purpose |
|--------|---------|
| `eth_getBalance` | Fetch ETH balance |
| `alchemy_getAssetTransfers` | Fetch sent and received asset transfers |
| `alchemy_getTokenBalances` | Fetch ERC-20 holdings |
| `alchemy_getTokenMetadata` | Resolve token name, symbol, and decimals |

These methods provide enough data to build a usable wallet overview without requiring a backend server.

---

## Demo Addresses

If you want to test the app immediately, try these commonly referenced Ethereum addresses:

- Vitalik Buterin: `0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045`
- Ethereum Foundation: `0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe`

---

## Security Notes

- Store your Alchemy credentials only in `.env`
- Do not commit `.env` to the repository
- Use a free-tier key only for local development or demos

If you plan to publish the app, consider adding rate-limit handling and clearer error messages for failed RPC calls.

---

## Troubleshooting

### App does not start

- Confirm Flutter and Dart are installed correctly
- Run `flutter doctor` to check your setup
- Make sure dependencies were installed with `flutter pub get`

### No wallet data appears

- Verify the Ethereum address is valid
- Confirm the `.env` file exists and contains a working API key
- Check whether the Alchemy endpoint URL matches the key you created

### API errors or empty responses

- Confirm your Alchemy account still has access to the requested network
- Check for rate limits or expired credentials
- Retry with a known public address such as the demo examples above

---

## Future Improvements

Possible next steps for the app:

- Add network switching for other EVM chains
- Add token price lookups and portfolio value estimates
- Add pagination or infinite scrolling for large transfer histories
- Add wallet labels or saved favorites
- Add export support for wallet summaries

---

Built by [@abundance999](https://github.com/abundance999)
