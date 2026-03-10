package com.carservice.CarServiceTracker.models;

public class ServicePackage {
    private String id;
    private String category;
    private String name;
    private String description;
    private String price;

    public ServicePackage() {}

    public ServicePackage(String id, String category, String name, String description, String price) {
        this.id = id;
        this.category = category;
        this.name = name;
        this.description = description;
        this.price = price;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPrice() { return price; }
    public void setPrice(String price) { this.price = price; }
}
