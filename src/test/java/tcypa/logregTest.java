package tcypa;

import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

public class logregTest {

    private HttpServletRequest request = mock(HttpServletRequest.class);

    private HttpServletResponse response = mock(HttpServletResponse.class);

    private HttpSession session = mock(HttpSession.class);

    private logreg logreg = mock(logreg.class);

    @Before
    public void setUp() {
        when(request.getSession(true)).thenReturn(session);
    }

    @Test
    public void testDoGet_Register() throws Exception {
        String testuser = "testuser";
        String testpassword = "testpassword";
        when(request.getParameter("action")).thenReturn("register");
        when(request.getParameter("Username")).thenReturn("testuser");
        when(request.getParameter("Password")).thenReturn("testpassword");
        List<User> users = new ArrayList<>();
        users.add(new User(testuser, testpassword));
        when(logreg.isUserAlreadyRegistered(users, eq("testuser"))).thenReturn(false);

        when(response.getWriter()).thenReturn(new PrintWriter(new StringWriter()));

        logreg.doGet(request, response);
    }

    @Test
    public void testDoGet_Login() throws Exception {
        when(request.getParameter("action")).thenReturn("login");
        when(request.getParameter("Username")).thenReturn("testuser");
        when(request.getParameter("Password")).thenReturn("testpassword");

        when(logreg.isUserPassValid(anyList(), eq("testuser"), eq("testpassword"))).thenReturn(true);

        when(response.getWriter()).thenReturn(new PrintWriter(new StringWriter()));

        logreg.doGet(request, response);

    }

}
