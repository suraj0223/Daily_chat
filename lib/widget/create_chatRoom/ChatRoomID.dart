class ChatRoomId {
  // final String user1;
  // final String user2;

  static String getID(String user1, String user2) {
      if (user1.substring(0, 1).codeUnitAt(0) >
        user2.substring(0, 1).codeUnitAt(0)) {
      return "$user2\_$user1";
    } else {
      return "$user1\_$user2";
    }
  }
}