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
public class TicketTypeHelper {
    
    Session session = null;

    public TicketTypeHelper() {
        this.session = HibernateUtil.getSessionFactory().getCurrentSession();
    }
    
    public List getTicketTypes(int startID, int eindID) {
    List<Tickettypes> ticketList = null;
    try {
        org.hibernate.Transaction tx = session.beginTransaction();
        Query q = session.createQuery ("from Tickettypes as tickettype where tickettype.typId between '"+startID+"' and '"+eindID+"'");
        ticketList = (List<Tickettypes>) q.list();
    } catch (Exception e) {
    }
    return ticketList;
}
    
    
}
