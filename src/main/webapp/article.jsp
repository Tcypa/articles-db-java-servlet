<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.nio.file.Path" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="tcypa.FormHandlerServlet" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>PDF</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/index.css">
</head>
<body>

<div class="container mt-5">
    <h2>Просмотр PDF</h2>

    <% 
        String searchAuthor = "";
        String searchYear = "";
        String searchTags = "";
        String searchTheme = "";
        String articleId = request.getParameter("articleId");
        JSONArray articlesArray = FormHandlerServlet.searchArticles(searchAuthor, searchYear, searchTags,searchTheme, request.getServletContext());

        if (articleId != null && articlesArray != null) {
            for (int i = 0; i < articlesArray.length(); i++) {
                JSONObject article = articlesArray.getJSONObject(i);
                if (articleId.equals(article.getString("id"))) {
                    String pdfFileName = article.getString("fileName");
    %>
                    <embed src="<%= request.getContextPath() + "/articles/" + pdfFileName %>" type="application/pdf" width="100%" height="1200px" />
    <%
                    break;
                }
            }
        } else {
    %>
            <p>Неверные параметры запроса.</p>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
