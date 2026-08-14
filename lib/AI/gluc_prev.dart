import 'dart:io';
import 'dart:math';

// كلاس لحساب مؤشرات تتعلق بالجلوكوز والمقاومة للأنسولين
class GlucosaCalculator {
  // ثوابت لضبط الحسابات
  static const double FACTOR_CARBOHIDRATOS = 0.1; // معامل تأثير الكربوهيدرات
  static const double FACTOR_RESISTENCIA = 1.0;   // معامل المقاومة
  static const double UMBRAL_TYG = 4.5;           // الحد الفاصل لمؤشر TyG

  double _resistenciaInsulina = 0.0; // لتخزين قيمة المقاومة للأنسولين

  // حساب مؤشر TyG (الدهون الثلاثية والجلوكوز)
  double calcularTyG(double trigliceridos, double glucosa) {
    if (trigliceridos <= 0 || glucosa <= 0) {
      throw ArgumentError('يجب أن تكون القيم موجبة');
    }
    return log(trigliceridos / 2) + log(glucosa / 2);
  }

  // حفظ قيمة المقاومة بناءً على مؤشر TyG
  void guardarResistencia(double tyGIndex) {
    _resistenciaInsulina = tyGIndex;
  }

  // الحصول على قيمة المقاومة الحالية
  double get resistenciaInsulina => _resistenciaInsulina;

  // حساب الجلوكوز المستقبلي بعد تناول كربوهيدرات
  double calcularGlucosaFutura(
      double glucosaActual, double carbohidratosConsumidos) {
    // حساب تأثير الكربوهيدرات
    double impactoCarbohidratos =
        carbohidratosConsumidos * FACTOR_CARBOHIDRATOS;
    double ajusteResistencia = _resistenciaInsulina * FACTOR_RESISTENCIA;

    return glucosaActual + impactoCarbohidratos - ajusteResistencia;
  }

  // تفسير مؤشر TyG
  String interpretarTyG(double tyGIndex) {
    return tyGIndex > UMBRAL_TYG
        ? 'خطر مرتفع لمقاومة الأنسولين'
        : 'الخطر طبيعي لمقاومة الأنسولين';
  }
}

void main() {
  final calc = GlucosaCalculator();

  try {
    print('أدخل مستوى الدهون الثلاثية (mg/dL):');
    final trigliceridos = double.parse(stdin.readLineSync()!);

    print('أدخل مستوى الجلوكوز أثناء الصيام (mg/dL):');
    final glucosaAyunas = double.parse(stdin.readLineSync()!);

    final tyGIndex = calc.calcularTyG(trigliceridos, glucosaAyunas);
    calc.guardarResistencia(tyGIndex);

    print("\nحساب مؤشر TyG:");
    print("الدهون الثلاثية: $trigliceridos mg/dL");
    print("الجلوكوز أثناء الصيام: $glucosaAyunas mg/dL");
    print("مؤشر TyG المحسوب: ${tyGIndex.toStringAsFixed(2)}");
    print(calc.interpretarTyG(tyGIndex));

    print('أدخل مستوى الجلوكوز الحالي (mg/dL):');
    final glucosaActual = double.parse(stdin.readLineSync()!);

    print('أدخل كمية الكربوهيدرات المستهلكة (بالغرام):');
    final carbohidratosConsumidos = double.parse(stdin.readLineSync()!);

    final glucosaFutura =
    calc.calcularGlucosaFutura(glucosaActual, carbohidratosConsumidos);

    print("\nتوقع مستوى الجلوكوز بعد ساعة:");
    print("الجلوكوز الحالي: $glucosaActual mg/dL");
    print("الكربوهيدرات المستهلكة: $carbohidratosConsumidos g");
    print(
        "مقاومة الأنسولين: ${calc.resistenciaInsulina.toStringAsFixed(2)}");
    print(
        "الجلوكوز المتوقع بعد ساعة: ${glucosaFutura.toStringAsFixed(2)} mg/dL");
  } on FormatException {
    print('خطأ: أدخل قيم رقمية صحيحة');
  } on ArgumentError catch (e) {
    print('خطأ: ${e.message}');
  }
}
