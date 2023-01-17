class mx.services.SOAPFault
{
    var faultcode, faultstring, detail, element, faultNamespaceURI, faultactor;
    function SOAPFault(fcode, fstring, detail, element, faultNS, faultactor)
    {
        faultcode = fcode;
        faultstring = fstring;
        this.detail = detail;
        this.element = element;
        faultNamespaceURI = faultNS;
        this.faultactor = faultactor;
    } // End of the function
} // End of Class
