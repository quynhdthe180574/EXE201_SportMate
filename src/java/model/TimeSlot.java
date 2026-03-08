package model;

import java.sql.Time;

public class TimeSlot {
    private int slotId;
    private Time startTime;
    private Time endTime;

    // Constructor mặc định (nên có)
    public TimeSlot() {
    }

    // Constructor đầy đủ (tùy chọn, tiện khi tạo object)
    public TimeSlot(int slotId, Time startTime, Time endTime) {
        this.slotId = slotId;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    // Getters và Setters
    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    // Optional: override toString để dễ debug
    @Override
    public String toString() {
        return "TimeSlot{" +
                "slotId=" + slotId +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                '}';
    }
}