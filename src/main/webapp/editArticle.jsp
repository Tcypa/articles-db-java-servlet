<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="tcypa.FormHandlerServlet" %>
<%! JSONArray getArticles(String username, ServletContext servletContext) {
    return FormHandlerServlet.getArticles(username, servletContext);
} %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<%@ page import="java.nio.file.Paths" %>

<%
    String username = (String) session.getAttribute("username");
    String articleId = request.getParameter("articleId");
    JSONArray articlesArray = getArticles(username, getServletContext());

    JSONObject article = null;
    for (int i = 0; i < articlesArray.length(); i++) {
        JSONObject currentArticle = articlesArray.getJSONObject(i);
        if (currentArticle.getString("id").equals(articleId)) {
            article = currentArticle;
            break;
        }
    }

    if (article == null) {
        response.sendRedirect("error.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Редактирование статьи</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-tagsinput/0.8.0/bootstrap-tagsinput.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="css/index.css">
</head>
<body>

<div class="container mt-5">
    <h2>Редактирование статьи</h2>

    <form action="FormHandlerServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="editArticle">
        
        <div class="mb-3">
            <label for="author" class="form-label">Автор</label>
            <input type="text" class="form-control" id="author" name="author" value="<%= article.getString("author") %>" required>
        </div>
        
        <div class="mb-3">
            <label for="theme" class="form-label">Тема</label>
            <input type="text" class="form-control" id="theme" name="theme" value="<%= article.getString("theme") %>" required>
        </div>
        
        <div class="mb-3">
            <label for="tags" class="form-label">Теги</label>
            <input type="text" class="form-control" data-role="tagsinput" id="tags" name="tags" value="<%= article.getString("tags") %>">
        </div>
        
        <div class="mb-3">
            <label for="year" class="form-label">Год</label>
            <input type="text" class="form-control" id="year" name="year" value="<%= article.getString("year") %>" required>
        </div>
        
        <div class="mb-3">
            <label for="pdfFile" class="form-label">Выберите файл</label>
            <input type="file" class="form-control" id="pdfFile" name="pdfFile" accept=".pdf">
        </div>
        <input type="hidden" name="articleId" value="<%=articleId%>">
        <button type="submit" class="btn btn-primary">Сохранить</button>
    </form>
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
</body>
</html>
