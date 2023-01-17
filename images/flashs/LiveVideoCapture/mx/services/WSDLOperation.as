class mx.services.WSDLOperation
{
    var name, wsdl, document, inputMessage, input, outputMessage, output;
    function WSDLOperation(name, wsdl, document)
    {
        this.name = name;
        this.wsdl = wsdl;
        this.document = document;
    } // End of the function
    function parseMessages()
    {
        var _loc2 = wsdl;
        input = _loc2.parseMessage(inputMessage, name, mx.services.SOAPConstants.MODE_IN, document);
        output = _loc2.parseMessage(outputMessage, name, mx.services.SOAPConstants.MODE_OUT, document);
    } // End of the function
} // End of Class
