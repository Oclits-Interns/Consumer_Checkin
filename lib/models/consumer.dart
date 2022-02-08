class ConsumerFields {
  static const id = "Consumer-Id";
  static const name = "Consumer-Name";
  static const plotType = "Plot-Type";
  static const number = "Number";
  static const email = "Email";
  static const ucNum = "UC-Num";
  static const zone_ward = "Zone-Ward-Num";
  static const address = "Address";
  static const newAddress = "New-Address";
  static const GasCompanyId = "Gas-Company-Id";
  static const ElectricCompanyId = "Electricity-Company-Id";
  static const LandlineCompanyId = "Landline-Company-Id";

  static List<String> getFields() => [id,
    name,
    plotType,
    number,
    email,
    ucNum,
    zone_ward,
    address,
    newAddress,
    GasCompanyId,
    ElectricCompanyId,
    LandlineCompanyId];
}