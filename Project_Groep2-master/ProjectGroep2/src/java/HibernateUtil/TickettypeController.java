/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package HibernateUtil;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.model.DataModel;
import javax.faces.model.ListDataModel;

/**
 *
 * @author 3030254
 */

//Soms engelstalige variabelen/methoden omdat Netbeans fouten gaf bij het gebruiken van Nederlandstalige namen

@ManagedBean(name="TickettypeController")
@SessionScoped
public class TickettypeController {
    
    int startId;
    int eindId;
    DataModel ticketTypes;
    TicketTypeHelper helper;
    private int recordCount = 1000;
    private int pageSize = 10;

    private Tickettypes current;
    private int selectedItemIndex;

    /**
     * Creates a new instance of TickettypeController
     */
    public TickettypeController() {
        helper = new TicketTypeHelper();
        startId = 1;
        eindId = 10;
    }
    
     public TickettypeController(int startId, int endId) {
        helper = new TicketTypeHelper();
        this.startId = startId;
        this.eindId = endId;
    }

    public Tickettypes getSelected() {
        if (current == null) {
            current = new Tickettypes();
            selectedItemIndex = -1;
        }
        return current;
    }


    public DataModel getTicketTypes() {
        if (ticketTypes == null) {
            ticketTypes = new ListDataModel(helper.getTicketTypes(startId, eindId));
        }
        return ticketTypes;
    }

    void recreateModel() {
        ticketTypes = null;
    }
    
     public boolean isHasNextPage() {
        if (eindId + pageSize <= recordCount) {
            return true;
        }
        return false;
    }

    public boolean isHasPreviousPage() {
        if (startId-pageSize > 0) {
            return true;
        }
        return false;
    }

    public String next() {
        startId = eindId+1;
        eindId = eindId + pageSize;
        recreateModel();
        return "tickettypes";
    }

    public String previous() {
        startId = startId - pageSize;
        eindId = eindId - pageSize;
        recreateModel();
        return "tickettypes";
    }

    public int getPageSize() {
        return pageSize;
    }

    public String prepareView(){
        current = (Tickettypes) getTicketTypes().getRowData();
        return "blader2";
    }
    public String prepareList(){
        recreateModel();
        return "tickettypes";
    }
}
