
package TestHibernate;
import hibernate.HibernateUtil;
import java.util.Iterator;
import java.util.List;
import mappingFilesAndPojo.Geregistreerdegebruikers;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class TestHibernate2 {
   static Connectie_Hibernate hibernate= new Connectie_Hibernate();
   public static void main(String[] args) {
  
         hibernate.maakConnectie("from Geregistreerdegebruikers");
}
}
