import 'package:assosnation_app/services/models/post.dart';
import 'package:assosnation_app/services/models/action.dart';

class Association {
  final String name;
  final String description;
  final String mail;
  final String address;
  final String city;
  final String postalCode;
  final String banner;
  final String phone;
  final String president;
  final String type;

  final List<Post>? posts;
  final List<Action>? actions;

  Association(this.name, this.description, this.mail, this.address, this.city,
      this.postalCode, this.phone, this.banner, this.president, this.type,
      this.posts, this.actions);

}