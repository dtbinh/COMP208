class Client {
    public static void main (String[] argv) {
        NetworkConnection connection    = new NetworkConnection("localhost");
        Thread            networkThread = new Thread(connection);
        Database          db            = new Database("./db");
        GUI               gui           = new GUI(db, connection);
        Thread            guiThread     = new Thread(gui);
        
        if (!Crypto.keysExist()) //move into GUI class
            Crypto.keyGen();
        
        networkThread.start(); //download new messages, wait 1 second, repeat
        guiThread.start();     //display content of DB, get user input, repeat
        
        while (gui.isRunning())
            while (connection.hasMessage())
                Parser.parse(Crypto.decrypt(connection.getMessage()), db);
        
        gui.close();
        connection.close();
        db.close();
    }
}