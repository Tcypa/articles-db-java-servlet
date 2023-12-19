<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="tcypa.FormHandlerServlet" %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Добавление новой статьи</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-tagsinput/0.8.0/bootstrap-tagsinput.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="css/index.css">
</head>

<body style="background-color: #343a40;">

    <div class="container mt-5">
        <h2 class="text-center text-white">Добавление новой статьи</h2>
        <form action="FormHandlerServlet" method="post" enctype="multipart/form-data">
            <div class="mb-3">
                <label for="author" class="form-label text-white">Автор</label>
                <input type="text" class="form-control" id="author" name="author" required>
            </div>
            <div class="mb-3">
                <label for="theme" class="form-label text-white">Тема</label>
                <input type="text" class="form-control" id="theme" name="theme" required>
            </div>
            <div class="mb-3" id="tags-container">
                <label for="tags" class="form-label text-white">Теги</label>
                <input type="text" class="form-control" data-role="tagsinput" id="tags" name="tags" />
            </div>
            <div class="mb-3">
                <label for="year" class="form-label text-white">Год выпуска</label>
                <input type="text" class="form-control" id="year" name="year" required>
            </div>
            <div class="mb-3">
                <label for="pdfFile" class="form-label text-white">Выберите PDF файл</label>
                <input type="file" class="form-control" id="pdfFile" name="pdfFile" accept=".pdf" required>
            </div>
            <input type="hidden" name="articleId" value=null>
            <input type="hidden" name="redirectPage" value="index.jsp">
            <button type="submit" class="btn btn-primary">Отправить</button>
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
