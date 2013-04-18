/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package beans;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;

/**
 *
 * @author Robbie Vercammen
 */
@ManagedBean(name="datum")
@RequestScoped
public class datumBean {
    private String strBegin, strEind;
    private Date dtBegin, dtEind;
    private Calendar calBegin, calEind;
    private DateFormat formatter = new SimpleDateFormat("yyyy-mm-dd"); //Gebruikt om een String in een Date object te plaatsen

    public datumBean() {
    }

    public Calendar getCalBegin() {
        return calBegin;
    }

    public void setCalBegin(Calendar calBegin) {
        this.calBegin = calBegin;
    }

    public Calendar getCalEind() {
        return calEind;
    }

    public void setCalEind(Calendar calEind) {
        this.calEind = calEind;
    }

    public String getStrBegin() {
        return strBegin;
    }

    public void setStrBegin(String strBegin) {
        this.strBegin = strBegin;
    }

    public String getStrEind() {
        return strEind;
    }

    public void setStrEind(String strEind) {
        this.strEind = strEind;
    }    
    
    /**
     * Berekend de duur tussen de twee data van deze instantie.
     * @return De duur in type long tussen twee data.
     * @throws ParseException, IllegalArgumentException
     */
    public long getDuur() throws ParseException {
        try {
            if (calBegin == null) {
                maakKalenders(strBegin, strEind);
            }
            long lMiliBegin = calBegin.getTimeInMillis();
            long lMiliEind = calEind.getTimeInMillis();
            long lDiff = lMiliEind - lMiliBegin;
            long lDuur = lDiff / (24 * 60 * 60 * 1000);
            return lDuur;
        } catch (IllegalArgumentException ia) {
            throw ia;
        } catch (ParseException pe) {
            throw pe;
        }
    }
    
    /**
     * Controleert of een ingegeven datum gelegen is tussen de begindatum en einddatum.
     * Als dit niet het geval is, wordt een standaardexception opgegooid.
     * @param strDatum
     * @return Resultaat in boolean
     * @throws Exception
     */
    public boolean isDatumTussen(String strDatum) throws ParseException {
        if (calBegin == null) {
                maakKalenders(strBegin, strEind);
        }
        Calendar calDatum = maakTijdelijkeKalender(strDatum);
        long lMiliBegin = calBegin.getTimeInMillis();
        long lMiliDatum = calDatum.getTimeInMillis();
        long lMiliEind = calEind.getTimeInMillis();
        if (lMiliDatum >= lMiliBegin & lMiliDatum <= lMiliEind) {
            return true;
        } else {
            throw new IllegalArgumentException("De datum moet tussen " + strBegin + " en " + strEind + " vallen.");
        }
    }
    
    /**
     * Maakt een kalenderobject aan ahv het ingegeven String object.
     * Indien het String object geen Date object is, treedt een ParseException op.
     * @param strDatum
     * @return Calendar
     * @throws ParseException, IllegalArgumentException
     */
    public Calendar maakTijdelijkeKalender(String strDatum) throws ParseException {
        try {
            Date tempDatum = formatter.parse(strBegin);
            Calendar calTemp = Calendar.getInstance();
            calTemp.setTime(tempDatum);
            return calTemp;
        } catch (IllegalArgumentException ia) {
            throw ia;
        } catch (ParseException pe) {
            throw pe;
        }
    }
    
    /**
     * Maakt kalenderobjecten calBegin en calEind van de twee String objecten.
     * Indien deze Strings geen Date objecten zijn, treedt een ParseException op.
     * @param strBegin
     * @param strEind
     * @throws ParseException 
     */
    public void maakKalenders(String strBegin, String strEind) throws ParseException {
        Date tempDatum = formatter.parse(strBegin);
        calBegin = Calendar.getInstance();
        calBegin.setTime(tempDatum);
        tempDatum = formatter.parse(strEind);
        calEind = Calendar.getInstance();
        calEind.setTime(tempDatum);
    }
}
