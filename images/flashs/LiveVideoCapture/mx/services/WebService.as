class mx.services.WebService
{
    var _name, _portName, _description, _proxyURI, _endpointReplacementURI, _timeout, gotWSDL, stub;
    function WebService(wsdlLocation, logObj, proxyURI, endpointProxyURI, serviceName, portName)
    {
        mx.services.Namespace.setup();
        _name = serviceName;
        _portName = portName;
        _description = null;
        _proxyURI = proxyURI;
        _endpointReplacementURI = endpointProxyURI;
        _timeout = -1;
        gotWSDL = false;
        stub = new mx.services.WebServiceProxy(this, wsdlLocation, logObj);
        function __resolve(methodName)
        {
            return (function ()
            {
                return (stub.invokeOperation(methodName, arguments));
            });
        } // End of the function
    } // End of the function
    function getCall(operationName)
    {
        return (stub.getCall(operationName));
    } // End of the function
    function onLoad(wsdl)
    {
    } // End of the function
    function onFault(fault)
    {
    } // End of the function
} // End of Class
