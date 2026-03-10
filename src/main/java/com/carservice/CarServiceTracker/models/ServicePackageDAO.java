package com.carservice.CarServiceTracker.models;

import com.carservice.CarServiceTracker.utils.FileHandler;
import java.util.ArrayList;
import java.util.List;

public class ServicePackageDAO {
    private static final String FILE_NAME = "service_packages.txt";

    public ServicePackageDAO() {
    }

    public List<ServicePackage> findAll() {
        List<ServicePackage> packages = new ArrayList<>();
        List<String> lines = FileHandler.readFile(FILE_NAME);
        for (String line : lines) {
            String[] parts = line.split("\\|", -1);
            if (parts.length >= 5) {
                packages.add(new ServicePackage(parts[0], parts[1], parts[2], parts[3], parts[4]));
            } else if (parts.length == 4) {
                packages.add(new ServicePackage(parts[0], parts[1], parts[2], parts[3], ""));
            } else if (parts.length == 3) {
                packages.add(new ServicePackage(parts[0], parts[1], parts[2], "", ""));
            }
        }
        return packages;
    }

    public ServicePackage findById(String id) {
        for (ServicePackage pkg : findAll()) {
            if (pkg.getId().equals(id)) {
                return pkg;
            }
        }
        return null;
    }

    public void save(ServicePackage pkg) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        String data = toLine(pkg);
        lines.add(data);
        FileHandler.writeFile(FILE_NAME, lines);
    }

    public void update(ServicePackage updated) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<String> newLines = new ArrayList<>();
        for (String line : lines) {
            if (line.startsWith(updated.getId() + "|")) {
                newLines.add(toLine(updated));
            } else {
                newLines.add(line);
            }
        }
        FileHandler.writeFile(FILE_NAME, newLines);
    }

    public void delete(String id) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<String> toKeep = new ArrayList<>();
        for (String line : lines) {
            if (!line.startsWith(id + "|")) {
                toKeep.add(line);
            }
        }
        FileHandler.writeFile(FILE_NAME, toKeep);
    }

    public String generateId() {
        return "PKG" + System.currentTimeMillis();
    }

    private String toLine(ServicePackage pkg) {
        String desc = (pkg.getDescription() != null) ? pkg.getDescription() : "";
        String price = (pkg.getPrice() != null) ? pkg.getPrice() : "";
        return pkg.getId() + "|" + pkg.getCategory() + "|" + pkg.getName() + "|" + desc + "|" + price;
    }
}
