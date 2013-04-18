/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package TestHibernate;

import java.util.List;
import java.lang.Exception;
import java.text.Format;
import java.text.SimpleDateFormat;
import mappingFilesAndPojo.Geregistreerdegebruikers;
/**
 *
 * @author AnkeA
 */
public class TestHibernate extends javax.swing.JFrame {

    static Connectie_Hibernate hibernate= new Connectie_Hibernate();
    List LijstGebruikers;  
    static int teller=0;
    public TestHibernate() {
        initComponents();
        try{
        LijstGebruikers=hibernate.maakConnectie("from Geregistreerdegebruikers");
        if(LijstGebruikers==null){
            throw new Exception("fout");
        }
        }
        catch(Exception e){
            System.out.println(e);
        }
        TonenTekst(LijstGebruikers,teller);
    }

   public void TonenTekst(List LijstGebruikers, int teller){
        Geregistreerdegebruikers gebruiker= (Geregistreerdegebruikers)LijstGebruikers.get(teller);
        txtGebruikersnaam.setText(gebruiker.getGebrNaam());
        txtAdres.setText(gebruiker.getGebrAdres());
        Format omzetting= new SimpleDateFormat("yyyy-MM-dd");
        String datum = omzetting.format(gebruiker.getGebrGebDat());
        txtGeboortedatum.setText(datum);
   
   
   }
                                         

     
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        txtGebruikersnaam = new javax.swing.JTextField();
        txtGeboortedatum = new javax.swing.JTextField();
        txtAdres = new javax.swing.JTextField();
        btnvolgende = new javax.swing.JButton();
        btnVorige = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jLabel1.setText("gebruikersnaam");

        jLabel2.setText("geboortedatum");

        jLabel3.setText("adres");

        btnvolgende.setText(">");
        btnvolgende.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnvolgendeActionPerformed(evt);
            }
        });

        btnVorige.setText("<");
        btnVorige.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnVorigeActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(54, 54, 54)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel3)
                            .addComponent(jLabel2)
                            .addComponent(jLabel1))
                        .addGap(58, 58, 58))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(btnVorige)
                        .addGap(18, 18, 18)))
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(btnvolgende)
                    .addComponent(txtGebruikersnaam, javax.swing.GroupLayout.PREFERRED_SIZE, 202, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(txtAdres, javax.swing.GroupLayout.PREFERRED_SIZE, 202, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(txtGeboortedatum, javax.swing.GroupLayout.PREFERRED_SIZE, 202, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(48, 48, 48)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel1)
                    .addComponent(txtGebruikersnaam, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(txtGeboortedatum, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel3)
                    .addComponent(txtAdres, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 79, Short.MAX_VALUE)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(btnvolgende)
                    .addComponent(btnVorige))
                .addGap(68, 68, 68))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btnvolgendeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnvolgendeActionPerformed
      if (teller <=LijstGebruikers.size()) {
            teller = teller + 1;
            TonenTekst(LijstGebruikers, teller);
        } else {
            teller = LijstGebruikers.size();
            TonenTekst(LijstGebruikers, LijstGebruikers.size());
        }
    }//GEN-LAST:event_btnvolgendeActionPerformed

    private void btnVorigeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnVorigeActionPerformed
       if (teller >= 0) {
            teller = teller - 1;
            TonenTekst(LijstGebruikers, teller);
        } else {
            teller = 0;
            TonenTekst(LijstGebruikers, 0);
        }
    }//GEN-LAST:event_btnVorigeActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(TestHibernate.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(TestHibernate.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(TestHibernate.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(TestHibernate.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new TestHibernate().setVisible(true);
            }
        });
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnVorige;
    private javax.swing.JButton btnvolgende;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JTextField txtAdres;
    private javax.swing.JTextField txtGeboortedatum;
    private javax.swing.JTextField txtGebruikersnaam;
    // End of variables declaration//GEN-END:variables
}
