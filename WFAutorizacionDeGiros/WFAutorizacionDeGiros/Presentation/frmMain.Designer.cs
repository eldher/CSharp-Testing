namespace WFAutorizacionDeGiros
{
    partial class frmMain
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.tabFrmMain = new System.Windows.Forms.TabControl();
            this.tabPendientes = new System.Windows.Forms.TabPage();
            this.btnDeseleccionarPendientes = new System.Windows.Forms.Button();
            this.button4 = new System.Windows.Forms.Button();
            this.btnSeleccionarPendientes = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.dgPendientes = new System.Windows.Forms.DataGridView();
            this.tabAprobadas = new System.Windows.Forms.TabPage();
            this.btnDeseleccionar = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.button3 = new System.Windows.Forms.Button();
            this.btnSeleccionarTodo = new System.Windows.Forms.Button();
            this.dgAprobadas = new System.Windows.Forms.DataGridView();
            this.tabDenegadas = new System.Windows.Forms.TabPage();
            this.button5 = new System.Windows.Forms.Button();
            this.button6 = new System.Windows.Forms.Button();
            this.button9 = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.dgDenegadas = new System.Windows.Forms.DataGridView();
            this.tabDevueltas = new System.Windows.Forms.TabPage();
            this.button7 = new System.Windows.Forms.Button();
            this.button8 = new System.Windows.Forms.Button();
            this.button17 = new System.Windows.Forms.Button();
            this.label9 = new System.Windows.Forms.Label();
            this.dgDevueltas = new System.Windows.Forms.DataGridView();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.tabPage3 = new System.Windows.Forms.TabPage();
            this.button15 = new System.Windows.Forms.Button();
            this.button14 = new System.Windows.Forms.Button();
            this.button16 = new System.Windows.Forms.Button();
            this.label6 = new System.Windows.Forms.Label();
            this.dgContratosDenegados = new System.Windows.Forms.DataGridView();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.button11 = new System.Windows.Forms.Button();
            this.label5 = new System.Windows.Forms.Label();
            this.button13 = new System.Windows.Forms.Button();
            this.dgContratosAprobados = new System.Windows.Forms.DataGridView();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.txtOutput = new System.Windows.Forms.TextBox();
            this.btoCancel = new System.Windows.Forms.Button();
            this.btnCPSolicitarAprBCV = new System.Windows.Forms.Button();
            this.btnCPDeseleccionar = new System.Windows.Forms.Button();
            this.btnCPSeleccionar = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.dgContratosPendientes = new System.Windows.Forms.DataGridView();
            this.tabContratos = new System.Windows.Forms.TabControl();
            this.button18 = new System.Windows.Forms.Button();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.autorizacionBCVParamsBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.tabFrmMain.SuspendLayout();
            this.tabPendientes.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgPendientes)).BeginInit();
            this.tabAprobadas.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgAprobadas)).BeginInit();
            this.tabDenegadas.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgDenegadas)).BeginInit();
            this.tabDevueltas.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgDevueltas)).BeginInit();
            this.tabPage3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgContratosDenegados)).BeginInit();
            this.tabPage2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgContratosAprobados)).BeginInit();
            this.tabPage1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgContratosPendientes)).BeginInit();
            this.tabContratos.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.autorizacionBCVParamsBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // tabFrmMain
            // 
            this.tabFrmMain.Controls.Add(this.tabPendientes);
            this.tabFrmMain.Controls.Add(this.tabAprobadas);
            this.tabFrmMain.Controls.Add(this.tabDenegadas);
            this.tabFrmMain.Controls.Add(this.tabDevueltas);
            this.tabFrmMain.Location = new System.Drawing.Point(12, 65);
            this.tabFrmMain.Name = "tabFrmMain";
            this.tabFrmMain.SelectedIndex = 0;
            this.tabFrmMain.Size = new System.Drawing.Size(673, 364);
            this.tabFrmMain.TabIndex = 0;
            // 
            // tabPendientes
            // 
            this.tabPendientes.Controls.Add(this.btnDeseleccionarPendientes);
            this.tabPendientes.Controls.Add(this.button4);
            this.tabPendientes.Controls.Add(this.btnSeleccionarPendientes);
            this.tabPendientes.Controls.Add(this.label2);
            this.tabPendientes.Controls.Add(this.dgPendientes);
            this.tabPendientes.Location = new System.Drawing.Point(4, 22);
            this.tabPendientes.Name = "tabPendientes";
            this.tabPendientes.Padding = new System.Windows.Forms.Padding(3);
            this.tabPendientes.Size = new System.Drawing.Size(665, 338);
            this.tabPendientes.TabIndex = 0;
            this.tabPendientes.Text = "Pendientes";
            this.tabPendientes.UseVisualStyleBackColor = true;
            // 
            // btnDeseleccionarPendientes
            // 
            this.btnDeseleccionarPendientes.Location = new System.Drawing.Point(91, 303);
            this.btnDeseleccionarPendientes.Name = "btnDeseleccionarPendientes";
            this.btnDeseleccionarPendientes.Size = new System.Drawing.Size(85, 29);
            this.btnDeseleccionarPendientes.TabIndex = 11;
            this.btnDeseleccionarPendientes.Text = "Deseleccionar";
            this.btnDeseleccionarPendientes.UseVisualStyleBackColor = true;
            this.btnDeseleccionarPendientes.Click += new System.EventHandler(this.btnDeseleccionarPendientes_Click);
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(445, 303);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(141, 29);
            this.button4.TabIndex = 10;
            this.button4.Text = "Solicitar Aprobación BCV";
            this.button4.UseVisualStyleBackColor = true;
            this.button4.Click += new System.EventHandler(this.button4_Click);
            // 
            // btnSeleccionarPendientes
            // 
            this.btnSeleccionarPendientes.Location = new System.Drawing.Point(10, 303);
            this.btnSeleccionarPendientes.Name = "btnSeleccionarPendientes";
            this.btnSeleccionarPendientes.Size = new System.Drawing.Size(75, 29);
            this.btnSeleccionarPendientes.TabIndex = 9;
            this.btnSeleccionarPendientes.Text = "Seleccionar";
            this.btnSeleccionarPendientes.UseVisualStyleBackColor = true;
            this.btnSeleccionarPendientes.Click += new System.EventHandler(this.btnSeleccionarPendientes_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(11, 3);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(89, 20);
            this.label2.TabIndex = 8;
            this.label2.Text = "Pendientes";
            // 
            // dgPendientes
            // 
            this.dgPendientes.AllowUserToAddRows = false;
            this.dgPendientes.AllowUserToDeleteRows = false;
            this.dgPendientes.AllowUserToResizeRows = false;
            this.dgPendientes.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgPendientes.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgPendientes.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnF2;
            this.dgPendientes.Location = new System.Drawing.Point(12, 26);
            this.dgPendientes.Name = "dgPendientes";
            this.dgPendientes.RowHeadersVisible = false;
            this.dgPendientes.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgPendientes.Size = new System.Drawing.Size(572, 274);
            this.dgPendientes.TabIndex = 4;
            this.dgPendientes.CellMouseDoubleClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgPendientes_CellMouseDoubleClick);
            // 
            // tabAprobadas
            // 
            this.tabAprobadas.Controls.Add(this.btnDeseleccionar);
            this.tabAprobadas.Controls.Add(this.label1);
            this.tabAprobadas.Controls.Add(this.button3);
            this.tabAprobadas.Controls.Add(this.btnSeleccionarTodo);
            this.tabAprobadas.Controls.Add(this.dgAprobadas);
            this.tabAprobadas.Location = new System.Drawing.Point(4, 22);
            this.tabAprobadas.Name = "tabAprobadas";
            this.tabAprobadas.Padding = new System.Windows.Forms.Padding(3);
            this.tabAprobadas.Size = new System.Drawing.Size(665, 338);
            this.tabAprobadas.TabIndex = 1;
            this.tabAprobadas.Text = "Aprobadas";
            this.tabAprobadas.UseVisualStyleBackColor = true;
            // 
            // btnDeseleccionar
            // 
            this.btnDeseleccionar.Location = new System.Drawing.Point(91, 303);
            this.btnDeseleccionar.Name = "btnDeseleccionar";
            this.btnDeseleccionar.Size = new System.Drawing.Size(85, 29);
            this.btnDeseleccionar.TabIndex = 8;
            this.btnDeseleccionar.Text = "Deseleccionar";
            this.btnDeseleccionar.UseVisualStyleBackColor = true;
            this.btnDeseleccionar.Click += new System.EventHandler(this.btnDeseleccionar_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(11, 3);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(87, 20);
            this.label1.TabIndex = 7;
            this.label1.Text = "Aprobadas";
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(445, 303);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(141, 29);
            this.button3.TabIndex = 5;
            this.button3.Text = "Solicitar Aprobación BCV";
            this.button3.UseVisualStyleBackColor = true;
            // 
            // btnSeleccionarTodo
            // 
            this.btnSeleccionarTodo.Location = new System.Drawing.Point(10, 303);
            this.btnSeleccionarTodo.Name = "btnSeleccionarTodo";
            this.btnSeleccionarTodo.Size = new System.Drawing.Size(75, 29);
            this.btnSeleccionarTodo.TabIndex = 4;
            this.btnSeleccionarTodo.Text = "Seleccionar";
            this.btnSeleccionarTodo.UseVisualStyleBackColor = true;
            this.btnSeleccionarTodo.Click += new System.EventHandler(this.btnSeleccionarTodo_Click);
            // 
            // dgAprobadas
            // 
            this.dgAprobadas.AllowUserToAddRows = false;
            this.dgAprobadas.AllowUserToDeleteRows = false;
            this.dgAprobadas.AllowUserToResizeRows = false;
            this.dgAprobadas.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgAprobadas.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgAprobadas.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnF2;
            this.dgAprobadas.Location = new System.Drawing.Point(12, 26);
            this.dgAprobadas.Name = "dgAprobadas";
            this.dgAprobadas.RowHeadersVisible = false;
            this.dgAprobadas.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgAprobadas.Size = new System.Drawing.Size(576, 273);
            this.dgAprobadas.TabIndex = 3;
            this.dgAprobadas.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgAprobadas_CellContentClick);
            this.dgAprobadas.CellMouseDoubleClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgAprobadas_CellMouseDoubleClick);
            // 
            // tabDenegadas
            // 
            this.tabDenegadas.Controls.Add(this.button5);
            this.tabDenegadas.Controls.Add(this.button6);
            this.tabDenegadas.Controls.Add(this.button9);
            this.tabDenegadas.Controls.Add(this.label3);
            this.tabDenegadas.Controls.Add(this.dgDenegadas);
            this.tabDenegadas.Location = new System.Drawing.Point(4, 22);
            this.tabDenegadas.Name = "tabDenegadas";
            this.tabDenegadas.Size = new System.Drawing.Size(665, 338);
            this.tabDenegadas.TabIndex = 2;
            this.tabDenegadas.Text = "Denegadas";
            this.tabDenegadas.UseVisualStyleBackColor = true;
            // 
            // button5
            // 
            this.button5.Location = new System.Drawing.Point(91, 303);
            this.button5.Name = "button5";
            this.button5.Size = new System.Drawing.Size(85, 29);
            this.button5.TabIndex = 11;
            this.button5.Text = "Deseleccionar";
            this.button5.UseVisualStyleBackColor = true;
            // 
            // button6
            // 
            this.button6.Location = new System.Drawing.Point(445, 303);
            this.button6.Name = "button6";
            this.button6.Size = new System.Drawing.Size(141, 29);
            this.button6.TabIndex = 10;
            this.button6.Text = "Solicitar Aprobación BCV";
            this.button6.UseVisualStyleBackColor = true;
            // 
            // button9
            // 
            this.button9.Location = new System.Drawing.Point(10, 303);
            this.button9.Name = "button9";
            this.button9.Size = new System.Drawing.Size(75, 29);
            this.button9.TabIndex = 9;
            this.button9.Text = "Seleccionar";
            this.button9.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(11, 3);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(92, 20);
            this.label3.TabIndex = 8;
            this.label3.Text = "Denegadas";
            // 
            // dgDenegadas
            // 
            this.dgDenegadas.AllowUserToAddRows = false;
            this.dgDenegadas.AllowUserToDeleteRows = false;
            this.dgDenegadas.AllowUserToResizeRows = false;
            this.dgDenegadas.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgDenegadas.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgDenegadas.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnF2;
            this.dgDenegadas.Location = new System.Drawing.Point(12, 26);
            this.dgDenegadas.Name = "dgDenegadas";
            this.dgDenegadas.RowHeadersVisible = false;
            this.dgDenegadas.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgDenegadas.Size = new System.Drawing.Size(576, 273);
            this.dgDenegadas.TabIndex = 6;
            this.dgDenegadas.CellMouseDoubleClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgDenegadas_CellMouseDoubleClick);
            // 
            // tabDevueltas
            // 
            this.tabDevueltas.Controls.Add(this.button7);
            this.tabDevueltas.Controls.Add(this.button8);
            this.tabDevueltas.Controls.Add(this.button17);
            this.tabDevueltas.Controls.Add(this.label9);
            this.tabDevueltas.Controls.Add(this.dgDevueltas);
            this.tabDevueltas.Location = new System.Drawing.Point(4, 22);
            this.tabDevueltas.Name = "tabDevueltas";
            this.tabDevueltas.Size = new System.Drawing.Size(665, 338);
            this.tabDevueltas.TabIndex = 3;
            this.tabDevueltas.Text = "Devueltas";
            this.tabDevueltas.UseVisualStyleBackColor = true;
            // 
            // button7
            // 
            this.button7.Location = new System.Drawing.Point(91, 303);
            this.button7.Name = "button7";
            this.button7.Size = new System.Drawing.Size(85, 29);
            this.button7.TabIndex = 16;
            this.button7.Text = "Deseleccionar";
            this.button7.UseVisualStyleBackColor = true;
            // 
            // button8
            // 
            this.button8.Location = new System.Drawing.Point(445, 303);
            this.button8.Name = "button8";
            this.button8.Size = new System.Drawing.Size(141, 29);
            this.button8.TabIndex = 15;
            this.button8.Text = "Solicitar Aprobación BCV";
            this.button8.UseVisualStyleBackColor = true;
            // 
            // button17
            // 
            this.button17.Location = new System.Drawing.Point(10, 303);
            this.button17.Name = "button17";
            this.button17.Size = new System.Drawing.Size(75, 29);
            this.button17.TabIndex = 14;
            this.button17.Text = "Seleccionar";
            this.button17.UseVisualStyleBackColor = true;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.Location = new System.Drawing.Point(11, 3);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(80, 20);
            this.label9.TabIndex = 13;
            this.label9.Text = "Devueltas";
            // 
            // dgDevueltas
            // 
            this.dgDevueltas.AllowUserToAddRows = false;
            this.dgDevueltas.AllowUserToDeleteRows = false;
            this.dgDevueltas.AllowUserToResizeRows = false;
            this.dgDevueltas.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgDevueltas.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgDevueltas.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnF2;
            this.dgDevueltas.Location = new System.Drawing.Point(12, 26);
            this.dgDevueltas.Name = "dgDevueltas";
            this.dgDevueltas.RowHeadersVisible = false;
            this.dgDevueltas.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgDevueltas.Size = new System.Drawing.Size(576, 273);
            this.dgDevueltas.TabIndex = 12;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.ForeColor = System.Drawing.Color.DimGray;
            this.label7.Location = new System.Drawing.Point(12, 30);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(235, 24);
            this.label7.TabIndex = 2;
            this.label7.Text = "Encomiendas Electronicas";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.Color.DimGray;
            this.label8.Location = new System.Drawing.Point(13, 456);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(89, 24);
            this.label8.TabIndex = 3;
            this.label8.Text = "Contratos";
            // 
            // tabPage3
            // 
            this.tabPage3.Controls.Add(this.button15);
            this.tabPage3.Controls.Add(this.button14);
            this.tabPage3.Controls.Add(this.button16);
            this.tabPage3.Controls.Add(this.label6);
            this.tabPage3.Controls.Add(this.dgContratosDenegados);
            this.tabPage3.Location = new System.Drawing.Point(4, 22);
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.Size = new System.Drawing.Size(959, 409);
            this.tabPage3.TabIndex = 2;
            this.tabPage3.Text = "Denegadas";
            this.tabPage3.UseVisualStyleBackColor = true;
            // 
            // button15
            // 
            this.button15.Location = new System.Drawing.Point(445, 303);
            this.button15.Name = "button15";
            this.button15.Size = new System.Drawing.Size(141, 29);
            this.button15.TabIndex = 16;
            this.button15.Text = "Solicitar Aprobación BCV";
            this.button15.UseVisualStyleBackColor = true;
            // 
            // button14
            // 
            this.button14.Location = new System.Drawing.Point(93, 306);
            this.button14.Name = "button14";
            this.button14.Size = new System.Drawing.Size(85, 29);
            this.button14.TabIndex = 11;
            this.button14.Text = "Deseleccionar";
            this.button14.UseVisualStyleBackColor = true;
            // 
            // button16
            // 
            this.button16.Location = new System.Drawing.Point(11, 306);
            this.button16.Name = "button16";
            this.button16.Size = new System.Drawing.Size(75, 29);
            this.button16.TabIndex = 9;
            this.button16.Text = "Seleccionar";
            this.button16.UseVisualStyleBackColor = true;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(6, 3);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(92, 20);
            this.label6.TabIndex = 8;
            this.label6.Text = "Denegados";
            // 
            // dgContratosDenegados
            // 
            this.dgContratosDenegados.AllowUserToAddRows = false;
            this.dgContratosDenegados.AllowUserToDeleteRows = false;
            this.dgContratosDenegados.AllowUserToResizeRows = false;
            this.dgContratosDenegados.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgContratosDenegados.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgContratosDenegados.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnF2;
            this.dgContratosDenegados.Location = new System.Drawing.Point(9, 26);
            this.dgContratosDenegados.Name = "dgContratosDenegados";
            this.dgContratosDenegados.RowHeadersVisible = false;
            this.dgContratosDenegados.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgContratosDenegados.Size = new System.Drawing.Size(576, 273);
            this.dgContratosDenegados.TabIndex = 6;
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.button11);
            this.tabPage2.Controls.Add(this.label5);
            this.tabPage2.Controls.Add(this.button13);
            this.tabPage2.Controls.Add(this.dgContratosAprobados);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(959, 409);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Aprobadas";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // button11
            // 
            this.button11.Location = new System.Drawing.Point(93, 306);
            this.button11.Name = "button11";
            this.button11.Size = new System.Drawing.Size(85, 29);
            this.button11.TabIndex = 8;
            this.button11.Text = "Deseleccionar";
            this.button11.UseVisualStyleBackColor = true;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(6, 3);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(87, 20);
            this.label5.TabIndex = 7;
            this.label5.Text = "Aprobados";
            // 
            // button13
            // 
            this.button13.Location = new System.Drawing.Point(11, 306);
            this.button13.Name = "button13";
            this.button13.Size = new System.Drawing.Size(75, 29);
            this.button13.TabIndex = 4;
            this.button13.Text = "Seleccionar";
            this.button13.UseVisualStyleBackColor = true;
            // 
            // dgContratosAprobados
            // 
            this.dgContratosAprobados.AllowUserToAddRows = false;
            this.dgContratosAprobados.AllowUserToDeleteRows = false;
            this.dgContratosAprobados.AllowUserToResizeRows = false;
            this.dgContratosAprobados.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgContratosAprobados.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgContratosAprobados.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnF2;
            this.dgContratosAprobados.Location = new System.Drawing.Point(9, 26);
            this.dgContratosAprobados.Name = "dgContratosAprobados";
            this.dgContratosAprobados.RowHeadersVisible = false;
            this.dgContratosAprobados.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgContratosAprobados.Size = new System.Drawing.Size(576, 273);
            this.dgContratosAprobados.TabIndex = 3;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.txtOutput);
            this.tabPage1.Controls.Add(this.btoCancel);
            this.tabPage1.Controls.Add(this.btnCPSolicitarAprBCV);
            this.tabPage1.Controls.Add(this.btnCPDeseleccionar);
            this.tabPage1.Controls.Add(this.btnCPSeleccionar);
            this.tabPage1.Controls.Add(this.label4);
            this.tabPage1.Controls.Add(this.dgContratosPendientes);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(959, 409);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Pendientes";
            this.tabPage1.UseVisualStyleBackColor = true;
            this.tabPage1.Click += new System.EventHandler(this.tabPage1_Click);
            // 
            // txtOutput
            // 
            this.txtOutput.Location = new System.Drawing.Point(77, 341);
            this.txtOutput.Multiline = true;
            this.txtOutput.Name = "txtOutput";
            this.txtOutput.Size = new System.Drawing.Size(176, 31);
            this.txtOutput.TabIndex = 20;
            this.txtOutput.Visible = false;
            // 
            // btoCancel
            // 
            this.btoCancel.Location = new System.Drawing.Point(455, 336);
            this.btoCancel.Name = "btoCancel";
            this.btoCancel.Size = new System.Drawing.Size(119, 29);
            this.btoCancel.TabIndex = 18;
            this.btoCancel.Text = "Cancelar Aprobación";
            this.btoCancel.UseVisualStyleBackColor = true;
            // 
            // btnCPSolicitarAprBCV
            // 
            this.btnCPSolicitarAprBCV.Location = new System.Drawing.Point(445, 303);
            this.btnCPSolicitarAprBCV.Name = "btnCPSolicitarAprBCV";
            this.btnCPSolicitarAprBCV.Size = new System.Drawing.Size(141, 29);
            this.btnCPSolicitarAprBCV.TabIndex = 16;
            this.btnCPSolicitarAprBCV.Text = "Solicitar Aprobación BCV";
            this.btnCPSolicitarAprBCV.UseVisualStyleBackColor = true;
            this.btnCPSolicitarAprBCV.Click += new System.EventHandler(this.btnSolicitarAprBCV_Click);
            // 
            // btnCPDeseleccionar
            // 
            this.btnCPDeseleccionar.Location = new System.Drawing.Point(93, 306);
            this.btnCPDeseleccionar.Name = "btnCPDeseleccionar";
            this.btnCPDeseleccionar.Size = new System.Drawing.Size(85, 29);
            this.btnCPDeseleccionar.TabIndex = 11;
            this.btnCPDeseleccionar.Text = "Deseleccionar";
            this.btnCPDeseleccionar.UseVisualStyleBackColor = true;
            this.btnCPDeseleccionar.Click += new System.EventHandler(this.button1_Click);
            // 
            // btnCPSeleccionar
            // 
            this.btnCPSeleccionar.Location = new System.Drawing.Point(11, 306);
            this.btnCPSeleccionar.Name = "btnCPSeleccionar";
            this.btnCPSeleccionar.Size = new System.Drawing.Size(75, 29);
            this.btnCPSeleccionar.TabIndex = 9;
            this.btnCPSeleccionar.Text = "Seleccionar";
            this.btnCPSeleccionar.UseVisualStyleBackColor = true;
            this.btnCPSeleccionar.Click += new System.EventHandler(this.button10_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(6, 3);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(89, 20);
            this.label4.TabIndex = 8;
            this.label4.Text = "Pendientes";
            // 
            // dgContratosPendientes
            // 
            this.dgContratosPendientes.AllowUserToAddRows = false;
            this.dgContratosPendientes.AllowUserToDeleteRows = false;
            this.dgContratosPendientes.AllowUserToResizeRows = false;
            this.dgContratosPendientes.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgContratosPendientes.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgContratosPendientes.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnF2;
            this.dgContratosPendientes.Location = new System.Drawing.Point(9, 26);
            this.dgContratosPendientes.Name = "dgContratosPendientes";
            this.dgContratosPendientes.RowHeadersVisible = false;
            this.dgContratosPendientes.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgContratosPendientes.Size = new System.Drawing.Size(572, 274);
            this.dgContratosPendientes.TabIndex = 4;
            this.dgContratosPendientes.CellMouseDoubleClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgContratosPendientes_CellMouseDoubleClick);
            // 
            // tabContratos
            // 
            this.tabContratos.Controls.Add(this.tabPage1);
            this.tabContratos.Controls.Add(this.tabPage2);
            this.tabContratos.Controls.Add(this.tabPage3);
            this.tabContratos.Location = new System.Drawing.Point(12, 489);
            this.tabContratos.Name = "tabContratos";
            this.tabContratos.SelectedIndex = 0;
            this.tabContratos.Size = new System.Drawing.Size(967, 435);
            this.tabContratos.TabIndex = 1;
            // 
            // button18
            // 
            this.button18.Location = new System.Drawing.Point(461, 456);
            this.button18.Name = "button18";
            this.button18.Size = new System.Drawing.Size(78, 44);
            this.button18.TabIndex = 12;
            this.button18.Text = "Actualizar Movimientos";
            this.button18.UseVisualStyleBackColor = true;
            this.button18.Click += new System.EventHandler(this.button18_Click);
            // 
            // backgroundWorker1
            // 
            this.backgroundWorker1.DoWork += new System.ComponentModel.DoWorkEventHandler(this.backgroundWorker1_DoWork);
            this.backgroundWorker1.ProgressChanged += new System.ComponentModel.ProgressChangedEventHandler(this.backgroundWorker1_ProgressChanged);
            this.backgroundWorker1.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.backgroundWorker1_RunWorkerCompleted);
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = global::WFAutorizacionDeGiros.Properties.Resources.spiffygif_66x66;
            this.pictureBox1.Location = new System.Drawing.Point(545, 435);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(71, 71);
            this.pictureBox1.TabIndex = 21;
            this.pictureBox1.TabStop = false;
            this.pictureBox1.Visible = false;
            // 
            // autorizacionBCVParamsBindingSource
            // 
            this.autorizacionBCVParamsBindingSource.DataSource = typeof(WFAutorizacionDeGiros.Data.autorizacionBCVParams);
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ButtonHighlight;
            this.ClientSize = new System.Drawing.Size(991, 952);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.button18);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.tabContratos);
            this.Controls.Add(this.tabFrmMain);
            this.Name = "frmMain";
            this.Text = "Autorización de Giros y Contratos SICAD II";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.frmMain_Load);
            this.SizeChanged += new System.EventHandler(this.frmMain_SizeChanged);
            this.tabFrmMain.ResumeLayout(false);
            this.tabPendientes.ResumeLayout(false);
            this.tabPendientes.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgPendientes)).EndInit();
            this.tabAprobadas.ResumeLayout(false);
            this.tabAprobadas.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgAprobadas)).EndInit();
            this.tabDenegadas.ResumeLayout(false);
            this.tabDenegadas.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgDenegadas)).EndInit();
            this.tabDevueltas.ResumeLayout(false);
            this.tabDevueltas.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgDevueltas)).EndInit();
            this.tabPage3.ResumeLayout(false);
            this.tabPage3.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgContratosDenegados)).EndInit();
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgContratosAprobados)).EndInit();
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgContratosPendientes)).EndInit();
            this.tabContratos.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.autorizacionBCVParamsBindingSource)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TabControl tabFrmMain;
        private System.Windows.Forms.TabPage tabPendientes;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Button btnSeleccionarTodo;
        private System.Windows.Forms.DataGridView dgAprobadas;
        private System.Windows.Forms.TabPage tabDenegadas;
        private System.Windows.Forms.TabPage tabDevueltas;
        private System.Windows.Forms.Label label1;
        public System.Windows.Forms.TabPage tabAprobadas;
        private System.Windows.Forms.Button btnDeseleccionar;
        private System.Windows.Forms.Button btnDeseleccionarPendientes;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.Button btnSeleccionarPendientes;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.DataGridView dgPendientes;
        private System.Windows.Forms.Button button5;
        private System.Windows.Forms.Button button6;
        private System.Windows.Forms.Button button9;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.DataGridView dgDenegadas;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TabPage tabPage3;
        private System.Windows.Forms.Button button14;
        private System.Windows.Forms.Button button16;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.DataGridView dgContratosDenegados;
        public System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.Button button11;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Button button13;
        private System.Windows.Forms.DataGridView dgContratosAprobados;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.Button btnCPDeseleccionar;
        private System.Windows.Forms.Button btnCPSeleccionar;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.DataGridView dgContratosPendientes;
        private System.Windows.Forms.TabControl tabContratos;
        private System.Windows.Forms.Button button7;
        private System.Windows.Forms.Button button8;
        private System.Windows.Forms.Button button17;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.DataGridView dgDevueltas;
        private System.Windows.Forms.Button button15;
        private System.Windows.Forms.Button btnCPSolicitarAprBCV;
        private System.Windows.Forms.Button button18;
        private System.Windows.Forms.Button btoCancel;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
        private System.Windows.Forms.TextBox txtOutput;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.BindingSource autorizacionBCVParamsBindingSource;
    }
}

