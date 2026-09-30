import 'package:shared_preferences/shared_preferences.dart';

const loginKey = "LOGIN_STATUS";

const custUidKey = "CUSTUIDKEY";
const custEmailKey = "CUSTEMAILKEY";
const custUserTokeKey = "CUSTUSERTOKENKEY";
const custUserType = "CUSTUSERTYPEKEY";
const custAuthKey = "CUSTAUTHKEY";
const profileDataKey = "PROFILEDATAKEY";
const taxLabelKey = "TAXLABELKEY";
const productHSNLabelKey = "PRODUCTHSNLABELKEY";
const otherChargesLabelKey = "OTHERCHARGESLABELKEY";
const fillBusinessData = "FILLBUSINESSDATA";
const fillQuotationData = "FILLQUOTATIONDATA";
const fillInvoiceData = "FILLINVOICEDATA";
const tutorialBool = "TUTORIALBOOL";
const supportVideoLink = "SUPPORTVIDEOLINK";
const subscriptionId = "SUBSCRIPTIONID";
const hasPlan = "HASPLAN";

class LocalPreferences {
  setLoginBool(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(loginKey, value);
  }

  // ------------------------------------------------------------------
  Future setUid(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(custUidKey, val);
  }

  Future<String?> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(custUidKey);
  }

  // ------------------------------------------------------------------
  Future setEmail(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(custEmailKey, val);
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(custEmailKey);
  }

  // ------------------------------------------------------------------

  Future setAuthToken(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(custAuthKey, val);
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(custAuthKey);
  }

  // ------------------------------------------------------------------

  Future setProfileData(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(profileDataKey, val);
  }

  Future<String?> getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(profileDataKey);
  }

  // ----------------------------------------------------------------------

  Future setTaxLabel(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(taxLabelKey, val);
  }

  Future<String?> getTaxLabel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(taxLabelKey);
  }

  // ----------------------------------------------------------------------

  Future setProductHSNLabel(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(productHSNLabelKey, val);
  }

  Future<String?> getProductHSNLabel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(productHSNLabelKey);
  }

  // ----------------------------------------------------------------------

  Future setOtherChargesLabel(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(otherChargesLabelKey, val);
  }

  Future<String?> getOtherChargesLabel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(otherChargesLabelKey);
  }
  // ----------------------------------------------------------------------

  Future setBusinessFill(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(fillBusinessData, val);
  }

  Future<bool?> getBusinessFill() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(fillBusinessData);
  }
  // ----------------------------------------------------------------------

  Future setQuotationFill(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(fillQuotationData, val);
  }

  Future<bool?> getQuotationFill() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(fillQuotationData);
  }
  // ----------------------------------------------------------------------

  Future setInvoiceFill(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(fillInvoiceData, val);
  }

  Future<bool?> getInvoiceFill() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(fillInvoiceData);
  }

  // ----------------------------------------------------------------------
  Future setTutorialCompleteBool(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(tutorialBool, val);
  }

  Future<bool?> getTutorialCompleteBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs;
    if (value.containsKey(tutorialBool)) {
      return prefs.getBool(tutorialBool);
    } else {
      return false;
    }
  }

  // ----------------------------------------------------------------------

  Future setSupportVideoLink(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(supportVideoLink, val);
  }

  Future<String?> getSupportVideoLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(supportVideoLink);
  }
  // ----------------------------------------------------------------------

  Future setSubscriptionId(int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(subscriptionId, val);
  }

  Future<int?> getSubscriptionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(subscriptionId);
  }

  // ----------------------------------------------------------------------

  Future setHasPlan(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(hasPlan, val);
  }

  Future<bool?> getHasPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(hasPlan);
  }

  setOtherChargesLabelIfEmpty(String s) {}
}
