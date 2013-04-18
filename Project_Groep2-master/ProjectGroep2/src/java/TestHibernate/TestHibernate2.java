
package TestHibernate;
import hibernate.HibernateUtil;
import java.util.Iterator;
import java.util.List;
import mappingFilesAndPojo.Geregistreerdegebruikers;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class TestHibernate2 {
   public static void main(String[] args) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;
        try {
            Geregistreerdegebruikers recipe = new Geregistreerdegebruikers();
           
            transaction = session.beginTransaction();
            List recipes = session.createQuery("from Geregistreerdegebruikers").list();

            for (Iterator iterator = recipes.iterator(); iterator.hasNext();) {
                recipe = (Geregistreerdegebruikers) iterator.next();
                System.out.println(recipe.getGebrNaam()+ "   " + recipe.getGebrAdres());
            }
            transaction.commit();

            //recipe updaten
//            System.out.println("updaten van één recipe");
//            transaction = session.beginTransaction();
//            Integer id = new Integer(1);
//            recipe = (Recipe) session.get(Recipe.class, id);
//            recipe.setTaste("no");
//            session.update(recipe);
//            transaction.commit();

            //recipe deleten
//            System.out.println("delete van één recipe");
//            transaction = session.beginTransaction();
//            id = new Integer(1);
//            recipe = (Recipe) session.get(Recipe.class, id);
//            session.delete(recipe);
//            transaction.commit();

        } catch (HibernateException e) {
            transaction.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }

   } 
}
