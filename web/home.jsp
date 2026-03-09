<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="dao.FieldDao" %>
<%@page import="dao.FieldImageDAO" %>
<%@page import="model.FieldImage" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.sql.SQLException" %>
<%
    FieldDao fieldDao = new FieldDao();
    FieldImageDAO fieldImageDAO = new FieldImageDAO();
    List<Map<String, Object>> topCourts = null;
    List<Map<String, Object>> sportTypes = null;
    String errorMessage = null;
    try {
        // Lấy 10 sân được đặt nhiều nhất
        topCourts = fieldDao.getTop10MostBookedFields();
    } catch (SQLException e) {
        errorMessage = "Lỗi khi tải danh sách sân: " + e.getMessage();
        System.err.println(errorMessage);
    }
    try {
        // Lấy danh mục môn thể thao
        sportTypes = fieldDao.getSportTypes();
    } catch (SQLException e) {
        errorMessage = "Lỗi khi tải danh mục thể thao: " + e.getMessage();
        System.err.println(errorMessage);
    }
%>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>SportMate - Đặt sân thể thao dễ dàng</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;500;600;700;800&display=swap"
        rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@100..700,0..1&display=swap"
        rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
        rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                        "display": ["Lexend"]
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
            font-family: 'Lexend', sans-serif;
        }
        .hover-lift {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .hover-lift:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px -5px rgba(19, 236, 109, 0.2);
        }
        .nav-link {
            position: relative;
        }
        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -4px;
            left: 0;
            background-color: #13ec6d;
            transition: width 0.3s ease;
        }
        .nav-link:hover::after {
            width: 100%;
        }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100">
    <%@ include file="header.jsp" %>
    <!-- Hero Section -->
    <section class="relative w-full min-h-[600px] flex items-center overflow-hidden">
        <div class="absolute inset-0 z-0">
            <img alt="Sports Complex Background" class="w-full h-full object-cover"
                data-alt="Modern indoor sports complex with various courts"
                src="https://lh3.googleusercontent.com/aida-public/AB6AXuBkqS0knFKZVpPQNHfdV74oCKDgJxm8VFl0zdKsqeFFuB8ELnQLbBL-H-ouY7yG_soSTBVegfPWdGcER5Hl-8ykGCj4rlaFXBnXnkYDyqsJIixNPSxMCThphAa5uH83LkIPzxoSi27uTYBotQVFUrzSZw8wKRJS0kcufBM5DGe59DkcYHGzphD70vjFOAwzBbYKdb1FVjNRvYMjJK99Dpx5iElqw3nCjFx4Y3ZPk-Olnfrm3PejVnU3lQ_ZpYj2hWri9BCNZDVHw6U" />
            <div class="absolute inset-0 bg-gradient-to-r from-background-dark/90 via-background-dark/60 to-transparent"></div>
        </div>
        <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
            <div class="max-w-2xl">
                <h1 class="text-5xl md:text-6xl font-black text-white leading-tight mb-6">
                    Sân đâu xa <span class="text-primary underline decoration-primary/30"> Đặt là ra </span>
                </h1>
                <p class="text-lg text-slate-300 mb-10 leading-relaxed">
                    Hệ thống đặt sân linh hoạt, thanh toán an toàn và nhanh chóng hàng đầu Việt Nam. Khám phá hàng ngàn sân vận động tiêu chuẩn quốc tế ngay hôm nay.
                </p>
                <div class="flex flex-wrap gap-4">
                    <button onclick="window.location.href='fieldList.jsp'" class="group px-8 py-4 bg-primary text-background-dark rounded-full font-bold text-lg hover:scale-105 transition-all flex items-center gap-2 shadow-xl shadow-primary/30">
                        Đặt sân ngay
                        <span class="material-symbols-outlined group-hover:translate-x-1 transition-transform">arrow_forward</span>
                    </button>
                    <button onclick="window.location.href='fieldList.jsp'" class="px-8 py-4 border-2 border-white/30 text-white rounded-full font-bold text-lg hover:bg-white/10 transition-all backdrop-blur-sm">
                        Xem danh sách sân
                    </button>
                </div>
            </div>
        </div>
    </section>
    <!-- Sports Categories -->
    <section class="py-20 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
            <h2 class="text-3xl font-bold mb-4">Danh mục môn thể thao</h2>
            <div class="w-20 h-1.5 bg-primary mx-auto rounded-full"></div>
        </div>
        <%
            if (sportTypes != null && !sportTypes.isEmpty()) {
        %>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
            <%
                String[] iconMap = {
                    "sports_soccer", // Bóng đá
                    "sports_tennis", // Cầu lông/Tennis
                    "sports_baseball", // Baseball
                    "sports_basketball" // Bóng rổ
                };
                for (int i = 0; i < sportTypes.size(); i++) {
                    Map<String, Object> sport = sportTypes.get(i);
                    String icon = i < iconMap.length ? iconMap[i] : "sports_soccer";
            %>
            <div class="group hover-lift bg-white dark:bg-slate-800/50 p-8 rounded-2xl border border-primary/10 text-center cursor-pointer hover:border-primary/30 transition-all">
                <div class="w-16 h-16 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform">
                    <span class="material-symbols-outlined text-4xl text-primary"><%= icon %></span>
                </div>
                <h3 class="text-xl font-bold mb-2"><%= sport.get("sportName") %></h3>
                <p class="text-sm text-slate-500 dark:text-slate-400">
                    <%
                        String sportName = (String) sport.get("sportName");
                        if (sportName.contains("Bóng đá")) {
                            out.print("Sân cỏ nhân tạo 5-7-11 người");
                        } else if (sportName.contains("Cầu lông")) {
                            out.print("Sân trong nhà tiêu chuẩn");
                        } else if (sportName.contains("Tennis")) {
                            out.print("Sân đất nện & sân cứng");
                        } else if (sportName.contains("Bóng rổ")) {
                            out.print("Sân thi đấu chuyên nghiệp");
                        } else {
                            out.print("Sân thể thao tiêu chuẩn");
                        }
                    %>
                </p>
            </div>
            <%
                }
            %>
        </div>
        <%
            } else {
        %>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
            <!-- Football -->
            <div class="group hover-lift bg-white dark:bg-slate-800/50 p-8 rounded-2xl border border-primary/10 text-center cursor-pointer">
                <div class="w-16 h-16 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform">
                    <span class="material-symbols-outlined text-4xl text-primary">sports_soccer</span>
                </div>
                <h3 class="text-xl font-bold mb-2">Bóng đá</h3>
                <p class="text-sm text-slate-500 dark:text-slate-400">Sân cỏ nhân tạo 5-7-11 người</p>
            </div>
            <!-- Badminton -->
            <div class="group hover-lift bg-white dark:bg-slate-800/50 p-8 rounded-2xl border border-primary/10 text-center cursor-pointer">
                <div class="w-16 h-16 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform">
                    <span class="material-symbols-outlined text-4xl text-primary">sports_tennis</span>
                </div>
                <h3 class="text-xl font-bold mb-2">Cầu lông</h3>
                <p class="text-sm text-slate-500 dark:text-slate-400">Sân trong nhà tiêu chuẩn</p>
            </div>
            <!-- Tennis -->
            <div class="group hover-lift bg-white dark:bg-slate-800/50 p-8 rounded-2xl border border-primary/10 text-center cursor-pointer">
                <div class="w-16 h-16 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform">
                    <span class="material-symbols-outlined text-4xl text-primary">sports_baseball</span>
                </div>
                <h3 class="text-xl font-bold mb-2">Tennis</h3>
                <p class="text-sm text-slate-500 dark:text-slate-400">Sân đất nện & sân cứng</p>
            </div>
            <!-- Basketball -->
            <div class="group hover-lift bg-white dark:bg-slate-800/50 p-8 rounded-2xl border border-primary/10 text-center cursor-pointer">
                <div class="w-16 h-16 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform">
                    <span class="material-symbols-outlined text-4xl text-primary">sports_basketball</span>
                </div>
                <h3 class="text-xl font-bold mb-2">Bóng rổ</h3>
                <p class="text-sm text-slate-500 dark:text-slate-400">Sân thi đấu chuyên nghiệp</p>
            </div>
        </div>
        <%
            }
        %>
    </section>
    <!-- Featured Courts -->
    <section class="py-20 bg-primary/5">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-end mb-12">
                <div>
                    <h2 class="text-3xl font-bold mb-2">Sân thể thao nổi bật</h2>
                    <p class="text-slate-600 dark:text-slate-400">Những địa điểm được đánh giá tốt nhất trong tuần</p>
                </div>
                <a class="text-primary font-bold hover:underline flex items-center gap-1" href="fieldList.jsp">
                    Xem tất cả <span class="material-symbols-outlined">chevron_right</span>
                </a>
            </div>
            <%
                if (topCourts != null && !topCourts.isEmpty()) {
                    int displayCount = Math.min(3, topCourts.size());
            %>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <%
                    for (int i = 0; i < displayCount; i++) {
                        Map<String, Object> court = topCourts.get(i);
                        Integer fieldId = (Integer) court.get("fieldId");
                        String venueName = (String) court.get("venueName");
                        String fieldName = (String) court.get("fieldName");
                        String districtName = (String) court.get("districtName");
                        String provinceName = (String) court.get("provinceName");
                        Double avgRating = court.get("avgRating") != null ? (Double) court.get("avgRating") : 0.0;
                        
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
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuBZZChf8CmeEVsUML3pY9Sn5n-vqQlhDQPKzaX6ZPVUt1SyA0KOyOT3SvYZV78X4Nlo6lURmBvslN1X3rbVPHS6dtlFWy8G4D98m2p-SgkEkYEycD0nZpLSr5QindvZMAM29ujoC25jjDprDnU_mo2Luw7qqfOwroZ81J5fZzCQChcLHcxEhNvaNWJ1FB7vb9WvDq1KETd6vqEY7CGGc07BY_VP4-EPmZ1oKauEprfXVaON9vhVTa4ekKtirKy3dMV7X_3-i5La5oY",
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuCocD0qytRhkVxk7iK2K9iRSK5XM7AymzSUW4Y_2zzTt4Bd6QaLWITYSitP5fuibdI_cTtCpHo9PI7Y2RL6OE6IrwbKjAa05fsQzcBPaMBwgmPlrRj0g6IqMAIY6w-u-dXavsvaTjfBpf12cQj8_s_5BrvaOn_BN9d7tp_VGets1bdSKuyKnXHp2sh5cJCzvGU79Vs-3zyga4FMr49TT5ROajLzi10w0rUODeQbG10AftkWwa7Y3eOQblJKiKDED9OaHmc9CackYpQ",
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuCsICcyCsEIzavkZPmRh1j6OXDIyV92fe9PGtH8MIcGGuBId1glqX19-Md5xjau20MnxTRIYa6ED__cHBjQ8C8pikZ3O2OntCgTbNTLLii1dtvw9QC46aIwSLn1hDU-Jlj2bV2UgSyapqANHXVOn0F_we26wqTQaDgR6s52PfhrkNbzE7jGF3PilV5GcwMrKXWIoud_kToZDqu8J1QCuN6U1cC3wI6lM4pB5wfLHGCCZXNv66pP0etQi_bygNlkM7reBEuHL5Qs7mk"
                            };
                            courtImage = courtImages[i % courtImages.length];
                        }
                %>
                <div class="group bg-white dark:bg-slate-800 rounded-3xl overflow-hidden hover-lift border border-transparent hover:border-primary/20">
                    <div class="relative h-56 overflow-hidden">
                        <img alt="<%= fieldName %>" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" src="<%= courtImage %>" onerror="this.src='https://lh3.googleusercontent.com/aida-public/AB6AXuBZZChf8CmeEVsUML3pY9Sn5n-vqQlhDQPKzaX6ZPVUt1SyA0KOyOT3SvYZV78X4Nlo6lURmBvslN1X3rbVPHS6dtlFWy8G4D98m2p-SgkEkYEycD0nZpLSr5QindvZMAM29ujoC25jjDprDnU_mo2Luw7qqfOwroZ81J5fZzCQChcLHcxEhNvaNWJ1FB7vb9WvDq1KETd6vqEY7CGGc07BY_VP4-EPmZ1oKauEprfXVaON9vhVTa4ekKtirKy3dMV7X_3-i5La5oY'" />
                        <div class="absolute top-4 right-4 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full text-xs font-bold text-background-dark">
                            Hot
                        </div>
                    </div>
                    <div class="p-6">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="text-xl font-bold"><%= venueName %></h3>
                            <div class="flex items-center text-yellow-400">
                                <span class="material-symbols-outlined text-sm fill-current">star</span>
                                <span class="text-sm font-bold ml-1 text-slate-700 dark:text-slate-300">
                                    <%= String.format("%.1f", avgRating) %>
                                </span>
                            </div>
                        </div>
                        <div class="flex items-center gap-1 text-slate-500 dark:text-slate-400 text-sm mb-4">
                            <span class="material-symbols-outlined text-sm">location_on</span>
                            <%= districtName %>, <%= provinceName %>
                        </div>
                        <div class="flex items-center justify-between mt-6">
                            <div>
                                <span class="text-xs text-slate-400 block">Giá từ</span>
                                <span class="text-xl font-bold text-primary"><%= priceDisplay %><span class="text-sm font-normal text-slate-500">/giờ</span></span>
                            </div>
                            <button onclick="window.location.href='fieldDetail.jsp?fieldId=<%= fieldId %>'" class="px-5 py-2.5 bg-background-dark dark:bg-primary text-white dark:text-background-dark rounded-xl font-bold text-sm hover:bg-primary hover:text-background-dark transition-all">
                                Đặt ngay
                            </button>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
            <%
                } else {
            %>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Court Card 1 -->
                <div class="group bg-white dark:bg-slate-800 rounded-3xl overflow-hidden hover-lift border border-transparent hover:border-primary/20">
                    <div class="relative h-56 overflow-hidden">
                        <img alt="Soccer Court" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBZZChf8CmeEVsUML3pY9Sn5n-vqQlhDQPKzaX6ZPVUt1SyA0KOyOT3SvYZV78X4Nlo6lURmBvslN1X3rbVPHS6dtlFWy8G4D98m2p-SgkEkYEycD0nZpLSr5QindvZMAM29ujoC25jjDprDnU_mo2Luw7qqfOwroZ81J5fZzCQChcLHcxEhNvaNWJ1FB7vb9WvDq1KETd6vqEY7CGGc07BY_VP4-EPmZ1oKauEprfXVaON9vhVTa4ekKtirKy3dMV7X_3-i5La5oY" />
                        <div class="absolute top-4 right-4 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full text-xs font-bold text-background-dark">
                            Hot
                        </div>
                    </div>
                    <div class="p-6">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="text-xl font-bold">Sân vận động Thống Nhất</h3>
                            <div class="flex items-center text-yellow-400">
                                <span class="material-symbols-outlined text-sm fill-current">star</span>
                                <span class="text-sm font-bold ml-1 text-slate-700 dark:text-slate-300">4.9</span>
                            </div>
                        </div>
                        <div class="flex items-center gap-1 text-slate-500 dark:text-slate-400 text-sm mb-4">
                            <span class="material-symbols-outlined text-sm">location_on</span>
                            Quận 10, TP. Hồ Chí Minh
                        </div>
                        <div class="flex items-center justify-between mt-6">
                            <div>
                                <span class="text-xs text-slate-400 block">Giá từ</span>
                                <span class="text-xl font-bold text-primary">300.000đ<span class="text-sm font-normal text-slate-500">/giờ</span></span>
                            </div>
                            <button onclick="window.location.href='fieldList.jsp'" class="px-5 py-2.5 bg-background-dark dark:bg-primary text-white dark:text-background-dark rounded-xl font-bold text-sm hover:bg-primary hover:text-background-dark transition-all">
                                Đặt ngay
                            </button>
                        </div>
                    </div>
                </div>
                <!-- Court Card 2 -->
                <div class="group bg-white dark:bg-slate-800 rounded-3xl overflow-hidden hover-lift border border-transparent hover:border-primary/20">
                    <div class="relative h-56 overflow-hidden">
                        <img alt="Badminton Court" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCocD0qytRhkVxk7iK2K9iRSK5XM7AymzSUW4Y_2zzTt4Bd6QaLWITYSitP5fuibdI_cTtCpHo9PI7Y2RL6OE6IrwbKjAa05fsQzcBPaMBwgmPlrRj0g6IqMAIY6w-u-dXavsvaTjfBpf12cQj8_s_5BrvaOn_BN9d7tp_VGets1bdSKuyKnXHp2sh5cJCzvGU79Vs-3zyga4FMr49TT5ROajLzi10w0rUODeQbG10AftkWwa7Y3eOQblJKiKDED9OaHmc9CackYpQ" />
                    </div>
                    <div class="p-6">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="text-xl font-bold">CLB Cầu Lông Đa Năng</h3>
                            <div class="flex items-center text-yellow-400">
                                <span class="material-symbols-outlined text-sm fill-current">star</span>
                                <span class="text-sm font-bold ml-1 text-slate-700 dark:text-slate-300">4.8</span>
                            </div>
                        </div>
                        <div class="flex items-center gap-1 text-slate-500 dark:text-slate-400 text-sm mb-4">
                            <span class="material-symbols-outlined text-sm">location_on</span>
                            Quận 7, TP. Hồ Chí Minh
                        </div>
                        <div class="flex items-center justify-between mt-6">
                            <div>
                                <span class="text-xs text-slate-400 block">Giá từ</span>
                                <span class="text-xl font-bold text-primary">120.000đ<span class="text-sm font-normal text-slate-500">/giờ</span></span>
                            </div>
                            <button onclick="window.location.href='fieldList.jsp'" class="px-5 py-2.5 bg-background-dark dark:bg-primary text-white dark:text-background-dark rounded-xl font-bold text-sm hover:bg-primary hover:text-background-dark transition-all">
                                Đặt ngay
                            </button>
                        </div>
                    </div>
                </div>
                <!-- Court Card 3 -->
                <div class="group bg-white dark:bg-slate-800 rounded-3xl overflow-hidden hover-lift border border-transparent hover:border-primary/20">
                    <div class="relative h-56 overflow-hidden">
                        <img alt="Basketball Court" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCsICcyCsEIzavkZPmRh1j6OXDIyV92fe9PGtH8MIcGGuBId1glqX19-Md5xjau20MnxTRIYa6ED__cHBjQ8C8pikZ3O2OntCgTbNTLLii1dtvw9QC46aIwSLn1hDU-Jlj2bV2UgSyapqANHXVOn0F_we26wqTQaDgR6s52PfhrkNbzE7jGF3PilV5GcwMrKXWIoud_kToZDqu8J1QCuN6U1cC3wI6lM4pB5wfLHGCCZXNv66pP0etQi_bygNlkM7reBEuHL5Qs7mk" />
                    </div>
                    <div class="p-6">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="text-xl font-bold">Trung Tâm Bóng Rổ City</h3>
                            <div class="flex items-center text-yellow-400">
                                <span class="material-symbols-outlined text-sm fill-current">star</span>
                                <span class="text-sm font-bold ml-1 text-slate-700 dark:text-slate-300">4.7</span>
                            </div>
                        </div>
                        <div class="flex items-center gap-1 text-slate-500 dark:text-slate-400 text-sm mb-4">
                            <span class="material-symbols-outlined text-sm">location_on</span>
                            Quận Cầu Giấy, Hà Nội
                        </div>
                        <div class="flex items-center justify-between mt-6">
                            <div>
                                <span class="text-xs text-slate-400 block">Giá từ</span>
                                <span class="text-xl font-bold text-primary">450.000đ<span class="text-sm font-normal text-slate-500">/giờ</span></span>
                            </div>
                            <button onclick="window.location.href='fieldList.jsp'" class="px-5 py-2.5 bg-background-dark dark:bg-primary text-white dark:text-background-dark rounded-xl font-bold text-sm hover:bg-primary hover:text-background-dark transition-all">
                                Đặt ngay
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
    </section>
    <!-- Benefits Section -->
    <section class="py-24 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-12 text-center">
            <div class="flex flex-col items-center">
                <div class="w-20 h-20 bg-primary/10 rounded-full flex items-center justify-center mb-6">
                    <span class="material-symbols-outlined text-4xl text-primary">flash_on</span>
                </div>
                <h4 class="text-lg font-bold mb-2">Đặt sân siêu tốc</h4>
                <p class="text-sm text-slate-500 dark:text-slate-400">Chỉ mất 30 giây để hoàn tất việc đặt lịch sân của bạn.</p>
            </div>
            <div class="flex flex-col items-center">
                <div class="w-20 h-20 bg-primary/10 rounded-full flex items-center justify-center mb-6">
                    <span class="material-symbols-outlined text-4xl text-primary">sell</span>
                </div>
                <h4 class="text-lg font-bold mb-2">Giá cả minh bạch</h4>
                <p class="text-sm text-slate-500 dark:text-slate-400">Cam kết giá tốt nhất, không phí ẩn, thanh toán minh bạch.</p>
            </div>
            <div class="flex flex-col items-center">
                <div class="w-20 h-20 bg-primary/10 rounded-full flex items-center justify-center mb-6">
                    <span class="material-symbols-outlined text-4xl text-primary">account_balance_wallet</span>
                </div>
                <h4 class="text-lg font-bold mb-2">Thanh toán an toàn</h4>
                <p class="text-sm text-slate-500 dark:text-slate-400">Hỗ trợ đa dạng phương thức thanh toán Momo, thẻ ngân hàng.</p>
            </div>
            <div class="flex flex-col items-center">
                <div class="w-20 h-20 bg-primary/10 rounded-full flex items-center justify-center mb-6">
                    <span class="material-symbols-outlined text-4xl text-primary">headset_mic</span>
                </div>
                <h4 class="text-lg font-bold mb-2">Hỗ trợ 24/7</h4>
                <p class="text-sm text-slate-500 dark:text-slate-400">Đội ngũ chăm sóc khách hàng luôn sẵn sàng giúp đỡ bạn.</p>
            </div>
        </div>
    </section>
    <!-- Partner CTA Banner -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mb-24">
        <div class="relative overflow-hidden rounded-[2.5rem] bg-gradient-to-br from-primary to-green-600 p-12 text-background-dark shadow-2xl shadow-primary/20">
            <div class="relative z-10 flex flex-col md:flex-row items-center justify-between gap-8">
                <div class="text-center md:text-left">
                    <h2 class="text-3xl md:text-4xl font-black mb-4 leading-tight">Bạn là chủ sân thể thao?</h2>
                    <p class="text-lg font-medium opacity-90">Đăng ký trở thành đối tác để quản lý sân hiệu quả và tăng doanh thu vượt trội.</p>
                </div>
                <a href="become-owner.jsp" class="inline-block no-underline">
                    <button class="px-10 py-5 bg-background-dark text-white rounded-full font-bold text-lg hover:scale-105 transition-all shadow-xl hover:shadow-background-dark/30 whitespace-nowrap">
                        Đăng ký làm đối tác ngay
                    </button>
                </a>
            </div>
            <div class="absolute -right-20 -bottom-20 opacity-10">
                <span class="material-symbols-outlined text-[300px]">handshake</span>
            </div>
        </div>
    </section>
    <%@ include file="footer.jsp" %>
    <%
String ownerRequest = request.getParameter("ownerRequest");
if ("success".equals(ownerRequest)) {
%>

<script>
Swal.fire({
    icon: 'success',
    title: 'Gửi yêu cầu thành công',
    text: 'Chúng tôi sẽ xét duyệt sớm!',
    confirmButtonText: 'OK'
});
</script>

<%
}
%>
</body>
</html>
