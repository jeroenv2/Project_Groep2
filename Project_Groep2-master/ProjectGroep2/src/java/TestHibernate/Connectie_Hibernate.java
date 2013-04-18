package TestHibernate;

import hibernate.HibernateUtil;
import java.util.Iterator;
import java.util.List;
import mappingFilesAndPojo.Geregistreerdegebruikers;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class Connectie_Hibernate {

    public List maakConnectie(String url) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;
        List LijstGebruikers = null;
        try {
            transaction = session.beginTransaction();
            LijstGebruikers = session.createQuery(url).list();

            transaction.commit();

        } catch (HibernateException e) {
            transaction.rollback();
            e.printStackTrace();
        } finally {

            session.close();
            return LijstGebruikers;
        
        }
        
        

    }

   
}
