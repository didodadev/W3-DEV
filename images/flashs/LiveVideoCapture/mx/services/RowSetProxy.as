class mx.services.RowSetProxy extends Array
{
    var sCall, xmlNodes, types, fields, length, views, index;
    function RowSetProxy(sCall, xmlNodes, types, fields)
    {
        super();
        this.sCall = sCall;
        this.xmlNodes = xmlNodes;
        this.types = types;
        this.fields = fields;
        length = xmlNodes.length;
        views = new Array();
    } // End of the function
    function __resolve(index)
    {
        index = Number(index);
        if (index < 0 || index > length)
        {
            return;
        } // end if
        var _loc3 = sCall.decodeRowSetItem(xmlNodes[index], types, fields);
        this[index] = _loc3;
        return (_loc3);
    } // End of the function
    function getColumnNames()
    {
        return (fields);
    } // End of the function
} // End of Class
