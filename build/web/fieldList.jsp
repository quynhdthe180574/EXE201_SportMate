<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="dao.FieldDao" %>
<%@page import="dao.FieldImageDAO" %>
<%@page import="model.FieldImage" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.sql.SQLException" %>
<%
    FieldDao fieldDao = new FieldDao();
    FieldImageDAO fieldImageDAO = new FieldImageDAO();
   
    // Pagination parameters
    int pageSize = 9;
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) currentPage = 1;
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
   
    // Search and filter parameters
    String keyword = request.getParameter("keyword");
    String sportTypeIdParam = request.getParameter("sportTypeId");
    String provinceIdParam = request.getParameter("provinceId");
    String districtIdParam = request.getParameter("districtId");
    String sortBy = request.getParameter("sortBy");
    String orderBy = request.getParameter("orderBy");
   
    // Parse filter values
    Integer sportTypeId = null;
    Integer provinceId = null;
    Integer districtId = null;
   
    if (sportTypeIdParam != null && !sportTypeIdParam.isEmpty()) {
        try {
            sportTypeId = Integer.parseInt(sportTypeIdParam);
        } catch (NumberFormatException e) {}
    }
   
    if (provinceIdParam != null && !provinceIdParam.isEmpty()) {
        try {
            provinceId = Integer.parseInt(provinceIdParam);
        } catch (NumberFormatException e) {}
    }
   
    if (districtIdParam != null && !districtIdParam.isEmpty()) {
        try {
            districtId = Integer.parseInt(districtIdParam);
        } catch (NumberFormatException e) {}
    }
   
    // Get multiple selected slot IDs
    String[] selectedSlotIds = request.getParameterValues("slotId");
    List<Integer> slotIdList = new ArrayList<>();
    if (selectedSlotIds != null && selectedSlotIds.length > 0) {
        for (String slotId : selectedSlotIds) {
            try {
                slotIdList.add(Integer.parseInt(slotId));
                System.out.println("DEBUG: Selected slotId = " + slotId);
            } catch (NumberFormatException e) {}
        }
    }
   
    // Date and slot parameters
    String bookingDateParam = request.getParameter("bookingDate");
    java.sql.Date bookingDate = null;
   
    // Parse booking date
    if (bookingDateParam != null && !bookingDateParam.isEmpty()) {
        try {
            bookingDate = java.sql.Date.valueOf(bookingDateParam);
        } catch (IllegalArgumentException e) {
            // Use today's date if invalid
            bookingDate = new java.sql.Date(System.currentTimeMillis());
        }
    } else {
        // Default to today
        bookingDate = new java.sql.Date(System.currentTimeMillis());
    }
   
    // Determine if searching for available fields or all fields
    boolean searchingAvailable = slotIdList.size() > 0 && bookingDate != null;
   
    // Default sort
    if (sortBy == null || sortBy.isEmpty()) {
        sortBy = "AVG(r.rating)";
    }
    if (orderBy == null || orderBy.isEmpty()) {
        orderBy = "DESC";
    }
   
    // Fetch data
    List<Map<String, Object>> fields = null;
    List<Map<String, Object>> provinces = null;
    List<Map<String, Object>> sportTypes = null;
    List<Map<String, Object>> districts = null;
    List<Map<String, Object>> timeSlots = null;
    int totalFields = 0;
    int totalPages = 1;
    String errorMessage = null;
   
    try {
        // Lấy danh sách tỉnh
        provinces = fieldDao.getProvinces();
    } catch (SQLException e) {
        System.err.println("Lỗi lấy danh sách tỉnh: " + e.getMessage());
    }
   
    try {
        // Lấy danh sách quận theo tỉnh
        if (provinceId != null) {
            districts = fieldDao.getDistricts(provinceId);
        } else {
            districts = fieldDao.getDistricts(null);
        }
    } catch (SQLException e) {
        System.err.println("Lỗi lấy danh sách quận: " + e.getMessage());
    }
   
    try {
        // Lấy danh sách môn thể thao
        sportTypes = fieldDao.getSportTypes();
    } catch (SQLException e) {
        System.err.println("Lỗi lấy danh sách môn thể thao: " + e.getMessage());
    }
   
    try {
        // Lấy danh sách khung giờ (ĐỦ các slot)
        timeSlots = fieldDao.getTimeSlots();
        System.out.println("DEBUG: Retrieved " + (timeSlots != null ? timeSlots.size() : 0) + " timeSlots from database");
    } catch (SQLException e) {
        System.err.println("Lỗi lấy danh sách khung giờ: " + e.getMessage());
    }
   
    try {
        System.out.println("DEBUG: searchingAvailable=" + searchingAvailable + ", selectedSlots=" + slotIdList.size() + ", bookingDate=" + bookingDate);
       
        // Nếu có slot IDs thì lấy sân trống, ngược lại lấy tất cả sân
        if (searchingAvailable && slotIdList.size() > 0) {
            System.out.println("DEBUG: Calling getAvailableFields with " + slotIdList.size() + " slots");
            
            // Lấy từng slot một và merge kết quả
            for (Integer slotId : slotIdList) {
                totalFields = fieldDao.getTotalAvailableFields(keyword, provinceId, districtId, sportTypeId,
                                                               null, null, bookingDate, slotId);
            }
            totalPages = (totalFields + pageSize - 1) / pageSize;
            if (totalPages < 1) totalPages = 1;
           
            // Lấy danh sách sân trống cho slot đầu tiên (để phân trang)
            if (slotIdList.size() > 0) {
                Integer firstSlotId = slotIdList.get(0);
                fields = fieldDao.getAvailableFields(keyword, provinceId, districtId, sportTypeId,
                                                     null, null, bookingDate, firstSlotId,
                                                     currentPage, pageSize, sortBy, orderBy);
            }
        } else {
            System.out.println("DEBUG: Calling searchAndFilterFields (no specific slot selected)");
            // Lấy tất cả sân (không filter theo ngày/giờ)
            totalFields = fieldDao.getTotalFiltered(keyword, provinceId, districtId, sportTypeId, null, null);
            totalPages = (totalFields + pageSize - 1) / pageSize;
            if (totalPages < 1) totalPages = 1;
           
            // Lấy danh sách sân
            fields = fieldDao.searchAndFilterFields(keyword, provinceId, districtId, sportTypeId,
                                                    null, null, currentPage, pageSize, sortBy, orderBy);
        }
    } catch (SQLException e) {
        errorMessage = "Lỗi khi tải danh sách sân: " + e.getMessage();
        System.err.println(errorMessage);
        e.printStackTrace();
        fields = new java.util.ArrayList<>();
    }
    
    // Build query string for pagination
    StringBuilder queryString = new StringBuilder();
    if (keyword != null && !keyword.isEmpty()) {
        queryString.append("&keyword=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));
    }
    if (sportTypeId != null) {
        queryString.append("&sportTypeId=").append(sportTypeId);
    }
    if (provinceId != null) {
        queryString.append("&provinceId=").append(provinceId);
    }
    if (districtId != null) {
        queryString.append("&districtId=").append(districtId);
    }
    queryString.append("&bookingDate=").append(bookingDateParam != null ? bookingDateParam : new java.text.SimpleDateFormat("yyyy-MM-dd").format(bookingDate));
    for (Integer slotId : slotIdList) {
        queryString.append("&slotId=").append(slotId);
    }
    queryString.append("&sortBy=").append(java.net.URLEncoder.encode(sortBy, "UTF-8"));
    queryString.append("&orderBy=").append(orderBy);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Danh sách sân thể thao - SportCourt</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
        rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
        rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#13ec6d",
                        "background-light": "#f6f8f7",
                        "background-dark": "#102218",
                    },
                    fontFamily: {
                        "display": ["Inter"]
                    },
                    borderRadius: {
                        "DEFAULT": "1rem",
                        "lg": "2rem",
                        "xl": "3rem",
                        "full": "9999px"
                    },
                },
            },
        }
    </script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        .custom-scrollbar::-webkit-scrollbar {
            width: 6px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
            background: transparent;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: #e2e8f0;
            border-radius: 10px;
        }
        .court-card:hover {
            transform: translateY(-4px);
            transition: all 0.3s ease;
        }
        .btn-glow:hover {
            box-shadow: 0 0 15px rgba(19, 236, 109, 0.5);
        }
        input[type="date"]::-webkit-calendar-picker-indicator {
            cursor: pointer;
            filter: invert(0.5);
        }
    </style>
   
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Debug: Log current URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            console.log('Current URL parameters:', {
                bookingDate: urlParams.get('bookingDate'),
                slotIds: urlParams.getAll('slotId')
            });
        });
    </script>
</head>
<body class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 min-h-screen">
    <%@ include file="header.jsp" %>
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Search Section -->
        <div class="mb-10">
            <h2 class="text-3xl font-black text-slate-900 dark:text-white mb-6">Danh sách sân thể thao</h2>
            <form method="get" class="flex flex-col md:flex-row gap-4 max-w-5xl">
                <div class="relative flex-1">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <span class="material-symbols-outlined text-slate-400">search</span>
                    </div>
                    <input name="keyword" value="<%= keyword != null ? keyword : "" %>" class="block w-full pl-12 pr-4 py-4 bg-white dark:bg-slate-900 border-none rounded-2xl shadow-sm ring-1 ring-slate-200 dark:ring-slate-800 focus:ring-2 focus:ring-primary text-lg" placeholder="Tìm theo tên sân hoặc khu vực..." type="text" />
                </div>
                <button type="submit" class="px-8 py-4 bg-primary text-slate-900 font-bold rounded-2xl hover:opacity-90 shadow-lg shadow-primary/20 transition-all">Tìm kiếm</button>
            </form>
        </div>
        <!-- Error Message -->
        <% if (errorMessage != null) { %>
        <div class="mb-6 p-4 bg-red-100 dark:bg-red-900/30 border border-red-300 dark:border-red-800 rounded-2xl text-red-700 dark:text-red-300">
            <%= errorMessage %>
        </div>
        <% } %>
        <div class="flex flex-col lg:flex-row gap-8">
            <!-- Sidebar Filters -->
            <aside class="w-full lg:w-72 flex-shrink-0">
                <div class="bg-white dark:bg-slate-900 rounded-2xl p-6 shadow-sm border border-slate-100 dark:border-slate-800 sticky top-24 max-h-[calc(100vh-8rem)] overflow-y-auto custom-scrollbar">
                    <form method="get">
                        <!-- Keep search params -->
                        <input type="hidden" name="keyword" value="<%= keyword != null ? keyword : "" %>" />
                        <input type="hidden" name="sortBy" value="<%= sortBy %>" />
                        <input type="hidden" name="orderBy" value="<%= orderBy %>" />
                       
                        <div class="flex items-center justify-between mb-6">
                            <h3 class="font-bold text-lg flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary">filter_list</span>
                                Bộ lọc
                            </h3>
                            <a href="fieldList.jsp" class="text-xs text-slate-400 hover:text-primary underline">Xóa lọc</a>
                        </div>
                        <!-- Date Picker for Booking -->
                        <div class="mb-8">
                            <p class="font-bold text-sm mb-4 uppercase tracking-wider text-slate-500">Chọn ngày đặt sân</p>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <span class="material-symbols-outlined text-slate-400 text-lg">calendar_month</span>
                                </div>
                                <input name="bookingDate" value="<%= bookingDateParam != null ? bookingDateParam : new java.text.SimpleDateFormat("yyyy-MM-dd").format(bookingDate) %>"
                                       type="date" class="w-full pl-10 pr-4 py-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-primary" />
                            </div>
                        </div>
                        <!-- Time Slot Selection - Multiple Checkboxes -->
                        <div class="mb-8">
                            <p class="font-bold text-sm mb-4 uppercase tracking-wider text-slate-500">Giờ trống (chọn nhiều)</p>
                            <div class="space-y-3 mb-4 max-h-64 overflow-y-auto custom-scrollbar">
                                <%
                                    if (timeSlots != null && !timeSlots.isEmpty()) {
                                        for (Map<String, Object> slot : timeSlots) {
                                            Integer slotId = (Integer) slot.get("slotId");
                                            // Convert java.sql.Time to String
                                            String startTime = "";
                                            String endTime = "";
                                            
                                            Object startTimeObj = slot.get("startTime");
                                            Object endTimeObj = slot.get("endTime");
                                            
                                            if (startTimeObj != null) {
                                                if (startTimeObj instanceof java.sql.Time) {
                                                    startTime = startTimeObj.toString();
                                                } else {
                                                    startTime = (String) startTimeObj;
                                                }
                                            }
                                            
                                            if (endTimeObj != null) {
                                                if (endTimeObj instanceof java.sql.Time) {
                                                    endTime = endTimeObj.toString();
                                                } else {
                                                    endTime = (String) endTimeObj;
                                                }
                                            }
                                            
                                            boolean isChecked = slotIdList.contains(slotId);
                                %>
                                <label class="flex items-center gap-3 cursor-pointer group p-2 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
                                    <input name="slotId" value="<%= slotId %>" type="checkbox" class="w-5 h-5 border-slate-300 rounded text-primary focus:ring-primary"
                                           <%= isChecked ? "checked" : "" %> />
                                    <div class="flex flex-col flex-1">
                                        <span class="text-sm group-hover:text-primary transition-colors"><%= startTime %> - <%= endTime %></span>
                                    </div>
                                </label>
                                <%
                                        }
                                    } else {
                                %>
                                <p class="text-sm text-slate-400">Không có khung giờ</p>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                       
                        <!-- Sport Type Filter -->
                        <div class="mb-8">
                            <p class="font-bold text-sm mb-4 uppercase tracking-wider text-slate-500">Loại sân</p>
                            <div class="space-y-3">
                                <%
                                    if (sportTypes != null) {
                                        for (Map<String, Object> sport : sportTypes) {
                                            int id = (Integer) sport.get("sportTypeId");
                                            String name = (String) sport.get("sportName");
                                            boolean checked = sportTypeId != null && sportTypeId == id;
                                %>
                                <label class="flex items-center gap-3 cursor-pointer group">
                                    <input name="sportTypeId" value="<%= id %>" class="w-5 h-5 rounded border-slate-300 text-primary focus:ring-primary" type="checkbox" <%= checked ? "checked" : "" %> />
                                    <span class="text-sm group-hover:text-primary transition-colors"><%= name %></span>
                                </label>
                                <%
                                        }
                                    }
                                %>
                            </div>
                        </div>
                        <!-- District Filter -->
                        <div class="mb-8">
                            <p class="font-bold text-sm mb-4 uppercase tracking-wider text-slate-500">Khu vực</p>
                            <select name="provinceId" onchange="this.form.submit();" class="w-full bg-background-light dark:bg-slate-800 border-none rounded-xl text-sm focus:ring-primary mb-3">
                                <option value="">Tất cả tỉnh/thành</option>
                                <%
                                    if (provinces != null) {
                                        for (Map<String, Object> prov : provinces) {
                                            int id = (Integer) prov.get("provinceId");
                                            String name = (String) prov.get("provinceName");
                                            boolean selected = provinceId != null && provinceId == id;
                                %>
                                <option value="<%= id %>" <%= selected ? "selected" : "" %>><%= name %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <%
                                if (districts != null && !districts.isEmpty()) {
                            %>
                            <select name="districtId" class="w-full bg-background-light dark:bg-slate-800 border-none rounded-xl text-sm focus:ring-primary">
                                <option value="">Tất cả quận/huyện</option>
                                <%
                                    for (Map<String, Object> dist : districts) {
                                        int id = (Integer) dist.get("districtId");
                                        String name = (String) dist.get("districtName");
                                        boolean selected = districtId != null && districtId == id;
                                %>
                                <option value="<%= id %>" <%= selected ? "selected" : "" %>><%= name %></option>
                                <%
                                    }
                                %>
                            </select>
                            <%
                                }
                            %>
                        </div>
                        <!-- Apply Filter Button -->
                        <button type="submit" class="w-full px-4 py-3 bg-primary text-slate-900 font-bold rounded-xl hover:opacity-90 transition-all flex items-center justify-center gap-2">
                            <span class="material-symbols-outlined text-lg">check</span>
                            Áp dụng lọc
                        </button>
                    </form>
                </div>
            </aside>
            <!-- Main Content -->
            <section class="flex-1">
                <!-- Result Count and Sorting -->
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
                    <div>
                        <p class="text-slate-500 text-sm">Hiển thị <span class="font-bold text-slate-900 dark:text-white"><%= fields != null ? fields.size() : 0 %></span> / <span class="font-bold text-slate-900 dark:text-white"><%= totalFields %></span> sân</p>
                        <%
                            if (searchingAvailable) {
                                String dateStr = new java.text.SimpleDateFormat("dd/MM/yyyy").format(bookingDate);
                                String slotStr = "";
                                if (slotIdList.size() > 0) {
                                    slotStr = "Khung giờ: ";
                                    for (int i = 0; i < slotIdList.size(); i++) {
                                        if (i > 0) slotStr += ", ";
                                        // Find corresponding timeslot info
                                        if (timeSlots != null) {
                                            for (Map<String, Object> slot : timeSlots) {
                                                Integer sid = (Integer) slot.get("slotId");
                                                if (sid.equals(slotIdList.get(i))) {
                                                    // Convert java.sql.Time to String
                                                    Object startTimeObj = slot.get("startTime");
                                                    Object endTimeObj = slot.get("endTime");
                                                    
                                                    String startTime = "";
                                                    String endTime = "";
                                                    
                                                    if (startTimeObj != null) {
                                                        if (startTimeObj instanceof java.sql.Time) {
                                                            startTime = startTimeObj.toString();
                                                        } else {
                                                            startTime = (String) startTimeObj;
                                                        }
                                                    }
                                                    
                                                    if (endTimeObj != null) {
                                                        if (endTimeObj instanceof java.sql.Time) {
                                                            endTime = endTimeObj.toString();
                                                        } else {
                                                            endTime = (String) endTimeObj;
                                                        }
                                                    }
                                                    
                                                    slotStr += startTime + "-" + endTime;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                        %>
                        <p class="text-xs text-slate-400 mt-1">📅 <%= dateStr %> <% if (!slotStr.isEmpty()) { %>| ⏰ <%= slotStr %><% } %></p>
                        <%
                            }
                        %>
                    </div>
                    <div class="flex items-center gap-3">
                        <span class="text-sm font-medium text-slate-500">Sắp xếp theo:</span>
                        <form method="get" class="flex bg-white dark:bg-slate-900 p-1 rounded-xl shadow-sm border border-slate-100 dark:border-slate-800" style="display: inline-flex;">
                            <input type="hidden" name="keyword" value="<%= keyword != null ? keyword : "" %>" />
                            <input type="hidden" name="sportTypeId" value="<%= sportTypeId != null ? sportTypeId : "" %>" />
                            <input type="hidden" name="provinceId" value="<%= provinceId != null ? provinceId : "" %>" />
                            <input type="hidden" name="districtId" value="<%= districtId != null ? districtId : "" %>" />
                           
                            <button type="submit" name="sortBy" value="MIN(fp.price)" class="px-4 py-1.5 text-xs font-bold <%= sortBy.contains("MIN(fp.price)") ? "bg-primary text-slate-900" : "text-slate-500 hover:text-slate-900 dark:hover:text-white" %> rounded-lg">Giá thấp nhất</button>
                            <button type="submit" name="sortBy" value="AVG(r.rating)" class="px-4 py-1.5 text-xs font-bold <%= sortBy.contains("AVG(r.rating)") ? "bg-primary text-slate-900" : "text-slate-500 hover:text-slate-900 dark:hover:text-white" %> rounded-lg">Đánh giá cao</button>
                        </form>
                    </div>
                </div>
                <!-- Court Cards Grid -->
                <%
                    if (fields != null && !fields.isEmpty()) {
                %>
                <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                    <%
                        for (int i = 0; i < fields.size(); i++) {
                            Map<String, Object> field = fields.get(i);
                            int fieldId = (Integer) field.get("fieldId");
                            String fieldName = (String) field.get("fieldName");
                            String venueName = (String) field.get("venueName");
                            String districtName = (String) field.get("districtName");
                            String provinceName = (String) field.get("provinceName");
                            Double avgRating = field.get("avgRating") != null ? (Double) field.get("avgRating") : 0.0;
                            
                            // Lấy giá từ slot đầu tiên
                            String priceDisplay = "Liên hệ";
                            try {
                                List<Map<String, Object>> prices = fieldDao.getFieldPrices(fieldId);
                                if (prices != null && !prices.isEmpty()) {
                                    Object priceObj = prices.get(0).get("price");
                                    if (priceObj != null) {
                                        double price = ((Number) priceObj).doubleValue();
                                        priceDisplay = String.format("%.0f.000đ", price / 1000);
                                    }
                                }
                            } catch (SQLException e) {
                                System.err.println("Lỗi lấy giá sân " + fieldId + ": " + e.getMessage());
                            }
                            
                            // Lấy ảnh từ database
                            List<FieldImage> images = fieldImageDAO.getImagesByField(fieldId);
                            String courtImage = "";
                            if (images != null && !images.isEmpty()) {
                                courtImage = images.get(0).getImageUrl();
                            } else {
                                // Fallback placeholder images nếu không có ảnh trong database
                                String[] courtImages = {
                                    "https://lh3.googleusercontent.com/aida-public/AB6AXuBqpghBbuxLm1R5cRO2IQ_lWLvBT2X1ubp06pwpqtzPBSkMR7-xyTli9yzV0OTpLForPzFBNHMTk-VFW9rc6d529yHDPKgrPPaIPLc_iiJPUtQ_YUGzceI6r09ZN02aoNa1dQr5nyYSJooaCiHVqxuXRfQK6lgu_r8KJJAbtzzaWL72l5r9_5qLJqRqpTZlKMDQ77_MG-NI38aGk-x-lBErzMisc4Nib4VwNnneDUGYvuBz3EAZztloqKD35UqLds5FD4gsisjNMbI",
                                    "https://lh3.googleusercontent.com/aida-public/AB6AXuD8rHsAA9O8SzRy9JNCa7FVjix65ZUVDDDVL-btyC4yvNkwRT9LuZsMwUuObvbrU6im_V9O1jvgCbnPIbdYeSWOaKNySzQVxEb4PWTZxWFRIHDijkQOWVux39_DDyoTnDxyw0PQaYjd0zcGVCrudBO90w0L1sGlv5Znh_NSE0jdvy7Fc8DoUpWOrOLPlihjk3zA2z2pDravTBOLddRyTvct6hsbvXiKETa8VKXxU0cVd5Yqs_Ok12vlvEUTG0eWh12I0b2aZMx2WbQ",
                                    "https://lh3.googleusercontent.com/aida-public/AB6AXuCym63_UDsvodoGM3q4YTkg2QRZ-ySyJYpOjjqhAZG1uXp66MV8YNn_EmRhLmNLOUAXHGt85ofQpavEeToqVErDiVjZ4GOn35_jCBzeE8TpO5F-PSmMbuqMFBanIN6mc6Sem5TRXEVjqqcFIK4x9MmLkKzB048RG1TYxECsqPMqYyb1AYtUG69THOnBqW1RmZevN11iAz280_MYwNtk_tnsnQCm20fyHd1TYGZ21lo7Pb6qzpHrCUM1bJy8lQJBUEmaQXcREsfEXWw"
                                };
                                courtImage = courtImages[i % courtImages.length];
                            }
                    %>
                    <div class="court-card group bg-white dark:bg-slate-900 rounded-2xl overflow-hidden shadow-sm border border-slate-100 dark:border-slate-800 flex flex-col">
                        <div class="relative h-48 overflow-hidden">
                            <img class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" src="<%= courtImage %>" alt="<%= fieldName %>" onerror="this.src='https://lh3.googleusercontent.com/aida-public/AB6AXuBqpghBbuxLm1R5cRO2IQ_lWLvBT2X1ubp06pwpqtzPBSkMR7-xyTli9yzV0OTpLForPzFBNHMTk-VFW9rc6d529yHDPKgrPPaIPLc_iiJPUtQ_YUGzceI6r09ZN02aoNa1dQr5nyYSJooaCiHVqxuXRfQK6lgu_r8KJJAbtzzaWL72l5r9_5qLJqRqpTZlKMDQ77_MG-NI38aGk-x-lBErzMisc4Nib4VwNnneDUGYvuBz3EAZztloqKD35UqLds5FD4gsisjNMbI'" />
                            <span class="absolute top-3 left-3 bg-red-500 text-white text-[10px] font-black px-3 py-1 rounded-full uppercase tracking-widest">Hot</span>
                            <button type="button" class="absolute top-3 right-3 w-8 h-8 bg-white/20 backdrop-blur-md text-white rounded-full flex items-center justify-center hover:bg-white hover:text-red-500 transition-colors">
                                <span class="material-symbols-outlined text-lg">favorite</span>
                            </button>
                        </div>
                        <div class="p-5 flex-1 flex flex-col">
                            <div class="flex justify-between items-start mb-2">
                                <h3 class="font-bold text-lg text-slate-900 dark:text-white group-hover:text-primary transition-colors line-clamp-1"><%= venueName %></h3>
                                <div class="flex items-center gap-1 text-amber-400">
                                    <span class="material-symbols-outlined text-sm fill-1">star</span>
                                    <span class="text-sm font-bold text-slate-900 dark:text-white"><%= String.format("%.1f", avgRating) %></span>
                                </div>
                            </div>
                            <div class="flex items-center gap-1 text-slate-500 text-sm mb-4">
                                <span class="material-symbols-outlined text-sm">location_on</span>
                                <span><%= districtName %>, <%= provinceName %></span>
                            </div>
                            <div class="mt-auto pt-4 border-t border-slate-50 dark:border-slate-800 flex items-center justify-between">
                                <div>
                                    <p class="text-[10px] uppercase text-slate-400 font-bold tracking-wider">Giá từ</p>
                                    <p class="text-primary font-black text-lg"><%= priceDisplay %><span class="text-xs text-slate-400 font-normal">/giờ</span></p>
                                </div>
                                <a href="FieldDetail.jsp?fieldId=<%= fieldId %>" class="btn-glow px-4 py-2 bg-primary text-slate-900 font-bold text-sm rounded-xl transition-all inline-block">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
                <!-- Pagination -->
                <%
                    if (totalPages > 1) {
                %>
                <div class="mt-12 flex justify-center items-center gap-2">
                    <%
                        if (currentPage > 1) {
                    %>
                    <a href="fieldList.jsp?page=<%= currentPage - 1 %><%= queryString %>" class="w-10 h-10 rounded-xl flex items-center justify-center border border-slate-200 dark:border-slate-800 hover:bg-slate-100 dark:hover:bg-slate-800">
                        <span class="material-symbols-outlined">chevron_left</span>
                    </a>
                    <%
                        } else {
                    %>
                    <button disabled class="w-10 h-10 rounded-xl flex items-center justify-center border border-slate-200 dark:border-slate-800 opacity-50 cursor-not-allowed">
                        <span class="material-symbols-outlined">chevron_left</span>
                    </button>
                    <%
                        }
                    %>
                    <%
                        // Calculate page range
                        int startPage = Math.max(1, currentPage - 1);
                        int endPage = Math.min(totalPages, currentPage + 1);
                       
                        // Show first page if far from start
                        if (startPage > 1) {
                    %>
                    <a href="fieldList.jsp?page=1<%= queryString %>" class="w-10 h-10 rounded-xl flex items-center justify-center border border-slate-200 dark:border-slate-800 hover:bg-slate-100 dark:hover:bg-slate-800 font-bold">1</a>
                    <%
                            if (startPage > 2) {
                    %>
                    <span class="px-2 text-slate-400">...</span>
                    <%
                            }
                        }
                       
                        // Show page numbers
                        for (int p = startPage; p <= endPage; p++) {
                            if (p == currentPage) {
                    %>
                    <button class="w-10 h-10 rounded-xl flex items-center justify-center bg-primary text-slate-900 font-black"><%= p %></button>
                    <%
                            } else {
                    %>
                    <a href="fieldList.jsp?page=<%= p %><%= queryString %>" class="w-10 h-10 rounded-xl flex items-center justify-center border border-slate-200 dark:border-slate-800 hover:bg-slate-100 dark:hover:bg-slate-800 font-bold"><%= p %></a>
                    <%
                            }
                        }
                       
                        // Show last page if far from end
                        if (endPage < totalPages) {
                            if (endPage < totalPages - 1) {
                    %>
                    <span class="px-2 text-slate-400">...</span>
                    <%
                            }
                    %>
                    <a href="fieldList.jsp?page=<%= totalPages %><%= queryString %>" class="w-10 h-10 rounded-xl flex items-center justify-center border border-slate-200 dark:border-slate-800 hover:bg-slate-100 dark:hover:bg-slate-800 font-bold"><%= totalPages %></a>
                    <%
                        }
                    %>
                    <%
                        if (currentPage < totalPages) {
                    %>
                    <a href="fieldList.jsp?page=<%= currentPage + 1 %><%= queryString %>" class="w-10 h-10 rounded-xl flex items-center justify-center border border-slate-200 dark:border-slate-800 hover:bg-slate-100 dark:hover:bg-slate-800">
                        <span class="material-symbols-outlined">chevron_right</span>
                    </a>
                    <%
                        } else {
                    %>
                    <button disabled class="w-10 h-10 rounded-xl flex items-center justify-center border border-slate-200 dark:border-slate-800 opacity-50 cursor-not-allowed">
                        <span class="material-symbols-outlined">chevron_right</span>
                    </button>
                    <%
                        }
                    %>
                </div>
                <%
                    }
                %>
                <%
                    } else {
                %>
                <div class="text-center py-12">
                    <span class="material-symbols-outlined text-6xl text-slate-300 dark:text-slate-600 mb-4 inline-block">search_off</span>
                    <p class="text-slate-500 text-lg">Không tìm thấy sân phù hợp</p>
                    <p class="text-slate-400 text-sm mt-2">Vui lòng thử lại với các bộ lọc khác</p>
                </div>
                <%
                    }
                %>
            </section>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>
