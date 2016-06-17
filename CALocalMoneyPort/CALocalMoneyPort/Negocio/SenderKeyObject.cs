using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CALocalMoneyPort.Negocio
{
    public class SenderKeyObject
    {
        public string idProvider { get; set; }
        public string sPrePrintedNumber { get; set; }
        public string sClavePay { get; set; }
        public string Flag { get; set; }
        public string errorCode { get; set; }
    }
}
