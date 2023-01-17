class mx.services.SchemaContext
{
    var log, schemas, schemaVersion, unresolvedImports, schemaURI, fault;
    function SchemaContext(logObj)
    {
        log = logObj;
        schemas = new Object();
    } // End of the function
    static function RegisterSchemaTypes(schemaObj, schemaVersion)
    {
        var _loc1 = schemaVersion.xsdURI;
        schemaObj.registerType(new mx.services.DataType("boolean", mx.services.DataType.BOOLEAN_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("string", mx.services.DataType.STRING_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("decimal", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("integer", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("negativeInteger", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("nonNegativeInteger", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("positiveInteger", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("nonPositiveInteger", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("long", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("int", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("short", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("byte", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("unsignedLong", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("unsignedInt", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("unsignedShort", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("unsignedByte", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("float", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("double", mx.services.DataType.NUMBER_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("date", mx.services.DataType.DATE_TYPE, _loc1));
        var _loc3 = new mx.services.DataType("dateTime", mx.services.DataType.DATE_TYPE, _loc1);
        schemaVersion.dateTimeType = _loc3;
        schemaObj.registerType(_loc3);
        schemaObj.registerType(new mx.services.DataType("time", mx.services.DataType.DATE_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("base64Binary", mx.services.DataType.OBJECT_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("hexBinary", mx.services.DataType.OBJECT_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("token", mx.services.DataType.STRING_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("normalizedString", mx.services.DataType.STRING_TYPE, _loc1));
        schemaObj.registerType(new mx.services.DataType("anyType", mx.services.DataType.ANY_TYPE, _loc1));
        if (_loc1 == mx.services.SchemaVersion.XSD_URI_1999)
        {
            schemaObj.registerType(new mx.services.DataType("timeInstant", mx.services.DataType.DATE_TYPE, _loc1));
        } // end if
    } // End of the function
    static function RegisterStandardTypes(schemaObj)
    {
        mx.services.SchemaContext.RegisterSchemaTypes(schemaObj, mx.services.SchemaVersion.getSchemaVersion(mx.services.SchemaVersion.XSD_URI_1999));
        mx.services.SchemaContext.RegisterSchemaTypes(schemaObj, mx.services.SchemaVersion.getSchemaVersion(mx.services.SchemaVersion.XSD_URI_2000));
        mx.services.SchemaContext.RegisterSchemaTypes(schemaObj, mx.services.SchemaVersion.getSchemaVersion(mx.services.SchemaVersion.XSD_URI_2001));
        schemaObj.registerType(new mx.services.DataType("string", mx.services.DataType.STRING_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        schemaObj.registerType(new mx.services.DataType("int", mx.services.DataType.NUMBER_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        schemaObj.registerType(new mx.services.DataType("integer", mx.services.DataType.NUMBER_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        schemaObj.registerType(new mx.services.DataType("long", mx.services.DataType.NUMBER_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        schemaObj.registerType(new mx.services.DataType("short", mx.services.DataType.NUMBER_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        schemaObj.registerType(new mx.services.DataType("byte", mx.services.DataType.NUMBER_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        schemaObj.registerType(new mx.services.DataType("decimal", mx.services.DataType.NUMBER_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        schemaObj.registerType(new mx.services.DataType("float", mx.services.DataType.NUMBER_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        schemaObj.registerType(new mx.services.DataType("base64", mx.services.DataType.NUMBER_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        schemaObj.registerType(new mx.services.DataType("double", mx.services.DataType.NUMBER_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        schemaObj.registerType(new mx.services.DataType("boolean", mx.services.DataType.BOOLEAN_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI));
        var _loc2 = new mx.services.DataType("Array", mx.services.DataType.ARRAY_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI);
        _loc2.arrayType = new mx.services.DataType("any", mx.services.DataType.ANY_TYPE, mx.services.SchemaVersion.SOAP_ENCODING_URI);
        _loc2.arrayDimensions = 1;
        _loc2.isEncodedArray = true;
        _loc2.itemElement = new mx.services.QName("item");
        schemaObj.registerType(_loc2);
        schemaObj.registerType(new mx.services.DataType("Map", mx.services.DataType.MAP_TYPE, mx.services.SchemaVersion.APACHESOAP_URI));
        schemaObj.registerType(new mx.services.DataType("RowSet", mx.services.DataType.ROWSET_TYPE, mx.services.SchemaVersion.APACHESOAP_URI));
        schemaObj.registerType(new mx.services.DataType("QueryBean", mx.services.DataType.QBEAN_TYPE, mx.services.SchemaVersion.CF_RPC_URI));
    } // End of the function
    function registerSchemaNode(rootElement, document)
    {
        var _loc4 = rootElement.getQName();
        if (_loc4.localPart != "schema")
        {
            return;
        } // end if
        var _loc2 = mx.services.SchemaVersion.getSchemaVersion(_loc4.namespaceURI);
        if (_loc2 == undefined)
        {
            return;
        } // end if
        schemaVersion = _loc2;
        if (rootElement.getQName().equals(_loc2.schemaQName))
        {
            var _loc5 = rootElement.attributes.targetNamespace;
            this.processImports(rootElement, _loc2, document);
            return (this.registerNamespace(_loc5, rootElement));
            
        } // end if
    } // End of the function
    function processImports(rootElement, schemaVersion, document)
    {
        var _loc4 = rootElement.getElementsByQName(schemaVersion.importQName);
        if (_loc4 != undefined)
        {
            for (var _loc3 = 0; _loc3 < _loc4.length; ++_loc3)
            {
                var _loc2 = _loc4[_loc3].attributes.schemaLocation;
                if (_loc2 != undefined)
                {
                    _loc2 = this.buildURL(_loc2, document.location);
                    var _loc5 = _loc4[_loc3].attributes.namespace;
                    this.importDocument(_loc2, _loc5);
                } // end if
            } // end of for
        } // end if
    } // End of the function
    function importDocument(location, namespaceURI)
    {
        var _loc2 = new XML();
        _loc2.ignoreWhite = true;
        _loc2.schemaContext = this;
        _loc2.namespace = namespaceURI;
        _loc2.location = location;
        ++unresolvedImports;
        this.fetchDocument(_loc2);
    } // End of the function
    function fetchDocument(document)
    {
        document.onData = function (src)
        {
            if (src == undefined)
            {
                fault = new mx.services.SOAPFault(mx.services.SOAPConstants.DISCONNECTED_FAULT_CODE, "Could not load imported schema", "Unable to load schema, if currently online, please verify the URI and/or format of the schema at (" + schemaURI + ")");
                log.logDebug("Unable to receive WSDL file");
            }
            else
            {
                --unresolvedImports;
                this.registerSchemaNode(document.firstChild, document);
            } // end else if
        };
        document.load(document.location, "GET");
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
    function registerNamespace(namespaceURI, rootElement)
    {
        log.logInfo("Registering schema namespace: " + namespaceURI, mx.services.Log.VERBOSE);
        if (schemas[namespaceURI] != undefined)
        {
            log.logInfo("Duplicate namespace!");
            return;
        } // end if
        var _loc2 = new mx.services.Schema(namespaceURI, rootElement, this);
        schemas[namespaceURI] = _loc2;
        var _loc4 = rootElement.attributes.elementFormDefault;
        if (_loc4 != undefined && _loc4 == "qualified")
        {
            _loc2.elementFormDefault = "qualified";
        } // end if
        return (_loc2);
    } // End of the function
    function registerType(dtype)
    {
        var _loc4 = dtype.namespaceURI;
        var _loc2 = schemas[_loc4];
        if (_loc2 == undefined)
        {
            _loc2 = this.registerNamespace(_loc4);
        } // end if
        if (_loc2.types[dtype.name] == undefined)
        {
            _loc2.types[dtype.name] = dtype;
        } // end if
    } // End of the function
    function registerElement(elemObj)
    {
        var _loc4 = elemObj.namespaceURI;
        var _loc2 = schemas[_loc4];
        if (_loc2 == undefined)
        {
            _loc2 = this.registerNamespace(_loc4);
        } // end if
        if (elemObj.form == undefined)
        {
            elemObj.form = _loc2.elementFormDefault;
        } // end if
        _loc2.elements[elemObj.name] = elemObj;
    } // End of the function
    function getElementByQName(elQName)
    {
        var _loc3 = schemas[elQName.namespaceURI];
        if (_loc3 != undefined)
        {
            var _loc2 = _loc3.elements[elQName.localPart];
            if (_loc2 == undefined)
            {
                _loc2 = _loc3.parseElement(elQName.localPart);
                if (_loc2 == undefined)
                {
                } // end if
            } // end if
            return (_loc2);
        } // end if
    } // End of the function
    function getTypeByQName(typeQName)
    {
        var _loc13 = schemas[typeQName.namespaceURI];
        if (_loc13 != undefined)
        {
            var _loc12 = typeQName.localPart;
            var _loc14 = _loc12.indexOf("[");
            if (_loc14 != -1)
            {
                var _loc15 = _loc12.substring(0, _loc14);
                var _loc9 = this.getTypeByQName(new mx.services.QName(_loc15, typeQName.namespaceURI));
                var _loc4 = _loc12.substring(_loc14);
                for (var _loc2 = 0; _loc2 != -1; _loc2 = _loc4.indexOf("[", _loc7))
                {
                    var _loc6 = new Array();
                    ++_loc2;
                    for (var _loc3 = _loc4.indexOf(",", _loc2); _loc3 != -1; _loc3 = _loc4.indexOf(",", _loc2))
                    {
                        var _loc8 = Number(_loc4.substring(_loc2, _loc3));
                        _loc6.push(_loc8);
                        _loc2 = _loc3 + 1;
                    } // end of for
                    var _loc7 = _loc4.indexOf("]", _loc2);
                    if (_loc7 == -1)
                    {
                    } // end if
                    if (_loc7 == _loc2)
                    {
                        _loc6.push(-1);
                    }
                    else
                    {
                        var _loc10 = Number(_loc4.substring(_loc2, _loc7));
                        _loc6.push(_loc10);
                    } // end else if
                    var _loc5 = new mx.services.DataType(_loc9.name, mx.services.DataType.ARRAY_TYPE, _loc9.namespaceURI);
                    _loc5.isEncodedArray = true;
                    _loc5.arrayType = _loc9;
                    _loc5.itemElement = new mx.services.QName("item");
                    _loc5.dimensions = _loc6;
                    _loc9 = _loc5;
                } // end of for
                return (_loc9);
            } // end if
            var _loc11 = _loc13.types[_loc12];
            if (_loc11 != undefined)
            {
                return (_loc11);
            } // end if
            _loc11 = _loc13.parseType(_loc12);
            if (_loc11 == undefined)
            {
            } // end if
            return (_loc11);
        } // end if
    } // End of the function
    function getType(qualifiedName, node)
    {
        var _loc3 = "";
        var _loc4 = qualifiedName;
        var _loc2 = qualifiedName.indexOf(":");
        if (_loc2 != -1)
        {
            _loc3 = qualifiedName.substring(0, _loc2);
            _loc4 = qualifiedName.substring(_loc2 + 1);
        } // end if
        var _loc6 = node.getNamespaceForPrefix(_loc3);
        return (this.getTypeByQName(_loc4, _loc6, node));
    } // End of the function
} // End of Class
