package Databank;

import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.List;

public class Connectie_Databank
{
    //Eigenschappen databank
    private String connectieString = "";
    private Connection connectie = null;
    private Statement statement = null;
    private ResultSet inhoudQuery = null;
    
    //Inloggegevens PhpMyAdmin
    private String gebruikersnaam = "root", wachtwoord = ""; //Standaardinstellingen van XAMPP
    
    //Constructor voor enkel de connection string en query
    public Connectie_Databank(String connectionString)
    {
        this.connectieString = connectionString;
    }
    
    //Constructor om een andere gebruikersnaam en wachtwoord te gebruiken
    public Connectie_Databank(String connectionString, String gebruikersnaam, String wachtwoord)
    {
        this.connectieString = connectionString;
        this.gebruikersnaam = gebruikersnaam;
        this.wachtwoord = wachtwoord;
    }
    
    public void maakConnectie()
    {
        try
        {
            connectie = DriverManager.getConnection(connectieString, gebruikersnaam, wachtwoord);
            statement = connectie.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        }
        catch(Exception e)
        {
            System.err.println(e.getMessage()); //Later verwijderen en gepaste meldingen en wijze van boodschap tonen
        }
    }
    
    public void voerQueryUit(String query, List<String> parameters)
    {
        try
        {
            //Reden preparedStatement: geen SQL-Injectie!
            
        }
        catch(Exception e)
        {
            System.err.println(e.getMessage()); //Later verwijderen en gepaste meldingen en wijze van boodschap tonen
        }
    }
}