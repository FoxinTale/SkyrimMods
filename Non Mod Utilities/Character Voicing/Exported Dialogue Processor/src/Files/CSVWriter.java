package Files;

import java.io.FileWriter;
import java.io.IOException;

public class CSVWriter {

    public static void write(String outputFileName) throws IOException {
        FileWriter csvWriter = new FileWriter(outputFileName + ".csv");
    }
}
