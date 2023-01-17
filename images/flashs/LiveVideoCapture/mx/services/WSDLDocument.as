class mx.services.WSDLDocument
{
    var xmlDoc, targetNamespace, bindingElements, portTypeElements, messageElements, serviceElements;
    function WSDLDocument(document, wsdl)
    {
        xmlDoc = document;
        var _loc8 = document.firstChild;
        var _loc6 = wsdl.constants;
        var _loc9 = _loc8.getQName();
        if (!_loc9.equals(_loc6.definitionsQName))
        {
            wsdl.fault = new mx.services.SOAPFault("Server", "Faulty WSDL format", "Definitions must be the first element in a WSDL document");
            return;
        } // end if
        targetNamespace = _loc8.attributes.targetNamespace;
        bindingElements = new Object();
        portTypeElements = new Object();
        messageElements = new Object();
        serviceElements = new Object();
        var _loc3 = _loc8.childNodes;
        for (var _loc2 = 0; _loc2 < _loc3.length; ++_loc2)
        {
            var _loc4 = _loc3[_loc2].getQName();
            var _loc5 = _loc3[_loc2].attributes.name;
            if (_loc4.equals(_loc6.bindingQName))
            {
                bindingElements[_loc5] = _loc3[_loc2];
                continue;
            } // end if
            if (_loc4.equals(_loc6.portTypeQName))
            {
                portTypeElements[_loc5] = _loc3[_loc2];
                continue;
            } // end if
            if (_loc4.equals(_loc6.messageQName))
            {
                messageElements[_loc5] = _loc3[_loc2];
                continue;
            } // end if
            if (_loc4.equals(_loc6.serviceQName))
            {
                serviceElements[_loc5] = _loc3[_loc2];
                continue;
            } // end if
            if (_loc4.equals(_loc6.typesQName))
            {
                wsdl.parseSchemas(_loc3[_loc2]);
            } // end if
        } // end of for
    } // End of the function
    function getBindingElement(name)
    {
        return (bindingElements[name]);
    } // End of the function
    function getMessageElement(name)
    {
        return (messageElements[name]);
    } // End of the function
    function getPortTypeElement(name)
    {
        return (portTypeElements[name]);
    } // End of the function
    function getServiceElement(name)
    {
        return (serviceElements[name]);
    } // End of the function
} // End of Class
