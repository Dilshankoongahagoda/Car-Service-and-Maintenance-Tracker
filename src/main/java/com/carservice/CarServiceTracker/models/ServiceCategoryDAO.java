package com.carservice.CarServiceTracker.models;

import com.carservice.CarServiceTracker.utils.FileHandler;
import java.util.ArrayList;
import java.util.List;

public class ServiceCategoryDAO {
    private static final String FILE_NAME = "service_categories.txt";

    public ServiceCategoryDAO() {
    }

    public List<ServiceCategory> findAll() {
        List<ServiceCategory> categories = new ArrayList<>();
        List<String> lines = FileHandler.readFile(FILE_NAME);
        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length >= 3) {
                categories.add(new ServiceCategory(parts[0], parts[1], parts[2]));
            }
        }
        return categories;
    }

    public ServiceCategory findByName(String name) {
        for (ServiceCategory c : findAll()) {
            if (c.getName().equalsIgnoreCase(name)) {
                return c;
            }
        }
        return null;
    }

    public void save(ServiceCategory category) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        String data = category.getName() + "|" + category.getDescription() + "|" + category.getStartingPrice();
        lines.add(data);
        FileHandler.writeFile(FILE_NAME, lines);
    }
}
