using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace WFAutorizacionDeGiros
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new frmMain());
        }
    }

    public static class DataGridExtender
    {
        public static void blockCells(this DataGridView dgv)
        {
            foreach (DataGridViewColumn dc in dgv.Columns)
            {
                if (dc.Index.Equals(0)) { dc.ReadOnly = false; }
                else { dc.ReadOnly = true; }
            }
        }
    }


}
