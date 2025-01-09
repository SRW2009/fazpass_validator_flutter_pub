
class CrossDeviceData {
  final String merchantAppId;
  final String deviceReceive;
  final String deviceRequest;
  final String deviceIdReceive;
  final String deviceIdRequest;
  final String expired;
  final String status;
  final String? notificationId;
  final String? action;

  CrossDeviceData.fromData(Map data) :
        merchantAppId = data["merchant_app_id"] as String,
        deviceReceive = data["device_receive"] as String,
        deviceRequest = data["device_request"] as String,
        deviceIdReceive = data["device_id_receive"] as String,
        deviceIdRequest = data["device_id_request"] as String,
        expired = data["expired"] as String,
        status = data["status"] as String,
        notificationId = data["notification_id"] as String?,
        action = data["action"] as String?;
}