<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Вход и регистрация</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/index.css">
</head>

<body style="background-color: #343a40; color: #ffffff; padding-top: 10px;">

    <div class="container-fluid mt-5">
        <div class="row justify-content-center">
            <div class="col-md-4 text-center">
                <h1>Вход</h1>
                <form action="logreg" method="login">
                    <div class="mb-3">
                        <label for="loginUsername" class="form-label">Логин:</label>
                        <input type="text" class="form-control" id="loginUsername" name="Username" required>
                    </div>
                    <div class="mb-3">
                        <label for="loginPassword" class="form-label">Пароль:</label>
                        <input type="password" class="form-control" id="loginPassword" name="Password" required>
                    </div>
                    <input type="hidden" name="action" value="login">
                    <button type="submit" class="btn btn-primary">Войти</button>
                </form>
            </div>

            <div class="col-md-4 text-center">
                <h1>Регистрация</h1>
                <form action="logreg" method="register">
                    <div class="mb-3">
                        <label for="registerUsername" class="form-label">Логин:</label>
                        <input type="text" class="form-control" id="registerUsername" name="Username" required>
                    </div>
                    <div class="mb-3">
                        <label for="registerPassword" class="form-label">Пароль:</label>
                        <input type="password" class="form-control" id="registerPassword" name="Password" required>
                    </div>
                    <input type="hidden" name="action" value="register">
                    <button type="submit" class="btn btn-success">Зарегестрироваться</button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
   <script>

    var successMessage = '<%= session.getAttribute("errorMessage") %>';
    if (successMessage && successMessage != "null") {

        alert(successMessage);
        <% session.removeAttribute("errorMessage"); %>
        <% session.invalidate(); %>
    }
</script>
</html>
