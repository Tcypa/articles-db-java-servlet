package tcypa;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@WebServlet("/FormHandlerServlet")
public class FormHandlerServlet extends HttpServlet {
    private static final String ARTICLE_FOLDER = "articles"; 
    private static final String JSON_FILE_PATH = ARTICLE_FOLDER + "/articles.json";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("text/html;charset=UTF-8");
    HttpSession session = request.getSession(false);
    String a_id = request.getParameter("articleId");
    
    String id = UUID.randomUUID().toString();
    
    System.out.println();
    if (a_id != null && !a_id.isEmpty()) {
         id = a_id;
         deleteArticle(id, getServletContext(), false);
    }

    if (ServletFileUpload.isMultipartContent(request)) {
        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);


            List<FileItem> items = upload.parseRequest(request);
            String author = null, theme = null, year = null, tags = null, fileName = null;

            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString("UTF-8");

                    switch (fieldName) {
                        case "author":
                            author = fieldValue;
                            break;
                        case "theme":
                            theme = fieldValue;
                            break;
                        case "year":
                            year = fieldValue;
                            break;
                        case "tags":
                            tags = fieldValue;
                            break;
                    }
                } else {

                    fileName = id + ".pdf";
                    if (a_id!=id){
                    File uploadedFile = new File(getServletContext().getRealPath(ARTICLE_FOLDER), fileName);
                    item.write(uploadedFile);
                    }
                    
                }
            }

            JSONObject articleJson = new JSONObject();
            articleJson.put("id", id);
            articleJson.put("author", author);
            articleJson.put("theme", theme);
            articleJson.put("tags", tags);
            articleJson.put("year", year);
            articleJson.put("fileName", fileName);
            articleJson.put("username", session.getAttribute("username"));


            JSONArray articlesArray;
            File jsonFile = new File(getServletContext().getRealPath(JSON_FILE_PATH));
            if (jsonFile.exists()) {
                String jsonContent = FileUtils.readFileToString(jsonFile, "UTF-8");
                articlesArray = new JSONArray(jsonContent);
            } else {
                articlesArray = new JSONArray();
            }


            articlesArray.put(articleJson);


            FileUtils.writeStringToFile(jsonFile, articlesArray.toString(), "UTF-8");


            session.setAttribute("successMessage", "Статья успешно добавлена!");
            response.sendRedirect("index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Ошибка при обработке запроса.");
        }
    } else {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Запрос не содержит файлов.");
    }
}

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");
    String articleId = request.getParameter("articleId");
    if ("deleteArticle".equals(action) && articleId != null) {
        deleteArticle(articleId, getServletContext(), true);
        response.sendRedirect("index.jsp");
        return;
    }

}
    public static JSONArray getArticles(String username, ServletContext servletContext) {
        final File jsonFile = new File(servletContext.getRealPath(JSON_FILE_PATH));
    
        try {
            if (jsonFile.exists()) {
                String jsonContent = FileUtils.readFileToString(jsonFile, "UTF-8");
                JSONArray allArticles = new JSONArray(jsonContent);
                JSONArray userArticles = new JSONArray();
    

                for (int i = 0; i < allArticles.length(); i++) {
                    JSONObject article = allArticles.getJSONObject(i);
                    if (username.equals(article.getString("username"))) {
                        userArticles.put(article);
                    }
                }
    
                return userArticles;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    
        return new JSONArray();
    }

public static JSONArray searchArticles(String author, String year, String tags, String theme, ServletContext servletContext) {
    final File jsonFile = new File(servletContext.getRealPath(JSON_FILE_PATH));

    try {
        if (jsonFile.exists()) {
            String jsonContent = FileUtils.readFileToString(jsonFile, "UTF-8");
            JSONArray allArticles = new JSONArray(jsonContent);


            JSONArray searchResults = new JSONArray();
            for (int i = 0; i < allArticles.length(); i++) {
                JSONObject article = allArticles.getJSONObject(i);


                if ((author == null || author.isEmpty() || article.getString("author").contains(author))
                        && (year == null || year.isEmpty() || article.getString("year").contains(year))
                        && (tags == null || tags.isEmpty() ||  areAllElementsPresent(article.getString("tags"),tags))
                        && (theme == null || theme.isEmpty() || article.getString("theme").contains(theme))) {
                    searchResults.put(article);
                }
            }

            return searchResults;
        }
    } catch (IOException e) {
        e.printStackTrace();
    }

    return new JSONArray();
}
public static void deleteArticle(String articleId, ServletContext servletContext,boolean deletefile) {
    final File jsonFile = new File(servletContext.getRealPath(JSON_FILE_PATH));

    try {
        if (jsonFile.exists()) {
            String jsonContent = FileUtils.readFileToString(jsonFile, "UTF-8");
            JSONArray articlesArray = new JSONArray(jsonContent);


            for (int i = 0; i < articlesArray.length(); i++) {
                JSONObject article = articlesArray.getJSONObject(i);
                if (article.getString("id").equals(articleId)) {
                    if(deletefile){
                    File fileToDelete = new File(servletContext.getRealPath(ARTICLE_FOLDER) + article.getString("fileName"));
                    fileToDelete.delete();    
                    }
                    
                    articlesArray.remove(i);
                    break;
                }
            }


            FileUtils.writeStringToFile(jsonFile, articlesArray.toString(), "UTF-8");
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}
private static boolean areAllElementsPresent(String allTags, String Tags) {
        List<String> all = Arrays.asList(allTags.split(","));
        List<String> notAll = Arrays.asList(Tags.split(","));

        return all.containsAll(notAll);
}

}
