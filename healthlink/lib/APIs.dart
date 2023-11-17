class API {
  static const String baseURL =
      'http://10.0.2.2:5000/api/v1/'; // Replace with your backend URL
  static const String userEndpoint = '/user'; // Example user endpoint

  static get getBaseURL => API.baseURL;
}
