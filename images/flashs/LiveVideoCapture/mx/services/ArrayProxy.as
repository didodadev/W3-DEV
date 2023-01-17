class mx.services.ArrayProxy extends Array
{
    var xmlNodes, sCall, arrayType, length, index;
    function ArrayProxy(xmlNodes, sCall, arrayType)
    {
        super();
        this.xmlNodes = xmlNodes;
        this.sCall = sCall;
        this.arrayType = arrayType;
        length = xmlNodes.length;
    } // End of the function
    function __resolve(index)
    {
        index = Number(index);
        var _loc2 = sCall.decodeResultNode(xmlNodes[index], arrayType);
        this[index] = _loc2;
        return (_loc2);
    } // End of the function
} // End of Class
