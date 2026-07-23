import java.io.*;
import java.util.ArrayList;
import java.util.Scanner;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static String startingString = "AileensGen_";
    public static String inputFileName = "dialogueExportAileensGenericDialogue.txt";
    public static String outputFileName = "Aileen";
//    public static String game = "overwatch";
//    public static String voice = "ow_dva";
//   public static String vocoder = "hifi";


    public static void main(String[] args) throws IOException {
        // pass the path to the file as a parameter
        File file = new File(inputFileName);

        String[] splitLine;
        String[] splitMood;
        String tempString;
        String fileName = "";
        String dialogueLine = "";
        String mood = "";

        FileWriter csvWriter = new FileWriter(outputFileName + ".csv");

        Scanner sc = new Scanner(file);
        ArrayList<String> fileLines = new ArrayList<>();
        ArrayList<String> outputLines = new ArrayList<>();

        while (sc.hasNextLine()){
            fileLines.add(sc.nextLine());
        }

        for(int i = 1; i < fileLines.size(); i++){
            splitLine = fileLines.get(i).split("\t");
            for(int j = 0; j < splitLine.length; j++){
                tempString = splitLine[j];
                if(tempString.contains(startingString) && !tempString.startsWith("Data")){
                    fileName = tempString;
                }
            }

            dialogueLine = splitLine[splitLine.length - 2];
            mood = splitLine[splitLine.length -1];
            splitMood = mood.split(" ");
//            outputLines.add(
//              game + "," + voice + "," + "\"" + dialogueLine + "\"" + "," + vocoder + "," + fileName + ".wav" + "\n"
//            );
            outputLines.add(
                    "\"" + dialogueLine + "\"" + "," + splitMood[0].trim() + "," + splitMood[1].trim() + "," + fileName + ".wav" + "\n"
            );
        }

   //     csvWriter.write("game_id,voice_id,text,vocoder,out_path" + "\n");
        csvWriter.write("text,mood,emotion_value,out_path" + "\n");
        for(int k = 0; k < outputLines.size(); k++){
            csvWriter.write(outputLines.get(k));
        }
        csvWriter.close();
    }
}

