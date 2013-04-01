package Databank;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

public class Connectie_Databank
{
    //Eigenschappen databank
    private String connectieString = "";
    private Connection connectie = null;
    private PreparedStatement prepStatement = null;
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
            prepStatement = connectie.prepareStatement(query);
            
            //Lijst met parameters uitlezen om de preparedStatement op te vullen
            for(int i=1; i<=parameters.size(); i++)
            {
                prepStatement.setString(i, parameters.get(i));
            }
            
            inhoudQuery = prepStatement.executeQuery();
        }
        catch(Exception e)
        {
            System.err.println(e.getMessage()); //Later verwijderen en gepaste meldingen en wijze van boodschap tonen
        }
    }
    
    public void sluitConnectie()
    {
        connectieString = "";
        connectie = null;
        prepStatement = null;
        inhoudQuery = null;
    }
}