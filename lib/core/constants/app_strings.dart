class AppStrings {
  AppStrings._();

  // App General
  static const String appName = 'Dairy Khata';
  static const String appTagline = 'Dairy Farm Ledger & Herd Management';
  static const String currencySymbol = 'Rs.';
  static const String unitLiters = 'L';

  // Navigation Titles
  static const String navHome = 'Dashboard';
  static const String navKhata = 'Ledger';
  static const String navHerd = 'My Herd';
  static const String navBreeds = 'Encyclopedia';
  static const String navProfile = 'Profile';

  // Auth Strings
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Sign in to manage your dairy farm ledger';
  static const String registerTitle = 'Create Account';
  static const String registerSubtitle = 'Start tracking your milk production & sales';
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'Enter your email';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String fullNameLabel = 'Full Name';
  static const String fullNameHint = 'e.g. Chaudhry Ahmed';
  static const String farmNameLabel = 'Farm Name';
  static const String farmNameHint = 'e.g. Green Pastures Farm';
  static const String phoneLabel = 'Phone Number';
  static const String phoneHint = 'e.g. 03001234567';
  static const String loginButton = 'Sign In';
  static const String registerButton = 'Register Farm';
  static const String dontHaveAccount = "Don't have an account? Register";
  static const String alreadyHaveAccount = 'Already have an account? Sign In';
  static const String logout = 'Sign Out';

  // Dashboard Strings
  static const String dashboardGreeting = 'Hello,';
  static const String todayProduction = "Today's Milk";
  static const String todayRevenue = "Today's Revenue";
  static const String weeklyOverview = 'Weekly Production (7 Days)';
  static const String quickActions = 'Quick Actions';
  static const String addMilkEntry = 'Add Milk Entry';
  static const String recordPayment = 'Record Payment';
  static const String recentTransactions = 'Recent Activity';
  static const String noDataYet = 'No entries recorded yet';

  // Customer Khata (Ledger) Strings
  static const String khataHeader = 'Customer Ledger';
  static const String totalOutstanding = 'Total Outstanding Balance';
  static const String addCustomer = 'Add New Customer';
  static const String customerName = 'Customer Name';
  static const String customerPhone = 'Phone Number';
  static const String customerAddress = 'Address / Location';
  static const String totalBought = 'Bought';
  static const String totalPaid = 'Paid';
  static const String remainingBalance = 'Remaining Balance';
  static const String recordMilkSale = 'Record Milk Sale';
  static const String recordPaymentReceived = 'Receive Payment';
  static const String milkQuantity = 'Milk Quantity (Liters)';
  static const String ratePerLiter = 'Rate per Liter (Rs)';
  static const String totalAmount = 'Total Amount';
  static const String paymentReceived = 'Payment Received';
  static const String previousBalance = 'Previous Balance';
  static const String newBalance = 'New Balance';
  static const String transactionTypeSale = 'Milk Sale';
  static const String transactionTypePayment = 'Payment Received';

  // Herd Management Strings
  static const String herdHeader = 'My Herd';
  static const String addAnimal = 'Add Animal';
  static const String tagIdLabel = 'Tag / ID Number';
  static const String tagIdHint = 'e.g. COW-102';
  static const String animalType = 'Animal Type';
  static const String animalBreed = 'Breed';
  static const String purchaseDate = 'Purchase Date';
  static const String averageYield = 'Daily Yield (Liters)';
  static const String cow = 'Cow';
  static const String buffalo = 'Buffalo';
  static const String totalAnimals = 'Total Animals';

  // Cattle Encyclopedia Strings
  static const String encyclopediaHeader = 'Cattle Encyclopedia';
  static const String searchBreedHint = 'Search cow or buffalo breeds...';
  static const String avgYieldLabel = 'Average Daily Yield';
  static const String fatPercentageLabel = 'Average Fat Content';
  static const String keyTraits = 'Key Characteristics';
  static const String originRegion = 'Origin / Region';

  // Shared Actions & Buttons
  static const String save = 'Save Entry';
  static const String submit = 'Submit';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String confirm = 'Confirm';
  static const String loading = 'Please wait...';
  static const String notesLabel = 'Notes / Description';
  static const String optional = '(Optional)';

  // Validation Messages
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String invalidNumber = 'Please enter a valid number';
  static const String passwordTooShort = 'Password must be at least 6 characters';
}
