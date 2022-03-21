class ConsumerFields {
  static const id = "Consumer_Id";
  static const name = "Consumer_Name";
  static const plotType = "Plot_Type";
  static const number = "Number";
  static const cnicNum = "CNIC_Number";
  static const email = "Email";
  static const tariffOrDia = "Tariff_Or_Dia";
  static const taluka = "Taluka";
  static const ucNum = "UC_Num";
  static const zoneNum = "Zone_Num";
  static const wardNum = "Ward_Num";
  static const area = "Area";
  static const unitNum = "Unit_Number";
  static const block = "Block";
  static const houseNum = "House_Number";
  static const address = "Address";
  static const newAddress = "New_Address";
  static const gasCompanyId = "Gas_Company_Id";
  static const electricCompanyId = "Electricity_Company_Id";
  static const landlineCompanyId = "Landline_Company_Id";
  static const dateTime = "DateTime";

  static List<String> getFields() => [
    id,
    name,
    plotType,
    number,
    cnicNum,
    email,
    taluka,
    ucNum,
    zoneNum,
    wardNum,
    area,
    unitNum,
    block,
    houseNum,
    address,
    newAddress,
    gasCompanyId,
    electricCompanyId,
    landlineCompanyId,
    dateTime];
}

class Consumers {
  final String id;
  final String plotType;
  final String name;
  final String number;
  final String emailAddress;
  final String nicNumber;
  final String tariffOrDia;
  final String taluka;
  final String ucNum;
  final String zoneNum;
  final String wardNum;
  final String area;
  final String block;
  final String houseNumber;
  final String unitNum;
  final String address;
  final String gasCompanyId;
  final String electricCompanyId;
  final String landlineCompanyId;

  Consumers({required this.id,
    required this.plotType,
    required this.name,
    required this.number,
    required this.emailAddress,
    required this.nicNumber,
    required this.tariffOrDia,
    required this.taluka,
    required this.ucNum,
    required this.zoneNum,
    required this.area,
    required this.block,
    required this.houseNumber,
    required this.unitNum,
    required this.wardNum,
    required this.address,
    required this.gasCompanyId,
    required this.electricCompanyId,
    required this.landlineCompanyId,
  });

  factory Consumers.fromJson(Map<String, dynamic> json) {
    return Consumers(
      id: json["ConsumerID"],
      plotType: json["Plot_type"],
      name: json["Name"],
      number: json["Number"],
      nicNumber: json["Nic_Number"],
      tariffOrDia: json["tariff_Or_Dia"],
      emailAddress: json["Email"],
      taluka: json["Taluka"],
      ucNum: json["UC"],
      zoneNum: json["Zone"],
      wardNum: json["Ward"],
      area: json["Area"],
      block: json["Block"],
      houseNumber: json["HouseNO"],
      address: json["Address"],
      unitNum: json["UnitNumber"],
      gasCompanyId: json["GasCompany"],
      electricCompanyId: json["ElectricCompany"],
      landlineCompanyId: json["LandlineCompany"],
    );
  }

  Map<String, dynamic> toJson() => {
    ConsumerFields.id : id,
    ConsumerFields.plotType : plotType,
    ConsumerFields.name : name,
    ConsumerFields.number : number,
    ConsumerFields.email : emailAddress,
    ConsumerFields.ucNum : ucNum,
    ConsumerFields.zoneNum : wardNum,
    ConsumerFields.address : address,
    ConsumerFields.gasCompanyId : gasCompanyId,
    ConsumerFields.electricCompanyId : electricCompanyId,
    ConsumerFields.landlineCompanyId : landlineCompanyId
  };
}