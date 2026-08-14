// lib/services/glucose_service.dart


import 'gluc_prev.dart';

class GlucoseService {
  final GlucosaCalculator _calculator = GlucosaCalculator();

  Future<double> calculateTyGIndex(double triglycerides, double fastingGlucose) async {
    return _calculator.calcularTyG(triglycerides, fastingGlucose);
  }

  Future<String> interpretTyGIndex(double tyGIndex) async {
    _calculator.guardarResistencia(tyGIndex);
    return _calculator.interpretarTyG(tyGIndex);
  }

  Future<double> predictGlucose(
      double currentGlucose,
      double carbsConsumed,
      double? tyGIndex,
      ) async {
    if (tyGIndex != null) {
      _calculator.guardarResistencia(tyGIndex);
    }
    return _calculator.calcularGlucosaFutura(currentGlucose, carbsConsumed);
  }
}