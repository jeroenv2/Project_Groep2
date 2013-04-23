package testHibernate;
import HibernateUtil.HibernateUtil;
import java.util.Iterator;
import java.util.List;
import MappingFilesAndPojo.Geregistreerdegebruikers;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class TestHibernate2 {
   static Connectie_Hibernate hibernate= new Connectie_Hibernate();
   public static void main(String[] args) {
  
      List lijst  = hibernate.maakConnectie("from Geregistreerdegebruikers");
      
      for(int i=0;i<lijst.size();i++){
          Geregistreerdegebruikers gebruiker= (Geregistreerdegebruikers) lijst.get(i);
          System.out.println(gebruiker.getGebrNaam());
          System.out.println(gebruiker.getGebrAdres());
          System.out.println(gebruiker.getGebrGebDat());
         
      }
}
}
