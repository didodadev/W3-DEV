class mx.services.QName
{
    var localPart, namespaceURI;
    function QName(localPart, namespaceURI)
    {
        this.localPart = localPart == undefined ? ("") : (localPart);
        this.namespaceURI = namespaceURI == undefined ? ("") : (namespaceURI);
    } // End of the function
    function equals(qname)
    {
        return (namespaceURI == qname.namespaceURI && localPart == qname.localPart);
    } // End of the function
} // End of Class
