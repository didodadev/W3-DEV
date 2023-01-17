class mx.services.SOAPParameter
{
    var name, schemaType, mode, qname;
    function SOAPParameter(name, schemaType, mode, qname)
    {
        this.name = name;
        this.schemaType = schemaType;
        this.mode = mode == undefined ? (mx.services.SOAPConstants.MODE_IN) : (mode);
        this.qname = qname;
    } // End of the function
} // End of Class
