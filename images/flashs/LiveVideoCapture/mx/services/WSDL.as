class mx.services.WSDL
{
    var log, serviceProxy, wsdlURI, wsdlDocs, constants, _parentLog, schemas, unresolvedImports, document, startTime, wsdl, parseXML, loaded, fault, targetNamespace, rootWSDL, onLoad, services;
    function WSDL(wsdlURI, serviceProxy, logObj, wsdlVersion)
    {
        log = logObj;
        log.logInfo("Creating WSDL object for " + wsdlURI, mx.services.Log.VERBOSE);
        this.serviceProxy = serviceProxy;
        this.wsdlURI = wsdlURI;
        wsdlDocs = new Object();
        var _loc4 = wsdlVersion == undefined ? (0) : (wsdlVersion);
        constants = mx.services.WSDLConstants.getConstants(_loc4);
        var _loc3 = new mx.services.Log(log.level, "XMLSchema");
        _loc3._parentLog = log;
        _loc3.onLog = function (txt)
        {
            _parentLog.onLog(txt);
        };
        schemas = new mx.services.SchemaContext(_loc3);
        mx.services.SchemaContext.RegisterStandardTypes(schemas);
        unresolvedImports = 1;
        var _loc2 = new XML();
        _loc2.ignoreWhite = true;
        _loc2.wsdl = this;
        _loc2.location = wsdlURI;
        _loc2.isRootWSDL = true;
        document = _loc2;
        startTime = new Date();
        this.fetchDocument(_loc2);
        log.logInfo("Successfully created WSDL object", mx.services.Log.VERBOSE);
    } // End of the function
    function fetchDocument(document)
    {
        document.onData = function (src)
        {
            if (src != undefined)
            {
                var _loc2 = new Date();
                wsdl.log.logInfo("Received WSDL document from the remote service", mx.services.Log.VERBOSE);
                this.parseXML(src);
                loaded = true;
                var _loc3 = Math.round(new Date() - _loc2);
                wsdl.log.logInfo("Parsed WSDL XML [" + _loc3 + " millis]", mx.services.Log.VERBOSE);
            } // end if
            wsdl.parseDocument(this);
            delete this.wsdl;
        };
        document.load(document.location, "GET");
    } // End of the function
    function parseDocument(document)
    {
        if (!document.loaded)
        {
            fault = new mx.services.SOAPFault(mx.services.SOAPConstants.DISCONNECTED_FAULT_CODE, "Could not load WSDL", "Unable to load WSDL, if currently online, please verify the URI and/or format of the WSDL (" + wsdlURI + ")");
            log.logDebug("Unable to receive WSDL file");
        }
        else
        {
            --unresolvedImports;
            this.processImports(document);
        } // end else if
        if (unresolvedImports == 0 || fault != undefined)
        {
            this.parseCompleted();
        } // end if
    } // End of the function
    function buildURL(locationURL, contextURL)
    {
        if (locationURL.substr(0, 7) == "http://" || locationURL.substr(0, 8) == "https://")
        {
            return (locationURL);
        } // end if
        var _loc3 = contextURL.lastIndexOf("/");
        contextURL = contextURL.substr(0, _loc3 + 1);
        return (contextURL + locationURL);
    } // End of the function
    function processImports(document)
    {
        var _loc12 = document.firstChild;
        var _loc14 = constants;
        var _loc13 = _loc12.getQName();
        if (!_loc13.equals(_loc14.definitionsQName))
        {
            if (_loc13.localPart == "schema")
            {
                schemas.registerSchemaNode(_loc12);
                return;
            }
            else
            {
                fault = new mx.services.SOAPFault("Server", "Faulty WSDL format", "Definitions must be the first element in a WSDL document");
                var _loc7 = document.firstChild;
                if (_loc7.nodeName == "soapenv:Envelope")
                {
                    _loc7 = _loc7.firstChild;
                    if (_loc7.nodeName == "soapenv:Body")
                    {
                        _loc7 = _loc7.firstChild;
                        if (_loc7.nodeName == "soapenv:Fault")
                        {
                            var _loc11;
                            var _loc10;
                            var _loc9;
                            for (var _loc2 = _loc7.firstChild; _loc2 != null; _loc2 = _loc2.nextSibling)
                            {
                                if (_loc2.nodeName == "faultcode")
                                {
                                    _loc11 = _loc2.firstChild;
                                    continue;
                                } // end if
                                if (_loc2.nodeName == "faultstring")
                                {
                                    _loc10 = _loc2.firstChild;
                                    continue;
                                } // end if
                                if (_loc2.nodeName == "detail")
                                {
                                    _loc9 = _loc2.firstChild;
                                } // end if
                            } // end of for
                            fault = new mx.services.SOAPFault(_loc11, _loc10, _loc9);
                        } // end if
                    } // end if
                } // end if
                return;
            } // end if
        } // end else if
        var _loc16 = _loc12.attributes.targetNamespace;
        var _loc15 = new mx.services.WSDLDocument(document, this);
        wsdlDocs[_loc16] = _loc15;
        if (document.isRootWSDL)
        {
            targetNamespace = _loc16;
            rootWSDL = _loc15;
        } // end if
        var _loc5 = _loc12.getElementsByQName(_loc14.importQName);
        if (_loc5 != undefined)
        {
            for (var _loc3 = 0; _loc3 < _loc5.length; ++_loc3)
            {
                var _loc4 = _loc5[_loc3].attributes.location;
                _loc4 = this.buildURL(_loc4, document.location);
                var _loc6 = _loc5[_loc3].attributes.namespace;
                this.importDocument(_loc4, _loc6);
            } // end of for
        } // end if
    } // End of the function
    function importDocument(location, namespaceURI)
    {
        var _loc2 = new XML();
        _loc2.ignoreWhite = true;
        _loc2.wsdl = this;
        _loc2.namespace = namespaceURI;
        _loc2.location = location;
        ++unresolvedImports;
        this.fetchDocument(_loc2);
    } // End of the function
    function parseCompleted()
    {
        if (fault == undefined)
        {
            this.parseServices();
        } // end if
        if (fault == undefined)
        {
            var _loc2 = Math.floor(new Date() - startTime);
        } // end if
        this.onLoad();
    } // End of the function
    function parseServices()
    {
        log.logDebug("Parsing definitions");
        var _loc6 = constants;
        var _loc3 = rootWSDL.serviceElements;
        if (_loc3 == undefined)
        {
            fault = new mx.services.SOAPFault("Server.NoServicesInWSDL", "Could not load WSDL", "No <wsdl:service> elements found in WSDL at " + wsdlURI + ".");
            log.logDebug("No <service> elements in WSDL file");
            return;
        } // end if
        var _loc4 = new Object();
        for (var _loc5 in _loc3)
        {
            var _loc2 = this.parseService(_loc3[_loc5]);
            _loc4[_loc2.name] = _loc2;
        } // end of for...in
        services = _loc4;
        log.logDebug("Completed WSDL parsing");
    } // End of the function
    function parseSchemas(typesNode)
    {
        log.logDebug("Parsing schemas");
        var _loc3 = typesNode.childNodes;
        var _loc4 = _loc3.length;
        for (var _loc2 = 0; _loc2 < _loc4; ++_loc2)
        {
            schemas.registerSchemaNode(_loc3[_loc2]);
        } // end of for
        log.logDebug("Done parsing schemas.");
    } // End of the function
    function parseService(serviceElement)
    {
        log.logDebug("Parsing service: " + serviceElement.nodeName);
        var _loc11 = new Object();
        _loc11.ports = new Object();
        var _loc8 = constants;
        _loc11.name = serviceElement.attributes.name;
        var _loc12 = serviceElement.childNodes;
        var _loc13 = _loc12.length;
        for (var _loc7 = 0; _loc7 < _loc13 && fault == undefined; ++_loc7)
        {
            var _loc2 = _loc12[_loc7];
            var _loc9 = _loc2.getQName();
            if (_loc9.equals(_loc8.documentationQName))
            {
                _loc11.description = _loc2.firstChild;
                continue;
            } // end if
            if (_loc9.equals(_loc8.portQName))
            {
                var _loc4 = new Object();
                for (var _loc3 = 0; _loc3 < _loc2.childNodes.length; ++_loc3)
                {
                    var _loc5 = _loc2.childNodes[_loc3];
                    var _loc6 = _loc5.getQName();
                    if (_loc6.equals(_loc8.soapAddressQName))
                    {
                        _loc4.endpointURI = _loc5.attributes.location;
                        break;
                    } // end if
                } // end of for
                if (_loc4.endpointURI != undefined)
                {
                    _loc4.name = _loc2.attributes.name;
                    var _loc10 = _loc2.getQNameFromString(_loc2.attributes.binding);
                    _loc4.binding = this.parseBinding(_loc10);
                    _loc11.ports[_loc4.name] = _loc4;
                } // end if
            } // end if
        } // end of for
        return (_loc11);
    } // End of the function
    function parseBinding(bindingName)
    {
        log.logDebug("Parsing binding: " + bindingName);
        var _loc10 = new Object();
        var _loc4 = constants;
        var _loc25 = wsdlDocs[bindingName.namespaceURI];
        if (_loc25 == undefined)
        {
            fault = new mx.services.SOAPFault("WSDL.UnrecognizedNamespace", "The WSDL parser had no registered document for the namespace \'" + bindingName.namespaceURI + "\'");
            return;
        } // end if
        var _loc19 = _loc25.getBindingElement(bindingName.localPart);
        if (_loc19 == undefined)
        {
            fault = new mx.services.SOAPFault("WSDL.UnrecognizedBindingName", "The WSDL parser couldn\'t find a binding named \'" + bindingName.localPart + "\' in namespace \'" + bindingName.namespaceURI + "\'");
            return;
        } // end if
        var _loc26 = _loc19.getQNameFromString(_loc19.attributes.type);
        _loc10.portType = this.parsePortType(_loc26);
        if (fault != undefined)
        {
            return;
        } // end if
        var _loc23 = _loc19.childNodes;
        var _loc24 = _loc23.length;
        for (var _loc13 = 0; _loc13 < _loc24; ++_loc13)
        {
            var _loc11 = _loc23[_loc13];
            var _loc17 = _loc11.getQName();
            if (_loc17.equals(_loc4.soapBindingQName))
            {
                _loc10.style = _loc11.attributes.style;
                if (_loc10.style == undefined)
                {
                    _loc10.style = mx.services.WSDLConstants.DEFAULT_STYLE;
                } // end if
                _loc10.transport = _loc11.attributes.transport;
                continue;
            } // end if
            if (_loc17.equals(_loc4.operationQName))
            {
                var _loc20 = _loc11.attributes.name;
                var _loc7 = _loc10.portType.operations[_loc20];
                var _loc14 = _loc11.childNodes;
                var _loc18 = _loc14.length;
                for (var _loc6 = 0; _loc6 < _loc18; ++_loc6)
                {
                    var _loc3 = _loc14[_loc6];
                    var _loc5 = _loc3.getQName();
                    if (_loc5.equals(_loc4.soapOperationQName))
                    {
                        var _loc12 = _loc3.attributes.soapAction;
                        _loc7.actionURI = _loc12;
                        var _loc9 = _loc3.attributes.style;
                        if (_loc9 == undefined)
                        {
                            _loc9 = _loc10.style;
                        } // end if
                        _loc7.style = _loc9;
                        continue;
                    } // end if
                    if (_loc5.equals(_loc4.inputQName))
                    {
                        var _loc8 = _loc3.getElementsByQName(_loc4.soapBodyQName)[0];
                        var _loc2 = new Object();
                        _loc2.use = _loc8.attributes.use;
                        _loc2.namespaceURI = _loc8.attributes.namespace;
                        if (_loc2.namespaceURI == undefined)
                        {
                            _loc2.namespaceURI = targetNamespace;
                        } // end if
                        _loc2.encodingStyle = _loc8.attributes.encodingStyle;
                        _loc7.inputEncoding = _loc2;
                        continue;
                    } // end if
                    if (_loc5.equals(_loc4.outputQName))
                    {
                        _loc8 = _loc3.getElementsByQName(_loc4.soapBodyQName)[0];
                        _loc2 = new Object();
                        _loc2.use = _loc8.attributes.use;
                        _loc2.namespaceURI = _loc8.attributes.namespace;
                        if (_loc2.namespaceURI == undefined)
                        {
                            _loc2.namespaceURI = targetNamespace;
                        } // end if
                        _loc2.encodingStyle = _loc8.attributes.encodingStyle;
                        _loc7.outputEncoding = _loc2;
                    } // end if
                } // end of for
            } // end if
        } // end of for
        var _loc21 = document.getElementsByQName(_loc4.bindingQName);
        for (var _loc15 = 0; _loc15 < _loc21.length; ++_loc15)
        {
            _loc19 = _loc21[_loc15];
            var _loc16 = _loc19.attributes.name;
            if (bindingName != _loc16)
            {
                continue;
            } // end if
            _loc10.name = _loc16;
        } // end of for
        return (_loc10);
    } // End of the function
    function parsePortType(portTypeName, document)
    {
        log.logDebug("Parsing portType: " + portTypeName);
        var _loc19 = wsdlDocs[portTypeName.namespaceURI];
        if (_loc19 == undefined)
        {
            fault = new mx.services.SOAPFault("WSDL.UnrecognizedNamespace", "The WSDL parser had no registered document for the namespace \'" + portTypeName.namespaceURI + "\'");
            return;
        } // end if
        var _loc18 = _loc19.getPortTypeElement(portTypeName.localPart);
        if (_loc18 == undefined)
        {
            fault = new mx.services.SOAPFault("WSDL.UnrecognizedPortTypeName", "The WSDL parser couldn\'t find a portType named \'" + portTypeName.localPart + "\' in namespace \'" + portTypeName.namespaceURI + "\'");
            return;
        } // end if
        var _loc13 = new Object();
        var _loc7 = constants;
        _loc13.name = _loc18.attributes.name;
        _loc13.operations = new Object();
        var _loc14 = _loc18.getElementsByQName(_loc7.operationQName);
        var _loc15 = _loc14.length;
        for (var _loc9 = 0; _loc9 < _loc15; ++_loc9)
        {
            var _loc11 = _loc14[_loc9];
            var _loc2 = new mx.services.WSDLOperation(_loc11.attributes.name, this, document);
            var _loc10 = _loc11.childNodes;
            var _loc12 = _loc10.length;
            for (var _loc5 = 0; _loc5 < _loc12; ++_loc5)
            {
                var _loc3 = _loc10[_loc5];
                var _loc4 = _loc3.getQName();
                if (_loc4.equals(_loc7.documentationQName))
                {
                    _loc2.documentation = _loc3.childNodes[0];
                    continue;
                } // end if
                var _loc8 = _loc3.attributes.message;
                var _loc6 = _loc3.getQNameFromString(_loc8);
                if (_loc4.equals(_loc7.inputQName))
                {
                    _loc2.inputMessage = _loc6;
                    continue;
                } // end if
                if (_loc4.equals(_loc7.outputQName))
                {
                    _loc2.outputMessage = _loc6;
                } // end if
            } // end of for
            if (_loc13.operations[_loc2.name] != undefined)
            {
                fault = new mx.services.SOAPFault("WSDL.OverloadedOperation", "The WSDL contains an overloaded operation (" + _loc2.name + ") - we do not currently support this usage.");
                return;
            } // end if
            _loc13.operations[_loc2.name] = _loc2;
        } // end of for
        return (_loc13);
    } // End of the function
    function parseMessage(messageName, operationName, mode, document)
    {
        log.logDebug("Parsing message: " + messageName);
        var _loc22 = wsdlDocs[messageName.namespaceURI];
        if (_loc22 == undefined)
        {
            fault = new mx.services.SOAPFault("WSDL.UnrecognizedNamespace", "The WSDL parser had no registered document for the namespace \'" + messageName.namespaceURI + "\'");
            return;
        } // end if
        var _loc21 = _loc22.getMessageElement(messageName.localPart);
        if (_loc21 == undefined)
        {
            fault = new mx.services.SOAPFault("WSDL.UnrecognizedMessageName", "The WSDL parser couldn\'t find a message named \'" + messageName.localPart + "\' in namespace \'" + messageName.namespaceURI + "\'");
            return;
        } // end if
        var _loc23 = constants;
        var _loc3 = new Object();
        _loc3.name = _loc21.attributes.name;
        if (_loc3.name == undefined)
        {
            if (mode == mx.services.SOAPConstants.MODE_IN)
            {
                _loc3.name = operationName + "Request";
            }
            else
            {
                _loc3.name == operationName + "Response";
            } // end if
        } // end else if
        log.logDebug("Message name is " + _loc3.name);
        var _loc18 = _loc21.getElementsByQName(_loc23.parameterQName);
        var _loc16 = _loc18.length;
        _loc3.parameters = new Array();
        for (var _loc8 = 0; _loc8 < _loc16; ++_loc8)
        {
            var _loc5 = _loc18[_loc8];
            var _loc14 = _loc5.attributes.name;
            var _loc2;
            var _loc12;
            if (_loc5.attributes.element != undefined)
            {
                var _loc10 = _loc5.attributes.element;
                var _loc13 = _loc5.getQNameFromString(_loc10);
                var _loc7 = schemas.getElementByQName(_loc13);
                if (schemas.fault != undefined)
                {
                    fault = schemas.fault;
                    return;
                } // end if
                if (_loc7 == undefined)
                {
                    fault = new mx.services.SOAPFault("WSDL.BadElement", "Element " + _loc10 + " not resolvable");
                    return;
                } // end if
                _loc2 = _loc7.schemaType;
                _loc12 = _loc13;
                if (_loc16 == 1 && operationName == _loc13.localPart)
                {
                    for (var _loc17 in _loc2.partTypes)
                    {
                        var _loc4 = _loc2.partTypes[_loc17];
                        var _loc6 = new mx.services.QName(_loc17, _loc4.namespace);
                        var _loc15 = new mx.services.SOAPParameter(_loc17, _loc4.schemaType, mode, _loc6);
                        _loc3.parameters.push(_loc15);
                        _loc3.targetNamespace = _loc13.namespaceURI;
                    } // end of for...in
                    _loc3.isWrapped = true;
                    if (_loc7.form == "qualified")
                    {
                        _loc3.isQualified = true;
                    } // end if
                    break;
                } // end if
            }
            else
            {
                var _loc9 = _loc5.attributes.type;
                _loc13 = _loc5.getQNameFromString(_loc9);
                _loc2 = schemas.getTypeByQName(_loc13);
                if (schemas.fault != undefined)
                {
                    fault = schemas.fault;
                    return;
                } // end if
                if (_loc2 == undefined)
                {
                    fault = new mx.services.SOAPFault("WSDL.BadType", "Type " + _loc9 + " not resolvable");
                    return;
                } // end if
            } // end else if
            _loc15 = new mx.services.SOAPParameter(_loc14, _loc2, mode, _loc12);
            _loc3.parameters.push(_loc15);
        } // end of for
        return (_loc3);
    } // End of the function
} // End of Class
