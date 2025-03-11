
class BankModel {
  final String id;
  final String accountHolderName;
  final String bankName;
  final String country;
  final String currency;
  final String last4;
  final String status;
  final bool isDefault;

  BankModel({
    required this.id,
    required this.accountHolderName,
    required this.bankName,
    required this.country,
    required this.currency,
    required this.last4,
    required this.status,
    required this.isDefault,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'],
      accountHolderName: json['account_holder_name'] ?? "Unknown",
      bankName: json['bank_name'] ?? "Unknown Bank",
      country: json['country'] ?? "NO",
      currency: json['currency'] ?? "nok",
      last4: json['last4'] ?? "****",
      status: json['status'] ?? "pending",
      isDefault: json['default_for_currency'] ?? false,
    );
  }
}
