// model/Field.java
package model;

public class Field {
    private int fieldId;
    private int venueId;
    private int sportTypeId;
    private String fieldName;

    public int getFieldId() { return fieldId; }
    public void setFieldId(int fieldId) { this.fieldId = fieldId; }
    public int getVenueId() { return venueId; }
    public void setVenueId(int venueId) { this.venueId = venueId; }
    public int getSportTypeId() { return sportTypeId; }
    public void setSportTypeId(int sportTypeId) { this.sportTypeId = sportTypeId; }
    public String getFieldName() { return fieldName; }
    public void setFieldName(String fieldName) { this.fieldName = fieldName; }
}