package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Steven Verheyen
 */
public class inlog extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try
        {
            Databank.Connectie_Databank connectie = new Databank.Connectie_Databank();
            connectie.maakConnectie();

            String query = "SELECT * FROM geregistreerdegebruikers WHERE gebr_naam = ? AND gebr_wachtwoord = ?";
            List<String> lijstParams = new ArrayList<String>();
            lijstParams.add(request.getParameter("gebruikersnaam"));
            lijstParams.add(request.getParameter("paswoord"));
            
            connectie.voerQueryUit(query, lijstParams);
            ResultSet res = connectie.haalResultSetOp();
            
            out.println("<!DOCTYPE html>");
            out.println("<html>");
                out.println("<head>");
                out.println("<title>Inlog</title>");            
                out.println("</head>");
                out.println("<body>");
                    out.println("<div id='page_wrapper'>");
                        request.getRequestDispatcher("/header.jsp").include(request, response); 
                        request.getRequestDispatcher("/navigation.jsp").include(request, response); 
                        out.println("<div id='content_wrapper'>");
                            out.println("<section id='content'>");
                                out.println("<div id='ElementenCenter'>");
                                    out.println("<div id='TekstCenter'>");

                                        res.last();
                                        int lengteResultSet = res.getRow(); //Lengte van de ResultSet opvragen
                                        if(lengteResultSet > 0)
                                        {
                                            out.println("<h1>U bent met succes ingelogd!</h1>");
                                            out.println("Klik <a href='index.jsp'>hier</a> om naar de hoofdpagina te gaan");
                                            
                                            //Verder uitwerken naar JavaBean...
                                        }
                                        else
                                        {
                                            out.println("<h2>U hebt verkeerde inloggegevens ingegeven</h2>");
                                            out.println("Klik <a href='index.jsp'>hier</a> om naar de hoofdpagina te gaan");
                                        }

                                        out.println("</div>");
                                    out.println("</div>");
                            out.println("</section>");
                        out.println("</div>");
                        out.println("<hr style='width: auto; margin-left: 20px; margin-right: 20px;' />");
                        request.getRequestDispatcher("/footer.jsp").include(request, response);
                     out.println("</div>");
                out.println("</body>");
            out.println("</html>");
        } 
        catch(Exception e)
        {
            out.println("Fout: " + e.getMessage());
        }
        finally
        {            
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}