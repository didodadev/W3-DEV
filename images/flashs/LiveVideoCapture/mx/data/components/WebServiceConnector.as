class mx.data.components.WebServiceConnector extends MovieClip
{
    var WSDLURL, addProperty, _visible, realWSDLURL, service, lastFault, dispatchEvent, results, operation, multipleSimultaneousAllowed, refreshAndValidate, suppressInvalidCalls, params, WebServiceConnector;
    function WebServiceConnector()
    {
        super();
        mx.events.EventDispatcher.initialize(this);
        mx.data.binding.ComponentMixins.initComponent(this);
        if (WSDLURL.length > 0 == true)
        {
            this.setWSDLURL(WSDLURL);
        } // end if
        this.addProperty("WSDLURL", getWSDLURL, setWSDLURL);
        _visible = false;
    } // End of the function
    function setWSDLURL(url)
    {
        realWSDLURL = url;
        service = mx.data.components.WebServiceConnector.allServices[realWSDLURL];
        if (service == null)
        {
            _global.__dataLogger.logData(this, "Creating WebService object for <WSDLURL>", {WSDLURL: WSDLURL});
            service = new mx.services.WebService(realWSDLURL);
            mx.data.components.WebServiceConnector.allServices[realWSDLURL] = service;
            var _loc3 = function (fault)
            {
                lastFault = fault;
            };
            service.onFault = _loc3;
            service.lastFault = null;
        }
        else
        {
            _global.__dataLogger.logData(this, "Will use already-created WebService object for <WSDLURL>", {WSDLURL: WSDLURL});
        } // end else if
    } // End of the function
    function getWSDLURL()
    {
        return (realWSDLURL);
    } // End of the function
    function notifyInfo()
    {
        this.notifyStatus("StatusChange", {callsInProgress: callsInProgress});
    } // End of the function
    function bumpCallsInProgress(amount)
    {
        callsInProgress = callsInProgress + amount;
        this.notifyInfo();
    } // End of the function
    function notifyStatus(code, data)
    {
        var _loc2 = new Object();
        _loc2.type = "status";
        _loc2.code = code;
        _loc2.data = data;
        this.dispatchEvent(_loc2);
    } // End of the function
    function setResult(r, pendingCall)
    {
        if (Object(this).__schema.multiPartResult)
        {
            if (typeof(pendingCall.getOutputParameters) != "function")
            {
                pendingCall.getOutputParameters = mx.services.PendingCall.prototype.getOutputParameters;
            } // end if
            var _loc8 = mx.data.binding.FieldAccessor.findElementType(Object(this).__schema, "results");
            var _loc5 = pendingCall.getOutputParameters();
            var _loc4 = new Object();
            var _loc6 = _loc5.length;
            for (var _loc2 = 0; _loc2 < _loc6; ++_loc2)
            {
                var _loc3 = _loc5[_loc2];
                _loc4[_loc3.name] = _loc3.value;
            } // end of for
            results = _loc4;
        }
        else
        {
            results = r;
        } // end else if
        this.dispatchEvent({type: "result"});
    } // End of the function
    function trigger()
    {
        _global.__dataLogger.logData(this, "WebService Triggered, <WSDLURL>, <operation>", {WSDLURL: WSDLURL, operation: operation});
        ++_global.__dataLogger.nestLevel;
        if (service == null)
        {
            this.notifyStatus("WebServiceFault", {faultcode: "No.WSDLURL.Defined", faultstring: "the WebServiceConnector component had no WSDL URL defined"});
            --_global.__dataLogger.nestLevel;
            return;
        } // end if
        if (service.lastFault != null)
        {
            this.notifyStatus("WebServiceFault", service.lastFault);
            --_global.__dataLogger.nestLevel;
            return;
        } // end if
        if (!multipleSimultaneousAllowed && callsInProgress > 0)
        {
            this.notifyStatus("CallAlreadyInProgress", callsInProgress);
            --_global.__dataLogger.nestLevel;
            return;
        } // end if
        this.dispatchEvent({type: "send"});
        if (!this.refreshAndValidate("params") && suppressInvalidCalls)
        {
            this.notifyStatus("InvalidParams");
            --_global.__dataLogger.nestLevel;
            return;
        } // end if
        var _loc3 = new Array();
        if (params instanceof Array)
        {
            for (var _loc7 = 0; _loc7 < params.length; ++_loc7)
            {
                _loc3.push(params[_loc7]);
            } // end of for
            _global.__dataLogger.logData(this, "Parameters to <operation> will be sent in the order you\'ve provided", {WSDLURL: WSDLURL, operation: operation});
        }
        else
        {
            var _loc5 = mx.data.binding.FieldAccessor.findElementType(Object(this).__schema, "params");
            if (_loc5 != null)
            {
                for (var _loc7 = 0; _loc7 < _loc5.elements.length; ++_loc7)
                {
                    var _loc4 = _loc5.elements[_loc7].name;
                    _loc3.push(params[_loc4]);
                } // end of for
                _global.__dataLogger.logData(this, "Parameters  to <operation> will be sent in the order defined in the schema", {WSDLURL: WSDLURL, operation: operation});
            }
            else
            {
                for (var _loc7 in params)
                {
                    _loc3.push(params[_loc7]);
                } // end of for...in
                _global.__dataLogger.logData(this, "No schema information available - parameters to <operation> will be sent in a unknown order", {WSDLURL: WSDLURL, operation: operation});
            } // end else if
        } // end else if
        _global.__dataLogger.logData(this, "Invoking <operation>(<params>)", {WSDLURL: WSDLURL, operation: operation, params: _loc3});
        var _loc6 = service.stub.invokeOperation(operation, _loc3);
        if (_loc6 == null)
        {
            if (service.lastFault != null)
            {
                this.notifyStatus("WebServiceFault", service.lastFault);
                service.lastFault = null;
            }
            else
            {
                this.notifyStatus("WebServiceFault", {faultcode: "Unknown.Call.Failure", faultstring: "WebService invocation failed for unknown reasons"});
            } // end else if
        }
        else
        {
            this.bumpCallsInProgress(1);
            _loc6.WebServiceConnector = this;
            _loc6.onResult = function (result)
            {
                WebServiceConnector.setResult(result, this);
                WebServiceConnector.bumpCallsInProgress(-1);
            };
            _loc6.onFault = function (fault)
            {
                WebServiceConnector.notifyStatus("WebServiceFault", fault);
                WebServiceConnector.bumpCallsInProgress(-1);
            };
        } // end else if
        --_global.__dataLogger.nestLevel;
    } // End of the function
    function onUpdate()
    {
        _visible = true;
    } // End of the function
    static var allServices = new Array();
    var callsInProgress = 0;
} // End of Class
