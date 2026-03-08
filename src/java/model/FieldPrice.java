package model;

import java.math.BigDecimal;

public class FieldPrice {
    private int fieldPriceId;
    private int fieldId;
    private int slotId;
    private BigDecimal price;

    public int getFieldPriceId() { return fieldPriceId; }
    public void setFieldPriceId(int fieldPriceId) { this.fieldPriceId = fieldPriceId; }
    public int getFieldId() { return fieldId; }
    public void setFieldId(int fieldId) { this.fieldId = fieldId; }
    public int getSlotId() { return slotId; }
    public void setSlotId(int slotId) { this.slotId = slotId; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
}