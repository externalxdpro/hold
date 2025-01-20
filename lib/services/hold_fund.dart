import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hold/constants/database.dart';

class HoldFund {
  String? cause;
  String? name;
  String? description;
  DateTime? dateCreated;
  List<HoldCharity>? charities;

  HoldFund({
    required this.cause,
    required this.name,
    required this.description,
    required this.dateCreated,
    required this.charities,
  });

  @override
  String toString() {
    return '{cause: $cause, name: $name, description: $description, dateCreated: $dateCreated, charities: $charities}';
  }
}

class HoldCharity {
  String? fund;
  String? cause;
  String? name;
  String? description;
  DateTime? dateListed;
  String? disclaimer;
  int? donations;
  int? employees;
  String? location;
  int? revenue;
  String? tax;
  String? website;

  HoldCharity({
    required this.fund,
    required this.cause,
    required this.name,
    required this.description,
    required this.dateListed,
    required this.disclaimer,
    required this.donations,
    required this.employees,
    required this.location,
    required this.revenue,
    required this.tax,
    required this.website,
  });

  @override
  String toString() {
    return '{fund: $fund, cause: $cause, name: $name, description: $description, dateListed: $dateListed, disclaimer: $disclaimer, donations: $donations, employees: $employees, location: $location, revenue: $revenue, tax: $tax, website: $website}';
  }
}

class HoldFunds {
  static List<HoldFund> funds = [];

  static Future<void> update() async {
    funds = [];
    final fundsData = FirebaseFirestore.instance.collection(fundsCollection);

    for (DocumentSnapshot doc in (await fundsData.get()).docs) {
      final data = doc.data() as Map<String, dynamic>;
      final charitiesData =
          fundsData.doc(doc.id).collection(FundConsts.charitiesCollection);

      List<HoldCharity> charities = [];
      for (DocumentSnapshot doc in (await charitiesData.get()).docs) {
        final data = doc.data() as Map<String, dynamic>;
        charities.add(HoldCharity(
          fund: data[CharityConsts.fundField],
          cause: data[CharityConsts.causeField],
          name: data[CharityConsts.nameField],
          description: data[CharityConsts.descriptionField],
          dateListed: data[CharityConsts.dateListedField]?.toDate(),
          disclaimer: data[CharityConsts.disclaimerField],
          donations: data[CharityConsts.donationsField],
          employees: data[CharityConsts.employeesField],
          location: data[CharityConsts.locationField],
          revenue: data[CharityConsts.revenueField],
          tax: data[CharityConsts.taxField],
          website: data[CharityConsts.websiteField],
        ));
      }
      funds.add(HoldFund(
        cause: data[FundConsts.causeField],
        name: data[FundConsts.nameField],
        description: data[FundConsts.descriptionField],
        dateCreated: data[FundConsts.dateCreatedField]?.toDate(),
        charities: charities,
      ));
    }
  }
}
