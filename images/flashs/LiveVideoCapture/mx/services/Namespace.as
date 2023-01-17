class mx.services.Namespace
{
    var prefixedQName, nodeName, getNamespaceForPrefix, attributes, getElementsByLocalName, firstChild, appendChild, getQName, mappings, loadNSMappings, parentNode, childNodes, getLocalName;
    function Namespace()
    {
    } // End of the function
    static function setup()
    {
        if (mx.services.Namespace.alreadySetup)
        {
            return;
        } // end if
        alreadySetup = true;
        var _loc15 = XMLNode.prototype;
        if (_loc15.getQName == undefined)
        {
            _loc15.getQName = function ()
            {
                if (prefixedQName != undefined)
                {
                    return (prefixedQName.qname);
                }
                else
                {
                    var _loc2 = nodeName;
                    var _loc3 = "";
                    var _loc4 = _loc2.indexOf(":");
                    if (_loc4 != -1)
                    {
                        _loc3 = _loc2.substring(0, _loc4);
                        _loc2 = _loc2.substring(_loc4 + 1);
                    } // end if
                    var _loc6 = this.getNamespaceForPrefix(_loc3);
                    var _loc5 = new mx.services.QName(_loc2, _loc6);
                    prefixedQName = new mx.services.PrefixedQName(_loc3, _loc5);
                    return (_loc5);
                } // end else if
            };
        } // end if
        if (_loc15.setChildValue == undefined)
        {
            _loc15.setChildValue = function (name, value)
            {
                var _loc5 = attributes[name];
                if (_loc5 != undefined)
                {
                    attributes[name] = value;
                    return;
                } // end if
                var _loc2 = this.getElementsByLocalName(name)[0];
                if (_loc2 != undefined)
                {
                    _loc2.firstChild.removeNode();
                    var _loc4 = mx.services.Namespace._doc.createTextNode(value);
                    _loc2.appendChild(_loc4);
                } // end if
            };
        } // end if
        if (_loc15.setValue == undefined)
        {
            _loc15.setValue = function (value)
            {
                trace ("setting value to " + value);
                firstChild.removeNode();
                var _loc2 = mx.services.Namespace._doc.createTextNode(value);
                this.appendChild(_loc2);
            };
        } // end if
        if (_loc15.getQualifiedName == undefined)
        {
            _loc15.getQualifiedName = function ()
            {
                return (nodeName);
            };
        } // end if
        if (_loc15.getPrefix == undefined)
        {
            _loc15.getPrefix = function ()
            {
                if (prefixedQName != undefined)
                {
                    return (prefixedQName.prefix);
                }
                else
                {
                    var _loc2 = nodeName;
                    var _loc3 = "";
                    var _loc4 = _loc2.indexOf(":");
                    if (_loc4 != -1)
                    {
                        _loc3 = _loc2.substring(0, _loc4);
                    } // end if
                    return (_loc3);
                } // end else if
            };
        } // end if
        if (_loc15.getLocalName == undefined)
        {
            _loc15.getLocalName = function ()
            {
                if (prefixedQName != undefined)
                {
                    return (prefixedQName.qname.localPart);
                }
                else
                {
                    var _loc2 = nodeName;
                    var _loc3 = _loc2.indexOf(":");
                    if (_loc3 != -1)
                    {
                        _loc2 = _loc2.substring(_loc3 + 1);
                    } // end if
                    return (_loc2);
                } // end else if
            };
        } // end if
        if (_loc15.getNamespaceURI == undefined)
        {
            _loc15.getNamespaceURI = function ()
            {
                return (this.getQName().namespaceURI);
            };
        } // end if
        if (_loc15.loadNSMappings == undefined)
        {
            _loc15.loadNSMappings = function ()
            {
                if (mappings == undefined)
                {
                    mappings = new Object();
                } // end if
                for (var _loc4 in attributes)
                {
                    var _loc2 = true;
                    if (_loc4.indexOf("xmlns") == 0)
                    {
                        if (_loc4.charAt(5) == ":")
                        {
                            _loc2 = false;
                        }
                        else if (_loc4.length != 5)
                        {
                            continue;
                        } // end else if
                        var _loc3 = attributes[_loc4];
                        if (_loc2)
                        {
                            mappings["<>defaultNamespace<>"] = _loc3;
                            continue;
                        } // end if
                        mappings[_loc4.substring(6)] = _loc3;
                    } // end if
                } // end of for...in
            };
        } // end if
        if (_loc15.getPrefixForNamespace == undefined)
        {
            _loc15.getPrefixForNamespace = function (namespaceURI)
            {
                var _loc3;
                if (namespaceURI == undefined || namespaceURI == "")
                {
                    return;
                } // end if
                if (mappings == undefined)
                {
                    this.loadNSMappings();
                } // end if
                for (var _loc5 in mappings)
                {
                    var _loc2 = mappings[_loc5];
                    if (_loc2 == namespaceURI)
                    {
                        _loc3 = _loc5;
                        break;
                    } // end if
                } // end of for...in
                if (_loc3 == undefined && parentNode != undefined)
                {
                    _loc3 = parentNode.getPrefixForNamespace(namespaceURI);
                } // end if
                if (_loc3 == "<>defaultNamespace<>")
                {
                    _loc3 = "";
                } // end if
                return (_loc3);
            };
        } // end if
        if (_loc15.getNamespaceForPrefix == undefined)
        {
            _loc15.getNamespaceForPrefix = function (prefix)
            {
                if (prefix == "")
                {
                    prefix = "<>defaultNamespace<>";
                } // end if
                if (mappings == undefined)
                {
                    this.loadNSMappings();
                } // end if
                var _loc2 = mappings[prefix];
                if (_loc2 == undefined && parentNode != undefined)
                {
                    _loc2 = parentNode.getNamespaceForPrefix(prefix);
                } // end if
                return (_loc2);
            };
        } // end if
        if (_loc15.getElementsByQName == undefined)
        {
            _loc15.getElementsByQName = function (qname)
            {
                var _loc4 = new Array();
                if (this.getQName().equals(qname))
                {
                    _loc4.push(this);
                } // end if
                var _loc5 = childNodes.length;
                for (var _loc2 = 0; _loc2 < _loc5; ++_loc2)
                {
                    var _loc3 = childNodes[_loc2];
                    if (_loc3.getQName().equals(qname))
                    {
                        _loc4.push(_loc3);
                    } // end if
                } // end of for
                return (_loc4);
            };
        } // end if
        if (_loc15.getElementsByLocalName == undefined)
        {
            _loc15.getElementsByLocalName = function (lname)
            {
                var _loc4 = new Array();
                if (this.getLocalName() == lname)
                {
                    _loc4.push(this);
                } // end if
                var _loc5 = childNodes.length;
                for (var _loc2 = 0; _loc2 < _loc5; ++_loc2)
                {
                    var _loc3 = childNodes[_loc2];
                    if (_loc3.getLocalName() == lname)
                    {
                        _loc4.push(_loc3);
                    } // end if
                } // end of for
                return (_loc4);
            };
        } // end if
        if (_loc15.getElementsByReferencedName == undefined)
        {
            _loc15.getElementsByReferencedName = function (nameValue, qname)
            {
                var _loc6 = new Array();
                var _loc12 = attributes.name;
                if (_loc12 == nameValue)
                {
                    var _loc10 = false;
                    if (qname != undefined)
                    {
                        var _loc11 = this.getQName();
                        if (_loc11.namespaceURI == qname.namespaceURI && _loc11.localPart == qname.localPart)
                        {
                            _loc10 = true;
                        } // end if
                    }
                    else
                    {
                        _loc10 = true;
                    } // end else if
                    if (_loc10)
                    {
                        _loc6.push(this);
                    } // end if
                }
                else
                {
                    var _loc8 = childNodes.length;
                    for (var _loc4 = 0; _loc4 < _loc8; ++_loc4)
                    {
                        var _loc3 = childNodes[_loc4].getElementsByReferencedName(nameValue, qname);
                        var _loc5 = _loc3.length;
                        for (var _loc2 = 0; _loc2 < _loc5; ++_loc2)
                        {
                            _loc6.push(_loc3[_loc2]);
                        } // end of for
                    } // end of for
                } // end else if
                return (_loc6);
            };
        } // end if
        if (_loc15.getAttributeByQName == undefined)
        {
            _loc15.getAttributeByQName = function (qn)
            {
                for (var _loc8 in attributes)
                {
                    var _loc5 = "";
                    var _loc2 = _loc8;
                    var _loc3 = _loc8.indexOf(":");
                    if (_loc3 != -1)
                    {
                        _loc5 = _loc8.substring(0, _loc3);
                        _loc2 = _loc8.substring(_loc3 + 1);
                    } // end if
                    var _loc4 = this.getNamespaceForPrefix(_loc5);
                    var _loc7 = new mx.services.QName(_loc4, _loc2);
                    if (_loc2 == qn.localPart && _loc4 == qn.namespaceURI)
                    {
                        return (attributes[_loc8]);
                    } // end if
                } // end of for...in
            };
        } // end if
        if (_loc15.getQNameFromString == undefined)
        {
            _loc15.getQNameFromString = function (prefixedName, useDefault)
            {
                var _loc3 = prefixedName.indexOf(":");
                var _loc4 = "";
                if (_loc3 == -1 && !useDefault)
                {
                    return (new mx.services.QName(prefixedName));
                }
                else
                {
                    _loc4 = prefixedName.substring(0, _loc3);
                    prefixedName = prefixedName.substring(_loc3 + 1);
                } // end else if
                return (new mx.services.QName(prefixedName, this.getNamespaceForPrefix(_loc4)));
            };
        } // end if
        if (_loc15.registerNamespace == undefined)
        {
            _loc15.registerNamespace = function (prefix, namespaceURI)
            {
                if (mappings == undefined)
                {
                    this.loadNSMappings();
                } // end if
                if (prefix == "")
                {
                    prefix = "<>defaultNamespace<>";
                } // end if
                if (mappings[prefix] == undefined)
                {
                    mappings[prefix] = namespaceURI;
                } // end if
            };
        } // end if
        if (_loc15.unregisterNamespace == undefined)
        {
            _loc15.unregisterNamespace = function (prefix)
            {
                if (mappings != undefined)
                {
                    if (prefix == "")
                    {
                        prefix = "<>defaultNamespace<>";
                    } // end if
                    mappings[prefix] = undefined;
                } // end if
            };
        } // end if
        _loc15 = XML.prototype;
        _loc15.nscount = 0;
        _loc15.getElementsByQName = function (qname)
        {
            return (firstChild.getElementsByQName(qname));
        };
        _loc15.getElementsByReferencedName = function (tname, qname)
        {
            var _loc2 = tname.indexOf(":");
            var _loc3 = _loc2 != -1 ? (tname.substring(_loc2 + 1)) : (tname);
            return (firstChild.getElementsByReferencedName(_loc3, qname));
        };
        _loc15.getElementsByLocalName = function (lname)
        {
            return (firstChild.getElementsByLocalName(lname));
        };
    } // End of the function
    static var alreadySetup = false;
    static var _doc = new XML();
} // End of Class
