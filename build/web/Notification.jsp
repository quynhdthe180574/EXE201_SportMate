<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Notification"%>

<%
    List<Notification> list =
        (List<Notification>) request.getAttribute("list");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Thông báo | Sport Mate</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background:#0f2027;
            color:white;
        }
        .notification-card {
            background:#111;
            border-radius:12px;
            padding:16px;
            margin-bottom:12px;
            cursor:pointer;
        }
    </style>
</head>

<body>

<div class="container mt-5" style="max-width:800px">

    <div class="container mt-4" style="max-width:800px">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>📢 Thông báo</h4>

        <a href="<%=request.getContextPath()%>/home.jsp"
           class="btn btn-outline-light btn-sm">
           🏠 Về trang chủ
        </a>
    </div>

    <% if (list == null || list.isEmpty()) { %>

        <div class="alert alert-secondary">
            Không có thông báo
        </div>

    <% } else { %>

        <% for (Notification n : list) { %>

            <!-- CARD -->
            <div class="notification-card"
                 data-bs-toggle="modal"
                 data-bs-target="#notiModal<%= n.getNotificationId() %>">

                <div class="d-flex justify-content-between">
                    <strong><%= n.getTitle() %></strong>
                    <span class="badge bg-success">
                        <%= n.getNotificationType() %>
                    </span>
                </div>

                <small class="text-secondary">
                    <%= n.getCreatedAt() %>
                </small>
            </div>

            <!-- MODAL -->
            <div class="modal fade"
                 id="notiModal<%= n.getNotificationId() %>"
                 tabindex="-1">

                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content bg-dark text-white">

                        <div class="modal-header">
                            <h5 class="modal-title">
                                <%= n.getTitle() %>
                            </h5>
                            <button type="button"
                                    class="btn-close btn-close-white"
                                    data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <p><%= n.getContent() %></p>
                            <small class="text-secondary">
                                <%= n.getCreatedAt() %>
                            </small>
                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-secondary"
                                    data-bs-dismiss="modal">
                                Đóng
                            </button>

                            <a href="notification-detail?id=<%= n.getNotificationId() %>"
                               class="btn btn-success">
                                Xem chi tiết →
                            </a>
                        </div>

                    </div>
                </div>
            </div>

        <% } %>

    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>