using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.ServiceModel;
using System.Threading;
using System.Security;
using System.Security.Permissions;
using System.Configuration;
using CALocalMoneyPort.WSItalcambio;
using CLBusinessObjects.Archivos;
using CALocalMoneyPort.Negocio;
using CLBusinessObjects.DATOS;
using System.IO;
using System.Globalization;

namespace CALocalMoneyPort.Negocio
{

    public class CALocalParameters
    {
        public string server { get; set; }
        public string db { get; set; }
        public string user { get; set; }
        public string password { get; set; }
        public string sendProviderAcronym { get; set; } //codeCompany
        public string receiptProviderAcronym { get; set; }
        public string requestType { get; set; }         // CONSULTADOC
        public string finalOperation { get; set; }      // idClient
        public string paymentKey { get; set; }          // codAgree
        public string paymentStatus { get; set; }
        public string response { get; set; }
        public string idProvider { get; set; }
        public string sendIdAgency { get; set; }
        public string environment { get; set; }
 

        public CALocalParameters returnCAParameters(string CAarguments)
        {
            char[] delimit = new char[] { '/' };
            // Creates logs in folder 
            //Traza Traza = new Traza("TrazaCALMP", @"C:\CALMP\", "");

            // Reads parameters sent from parent application
            string[] parameters = CAarguments.Split(delimit);
            CALocalParameters CAParams = new CALocalParameters();

            try
            {
                    CAParams.server = parameters[0].ToString();
                    CAParams.db = parameters[1].ToString();
                    CAParams.user = parameters[2].ToString();
                    CAParams.password = parameters[3].ToString();
                    CAParams.sendProviderAcronym = parameters[4].ToString();
                    CAParams.receiptProviderAcronym = parameters[5].ToString();
                    CAParams.requestType = parameters[6].ToString();
                    CAParams.finalOperation = parameters[7].ToString();
                    CAParams.paymentKey = parameters[8].ToString();
                    CAParams.paymentStatus = parameters[9].ToString();
                    CAParams.response = parameters[10].ToString();
                    CAParams.idProvider = parameters[11].ToString();
                    CAParams.sendIdAgency = parameters[12].ToString();
                    CAParams.environment = parameters[13].ToString().ToLower();
                    return CAParams;                
            }
            catch (Exception ex)
            {
                Console.WriteLine("Missing Params..." + ex.ToString());
                return CAParams;
            }
        }
    }

    public class autorizacionBCVParams
    {
        //****** BCV
        public string suiche { get; set; }
        public string server { get; set; }
        public string db { get; set; }
        public string user { get; set; }
        public string password { get; set; }
        public string operacion { get; set; } //codeCompany
        public string COTIMOVIMIENTO { get; set; }
        public string CODCLIENTE { get; set; }         // CONSULTADOC
        public string NBCLIENTE { get; set; }      // idClient
        public decimal MOBASE { get; set; }          // codAgree
        public decimal TSCAMBIO { get; set; }
        public string COUCTATRANS { get; set; }
        public decimal MOTRANS { get; set; }
        public long COMOTIVOOPERACION { get; set; }
        public string COINTRUM { get; set; }

        public autorizacionBCVParams returnAutorizacionBCVParams(string CAarguments)
        {
            char[] delimit = new char[] { '/' };
            string[] parameters = CAarguments.Split(delimit);
            autorizacionBCVParams aBcvParams = new autorizacionBCVParams();

            try
            {
                aBcvParams.suiche = parameters[0].ToString();
                aBcvParams.server = parameters[1].ToString();
                aBcvParams.db = parameters[2].ToString();
                aBcvParams.user = parameters[3].ToString();
                aBcvParams.password = parameters[4].ToString(); 
                aBcvParams.operacion = parameters[5].ToString();
                aBcvParams.COTIMOVIMIENTO = parameters[6].ToString();
                aBcvParams.CODCLIENTE = parameters[7].ToString();
                aBcvParams.NBCLIENTE = parameters[8].ToString();
                aBcvParams.MOBASE = Convert.ToDecimal(parameters[9]);
                aBcvParams.TSCAMBIO = Convert.ToDecimal(parameters[10]);
                aBcvParams.COUCTATRANS = parameters[11].ToString();
                aBcvParams.MOTRANS = Convert.ToDecimal(parameters[12]);
                aBcvParams.COMOTIVOOPERACION = Convert.ToInt64(parameters[13]);
                aBcvParams.COINTRUM = parameters[14].ToString();
                return aBcvParams;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Missing Params AutBCV..." + ex.ToString());
                return aBcvParams;
            }
        }
    }
    
    public static class TMoneyObject
    {

        public static tReceiptElectronicMoney getMoneyObj(this tReceiptElectronicMoney MoneyObj, string connection, string finaloperation, Traza Traza)
        {
            try
            {
                Datos AgencyData = new Datos(connection);
                string StrQuery = string.Format("EXEC uSpLocalMoneyPort {0},{1},{2},{3}", "\'\'", "\'\'", "SEND", "\'" + finaloperation + "\'");
                DataTable tblObjMoney = AgencyData.ResultTableQuery(StrQuery);

                MoneyObj.Aux0 = "";
                MoneyObj.Aux1 = "";
                MoneyObj.Aux2 = "";
                MoneyObj.Aux3 = "";
                MoneyObj.Aux4 = "";

                MoneyObj.IdSender = tblObjMoney.Rows[0]["IdSender"].ToString();
                MoneyObj.FirstNameSender = tblObjMoney.Rows[0]["FirstNameSender"].ToString();
                MoneyObj.SecondNameSender = tblObjMoney.Rows[0]["SecondNameSender"].ToString();
                MoneyObj.LastNameSender = tblObjMoney.Rows[0]["LastNameSender"].ToString();
                MoneyObj.SecondLastNamerSender = tblObjMoney.Rows[0]["SecondLastNamerSender"].ToString();
                MoneyObj.IdBeneficiary = tblObjMoney.Rows[0]["IdBeneficiary"].ToString();
                MoneyObj.FirstNameBeneficiary = tblObjMoney.Rows[0]["FirstNameBeneficiary"].ToString();
                MoneyObj.SecondNameBeneficiary = tblObjMoney.Rows[0]["SecondNameBeneficiary"].ToString();
                MoneyObj.LastNameBeneficiary = tblObjMoney.Rows[0]["LastNameBeneficiary"].ToString();
                MoneyObj.SecondLastNameBeneficiary = tblObjMoney.Rows[0]["SecondLastNameBeneficiary"].ToString();
                MoneyObj.AddressBeneficiary = tblObjMoney.Rows[0]["AddressBeneficiary"].ToString();
                MoneyObj.CityBeneficiary = tblObjMoney.Rows[0]["CityBeneficiary"].ToString();
                MoneyObj.Amount = tblObjMoney.Rows[0]["Amount"].ToString();
                MoneyObj.Country = tblObjMoney.Rows[0]["Country"].ToString();
                MoneyObj.PhoneBeneficiary = tblObjMoney.Rows[0]["PhoneBeneficiary"].ToString();
                //MoneyObj.KeySender = "keyTest"; // verificar luego
                MoneyObj.IdProvider = tblObjMoney.Rows[0]["IdProvider"].ToString();
                MoneyObj.pai_iso3 = tblObjMoney.Rows[0]["pai_iso3"].ToString();
                MoneyObj.paymenttype = tblObjMoney.Rows[0]["paymenttype"].ToString();
                MoneyObj.bankName = tblObjMoney.Rows[0]["bankName"].ToString();
                MoneyObj.bankAddress = tblObjMoney.Rows[0]["bankAddress"].ToString();
                MoneyObj.bankCode = tblObjMoney.Rows[0]["bankCode"].ToString();
                MoneyObj.phone = tblObjMoney.Rows[0]["phone"].ToString();
                MoneyObj.sGroupBranchCode = tblObjMoney.Rows[0]["sGroupBranchCode"].ToString();
                MoneyObj.sCurrencyPayCode = tblObjMoney.Rows[0]["sCurrencyPayCode"].ToString();
                MoneyObj.sBranchCodePay = tblObjMoney.Rows[0]["sBranchCodePay"].ToString();
                MoneyObj.currencyCode = tblObjMoney.Rows[0]["currencyCode"].ToString();
                MoneyObj.currency = tblObjMoney.Rows[0]["currency"].ToString();
                MoneyObj.typeAccount = tblObjMoney.Rows[0]["typeAccount"].ToString();
                MoneyObj.accountNumber = tblObjMoney.Rows[0]["accountNumber"].ToString();
                MoneyObj.idRegion = tblObjMoney.Rows[0]["idRegion"].ToString();
                MoneyObj.aba = tblObjMoney.Rows[0]["aba"].ToString();
                MoneyObj.swift = tblObjMoney.Rows[0]["swift"].ToString();
                MoneyObj.iban = tblObjMoney.Rows[0]["iban"].ToString();
                MoneyObj.idAgency = tblObjMoney.Rows[0]["idAgency"].ToString();
                MoneyObj.agency = tblObjMoney.Rows[0]["agency"].ToString();
                MoneyObj.institutionNumber = tblObjMoney.Rows[0]["institutionNumber"].ToString();
                MoneyObj.officeNumber = tblObjMoney.Rows[0]["officeNumber"].ToString();
                MoneyObj.Fixing = tblObjMoney.Rows[0]["Fixing"].ToString();
                //MoneyObj.exchangeRateApplied = tblObjMoney.Rows[0]["exchangeRateApplied"].ToString();
                //MoneyObj.currencyPayment = "D"; // verificar luego
                MoneyObj.emailBeneficiary = tblObjMoney.Rows[0]["emailBeneficiary"].ToString();
                MoneyObj.sendIdAgency = tblObjMoney.Rows[0]["sendIdAgency"].ToString();

                return MoneyObj;
            }
            catch (Exception)
            {
                //throw new Exception(" getMoneyObj: " + ex.Message.ToString());
                Traza.Escribir("Registry not Found in local DB");
                return MoneyObj;
            }
        }

        public static tReceiptElectronicMoney encryptMoneyObj(this tReceiptElectronicMoney MoneyObj, Traza Traza)
        {
            Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();

            try
            {
                MoneyObj.Aux0 = objEncrypt.Encriptar(MoneyObj.Aux0);
                MoneyObj.Aux1 = objEncrypt.Encriptar(MoneyObj.Aux1);
                MoneyObj.Aux2 = objEncrypt.Encriptar(MoneyObj.Aux2);
                MoneyObj.Aux3 = objEncrypt.Encriptar(MoneyObj.Aux3);
                MoneyObj.Aux4 = objEncrypt.Encriptar(MoneyObj.Aux4);
                MoneyObj.IdSender = objEncrypt.Encriptar(MoneyObj.IdSender);
                MoneyObj.FirstNameSender = objEncrypt.Encriptar(MoneyObj.FirstNameSender);
                MoneyObj.SecondNameSender = objEncrypt.Encriptar(MoneyObj.SecondNameSender);
                MoneyObj.LastNameSender = objEncrypt.Encriptar(MoneyObj.LastNameSender);
                MoneyObj.SecondLastNamerSender = objEncrypt.Encriptar(MoneyObj.SecondLastNamerSender);
                MoneyObj.IdBeneficiary = objEncrypt.Encriptar(MoneyObj.IdBeneficiary);
                MoneyObj.FirstNameBeneficiary = objEncrypt.Encriptar(MoneyObj.FirstNameBeneficiary);
                MoneyObj.SecondNameBeneficiary = objEncrypt.Encriptar(MoneyObj.SecondNameBeneficiary);
                MoneyObj.LastNameBeneficiary = objEncrypt.Encriptar(MoneyObj.LastNameBeneficiary);
                MoneyObj.SecondLastNameBeneficiary = objEncrypt.Encriptar(MoneyObj.SecondLastNameBeneficiary);
                MoneyObj.AddressBeneficiary = objEncrypt.Encriptar(MoneyObj.AddressBeneficiary);
                MoneyObj.CityBeneficiary = objEncrypt.Encriptar(MoneyObj.CityBeneficiary);
                MoneyObj.Amount = objEncrypt.Encriptar(MoneyObj.Amount);
                MoneyObj.Country = objEncrypt.Encriptar(MoneyObj.Country);
                MoneyObj.PhoneBeneficiary = objEncrypt.Encriptar(MoneyObj.PhoneBeneficiary);
                MoneyObj.KeySender = objEncrypt.Encriptar(MoneyObj.KeySender); // verificar luego
                MoneyObj.IdProvider = objEncrypt.Encriptar(MoneyObj.IdProvider);
                MoneyObj.pai_iso3 = objEncrypt.Encriptar(MoneyObj.pai_iso3);
                MoneyObj.paymenttype = objEncrypt.Encriptar(MoneyObj.paymenttype);
                MoneyObj.bankName = objEncrypt.Encriptar(MoneyObj.bankName);
                MoneyObj.bankAddress = objEncrypt.Encriptar(MoneyObj.bankAddress);
                MoneyObj.bankCode = objEncrypt.Encriptar(MoneyObj.bankCode);
                MoneyObj.phone = objEncrypt.Encriptar(MoneyObj.phone);
                MoneyObj.sGroupBranchCode = objEncrypt.Encriptar(MoneyObj.sGroupBranchCode);
                MoneyObj.sCurrencyPayCode = objEncrypt.Encriptar(MoneyObj.sCurrencyPayCode);
                MoneyObj.sBranchCodePay = objEncrypt.Encriptar(MoneyObj.sBranchCodePay);
                MoneyObj.currencyCode = objEncrypt.Encriptar(MoneyObj.currencyCode);
                MoneyObj.currency = objEncrypt.Encriptar(MoneyObj.currency);
                MoneyObj.typeAccount = objEncrypt.Encriptar(MoneyObj.typeAccount);
                MoneyObj.accountNumber = objEncrypt.Encriptar(MoneyObj.accountNumber);
                MoneyObj.idRegion = objEncrypt.Encriptar(MoneyObj.idRegion);
                MoneyObj.aba = objEncrypt.Encriptar(MoneyObj.aba);
                MoneyObj.swift = objEncrypt.Encriptar(MoneyObj.swift);
                MoneyObj.iban = objEncrypt.Encriptar(MoneyObj.iban);
                MoneyObj.idAgency = objEncrypt.Encriptar(MoneyObj.idAgency);
                MoneyObj.agency = objEncrypt.Encriptar(MoneyObj.agency);
                MoneyObj.institutionNumber = objEncrypt.Encriptar(MoneyObj.institutionNumber);
                MoneyObj.officeNumber = objEncrypt.Encriptar(MoneyObj.officeNumber);
                MoneyObj.Fixing = objEncrypt.Encriptar(MoneyObj.Fixing);
                //MoneyObj.exchangeRateApplied = objEncrypt.Encriptar(MoneyObj.exchangeRateApplied);
                MoneyObj.currencyPayment = objEncrypt.Encriptar(MoneyObj.currencyPayment); // verificar luego
                MoneyObj.emailBeneficiary = objEncrypt.Encriptar(MoneyObj.emailBeneficiary);
                MoneyObj.sendIdAgency = objEncrypt.Encriptar(MoneyObj.sendIdAgency);
                MoneyObj.operationBoxOffice = objEncrypt.Encriptar(MoneyObj.operationBoxOffice);
                MoneyObj.operationCashier = objEncrypt.Encriptar(MoneyObj.operationCashier);
                MoneyObj.phoneRemitter = objEncrypt.Encriptar(MoneyObj.phoneRemitter);
                MoneyObj.addressRemitter = objEncrypt.Encriptar(MoneyObj.addressRemitter);
                MoneyObj.cityRemitter = objEncrypt.Encriptar(MoneyObj.cityRemitter);
                MoneyObj.stateRemitter = objEncrypt.Encriptar(MoneyObj.stateRemitter);
                MoneyObj.senderZipCode = objEncrypt.Encriptar(MoneyObj.senderZipCode);
                MoneyObj.senderCountry = objEncrypt.Encriptar(MoneyObj.senderCountry);
                MoneyObj.stateBeneficiary = objEncrypt.Encriptar(MoneyObj.stateBeneficiary);
                MoneyObj.senderZipCodeBenef = objEncrypt.Encriptar(MoneyObj.senderZipCodeBenef);
                return MoneyObj;
            }
            catch (Exception)
            {
                Traza.Escribir("No transaction to encrypt...");
                return MoneyObj;
            }
        }

        public static tReceiptElectronicMoney decryptMoneyObj(this tReceiptElectronicMoney MoneyObj, Traza Traza)
        {
            Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();

            try
            {
                MoneyObj.Aux0 = objDecrypt.Desencriptar(MoneyObj.Aux0);
                MoneyObj.Aux1 = objDecrypt.Desencriptar(MoneyObj.Aux1);
                MoneyObj.Aux2 = objDecrypt.Desencriptar(MoneyObj.Aux2);
                MoneyObj.Aux3 = objDecrypt.Desencriptar(MoneyObj.Aux3);
                MoneyObj.Aux4 = objDecrypt.Desencriptar(MoneyObj.Aux4);
                MoneyObj.IdSender = objDecrypt.Desencriptar(MoneyObj.IdSender);
                MoneyObj.FirstNameSender = objDecrypt.Desencriptar(MoneyObj.FirstNameSender);
                MoneyObj.SecondNameSender = objDecrypt.Desencriptar(MoneyObj.SecondNameSender);
                MoneyObj.LastNameSender = objDecrypt.Desencriptar(MoneyObj.LastNameSender);
                MoneyObj.SecondLastNamerSender = objDecrypt.Desencriptar(MoneyObj.SecondLastNamerSender);
                MoneyObj.IdBeneficiary = objDecrypt.Desencriptar(MoneyObj.IdBeneficiary);
                MoneyObj.FirstNameBeneficiary = objDecrypt.Desencriptar(MoneyObj.FirstNameBeneficiary);
                MoneyObj.SecondNameBeneficiary = objDecrypt.Desencriptar(MoneyObj.SecondNameBeneficiary);
                MoneyObj.LastNameBeneficiary = objDecrypt.Desencriptar(MoneyObj.LastNameBeneficiary);
                MoneyObj.SecondLastNameBeneficiary = objDecrypt.Desencriptar(MoneyObj.SecondLastNameBeneficiary);
                MoneyObj.AddressBeneficiary = objDecrypt.Desencriptar(MoneyObj.AddressBeneficiary);
                MoneyObj.CityBeneficiary = objDecrypt.Desencriptar(MoneyObj.CityBeneficiary);
                MoneyObj.Amount = objDecrypt.Desencriptar(MoneyObj.Amount);
                MoneyObj.Country = objDecrypt.Desencriptar(MoneyObj.Country);
                MoneyObj.PhoneBeneficiary = objDecrypt.Desencriptar(MoneyObj.PhoneBeneficiary);
                MoneyObj.KeySender = objDecrypt.Desencriptar(MoneyObj.KeySender);
                MoneyObj.IdProvider = objDecrypt.Desencriptar(MoneyObj.IdProvider);
                MoneyObj.pai_iso3 = objDecrypt.Desencriptar(MoneyObj.pai_iso3);
                MoneyObj.paymenttype = objDecrypt.Desencriptar(MoneyObj.paymenttype);
                MoneyObj.bankName = objDecrypt.Desencriptar(MoneyObj.bankName);
                MoneyObj.bankAddress = objDecrypt.Desencriptar(MoneyObj.bankAddress);
                MoneyObj.bankCode = objDecrypt.Desencriptar(MoneyObj.bankCode);
                MoneyObj.phone = objDecrypt.Desencriptar(MoneyObj.phone);
                MoneyObj.sGroupBranchCode = objDecrypt.Desencriptar(MoneyObj.sGroupBranchCode);
                MoneyObj.sCurrencyPayCode = objDecrypt.Desencriptar(MoneyObj.sCurrencyPayCode);
                MoneyObj.sBranchCodePay = objDecrypt.Desencriptar(MoneyObj.sBranchCodePay);
                MoneyObj.currencyCode = objDecrypt.Desencriptar(MoneyObj.currencyCode);
                MoneyObj.currency = objDecrypt.Desencriptar(MoneyObj.currency);
                MoneyObj.typeAccount = objDecrypt.Desencriptar(MoneyObj.typeAccount);
                MoneyObj.accountNumber = objDecrypt.Desencriptar(MoneyObj.accountNumber);
                MoneyObj.idRegion = objDecrypt.Desencriptar(MoneyObj.idRegion);
                MoneyObj.aba = objDecrypt.Desencriptar(MoneyObj.aba);
                MoneyObj.swift = objDecrypt.Desencriptar(MoneyObj.swift);
                MoneyObj.iban = objDecrypt.Desencriptar(MoneyObj.iban);
                MoneyObj.idAgency = objDecrypt.Desencriptar(MoneyObj.idAgency);
                MoneyObj.agency = objDecrypt.Desencriptar(MoneyObj.agency);
                MoneyObj.institutionNumber = objDecrypt.Desencriptar(MoneyObj.institutionNumber);
                MoneyObj.officeNumber = objDecrypt.Desencriptar(MoneyObj.officeNumber);
                MoneyObj.Fixing = objDecrypt.Desencriptar(MoneyObj.Fixing);
                //MoneyObj.exchangeRateApplied = objDecrypt.Desencriptar(MoneyObj.exchangeRateApplied);
                MoneyObj.currencyPayment = objDecrypt.Desencriptar(MoneyObj.currencyPayment); // verificar luego
                MoneyObj.emailBeneficiary = objDecrypt.Desencriptar(MoneyObj.emailBeneficiary);
                MoneyObj.sendIdAgency = objDecrypt.Desencriptar(MoneyObj.sendIdAgency);
                //MoneyObj.currencyPayment
                MoneyObj.operationBoxOffice = objDecrypt.Desencriptar(MoneyObj.operationBoxOffice);
                MoneyObj.operationCashier = objDecrypt.Desencriptar(MoneyObj.operationCashier);
                MoneyObj.phoneRemitter = objDecrypt.Desencriptar(MoneyObj.phoneRemitter);
                MoneyObj.addressRemitter = objDecrypt.Desencriptar(MoneyObj.addressRemitter);
                MoneyObj.cityRemitter = objDecrypt.Desencriptar(MoneyObj.cityRemitter);
                MoneyObj.stateRemitter = objDecrypt.Desencriptar(MoneyObj.stateRemitter);
                MoneyObj.senderZipCode = objDecrypt.Desencriptar(MoneyObj.senderZipCode);
                MoneyObj.senderCountry = objDecrypt.Desencriptar(MoneyObj.senderCountry);
                MoneyObj.stateBeneficiary = objDecrypt.Desencriptar(MoneyObj.stateBeneficiary);
                MoneyObj.senderZipCodeBenef = objDecrypt.Desencriptar(MoneyObj.senderZipCodeBenef);
                return MoneyObj;
            }
            catch (Exception ex)
            {
                throw new Exception(" encryptMoneyObj: " + ex.Message.ToString());
            }
        }

        public static tReceiptElectronicMoney setPaymentKeyMoneyObj(this tReceiptElectronicMoney MoneyObj, string connection, string finaloperation, Traza Traza)
        {
            try
            {
                Datos AgencyData = new Datos(connection);
                string StrQuery = string.Format("EXEC uSpLocalMoneyPort '','','GETKEY','{0}'", finaloperation);
                DataTable tblObjMoney = AgencyData.ResultTableQuery(StrQuery);

                string moProviderAcronym = tblObjMoney.Rows[0]["providerAcronym"].ToString();
                MoneyObj.IdProvider = tblObjMoney.Rows[0]["idProvider"].ToString();
                MoneyObj.KeySender = moProviderAcronym + MoneyObj.IdProvider;

                return MoneyObj;
            }
            catch (Exception)
            {
                Traza.Escribir("Error sending transaction...");
                return MoneyObj;
            }
        }

        public static tReceiptElectronicMoney setPaymentKeyMoneyObjVEN(this tReceiptElectronicMoney MoneyObj, string connection, string finaloperation, Traza Traza)
        {
            try
            {
                string sendProviderAcronym = ConfigurationManager.AppSettings["COMPANY"];
                Datos AgencyData = new Datos(connection);
                string StrQuery = string.Format("EXEC uSpLocalMoneyPortVEN '','','GETKEY','{0}'", finaloperation);
                DataTable tblObjMoney = AgencyData.ResultTableQuery(StrQuery);

                string moProviderAcronym = tblObjMoney.Rows[0]["providerAcronym"].ToString();
                MoneyObj.IdProvider = tblObjMoney.Rows[0]["idProvider"].ToString();

                switch (moProviderAcronym)
                {
                    case "TN":
                        MoneyObj.KeySender = moProviderAcronym + finaloperation;
                        break;
                    case "CS":
                        if (sendProviderAcronym.Equals("IC"))
                        {
                            MoneyObj.KeySender = "ITA" + finaloperation;
                        }
                        else
                        {
                            MoneyObj.KeySender = "MUR" + finaloperation;
                        }
                        break;
                    case "ME":
                        if (sendProviderAcronym.Equals("IC"))
                        {
                            MoneyObj.KeySender = "ITC" + finaloperation;
                        }
                        else
                        {
                            MoneyObj.KeySender = "ITL" + finaloperation;
                        }
                        break;
                    case "FT":
                        MoneyObj.KeySender = "TF" + finaloperation;
                        break;
                    case "PQ":
                        MoneyObj.KeySender = "IPQ" + finaloperation;
                        break;
                    case "JP":
                        MoneyObj.KeySender = "IJP" + finaloperation;
                        break;
                    case "MR":
                        if (sendProviderAcronym.Equals("IC"))
                        {
                            MoneyObj.KeySender = "ITA" + finaloperation;
                        }
                        else
                        {
                            MoneyObj.KeySender = "MUR" + finaloperation;
                        }
                        break;
                    default:
                        MoneyObj.KeySender = moProviderAcronym + finaloperation;
                        break;
                }
                return MoneyObj;
            }
            catch (Exception)
            {
                Traza.Escribir("Error sending transaction...");
                return MoneyObj;
            }
        }

        public static tReceiptElectronicMoney getMoneyObjSicad2(this tReceiptElectronicMoney MoneyObj, string connection, string finaloperation, Traza Traza)
        {
            try
            {
                Datos AgencyData = new Datos(connection);
                string StrQuery = string.Format("EXEC uSpLocalMoneyPort '','',SENDALL,''");
                DataTable tblObjMoney = AgencyData.ResultTableQuery(StrQuery);

                MoneyObj.Aux0 = "";
                MoneyObj.Aux1 = "";
                MoneyObj.Aux2 = "";
                MoneyObj.Aux3 = "";
                MoneyObj.Aux4 = "";

                MoneyObj.IdSender = tblObjMoney.Rows[0]["IdSender"].ToString();
                MoneyObj.FirstNameSender = tblObjMoney.Rows[0]["FirstNameSender"].ToString();
                MoneyObj.SecondNameSender = tblObjMoney.Rows[0]["SecondNameSender"].ToString();
                MoneyObj.LastNameSender = tblObjMoney.Rows[0]["LastNameSender"].ToString();
                MoneyObj.SecondLastNamerSender = tblObjMoney.Rows[0]["SecondLastNamerSender"].ToString();
                MoneyObj.IdBeneficiary = tblObjMoney.Rows[0]["IdBeneficiary"].ToString();
                MoneyObj.FirstNameBeneficiary = tblObjMoney.Rows[0]["FirstNameBeneficiary"].ToString();
                MoneyObj.SecondNameBeneficiary = tblObjMoney.Rows[0]["SecondNameBeneficiary"].ToString();
                MoneyObj.LastNameBeneficiary = tblObjMoney.Rows[0]["LastNameBeneficiary"].ToString();
                MoneyObj.SecondLastNameBeneficiary = tblObjMoney.Rows[0]["SecondLastNameBeneficiary"].ToString();
                MoneyObj.AddressBeneficiary = tblObjMoney.Rows[0]["AddressBeneficiary"].ToString();
                MoneyObj.CityBeneficiary = tblObjMoney.Rows[0]["CityBeneficiary"].ToString();
                MoneyObj.Amount = tblObjMoney.Rows[0]["Amount"].ToString();
                MoneyObj.Country = tblObjMoney.Rows[0]["Country"].ToString();
                MoneyObj.PhoneBeneficiary = tblObjMoney.Rows[0]["PhoneBeneficiary"].ToString();
                //MoneyObj.KeySender = "keyTest"; // verificar luego
                MoneyObj.IdProvider = tblObjMoney.Rows[0]["IdProvider"].ToString();
                MoneyObj.pai_iso3 = tblObjMoney.Rows[0]["pai_iso3"].ToString();
                MoneyObj.paymenttype = tblObjMoney.Rows[0]["paymenttype"].ToString();
                MoneyObj.bankName = tblObjMoney.Rows[0]["bankName"].ToString();
                MoneyObj.bankAddress = tblObjMoney.Rows[0]["bankAddress"].ToString();
                MoneyObj.bankCode = tblObjMoney.Rows[0]["bankCode"].ToString();
                MoneyObj.phone = tblObjMoney.Rows[0]["phone"].ToString();
                MoneyObj.sGroupBranchCode = tblObjMoney.Rows[0]["sGroupBranchCode"].ToString();
                MoneyObj.sCurrencyPayCode = tblObjMoney.Rows[0]["sCurrencyPayCode"].ToString();
                MoneyObj.sBranchCodePay = tblObjMoney.Rows[0]["sBranchCodePay"].ToString();
                MoneyObj.currencyCode = tblObjMoney.Rows[0]["currencyCode"].ToString();
                MoneyObj.currency = tblObjMoney.Rows[0]["currency"].ToString();
                MoneyObj.typeAccount = tblObjMoney.Rows[0]["typeAccount"].ToString();
                MoneyObj.accountNumber = tblObjMoney.Rows[0]["accountNumber"].ToString();
                MoneyObj.idRegion = tblObjMoney.Rows[0]["idRegion"].ToString();
                MoneyObj.aba = tblObjMoney.Rows[0]["aba"].ToString();
                MoneyObj.swift = tblObjMoney.Rows[0]["swift"].ToString();
                MoneyObj.iban = tblObjMoney.Rows[0]["iban"].ToString();
                MoneyObj.idAgency = tblObjMoney.Rows[0]["idAgency"].ToString();
                MoneyObj.agency = tblObjMoney.Rows[0]["agency"].ToString();
                MoneyObj.institutionNumber = tblObjMoney.Rows[0]["institutionNumber"].ToString();
                MoneyObj.officeNumber = tblObjMoney.Rows[0]["officeNumber"].ToString();
                MoneyObj.Fixing = tblObjMoney.Rows[0]["Fixing"].ToString();
                //MoneyObj.exchangeRateApplied = tblObjMoney.Rows[0]["exchangeRateApplied"].ToString();
                //MoneyObj.currencyPayment = "D"; // verificar luego
                MoneyObj.emailBeneficiary = tblObjMoney.Rows[0]["emailBeneficiary"].ToString();
                MoneyObj.sendIdAgency = tblObjMoney.Rows[0]["sendIdAgency"].ToString();

                return MoneyObj;
            }
            catch (Exception)
            {
                //throw new Exception(" getMoneyObj: " + ex.Message.ToString());
                Traza.Escribir("Registry not Found in local DB");
                return MoneyObj;
            }
        }

    }

    public class MoneyBatch
    {

        public List<tReceiptElectronicMoney> MoneyList { get; set; }

        public List<tReceiptElectronicMoney> setMoneyBatch(string connection, string sendIdProvider, string receiptIdProvider, Traza Traza)
        {
            MoneyBatch moneyProvider = new MoneyBatch();

            //DataClass.Datos AgencyData = new DataClass.Datos(connection);

            try
            {
                Datos AgencyBatchData = new Datos(connection);
                string StrQuery = string.Format("EXEC uSpLocalMoneyPortVEN '','','SENDALL','','{0}'", receiptIdProvider); // returns list of moneyObjects
                DataTable tblBatch = AgencyBatchData.ResultTableQuery(StrQuery);


                MoneyList = tblBatch.AsEnumerable().Select(row => new tReceiptElectronicMoney
                {

                    IdSender = Convert.ToString(row.Field<string>("IdSender")),
                    FirstNameSender = Convert.ToString(row.Field<string>("FirstNameSender")),
                    SecondNameSender = Convert.ToString(row.Field<string>("SecondNameSender")),
                    LastNameSender = Convert.ToString(row.Field<string>("LastNameSender")),
                    SecondLastNamerSender = Convert.ToString(row.Field<string>("SecondLastNamerSender")),
                    IdBeneficiary = Convert.ToString(row.Field<string>("IdBeneficiary")),
                    FirstNameBeneficiary = Convert.ToString(row.Field<string>("FirstNameBeneficiary")),
                    SecondNameBeneficiary = Convert.ToString(row.Field<string>("SecondNameBeneficiary")),
                    LastNameBeneficiary = Convert.ToString(row.Field<string>("LastNameBeneficiary")),
                    SecondLastNameBeneficiary = Convert.ToString(row.Field<string>("SecondLastNameBeneficiary")),
                    AddressBeneficiary = Convert.ToString(row.Field<string>("AddressBeneficiary")),
                    CityBeneficiary = Convert.ToString(row.Field<string>("CityBeneficiary")),
                    Amount = Convert.ToString(row.Field<string>("Amount")),
                    Country = Convert.ToString(row.Field<string>("Country")),
                    PhoneBeneficiary = Convert.ToString(row.Field<string>("PhoneBeneficiary")),
                    IdProvider = row.Field<int>("IdProvider").ToString(),
                    pai_iso3 = Convert.ToString(row.Field<string>("pai_iso3")),
                    paymenttype = Convert.ToString(row.Field<string>("paymenttype")),
                    bankName = Convert.ToString(row.Field<string>("bankName")),
                    bankAddress = Convert.ToString(row.Field<string>("bankAddress")),
                    bankCode = Convert.ToString(row.Field<string>("bankCode")),
                    phone = Convert.ToString(row.Field<string>("phone")),
                    sGroupBranchCode = Convert.ToString(row.Field<string>("sGroupBranchCode")),
                    sCurrencyPayCode = Convert.ToString(row.Field<string>("sCurrencyPayCode")),
                    sBranchCodePay = Convert.ToString(row.Field<string>("sBranchCodePay")),
                    currencyCode = Convert.ToString(row.Field<string>("currencyCode")),
                    currency = Convert.ToString(row.Field<string>("currency")),
                    typeAccount = Convert.ToString(row.Field<string>("typeAccount")),
                    accountNumber = Convert.ToString(row.Field<string>("accountNumber")),
                    idRegion = Convert.ToString(row.Field<string>("idRegion")),
                    aba = Convert.ToString(row.Field<string>("aba")),
                    swift = Convert.ToString(row.Field<string>("swift")),
                    iban = Convert.ToString(row.Field<string>("iban")),
                    idAgency = Convert.ToString(row.Field<string>("idAgency")),
                    agency = Convert.ToString(row.Field<string>("agency")),
                    institutionNumber = Convert.ToString(row.Field<int>("institutionNumber")),
                    officeNumber = Convert.ToString(row.Field<string>("officeNumber")),
                    Fixing = Convert.ToString(row.Field<string>("Fixing")),
                    emailBeneficiary = Convert.ToString(row.Field<string>("emailBeneficiary")),
                    sendIdAgency = Convert.ToString(row.Field<int>("sendIdAgency")),
                    Aux0 = Convert.ToString(row.Field<string>("operationfinal")),
                    //exchangeRateApplied=Convert.ToString(row.Field<string>("exchangeRateApplied")),
                    //Add(mt);=Convert.ToString(row.Field<string>("Add(mt);")),
                    Aux1 = Convert.ToString(""),
                    Aux2 = Convert.ToString(""),
                    Aux3 = Convert.ToString(""),
                    Aux4 = Convert.ToString(""),
                    operationBoxOffice = Convert.ToString(row.Field<string>("operationBoxOffice")),
                    operationCashier = Convert.ToString(row.Field<string>("operationCashier")),
                    phoneRemitter = Convert.ToString(row.Field<string>("phoneRemitter")),
                    addressRemitter = Convert.ToString(row.Field<string>("addressRemitter")),
                    cityRemitter = Convert.ToString(row.Field<string>("cityRemitter")),
                    stateRemitter = Convert.ToString(row.Field<string>("stateRemitter")),
                    senderZipCode = Convert.ToString(row.Field<string>("senderZipCode")),
                    senderCountry = Convert.ToString(row.Field<string>("senderCountry")),
                    stateBeneficiary = Convert.ToString(row.Field<string>("stateBeneficiary")),
                    senderZipCodeBenef = Convert.ToString(row.Field<string>("senderZipCodeBenef")),
                    bankTypeAccount = Convert.ToString(row.Field<string>("bankTypeAccount"))
                }).ToList();

                return MoneyList;

            }
            catch (Exception ex)
            {
                Traza.Escribir("Error setMoneyBatch: " + ex);
                return MoneyList;

            }
        }
    }


}






