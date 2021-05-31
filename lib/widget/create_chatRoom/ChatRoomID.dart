class ChatRoomId {
  static String getID({String currentUser, String anotherUser}) {
    if (currentUser.substring(0, 1).codeUnitAt(0) >
        anotherUser.substring(0, 1).codeUnitAt(0)) {
      return "$anotherUser$currentUser";
    } else {
      return "$currentUser$anotherUser";
    }
  }
}