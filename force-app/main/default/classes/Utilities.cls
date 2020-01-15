public class Utilities {

//SYSTEMIZE STRING
//Converts a string to a "systemized" string:
//    uppercased, trimmed, duplicate whitespaces removed, whitespaces converted to underscores, non-word characters removed
public static string SystemizeString(string p){
    string s = p != null ? p : '';
    s = s.trim().replaceAll('\\s{2,}',' '); //Trim and remove duplicate whitespaces with a single space
    s = s.replaceAll('[^A-z^0-9^\\s]',''); //Replace everything that is not a letter or a number and not a whitespace with BLANK
    s = s.trim().replaceAll('\\s','_').toUpperCase(); //Trim again, and replace whitespaces with underscores and uppercase the whole thing
    return s;
}
}