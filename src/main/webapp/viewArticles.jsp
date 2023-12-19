<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="tcypa.FormHandlerServlet" %>
<%! JSONArray getArticles(String username,ServletContext servletContext) {
    return FormHandlerServlet.getArticles(username,servletContext);
} %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Статьи</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/index.css">
</head>

<body style="background-color: #343a40; color: #ffffff; padding-top: 56px;">

    <div class="container mt-5">
        <h2 class="text-center text-light">Все ваши статьи</h2>

        <%
             String username = (String) session.getAttribute("username");
            ServletContext servletContext = request.getServletContext();
            JSONArray articlesArray = getArticles(username,servletContext); 
        %>

        <% if (articlesArray != null && articlesArray.length() > 0) { %>
        <div class="container mt-5">
            <ul class="list-group">
                <% for (int i = 0; i < articlesArray.length(); i++) { %>
                <li class="list-group-item">
                    <strong class="text-dark">Автор:</strong> <%= articlesArray.getJSONObject(i).getString("author") %><br>
                    <strong class="text-dark">Тема:</strong> <%= articlesArray.getJSONObject(i).getString("theme") %><br>
                    <strong class="text-dark">Теги:</strong> <%= articlesArray.getJSONObject(i).getString("tags") %><br>
                    <strong class="text-dark">Год выпуска:</strong> <%= articlesArray.getJSONObject(i).getString("year") %><br>
                    <form action="article.jsp" method="post">
                        <input type="hidden" name="articleId" value="<%= articlesArray.getJSONObject(i).getString("id") %>">
                        <button type="submit" class="btn btn-link">Просмотреть PDF</button>
                    </form>
                    <form action="editArticle.jsp" method="post">
                        <input type="hidden" name="articleId" value="<%= articlesArray.getJSONObject(i).getString("id") %>">
                        <button type="submit" class="btn btn-primary">Редактировать статью</button>
                    </form>
                    <form action="FormHandlerServlet" method="get" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="deleteArticle">
                        <input type="hidden" name="articleId" value="<%= articlesArray.getJSONObject(i).getString("id") %>">
                        <button type="submit" class="btn btn-danger">Удалить статью</button>
                    </form>
                    
                    <hr>
                </li>
                <% } %>
            </ul>
        </div>
        <% } else { %>
        <p class="text-white">Нет добавленных статей.</p>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>

