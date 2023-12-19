<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="tcypa.FormHandlerServlet" %>
<%@ page import= "javax.servlet.http.HttpSession"%>
<%@ page import="org.apache.commons.io.IOUtils" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Доска объявлений</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-tagsinput/0.8.0/bootstrap-tagsinput.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="css/index.css">
</head>

<body style="background-color: #343a40; color: #ffffff; padding-top: 5px;">

    <div id="header" class="text-center mt-4">
        <h1>Каталог Статей</h1>
    </div>

    <div id="loginContainer" class="container mt-5">
        <div class="row justify-content-center">
            <%
                if (session != null && session.getAttribute("userLoggedIn") != null) {
            %> 
            <div class="col-md-6 text-center">
                <h1>Добро пожаловать, <%= session.getAttribute("username") %>!</h1>
            </div>

            <div class="col-md-6 text-center">
                <a href="addArticle.jsp" class="btn btn-primary " id = "exbt">Добавить статью</a>
                <a href="viewArticles.jsp" class="btn btn-info" id = "exbt">Мои статьи</a>
                <form action="<%= request.getContextPath() %>/index.jsp" method="post">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="btn btn-secondary" id = "exbt">Выйти</button>
                </form>
            </div>

            <%
                } else {
            %>
            <div class="col-md-12 text-center">
                <a href="login.jsp" class="btn btn-success">Перейти на страницу регистрации и входа</a>
            </div>
            <%
                }
            %>
        </div>
         <%
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            if (session != null) {
                session.setAttribute("userLoggedIn",null);
                response.sendRedirect("index.jsp");
            }
        }
    %>
    </div>
     <div class="container mt-5">
        <h2 class="text-center">Поиск статьи</h2>
        <form action="<%= request.getContextPath() %>/index.jsp" method="post">
            <div class="mb-3">
                <label for="author" class="form-label text-white">Автор</label>
                <input type="text" class="form-control" id="author" name="author">
            </div>
            <div class="mb-3">
                <label for="year" class="form-label text-white">Год выпуска</label>
                <input type="text" class="form-control" id="year" name="year">
            </div>
            <div class="mb-3">
                <label for="theme" class="form-label text-white">Тема</label>
                <input type="text" class="form-control" id="theme" name="theme">
            </div>
            <div class="mb-3" id="tags-container">
                <label for="tags" class="form-label text-white">Теги</label>
                <input type="text" class="form-control" data-role="tagsinput" id="tags2" name="tags" />
            </div>
            <button type="submit" class="btn btn-primary">Искать</button>
        </form>
    </div>

    <% 
        String searchAuthor = request.getParameter("author");
        String searchYear = request.getParameter("year");
        String searchTags = request.getParameter("tags");
        String searchTheme = request.getParameter("theme");

        JSONArray searchResults = FormHandlerServlet.searchArticles(searchAuthor, searchYear, searchTags,searchTheme, request.getServletContext());
    %>

    <% if (searchResults != null && searchResults.length() > 0) { %>
    <div class="container mt-5">
        <h2 class="text-center">Результаты поиска</h2>
        <ul class="list-group">
            <% for (int i = 0; i < searchResults.length(); i++) { %>
            <li class="list-group-item">
                <strong class="text-dark">Автор:</strong> <%= searchResults.getJSONObject(i).getString("author") %><br>
                <strong class="text-dark">Тема:</strong> <%= searchResults.getJSONObject(i).getString("theme") %><br>
                <strong class="text-dark">Теги:</strong> <%= searchResults.getJSONObject(i).getString("tags") %><br>
                <strong class="text-dark">Год выпуска:</strong> <%= searchResults.getJSONObject(i).getString("year") %><br>
                <form action="article.jsp" method="post">
                    <input type="hidden" name="articleId" value="<%= searchResults.getJSONObject(i).getString("id") %>">
                    <button type="submit" class="btn btn-link">Просмотреть PDF</button>
                </form>
                <hr>
            </li>
            <% } %>
        </ul>
    </div>
    <% } else { %>
    <div class="container mt-5">
        <p class="text-white">Нет результатов поиска.</p>
    </div>
    <% } %>


    <div id="footer" class="text-center mt-5">
        &copy; 2023 Паршин Владимир
    </div>

   
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.0/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-tagsinput/0.8.0/bootstrap-tagsinput.min.js"></script>
    <script>
        $(function () {
            $('input')
                .on('change', function (event) {
                    var $element = $(event.target);
                    var $container = $element.closest('.example');

                    if (!$element.data('tagsinput')) return;

                    var val = $element.val();
                    if (val === null) val = 'null';
                    var items = $element.tagsinput('items');

                    $('code', $('pre.val', $container)).html(
                        $.isArray(val) ? JSON.stringify(val) : '"' + val.replace('"', '\\"') + '"'
                    );
                    $('code', $('pre.items', $container)).html(
                        JSON.stringify($element.tagsinput('items'))
                    );
                })
                .trigger('change');
        });
    </script>
<script>
    <% 
        if (session != null) {
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null && !successMessage.equals("null")) {
    %>
                var successMessage = '<%= successMessage %>';
                alert(successMessage);
                <% session.removeAttribute("successMessage"); %>
    <% 
            }
        }
    %>
</script>
</body>

</html>
