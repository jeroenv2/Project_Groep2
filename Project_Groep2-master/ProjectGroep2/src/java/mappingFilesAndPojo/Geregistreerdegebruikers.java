package mappingFilesAndPojo;
// Generated Apr 18, 2013 10:32:58 AM by Hibernate Tools 3.2.1.GA


import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Geregistreerdegebruikers generated by hbm2java
 */
@Entity
@Table(name="geregistreerdegebruikers"
    ,catalog="groep2_festivals"
)
public class Geregistreerdegebruikers  implements java.io.Serializable {


     private Integer gebrId;
     private String gebrNaam;
     private String gebrAdres;
     private String gebrWachtwoord;
     private Date gebrGebDat;

    public Geregistreerdegebruikers() {
    }

    public Geregistreerdegebruikers(String gebrNaam, String gebrAdres, String gebrWachtwoord, Date gebrGebDat) {
       this.gebrNaam = gebrNaam;
       this.gebrAdres = gebrAdres;
       this.gebrWachtwoord = gebrWachtwoord;
       this.gebrGebDat = gebrGebDat;
    }
   
     @Id @GeneratedValue(strategy=IDENTITY)
    
    @Column(name="gebr_id", unique=true, nullable=false)
    public Integer getGebrId() {
        return this.gebrId;
    }
    
    public void setGebrId(Integer gebrId) {
        this.gebrId = gebrId;
    }
    
    @Column(name="gebr_naam", nullable=false)
    public String getGebrNaam() {
        return this.gebrNaam;
    }
    
    public void setGebrNaam(String gebrNaam) {
        this.gebrNaam = gebrNaam;
    }
    
    @Column(name="gebr_adres", nullable=false)
    public String getGebrAdres() {
        return this.gebrAdres;
    }
    
    public void setGebrAdres(String gebrAdres) {
        this.gebrAdres = gebrAdres;
    }
    
    @Column(name="gebr_wachtwoord", nullable=false)
    public String getGebrWachtwoord() {
        return this.gebrWachtwoord;
    }
    
    public void setGebrWachtwoord(String gebrWachtwoord) {
        this.gebrWachtwoord = gebrWachtwoord;
    }
    @Temporal(TemporalType.DATE)
    @Column(name="gebr_gebDat", nullable=false, length=10)
    public Date getGebrGebDat() {
        return this.gebrGebDat;
    }
    
    public void setGebrGebDat(Date gebrGebDat) {
        this.gebrGebDat = gebrGebDat;
    }




}


