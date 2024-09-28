class MyDefaultConnector {
  static dynamic connectorConfig = {
    'region': 'us-central1',
    'project': 'photo_uploader',
    'type': 'default',
  };

  MyDefaultConnector({required this.dataConnect});

  static MyDefaultConnector get instance {
    return MyDefaultConnector(
      dataConnect: _instanceForDataConnect(),
    );
  }

  static dynamic _instanceForDataConnect() {
    return {};
  }

  final dynamic dataConnect;
}
