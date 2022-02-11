class ConsumerFields {
  static const id = "Consumer_Id";
  static const name = "Consumer_Name";
  static const plotType = "Plot_Type";
  static const number = "Number";
  static const cnicNum = "CNIC_Number";
  static const email = "Email";
  static const taluka = "Taluka";
  static const ucNum = "UC_Num";
  static const zone_ward = "Zone_Ward_Num";
  static const area = "Area";
  static const street = "Street";
  static const block = "Block";
  static const houseNum = "House_Number";
  static const address = "Address";
  static const newAddress = "New_Address";
  static const gasCompanyId = "Gas_Company_Id";
  static const electricCompanyId = "Electricity_Company_Id";
  static const landlineCompanyId = "Landline_Company_Id";

  static List<String> getFields() => [
    id,
    name,
    plotType,
    number,
    cnicNum,
    email,
    taluka,
    ucNum,
    zone_ward,
    area,
    street,
    block,
    houseNum,
    address,
    newAddress,
    gasCompanyId,
    electricCompanyId,
    landlineCompanyId];
}

/*
class Consumers {
  final String id;
  final String plotType;
  final String name;
  final String number;
  final String emailAddress;
  final String ucNum;
  final String wardNum;
  final String address;
  final String newAddress;
  final String gasCompanyId;
  final String electricCompanyId;
  final String landlineCompanyId;

  Consumers({required this.id,
    required this.plotType,
    required this.name,
    required this.number,
    required this.emailAddress,
    required this.ucNum,
    required this.wardNum,
    required this.address,
    required this.newAddress,
    required this.gasCompanyId,
    required this.electricCompanyId,
    required this.landlineCompanyId,
  });

  factory Consumers.fromJson(Map<String, dynamic> json) {
    return Consumers(
      id: json["id"],
      plotType: json["plot_type"],
      name: json["name"],
      number: json["number"],
      emailAddress: json["email_address"],
      ucNum: json["uc_num"],
      wardNum: json["ward_num"],
      address: json["address"],
      newAddress: json["new_address"],
      gasCompanyId: json["gas_company_id"],
      electricCompanyId: json["electric_company_id"],
      landlineCompanyId: json["landline_company_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    ConsumerFields.id : id,
    ConsumerFields.plotType : plotType,
    ConsumerFields.name : name,
    ConsumerFields.number : number,
    ConsumerFields.email : emailAddress,
    ConsumerFields.ucNum : ucNum,
    ConsumerFields.zone_ward : wardNum,
    ConsumerFields.address : address,
    ConsumerFields.newAddress : newAddress,
    ConsumerFields.gasCompanyId : gasCompanyId,
    ConsumerFields.electricCompanyId : electricCompanyId,
    ConsumerFields.landlineCompanyId : landlineCompanyId
  };
}*/
