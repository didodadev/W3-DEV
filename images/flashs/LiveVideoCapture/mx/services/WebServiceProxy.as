class mx.services.WebServiceProxy
{
    var log, service, wsdlURI, _parentLog, wsdl, serviceProxy, _servicePortMappings, timerID, __handleFault, onFault, activePort, stub, waitingOps, callQueue, cancelled, originalPromise, request, response;
    function WebServiceProxy(webservice, wsdlLocation, logObj)
    {
        log = logObj;
        log.logInfo("Creating stub for " + wsdlLocation, mx.services.Log.VERBOSE);
        service = webservice;
        var _loc3;
        if (_loc3 == undefined)
        {
            _loc3 = service._proxyURI;
        } // end if
        if (_loc3 != undefined)
        {
            wsdlLocation = this.buildURL(_loc3) + "?target=" + escape(wsdlLocation);
        } // end if
        wsdlURI = this.buildURL(wsdlLocation);
        var _loc2 = new mx.services.Log(log.level, "WSDL");
        _loc2._parentLog = log;
        _loc2.onLog = function (txt)
        {
            _parentLog.onLog(txt);
        };
        wsdl = new mx.services.WSDL(wsdlURI, this, _loc2);
        wsdl.onLoad = function ()
        {
            serviceProxy.onWSDL();
        };
        log.logInfo("Created stub for " + wsdlURI, mx.services.Log.VERBOSE);
    } // End of the function
    function buildURL(url)
    {
        var _loc2 = url;
        if (url.indexOf("http://") == -1 && url.indexOf("https://") == -1)
        {
            var _loc3 = _root._url.indexOf("/", 8);
            if (_loc3 != -1)
            {
                _loc2 = _root._url.substring(0, _loc3) + url;
            } // end if
        } // end if
        return (_loc2);
    } // End of the function
    function onWSDL()
    {
        var _loc12 = wsdl.fault;
        if (_loc12 == undefined)
        {
            var _loc8 = new Object();
            var _loc10 = wsdl.services;
            var _loc7 = 0;
            var _loc5 = null;
            var _loc6 = null;
            for (var _loc9 in _loc10)
            {
                var _loc4 = new Object();
                var _loc3 = wsdl.services[_loc9].ports;
                for (var _loc11 in _loc3)
                {
                    var _loc2 = this.createCallsFromPort(_loc3[_loc11]);
                    _loc4[_loc11] = _loc2;
                    if (_loc5 == undefined)
                    {
                        _loc5 = _loc11;
                        _loc6 = _loc9;
                    } // end if
                    ++_loc7;
                } // end of for...in
                _loc8[_loc9] = _loc4;
            } // end of for...in
            _servicePortMappings = _loc8;
            _loc9 = service._name;
            _loc11 = service._portName;
            if (_loc9 == undefined && _loc11 == undefined)
            {
                if (_loc7 == 1)
                {
                    _loc9 = _loc6;
                    _loc11 = _loc5;
                }
                else if (_loc7 == 0)
                {
                    _loc12 = new mx.services.SOAPFault("WSDL.NoPorts", "There are no valid services/ports in the WSDL file!");
                }
                else
                {
                    _loc12 = new mx.services.SOAPFault("WSDL.MultiplePorts", "There are multiple possible ports in the WSDL file; please specify a service name and port name!");
                } // end else if
            } // end else if
            if (_loc12 == undefined)
            {
                if (_loc9 == undefined)
                {
                    _loc9 = _loc6;
                } // end if
                if (_loc11 == undefined)
                {
                    _loc11 = _loc5;
                } // end if
                var _loc13 = this.setPort(_loc11, _loc9);
                if (_loc13 == undefined)
                {
                    return;
                } // end if
                log.logInfo("Set active port in service stub: " + _loc9 + " : " + _loc11, mx.services.Log.VERBOSE);
                service.gotWSDL = true;
                service.onLoad.call(service, wsdl.document);
            } // end if
        } // end if
        if (_loc12 != undefined)
        {
            service.onFault.call(service, _loc12);
            log.logDebug("Service stub found fault upon receiving WSDL: " + _loc12.faultstring);
        } // end if
        service.__resolve = function (operationName)
        {
            var callback = new mx.services.PendingCall();
            callback.genSingleConcurrencyFault = function ()
            {
                clearInterval(timerID);
                var _loc2 = new mx.services.SOAPFault("Client.NoSuchMethod", "Couldn\'t find method \'" + operationName + "\' in service!");
                this.__handleFault(_loc2);
                this.onFault(_loc2);
            };
            callback.timerID = setInterval(function ()
            {
                callback.genSingleConcurrencyFault();
            }, 50);
            return (callback);
        };
        this.unEnqueueCalls(_loc12);
    } // End of the function
    function setPort(portName, serviceName)
    {
        var _loc4 = serviceName == undefined ? (service._name) : (serviceName);
        var service = _servicePortMappings[_loc4];
        if (service == undefined)
        {
            service.onFault(new mx.services.SOAPFault("Client.NoSuchService", "Couldn\'t find service \'" + _loc4 + "\'"));
            return;
        } // end if
        var _loc3 = _servicePortMappings[_loc4][portName];
        if (_loc3 == undefined)
        {
            service.onFault(new mx.services.SOAPFault("Client.NoSuchPort", "Couldn\'t find a matching port (service = \'" + _loc4 + "\', port = \'" + portName + "\')"));
            return;
        } // end if
        for (var _loc5 in activePort)
        {
            service[_loc5] = undefined;
        } // end of for...in
        for (var _loc5 in _loc3)
        {
            service[_loc5] = function ()
            {
                return (stub.invokeOperation(arguments.callee.name, arguments));
            };
            service[_loc5].name = _loc5;
        } // end of for...in
        activePort = _loc3;
        service._name = _loc4;
        service._description = _servicePortMappings[_loc4].description;
        return (activePort);
    } // End of the function
    function createCallsFromPort(wsdlPort)
    {
        var _loc17 = new Object();
        var _loc20 = wsdlPort.binding;
        var _loc19 = _loc20.portType;
        var _loc16 = _loc19.operations;
        var _loc13 = wsdlPort.endpointURI;
        if (service._endpointReplacementURI != undefined)
        {
            var _loc21 = _loc13.indexOf("/", 7);
            _loc13 = service._endpointReplacementURI + _loc13.substring(_loc21);
        } // end if
        var _loc23;
        var _loc18 = wsdl.schemas;
        var _loc14 = service._proxyURI;
        if (_loc14 != undefined)
        {
            _loc14 = this.buildURL(_loc14);
        } // end if
        var _loc15 = waitingOps;
        var _loc4;
        for (var _loc4 in _loc16)
        {
            var _loc3 = _loc16[_loc4];
            var _loc7 = _loc3.actionURI;
            var _loc12 = _loc3.style;
            var _loc6 = _loc3.inputEncoding;
            var _loc10 = _loc6.use;
            var _loc9 = _loc6.namespaceURI;
            var _loc11 = _loc6.encodingStyle;
            var _loc5 = new mx.services.Log(log.level, "SOAP");
            _loc5._parentLog = log;
            _loc5.onLog = function (txt)
            {
                _parentLog.onLog(txt);
            };
            var _loc8 = _loc13;
            if (_loc14 != undefined)
            {
                _loc8 = _loc14 + "?transport=SoapHttp&action=" + escape(_loc7) + "&target=" + escape(_loc13);
            } // end if
            var _loc2 = _loc15[_loc4];
            if (_loc2 != undefined)
            {
                delete _loc15[_loc4];
            }
            else
            {
                _loc2 = new mx.services.SOAPCall(_loc4);
            } // end else if
            _loc2.targetNamespace = _loc9;
            _loc2.endpointURI = _loc8;
            _loc2.log = _loc5;
            _loc2.operationStyle = _loc12;
            _loc2.useStyle = _loc10;
            _loc2.encodingStyle = _loc11;
            _loc2.actionURI = _loc7;
            _loc2.schemaContext = _loc18;
            _loc2.wsdlOperation = _loc3;
            if (_loc3.description != undefined)
            {
                _loc2.description = _loc3.description;
            } // end if
            _loc17[_loc4] = _loc2;
            log.logInfo("Made SOAPCall for operation " + _loc4, mx.services.Log.BRIEF);
        } // end of for...in
        return (_loc17);
    } // End of the function
    function invokeOperation(operationName, args)
    {
        var _loc2;
        if (wsdl.fault != undefined)
        {
            if (wsdl.fault.faultcode == mx.services.SOAPConstants.DISCONNECTED_FAULT_CODE)
            {
                _loc2 = this.enqueueCall(operationName, args);
            }
            else
            {
                service.onFault.call(service, wsdl.fault);
            } // end else if
        }
        else if (wsdl.rootWSDL.xmlDoc == undefined || !wsdl.rootWSDL.xmlDoc.loaded)
        {
            _loc2 = this.enqueueCall(operationName, args);
            log.logInfo("Queing call " + operationName);
        }
        else
        {
            _loc2 = this.invokeCall(operationName, args);
            if (_loc2 == undefined)
            {
                var _loc5 = new mx.services.SOAPFault("Client.NoSuchMethod", "Couldn\'t find method \'" + operationName + "\' in service!");
                service.onFault.call(service, _loc5);
                return;
            } // end if
            log.logInfo("Invoking call " + operationName);
        } // end else if
        return (_loc2);
    } // End of the function
    function getCall(operationName)
    {
        if (wsdl.rootWSDL.xmlDoc != undefined && wsdl.rootWSDL.xmlDoc.loaded)
        {
            return (activePort[operationName]);
        } // end if
        var _loc2 = waitingOps;
        if (_loc2 == undefined)
        {
            _loc2 = new Object();
            waitingOps = _loc2;
        } // end if
        var _loc3 = _loc2[operationName];
        if (_loc3 == undefined)
        {
            _loc3 = new mx.services.SOAPCall(operationName);
            _loc2[operationName] = _loc3;
        } // end if
        return (_loc3);
    } // End of the function
    function invokeCall(operationName, parameters)
    {
        var _loc2 = activePort[operationName];
        if (_loc2 == undefined)
        {
            return;
        } // end if
        if (service._timeout != -1)
        {
            _loc2.timeout = service._timeout;
        } // end if
        var _loc3 = _loc2.asyncInvoke(parameters, "onLoad");
        return (_loc3);
    } // End of the function
    function enqueueCall(operationName, args)
    {
        if (callQueue == undefined)
        {
            callQueue = new Array();
        } // end if
        var _loc2 = new Object();
        _loc2.operationName = operationName;
        _loc2.args = args;
        _loc2.cancel = function ()
        {
            cancelled = true;
        };
        callQueue.push(_loc2);
        return (_loc2);
    } // End of the function
    function unEnqueueCalls(fault)
    {
        var _loc7 = waitingOps;
        if (_loc7 != undefined)
        {
            for (var _loc10 in _loc7)
            {
                var _loc6 = _loc7[_loc10];
                if (fault != undefined)
                {
                    _loc6.onFault(fault);
                    continue;
                } // end if
                var _loc3 = activePort[_loc10];
                if (_loc3 == undefined)
                {
                    _loc6.onFault(new mx.services.SOAPFault("Client.NoSuchMethod", "Couldn\'t find method \'" + _loc10 + "\' in service!"));
                    continue;
                } // end if
            } // end of for...in
        } // end if
        var _loc8 = callQueue;
        if (_loc8 != undefined)
        {
            var _loc9 = _loc8.length;
            for (var _loc4 = 0; _loc4 < _loc9; ++_loc4)
            {
                var _loc2 = _loc8[_loc4];
                if (_loc2.cancelled)
                {
                    continue;
                } // end if
                if (fault != undefined)
                {
                    log.logInfo("Faulting previously queued call " + _loc2.operationName);
                    _loc2.onFault(fault);
                    continue;
                } // end if
                log.logInfo("Invoking previously queued call " + _loc2.operationName);
                _loc3 = this.invokeCall(_loc2.operationName, _loc2.args);
                if (_loc3 == undefined)
                {
                    fault = new mx.services.SOAPFault("Client.NoSuchMethod", "Couldn\'t find method \'" + _loc2.operationName + "\' in service!");
                    _loc2.onFault(fault);
                    return;
                } // end if
                _loc3.originalPromise = _loc2;
                _loc2.myCall = _loc3.myCall;
                _loc3.timerObj = _loc2.timerObj;
                _loc3.onResult = function (result, response)
                {
                    originalPromise.request = request;
                    originalPromise.response = this.response;
                    originalPromise.onResult(result, response);
                };
                _loc3.onFault = function (fault)
                {
                    originalPromise.request = request;
                    originalPromise.response = response;
                    originalPromise.onFault(fault);
                };
                _loc3.__handleResult = function (result, response)
                {
                    originalPromise.request = request;
                    originalPromise.response = this.response;
                    originalPromise.__handleResult(result, response);
                };
                _loc3.__handleFault = function (fault)
                {
                    originalPromise.request = request;
                    originalPromise.response = response;
                    originalPromise.__handleFault(fault);
                };
                _loc3.onHeaders = function (headers, response)
                {
                    originalPromise.request = request;
                    originalPromise.response = this.response;
                    originalPromise.onHeaders(headers, response);
                };
            } // end of for
        } // end if
    } // End of the function
} // End of Class
