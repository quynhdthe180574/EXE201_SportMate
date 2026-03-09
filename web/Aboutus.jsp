<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Get user from session
    model.User user = (model.User) session.getAttribute("user");
    String userName = "";
    String userFirstChar = "U";
    
    if (user != null) {
        userName = user.getFullname();
        if (userName == null || userName.trim().isEmpty()) {
            userName = user.getEmail(); // fallback to email if fullname is empty
        }
        if (!userName.isEmpty()) {
            userFirstChar = String.valueOf(userName.charAt(0)).toUpperCase();
        }
    }
    
    pageContext.setAttribute("isLoggedIn", user != null);
    pageContext.setAttribute("userName", userName);
    pageContext.setAttribute("userFirstChar", userFirstChar);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Về chúng tôi - SportMate</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@100..700,0..1&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
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
                        "display": ["Lexend", "sans-serif"]
                    },
                    borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
                },
            },
        }
    </script>
    <style>
        body {
            font-family: 'Lexend', sans-serif;
        }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100">
<div class="relative flex min-h-screen w-full flex-col overflow-x-hidden">

    <!-- Top Navigation with Session Management -->
    <header class="flex items-center justify-between whitespace-nowrap border-b border-solid border-slate-200 dark:border-slate-800 px-6 md:px-20 py-4 bg-background-light/80 dark:bg-background-dark/80 backdrop-blur-md sticky top-0 z-50">
        <div class="flex items-center gap-4 text-slate-900 dark:text-slate-100">
            <div class="size-8 bg-primary rounded-lg flex items-center justify-center">
                <span class="material-symbols-outlined text-background-dark">sports_tennis</span>
            </div>
            <a href="home.jsp" class="text-xl font-bold leading-tight tracking-tight hover:text-primary transition-colors">SportMate</a>
        </div>
        <div class="hidden md:flex flex-1 justify-end gap-8">
             <!-- Nav -->
            <nav class="hidden md:flex items-center gap-10 text-sm font-semibold">
                <a href="home.jsp" class="hover:text-primary transition-colors">Trang chủ</a>
                <a href="fieldList.jsp" class="hover:text-primary transition-colors">Danh sách sân</a>
                <a href="Aboutus.jsp" class="hover:text-primary transition-colors">Về chúng tôi</a>    
                <a href="Notification.jsp" class="hover:text-primary transition-colors">Thông báo</a>    
            </nav>
            <c:choose>
                <c:when test="${isLoggedIn}">
                    <!-- User Logged In - Avatar with Dropdown -->
                    <div class="relative group">
                        <button class="flex items-center gap-2 px-3 py-2 rounded-full bg-primary/10 hover:bg-primary/20 transition-colors">
                            <div class="size-7 rounded-full bg-primary flex items-center justify-center text-slate-900 font-bold text-xs">
                                ${userFirstChar}
                            </div>
                            <span class="hidden sm:block text-xs font-bold text-slate-900 dark:text-slate-100">${userName}</span>
                            <span class="material-symbols-outlined text-base">expand_more</span>
                        </button>
                        <div class="absolute right-0 mt-2 w-48 bg-white dark:bg-slate-800 rounded-lg border border-primary/10 shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                            <div class="px-4 py-3 border-b border-primary/10">
                                <p class="text-xs font-bold text-slate-900 dark:text-slate-100">${userName}</p>
                                <p class="text-xs text-slate-500">Tài khoản của tôi</p>
                            </div>
                            <div class="py-2">
                                <a href="bookingHistory.jsp" class="flex items-center gap-2 px-4 py-2 text-xs font-semibold text-slate-600 dark:text-slate-400 hover:text-primary hover:bg-primary/5 dark:hover:bg-primary/10 transition-colors">
                                    <span class="material-symbols-outlined text-sm">calendar_today</span>
                                    <span>Lịch sử đặt sân</span>
                                </a>
                                <a href="profile.jsp" class="flex items-center gap-2 px-4 py-2 text-xs font-semibold text-slate-600 dark:text-slate-400 hover:text-primary hover:bg-primary/5 dark:hover:bg-primary/10 transition-colors">
                                    <span class="material-symbols-outlined text-sm">person</span>
                                    <span>Hồ sơ cá nhân</span>
                                </a>
                            </div>
                            <div class="border-t border-primary/10"></div>
                            <div class="py-2">
                                <a href="${pageContext.request.contextPath}/logout.jsp" class="flex items-center gap-2 px-4 py-2 text-xs font-semibold text-red-600 dark:text-red-400 hover:text-red-700 dark:text-red-300 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors">
                                    <span class="material-symbols-outlined text-sm">logout</span>
                                    <span>Đăng xuất</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- User Not Logged In -->
                    <button onclick="window.location.href='login.jsp'" class="text-sm font-bold text-slate-700 dark:text-slate-200 hover:text-primary transition-colors">Đăng nhập</button>
                    <button onclick="window.location.href='signup.jsp'" class="flex min-w-[120px] cursor-pointer items-center justify-center rounded-lg h-10 px-5 bg-primary text-background-dark text-sm font-bold transition-transform hover:scale-105">
                        Đăng ký ngay
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
        <button class="md:hidden text-slate-900 dark:text-slate-100">
            <span class="material-symbols-outlined">menu</span>
        </button>
    </header>

    <main class="flex flex-col">
        <!-- Hero Section -->
        <section class="relative h-[60vh] min-h-[400px] flex items-center justify-center overflow-hidden">
            <div class="absolute inset-0 bg-cover bg-center" style='background-image: linear-gradient(rgba(16, 34, 24, 0.7) 0%, rgba(16, 34, 24, 0.9) 100%), url("https://lh3.googleusercontent.com/aida-public/AB6AXuC327O2Z4XmcdyHmpDiyGuFX63Gu-SC2mjvHD34PjgqfmWnQ0pzu6mDj6dYoS7eryzz4M4BCR1TLZpiTTGu6URvW5B2Cwaw5Mbrm8SWyr-N2bvohTSK4fBfv6JGBigVYLgaTjgaQbO4puS68MpV5cOgARHQTjd7KpUdF44vBqKPbLg2bORp0OIxOcUBE1pZ-HL-Gib3eodfgxYwy7f9kr-P2r0sWmsAt6jBdBORy9aBVi9BL2eTJbIM71jMiuVGz80m0wEbe7ZdZws");'></div>
            <div class="relative z-10 text-center px-4 max-w-4xl">
                <h1 class="text-white text-5xl md:text-7xl font-black mb-6 tracking-tight">
                    Về SportMate
                </h1>
                <p class="text-primary text-lg md:text-xl font-medium max-w-2xl mx-auto">
                    Kết nối đam mê, nâng tầm trải nghiệm thể thao chuyên nghiệp qua nền tảng đặt sân hiện đại nhất Việt Nam.
                </p>
            </div>
        </section>

        <!-- Our Story Section -->
        <section class="py-20 px-6 md:px-20 max-w-7xl mx-auto">
            <div class="grid md:grid-cols-2 gap-12 items-center">
                <div class="relative">
                    <div class="aspect-square rounded-2xl overflow-hidden shadow-2xl">
                        <img class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCYR_i58E0mP2PULBwue1vF39ZdbsI7l-V_8eOfyOYOd3ZtNbZsMM08VQa8fYHMnys2zEz_BnLP7sQas-6O_1M_f2YDfcZTokBNHw3nIVA9hYxvoy6ZDDGDW-rnm5_lvLvmw-yzGfxOSAI-6yvCvA9Re71XUbisbBKlHlQUuW-dZH89z8NwLCTmXc4I1rIlfHpSn_kT_Xk4ju_M3617hvTe0YGwu8E01ZrArBlTCUlqmwhy2vj0RQdDw4fMN8Z4Y2MV2v0tOL3igTk" alt="Cộng đồng sân thể thao"/>
                    </div>
                    <div class="absolute -bottom-6 -right-6 w-48 h-48 bg-primary/20 rounded-full blur-3xl -z-10"></div>
                </div>
                <div class="flex flex-col gap-6">
                    <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-primary/10 text-primary w-fit">
                        <span class="material-symbols-outlined text-sm">history</span>
                        <span class="text-xs font-bold uppercase tracking-wider">Câu chuyện của chúng tôi</span>
                    </div>
                    <h2 class="text-3xl md:text-4xl font-extrabold leading-tight">Sứ mệnh làm cho thể thao trở nên dễ dàng hơn</h2>
                    <div class="space-y-4 text-slate-600 dark:text-slate-400 text-lg">
                        <p>
                            SportMate ra đời từ một trăn trở giản đơn: Tại sao việc tìm kiếm và đặt một sân bóng hay sân tennis chất lượng lại tốn nhiều thời gian đến vậy? Chúng tôi nhận thấy rào cản về thông tin và sự bất tiện trong quy trình đặt sân truyền thống đang kìm hãm đam mê của hàng triệu người chơi.
                        </p>
                        <p>
                            Chúng tôi tin rằng mọi người đều xứng đáng có một không gian tập luyện chuyên nghiệp, tiện lợi và minh bạch. Bằng cách ứng dụng công nghệ, SportMate không chỉ là một ứng dụng đặt sân, mà là người bạn đồng hành trong hành trình nâng cao sức khỏe và kết nối cộng đồng yêu thể thao.
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Statistics Section -->
        <section class="bg-slate-900 text-white py-16 px-6">
            <div class="max-w-7xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-8">
                <div class="text-center">
                    <div class="text-4xl md:text-5xl font-black text-primary mb-2">1000+</div>
                    <div class="text-slate-400 text-sm font-medium uppercase tracking-widest">Sân bãi liên kết</div>
                </div>
                <div class="text-center">
                    <div class="text-4xl md:text-5xl font-black text-primary mb-2">100k+</div>
                    <div class="text-slate-400 text-sm font-medium uppercase tracking-widest">Người dùng tin tưởng</div>
                </div>
                <div class="text-center">
                    <div class="text-4xl md:text-5xl font-black text-primary mb-2">65+</div>
                    <div class="text-slate-400 text-sm font-medium uppercase tracking-widest">Quận huyện</div>
                </div>
                <div class="text-center">
                    <div class="text-4xl md:text-5xl font-black text-primary mb-2">10+</div>
                    <div class="text-slate-400 text-sm font-medium uppercase tracking-widest">Năm kinh nghiệm</div>
                </div>
            </div>
        </section>

        <!-- Values Section -->
        <section class="py-24 px-6 md:px-20 bg-primary/5">
            <div class="max-w-7xl mx-auto">
                <div class="text-center mb-16">
                    <h2 class="text-3xl md:text-4xl font-extrabold mb-4">Giá trị cốt lõi</h2>
                    <p class="text-slate-600 dark:text-slate-400 max-w-2xl mx-auto">Những nguyên tắc vàng dẫn dắt chúng tôi xây dựng một hệ sinh thái thể thao bền vững.</p>
                </div>
                <div class="grid md:grid-cols-4 gap-8">
                    <div class="bg-background-light dark:bg-background-dark p-8 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 transition-all hover:-translate-y-2 hover:shadow-xl">
                        <div class="size-14 rounded-xl bg-primary/10 flex items-center justify-center mb-6">
                            <span class="material-symbols-outlined text-primary text-3xl">visibility</span>
                        </div>
                        <h3 class="text-xl font-bold mb-3">Minh bạch</h3>
                        <p class="text-slate-600 dark:text-slate-400 text-sm leading-relaxed">Thông tin giá cả và lịch đặt luôn công khai, rõ ràng và cập nhật theo thời gian thực.</p>
                    </div>
                    <div class="bg-background-light dark:bg-background-dark p-8 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 transition-all hover:-translate-y-2 hover:shadow-xl">
                        <div class="size-14 rounded-xl bg-primary/10 flex items-center justify-center mb-6">
                            <span class="material-symbols-outlined text-primary text-3xl">bolt</span>
                        </div>
                        <h3 class="text-xl font-bold mb-3">Tiện lợi</h3>
                        <p class="text-slate-600 dark:text-slate-400 text-sm leading-relaxed">Chỉ với vài thao tác chạm, bạn đã có thể sở hữu ngay khung giờ chơi lý tưởng nhất.</p>
                    </div>
                    <div class="bg-background-light dark:bg-background-dark p-8 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 transition-all hover:-translate-y-2 hover:shadow-xl">
                        <div class="size-14 rounded-xl bg-primary/10 flex items-center justify-center mb-6">
                            <span class="material-symbols-outlined text-primary text-3xl">support_agent</span>
                        </div>
                        <h3 class="text-xl font-bold mb-3">Hỗ trợ</h3>
                        <p class="text-slate-600 dark:text-slate-400 text-sm leading-relaxed">Đội ngũ chăm sóc khách hàng luôn sẵn sàng đồng hành cùng bạn 24/7.</p>
                    </div>
                    <div class="bg-background-light dark:bg-background-dark p-8 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 transition-all hover:-translate-y-2 hover:shadow-xl">
                        <div class="size-14 rounded-xl bg-primary/10 flex items-center justify-center mb-6">
                            <span class="material-symbols-outlined text-primary text-3xl">tips_and_updates</span>
                        </div>
                        <h3 class="text-xl font-bold mb-3">Đổi mới</h3>
                        <p class="text-slate-600 dark:text-slate-400 text-sm leading-relaxed">Luôn cập nhật công nghệ để mang lại những trải nghiệm số hóa hàng đầu.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Our Team Section -->
        <section class="py-24 px-6 md:px-20 max-w-7xl mx-auto">
            <div class="text-center mb-16">
                <h2 class="text-3xl md:text-4xl font-extrabold mb-4">Đội ngũ sáng lập</h2>
                <p class="text-slate-600 dark:text-slate-400 max-w-2xl mx-auto">Gặp gỡ những người đam mê thể thao đằng sau sự thành công của SportMate.</p>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-12">
                <div class="group">
                    <div class="aspect-[4/5] rounded-2xl overflow-hidden mb-6 relative">
                        <img class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCzatU8vR-WYGxt_NpXMsrCgE-7SDUal8FxWDh4Pc651V20lh3OR51EL3FgTwVIv_-fElSOz5Xq3VPXxWwGbXQ492_5uYJ5U4jP_tv5CSrSNPHUZZaPLwm0XhKryznbh6Wt-eMw8_wg7C7W-dM_cJeWoiRiIi3e4VPy5rYcvta0hZuuqddHuEfPOOYS6Do7e61_DNAtwUpR6t2c1tJ1UtYp5jYBrAG4EfKhOwHcr1SEWBPHfjl6FuSlD974vjGY6XsEiDXhaEiivTs" alt="Founder"/>
                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                    </div>
                    <h3 class="text-2xl font-bold">Nguyễn Minh Nam</h3>
                    <p class="text-primary font-semibold">Founder &amp; CEO</p>
                </div>
                <div class="group">
                    <div class="aspect-[4/5] rounded-2xl overflow-hidden mb-6 relative">
                        <img class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBnwwvuafeSRCaufJjZeDiDPhQCqkQ-9hXx_Gi2LwxvBX19dg-TVSBQfyHZhQf7qqKuYkvdL8TUw24OHaqwu7nKAwwYxS4Y8r7kNYsbQxBNVxUQGb0AQciOp_J4LnKX9QIXBzBeKVS71aw07ieREF_WXOCALd0fD_XLJryA9VjDQC0dBVKX9y79-aHjElZSh9kjub5fBU-ih_Y-j1ejpTiBJSD6HWiOMCGSrvwR30LPv7jxp6pfA_n8R1cMMq8v09XXjUWpoJtSPag" alt="Co-Founder"/>
                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                    </div>
                    <h3 class="text-2xl font-bold">Lê Thu Hà</h3>
                    <p class="text-primary font-semibold">COO &amp; Co-Founder</p>
                </div>
                <div class="group">
                    <div class="aspect-[4/5] rounded-2xl overflow-hidden mb-6 relative">
                        <img class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAp8UKkq53ZluU_SWcA2c8P1nPTkz1A6cVFCwF23t1Iw4iVkvQmyjNqQrlUhbYqJyPTp93LxPEfIHuEZEYIYUkhtXjYDEdktsaq3wnShfHITW6nRk8pRox7xkhwK60xf8VI69L76tOuU5KMk6WSNXxY8uH4_oRDpXUx1bL0nJRm59vbEz25Bof9ML2EK5A5XrUH64a9j_Geo8zqEam1svHP21KU8aJm18cK2fEAZ0wzNwSbcKaya5f7NRyxBBQlnDw9kT2EO-1_paw" alt="CTO"/>
                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                    </div>
                    <h3 class="text-2xl font-bold">Trần Quốc Bảo</h3>
                    <p class="text-primary font-semibold">CTO &amp; Co-Founder</p>
                </div>
            </div>
        </section>

        <!-- Call to Action Section -->
        <section class="py-20 px-6 md:px-20">
            <div class="max-w-7xl mx-auto rounded-3xl bg-primary overflow-hidden relative">
                <div class="absolute inset-0 opacity-10 pointer-events-none">
                    <div class="absolute top-0 left-0 w-64 h-64 bg-white rounded-full -translate-x-1/2 -translate-y-1/2"></div>
                    <div class="absolute bottom-0 right-0 w-96 h-96 bg-white rounded-full translate-x-1/3 translate-y-1/3"></div>
                </div>
                <div class="relative z-10 p-10 md:p-20 flex flex-col md:flex-row items-center justify-between gap-10">
                    <div class="text-background-dark max-w-xl text-center md:text-left">
                        <h2 class="text-3xl md:text-5xl font-black mb-6 leading-tight">Bạn sở hữu sân thể thao?</h2>
                        <p class="text-lg font-medium opacity-90">Hãy trở thành đối tác của chúng tôi để tối ưu hóa doanh thu và tiếp cận hàng ngàn khách hàng tiềm năng mỗi ngày.</p>
                    </div>
                    <div class="flex flex-col gap-4 min-w-[200px]">
                        <button onclick="window.location.href='#'" class="bg-background-dark text-primary px-8 py-4 rounded-xl font-bold text-lg transition-all hover:scale-105 shadow-xl">
                            Đăng ký đối tác
                        </button>
                        <button class="border-2 border-background-dark/20 text-background-dark px-8 py-4 rounded-xl font-bold text-lg hover:bg-background-dark/5 transition-all">
                            Tìm hiểu thêm
                        </button>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="bg-slate-950 text-slate-400 py-12 px-6 md:px-20">
        <div class="max-w-7xl mx-auto grid md:grid-cols-4 gap-12 border-b border-slate-800 pb-12 mb-8">
            <div class="col-span-1 md:col-span-1">
                <div class="flex items-center gap-4 text-white mb-6">
                    <div class="size-6 bg-primary rounded flex items-center justify-center">
                        <span class="material-symbols-outlined text-background-dark text-xs">sports_tennis</span>
                    </div>
                    <h2 class="text-lg font-bold">SportMate</h2>
                </div>
                <p class="text-sm leading-relaxed">Nâng tầm phong cách sống năng động qua từng trận đấu. Giải pháp quản lý sân bãi hàng đầu Việt Nam.</p>
            </div>
            <div>
                <h4 class="text-white font-bold mb-6">Khám phá</h4>
                <ul class="space-y-4 text-sm">
                    <li><a class="hover:text-primary transition-colors" href="fieldList.jsp">Tìm sân gần đây</a></li>
                    <li><a class="hover:text-primary transition-colors" href="home.jsp">Ưu đãi hôm nay</a></li>
                    <li><a class="hover:text-primary transition-colors" href="#">Cộng đồng thể thao</a></li>
                </ul>
            </div>
            <div>
                <h4 class="text-white font-bold mb-6">Thông tin</h4>
                <ul class="space-y-4 text-sm">
                    <li><a class="hover:text-primary transition-colors" href="aboutus.jsp">Về chúng tôi</a></li>
                    <li><a class="hover:text-primary transition-colors" href="#">Điều khoản dịch vụ</a></li>
                    <li><a class="hover:text-primary transition-colors" href="#">Chính sách bảo mật</a></li>
                </ul>
            </div>
            <div>
                <h4 class="text-white font-bold mb-6">Liên hệ</h4>
                <ul class="space-y-4 text-sm">
                    <li class="flex items-center gap-3"><span class="material-symbols-outlined text-primary text-sm">mail</span> contact@sportmate.vn</li>
                    <li class="flex items-center gap-3"><span class="material-symbols-outlined text-primary text-sm">call</span> +84 (0) 123 456 789</li>
                    <li class="flex items-center gap-3"><span class="material-symbols-outlined text-primary text-sm">location_on</span> Hà Nội, Việt Nam</li>
                </ul>
            </div>
        </div>
        <div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between text-xs">
            <p>© 2024 SportMate. Tất cả quyền được bảo lưu.</p>
            <div class="flex gap-6 mt-4 md:mt-0">
                <a class="hover:text-white transition-colors" href="#">Facebook</a>
                <a class="hover:text-white transition-colors" href="#">Instagram</a>
                <a class="hover:text-white transition-colors" href="#">LinkedIn</a>
            </div>
        </div>
    </footer>
</div>
</body>
</html>
