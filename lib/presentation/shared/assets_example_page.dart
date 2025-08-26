import 'package:flutter/material.dart';
import '../../core/assets/assets_barrel.dart';

/// Example page demonstrating asset management with Spider
class AssetsExamplePage extends StatelessWidget {
  const AssetsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets Demo'),
        // Using SVG helper for app bar icon
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: 'assets/icons/menu.svg'.toSvgIcon(
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // SVG Logo
                    'assets/logos/app_logo.svg'.toSvg(
                      width: 60,
                      height: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Asset Management Demo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Icons section
            Text(
              'SVG Icons',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildIconExample(
                          context,
                          'assets/icons/user.svg',
                          'User Icon',
                        ),
                        _buildIconExample(
                          context,
                          'assets/icons/menu.svg',
                          'Menu Icon',
                        ),
                        _buildIconExample(
                          context,
                          'assets/icons/warning.svg',
                          'Warning Icon',
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'SVG icons with automatic color theming',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Image examples section
            Text(
              'Image Helpers',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildImageExample(
                          'Network + Fallback',
                          AssetHelper.getNetworkImageWithAssetFallback(
                            null, // Null network URL will show fallback
                            'assets/logos/app_logo.svg',
                            width: 60,
                            height: 40,
                          ),
                        ),
                        _buildImageExample(
                          'Error Handling',
                          AssetHelper.getImage(
                            'assets/images/non_existent.png',
                            width: 60,
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Automatic error handling and fallbacks',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Asset utilities section
            Text(
              'Asset Utilities',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: const Text('Asset Validation'),
                      subtitle: const Text('Check if assets exist at runtime'),
                      trailing: ElevatedButton(
                        onPressed: () => _checkAssetExists(context),
                        child: const Text('Test'),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.palette, color: Colors.blue),
                      title: const Text('Dynamic Theming'),
                      subtitle: const Text('SVG icons adapt to theme colors'),
                      trailing: IconButton(
                        onPressed: () => _showThemeExample(context),
                        icon: const Icon(Icons.color_lens),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.code, color: Colors.purple),
                      title: const Text('Generated Code'),
                      subtitle: const Text('Type-safe asset references'),
                      trailing: ElevatedButton(
                        onPressed: () => _showGeneratedCode(context),
                        child: const Text('View'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to use Spider:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text('1. Add assets to assets/ folders'),
                  const Text('2. Run: flutter packages pub run build_runner build'),
                  const Text('3. Use generated Assets class in your code'),
                  const Text('4. Enjoy type-safe asset management! 🎉'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconExample(
    BuildContext context,
    String assetPath,
    String label, {
    Color? color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: assetPath.toSvgIcon(
            size: 32,
            color: color ?? Theme.of(context).iconTheme.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildImageExample(String label, Widget image) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _checkAssetExists(BuildContext context) async {
    final exists = await 'assets/icons/user.svg'.assetExists();
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            exists 
                ? '✅ Asset exists: assets/icons/user.svg'
                : '❌ Asset not found: assets/icons/user.svg'
          ),
          backgroundColor: exists ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _showThemeExample(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Example'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Same SVG with different colors:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                'assets/icons/user.svg'.toSvgIcon(color: Colors.red),
                'assets/icons/user.svg'.toSvgIcon(color: Colors.green),
                'assets/icons/user.svg'.toSvgIcon(color: Colors.blue),
                'assets/icons/user.svg'.toSvgIcon(color: Colors.purple),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showGeneratedCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generated Code Preview'),
        content: const SingleChildScrollView(
          child: Text(
            '''// Generated by Spider - DO NOT MODIFY
class Assets {
  static const String iconsMenu = 'assets/icons/menu.svg';
  static const String iconsUser = 'assets/icons/user.svg';
  static const String iconsWarning = 'assets/icons/warning.svg';
  static const String logosAppLogo = 'assets/logos/app_logo.svg';
}

// Usage:
Assets.iconsUser.toSvgIcon()
Assets.logosAppLogo.toSvg()''',
            style: TextStyle(fontFamily: 'monospace'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}