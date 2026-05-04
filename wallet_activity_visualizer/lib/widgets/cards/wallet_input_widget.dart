import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/wallet_providers.dart';
import '../../services/wallet_service.dart';
import '../../theme.dart';

class WalletInputWidget extends ConsumerStatefulWidget {
  const WalletInputWidget({super.key});

  @override
  ConsumerState<WalletInputWidget> createState() => _WalletInputWidgetState();
}

class _WalletInputWidgetState extends ConsumerState<WalletInputWidget> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isValid = false;
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final val = _controller.text.trim();
    setState(() {
      _hasInput = val.isNotEmpty;
      _isValid = WalletService.isValidAddress(val);
    });
  }

  void _analyze() {
    final addr = _controller.text.trim();
    if (!WalletService.isValidAddress(addr)) return;
    HapticFeedback.mediumImpact();
    ref.read(walletAddressProvider.notifier).state = addr;
    _focusNode.unfocus();
  }

  void _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _controller.text = data!.text!.trim();
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  Color get _borderColor {
    if (!_hasInput) return AppTheme.border;
    return _isValid ? AppTheme.accent : AppTheme.accentRed;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WALLET ADDRESS',
          style: GoogleFonts.jetBrainsMono(
            color: AppTheme.textMuted,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1.2),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    hintText: '0x71C7656EC7ab88b098defB...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintStyle: GoogleFonts.jetBrainsMono(
                      color: AppTheme.textHint,
                      fontSize: 12,
                    ),
                  ),
                  onSubmitted: (_) => _analyze(),
                ),
              ),
              if (_hasInput)
                IconButton(
                  icon: const Icon(Icons.clear, size: 16),
                  color: AppTheme.textMuted,
                  onPressed: () {
                    _controller.clear();
                    ref.read(walletAddressProvider.notifier).state = '';
                  },
                ),
              _buildPasteButton(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isValid ? AppTheme.accent : AppTheme.surface2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isValid ? AppTheme.accent : AppTheme.border,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _isValid ? _analyze : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ANALYZE WALLET',
                        style: GoogleFonts.jetBrainsMono(
                          color: _isValid ? Colors.black : AppTheme.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: _isValid ? Colors.black : AppTheme.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_hasInput && !_isValid) ...[
          const SizedBox(height: 6),
          Text(
            '⚠ Invalid Ethereum address — must start with 0x and be 42 characters',
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.accentRed,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasteButton() {
    return GestureDetector(
      onTap: _paste,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppTheme.border),
        ),
        child: Text(
          'PASTE',
          style: GoogleFonts.jetBrainsMono(
            color: AppTheme.textMuted,
            fontSize: 9,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
