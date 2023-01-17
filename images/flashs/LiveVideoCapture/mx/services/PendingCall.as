class mx.services.PendingCall
{
    var myCall, soapConstants, log, timerID, onFault, request, requestHeaders, _multiRefs, fault, response, __handleFault, responseHeaders, onHeaders, onResult, __handleResult, bodyNode, onHeader;
    function PendingCall(myCall)
    {
        this.myCall = myCall;
        soapConstants = myCall.soapConstants;
        log = myCall.log;
        doLazyDecoding = myCall.doLazyDecoding;
        doDecoding = myCall.doDecoding;
    } // End of the function
    function setTimeout(timeoutMS)
    {
        function timeoutFunc()
        {
            clearInterval(timerID);
            timerID = undefined;
            var _loc2 = new mx.services.SOAPFault("Timeout", "Timeout while calling method " + myCall.operationName + "!");
            this.onFault(_loc2);
        } // End of the function
        timerID = setInterval(this, "timeoutFunc", timeoutMS);
    } // End of the function
    function cancel()
    {
        if (timerID != undefined)
        {
            clearInterval(timerID);
        } // end if
        cancelled = true;
    } // End of the function
    function encode()
    {
        log.logInfo("Encoding SOAPCall request", mx.services.Log.VERBOSE);
        this.encodeHTTPRequest();
        this.encodeSOAPEnvelope();
    } // End of the function
    function encodeHTTPRequest()
    {
        log.logDebug("Creating HTTP request object");
        var _loc2 = new XML();
        _loc2.ignoreWhite = true;
        _loc2.contentType = soapConstants.contentType;
        _loc2.xmlDecl = mx.services.SOAPConstants.XML_DECLARATION;
        _loc2.addRequestHeader("SOAPAction", "\"" + myCall.actionURI + "\"");
        request = _loc2;
    } // End of the function
    function encodeSOAPEnvelope()
    {
        log.logDebug("Encoding SOAP request envelope");
        var _loc3 = request;
        var _loc4 = myCall.schemaVersion;
        var _loc5 = soapConstants.envelopeQName;
        var _loc2 = _loc3.createElement(mx.services.SOAPConstants.SOAP_ENV_PREFIX + ":" + _loc5.localPart);
        _loc2.attributes["xmlns:" + mx.services.SOAPConstants.SOAP_ENV_PREFIX] = soapConstants.ENVELOPE_URI;
        _loc2.attributes["xmlns:" + mx.services.SOAPConstants.XML_SCHEMA_PREFIX] = _loc4.xsdURI;
        _loc2.attributes["xmlns:" + mx.services.SOAPConstants.XML_SCHEMA_INSTANCE_PREFIX] = _loc4.xsiURI;
        _loc3.appendChild(_loc2);
        _loc3.soapEnvelope = _loc2;
        this.encodeSOAPHeader();
        this.encodeSOAPBody();
    } // End of the function
    function encodeSOAPHeader()
    {
        var _loc7 = request;
        var _loc6 = request.soapEnvelope;
        var _loc3 = requestHeaders;
        if (_loc3.length > 0)
        {
            var _loc4 = _loc7.createElement(mx.services.SOAPConstants.SOAP_ENV_PREFIX + ":" + soapConstants.headerQName.localPart);
            _loc6.appendChild(_loc4);
            var _loc5 = _loc3.length;
            for (var _loc2 = 0; _loc2 < _loc5; ++_loc2)
            {
                _loc4.appendChild(_loc3[_loc2].element);
            } // end of for
        } // end if
    } // End of the function
    function encodeSOAPBody()
    {
        log.logDebug("Encoding SOAP request body");
        var _loc2 = request;
        var _loc3 = myCall;
        var _loc5 = _loc3.operationName;
        var _loc6 = _loc3.targetNamespace;
        var _loc7 = _loc3.soapConstants;
        var _loc10 = _loc2.soapEnvelope;
        _loc2.soapEnvelope = null;
        var _loc8 = _loc7.bodyQName;
        var _loc4 = _loc2.createElement(mx.services.SOAPConstants.SOAP_ENV_PREFIX + ":" + _loc8.localPart);
        _loc10.appendChild(_loc4);
        if (!_loc3.useLiteralBody)
        {
            if (_loc3.operationStyle != mx.services.SOAPConstants.DOC_STYLE)
            {
                if (_loc3.operationStyle == mx.services.SOAPConstants.WRAPPED_STYLE && _loc3.elementFormQualified)
                {
                    _loc2.soapOperation = _loc2.createElement(_loc5);
                    _loc2.soapOperation.attributes.xmlns = _loc6;
                }
                else
                {
                    var _loc9 = this.getStringFromQName(_loc4, new mx.services.QName(_loc5, _loc6));
                    _loc2.soapOperation = _loc2.createElement(_loc9);
                    if (_loc3.useStyle == mx.services.SOAPConstants.USE_ENCODED)
                    {
                        _loc2.soapOperation.attributes[mx.services.SOAPConstants.SOAP_ENV_PREFIX + ":encodingStyle"] = _loc7.ENCODING_URI;
                    } // end if
                } // end else if
                _loc4.appendChild(_loc2.soapOperation);
            }
            else
            {
                _loc2.soapOperation = _loc4;
            } // end if
        } // end else if
    } // End of the function
    function addHeader(headerElement)
    {
        log.logDebug("Adding header: " + headerElement.nodeName);
        if (requestHeaders == undefined)
        {
            requestHeaders = new Array();
        } // end if
        requestHeaders.push(new mx.services.SOAPHeader(headerElement));
    } // End of the function
    function getOrCreatePrefix(node, namespaceURI, preferredPrefix)
    {
        if (namespaceURI == undefined || namespaceURI == "")
        {
            var _loc5 = node.getNamespaceForPrefix("");
            if (_loc5 != undefined && _loc5 != "")
            {
                node.attributes.xmlns = "";
                node.registerNamespace("", "");
            } // end if
            return ("");
        } // end if
        var _loc2 = node.getPrefixForNamespace(namespaceURI);
        var _loc6 = false;
        if (_loc2 == undefined)
        {
            if (preferredPrefix == undefined)
            {
                ++request.nscount;
                _loc2 = "ns" + request.nscount;
            }
            else
            {
                _loc2 = preferredPrefix;
            } // end else if
            _loc6 = true;
        } // end if
        if (_loc6)
        {
            if (_loc2 != "")
            {
                node.attributes["xmlns:" + _loc2] = namespaceURI;
            }
            else
            {
                node.attributes.xmlns = namespaceURI;
            } // end else if
            node.registerPrefix(_loc2, namespaceURI);
        } // end if
        return (_loc2);
    } // End of the function
    function getStringFromQName(node, qname)
    {
        var _loc2 = this.getOrCreatePrefix(node, qname.namespaceURI);
        if (_loc2 != "")
        {
            return (_loc2 + ":" + qname.localPart);
        }
        else
        {
            return (qname.localPart);
        } // end else if
    } // End of the function
    function encodeParam(paramName, paramType, parentNode, qname)
    {
        var _loc2;
        var _loc4 = request;
        var _loc12 = mx.services.SOAPConstants.SCHEMA_INSTANCE_TYPE;
        if (paramType.typeType == mx.services.DataType.ARRAY_TYPE)
        {
            if (myCall.useStyle == mx.services.SOAPConstants.USE_ENCODED)
            {
                _loc2 = _loc4.createElement(mx.services.SOAPConstants.SOAP_ENC_PREFIX + ":" + paramName);
                _loc2.attributes["xmlns:" + mx.services.SOAPConstants.SOAP_ENC_PREFIX] = soapConstants.ENCODING_URI;
                parentNode.appendChild(_loc2);
                _loc2.nodeName = paramName;
                var _loc7 = paramType.arrayType;
                var _loc8 = mx.services.SOAPConstants.ARRAY_TYPE_PQNAME;
                var _loc11 = this.getOrCreatePrefix(_loc2, _loc7.namespaceURI);
                _loc2.attributes[_loc8] = _loc11 + ":" + _loc7.name;
            }
            else
            {
                _loc2 = _loc4.createElement(paramName);
                parentNode.appendChild(_loc2);
                if (qname != undefined)
                {
                    _loc2.nodeName = this.getStringFromQName(_loc2, qname);
                } // end if
            } // end else if
        }
        else if (myCall.useStyle == mx.services.SOAPConstants.USE_ENCODED)
        {
            var _loc9 = this.getStringFromQName(parentNode, new mx.services.QName(paramName, paramType.namespaceURI));
            _loc2 = _loc4.createElement(_loc9);
            parentNode.appendChild(_loc2);
            _loc2.nodeName = paramName;
        }
        else
        {
            _loc2 = _loc4.createElement(paramName);
            parentNode.appendChild(_loc2);
            if (qname != undefined)
            {
                _loc2.nodeName = this.getStringFromQName(_loc2, qname);
            } // end else if
        } // end else if
        return (_loc2);
    } // End of the function
    function encodeParamValue(valueObj, valueType, elementNode, document)
    {
        var _loc29 = mx.services.SOAPConstants.SCHEMA_INSTANCE_TYPE;
        if (valueType.typeType == mx.services.DataType.ARRAY_TYPE)
        {
            var _loc19 = valueType.arrayType;
            var _loc20 = valueObj.length;
            if (myCall.useStyle == mx.services.SOAPConstants.USE_ENCODED && valueType.isEncodedArray == true)
            {
                var _loc11 = valueType;
                var _loc4 = "";
                var _loc21 = true;
                while (_loc11.typeType == mx.services.DataType.ARRAY_TYPE)
                {
                    var _loc3 = _loc11.dimensions;
                    if (_loc3.length > 1)
                    {
                        for (var _loc9 = 0; _loc9 < _loc3.length; ++_loc9)
                        {
                            if (_loc9 > 0)
                            {
                                _loc4 = _loc4 + ",";
                            } // end if
                            _loc4 = _loc4 + _loc3[_loc9];
                        } // end of for
                    }
                    else if (_loc21)
                    {
                        _loc4 = _loc4 + ("[" + _loc20 + "]");
                        _loc21 = false;
                    }
                    else
                    {
                        _loc4 = _loc4 + "[]";
                    } // end else if
                    _loc11 = _loc11.arrayType;
                } // end while
                elementNode.attributes[mx.services.SOAPConstants.ARRAY_TYPE_PQNAME] = this.getStringFromQName(elementNode, valueType.qname) + _loc4;
                elementNode.attributes[_loc29] = mx.services.SOAPConstants.ARRAY_PQNAME;
            } // end if
            for (var _loc9 = 0; _loc9 < _loc20; ++_loc9)
            {
                var _loc18 = this.getStringFromQName(elementNode, valueType.itemElement);
                var _loc13 = document.createElement(_loc18);
                var _loc22 = elementNode.getPrefixForNamespace(_loc19.namespaceURI);
                elementNode.appendChild(_loc13);
                this.encodeParamValue(valueObj[_loc9], _loc19, _loc13, document);
            } // end of for
            return;
        } // end if
        if (myCall.useStyle == mx.services.SOAPConstants.USE_ENCODED)
        {
            var _loc26;
            var _loc28 = true;
            if (valueType == undefined)
            {
                valueType = valueObj.__dataType;
            } // end if
            if (valueType == undefined || valueType.typeType == mx.services.DataType.ANY_TYPE)
            {
                var _loc27 = typeof(valueObj);
                var _loc25;
                if (_loc27 == "number")
                {
                    _loc25 = "double";
                }
                else if (_loc27 == "object")
                {
                    if (valueObj instanceof Date)
                    {
                        _loc25 = "dateTime";
                        valueType = myCall.schemaVersion.dateTimeType;
                    }
                    else
                    {
                        valueType = mx.services.DataType.objectType;
                        _loc28 = false;
                    } // end else if
                }
                else
                {
                    _loc25 = "string";
                } // end else if
                var _loc30 = this.getOrCreatePrefix(elementNode, myCall.schemaVersion.xsdURI);
                _loc26 = _loc30 + ":" + _loc25;
            }
            else if (!valueType.isAnonymous)
            {
                _loc30 = this.getOrCreatePrefix(elementNode, valueType.namespaceURI);
                _loc26 = _loc30 + ":" + valueType.name;
            } // end else if
            if (_loc28 && _loc26 != undefined)
            {
                elementNode.attributes[_loc29] = _loc26;
            } // end if
        } // end if
        if (valueType.typeType == mx.services.DataType.MAP_TYPE)
        {
            this.encodeMap(valueObj, elementNode, document);
        }
        else
        {
            if (valueType.partTypes != undefined)
            {
                for (var _loc24 in valueType.partTypes)
                {
                    var _loc6 = valueType.partTypes[_loc24];
                    var _loc8 = valueObj[_loc24];
                    var _loc17 = new mx.services.QName(_loc24, _loc6.namespace);
                    if (_loc6.isAttribute)
                    {
                        elementNode.attributes[_loc24] = _loc8;
                        continue;
                    } // end if
                    var _loc16 = this.encodeParam(_loc24, _loc6.schemaType, elementNode, _loc17);
                    if (_loc8 != undefined)
                    {
                        this.encodeParamValue(_loc8, _loc6.schemaType, _loc16, document);
                    } // end if
                } // end of for...in
                if (valueType.simpleValue != undefined)
                {
                    var _loc33 = document.createTextNode(valueObj._value);
                    elementNode.appendChild(_loc33);
                } // end if
                return;
            } // end if
            if (valueType.typeType == mx.services.DataType.DATE_TYPE)
            {
                var _loc34 = this.encodeDate(valueObj, valueType);
                var _loc31 = document.createTextNode(_loc34);
                elementNode.appendChild(_loc31);
                return;
            } // end if
            if (valueType.typeType == mx.services.DataType.OBJECT_TYPE)
            {
                for (var _loc23 in valueObj)
                {
                    var _loc14 = valueObj[_loc23];
                    var _loc12 = _loc14.__dataType;
                    var _loc15 = this.encodeParam(_loc23, _loc12, elementNode);
                    this.encodeParamValue(_loc14, _loc12, _loc15, document);
                } // end of for...in
                return;
            }
            else
            {
                var _loc32 = document.createTextNode(valueObj.toString());
                elementNode.appendChild(_loc32);
            } // end else if
        } // end else if
    } // End of the function
    function setupBodyXML(bodyXML)
    {
        request.appendChild(bodyXML);
    } // End of the function
    function setupParams(inputParams)
    {
        var _loc9 = myCall.parameters;
        var _loc10 = _loc9.length;
        for (var _loc3 = 0; _loc3 < _loc10; ++_loc3)
        {
            var _loc2 = _loc9[_loc3];
            var _loc4 = _loc2.schemaType;
            var _loc6;
            if (_loc2.mode != mx.services.SOAPConstants.MODE_OUT)
            {
                var _loc8 = this.encodeParam(_loc2.name, _loc4, request.soapOperation, _loc2.qname);
                if (inputParams instanceof Array)
                {
                    _loc6 = inputParams[_loc3];
                }
                else
                {
                    _loc6 = inputParams[_loc2.name];
                } // end else if
                var _loc5 = _loc4.schemaType;
                if (_loc5 == undefined)
                {
                    _loc5 = _loc4;
                } // end if
                this.encodeParamValue(_loc6, _loc5, _loc8, request);
            } // end if
        } // end of for
        request.soapOperation = null;
        _multiRefs = null;
    } // End of the function
    function encodeMap(obj, mapNode, document)
    {
        for (var _loc8 in obj)
        {
            var _loc2 = document.createElement("item");
            var _loc4 = document.createElement("key");
            _loc2.appendChild(_loc4);
            this.encodeParamValue(_loc8, undefined, _loc4, document);
            var _loc5 = document.createElement("value");
            _loc2.appendChild(_loc5);
            this.encodeParamValue(obj[_loc8], undefined, _loc5, document);
            mapNode.appendChild(_loc2);
        } // end of for...in
    } // End of the function
    function encodeDate(rawDate, dateType)
    {
        var _loc1 = new String();
        if (dateType.name == "dateTime" || dateType.name == "date")
        {
            _loc1 = _loc1.concat(rawDate.getUTCFullYear(), "-");
            var _loc2 = rawDate.getUTCMonth() + 1;
            if (_loc2 < 10)
            {
                _loc1 = _loc1.concat("0");
            } // end if
            _loc1 = _loc1.concat(_loc2, "-");
            _loc2 = rawDate.getUTCDate();
            if (_loc2 < 10)
            {
                _loc1 = _loc1.concat("0");
            } // end if
            _loc1 = _loc1.concat(_loc2);
        } // end if
        if (dateType.name == "dateTime")
        {
            _loc1 = _loc1.concat("T");
        } // end if
        if (dateType.name == "dateTime" || dateType.name == "time")
        {
            _loc2 = rawDate.getUTCHours();
            if (_loc2 < 10)
            {
                _loc1 = _loc1.concat("0");
            } // end if
            _loc1 = _loc1.concat(_loc2, ":");
            _loc2 = rawDate.getUTCMinutes();
            if (_loc2 < 10)
            {
                _loc1 = _loc1.concat("0");
            } // end if
            _loc1 = _loc1.concat(_loc2, ":");
            _loc2 = rawDate.getUTCSeconds();
            if (_loc2 < 10)
            {
                _loc1 = _loc1.concat("0");
            } // end if
            _loc1 = _loc1.concat(_loc2, ".");
            _loc2 = rawDate.getUTCMilliseconds();
            if (_loc2 < 10)
            {
                _loc1 = _loc1.concat("00");
            }
            else if (_loc2 < 100)
            {
                _loc1 = _loc1.concat("0");
            } // end else if
            _loc1 = _loc1.concat(_loc2);
        } // end if
        _loc1 = _loc1.concat("Z");
        return (_loc1);
    } // End of the function
    function decode(assert, response, callbackMethod)
    {
        log.logInfo("Decoding SOAPCall response", mx.services.Log.VERBOSE);
        var _loc3;
        if (!assert)
        {
            var _loc4 = new mx.services.SOAPFault();
            _loc4.faultcode = "Server.Connection";
            _loc4.faultstring = "Unable to connect to endpoint: " + myCall.endpointURI;
            _loc4.faultactor = myCall.targetNamespace;
            fault = _loc4;
            log.logDebug("No response received from remote service");
        }
        else
        {
            _loc3 = this.decodeSOAPEnvelope(response);
            if (log.level > mx.services.Log.BRIEF)
            {
                this.response._decodeTimeMark = new Date();
                this.response._decodeTime = Math.round(this.response._decodeTimeMark - this.response._parseTimeMark);
                log.logInfo("Decoded SOAP response into result [" + this.response._decodeTime + " millis]");
            } // end if
        } // end else if
        if (fault != undefined)
        {
            this.__handleFault(fault);
            this.onFault(fault, response);
            myCall.onFault(fault, response);
        }
        else
        {
            if (responseHeaders != undefined)
            {
                this.onHeaders(responseHeaders, response);
            } // end if
            this.onResult(_loc3, response);
            myCall.onResult(_loc3, response);
            this.__handleResult(_loc3);
        } // end else if
        this[callbackMethod](_loc3, response);
    } // End of the function
    function decodeSOAPEnvelope(response)
    {
        log.logDebug("Decoding SOAP response envelope");
        var _loc4;
        var _loc11 = soapConstants;
        var _loc8 = response.firstChild;
        if (_loc8.getNamespaceURI() != soapConstants.ENVELOPE_URI)
        {
            var _loc12 = new mx.services.SOAPFault();
            _loc12.faultcode = "VersionMismatch";
            _loc12.faultstring = "Request implements version: " + soapConstants.ENVELOPE_URI + " Response implements version " + _loc8.getNamespaceURI();
            fault = _loc12;
        }
        else
        {
            var _loc13 = _loc8.getPrefixForNamespace(_loc11.ENVELOPE_URI);
            var _loc6 = _loc8.getPrefixForNamespace(myCall.schemaVersion.xsiURI);
            var _loc14 = _loc8.getPrefixForNamespace(myCall.schemaVersion.xsdURI);
            var _loc9 = new mx.services.PrefixedQName(_loc13, _loc11.headerQName);
            var _loc10 = new mx.services.PrefixedQName(_loc13, _loc11.bodyQName);
            var _loc15 = new mx.services.PrefixedQName(_loc13, _loc11.faultQName);
            var _loc5 = _loc8.childNodes;
            var _loc7 = _loc5.length;
            for (var _loc3 = 0; _loc3 < _loc7; ++_loc3)
            {
                var _loc2 = _loc5[_loc3];
                if (_loc2.nodeName == _loc9.qualifiedName)
                {
                    responseHeaders = this.decodeSOAPHeaders(_loc2);
                    continue;
                } // end if
                if (fault == undefined && _loc2.nodeName == _loc10.qualifiedName)
                {
                    bodyNode = _loc2;
                    if (doDecoding)
                    {
                        _loc4 = this.decodeSOAPBody(_loc2, _loc6);
                        continue;
                    } // end if
                    _loc4 = _loc2.childNodes;
                } // end if
            } // end of for
        } // end else if
        return (_loc4);
    } // End of the function
    function decodeSOAPHeaders(headerNode)
    {
        log.logDebug("Decoding SOAP response headers");
        var _loc6 = new Array();
        var _loc7 = headerNode.childNodes;
        var _loc8 = _loc7.length;
        for (var _loc4 = 0; _loc4 < _loc8; ++_loc4)
        {
            var _loc2 = _loc7[_loc4];
            var _loc5 = _loc2.attributes.mustUnderstand;
            if (_loc5 == "1")
            {
                if (typeof(onHeader) != "function")
                {
                    var _loc3 = new mx.services.SOAPFault();
                    _loc3.faultcode = "MustUnderstand";
                    _loc3.faultstring = "No callback for header " + _loc2.nodeName;
                    fault = _loc3;
                    break;
                } // end if
            } // end if
            _loc6.push(_loc2);
        } // end of for
        return (_loc6);
    } // End of the function
    function decodeSOAPBody(bodyNode, xsiPrefix)
    {
        log.logDebug("Decoding SOAP response body");
        var _loc7;
        var _loc8 = bodyNode.childNodes[0];
        if (_loc8.getLocalName() == soapConstants.faultQName.localPart)
        {
            fault = this.decodeSOAPFault(_loc8);
        }
        else if (myCall.useStyle == mx.services.SOAPConstants.USE_ENCODED)
        {
            var _loc9 = _loc8.childNodes;
            var _loc10 = _loc9.length;
            for (var _loc2 = 0; _loc2 < _loc10; ++_loc2)
            {
                var _loc3 = _loc9[_loc2];
                var _loc6 = this.getOutputParameter(_loc2);
                var _loc4 = this.decodeResultNode(_loc3, _loc6.schemaType);
                _loc6.value = _loc4;
                if (_loc2 == 0)
                {
                    _loc7 = _loc4;
                } // end if
            } // end of for
        }
        else
        {
            _loc6 = this.getOutputParameterByQName(_loc8.getQName());
            if (myCall.operationStyle == mx.services.SOAPConstants.WRAPPED_STYLE)
            {
                for (var _loc11 in _loc6.schemaType.partTypes)
                {
                    var _loc5 = _loc6.schemaType.partTypes[_loc11];
                    _loc4 = this.decodeResultNode(_loc8.childNodes[0], _loc5.schemaType);
                    _loc7 = _loc4;
                } // end of for...in
            }
            else
            {
                _loc7 = this.decodeResultNode(_loc8, _loc6.schemaType);
                _loc6.value = _loc7;
            } // end else if
        } // end else if
        return (_loc7);
    } // End of the function
    function decodeResultNode(resultNode, schemaType, preExistingResult)
    {
        var _loc5;
        var _loc17 = resultNode.attributes.href;
        if (_loc17 != undefined)
        {
            resultNode = this.decodeRef(bodyNode, _loc17);
            if (resultNode == undefined)
            {
            } // end if
        } // end if
        var _loc13 = myCall.schemaVersion;
        for (var _loc15 in resultNode.attributes)
        {
            var _loc10 = resultNode.getQNameFromString(_loc15);
            if (_loc13.nilQName.equals(_loc10))
            {
                var _loc9 = resultNode.attributes[_loc15];
                if (_loc9 == "true" || _loc9 == "1")
                {
                    return (null);
                } // end if
            } // end if
        } // end of for...in
        if (schemaType == undefined || schemaType.typeType == mx.services.DataType.ANY_TYPE)
        {
            schemaType = this.getTypeFromNode(resultNode);
        } // end if
        if (schemaType.typeType == mx.services.DataType.ARRAY_TYPE)
        {
            _loc5 = this.decodeArrayNode(resultNode, schemaType.arrayType);
        }
        else if (schemaType.typeType == mx.services.DataType.COLL_TYPE)
        {
            _loc5 = this.decodeCollectionNode(resultNode, schemaType.arrayType, preExistingResult);
        }
        else if (schemaType.typeType == mx.services.DataType.XML_TYPE)
        {
            _loc5 = resultNode;
        }
        else if (schemaType.typeType == mx.services.DataType.MAP_TYPE)
        {
            _loc5 = this.decodeMap(resultNode);
        }
        else if (schemaType.typeType == mx.services.DataType.ROWSET_TYPE)
        {
            _loc5 = this.decodeRowSet(resultNode);
        }
        else if (schemaType.typeType == mx.services.DataType.QBEAN_TYPE)
        {
            _loc5 = this.decodeQueryBean(resultNode);
        }
        else if (schemaType.partTypes != undefined)
        {
            _loc5 = new Object();
            var _loc2;
            for (var _loc2 in schemaType.partTypes)
            {
                if (schemaType.partTypes[_loc2].isAttribute)
                {
                    _loc5[_loc2] = resultNode.attributes[_loc2];
                } // end if
            } // end of for...in
            if (schemaType.simpleValue == undefined)
            {
                var _loc12 = resultNode.childNodes;
                for (var _loc2 = 0; _loc2 < _loc12.length; ++_loc2)
                {
                    var _loc7 = _loc12[_loc2];
                    var _loc6 = _loc7.getLocalName();
                    var _loc8 = schemaType.partTypes[_loc6];
                    if (_loc8 == undefined)
                    {
                    } // end if
                    var _loc11 = _loc5[_loc6];
                    _loc5[_loc6] = this.decodeResultNode(_loc7, _loc8.schemaType, _loc11);
                } // end of for
            }
            else
            {
                _loc5._value = this.decodeResultNode(resultNode, schemaType.simpleValue);
            } // end else if
        }
        else if (resultNode.childNodes.length == 0)
        {
            if (schemaType.typeType == mx.services.DataType.STRING_TYPE)
            {
                _loc5 = "";
            }
            else
            {
                _loc5 = null;
            } // end else if
        }
        else if (resultNode.childNodes.length == 1 && resultNode.childNodes[0].nodeType == 3)
        {
            var _loc14 = resultNode.childNodes[0];
            var _loc18 = schemaType.typeType;
            if (schemaType.typeType == mx.services.DataType.BOOLEAN_TYPE)
            {
                var _loc16 = _loc14.nodeValue;
                if (_loc16.toLowerCase() == "true" || _loc16 == "1")
                {
                    _loc5 = true;
                }
                else
                {
                    _loc5 = false;
                } // end else if
            }
            else if (schemaType.typeType == mx.services.DataType.DATE_TYPE)
            {
                _loc5 = this.decodeDate(_loc14.nodeValue);
            }
            else if (schemaType.typeType == mx.services.DataType.NUMBER_TYPE)
            {
                _loc5 = Number(_loc14.nodeValue);
            }
            else
            {
                _loc5 = _loc14.nodeValue;
            } // end else if
        }
        else
        {
            _loc5 = resultNode;
        } // end else if
        return (_loc5);
    } // End of the function
    function decodeRef(rootNode, id)
    {
        id = id.substring(1);
        if (_multiRefs == null)
        {
            _multiRefs = new Object();
            var _loc5 = rootNode.childNodes;
            var _loc6 = _loc5.length;
            for (var _loc2 = 0; _loc2 < _loc6; ++_loc2)
            {
                var _loc3 = _loc5[_loc2];
                var _loc4 = _loc3.attributes.id;
                if (_loc4 != undefined)
                {
                    _multiRefs[_loc4] = _loc3;
                } // end if
            } // end of for
        } // end if
        return (_multiRefs[id]);
    } // End of the function
    function decodeArrayNode(node, arrayType)
    {
        return (myCall.useStyle == mx.services.SOAPConstants.USE_LITERAL ? (this.decodeLiteralArrayNode(node, arrayType)) : (this.decodeSOAPArrayNode(node, arrayType)));
    } // End of the function
    function decodeLiteralArrayNode(node, arrayType)
    {
        if (doLazyDecoding)
        {
            return (new mx.services.ArrayProxy(node.childNodes, this, arrayType));
        } // end if
        var _loc4 = new Array();
        var _loc3 = node.childNodes;
        var _loc5 = _loc3.length;
        for (var _loc2 = 0; _loc2 < _loc5; ++_loc2)
        {
            _loc4.push(this.decodeResultNode(_loc3[_loc2], arrayType));
        } // end of for
        return (_loc4);
    } // End of the function
    function decodeCollectionNode(node, arrayType, arrayObj)
    {
        if (arrayObj == undefined)
        {
            arrayObj = new Array();
        } // end if
        arrayObj.push(this.decodeResultNode(node, arrayType));
        return (arrayObj);
    } // End of the function
    function decodeSOAPArrayNode(node, arrayType)
    {
        var _loc9 = new Array();
        var _loc4 = node.getAttributeByQName(soapConstants.soapencArrayTypeQName);
        if (_loc4 == undefined)
        {
            var _loc7 = this.decodeLiteralArrayNode(node, arrayType);
            return (_loc7);
        } // end if
        var _loc2 = myCall.schemaContext.getTypeByQName(node.getQNameFromString(_loc4));
        if (_loc2 != undefined)
        {
            arrayType = _loc2;
        } // end if
        var _loc6 = new Array(1);
        _loc6[0] = 0;
        var _loc8 = this.decodeArrayContents(node.childNodes, _loc6, arrayType.dimensions, 0, arrayType);
        return (_loc8);
    } // End of the function
    function decodeArrayContents(arrayMemberNodes, linearIdxHolder, dimensions, dimensionIdx, arrayType)
    {
        var _loc4 = dimensions[dimensionIdx];
        var _loc3 = new Array();
        if (dimensionIdx == dimensions.length - 1)
        {
            for (var _loc2 = 0; _loc2 < _loc4; ++_loc2)
            {
                _loc3[_loc2] = this.decodeResultNode(arrayMemberNodes[linearIdxHolder[0]++], arrayType.arrayType);
            } // end of for
        }
        else
        {
            for (var _loc2 = 0; _loc2 < _loc4; ++_loc2)
            {
                _loc3[_loc2] = this.decodeArrayContents(arrayMemberNodes, linearIdxHolder, dimensions, dimensionIdx + 1, arrayType.arrayType);
            } // end of for
        } // end else if
        return (_loc3);
    } // End of the function
    function decodeRowSet(rowSetNode)
    {
        var _loc10 = new Array();
        var _loc7 = new Array();
        var _loc6 = new Array();
        var _loc9 = rowSetNode.childNodes[0].childNodes;
        var _loc12 = _loc9.length;
        for (var _loc2 = 0; _loc2 < _loc12; ++_loc2)
        {
            var _loc3 = _loc9[_loc2];
            var _loc4 = _loc3.attributes.type;
            if (_loc4 == undefined)
            {
                return;
            } // end if
            var _loc5 = _loc3.getQNameFromString(_loc4);
            if (_loc5 == undefined)
            {
                return;
            } // end if
            _loc7[_loc2] = myCall.schemaContext.getTypeByQName(_loc5);
            _loc6[_loc2] = _loc3.childNodes[0].nodeValue;
        } // end of for
        var _loc8 = rowSetNode.childNodes[1].childNodes;
        var _loc11 = _loc8.length;
        if (doLazyDecoding)
        {
            return (new mx.services.RowSetProxy(this, _loc8, _loc7, _loc6));
        } // end if
        for (var _loc2 = 0; _loc2 < _loc11; ++_loc2)
        {
            _loc10[_loc2] = this.decodeRowSetItem(_loc8[_loc2], _loc7, _loc6);
        } // end of for
        return (_loc10);
    } // End of the function
    function decodeQueryBean(beanNode)
    {
        var _loc10 = new Array();
        var _loc4 = new Array();
        var _loc9 = beanNode.getElementsByLocalName("columnList")[0];
        if (_loc9 == undefined)
        {
            return;
        } // end if
        var _loc11 = _loc9.childNodes.length;
        for (var _loc3 = 0; _loc3 < _loc11; ++_loc3)
        {
            var _loc7 = _loc9.childNodes[_loc3];
            _loc4[_loc3] = _loc7.childNodes[0].nodeValue;
        } // end of for
        var _loc12 = beanNode.getElementsByLocalName("data")[0];
        if (_loc12 == undefined)
        {
            return;
        } // end if
        var _loc8 = this.decodeSOAPArrayNode(_loc12);
        for (var _loc3 = 0; _loc3 < _loc8.length; ++_loc3)
        {
            var _loc6 = _loc8[_loc3];
            var _loc5 = new Object();
            for (var _loc2 = 0; _loc2 < _loc4.length; ++_loc2)
            {
                _loc5[_loc4[_loc2]] = _loc6[_loc2];
            } // end of for
            _loc10[_loc3] = _loc5;
        } // end of for
        return (_loc10);
    } // End of the function
    function decodeRowSetItem(itemNode, types, fields)
    {
        var _loc5 = itemNode.childNodes;
        var _loc4 = new Object();
        var _loc6 = types.length;
        for (var _loc2 = 0; _loc2 < _loc6; ++_loc2)
        {
            var _loc3 = _loc5[_loc2];
            _loc4[fields[_loc2]] = this.decodeResultNode(_loc3, types[_loc2]);
        } // end of for
        return (_loc4);
    } // End of the function
    function decodeMap(node)
    {
        var _loc9 = new Object();
        var _loc8 = node.childNodes;
        for (var _loc5 = 0; _loc5 < _loc8.length; ++_loc5)
        {
            var _loc4 = _loc8[_loc5].childNodes;
            var _loc6;
            var _loc7;
            for (var _loc3 = 0; _loc3 < _loc4.length; ++_loc3)
            {
                var _loc2 = _loc4[_loc3];
                if (_loc2.nodeName == "key")
                {
                    _loc6 = this.decodeResultNode(_loc2);
                    continue;
                } // end if
                if (_loc2.nodeName == "value")
                {
                    _loc7 = this.decodeResultNode(_loc2);
                    continue;
                } // end if
            } // end of for
            _loc9[_loc6] = _loc7;
        } // end of for
        return (_loc9);
    } // End of the function
    function getTypeFromNode(node)
    {
        var _loc2 = node.attributes.xsi:type;
        if (_loc2 == undefined)
        {
            return;
        } // end if
        var _loc3 = node.getQNameFromString(_loc2);
        if (_loc3 == undefined)
        {
            return;
        } // end if
        return (myCall.schemaContext.getTypeByQName(_loc3));
    } // End of the function
    function decodeDate(rawValue)
    {
        var _loc4;
        var _loc2;
        var _loc1;
        var _loc8 = rawValue.indexOf("T");
        var _loc14 = rawValue.indexOf(":");
        var _loc15 = rawValue.indexOf("-");
        if (_loc8 != -1)
        {
            _loc2 = rawValue.substring(0, _loc8);
            _loc1 = rawValue.substring(_loc8 + 1);
        }
        else if (_loc14 != -1)
        {
            _loc1 = rawValue;
        }
        else if (_loc15 != -1)
        {
            _loc2 = rawValue;
        } // end else if
        if (_loc2 != undefined)
        {
            var _loc13 = _loc2.substring(0, _loc2.indexOf("-"));
            var _loc12 = _loc2.substring(5, _loc2.indexOf("-", 5));
            var _loc9 = _loc2.substring(8, 10);
            _loc4 = new Date(Date.UTC(_loc13, _loc12 - 1, _loc9));
        }
        else
        {
            _loc4 = new Date();
        } // end else if
        if (_loc1 != undefined)
        {
            var _loc3 = "Z";
            var _loc6 = 0;
            if (_loc2.length > 10)
            {
                _loc3 = _loc2.substring(10);
            }
            else if (_loc1.length > 12)
            {
                _loc3 = _loc1.substring(12);
            } // end else if
            if (_loc3 != "Z")
            {
                var _loc7 = _loc3.length;
                _loc6 = _loc3.substring(_loc7 - 5, _loc7 - 3);
                if (_loc3.charAt(_loc7 - 6) == "+")
                {
                    _loc6 = -_loc6;
                } // end if
            } // end if
            var _loc16 = Number(_loc1.substring(0, _loc1.indexOf(":")));
            var _loc17 = _loc1.substring(3, _loc1.indexOf(":", 3));
            var _loc10 = _loc1.substring(6, _loc1.indexOf(".", 6));
            var _loc11 = _loc1.substr(9, 3);
            _loc4.setUTCHours(_loc16, _loc17, _loc10, _loc11);
            _loc4 = new Date(_loc4.getTime() + _loc6 * 3600000);
        } // end if
        return (_loc4);
    } // End of the function
    function decodeSOAPFault(faultNode)
    {
        log.logDebug("SOAP: Decoding SOAP response fault");
        var _loc4 = new mx.services.SOAPFault();
        _loc4.element = faultNode;
        var _loc5 = faultNode.childNodes;
        var _loc6 = _loc5.length;
        for (var _loc3 = 0; _loc3 < _loc6; ++_loc3)
        {
            var _loc2 = _loc5[_loc3];
            if (_loc2.nodeName == "faultcode")
            {
                _loc4.faultcode = _loc2.childNodes[0].toString();
                continue;
            } // end if
            if (_loc2.nodeName == "faultstring")
            {
                _loc4.faultstring = _loc2.childNodes[0].toString();
                continue;
            } // end if
            if (_loc2.nodeName == "faultactor")
            {
                _loc4.faultactor = _loc2.childNodes[0].toString();
                continue;
            } // end if
            if (_loc2.nodeName == "detail")
            {
                _loc4.detail = _loc2;
            } // end if
        } // end of for
        return (_loc4);
    } // End of the function
    function getOutputParameter(index)
    {
        return (this.getOutputParameters()[index]);
    } // End of the function
    function getOutputParameterByName(localName)
    {
        var _loc4 = this.getOutputParameters();
        var _loc5 = _loc4.length;
        for (var _loc2 = 0; _loc2 < _loc5; ++_loc2)
        {
            var _loc3 = _loc4[_loc2];
            if (_loc3.name == localName)
            {
                return (_loc3);
            } // end if
        } // end of for
    } // End of the function
    function getOutputParameterByQName(qname)
    {
        var _loc4 = this.getOutputParameters();
        var _loc6 = _loc4.length;
        for (var _loc2 = 0; _loc2 < _loc6; ++_loc2)
        {
            var _loc3 = _loc4[_loc2].qname;
            if (_loc3 != undefined)
            {
                if (_loc3.localPart == qname.localPart && _loc3.namespaceURI == qname.namespaceURI)
                {
                    return (_loc4[_loc2]);
                } // end if
            } // end if
        } // end of for
    } // End of the function
    function getOutputParameters()
    {
        var _loc5 = new Array();
        var _loc4 = myCall.parameters;
        var _loc6 = _loc4.length;
        for (var _loc2 = 0; _loc2 < _loc6; ++_loc2)
        {
            var _loc3 = _loc4[_loc2];
            if (_loc3.mode != mx.services.SOAPConstants.MODE_IN)
            {
                _loc5.push(_loc3);
            } // end if
        } // end of for
        return (_loc5);
    } // End of the function
    function getOutputValue(index)
    {
        return (this.getOutputValues()[index]);
    } // End of the function
    function getOutputValues()
    {
        var _loc5 = new Array();
        var _loc4 = myCall.parameters;
        var _loc6 = _loc4.length;
        for (var _loc2 = 0; _loc2 < _loc6; ++_loc2)
        {
            var _loc3 = _loc4[_loc2];
            if (_loc3.mode != mx.services.SOAPConstants.MODE_IN)
            {
                _loc5.push(_loc3.value);
            } // end if
        } // end of for
        return (_loc5);
    } // End of the function
    function getInputParameter(index)
    {
        return (this.getInputParameters()[index]);
    } // End of the function
    function getInputParameters()
    {
        var _loc5 = new Array();
        var _loc4 = myCall.parameters;
        var _loc6 = _loc4.length;
        for (var _loc2 = 0; _loc2 < _loc6; ++_loc2)
        {
            var _loc3 = _loc4[_loc2];
            if (_loc3.mode != mx.services.SOAPConstants.MODE_OUT)
            {
                _loc5.push(_loc3);
            } // end if
        } // end of for
        return (_loc5);
    } // End of the function
    var doLazyDecoding = true;
    var doDecoding = true;
    var cancelled = false;
} // End of Class
