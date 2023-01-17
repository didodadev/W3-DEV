class mx.services.Schema
{
    var targetNamespace, rootElement, context, schemaVersion, types, elements, elementFormDefault;
    function Schema(targetNamespace, rootElement, schemaContext)
    {
        this.targetNamespace = targetNamespace;
        this.rootElement = rootElement;
        context = schemaContext;
        schemaVersion = schemaContext.schemaVersion;
        types = new Object();
        elements = new Object();
    } // End of the function
    static function getSchemas(xmlDocument)
    {
        var _loc1 = new Array();
        return (_loc1);
    } // End of the function
    function registerType(dtype)
    {
        if (types[dtype.name] == undefined)
        {
            types[dtype.name] = dtype;
        } // end if
    } // End of the function
    function registerElement(elementObj)
    {
        elements[elementObj.name] = elementObj;
    } // End of the function
    function parseType(localPart)
    {
        var _loc2 = rootElement.getElementsByReferencedName(localPart, schemaVersion.complexTypeQName)[0];
        if (_loc2 != undefined)
        {
            return (this.parseComplexType(_loc2));
        } // end if
        _loc2 = rootElement.getElementsByReferencedName(localPart, schemaVersion.simpleTypeQName)[0];
        if (_loc2 != undefined)
        {
            return (this.parseSimpleType(_loc2));
        } // end if
    } // End of the function
    function parseElement(name)
    {
        var _loc3 = rootElement.getElementsByReferencedName(name, schemaVersion.elementTypeQName)[0];
        if (_loc3 != undefined)
        {
            var _loc2 = this.parseElementDecl(_loc3);
            this.registerElement(_loc2);
            return (_loc2);
        } // end if
    } // End of the function
    function parseComplexType(typeNode, isAnonymous)
    {
        var _loc4 = new mx.services.DataType();
        var _loc8 = typeNode.attributes.name;
        if (!isAnonymous)
        {
            _loc4.name = _loc8;
            _loc4.namespaceURI = targetNamespace;
            _loc4.qname = new mx.services.QName(_loc8, targetNamespace);
            this.registerType(_loc4);
        }
        else
        {
            _loc4.isAnonymous = true;
        } // end else if
        var _loc6 = typeNode.childNodes;
        var _loc7 = _loc6.length;
        for (var _loc5 = 0; _loc5 < _loc7 && context.fault == undefined; ++_loc5)
        {
            var _loc2 = _loc6[_loc5];
            var _loc3 = _loc2.getQName();
            if (_loc3.equals(schemaVersion.allQName))
            {
                this.parseAll(_loc2, _loc4);
                continue;
            } // end if
            if (_loc3.equals(schemaVersion.complexContentQName))
            {
                this.parseComplexContent(_loc2, _loc4);
                continue;
            } // end if
            if (_loc3.equals(schemaVersion.simpleContentQName))
            {
                this.parseSimpleContent(_loc2, _loc4);
                continue;
            } // end if
            if (_loc3.equals(schemaVersion.sequenceQName))
            {
                this.parseSequence(_loc2, _loc4);
                continue;
            } // end if
            if (_loc3.equals(schemaVersion.attributeQName))
            {
                this.parseAttribute(_loc2, _loc4);
            } // end if
        } // end of for
        typeNode.parsed = 1;
        return (_loc4);
    } // End of the function
    function parseSimpleType(typeNode, isAnonymous)
    {
        var _loc8 = new mx.services.DataType();
        var _loc11 = typeNode.attributes.name;
        if (!isAnonymous)
        {
            _loc8.name = _loc11;
            _loc8.namespaceURI = targetNamespace;
            _loc8.qname = new mx.services.QName(_loc11, targetNamespace);
            this.registerType(_loc8);
        }
        else
        {
            _loc8.isAnonymous = true;
        } // end else if
        var _loc9 = typeNode.childNodes;
        var _loc10 = _loc9.length;
        for (var _loc3 = 0; _loc3 < _loc10; ++_loc3)
        {
            var _loc2 = _loc9[_loc3];
            var _loc4 = _loc2.getQName();
            if (_loc4.equals(schemaVersion.restrictionQName))
            {
                var _loc5 = _loc2.attributes.base;
                var _loc6 = _loc2.getQNameFromString(_loc5);
                var _loc7 = context.getTypeByQName(_loc6);
                _loc8.typeType = _loc7.typeType;
            } // end if
        } // end of for
        typeNode.parsed = 1;
        return (_loc8);
    } // End of the function
    function parseAll(allNode, typeObj)
    {
        return (this.parseSequence(allNode, typeObj));
    } // End of the function
    function parseElementDecl(elementNode)
    {
        var _loc2 = new mx.services.ElementDecl();
        var _loc6;
        if (elementNode.attributes.ref != undefined)
        {
            var _loc10 = elementNode.attributes.ref;
            var _loc9 = elementNode.getQNameFromString(_loc10);
            var _loc5 = context.getElementByQName(_loc9);
            _loc2.name = _loc5.name;
            _loc2.schemaType = _loc5.schemaType;
            _loc2.form = _loc5.form;
            _loc2.namespace = _loc5.namespace;
            _loc2.minOccurs = elementNode.attributes.minOccurs;
            _loc2.maxOccurs = elementNode.attributes.maxOccurs;
            return (_loc2);
        } // end if
        var _loc12 = elementNode.attributes.name;
        _loc2.name = _loc12;
        if (elementNode.attributes.type != undefined)
        {
            var _loc11 = elementNode.getQNameFromString(elementNode.attributes.type, true);
            _loc6 = context.getTypeByQName(_loc11);
        }
        else
        {
            var _loc8 = elementNode.getElementsByQName(schemaVersion.complexTypeQName)[0];
            if (_loc8 != null)
            {
                _loc6 = this.parseComplexType(_loc8, true);
            }
            else
            {
                var _loc7 = elementNode.getElementsByQName(schemaVersion.simpleTypeQName)[0];
                if (_loc7 != null)
                {
                    _loc6 = this.parseSimpleType(_loc7, true);
                } // end if
            } // end else if
        } // end else if
        _loc2.schemaType = _loc6;
        _loc2.minOccurs = elementNode.attributes.minOccurs;
        _loc2.maxOccurs = elementNode.attributes.maxOccurs;
        var _loc4 = elementNode.attributes.form;
        if (_loc4 == undefined)
        {
            _loc4 = elementFormDefault;
        } // end if
        _loc2.form = _loc4;
        if (_loc4 == "qualified")
        {
            _loc2.namespace = targetNamespace;
        }
        else
        {
            _loc2.namespace = "";
        } // end else if
        return (_loc2);
    } // End of the function
    function parseAttribute(attrNode, typeObj)
    {
        var _loc4 = attrNode.attributes.name;
        var _loc6 = new Object();
        _loc6.name = _loc4;
        var _loc5 = attrNode.attributes.type;
        if (_loc5 != undefined)
        {
            var _loc7 = attrNode.getQNameFromString(_loc5, true);
            var _loc3 = context.getTypeByQName(_loc7);
            if (_loc3 != undefined)
            {
                if (typeObj.partTypes == undefined)
                {
                    typeObj.partTypes = new Object();
                } // end if
                var _loc2 = new Object();
                _loc2.isAttribute = true;
                _loc2.schemaType = _loc3;
                typeObj.partTypes[_loc4] = _loc2;
            } // end if
        } // end if
    } // End of the function
    function parseSequence(sequenceNode, dtype)
    {
        var _loc9 = sequenceNode.childNodes;
        var _loc8 = _loc9.length;
        for (var _loc5 = _loc8 - 1; _loc5 > -1; --_loc5)
        {
            var _loc7 = _loc9[_loc5];
            var _loc2 = this.parseElementDecl(_loc7);
            var _loc4 = _loc2;
            if (_loc8 == 1 && _loc2.maxOccurs == "unbounded")
            {
                dtype.name = "array";
                dtype.typeType = mx.services.DataType.ARRAY_TYPE;
                dtype.arrayType = _loc4.schemaType;
                dtype.itemElement = new mx.services.QName(_loc2.name, _loc2.namespace);
                continue;
            } // end if
            if (_loc2.maxOccurs == "unbounded")
            {
                var _loc6 = new mx.services.DataType("array", mx.services.DataType.ARRAY_TYPE);
                _loc6.arrayType = _loc4.schemaType;
                _loc4 = _loc6;
                _loc4.itemElement = new mx.services.QName(_loc2.name, _loc2.namespace);
            } // end if
            if (dtype.partTypes == undefined)
            {
                dtype.partTypes = new Object();
            } // end if
            dtype.partTypes[_loc2.name] = _loc4;
        } // end of for
        return (dtype);
    } // End of the function
    function parseSimpleContent(contentNode, typeObj)
    {
        var _loc5 = contentNode.firstChild;
        if (!_loc5.getQName().equals(schemaVersion.extensionQName))
        {
            return;
        } // end if
        var _loc6 = _loc5.attributes.base;
        var _loc7 = _loc5.getQNameFromString(_loc6, true);
        var _loc8 = context.getTypeByQName(_loc7);
        if (typeObj.partTypes == undefined)
        {
            typeObj.partTypes = new Object();
        } // end if
        typeObj.simpleValue = _loc8;
        var _loc3 = _loc5.childNodes;
        for (var _loc2 = 0; _loc2 < _loc3.length; ++_loc2)
        {
            this.parseAttribute(_loc3[_loc2], typeObj);
        } // end of for
    } // End of the function
    function parseComplexContent(contentNode, typeObj)
    {
        var _loc6 = contentNode.childNodes;
        var _loc7 = _loc6.length;
        for (var _loc3 = 0; _loc3 < _loc7 && context.fault == undefined; ++_loc3)
        {
            var _loc2 = _loc6[_loc3];
            var _loc4 = _loc2.getQName();
            if (_loc4.equals(schemaVersion.restrictionQName))
            {
                return (this.parseRestriction(_loc2, typeObj));
            } // end if
            if (_loc4.equals(schemaVersion.extensionQName))
            {
                return (this.parseExtension(_loc2, typeObj));
            } // end if
        } // end of for
    } // End of the function
    function parseExtension(extensionNode, typeObj)
    {
        var _loc11 = extensionNode.attributes.base;
        var _loc12 = extensionNode.getQNameFromString(_loc11);
        var _loc5 = context.getTypeByQName(_loc12);
        typeObj.typeType = _loc5.typeType;
        typeObj.partTypes = new Object();
        for (var _loc9 in _loc5.partTypes)
        {
            typeObj.partTypes[_loc9] = _loc5.partTypes[_loc9];
        } // end of for...in
        var _loc7 = extensionNode.childNodes;
        var _loc8 = _loc7.length;
        for (var _loc2 = 0; _loc2 < _loc8 && context.fault == undefined; ++_loc2)
        {
            var _loc3 = _loc7[_loc2];
            var _loc4 = _loc3.getQName();
            if (_loc4.equals(schemaVersion.sequenceQName))
            {
                return (this.parseSequence(_loc3, typeObj));
            } // end if
        } // end of for
    } // End of the function
    function parseRestriction(restrictionNode, derivedType)
    {
        var _loc13 = restrictionNode.attributes.base;
        var _loc14 = restrictionNode.getQNameFromString(_loc13);
        var _loc12 = context.getTypeByQName(_loc14);
        derivedType.name = "derived" + _loc12.name;
        derivedType.typeType = _loc12.typeType;
        derivedType.namespaceURI = _loc12.namespaceURI;
        if (_loc12.typeType == mx.services.DataType.ARRAY_TYPE)
        {
            derivedType.isEncodedArray = _loc12.isEncodedArray;
            derivedType.itemElement = _loc12.itemElement;
        } // end if
        var _loc10 = restrictionNode.getElementsByQName(schemaVersion.attributeQName);
        for (var _loc9 = 0; _loc9 < _loc10.length; ++_loc9)
        {
            var _loc5 = _loc10[_loc9];
            var _loc7 = _loc5.attributes.ref;
            if (_loc7.indexOf(":") != -1)
            {
                _loc7 = _loc7.substring(_loc7.indexOf(":") + 1);
            } // end if
            for (var _loc11 in _loc5.attributes)
            {
                var _loc2 = _loc11;
                if (_loc2.indexOf(":") != -1)
                {
                    _loc2 = _loc2.substring(_loc2.indexOf(":") + 1);
                } // end if
                if (_loc2 == _loc7)
                {
                    var _loc6 = _loc5.attributes[_loc11];
                    var _loc8 = _loc5.getQNameFromString(_loc6, true);
                    var _loc3 = context.getTypeByQName(_loc8);
                    if (_loc3 != undefined)
                    {
                        derivedType[_loc2] = _loc3[_loc2];
                        derivedType.name = _loc3.name;
                        derivedType.qname = _loc3.qname;
                        derivedType.namespaceURI = _loc3.namespaceURI;
                        continue;
                    } // end if
                    derivedType[_loc2] = _loc6;
                } // end if
            } // end of for...in
        } // end of for
        return (derivedType);
    } // End of the function
} // End of Class
