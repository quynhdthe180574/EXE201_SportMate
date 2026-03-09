package model;

import java.sql.Time;

public class Venue {
    private int venueId;
    private int userId;
    private String venueName;
    private int provinceId;
    private int districtId;
    private String addressDetail;
    private String description;
    private Time openTime;
    private Time closeTime;
    private String status;

    // Getter & Setter – PHẢI public và tên chuẩn
    public int getVenueId() { return venueId; }
    public void setVenueId(int venueId) { this.venueId = venueId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getVenueName() { return venueName; }
    public void setVenueName(String venueName) { this.venueName = venueName; }

    public int getProvinceId() { return provinceId; }
    public void setProvinceId(int provinceId) { this.provinceId = provinceId; }

    public int getDistrictId() { return districtId; }
    public void setDistrictId(int districtId) { this.districtId = districtId; }

    public String getAddressDetail() { return addressDetail; }
    public void setAddressDetail(String addressDetail) { this.addressDetail = addressDetail; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Time getOpenTime() { return openTime; }
    public void setOpenTime(Time openTime) { this.openTime = openTime; }

    public Time getCloseTime() { return closeTime; }
    public void setCloseTime(Time closeTime) { this.closeTime = closeTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // toString để debug – đã có trong JSP của bạn
    @Override
    public String toString() {
        return "Venue{" +
                "venueId=" + venueId +
                ", venueName='" + venueName + '\'' +
                ", addressDetail='" + addressDetail + '\'' +
                ", openTime=" + openTime +
                ", status='" + status + '\'' +
                '}';
    }
}