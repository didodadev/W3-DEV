class mx.services.SOAPCall
{
    var log, operationName, targetNamespace, endpointURI, parameters, concurrency, timeout, version, schemaContext, schemaVersion, soapConstants, doLazyDecoding, doDecoding, operationStyle, useStyle, encodingStyle, actionURI, request, wsdlOperation, elementFormQualified, currentlyActive, callback, _networkTimeMark, _startTimeMark, _networkTime, parseXML, loaded, _parseTimeMark, _parseTime, timerID, fault, __handleFault, onFault;
    function SOAPCall(operationName, targetNamespace, endpointURI, logObj, operationStyle, useStyle, encodingStyle, soapAction, soapVersion, schemaContext)
    {
        log = logObj;
        log.logInfo("Creating SOAPCall for " + operationName, mx.services.Log.VERBOSE);
        log.logDebug("SOAPCall endpoint URI: " + endpointURI);
        this.operationName = operationName;
        this.targetNamespace = targetNamespace;
        this.endpointURI = endpointURI;
        parameters = new Array();
        concurrency = mx.services.SOAPCall.MULTIPLE_CONCURRENCY;
        timeout = undefined;
        version = soapVersion == undefined ? (mx.services.SOAPConstants.DEFAULT_VERSION) : (soapVersion);
        this.schemaContext = schemaContext;
        var _loc2 = schemaContext.schemaVersion;
        schemaVersion = _loc2 == undefined ? (mx.services.SchemaVersion.getSchemaVersion(mx.services.SchemaVersion.XSD_URI_2001)) : (_loc2);
        soapConstants = mx.services.SOAPConstants.getConstants(version);
        doLazyDecoding = true;
        doDecoding = true;
        this.operationStyle = operationStyle == undefined ? (mx.services.SOAPConstants.DEFAULT_OPERATION_STYLE) : (operationStyle);
        this.useStyle = useStyle == undefined ? (mx.services.SOAPConstants.DEFAULT_USE) : (useStyle);
        this.encodingStyle = encodingStyle == undefined ? (soapConstants.ENCODING_URI) : (encodingStyle);
        actionURI = soapAction == undefined || soapAction == "" ? (this.targetNamespace + "/" + this.operationName) : (soapAction);
        log.logInfo("Successfully created SOAPCall", mx.services.Log.VERBOSE);
    } // End of the function
    function addParameter(soapParam)
    {
        parameters.push(soapParam);
    } // End of the function
    function invoke()
    {
        if (request == undefined)
        {
            return;
        } // end if
        return (this.asyncInvoke(request, "onLoad"));
    } // End of the function
    function asyncInvoke(args, callbackMethod)
    {
        var callback = new mx.services.PendingCall(this);
        if (!initialized)
        {
            wsdlOperation.parseMessages();
            if (wsdlOperation.input.isWrapped)
            {
                operationStyle = mx.services.SOAPConstants.WRAPPED_STYLE;
                targetNamespace = wsdlOperation.input.targetNamespace;
                elementFormQualified = wsdlOperation.input.isQualified;
            } // end if
            if (wsdlOperation.wsdl.fault != undefined)
            {
                this.triggerDelayedFault(callback, wsdlOperation.wsdl.fault);
                return (callback);
            } // end if
            var _loc4 = wsdlOperation.input.parameters;
            var _loc8 = _loc4.length;
            for (var _loc2 = 0; _loc2 < _loc8; ++_loc2)
            {
                this.addParameter(_loc4[_loc2]);
            } // end of for
            var _loc5 = wsdlOperation.output.parameters;
            var _loc6 = _loc5.length;
            for (var _loc2 = 0; _loc2 < _loc6; ++_loc2)
            {
                this.addParameter(_loc5[_loc2]);
            } // end of for
            initialized = true;
        } // end if
        log.logInfo("Asynchronously invoking SOAPCall: " + operationName);
        var _loc10;
        if (log.level > mx.services.Log.BRIEF)
        {
            _loc10 = new Date();
        } // end if
        if (concurrency != mx.services.SOAPCall.MULTIPLE_CONCURRENCY && currentlyActive != undefined)
        {
            if (concurrency == mx.services.SOAPCall.SINGLE_CONCURRENCY)
            {
                var _loc11 = new mx.services.SOAPFault("ConcurrencyError", "Attempt to call method " + operationName + " while another call is pending.  Either change concurrency options or avoid multiple calls.");
                this.triggerDelayedFault(callback, _loc11);
                return (callback);
            }
            else
            {
                currentlyActive.cancel();
            } // end if
        } // end else if
        currentlyActive = callback;
        if (concurrency == mx.services.SOAPCall.SINGLE_CONCURRENCY)
        {
            callback.isSingleCall = true;
        } // end if
        callback.encode();
        callback.callbackMethod = callbackMethod;
        callback.setupParams(args);
        var _loc7 = new XML();
        _loc7.ignoreWhite = true;
        _loc7.callback = callback;
        _loc7._startTimeMark = _loc10;
        _loc7.onData = function (src)
        {
            var _loc2 = callback;
            delete this.callback;
            if (_loc2.isSingleCall)
            {
                _loc2.myCall.currentlyActive = undefined;
            } // end if
            if (_loc2.timerID != undefined)
            {
                clearInterval(_loc2.timerID);
                _loc2.timerID = undefined;
            } // end if
            if (_loc2.cancelled)
            {
                return;
            } // end if
            var _loc3 = _loc2.log.level;
            if (_loc3 > mx.services.Log.BRIEF)
            {
                _networkTimeMark = new Date();
                _networkTime = Math.round(_networkTimeMark - _startTimeMark);
                _loc2.log.logInfo("Received SOAP response from network [" + _networkTime + " millis]");
            } // end if
            if (src != undefined)
            {
                this.parseXML(src);
                loaded = true;
                if (_loc3 > mx.services.Log.BRIEF)
                {
                    _parseTimeMark = new Date();
                    _parseTime = Math.round(_parseTimeMark - _networkTimeMark);
                    _loc2.log.logInfo("Parsed SOAP response XML [" + _parseTime + " millis]");
                } // end if
            }
            else
            {
                loaded = false;
            } // end else if
            _loc2.decode.call(_loc2, loaded, this, _loc2.callbackMethod);
        };
        callback.response = _loc7;
        if (timeout != undefined)
        {
            callback.setTimeout(timeout);
        } // end if
        callback.request.sendAndLoad(endpointURI, _loc7, "POST");
        log.logInfo("Sent SOAP Request Message", mx.services.Log.VERBOSE);
        return (callback);
    } // End of the function
    function triggerDelayedFault(callback, fault)
    {
        callback.fault = fault;
        callback.handleDelayedFault = function ()
        {
            clearInterval(timerID);
            timerID = undefined;
            this.__handleFault(this.fault);
            this.onFault(this.fault);
        };
        callback.timerID = setInterval(function ()
        {
            callback.handleDelayedFault();
        }, 50);
    } // End of the function
    static var MULTIPLE_CONCURRENCY = 0;
    static var SINGLE_CONCURRENCY = 1;
    static var LAST_CONCURRENCY = 2;
    var initialized = false;
    var useLiteralBody = false;
} // End of Class
