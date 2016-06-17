using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using WFAutorizacionDeGiros.Presentation;
using WFAutorizacionDeGiros.Business;
using WFAutorizacionDeGiros.Data;

namespace WFAutorizacionDeGiros.Presentation
{
    public partial class frmDetails : Form
    {
        public DataClass _data = new DataClass();
        public BusinessClass _buss = new BusinessClass();
        public string finaloperation { get; set; }
        public DataRow row { get; set; }
        public string conexion { get; set; }
        public BusinessClass.moneyObj MoneyObj = new BusinessClass.moneyObj();

        public frmDetails()
        {
            InitializeComponent();
        }
        
        private void frmDetails_Load(object sender, EventArgs e)
        {
            _data.connection = @"Data Source=desarrollonew2;Initial Catalog=Exchange;Persist Security Info=True;User ID=iusr;Password=internet;Connection Timeout=300";
            try 
            {
                _buss.SetItemFromRow(MoneyObj, row);
            }
            catch(Exception ex) 
            {
                MessageBox.Show("Error" + ex.ToString());
            }
            
            loadTxtFields();
            blockTxtFields();
            groupChangeAmount.Visible = false;
            btnSave.Enabled = false;

            DataTable rdt = _data.Hist(MoneyObj.codOperation);
            dataGridView1.DataSource = rdt;
            dataGridView1.Refresh();
        }

        private void loadTxtFields()
        {
            // cargar txts desde objeto
            txtCodSender.Text = MoneyObj.codSender;
            txtCodReceiver.Text = MoneyObj.codReceiver;
            txtNameSender.Text = "Nombre Test";
            txtNameReceiver.Text = "Nombre Test";
            txtpaymentKey.Text = MoneyObj.paymentKey;
            txtidProvider.Text = MoneyObj.providerAcronym;
            txtamount.Text = MoneyObj.amount.ToString();
            txtFinalOperatio.Text = MoneyObj.finalOperation;
            txtfeeamount.Text = MoneyObj.feeamount.ToString();
            txtexchangeRateApplied.Text = MoneyObj.exchangeRateApplied.ToString();
            txtsendCountry.Text = MoneyObj.sendCountry;
            txtrcvCountry.Text = MoneyObj.rcvCountry;
            txtNameSender.Text = MoneyObj.NameSender;
            txtNameReceiver.Text = MoneyObj.NameReceiver;
        }

        private void blockTxtFields()
        {
            // bloquea los txt
            txtCodSender.ReadOnly = true;
            txtCodReceiver.ReadOnly = true;
            txtNameSender.ReadOnly = true;
            txtNameReceiver.ReadOnly = true;
            txtpaymentKey.ReadOnly = true;
            txtidProvider.ReadOnly = true;
            txtamount.ReadOnly = true;
            txtFinalOperatio.ReadOnly = true;
            txtfeeamount.ReadOnly = true;
            txtexchangeRateApplied.ReadOnly = true;
            txtsendCountry.ReadOnly = true;
            txtrcvCountry.ReadOnly = true;
            txtNameSender.ReadOnly = true;
            txtNameReceiver.ReadOnly = true;
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnChangeamount_Click(object sender, EventArgs e)
        {
            // botones de clave
            btnChangeamount.Enabled = false;
            btnSave.Enabled = true;
            // interaccion cambio de monto
            groupChangeAmount.Visible = true;
            txtChangefeeamount.Text = txtfeeamount.Text;
            txtChangeexchangerateapplied.Text = txtexchangeRateApplied.Text;
            txtChangeAmount.Text = txtChangeAmount.Text;
            txtChangeAmount.Focus();
            txtChangeAmount.SelectionStart = txtChangeAmount.Text.Length + 1;            
        }
        
        private void btnSave_Click(object sender, EventArgs e)
        {            
            string opcion = "DIVIDIR";
            string status = "";
            decimal AmountOld = Convert.ToDecimal(txtamount.Text);
            decimal AmountNew = Convert.ToDecimal(txtChangeAmount.Text);
            string finalOp =MoneyObj.finalOperation;
            string codOp = MoneyObj.codOperation;

            groupChangeAmount.Visible = false;
            toolStripStatusLabel1.Text = "Guardando Registro";
            _data.saveModification(opcion, status, finalOp, codOp, AmountOld, AmountNew);
            // mostrar Tabla con registros actualizados
            DataTable rdt = _data.Hist(MoneyObj.codOperation);
            dataGridView1.DataSource = rdt;
            dataGridView1.Refresh();
            toolStripStatusLabel1.Text = "Registro Modificado";
            btnSave.Enabled = true;
        }

        private void txtChangeAmount_TextChanged(object sender, EventArgs e)
        {
            // evita que el campo quede vacio
            if (txtChangeAmount.Text != "")
            {
                // chequea que el monto ingresado sea menor al monto total a enviar
                if (Convert.ToSingle(txtChangeAmount.Text) >= MoneyObj.amount)
                {                    
                    statusLabel.Text = "Monto Inválido. Debe ser menor al mostrado.";
                    txtChangeAmount.Text = "";
                    txtChangeAmount.Focus();
                    txtChangeAmount.SelectionStart = txtChangeAmount.Text.Length + 1;
                    txtamount.Text = MoneyObj.amount.ToString();
                }
                else
                {txtamount.Text = (MoneyObj.amount - Convert.ToSingle(txtChangeAmount.Text)).ToString();}
            }            
        }

        private void txtChangeAmount_KeyPress(object sender, KeyPressEventArgs e)
        {
            // bloquear input de letras
            if ((e.KeyChar > (char)Keys.D9 || e.KeyChar < (char)Keys.D0) && e.KeyChar != (char)Keys.Back && e.KeyChar != '.')
            {e.Handled = true;}
        }

    }

}
