class mx.services.WSDLConstants
{
    function WSDLConstants()
    {
    } // End of the function
    static function getConstants(versionNumber)
    {
        var _loc1 = new Object();
        _loc1.definitionsQName = new mx.services.QName("definitions", mx.services.WSDLConstants.WSDL_URI);
        _loc1.typesQName = new mx.services.QName("types", mx.services.WSDLConstants.WSDL_URI);
        _loc1.messageQName = new mx.services.QName("message", mx.services.WSDLConstants.WSDL_URI);
        _loc1.portTypeQName = new mx.services.QName("portType", mx.services.WSDLConstants.WSDL_URI);
        _loc1.bindingQName = new mx.services.QName("binding", mx.services.WSDLConstants.WSDL_URI);
        _loc1.serviceQName = new mx.services.QName("service", mx.services.WSDLConstants.WSDL_URI);
        _loc1.importQName = new mx.services.QName("import", mx.services.WSDLConstants.WSDL_URI);
        _loc1.documentationQName = new mx.services.QName("documentation", mx.services.WSDLConstants.WSDL_URI);
        _loc1.portQName = new mx.services.QName("port", mx.services.WSDLConstants.WSDL_URI);
        _loc1.soapAddressQName = new mx.services.QName("address", mx.services.WSDLConstants.WSDL_SOAP_URI);
        _loc1.bindingQName = new mx.services.QName("binding", mx.services.WSDLConstants.WSDL_URI);
        _loc1.soapBindingQName = new mx.services.QName("binding", mx.services.WSDLConstants.WSDL_SOAP_URI);
        _loc1.operationQName = new mx.services.QName("operation", mx.services.WSDLConstants.WSDL_URI);
        _loc1.soapOperationQName = new mx.services.QName("operation", mx.services.WSDLConstants.WSDL_SOAP_URI);
        _loc1.documentationQName = new mx.services.QName("documentation", mx.services.WSDLConstants.WSDL_URI);
        _loc1.soapBodyQName = new mx.services.QName("body", mx.services.WSDLConstants.WSDL_SOAP_URI);
        _loc1.inputQName = new mx.services.QName("input", mx.services.WSDLConstants.WSDL_URI);
        _loc1.outputQName = new mx.services.QName("output", mx.services.WSDLConstants.WSDL_URI);
        _loc1.parameterQName = new mx.services.QName("part", mx.services.WSDLConstants.WSDL_URI);
        return (_loc1);
    } // End of the function
    static var WSDL_URI = "http://schemas.xmlsoap.org/wsdl/";
    static var WSDL_SOAP_URI = "http://schemas.xmlsoap.org/wsdl/soap/";
    static var SOAP_ENVELOPE_URI = "http://schemas.xmlsoap.org/soap/envelope/";
    static var SOAP_ENCODING_URI = "http://schemas.xmlsoap.org/wsdl/soap/encoding/";
    static var HTTP_WSDL_URI = "http://schemas.xmlsoap.org/wsdl/http/";
    static var HTTP_SOAP_URI = "http://schemas.xmlsoap.org/soap/http";
    static var MACROMEDIA_SOAP_URI = "http://www.macromedia.com/soap/";
    static var DEFAULT_STYLE = "document";
} // End of Class
