<component>
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="structname" type="any">
        <cfargument name="precode" type="any">
        <cfargument name="postcode" type="any" default="">
        <cfargument name="isDataType" type="boolean" default="no">
        <cfargument name="postfix" type="any" default="">
        <cfscript>
            attrs = [];
            jsattr = createObject("component",  "WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.jsattribute").init(arguments.element, arguments.structname);
            jscode = jsattr.generate(precode);
            arrayAppend(attrs, jscode, 1);
            cssattr = createObject("component",  "WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.cssattribute").init(arguments.element, arguments.structname);
            csscode = cssattr.generate(precode);
            arrayAppend(attrs, csscode, 1);
            if (isDataType) {
                datatype = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.datatype").init(arguments.element, arguments.structname, arguments.postfix);
                dtypecode = datatype.generate(precode, postcode);
                arrayAppend(attrs, dtypecode);
            }
            formulaattr = createObject("component",  "WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.formula").init(arguments.element, arguments.structname);
            formulacode = formulaattr.generate(precode, postcode);
            arrayAppend(attrs, formulacode, 1);
            result = arrayToList(attrs, " ");
        </cfscript>
        <cfreturn result>
    </cffunction>
</component>