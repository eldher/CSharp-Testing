using System;
using System.Reflection;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using WFAutorizacionDeGiros.Business;
using WFAutorizacionDeGiros.Data;
using WFAutorizacionDeGiros.Presentation;
using WFAutorizacionDeGiros.autBCV;




namespace WFAutorizacionDeGiros
{
    public partial class frmMain : Form
    {
        public DataClass _data = new DataClass();
        public BusinessClass _buss = new BusinessClass();

        public frmMain()
        {
            InitializeComponent();

            // para bg worker
            backgroundWorker1.WorkerReportsProgress = true;
            backgroundWorker1.WorkerSupportsCancellation = true;
        }

        public void frmMain_Load(object sender, EventArgs e)
        {
            _data.connection = @"Data Source=desarrollonew2;Initial Catalog=Exchange;Persist Security Info=True;User ID=iusr;Password=internet;Connection Timeout=300";
            _data.loadMainDGV();
            cargarDataGrid();
        }

        public void cargarDataGrid()
        {
            dgAprobadas.DataSource = _buss.addBoolColumnToDGV(_data.dtAprobadas);
            dgPendientes.DataSource = _buss.addBoolColumnToDGV(_data.dtPendientes);
            dgDenegadas.DataSource = _buss.addBoolColumnToDGV(_data.dtDenegadas);
            dgDevueltas.DataSource = _buss.addBoolColumnToDGV(_data.dtDevueltas);

            dgContratosAprobados.DataSource = _buss.addBoolColumnToDGV(_data.dtContratosAprobados);
            dgContratosDenegados.DataSource = _buss.addBoolColumnToDGV(_data.dtContratosDenegados);
            dgContratosPendientes.DataSource = _buss.addBoolColumnToDGV(_data.dtContratosPendientes);

            dgAprobadas.blockCells();
            dgPendientes.blockCells();
            dgDenegadas.blockCells();
            dgDevueltas.blockCells();
        }

        public void cargarDataGridContratos()
        {
            dgContratosAprobados.DataSource = _buss.addBoolColumnToDGV(_data.dtContratosAprobados);
            dgContratosDenegados.DataSource = _buss.addBoolColumnToDGV(_data.dtContratosDenegados);
            dgContratosPendientes.DataSource = _buss.addBoolColumnToDGV(_data.dtContratosPendientes);

            dgContratosAprobados.blockCells();
            dgContratosDenegados.blockCells();
            dgContratosPendientes.blockCells();

        }

        private void btnSeleccionarTodo_Click(object sender, EventArgs e)
        {
            DataGridViewSelectedRowCollection dgg = dgAprobadas.SelectedRows;
            foreach (DataGridViewRow dtr in dgg)
            {
                dtr.Cells[0].Value = true;
            }
            dgAprobadas.Focus();
        }

        private void dgAprobadas_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.RowIndex != -1)
            {
                string finaloperation = dgAprobadas.Rows[e.RowIndex].Cells["OperacionFinal"].Value.ToString();
                // get row from dataTable
                DataRow[] registro = _data.dtAprobadas.Select(string.Format("finalOperation = {0}", finaloperation));                //DataGridViewRow registro = dgAprobadas.Rows[e.RowIndex];
                //MessageBox.Show(finaloperation);
                frmDetails frmDetalles = new frmDetails();
                frmDetalles.finaloperation = finaloperation;
                frmDetalles.row = registro[0];
                frmDetalles.Show();
            }
        }

        // resize del form
        private void frmMain_SizeChanged(object sender, EventArgs e)
        {
            int y = this.Size.Height;
            int x = this.Size.Width;
            tabFrmMain.Size = new Size(x - 50, 360);
            tabContratos.Size = new Size(x - 50, 360);
            //tabContratos.Size = new Size(x - 50,600);
            dgAprobadas.Width = x - 85;
            dgPendientes.Width = x - 85;
            dgDevueltas.Width = x - 85;
            dgDenegadas.Width = x - 85;
            //** contratos
            dgContratosAprobados.Width = x - 85;
            dgContratosPendientes.Width = x - 85;
            dgContratosDenegados.Width = x - 85;
        }

        // deselecciona las filas del datagrid
        private void btnDeseleccionar_Click(object sender, EventArgs e)
        {
            DataGridViewSelectedRowCollection dgg = dgAprobadas.SelectedRows;
            foreach (DataGridViewRow dtr in dgg)
            {
                dtr.Cells[0].Value = false;
            }
            dgAprobadas.Focus();
        }

        private void dgPendientes_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.RowIndex != -1)
            {
                string finaloperation = dgPendientes.Rows[e.RowIndex].Cells["OperacionFinal"].Value.ToString();
                // get row from dataTable
                DataRow[] registro = _data.dtPendientes.Select(string.Format("finalOperation = {0}", finaloperation));                //DataGridViewRow registro = dgAprobadas.Rows[e.RowIndex];
                //MessageBox.Show(finaloperation);
                frmDetails frmDetalles = new frmDetails();
                frmDetalles.finaloperation = finaloperation;
                frmDetalles.row = registro[0];
                frmDetalles.Show();
            }
        }

        private void dgAprobadas_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void dgDenegadas_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.RowIndex != -1)
            {
                string finaloperation = dgDenegadas.Rows[e.RowIndex].Cells["OperacionFinal"].Value.ToString();
                // get row from dataTable
                DataRow[] registro = _data.dtDenegadas.Select(string.Format("finalOperation = {0}", finaloperation));                //DataGridViewRow registro = dgAprobadas.Rows[e.RowIndex];
                //MessageBox.Show(finaloperation);
                frmDetails frmDetalles = new frmDetails();
                frmDetalles.finaloperation = finaloperation;
                frmDetalles.row = registro[0];
                frmDetalles.Show();
            }
        }

        private void btnSeleccionarPendientes_Click(object sender, EventArgs e)
        {
            DataGridViewSelectedRowCollection dgg = dgPendientes.SelectedRows;
            foreach (DataGridViewRow dtr in dgg)
            {
                dtr.Cells[0].Value = true;
            }
            dgPendientes.Focus();
        }

        private void btnDeseleccionarPendientes_Click(object sender, EventArgs e)
        {
            DataGridViewSelectedRowCollection dgg = dgPendientes.SelectedRows;
            foreach (DataGridViewRow dtr in dgg)
            {
                dtr.Cells[0].Value = false;
            }
            dgPendientes.Focus();
        }

        private void button18_Click(object sender, EventArgs e)
        {
            _data.loadMainDGV();
            cargarDataGrid();
            this.Refresh();
        }

        private void dgPendientes_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void dgContratosPendientes_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.RowIndex != -1)
            {
                string nroContrato = dgContratosPendientes.Rows[e.RowIndex].Cells["Contrato"].Value.ToString();
                // get row from dataTable
                DataRow[] registro = _data.dtContratosPendientes.Select(string.Format("Contrato = {0}", nroContrato));


                BusinessClass.Contratos Contrato = new BusinessClass.Contratos();
                Contrato = Contrato.CreateContratoFromRow(registro[0]);


                frmDetalleContratos frmDetalleContrato = new frmDetalleContratos();
                frmDetalleContrato.Contrato = Contrato;
                //frmDetalles.row = registro[0];
                frmDetalleContrato.Show();
            }
        }



        private void btnSolicitarAprBCV_Click(object sender, EventArgs e)
        {
            backgroundWorker1.RunWorkerAsync();

        }

        private void button10_Click(object sender, EventArgs e)
        {
            DataGridViewSelectedRowCollection dgg = dgContratosPendientes.SelectedRows;//dgPendientes.SelectedRows;
            foreach (DataGridViewRow dtr in dgg)
            {
                dtr.Cells[0].Value = true;
            }
            dgPendientes.Focus();
        }

        private void tabPage1_Click(object sender, EventArgs e)
        {

        }

        //private void blockCells(DataGridView dgv)
        //{
        //    foreach (DataGridViewColumn dc in dgv.Columns)
        //    {
        //        if (dc.Index.Equals(0)) {dc.ReadOnly = false;}
        //        else {dc.ReadOnly = true;}
        //    }
        //}

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {

            backgroundWorker1.ReportProgress(1);

            DataGridViewRowCollection dgp = dgContratosPendientes.Rows; //.SelectedRows;

            BusinessClass.autorizaBCV mAutorizaBCV = new BusinessClass.autorizaBCV();

            foreach (DataGridViewRow dtr in dgp)
            {
                if (dtr.Cells[0].Value.Equals(true))
                {
                    autorizacionBCVParams _autBCVParams = new autorizacionBCVParams();
                    _autBCVParams.operacion = dtr.Cells["OperacionCaja"].Value.ToString();
                    _autBCVParams.server = "desarrollonew2";
                    _autBCVParams.user = "iusr";
                    _autBCVParams.password = "internet";
                    _autBCVParams.db = "exchange";
                    _autBCVParams.COTIMOVIMIENTO = dtr.Cells["Tipo"].Value.ToString();
                    _autBCVParams.CODCLIENTE = dtr.Cells["Cedula"].Value.ToString();
                    _autBCVParams.NBCLIENTE = dtr.Cells["Nombre"].Value.ToString();
                    _autBCVParams.MOBASE = Convert.ToDecimal(dtr.Cells["Monto"].Value);
                    _autBCVParams.TSCAMBIO = Convert.ToDecimal(dtr.Cells["Tasa"].Value.ToString());
                    _autBCVParams.COUCTATRANS = dtr.Cells["Divisa"].Value.ToString();
                    _autBCVParams.MOTRANS = Convert.ToDecimal(dtr.Cells["MontoBs"].Value);
                    _autBCVParams.COMOTIVOOPERACION = Convert.ToInt64(dtr.Cells["Motivo"].Value.ToString());
                    _autBCVParams.COINTRUM = dtr.Cells["Instrumento"].Value.ToString();

                    mAutorizaBCV.exeAutorizacionBCV(_autBCVParams);
                }


                if (backgroundWorker1.CancellationPending)
                {
                    e.Cancel = true;
                    return;
                }

                e.Result = "Operación Procesada";
            }

        }

        //It is ok to access UI controls here.
        private void backgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            pictureBox1.Visible = true;

            DateTime time = Convert.ToDateTime(e.UserState); //get additional information about progress

            //in this example, we log that optional additional info to textbox
            txtOutput.AppendText(time.ToLongTimeString());
            txtOutput.AppendText(Environment.NewLine);

        }

        //This is executed after the task is complete whatever the task has completed: a) sucessfully, b) with error c)has been cancelled
        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            if (e.Cancelled)
            {
                MessageBox.Show("Los envios han sido cancelados.");
            }
            else if (e.Error != null)
            {
                MessageBox.Show("Error. Details: " + (e.Error as Exception).ToString());
            }
            else
            {
                pictureBox1.Visible = false;
                MessageBox.Show("Operaciones Enviadas");
                _data.loadContratos();
                cargarDataGridContratos();
            }

        }

        private void btoCancel_Click(object sender, EventArgs e)
        {
            //notify background worker we want to cancel the operation.
            //this code doesn't actually cancel or kill the thread that is executing the job.
            backgroundWorker1.CancelAsync();
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {

        }


    }

}
