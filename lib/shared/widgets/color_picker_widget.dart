import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';

/// Color picker widget for selecting custom colors
class ColorPickerWidget extends ConsumerWidget {
  final String title;
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> predefinedColors;
  
  const ColorPickerWidget({
    super.key,
    required this.title,
    required this.currentColor,
    required this.onColorChanged,
    this.predefinedColors = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Current color display
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: currentColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey, width: 1),
          ),
          child: Center(
            child: Text(
              _getColorName(currentColor),
              style: TextStyle(
                color: _getContrastColor(currentColor),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Predefined colors
        if (predefinedColors.isNotEmpty) ...[
          Text(
            'Predefined Colors',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: predefinedColors.map((color) {
              final isSelected = color.value == currentColor.value;
              return GestureDetector(
                onTap: () => onColorChanged(color),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.grey,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 16,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
        
        // Custom color picker
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showColorPicker(context, ref),
            icon: const Icon(Icons.color_lens, size: 16),
            label: const Text('Custom Color'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
  
  String _getColorName(Color color) {
    // Convert color to hex string
    final hex = color.value.toRadixString(16).padLeft(8, '0').substring(2);
    return '#$hex'.toUpperCase();
  }
  
  Color _getContrastColor(Color color) {
    // Calculate luminance to determine if we should use white or black text
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? AppColors.black : AppColors.white;
  }
  
  void _showColorPicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick $title'),
        content: SizedBox(
          width: 300,
          height: 350,
          child: ColorPicker(
            currentColor: currentColor,
            onColorChanged: (color) {
              onColorChanged(color);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

/// Simple color picker using HSV color space
class ColorPicker extends StatefulWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;
  
  const ColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late HSVColor _hsvColor;
  
  @override
  void initState() {
    super.initState();
    _hsvColor = HSVColor.fromColor(widget.currentColor);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Color preview
        Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: _hsvColor.toColor(),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Hue slider
        Text('Hue: ${_hsvColor.hue.round()}°'),
        Slider(
          value: _hsvColor.hue,
          min: 0,
          max: 360,
          divisions: 360,
          onChanged: (value) {
            setState(() {
              _hsvColor = _hsvColor.withHue(value);
            });
            widget.onColorChanged(_hsvColor.toColor());
          },
        ),
        
        // Saturation slider
        Text('Saturation: ${(_hsvColor.saturation * 100).round()}%'),
        Slider(
          value: _hsvColor.saturation,
          min: 0,
          max: 1,
          divisions: 100,
          onChanged: (value) {
            setState(() {
              _hsvColor = _hsvColor.withSaturation(value);
            });
            widget.onColorChanged(_hsvColor.toColor());
          },
        ),
        
        // Value slider
        Text('Value: ${(_hsvColor.value * 100).round()}%'),
        Slider(
          value: _hsvColor.value,
          min: 0,
          max: 1,
          divisions: 100,
          onChanged: (value) {
            setState(() {
              _hsvColor = _hsvColor.withValue(value);
            });
            widget.onColorChanged(_hsvColor.toColor());
          },
        ),
      ],
    );
  }
}
