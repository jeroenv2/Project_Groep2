/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package HibernateUtil;

import java.util.List;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author 3030254
 */
public class GebruikerHelper {
    Session session = null;

    public GebruikerHelper() {
        this.session = HibernateUtil.getSessionFactory().getCurrentSession();
    }
    
    public List getGebruikersNamen(int startID, int endID) {
    List<Geregistreerdegebruikers> gebruikerslijst = null;
    try {
        org.hibernate.Transaction tx = session.beginTransaction();
        Query q;
        q = session.createQuery ("from Geregistreerdegebruikers as gebruiker where gebruiker.gebrId between '"+startID+"' and '"+endID+"'");
        gebruikerslijst = (List<Geregistreerdegebruikers>) q.list();
    } catch (Exception e) {
    }
    return gebruikerslijst;
}
}
