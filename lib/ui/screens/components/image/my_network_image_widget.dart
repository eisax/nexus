
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:nexus/utils/dimensions.dart';
// import 'package:nexus/utils/my_color.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class MyNetworkImageWidget extends StatelessWidget {
//   final String imageUrl;
//   final double? height;
//   final double? width;
//   final double radius;
//   final BoxFit boxFit;
//   final BorderRadiusGeometry? borderRadius;
//   final Widget? errorWidget;
//   const MyNetworkImageWidget({
//     super.key,
//     required this.imageUrl,
//     this.height,
//     this.width,
//     this.borderRadius,
//     this.radius = 5,
//     this.boxFit = BoxFit.cover,
//     this.errorWidget,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return imageUrl != ''
//         ? CachedNetworkImage(
//             imageUrl: imageUrl.toString(),
//             imageBuilder: (context, imageProvider) {
//               return Container(
//                 height: height,
//                 width: width,
//                 decoration: BoxDecoration(
//                   borderRadius: borderRadius ?? BorderRadius.circular(radius),
//                   image: DecorationImage(image: imageProvider, fit: boxFit),
//                 ),
//               );
//             },
//             placeholder: (context, url) => SizedBox(
//               height: height,
//               width: width,
//               child: ClipRRect(
//                   borderRadius: borderRadius ?? BorderRadius.circular(Dimensions.defaultRadius * 5),
//                   child: Center(
//                     child: SpinKitFadingCube(
//                       color: MyColor.primaryColor.withOpacity(0.3),
//                       size: Dimensions.space20,
//                     ),
//                   )),
//             ),
//             errorWidget: (context, url, error) => SizedBox(
//               height: height,
//               width: width,
//               child: ClipRRect(
//                 borderRadius: borderRadius ?? BorderRadius.circular(Dimensions.defaultRadius * 5),
//                 child: Center(
//                   child: Icon(
//                     Icons.image,
//                     color: MyColor.colorGrey.withOpacity(0.5),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         : errorWidget ??
//             SizedBox(
//               height: height,
//               width: width,
//               child: ClipRRect(
//                 borderRadius: borderRadius ?? BorderRadius.circular(Dimensions.defaultRadius * 5),
//                 child: Center(
//                   child: Icon(
//                     Icons.image,
//                     color: MyColor.colorGrey.withOpacity(0.5),
//                   ),
//                 ),
//               ),
//             );
//   }
// }
