class mx.services.DataType
{
    var name, typeType, namespaceURI, qname, isAnonymous, deserializer;
    function DataType(name, typeType, xmlns, deserializer)
    {
        this.name = name;
        this.typeType = typeType == undefined ? (mx.services.DataType.OBJECT_TYPE) : (typeType);
        namespaceURI = xmlns == undefined ? (mx.services.SchemaVersion.XML_SCHEMA_URI) : (xmlns);
        qname = new mx.services.QName(this.name, namespaceURI);
        isAnonymous = false;
        this.deserializer = deserializer;
    } // End of the function
    static var NUMBER_TYPE = 0;
    static var STRING_TYPE = 1;
    static var OBJECT_TYPE = 2;
    static var DATE_TYPE = 3;
    static var BOOLEAN_TYPE = 4;
    static var XML_TYPE = 5;
    static var ARRAY_TYPE = 6;
    static var MAP_TYPE = 7;
    static var ANY_TYPE = 8;
    static var COLL_TYPE = 10;
    static var ROWSET_TYPE = 11;
    static var QBEAN_TYPE = 12;
    static var objectType = new mx.services.DataType("", mx.services.DataType.OBJECT_TYPE, "");
} // End of Class
