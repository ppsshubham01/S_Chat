import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  final userEmailKey = "email";
  final userPasswordKey = "password";
  final accountIdKey = "accountId";
  final accountTypeKey = "accountType";
  final lastSelectedWaterMeterKey = "watermeter";
  final currentDateKey = "currentDate";
  final userFullNameKey = "userFullName";
  final userDeviceIdKey = "userDeviceId";
  final userDeviceNameKey = "userDeviceName";
  final userDeviceOSTypeKey = "userDeviceOSType";
  final userJWtTokenKey = "userJWtToken";
  final fcmTokenKey = "userDeviceFirebaseNotificationToken";
  final customerIdKey = "cId";
  final firstTimeAppOpenKey = "firtsTimeAppOpen";
  final stripeCustomerEmpheralKey = "stripeCustomerEmpheralKey";
  final stripeCustomerContextIdKey = "stripeCustomerContextId";
  final stripePublishableKey = "stripePublishableKey";
  final temperatureUnitKey = "temperatureUnit";
  final displayUnitKey = "displayUnit";
  final modeKey = "selectedMode";
  final rememberMekey = "rememberMe";
  final isDataEncrypted = "isDataEncrypted";
  final isMailExist = "isMailExist";
  final isFirstTimeFCMOpen = "isFirstTimeFCMOpen";
  final fcmNotificationUniqueIdList = "fcmNotificationUniqueIdList";

  Future<bool> setIsMailExist(bool isMailExistBool) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(isMailExist, isMailExistBool);
  }

  Future<bool?> getIsMailExist() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isMailExist);
  }

// ! User Email
  Future<bool> saveUserEmail(userEmail) async {//work
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userEmailKey, userEmail);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userEmailKey);
  }

  Future<bool> removeUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userEmailKey);
  }

// ! User Password
  Future<bool> saveUserPassword(userPassword) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userPasswordKey, userPassword);
  }

  Future<String?> getUserPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userPasswordKey);
  }

  Future<bool> removeUserPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userPasswordKey);
  }

// ! Acount ID
  Future<bool> saveAccountId(accountId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(accountIdKey, accountId);
  }

  Future<String?> getAccountId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(accountIdKey);
  }

  Future<bool> removeAccountId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(accountIdKey);
  }

// ! Account Type
  Future<bool> saveAccountType(accountType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(accountTypeKey, accountType);
  }

  Future<String?> getAccountType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(accountTypeKey);
  }

  Future<bool> removeAccountType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(accountTypeKey);
  }

// ! Last Selected Water Meter
  Future<bool> saveLastSelectedWaterMeter(lastSelectedWaterMeter) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        lastSelectedWaterMeterKey, lastSelectedWaterMeter);
  }

  Future<String?> getLastSelectedWaterMeter() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(lastSelectedWaterMeterKey);
  }

  Future<bool> removeLastSelectedWaterMeter() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(lastSelectedWaterMeterKey);
  }

// ! Current Data
  Future<bool> saveCurrentDate(lastSelectedWaterMeter) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        currentDateKey, lastSelectedWaterMeter);
  }

  Future<String?> getCurrentDate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(currentDateKey);
  }

  Future<bool> removeCurrentDate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(currentDateKey);
  }

// ! User Full Name
  Future<bool> saveUserFullName(userFullName) async {//work
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userFullNameKey, userFullName);
  }

  Future<String?> getUserFullName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userFullNameKey);
  }

  Future<bool> removeUserFullName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userFullNameKey);
  }

// ! User DeviceID
  Future<bool> saveUserDeviceId(userDeviceId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userDeviceIdKey, userDeviceId);
  }

  Future<String?> getUserDeviceId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userDeviceIdKey);
  }

  Future<bool> removeUserDeviceId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userDeviceIdKey);
  }

// ! User DeviceID
  Future<bool> saveUserDeviceName(userDeviceName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userDeviceNameKey, userDeviceName);
  }

  Future<String?> getUserDeviceName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userDeviceNameKey);
  }

  Future<bool> removeUserDeviceName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userDeviceNameKey);
  }

// ! User DeviceID
  Future<bool> saveUserDeviceOSType(userDeviceOSType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        userDeviceOSTypeKey, userDeviceOSType);
  }

  Future<String?> getUserDeviceOSType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userDeviceOSTypeKey);
  }

  Future<bool> removeUserDeviceOSType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userDeviceOSTypeKey);
  }

// ! User DeviceID
  Future<bool> saveUserJWToken(userJWtToken) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userJWtTokenKey, userJWtToken);
  }

  Future<String?> getUserJWtToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userJWtTokenKey);
  }

  Future<bool> removeUserJWtToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userJWtTokenKey);
  }

// ! User saveFcmToken
  Future<bool> saveFcmToken(fcmToken) async {//work
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(fcmTokenKey, fcmToken);
  }

  Future<String?> getFcmToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(fcmTokenKey);
  }

  Future<bool> removeFcmToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(fcmTokenKey);
  }

  // is Data Ecrypted
  Future<bool> setIsDataEncrypted(bool firsttime) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(isDataEncrypted, firsttime);
  }

  Future<bool?> getIsDataEncrypted() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isDataEncrypted);
  }

// ! User Customer ID
  Future<bool> saveCustomerId(customerId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(customerIdKey, customerId);
  }

  Future<String?> getCustomerId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(customerIdKey);
  }

  Future<bool> removeCustomerId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(customerIdKey);
  }

// ! User First time oepn
  Future<bool> saveFirstTimeAppOpen(firstTimeOpenApp) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(
        firstTimeAppOpenKey, firstTimeOpenApp);
  }

  Future<bool?> getFirstTimeAppOpen() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(firstTimeAppOpenKey);
  }

  Future<bool> removeFirstTimeAppOpen() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(firstTimeAppOpenKey);
  }

// ! stripeCustomerEmpheralKey
  Future<bool> saveStripeCustomerEmpheralKey(stripeCustomerEmpheralKey) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        stripeCustomerEmpheralKey, stripeCustomerEmpheralKey);
  }

  Future<String?> getStripeCustomerEmpheralKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(stripeCustomerEmpheralKey);
  }

  Future<bool> removeStripeCustomerEmpheralKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(stripeCustomerEmpheralKey);
  }

// ! stripeCustomerEmpheralKey
  Future<bool> saveStripeCustomerContextId(stripeCustomerContextId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        stripeCustomerContextIdKey, stripeCustomerContextId);
  }

  Future<String?> getStripeCustomerContextId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(stripeCustomerContextIdKey);
  }

  Future<bool> removeStripeCustomerContextId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(stripeCustomerContextIdKey);
  }

// ! stripeCustomerEmpheralKey
  Future<bool> saveStripePublishable(stripePublishableKey) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        stripePublishableKey, stripePublishableKey);
  }

  Future<String?> getStripePublishable() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(stripePublishableKey);
  }

  Future<bool> removeStripePublishable() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(stripePublishableKey);
  }

// ! Display Unit
  Future<bool> saveDisplayUnit(displayUnit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(displayUnitKey, displayUnit);
  }

  Future<int?> getDisplayUnit() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(displayUnitKey);
  }

  Future<bool> removeDisplayUnit() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(displayUnitKey);
  }

// ! Temperature Unit
  Future<bool> saveTemperatureUnit(temperatureUnit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(temperatureUnitKey, temperatureUnit);
  }

  Future<int?> getTemperatureUnit() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(temperatureUnitKey);
  }

  Future<bool> removeTemperatureUnit() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(temperatureUnitKey);
  }

// ! Mode
  Future<bool> saveMode(mode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(modeKey, mode);
  }

  Future<int?> getMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(modeKey);
  }

  Future<bool> removeMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(modeKey);
  }

// ! REMEMBER ME
  Future<bool> saveRememberMe(mode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(rememberMekey, mode);
  }

  Future<bool?> getRememberMe() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(rememberMekey);
  }

  Future<bool> removeRememberMe() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(rememberMekey);
  }

  // isFirstTimeFcmNotificationOpen
  Future<bool> saveIsFirstTimeFcmNotification(bool isMailExist) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(isFirstTimeFCMOpen, isMailExist);
  }

  Future<bool?> getIsFirstTimeFcmNotification() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isFirstTimeFCMOpen);
  }

  Future<bool> removeIsFirstTimeFcmNotification() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(isFirstTimeFCMOpen);
  }

  // fcmNotificationUniqueIdList
  Future<bool> saveFcmNotificationUniqueIdList(
      List<String> notificationUniqueId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setStringList(
        fcmNotificationUniqueIdList, notificationUniqueId);
  }

  Future<List<String>?> getFcmNotificationUniqueIdList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(fcmNotificationUniqueIdList);
  }

  Future<bool> removeFcmNotificationUniqueIdList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(fcmNotificationUniqueIdList);
  }
}
