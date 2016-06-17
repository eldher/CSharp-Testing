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
    public partial class frmDetalleContratos : Form
    {
        public DataClass _data = new DataClass();
        public BusinessClass _buss = new BusinessClass();
        public string finaloperation { get; set; }
        public DataRow row { get; set; }
        public string conexion { get; set; }
        public BusinessClass.Contratos Contrato = new BusinessClass.Contratos();
        public BusinessClass.moneyObj MoneyObj = new BusinessClass.moneyObj();

        public frmDetalleContratos()
        {
            InitializeComponent();
        }

        private void frmDetalleContratos_Load(object sender, EventArgs e)
        {

            //_data.connection = @"Data Source=desarrollonew2;Initial Catalog=Exchange;Persist Security Info=True;User ID=iusr;Password=internet;Connection Timeout=300";
            //try
            //{
            //    _buss.SetItemFromRow(MoneyObj, row);
            //}
            //catch (Exception ex)
            //{
            //    MessageBox.Show("Error" + ex.ToString());
            //}

            loadTxtFields();
            blockTxtFields();
            //blockTxtFields();
            //groupChangeAmount.Visible = false;
            //btnSave.Enabled = false;

            //DataTable rdt = _data.Hist(MoneyObj.codOperation);
            //dataGridView1.DataSource = rdt;
            //dataGridView1.Refresh();
        }

        private void loadTxtFields()
        {
            //tAgregar.Text = Contrato.Agregar;
            tContrato.Text = Contrato.Contrato;
            tTipo.Text = Contrato.Tipo;
            tCedula.Text = Contrato.Cedula;
            tNombre.Text = Contrato.Nombre;
            tMonto.Text = Contrato.Monto.ToString();
            tTasa.Text = Contrato.Tasa.ToString();
            tDivisa.Text = Contrato.Divisa;
            tMontoBs.Text = Contrato.MontoBS.ToString();

            switch (Contrato.Motivo)
            {
                case "1":
                    tMotivo.Text = "AHORRO";
                    break;

                case "2":
                    tMotivo.Text = "TURISMO";
                    break;

                case "3":
                    tMotivo.Text = "REMESA FAMILIAR";
                    break;                    
            }

            //tMotivo.Text = Contrato.Motivo;

            switch (Contrato.Instrumento)
            {
                case "1":
                    tInstrumento.Text = "EFECTIVO";
                    break;

                case "2":
                    tInstrumento.Text = "CHEQUE";
                    break;

                case "3":
                    tInstrumento.Text = "TRANSFERENCIA";
                    break;
            }

           // tInstrumento.Text = Contrato.Instrumento;
            tOperacionCaja.Text = Contrato.OperacionCaja;
            tAutorizacionBCV.Text = Contrato.AutorizacionBCV;
            tStatus.Text = Contrato.Status;
        }

        private void blockTxtFields()
        {
            // bloquea los txt
            tContrato.ReadOnly = true;
            tTipo.ReadOnly = true;
            tCedula.ReadOnly = true;
            tNombre.ReadOnly = true;
            tMonto.ReadOnly = true;
            tTasa.ReadOnly = true;
            tMontoBs.ReadOnly = true;
            tDivisa.ReadOnly = true;
            //txtFinalOperatio.ReadOnly = true;
            tMotivo.ReadOnly = true;
            tInstrumento.ReadOnly = true;
           // txtsendCountry.ReadOnly = true;
            tOperacionCaja.ReadOnly = true;
            tCedula.ReadOnly = true;
            tNombre.ReadOnly = true;
            tStatus.ReadOnly = true;
            tAutorizacionBCV.ReadOnly = true;
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
            //groupChangeAmount.Visible = true;
            //txtChangefeeamount.Text = txtfeeamount.Text;
            //txtChangeexchangerateapplied.Text = txtexchangeRateApplied.Text;
            //txtChangeAmount.Text = txtChangeAmount.Text;
            //txtChangeAmount.Focus();
            //txtChangeAmount.SelectionStart = txtChangeAmount.Text.Length + 1;
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            //string opcion = "DIVIDIR";
            //string status = "";
            //decimal AmountOld = Convert.ToDecimal(txtamount.Text);
            //decimal AmountNew = Convert.ToDecimal(txtChangeAmount.Text);
            //string finalOp = MoneyObj.finalOperation;
            //string codOp = MoneyObj.codOperation;

            //groupChangeAmount.Visible = false;
            //statusLabel.Text = "Guardando Registro";
            //_data.saveModification(opcion, status, finalOp, codOp, AmountOld, AmountNew);
            //// mostrar Tabla con registros actualizados
            //DataTable rdt = _data.Hist(MoneyObj.codOperation);
            //dataGridView1.DataSource = rdt;
            //dataGridView1.Refresh();
            //statusLabel.Text = "Registro Modificado";
            //btnSave.Enabled = true;
        }

        private void txtChangeAmount_TextChanged(object sender, EventArgs e)
        {
            //// evita que el campo quede vacio
            //if (txtChangeAmount.Text != "")
            //{
            //    // chequea que el monto ingresado sea menor al monto total a enviar
            //    if (Convert.ToSingle(txtChangeAmount.Text) >= MoneyObj.amount)
            //    {
            //        statusLabel.Text = "Monto Inválido. Debe ser menor al mostrado.";
            //        txtChangeAmount.Text = "";
            //        txtChangeAmount.Focus();
            //        txtChangeAmount.SelectionStart = txtChangeAmount.Text.Length + 1;
            //        txtamount.Text = MoneyObj.amount.ToString();
            //    }
            //    else
            //    { txtamount.Text = (MoneyObj.amount - Convert.ToSingle(txtChangeAmount.Text)).ToString(); }
            //}
        }

        private void txtChangeAmount_KeyPress(object sender, KeyPressEventArgs e)
        {
            // bloquear input de letras
            if ((e.KeyChar > (char)Keys.D9 || e.KeyChar < (char)Keys.D0) && e.KeyChar != (char)Keys.Back && e.KeyChar != '.')
            { e.Handled = true; }
        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }


    }

}
