﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18444
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CALocalMoneyPort.autBCV {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx", ConfigurationName="autBCV.autBCVSoap")]
    public interface autBCVSoap {
        
        // CODEGEN: Generating message contract since element name HelloWorldResult from namespace http://localhost:56854/WSOIBCV.asmx is not marked nillable
        [System.ServiceModel.OperationContractAttribute(Action="http://localhost:56854/WSOIBCV.asmx/HelloWorld", ReplyAction="*")]
        CALocalMoneyPort.autBCV.HelloWorldResponse HelloWorld(CALocalMoneyPort.autBCV.HelloWorldRequest request);
        
        // CODEGEN: Generating message contract since element name COTIMOVIMIENTO from namespace http://localhost:56854/WSOIBCV.asmx is not marked nillable
        [System.ServiceModel.OperationContractAttribute(Action="http://localhost:56854/WSOIBCV.asmx/VENTADIV", ReplyAction="*")]
        CALocalMoneyPort.autBCV.VENTADIVResponse VENTADIV(CALocalMoneyPort.autBCV.VENTADIVRequest request);
        
        // CODEGEN: Generating message contract since element name COTIMOVIMIENTO from namespace http://localhost:56854/WSOIBCV.asmx is not marked nillable
        [System.ServiceModel.OperationContractAttribute(Action="http://localhost:56854/WSOIBCV.asmx/COMPRADIV", ReplyAction="*")]
        CALocalMoneyPort.autBCV.COMPRADIVResponse COMPRADIV(CALocalMoneyPort.autBCV.COMPRADIVRequest request);
        
        // CODEGEN: Generating message contract since element name TIPOSMOVIMIENTOSResult from namespace http://localhost:56854/WSOIBCV.asmx is not marked nillable
        [System.ServiceModel.OperationContractAttribute(Action="http://localhost:56854/WSOIBCV.asmx/TIPOSMOVIMIENTOS", ReplyAction="*")]
        CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSResponse TIPOSMOVIMIENTOS(CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSRequest request);
        
        // CODEGEN: Generating message contract since element name fecha from namespace http://localhost:56854/WSOIBCV.asmx is not marked nillable
        [System.ServiceModel.OperationContractAttribute(Action="http://localhost:56854/WSOIBCV.asmx/MOVIMIENTOS", ReplyAction="*")]
        CALocalMoneyPort.autBCV.MOVIMIENTOSResponse MOVIMIENTOS(CALocalMoneyPort.autBCV.MOVIMIENTOSRequest request);
        
        // CODEGEN: Generating message contract since element name MOTIVOSResult from namespace http://localhost:56854/WSOIBCV.asmx is not marked nillable
        [System.ServiceModel.OperationContractAttribute(Action="http://localhost:56854/WSOIBCV.asmx/MOTIVOS", ReplyAction="*")]
        CALocalMoneyPort.autBCV.MOTIVOSResponse MOTIVOS(CALocalMoneyPort.autBCV.MOTIVOSRequest request);
        
        // CODEGEN: Generating message contract since element name EXCEPCIONESResult from namespace http://localhost:56854/WSOIBCV.asmx is not marked nillable
        [System.ServiceModel.OperationContractAttribute(Action="http://localhost:56854/WSOIBCV.asmx/EXCEPCIONES", ReplyAction="*")]
        CALocalMoneyPort.autBCV.EXCEPCIONESResponse EXCEPCIONES(CALocalMoneyPort.autBCV.EXCEPCIONESRequest request);
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class HelloWorldRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="HelloWorld", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.HelloWorldRequestBody Body;
        
        public HelloWorldRequest() {
        }
        
        public HelloWorldRequest(CALocalMoneyPort.autBCV.HelloWorldRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute()]
    public partial class HelloWorldRequestBody {
        
        public HelloWorldRequestBody() {
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class HelloWorldResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="HelloWorldResponse", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.HelloWorldResponseBody Body;
        
        public HelloWorldResponse() {
        }
        
        public HelloWorldResponse(CALocalMoneyPort.autBCV.HelloWorldResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx")]
    public partial class HelloWorldResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string HelloWorldResult;
        
        public HelloWorldResponseBody() {
        }
        
        public HelloWorldResponseBody(string HelloWorldResult) {
            this.HelloWorldResult = HelloWorldResult;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class VENTADIVRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="VENTADIV", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.VENTADIVRequestBody Body;
        
        public VENTADIVRequest() {
        }
        
        public VENTADIVRequest(CALocalMoneyPort.autBCV.VENTADIVRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx")]
    public partial class VENTADIVRequestBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string COTIMOVIMIENTO;
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=1)]
        public string COCLIENTE;
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=2)]
        public string NBCLIENTE;
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=3)]
        public decimal MOBASE;
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=4)]
        public decimal TSCAMBIO;
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=5)]
        public string COUCTATRANS;
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=6)]
        public decimal MOTRANS;
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=7)]
        public long COMOTIVOOPERACION;
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=8)]
        public string COINTRUM;
        
        public VENTADIVRequestBody() {
        }
        
        public VENTADIVRequestBody(string COTIMOVIMIENTO, string COCLIENTE, string NBCLIENTE, decimal MOBASE, decimal TSCAMBIO, string COUCTATRANS, decimal MOTRANS, long COMOTIVOOPERACION, string COINTRUM) {
            this.COTIMOVIMIENTO = COTIMOVIMIENTO;
            this.COCLIENTE = COCLIENTE;
            this.NBCLIENTE = NBCLIENTE;
            this.MOBASE = MOBASE;
            this.TSCAMBIO = TSCAMBIO;
            this.COUCTATRANS = COUCTATRANS;
            this.MOTRANS = MOTRANS;
            this.COMOTIVOOPERACION = COMOTIVOOPERACION;
            this.COINTRUM = COINTRUM;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class VENTADIVResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="VENTADIVResponse", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.VENTADIVResponseBody Body;
        
        public VENTADIVResponse() {
        }
        
        public VENTADIVResponse(CALocalMoneyPort.autBCV.VENTADIVResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx")]
    public partial class VENTADIVResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string VENTADIVResult;
        
        public VENTADIVResponseBody() {
        }
        
        public VENTADIVResponseBody(string VENTADIVResult) {
            this.VENTADIVResult = VENTADIVResult;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class COMPRADIVRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="COMPRADIV", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.COMPRADIVRequestBody Body;
        
        public COMPRADIVRequest() {
        }
        
        public COMPRADIVRequest(CALocalMoneyPort.autBCV.COMPRADIVRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx")]
    public partial class COMPRADIVRequestBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string COTIMOVIMIENTO;
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=1)]
        public string COCLIENTE;
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=2)]
        public string NBCLIENTE;
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=3)]
        public decimal MOBASE;
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=4)]
        public decimal TSCAMBIO;
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=5)]
        public string COUCTATRANS;
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=6)]
        public decimal MOTRANS;
        
        [System.Runtime.Serialization.DataMemberAttribute(Order=7)]
        public long COMOTIVOOPERACION;
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=8)]
        public string COINTRUM;
        
        public COMPRADIVRequestBody() {
        }
        
        public COMPRADIVRequestBody(string COTIMOVIMIENTO, string COCLIENTE, string NBCLIENTE, decimal MOBASE, decimal TSCAMBIO, string COUCTATRANS, decimal MOTRANS, long COMOTIVOOPERACION, string COINTRUM) {
            this.COTIMOVIMIENTO = COTIMOVIMIENTO;
            this.COCLIENTE = COCLIENTE;
            this.NBCLIENTE = NBCLIENTE;
            this.MOBASE = MOBASE;
            this.TSCAMBIO = TSCAMBIO;
            this.COUCTATRANS = COUCTATRANS;
            this.MOTRANS = MOTRANS;
            this.COMOTIVOOPERACION = COMOTIVOOPERACION;
            this.COINTRUM = COINTRUM;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class COMPRADIVResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="COMPRADIVResponse", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.COMPRADIVResponseBody Body;
        
        public COMPRADIVResponse() {
        }
        
        public COMPRADIVResponse(CALocalMoneyPort.autBCV.COMPRADIVResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx")]
    public partial class COMPRADIVResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string COMPRADIVResult;
        
        public COMPRADIVResponseBody() {
        }
        
        public COMPRADIVResponseBody(string COMPRADIVResult) {
            this.COMPRADIVResult = COMPRADIVResult;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class TIPOSMOVIMIENTOSRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="TIPOSMOVIMIENTOS", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSRequestBody Body;
        
        public TIPOSMOVIMIENTOSRequest() {
        }
        
        public TIPOSMOVIMIENTOSRequest(CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute()]
    public partial class TIPOSMOVIMIENTOSRequestBody {
        
        public TIPOSMOVIMIENTOSRequestBody() {
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class TIPOSMOVIMIENTOSResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="TIPOSMOVIMIENTOSResponse", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSResponseBody Body;
        
        public TIPOSMOVIMIENTOSResponse() {
        }
        
        public TIPOSMOVIMIENTOSResponse(CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx")]
    public partial class TIPOSMOVIMIENTOSResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string TIPOSMOVIMIENTOSResult;
        
        public TIPOSMOVIMIENTOSResponseBody() {
        }
        
        public TIPOSMOVIMIENTOSResponseBody(string TIPOSMOVIMIENTOSResult) {
            this.TIPOSMOVIMIENTOSResult = TIPOSMOVIMIENTOSResult;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class MOVIMIENTOSRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="MOVIMIENTOS", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.MOVIMIENTOSRequestBody Body;
        
        public MOVIMIENTOSRequest() {
        }
        
        public MOVIMIENTOSRequest(CALocalMoneyPort.autBCV.MOVIMIENTOSRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx")]
    public partial class MOVIMIENTOSRequestBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string fecha;
        
        public MOVIMIENTOSRequestBody() {
        }
        
        public MOVIMIENTOSRequestBody(string fecha) {
            this.fecha = fecha;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class MOVIMIENTOSResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="MOVIMIENTOSResponse", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.MOVIMIENTOSResponseBody Body;
        
        public MOVIMIENTOSResponse() {
        }
        
        public MOVIMIENTOSResponse(CALocalMoneyPort.autBCV.MOVIMIENTOSResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx")]
    public partial class MOVIMIENTOSResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string MOVIMIENTOSResult;
        
        public MOVIMIENTOSResponseBody() {
        }
        
        public MOVIMIENTOSResponseBody(string MOVIMIENTOSResult) {
            this.MOVIMIENTOSResult = MOVIMIENTOSResult;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class MOTIVOSRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="MOTIVOS", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.MOTIVOSRequestBody Body;
        
        public MOTIVOSRequest() {
        }
        
        public MOTIVOSRequest(CALocalMoneyPort.autBCV.MOTIVOSRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute()]
    public partial class MOTIVOSRequestBody {
        
        public MOTIVOSRequestBody() {
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class MOTIVOSResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="MOTIVOSResponse", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.MOTIVOSResponseBody Body;
        
        public MOTIVOSResponse() {
        }
        
        public MOTIVOSResponse(CALocalMoneyPort.autBCV.MOTIVOSResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx")]
    public partial class MOTIVOSResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string MOTIVOSResult;
        
        public MOTIVOSResponseBody() {
        }
        
        public MOTIVOSResponseBody(string MOTIVOSResult) {
            this.MOTIVOSResult = MOTIVOSResult;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class EXCEPCIONESRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="EXCEPCIONES", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.EXCEPCIONESRequestBody Body;
        
        public EXCEPCIONESRequest() {
        }
        
        public EXCEPCIONESRequest(CALocalMoneyPort.autBCV.EXCEPCIONESRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute()]
    public partial class EXCEPCIONESRequestBody {
        
        public EXCEPCIONESRequestBody() {
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class EXCEPCIONESResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="EXCEPCIONESResponse", Namespace="http://localhost:56854/WSOIBCV.asmx", Order=0)]
        public CALocalMoneyPort.autBCV.EXCEPCIONESResponseBody Body;
        
        public EXCEPCIONESResponse() {
        }
        
        public EXCEPCIONESResponse(CALocalMoneyPort.autBCV.EXCEPCIONESResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://localhost:56854/WSOIBCV.asmx")]
    public partial class EXCEPCIONESResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public string EXCEPCIONESResult;
        
        public EXCEPCIONESResponseBody() {
        }
        
        public EXCEPCIONESResponseBody(string EXCEPCIONESResult) {
            this.EXCEPCIONESResult = EXCEPCIONESResult;
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface autBCVSoapChannel : CALocalMoneyPort.autBCV.autBCVSoap, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class autBCVSoapClient : System.ServiceModel.ClientBase<CALocalMoneyPort.autBCV.autBCVSoap>, CALocalMoneyPort.autBCV.autBCVSoap {
        
        public autBCVSoapClient() {
        }
        
        public autBCVSoapClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public autBCVSoapClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public autBCVSoapClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public autBCVSoapClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        CALocalMoneyPort.autBCV.HelloWorldResponse CALocalMoneyPort.autBCV.autBCVSoap.HelloWorld(CALocalMoneyPort.autBCV.HelloWorldRequest request) {
            return base.Channel.HelloWorld(request);
        }
        
        public string HelloWorld() {
            CALocalMoneyPort.autBCV.HelloWorldRequest inValue = new CALocalMoneyPort.autBCV.HelloWorldRequest();
            inValue.Body = new CALocalMoneyPort.autBCV.HelloWorldRequestBody();
            CALocalMoneyPort.autBCV.HelloWorldResponse retVal = ((CALocalMoneyPort.autBCV.autBCVSoap)(this)).HelloWorld(inValue);
            return retVal.Body.HelloWorldResult;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        CALocalMoneyPort.autBCV.VENTADIVResponse CALocalMoneyPort.autBCV.autBCVSoap.VENTADIV(CALocalMoneyPort.autBCV.VENTADIVRequest request) {
            return base.Channel.VENTADIV(request);
        }
        
        public string VENTADIV(string COTIMOVIMIENTO, string COCLIENTE, string NBCLIENTE, decimal MOBASE, decimal TSCAMBIO, string COUCTATRANS, decimal MOTRANS, long COMOTIVOOPERACION, string COINTRUM) {
            CALocalMoneyPort.autBCV.VENTADIVRequest inValue = new CALocalMoneyPort.autBCV.VENTADIVRequest();
            inValue.Body = new CALocalMoneyPort.autBCV.VENTADIVRequestBody();
            inValue.Body.COTIMOVIMIENTO = COTIMOVIMIENTO;
            inValue.Body.COCLIENTE = COCLIENTE;
            inValue.Body.NBCLIENTE = NBCLIENTE;
            inValue.Body.MOBASE = MOBASE;
            inValue.Body.TSCAMBIO = TSCAMBIO;
            inValue.Body.COUCTATRANS = COUCTATRANS;
            inValue.Body.MOTRANS = MOTRANS;
            inValue.Body.COMOTIVOOPERACION = COMOTIVOOPERACION;
            inValue.Body.COINTRUM = COINTRUM;
            CALocalMoneyPort.autBCV.VENTADIVResponse retVal = ((CALocalMoneyPort.autBCV.autBCVSoap)(this)).VENTADIV(inValue);
            return retVal.Body.VENTADIVResult;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        CALocalMoneyPort.autBCV.COMPRADIVResponse CALocalMoneyPort.autBCV.autBCVSoap.COMPRADIV(CALocalMoneyPort.autBCV.COMPRADIVRequest request) {
            return base.Channel.COMPRADIV(request);
        }
        
        public string COMPRADIV(string COTIMOVIMIENTO, string COCLIENTE, string NBCLIENTE, decimal MOBASE, decimal TSCAMBIO, string COUCTATRANS, decimal MOTRANS, long COMOTIVOOPERACION, string COINTRUM) {
            CALocalMoneyPort.autBCV.COMPRADIVRequest inValue = new CALocalMoneyPort.autBCV.COMPRADIVRequest();
            inValue.Body = new CALocalMoneyPort.autBCV.COMPRADIVRequestBody();
            inValue.Body.COTIMOVIMIENTO = COTIMOVIMIENTO;
            inValue.Body.COCLIENTE = COCLIENTE;
            inValue.Body.NBCLIENTE = NBCLIENTE;
            inValue.Body.MOBASE = MOBASE;
            inValue.Body.TSCAMBIO = TSCAMBIO;
            inValue.Body.COUCTATRANS = COUCTATRANS;
            inValue.Body.MOTRANS = MOTRANS;
            inValue.Body.COMOTIVOOPERACION = COMOTIVOOPERACION;
            inValue.Body.COINTRUM = COINTRUM;
            CALocalMoneyPort.autBCV.COMPRADIVResponse retVal = ((CALocalMoneyPort.autBCV.autBCVSoap)(this)).COMPRADIV(inValue);
            return retVal.Body.COMPRADIVResult;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSResponse CALocalMoneyPort.autBCV.autBCVSoap.TIPOSMOVIMIENTOS(CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSRequest request) {
            return base.Channel.TIPOSMOVIMIENTOS(request);
        }
        
        public string TIPOSMOVIMIENTOS() {
            CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSRequest inValue = new CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSRequest();
            inValue.Body = new CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSRequestBody();
            CALocalMoneyPort.autBCV.TIPOSMOVIMIENTOSResponse retVal = ((CALocalMoneyPort.autBCV.autBCVSoap)(this)).TIPOSMOVIMIENTOS(inValue);
            return retVal.Body.TIPOSMOVIMIENTOSResult;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        CALocalMoneyPort.autBCV.MOVIMIENTOSResponse CALocalMoneyPort.autBCV.autBCVSoap.MOVIMIENTOS(CALocalMoneyPort.autBCV.MOVIMIENTOSRequest request) {
            return base.Channel.MOVIMIENTOS(request);
        }
        
        public string MOVIMIENTOS(string fecha) {
            CALocalMoneyPort.autBCV.MOVIMIENTOSRequest inValue = new CALocalMoneyPort.autBCV.MOVIMIENTOSRequest();
            inValue.Body = new CALocalMoneyPort.autBCV.MOVIMIENTOSRequestBody();
            inValue.Body.fecha = fecha;
            CALocalMoneyPort.autBCV.MOVIMIENTOSResponse retVal = ((CALocalMoneyPort.autBCV.autBCVSoap)(this)).MOVIMIENTOS(inValue);
            return retVal.Body.MOVIMIENTOSResult;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        CALocalMoneyPort.autBCV.MOTIVOSResponse CALocalMoneyPort.autBCV.autBCVSoap.MOTIVOS(CALocalMoneyPort.autBCV.MOTIVOSRequest request) {
            return base.Channel.MOTIVOS(request);
        }
        
        public string MOTIVOS() {
            CALocalMoneyPort.autBCV.MOTIVOSRequest inValue = new CALocalMoneyPort.autBCV.MOTIVOSRequest();
            inValue.Body = new CALocalMoneyPort.autBCV.MOTIVOSRequestBody();
            CALocalMoneyPort.autBCV.MOTIVOSResponse retVal = ((CALocalMoneyPort.autBCV.autBCVSoap)(this)).MOTIVOS(inValue);
            return retVal.Body.MOTIVOSResult;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        CALocalMoneyPort.autBCV.EXCEPCIONESResponse CALocalMoneyPort.autBCV.autBCVSoap.EXCEPCIONES(CALocalMoneyPort.autBCV.EXCEPCIONESRequest request) {
            return base.Channel.EXCEPCIONES(request);
        }
        
        public string EXCEPCIONES() {
            CALocalMoneyPort.autBCV.EXCEPCIONESRequest inValue = new CALocalMoneyPort.autBCV.EXCEPCIONESRequest();
            inValue.Body = new CALocalMoneyPort.autBCV.EXCEPCIONESRequestBody();
            CALocalMoneyPort.autBCV.EXCEPCIONESResponse retVal = ((CALocalMoneyPort.autBCV.autBCVSoap)(this)).EXCEPCIONES(inValue);
            return retVal.Body.EXCEPCIONESResult;
        }
    }
}