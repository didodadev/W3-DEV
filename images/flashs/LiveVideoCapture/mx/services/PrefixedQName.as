class mx.services.PrefixedQName
{
    var prefix, qname, qualifiedName;
    function PrefixedQName(prefix, qname)
    {
        this.prefix = prefix;
        this.qname = qname;
        qualifiedName = prefix;
        if (prefix != "")
        {
            qualifiedName = qualifiedName + ":";
        } // end if
        qualifiedName = qualifiedName + qname.localPart;
    } // End of the function
} // End of Class
