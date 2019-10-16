import 'dart:math';

List cars = [
  {
    "uid": 0,
    "car_name": "Mercedes W124",
    "car_img_path": "images/merc.jpg",
    "otherImg": [
      "images/merc1.jpg",
      "images/merc2.jpg",
      "images/merc3.jpg",
      "images/merc4.jpg"
    ],
    "car_description":
        "W124 is the Mercedes-Benz internal chassis-designation for the 1984/85 to 1995/96 version of the Mercedes-Benz E-Class, as well as the first generation to be officially referred to as E-Class. The W124 models replaced the W123 models after 1985 and were succeeded by the W210 E-Class after 1995."
  },
  {
    "uid": 1,
    "car_name": "Kia Rio",
    "car_img_path": "images/rio.jpg",
    "otherImg": [
      "images/rio1.jpg",
      "images/rio2.jpg",
      "images/rio3.jpg",
    ],
    "car_description":
        "The Kia Rio is a subcompact car produced by the South Korean manufacturer Kia Motors since November 1999 and now in its fourth generation. Body styles have included a three and five-door hatchback and four-door sedan, equipped with inline-four gasoline and diesel engines, and front-wheel drive."
  },
  {
    "uid": 2,
    "car_name": "Chevorlet Optra",
    "car_img_path": "images/optra.jpg",
    "otherImg": ["images/optra1.jpg", "images/optra2.jpg"],
    "car_description":
        "The Chevrolet Optra is an automotive nameplate used by the Chevrolet marque for two different compact car models, in the following markets: Daewoo Lacetti (2004-2013), in markets such as U.S.A, Colombia, Canada, Mexico, Japan and Southeast Asia."
  },
  {
    "uid": 3,
    "car_name": "Mercedes W140",
    "car_img_path": "images/w140.jpg",
    "otherImg": [
      "images/w1401.jpg",
      "images/w1402.jpg",
      "images/w1403.jpg",
      "images/w1404.jpg",
      "images/w1405.jpg"
    ],
    "car_description":
        "The Mercedes-Benz W140 is a series of flagship vehicles that were manufactured by the German automotive company Mercedes-Benz from 1991 to 1998"
  },
];

Random random = Random();
List names = [
  "Ossama Akram",
  "Reem Emam",
  "Noha Ehab",
  "Menna Emam",
  "Maryam Ehab",
  "Perrihane Amr",
  "Amr Akram",
  "Ahmed Abdelraouf",
  "Maggie Signaling",
  "Amr Talaat",
  "Eman Azzab",
];

List types = ["recieved", "sent"];

List history = List.generate(
    15,
    (index) => {
          "name": names[random.nextInt(10)],
          "date": "${random.nextInt(31).toString().padLeft(2, "0")}"
              "/${random.nextInt(12).toString().padLeft(2, "0")}/2019",
          "amount": "${random.nextInt(1000).toString()}KM",
          "type": types[random.nextInt(2)],
          "dp": "images/ossama1.jpg",
        });
