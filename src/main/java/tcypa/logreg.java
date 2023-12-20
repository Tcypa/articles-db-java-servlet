package tcypa;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.*;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "logreg", urlPatterns = { "/logreg" })
public class logreg extends HttpServlet {
    private List<User> users;
    private static final long serialVersionUID = 1L;
    private static final String JSON_FILE_PATH = "userdata.json";

    public void init() throws ServletException {
        users = getUsersFromJson();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String username = request.getParameter("Username");
        String password = request.getParameter("Password");
        HttpSession session = request.getSession(true);
        if ("register".equals(action)) {

            if (!isUserAlreadyRegistered(users, username)) {
                users.add(new User(username, password));
                writeUsersToJson(users);
                session.setAttribute("successMessage", "Успешная регистрация");
                session.setAttribute("username", username);
                session.setAttribute("userLoggedIn", true);
                response.sendRedirect("index.jsp");
            } else {
                session.setAttribute("errorMessage", "Пользователь уже существует");
                response.sendRedirect("login.jsp");

            }
        } else if ("login".equals(action)) {
            if (isUserPassValid(users, username, password)) {
                session.setAttribute("username", username);
                session.setAttribute("userLoggedIn", true);
                response.sendRedirect("index.jsp");
            } else {
                session.setAttribute("errorMessage", "Неправильный логин или пароль, попробуйте снова");
                response.sendRedirect("login.jsp");
            }
        }
    }

    private List<User> getUsersFromJson() {
        List<User> users = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(getServletContext().getRealPath(JSON_FILE_PATH)))) {
            Gson gson = new Gson();
            Type userListType = new TypeToken<ArrayList<User>>() {
            }.getType();
            users = gson.fromJson(br, userListType);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return users;
    }

    private void writeUsersToJson(List<User> users) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(getServletContext().getRealPath(JSON_FILE_PATH)))) {
            Gson gson = new Gson();
            gson.toJson(users, bw);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    boolean isUserAlreadyRegistered(List<User> users, String username) {
        for (User user : users) {
            if (username.equals(user.getUsername())) {
                return true;
            }
        }
        return false;
    }

    boolean isUserPassValid(List<User> users, String username, String password) {
        for (User user : users) {
            if (username.equals(user.getUsername())) {
                return true;
            }
        }
        return false;
    }
}
