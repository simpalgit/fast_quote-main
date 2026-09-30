import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Callback when a purchase is successful
  Function(PurchaseDetails)? onPurchaseSuccess;
  // Callback when a purchase fails
  Function(String)? onPurchaseError;

  void initialize() {
    if (Platform.isIOS) {
      final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
      _subscription = purchaseUpdated.listen(
        (purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        },
        onDone: () {
          _subscription.cancel();
        },
        onError: (error) {
          if (onPurchaseError != null) {
            onPurchaseError!(error.toString());
          }
        },
      );
    }
  }

  void dispose() {
    if (Platform.isIOS) {
      _subscription.cancel();
    }
  }

  Future<List<ProductDetails>> getProducts(List<String> productIds) async {
    if (!Platform.isIOS) return [];

    final bool available = await _iap.isAvailable();
    if (!available) {
      return [];
    }

    final ProductDetailsResponse response = await _iap.queryProductDetails(
      productIds.toSet(),
    );
    if (response.error != null) {
      debugPrint("IAP Error: ${response.error}");
      return [];
    }

    return response.productDetails;
  }

  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI if needed
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          if (onPurchaseError != null) {
            onPurchaseError!(
              purchaseDetails.error?.message ?? "Purchase failed",
            );
          }
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // Verify purchase on backend if needed
          if (onPurchaseSuccess != null) {
            onPurchaseSuccess!(purchaseDetails);
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    });
  }
}
