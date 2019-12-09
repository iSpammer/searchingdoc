import 'dart:math';

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
  },
);
