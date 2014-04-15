//Can't user java.util.StringTokenizer because of GWT
package ballmerpeak.turtlenet.shared;

public class Tokenizer {
    String[] tokens;
    int i = 0;
    
    public Tokenizer (String s, char c) {
        tokens = new String[s.count(c)];
    }
    
    public String nextToken () {
        return tokens[i++];
    }
    
    public boolean hasMoreTokens () {
        return i < tokens.length;
    }
    
    public int countTokens () {
        return tokens.length;
    }
}
