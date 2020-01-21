class Events {
  String eventName;
  String image;
  String summary;
  List<Events> event;

  Events({this.eventName, this.image, this.summary});
}

List<Events> events = [
  Events(
    eventName: "My First Event",
    image: 'assets/images/image_1.jpeg',
    summary: "Let's GO!",
  ),
  Events(
    eventName: "Get Together At Last",
    image: 'assets/images/image_2.jpeg',
    summary: "It's been too long guys! We need to meet up, so fill in your location and availability and we'll get it sorted!",
  ),
  Events(
    eventName: "The Boyz are BACK",
    image: 'assets/images/image_3.jpeg',
    summary: "Guess who's back? back again...... The boyz are back, tell a friend",
  ),
  Events(
    eventName: "Another EVENT!!!",
    image: 'assets/images/image_5.jpg',
    summary: "JGDJS sfjsndgssm sc sjf k gfhs djgnsdjghd fghd f ksdfgh dk j",
  ),
  Events(
    eventName: "OMG Another event!!!!1",
    image: 'assets/images/image_4.jpeg',
    summary: "I can't believe how many events there are!",
  ),
];
