import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/wallet_providers.dart';
import '../theme.dart';
import '../widgets/animations/skeletons.dart';
import '../widgets/cards/stat_cards.dart';
import '../widgets/cards/token_row.dart';
import '../widgets/cards/tx_row.dart';
import '../widgets/cards/wallet_input_widget.dart';
import '../widgets/charts/wallet_charts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletInfoProvider);
    final address = ref.watch(walletAddressProvider);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const WalletInputWidget(),
                  const SizedBox(height: 24),
                  if (address.isEmpty)
                    _buildEmptyState()
                  else
                    walletAsync.when(
                      loading: () => _buildLoadingState(),
                      error: (e, _) => _buildErrorState(e.toString()),
                      data: (wallet) {
                        if (wallet == null) return _buildEmptyState();
                        return _buildDashboard(wallet);
                      },
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppTheme.bg,
      elevation: 0,
      pinned: true,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppTheme.accent,
                size: 15,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Wallet Visualizer',
              style: GoogleFonts.sora(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              'ETH',
              style: GoogleFonts.jetBrainsMono(
                color: AppTheme.accent,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppTheme.border),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Icon(
            Icons.search,
            color: AppTheme.textMuted,
            size: 30,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Paste a wallet address',
          style: GoogleFonts.sora(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter any Ethereum address above\nto explore its on-chain activity.',
          textAlign: TextAlign.center,
          style: GoogleFonts.sora(
            color: AppTheme.textMuted,
            fontSize: 13,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        _buildDemoAddresses(),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildDemoAddresses() {
    final demos = [
      ('Vitalik Buterin', '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045'),
      ('Ethereum Foundation', '0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe'),
    ];

    return Column(
      children: [
        Text(
          'TRY A DEMO ADDRESS',
          style: GoogleFonts.jetBrainsMono(
            color: AppTheme.textHint,
            fontSize: 9,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        ...demos.map((d) => _demoChip(d.$1, d.$2)),
      ],
    );
  }

  Widget _demoChip(String label, String address) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(walletAddressProvider.notifier).state = address;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.person_outline, color: AppTheme.accentBlue, size: 15),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.sora(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${address.substring(0, 8)}...${address.substring(address.length - 6)}',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppTheme.textHint, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: StatCardSkeleton()),
            SizedBox(width: 10),
            Expanded(child: StatCardSkeleton()),
            SizedBox(width: 10),
            Expanded(child: StatCardSkeleton()),
          ],
        ),
        const SizedBox(height: 16),
        const ChartSkeleton(height: 180),
        const SizedBox(height: 16),
        const ChartSkeleton(height: 140),
        const SizedBox(height: 16),
        ...List.generate(5, (_) => const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: TxRowSkeleton(),
        )),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.accentRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentRed.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.accentRed, size: 32),
          const SizedBox(height: 12),
          Text(
            'Failed to load wallet data',
            style: GoogleFonts.sora(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            error.replaceAll('Exception: ', ''),
            textAlign: TextAlign.center,
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textMuted,
              fontSize: 11,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => ref.invalidate(walletInfoProvider),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                'RETRY',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildDashboard(wallet) {
    final address = ref.watch(walletAddressProvider);
    final filter = ref.watch(txFilterProvider);
    final filteredAsync = ref.watch(filteredTransfersProvider);
    final transfers = filteredAsync.value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.accent.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  address,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: address));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Address copied',
                          style: GoogleFonts.jetBrainsMono(fontSize: 12)),
                      backgroundColor: AppTheme.surface2,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Icon(Icons.copy, size: 14, color: AppTheme.textMuted),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms),

        const SizedBox(height: 16),

        // Stat cards
        Row(
          children: [
            Expanded(
              child: BalanceStatCard(ethBalance: wallet.ethBalance)
                  .animate()
                  .fadeIn(delay: 50.ms)
                  .slideY(begin: 0.05, end: 0),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                label: 'Transactions',
                value: wallet.transfers.length.toString(),
                valueColor: AppTheme.accentBlue,
                subtitle: 'total fetched',
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                label: 'Tokens',
                value: wallet.tokenCount.toString(),
                valueColor: AppTheme.accentPurple,
                subtitle: 'ERC-20 / NFT',
              ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.05, end: 0),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Charts
        TxFrequencyChart(wallet: wallet)
            .animate()
            .fadeIn(delay: 200.ms)
            .slideY(begin: 0.04, end: 0),
        const SizedBox(height: 12),
        TokenDistributionChart(wallet: wallet)
            .animate()
            .fadeIn(delay: 250.ms)
            .slideY(begin: 0.04, end: 0),

        const SizedBox(height: 24),

        // Transactions section
        Text(
          'TRANSACTIONS',
          style: GoogleFonts.jetBrainsMono(
            color: AppTheme.textMuted,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),

        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip('All', 'all', filter),
              const SizedBox(width: 8),
              _filterChip('Received', 'received', filter),
              const SizedBox(width: 8),
              _filterChip('Sent', 'sent', filter),
              const SizedBox(width: 8),
              _filterChip('Tokens', 'tokens', filter),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Transaction list
        if (transfers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No transactions found',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.textHint,
                  fontSize: 12,
                ),
              ),
            ),
          )
        else
          ...transfers.asMap().entries.map(
                (e) => TxRow(
                  tx: e.value,
                  walletAddress: address,
                  index: e.key,
                ),
              ),

        // Tokens section
        if (wallet.tokens.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'TOKEN HOLDINGS',
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textMuted,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          ...wallet.tokens.take(10).toList().asMap().entries.map(
                (e) => TokenRow(token: e.value, index: e.key),
              ),
        ],

        const SizedBox(height: 32),
        Center(
          child: Text(
            'Powered by Alchemy API',
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textHint,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String label, String value, String current) {
    final isActive = current == value;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(txFilterProvider.notifier).state = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accent.withOpacity(0.12) : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppTheme.accent : AppTheme.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: isActive ? AppTheme.accent : AppTheme.textMuted,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
