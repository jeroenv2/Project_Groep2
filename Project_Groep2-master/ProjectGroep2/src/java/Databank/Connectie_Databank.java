package Databank;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

public class Connectie_Databank
{
    //Eigenschappen databank
    private String connectieString = "";
    private Connection connectie = null;
    private PreparedStatement prepStatement = null;
    private Statement statement = null;
    private ResultSet inhoudQuery = null;
    
    //Inloggegevens PhpMyAdmin
    private String gebruikersnaam, wachtwoord;
    
    //Constructor met standaardinstellingen
    public Connectie_Databank()
    {
        this.connectieString = "jdbc:mysql://localhost/groep2_festivals";
        this.gebruikersnaam = "root";
        this.wachtwoord = "";
    }
    
    //Constructor met nieuwe data
    public Connectie_Databank(String connectionString, String gebruikersnaam, String wachtwoord)
    {
        this.connectieString = connectionString;
        this.gebruikersnaam = gebruikersnaam;
        this.wachtwoord = wachtwoord;
    }
    
    /**
     * Deze methode zorgt ervoor dat er verbinding gemaakt wordt me de databank
     * @throws SQLException
     * @throws Exception 
     */
    public void maakConnectie() throws SQLException, Exception
    {
        try
        {
            Class.forName("com.mysql.jdbc.Driver");
            connectie = DriverManager.getConnection(connectieString, gebruikersnaam, wachtwoord);
        } catch (SQLException se) {
            System.err.println("VERBINDING MAKEN [SQL]: ");
            throw se;
        } catch(Exception e) {
            System.err.println("VERBINDING MAKEN [ONBEKEND]: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Deze functie haalt gegevens op uit de database aan de hand van de opgegeven query.
     * @param query
     * @param parameters 
     */
    public void voerQueryUit(String query, List<String> parameters) throws IllegalArgumentException, SQLException, Exception
    {
        try
        {
            if(parameters.size() > 0)
            {
                //Reden preparedStatement: geen SQL-Injectie!
                prepStatement = connectie.prepareStatement(query);

                //Lijst met parameters uitlezen om de preparedStatement op te vullen
                for(int i=1; i<=parameters.size(); i++)
                {
                   prepStatement.setString(i, parameters.get(i-1));
                }
                inhoudQuery = prepStatement.executeQuery();
            }
            else
            {
                statement = connectie.createStatement();
                inhoudQuery = statement.executeQuery(query);
            }
        } catch(IllegalArgumentException ia) {
            System.err.println("CONNECTIEKLASSE [ARGUMENTEN]: ");
            ia.printStackTrace();
            throw ia;
        } catch(SQLException se) {
            System.err.println("CONNECTIEKLASSE [SQL]: ");
            se.printStackTrace();
            throw se;
        } catch(Exception e) {
            System.err.println("CONNECTIEKLASSE [ONBEKEND]: ");
            e.printStackTrace();
            throw e;
        }
    }
    
    public void voerVeranderingUit(String query, List<String> parameters) throws IllegalArgumentException, SQLException, Exception
    {
        try
        {
            if(parameters.size() > 0)
            {
                //Reden preparedStatement: geen SQL-Injectie!
                prepStatement = connectie.prepareStatement(query);

                //Lijst met parameters uitlezen om de preparedStatement op te vullen
                for(int i=1; i<=parameters.size(); i++)
                {
                   prepStatement.setString(i, parameters.get(i-1));
                }
                prepStatement.executeUpdate();
            }
            else
            {
                statement = connectie.createStatement();
                statement.executeUpdate(query);
            }
        } catch(IllegalArgumentException ia) {
            System.err.println("VERANDERQUERY [ARGUMENTEN]: ");
            ia.printStackTrace();
            throw ia;
        } catch(SQLException se) {
            System.err.println("VERANDERQUERY [SQL]: ");
            se.printStackTrace();
            throw se;
        } catch(Exception e) {
            System.err.println("VERANDERQUERY [ONBEKEND]: ");
            e.printStackTrace();
            throw e;
        }
    }
    
    public int veranderQuery(String query, List<String> parameters) throws IllegalArgumentException, SQLException, Exception
    {
        int aantalUpdates = 0;
        try {
            if(parameters.size() > 0) {
                //Reden preparedStatement: geen SQL-Injectie!
                prepStatement = connectie.prepareStatement(query);

                //Lijst met parameters uitlezen om de preparedStatement op te vullen
                for(int i=1; i<=parameters.size(); i++)
                {
                   prepStatement.setString(i, parameters.get(i-1));
                }
                
                aantalUpdates = prepStatement.executeUpdate(); 
            }
        } catch(IllegalArgumentException ia) {
            System.err.println("VERANDERQUERY MET RESULTAAT [ARGUMENTEN]:");
            ia.printStackTrace();
            throw ia;
        } catch(SQLException se) {
            System.err.println("VERANDERQUERY MET RESULTAAT [SQL]:");
            se.printStackTrace();
            throw se;
        } catch(Exception e) {
            System.err.println("VERANDERQUERY MET RESULTAAT [ONBEKEND]:");
            e.printStackTrace();
            throw e;
        }
        finally
        {
            return aantalUpdates;
        }
    }
    
    public ResultSet haalResultSetOp()
    {
        return inhoudQuery;
    }
    
    /**
     * Deze functie sluit alle connectiegegevens af zodat deze uit het geheugen verdwijnen.
     */
    public void sluitConnectie() throws SQLException, Exception
    {
        //ConnectieString leegmaken en alle objecten die te maken hebben met de connectie sluiten
        try
        {
            if(connectie != null)
            {
                connectie.close();
            }
            if(prepStatement != null)
            {
                prepStatement.close();
            }
            if(inhoudQuery != null)
            {
                inhoudQuery.close();
            }
            connectie = null;
            statement = null;
            prepStatement = null;
            inhoudQuery = null;
        } catch(SQLException se) {
            System.err.println("SLUIT CONNECTIE [SQL]:");
            se.printStackTrace();
            throw se;
        } catch(Exception e) {
            System.err.println("SLUIT CONNECTIE [ONBEKEND]:");
            e.printStackTrace();
            throw e;
        }
    }
}
