class mx.services.SchemaVersion
{
    var xsdURI, xsiURI, schemaQName, allQName, complexTypeQName, elementTypeQName, importQName, simpleTypeQName, complexContentQName, sequenceQName, simpleContentQName, restrictionQName, attributeQName, extensionQName, nilQName;
    static var version2001, version2000, version1999;
    function SchemaVersion(xsdURI, xsiURI)
    {
        this.xsdURI = xsdURI;
        this.xsiURI = xsiURI;
        schemaQName = new mx.services.QName("schema", xsdURI);
        allQName = new mx.services.QName("all", xsdURI);
        complexTypeQName = new mx.services.QName("complexType", xsdURI);
        elementTypeQName = new mx.services.QName("element", xsdURI);
        importQName = new mx.services.QName("import", xsdURI);
        simpleTypeQName = new mx.services.QName("simpleType", xsdURI);
        complexContentQName = new mx.services.QName("complexContent", xsdURI);
        sequenceQName = new mx.services.QName("sequence", xsdURI);
        simpleContentQName = new mx.services.QName("simpleContent", xsdURI);
        restrictionQName = new mx.services.QName("restriction", xsdURI);
        attributeQName = new mx.services.QName("attribute", xsdURI);
        extensionQName = new mx.services.QName("extension", xsdURI);
        var _loc3 = "nil";
        if (xsdURI == mx.services.SchemaVersion.XSD_URI_1999)
        {
            _loc3 = "null";
        } // end if
        nilQName = new mx.services.QName(_loc3, xsiURI);
    } // End of the function
    static function getSchemaVersion(xsdURI)
    {
        if (xsdURI == mx.services.SchemaVersion.XSD_URI_2001)
        {
            if (mx.services.SchemaVersion.version2001 == undefined)
            {
                version2001 = new mx.services.SchemaVersion(mx.services.SchemaVersion.XSD_URI_2001, mx.services.SchemaVersion.XSI_URI_2001);
            } // end if
            return (mx.services.SchemaVersion.version2001);
        } // end if
        if (xsdURI == mx.services.SchemaVersion.XSD_URI_2000)
        {
            if (mx.services.SchemaVersion.version2000 == undefined)
            {
                version2000 = new mx.services.SchemaVersion(mx.services.SchemaVersion.XSD_URI_2000, mx.services.SchemaVersion.XSI_URI_2000);
            } // end if
            return (mx.services.SchemaVersion.version2000);
        } // end if
        if (xsdURI == mx.services.SchemaVersion.XSD_URI_1999)
        {
            if (mx.services.SchemaVersion.version1999 == undefined)
            {
                version1999 = new mx.services.SchemaVersion(mx.services.SchemaVersion.XSD_URI_1999, mx.services.SchemaVersion.XSI_URI_1999);
            } // end if
            return (mx.services.SchemaVersion.version1999);
        } // end if
    } // End of the function
    static var XML_SCHEMA_URI = "http://www.w3.org/2001/XMLSchema";
    static var SOAP_ENCODING_URI = "http://schemas.xmlsoap.org/soap/encoding/";
    static var XSD_URI_1999 = "http://www.w3.org/1999/XMLSchema";
    static var XSD_URI_2000 = "http://www.w3.org/2000/10/XMLSchema";
    static var XSD_URI_2001 = "http://www.w3.org/2001/XMLSchema";
    static var XSI_URI_1999 = "http://www.w3.org/1999/XMLSchema-instance";
    static var XSI_URI_2000 = "http://www.w3.org/2000/10/XMLSchema-instance";
    static var XSI_URI_2001 = "http://www.w3.org/2001/XMLSchema-instance";
    static var APACHESOAP_URI = "http://xml.apache.org/xml-soap";
    static var CF_RPC_URI = "http://rpc.xml.coldfusion";
} // End of Class
