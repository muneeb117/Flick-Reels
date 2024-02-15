import"package:flutter/material.dart";
buildProfile(String profilePhoto) {
  return SizedBox(
    height: 60,
    width: 60,
    child: Stack(
      children: [
        Positioned(
            left: 5,
            child: Container(
              width: 45,
              height: 45,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ))
      ],
    ),
  );
}
