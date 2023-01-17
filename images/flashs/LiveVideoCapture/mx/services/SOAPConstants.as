class mx.services.SOAPConstants
{
    var contentType, ENVELOPE_URI, ENCODING_URI, envelopeQName, headerQName, bodyQName, faultQName, actorQName, soapencArrayQName, soapencArrayTypeQName, soapencRefQName;
    static var soap11Constants, soap12Constants;
    function SOAPConstants()
    {
    } // End of the function
    static function getConstants(versionNumber)
    {
        if (versionNumber < 2)
        {
            if (mx.services.SOAPConstants.soap11Constants == undefined)
            {
                soap11Constants = new mx.services.SOAPConstants();
                mx.services.SOAPConstants.soap11Constants.setSOAP11();
            } // end if
            return (mx.services.SOAPConstants.soap11Constants);
        }
        else
        {
            if (mx.services.SOAPConstants.soap12Constants == undefined)
            {
                soap12Constants = new mx.services.SOAPConstants();
                mx.services.SOAPConstants.soap12Constants.setSOAP12();
            } // end if
            return (mx.services.SOAPConstants.soap12Constants);
        } // end else if
    } // End of the function
    function setSOAP11()
    {
        contentType = "text/xml; charset=utf-8";
        ENVELOPE_URI = "http://schemas.xmlsoap.org/soap/envelope/";
        ENCODING_URI = "http://schemas.xmlsoap.org/soap/encoding/";
        this.setupConstants();
    } // End of the function
    function setSOAP12()
    {
        contentType = "application/soap+xml; charset=utf-8";
        ENVELOPE_URI = "http://www.w3.org/2002/12/soap-envelope";
        ENCODING_URI = "http://www.w3.org/2002/12/soap-encoding";
        this.setupConstants();
    } // End of the function
    function setupConstants()
    {
        envelopeQName = new mx.services.QName("Envelope", ENVELOPE_URI);
        headerQName = new mx.services.QName("Header", ENVELOPE_URI);
        bodyQName = new mx.services.QName("Body", ENVELOPE_URI);
        faultQName = new mx.services.QName("Fault", ENVELOPE_URI);
        actorQName = new mx.services.QName("Actor", ENVELOPE_URI);
        soapencArrayQName = new mx.services.QName("Array", ENCODING_URI);
        soapencArrayTypeQName = new mx.services.QName("arrayType", ENCODING_URI);
        soapencRefQName = new mx.services.QName("multiRef", ENCODING_URI);
    } // End of the function
    static var DEFAULT_VERSION = 0;
    static var XML_DECLARATION = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r";
    static var RPC_STYLE = "rpc";
    static var DOC_STYLE = "document";
    static var WRAPPED_STYLE = "wrapped";
    static var USE_ENCODED = "encoded";
    static var USE_LITERAL = "literal";
    static var DEFAULT_OPERATION_STYLE = mx.services.SOAPConstants.RPC_STYLE;
    static var DEFAULT_USE = mx.services.SOAPConstants.USE_ENCODED;
    static var SOAP_ENV_PREFIX = "SOAP-ENV";
    static var SOAP_ENC_PREFIX = "soapenc";
    static var XML_SCHEMA_PREFIX = "xsd";
    static var XML_SCHEMA_INSTANCE_PREFIX = "xsi";
    static var XML_SCHEMA_URI = "http://www.w3.org/2001/XMLSchema";
    static var XML_SCHEMA_INSTANCE_URI = "http://www.w3.org/2001/XMLSchema-instance";
    static var SCHEMA_INSTANCE_TYPE = mx.services.SOAPConstants.XML_SCHEMA_INSTANCE_PREFIX + ":type";
    static var ARRAY_PQNAME = mx.services.SOAPConstants.SOAP_ENC_PREFIX + ":Array";
    static var ARRAY_TYPE_PQNAME = mx.services.SOAPConstants.SOAP_ENC_PREFIX + ":arrayType";
    static var MODE_IN = 0;
    static var MODE_OUT = 1;
    static var MODE_INOUT = 2;
    static var DISCONNECTED_FAULT_CODE = "Client.Disconnected";
} // End of Class
