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
@ManagedBean(name="GebruikerController")
@SessionScoped
public class GebruikerController {
    
    int startId;
    int eindId;
    DataModel gebruikerNamen;
    GebruikerHelper helper;
    private int recordTeller = 1000;
    private int pageSize = 10;

    private Geregistreerdegebruikers current;
    private int selectedItemIndex;

    /**
     * Creates a new instance of GebruikerController
     */
    public GebruikerController() {
        helper = new GebruikerHelper();
        startId = 1;
        eindId = 10;
    }
    
     public GebruikerController(int startId, int endId) {
        helper = new GebruikerHelper();
        this.startId = startId;
        this.eindId = endId;
    }

    public Geregistreerdegebruikers getSelected() {
        if (current == null) {
            current = new Geregistreerdegebruikers();
            selectedItemIndex = -1;
        }
        return current;
    }


    public DataModel getGebruikersNamen() {
        if (gebruikerNamen == null) {
            gebruikerNamen = new ListDataModel(helper.getGebruikersNamen(startId, eindId));
        }
        return gebruikerNamen;
    }

    void recreateModel() {
        gebruikerNamen = null;
    }
    
     public boolean isHasNextPage() {
        if (eindId + pageSize <= recordTeller) {
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
        return "gebruiker";
    }

    public String previous() {
        startId = startId - pageSize;
        eindId = eindId - pageSize;
        recreateModel();
        return "gebruiker";
    }

    public int getPageSize() {
        return pageSize;
    }

    public String prepareView(){
        current = (Geregistreerdegebruikers) getGebruikersNamen().getRowData();
        return "blader";
    }
    public String prepareList(){
        recreateModel();
        return "gebruiker";
    }
}
