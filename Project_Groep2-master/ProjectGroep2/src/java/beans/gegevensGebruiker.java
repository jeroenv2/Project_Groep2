package beans;

import java.util.Date;

/**
 *
 * @author Steven Verheyen
 */
public class gegevensGebruiker
{
    String gebruikersnaam, paswoord, adres;
    Date geboorteDatum;
    
    public gegevensGebruiker()
    {
    }
    
    public void setGebruikersnaam(String gebruikersnaam)
    {
        this.gebruikersnaam = gebruikersnaam;
    }
    public void setPaswoord(String paswoord)
    {
        this.paswoord = paswoord;
    }
    public void setAdres(String adres)
    {
        this.adres = adres;
    }
    public void setGeboorteDatum(Date geboorteDatum)
    {
        this.geboorteDatum = geboorteDatum;
    }
    
    public String getGebruikersnaam()
    {
        return gebruikersnaam;
    }
    public String getPaswoord()
    {
        return paswoord;
    }
    public String getAdres()
    {
        return adres;
    }
    public Date getGeboorteDatum()
    {
        return geboorteDatum;
    }
}