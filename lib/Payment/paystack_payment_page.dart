import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:wallpaper_app/Provider/save_purchased_wallpaper.dart';
import 'package:wallpaper_app/Utils/show_alert.dart';

import '../Constants/key.dart';


class MakePayment{
  // let us write constructors
  MakePayment({  this.ctx, this.amount, this.image });

  BuildContext? ctx;

  String? amount;

  String? image;



  PaystackPlugin paystack = PaystackPlugin();

  final User? _user = FirebaseAuth.instance.currentUser;

  // create a reference here
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }


  //get UI
  PaymentCard _getCardUI(){
    return PaymentCard(
        number: "",
        cvc: "",
        expiryMonth: 0,
        expiryYear: 0,
      country: '',
      name: _user!.displayName,

    );
  }


//create method that will initiallize our plugin for us, we will pass key the inside

  Future initializePlugin() async{
    await paystack.initialize(publicKey: ConstantKey.PAYSTACK_KEY);
  }

  // Create a method for charge card

  chargeCardAndMakePayment() async{
    final String price = amount!.replaceAll(',','');
    initializePlugin().then((_) async{
      Charge charge = Charge()
          ..amount = int.parse(price) * 100
          ..email = _user!.email
        ..currency = 'NGN'
      //to make it selectable btw banks and atm card add this below
      // ..accessCode = "12345"
          ..reference = _getReference()
          ..card = _getCardUI();

      CheckoutResponse response = await paystack.checkout(
          ctx!,
          charge: charge,
        //to make it selectable btw banks and atm card
        // method: CheckoutMethod.selectable,
        //
        method: CheckoutMethod.card,

        fullscreen: false,
        // logo: const FlutterLogo(
        //   size: 24,
        // ),

      );
      print("Response $response");

      final String message = response.message;

      if(response.status == true){
        //generate receipt
        SavePurchasedProvider().save(wallpaperImage: image);
        print("Transaction successful");
        showAlert(ctx!, 'Wall paper saved to download');
      }else{
        print("Transaction failed");
        showAlert(ctx!, message);
      }

    });
  }


}