package com.carservice.CarServiceTracker.models;

public class ServiceCategory {
    private String name;
    private String description;
    private String startingPrice;

    public ServiceCategory() {}

    public ServiceCategory(String name, String description, String startingPrice) {
        this.name = name;
        this.description = description;
        this.startingPrice = startingPrice;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStartingPrice() {
        return startingPrice;
    }

    public void setStartingPrice(String startingPrice) {
        this.startingPrice = startingPrice;
    }
}
