package tcypa;

import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

public class FormHandlerServletTest {

    private HttpServletRequest request = mock(HttpServletRequest.class);

    private HttpServletResponse response = mock(HttpServletResponse.class);

    private HttpSession session = mock(HttpSession.class);

    private FormHandlerServlet formHandlerServlet = mock(FormHandlerServlet.class);

    @Before
    public void setUp() {
        when(request.getSession(false)).thenReturn(session);

    }

    @Test
    public void testDoPost() throws Exception {

        when(request.getParameter("articleId")).thenReturn("123");
        when(request.getParameter("author")).thenReturn("John Doe");
        when(request.getParameter("theme")).thenReturn("Test Theme");
        when(request.getParameter("year")).thenReturn("2023");
        when(request.getParameter("tags")).thenReturn("tag1,tag2");

        when(ServletFileUpload.isMultipartContent(request)).thenReturn(true);

        when(session.getAttribute("username")).thenReturn("testuser");

        when(response.getWriter()).thenReturn(new PrintWriter(new StringWriter()));

        formHandlerServlet.doPost(request, response);
    }

}
