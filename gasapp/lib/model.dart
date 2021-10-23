class Userlogin {
  final String fname;
  final String lname;
  final String contactnum;
  final String username;
  final String userid;
  final String Consumer_id;
  final String order_id;
  // ignore: non_constant_identifier_names
  final String product_name;
  // ignore: non_constant_identifier_names
  final String product_price;
  final String status;
  final String type;
  final String start_time;
  final String orderStatus;
  final String path;
  final String consumer_lat;
  final String consumer_longh;
  final String longhi;
  final String lat;
  final String consumer_number;
  final String quantity;
  final String total;
  final String day;
  final String date;
  final String monthonly;
  final String paymentStatus;
  // ignore: non_constant_identifier_names
  Userlogin(
      {this.monthonly,
      this.paymentStatus,
      this.start_time,
      this.longhi,
      this.lat,
      this.consumer_longh,
      this.consumer_lat,
      this.Consumer_id,
      this.orderStatus,
      this.path,
      this.order_id,
      this.fname,
      this.lname,
      this.contactnum,
      this.username,
      this.userid,
      this.product_name,
      this.product_price,
      this.status,
      this.type,
      this.consumer_number,
      this.quantity,
      this.total,
      this.day,
      this.date});

  factory Userlogin.fromJson(Map<String, dynamic> json) {
    return Userlogin(
        fname: json['fname'],
        lname: json['lname'],
        contactnum: json['contactnum'],
        username: json['username'],
        userid: json['userid'],
        product_name: json['product_name'],
        product_price: json['product_price'],
        status: json['status'],
        type: json['type'],
        order_id: json['order_id'],
        path: json['path'],
        orderStatus: json['orderStatus'],
        Consumer_id: json['Consumer_id'],
        consumer_longh: json['consumer_longh'],
        consumer_lat: json['consumer_lat'],
        longhi: json['longhi'],
        lat: json['lat'],
        consumer_number: json['consumer_number'],
        quantity: json['quantity'],
        total: json['total'],
        day: json['day'],
        date: json['date'],
        start_time: json['start_time'],
        monthonly: json['monthonly'],
        paymentStatus: json['paymentStatus']);
  }

  Map<String, dynamic> toJson() => {
        'fname': fname,
        'lname': lname,
        'contactnum': contactnum,
        'username': username,
        'userid': userid,
        'product_name': product_name,
        'product_price': product_price,
        'status': status,
        'order_id': order_id,
        'path': path,
        'orderStatus': orderStatus,
        'Consumer_id': Consumer_id,
        'consumer_longh': consumer_longh,
        'consumer_lat': consumer_lat,
        'longhi': longhi,
        'lat': lat,
        'consumer_number': consumer_number,
        'quantity': quantity,
        'total': total,
        'start_time': start_time,
        'day': day,
        'date': date,
        'monthonly': monthonly,
        'paymentStatus': paymentStatus
      };
}
