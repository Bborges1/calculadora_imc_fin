class Imc {
  late String? id;
  late String? usuario;
  late double altura;
  late double? imc;
  late double peso;
  late DateTime? data;

  Imc({
    this.id,
    this.usuario,
    required this.altura,
    required this.peso,
    this.imc,
    this.data,
  }) {
    this.imc = peso / (altura * altura);
  }

  factory Imc.fromMap(Map<String, dynamic> map) {
    return Imc(
        id: map['id'],
        usuario: map['usuario'],
        altura: map['altura'],
        peso: map['peso'],
        imc: map['imc'],
        data: map['data']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'altura': altura,
      'peso': peso,
      'imc': imc,
      'data': data?.toIso8601String(),
    };
  }
}
