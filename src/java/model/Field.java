package model;

import java.util.ArrayList;
import java.util.List;

public class Field {
    private int fieldId;
    private int venueId;
    private int sportTypeId;
    private String fieldName;
    private List<String> imageUrls = new ArrayList<>();  // <-- thêm dòng này

    public int getFieldId() { return fieldId; }
    public void setFieldId(int fieldId) { this.fieldId = fieldId; }
    public int getVenueId() { return venueId; }
    public void setVenueId(int venueId) { this.venueId = venueId; }
    public int getSportTypeId() { return sportTypeId; }
    public void setSportTypeId(int sportTypeId) { this.sportTypeId = sportTypeId; }
    public String getFieldName() { return fieldName; }
    public void setFieldName(String fieldName) { this.fieldName = fieldName; }

    public List<String> getImageUrls() { return imageUrls; }
    public void setImageUrls(List<String> imageUrls) { this.imageUrls = imageUrls; }
}