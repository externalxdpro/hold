// Users collection
const String usersCollection = 'users';
const String fundsCollection = 'funds';
const String serverCollection = 'server';

class UserConsts {
  static const String firstNameField = 'firstName';
  static const String lastNameField = 'lastName';
  static const String userAgeField = 'UserAge';
  static const String userBadgesField = 'UserBadges';
  static const String uidField = 'uid';
  static const String userCreatedAccountField = 'UserCreatedAccount';
  static const String portfolioField = 'Portfolio';
  static const String notificationTokenField = 'notificationToken';
  static const String deviceUIDField = 'deviceUID';
  static const String premiumUserField = 'PremiumUser';
  static const String portfolioDonationField = 'PortfolioDonation';
  static const String totalMonthlyDonationField = 'TotalMonthlyDonation';
  static const String totalDonationField = 'TotalDonation';
  static const String emailField = 'Email';
  static const String stripeCustomerIDField = 'StripeCustomerID';
}

// Funds collection
class FundConsts {
  static const String charitiesCollection = 'charities';
  static const String donationsCollection = 'donations';

  static const String causeField = 'Cause';
  static const String nameField = 'Name';
  static const String descriptionField = 'Description';
  static const String dateCreatedField = 'DateCreated';
}

// Charity collection (inside of funds collection)
class CharityConsts {
  static const String causeField = 'Cause';
  static const String charityIDField = 'CharityID';
  static const String nameField = 'Name';
  static const String descriptionField = 'Description';
  static const String dateListedField = 'DateListed';
  static const String disclaimerField = 'Disclaimer';
  static const String donationsField = 'Donations';
  static const String employeesField = 'Employees';
  static const String fundField = 'Fund';
  static const String locationField = 'Location';
  static const String revenueField = 'Revenue';
  static const String taxField = 'Tax';
  static const String websiteField = 'Website';
}

// Server collection
class ServerConsts {
  // AppSecurity document
  static const String appSecurityDoc = 'appSecurity';

  // FeesConfig document
  static const String feesConfigDoc = 'feesConfig';

  static const String smallFeeField = 'Small';
  static const String largeFeeField = 'Large';

  // ServerConfig document
  static const String serverConfigDoc = 'serverConfig';

  static const String disclaimerField = 'Disclaimer';
  static const String maintenanceField = 'Maintenance';
  static const String waitlistField = 'Waitlist';
  static const String appVersionField = 'app_android_version';
}
