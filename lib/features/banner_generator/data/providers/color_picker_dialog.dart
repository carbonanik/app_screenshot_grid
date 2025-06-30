import '../../../../shared/models/background_type.dart';
import 'package:flutter/material.dart';
import '../../presentation/widgets/modern_color_picker_dialog.dart';

class ColorPickerDialog extends StatelessWidget {
  final String title;
  final bool allowGradients;

  const ColorPickerDialog({
    super.key,
    this.title = "Select Color",
    this.allowGradients = true,
  });

  @override
  Widget build(BuildContext context) {
    // Modern designer colors - trending and commonly used
    const solidColors = [
      // Neutrals
      Color(0xFFFFFFFF), // Pure White
      Color(0xFFF8F9FA), // Off White
      Color(0xFFE9ECEF), // Light Gray
      Color(0xFF6C757D), // Medium Gray
      Color(0xFF212529), // Dark Gray
      Color(0xFF000000), // Pure Black
      // Modern Blues
      Color(0xFF0D6EFD), // Primary Blue
      Color(0xFF0A58CA), // Dark Blue
      Color(0xFF6EA8FE), // Light Blue
      Color(0xFFE7F1FF), // Very Light Blue
      // Modern Greens
      Color(0xFF198754), // Success Green
      Color(0xFF20C997), // Teal
      Color(0xFFD1E7DD), // Light Green
      // Modern Purples
      Color(0xFF6F42C1), // Purple
      Color(0xFF8B5CF6), // Modern Purple
      Color(0xFFE9D5FF), // Light Purple
      // Modern Pinks
      Color(0xFFD63384), // Pink
      Color(0xFFEC4899), // Modern Pink
      Color(0xFFFCE7F3), // Light Pink
      // Modern Oranges
      Color(0xFFFD7E14), // Orange
      Color(0xFFFF6B35), // Modern Orange
      Color(0xFFFFE5D9), // Light Orange
      // Modern Yellows
      Color(0xFFFFC107), // Warning Yellow
      Color(0xFFF59E0B), // Amber
      Color(0xFFFEF3C7), // Light Yellow
      // Modern Reds
      Color(0xFFDC3545), // Danger Red
      Color(0xFFEF4444), // Modern Red
      Color(0xFFFEE2E2), // Light Red
    ];

    // Modern designer gradients - trending and commonly used
    const gradients = [
      // Blue Gradients
      LinearGradient(
        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFF0EA5E9), Color(0xFF8B5CF6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),

      // Purple Gradients
      LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFFF59E0B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),

      // Green Gradients
      LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFF34D399), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),

      // Pink Gradients
      LinearGradient(
        colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFFF472B6), Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),

      // Orange Gradients
      LinearGradient(
        colors: [Color(0xFFF97316), Color(0xFFEA580C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFFFB923C), Color(0xFFF97316)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),

      // Sunset Gradients
      LinearGradient(
        colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFFFF8E53), Color(0xFFFE6B8B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),

      // Ocean Gradients
      LinearGradient(
        colors: [Color(0xFF0EA5E9), Color(0xFF22D3EE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFF0891B2), Color(0xFF0EA5E9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),

      // Neutral Gradients
      LinearGradient(
        colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFF374151), Color(0xFF6B7280)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),

      // Modern Multi-Color Gradients
      LinearGradient(
        colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];

    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Solid colors section
            _buildSectionTitle("Solid Colors"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: solidColors.map((color) {
                return GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pop(BackgroundColor(color)),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Gradients section (only show if gradients are allowed)
            if (allowGradients) ...[
              _buildSectionTitle("Gradients"),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: gradients.map((gradient) {
                  return GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pop(BackgroundGradient(gradient)),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Custom color option
            _buildSectionTitle("Custom Color"),
            GestureDetector(
              onTap: () async {
                final picked = await showDialog<Color>(
                  context: context,
                  builder: (context) => ModernColorPickerDialog(
                    initialColor: Colors.white,
                    title: allowGradients ? "Background Color" : "Title Color",
                  ),
                );
                if (picked != null) {
                  Navigator.of(context).pop(BackgroundColor(picked));
                }
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF667EEA),
                      Color(0xFF764BA2),
                      Color(0xFFF093FB),
                      Color(0xFFF5576C),
                      Color(0xFF4FACFE),
                      Color(0xFF00F2FE),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.palette, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Choose Custom Color",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
