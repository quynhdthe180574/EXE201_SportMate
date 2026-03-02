<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Notification"%>

<%
    List<Notification> list =
        (List<Notification>) request.getAttribute("list");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Thông báo | SportBook</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body{
                background:#f3f4f6;
            }

            .wrapper{
                max-width:950px;
                margin:auto;
                padding:40px 0;
            }

            .header-box{
                background:white;
                padding:25px;
                border-radius:14px;
                margin-bottom:20px;
            }

            .header-box h4{
                font-weight:700;
                margin:0;
            }

            .search-box input{
                border-radius:30px;
            }

            .tab-menu{
                display:flex;
                gap:25px;
                margin-top:15px;
                border-bottom:1px solid #eee;
            }

            .tab-menu span{
                padding-bottom:10px;
                cursor:pointer;
                font-weight:500;
            }

            .tab-active{
                color:#dc3545;
                border-bottom:3px solid #dc3545;
            }

            .noti-card{
                background:#eef2f7;
                border-radius:14px;
                padding:18px 20px;
                margin-bottom:15px;
                transition:0.2s;
            }

            .noti-card:hover{
                background:#e3e8ef;
            }

            .noti-icon{
                font-size:22px;
                width:40px;
            }

            .noti-title{
                font-weight:600;
                font-size:16px;
            }

            .noti-content{
                font-size:14px;
                color:#555;
            }

            .noti-time{
                font-size:13px;
                color:#888;
            }

            .badge-status{
                font-size:12px;
                padding:4px 10px;
                border-radius:20px;
            }

            .badge-success{
                background:#d1f5e0;
                color:#198754;
            }

            .badge-info{
                background:#dbeafe;
                color:#0d6efd;
            }

            .badge-warning{
                background:#fff3cd;
                color:#856404;
            }

            .unread-dot{
                width:8px;
                height:8px;
                background:red;
                border-radius:50%;
                display:inline-block;
                margin-left:6px;
            }

            .close-btn{
                cursor:pointer;
                color:#999;
            }

            .close-btn:hover{
                color:black;
            }

            .action-btn{
                border-radius:20px;
                font-size:14px;
            }
        </style>
    </head>

    <body>

        <div class="wrapper">

            <!-- HEADER -->
            <div class="header-box">

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h4>🔔 Thông báo</h4>
                        <small class="text-muted">
                            Bạn có <%= (list != null ? list.size() : 0) %> thông báo
                        </small>
                    </div>

                    <div>
                        <form action="notifications" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="markAllRead">
                            <button type="submit" class="btn btn-outline-dark action-btn">
                                Đánh dấu tất cả đã đọc
                            </button>
                        </form>

                        <form action="notifications" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="deleteAll">
                            <button type="submit" class="btn btn-outline-danger action-btn">
                                Xóa tất cả
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Tabs -->
                <%
                String filter = request.getParameter("filter");
                if (filter == null) filter = "all";
                %>

                <!--                <div class="tab-menu">
                                    <a href="notifications?filter=all"
                                       class="<%= filter.equals("all") ? "tab-active" : "" %>">
                                        Tất cả
                                    </a>                  
                                </div>-->

            </div>

            <!-- LIST -->
            <% if (list == null || list.isEmpty()) { %>

            <div class="alert alert-light text-center">
                Không có thông báo
            </div>

            <% } else { %>

            <% for (Notification n : list) { %>

            <div class="noti-card">

                <div class="d-flex justify-content-between">

                    <div class="d-flex">

                        <div class="noti-icon">
                            ✅
                        </div>

                        <div>

                            <div class="noti-title">
                                <%= n.getTitle() %>
                                <span class="unread-dot"></span>
                            </div>

                            <div class="noti-content">
                                <%= n.getContent() %>
                            </div>

                            <div class="mt-2">
                                <span class="badge-status badge-success">
                                    Thông báo
                                </span>
                                <span class="noti-time ms-2">
                                    <%= n.getCreatedAt() %>
                                </span>
                            </div>

                        </div>

                    </div>

                    <form action="notifications" method="post" style="margin:0;">
                        <input type="hidden" name="action" value="deleteOne">
                        <input type="hidden" name="notificationId"
                               value="<%= n.getNotificationId() %>">

                        <button type="submit" class="close-btn"
                                style="background:none;border:none;">
                            ✕
                        </button>
                    </form>

                </div>

            </div>

            <% } %>

            <% } %>

        </div>

    </body>
</html>