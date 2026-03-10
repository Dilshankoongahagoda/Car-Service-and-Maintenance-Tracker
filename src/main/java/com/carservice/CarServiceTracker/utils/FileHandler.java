package com.carservice.CarServiceTracker.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

public class FileHandler {
    // Determine the absolute path based on the current working directory
    private static final String DATA_DIR = "data/";

    /**
     * Reads all lines from a given file.
     * @param fileName The name of the file to read
     * @return A list of strings representing the lines in the file
     */
    public static List<String> readFile(String fileName) {
        List<String> lines = new ArrayList<>();
        File file = new File(DATA_DIR + fileName);
        
        if (!file.exists()) {
            return lines;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                // Ignore empty lines
                if (!line.trim().isEmpty()) {
                    lines.add(line);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading file: " + fileName);
            e.printStackTrace();
        }
        return lines;
    }

    /**
     * Writes all lines to a given file safely using locks.
     * @param fileName The name of the file to write to
     * @param lines The list of strings to write
     */
    public static synchronized void writeFile(String fileName, List<String> lines) {
        File dataDir = new File(DATA_DIR);
        if (!dataDir.exists()) {
            dataDir.mkdirs();
        }
        
        File file = new File(DATA_DIR + fileName);
        
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing to file: " + fileName);
            e.printStackTrace();
        }
    }

    /**
     * Creates a backup of the specified file.
     * @param fileName The name of the file to backup
     */
    public static void backupFile(String fileName) {
        File file = new File(DATA_DIR + fileName);
        if (file.exists()) {
            File backup = new File(DATA_DIR + fileName + ".bak");
            file.renameTo(backup);
        }
    }
}
