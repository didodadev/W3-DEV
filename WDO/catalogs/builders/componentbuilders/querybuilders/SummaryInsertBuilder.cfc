<cfcomponent>
    <cfproperty name="structName" type="string">
    <cfproperty name="data" type="any">

    <cfproperty name="tableName" type="string">
    <cfproperty nane="fieldNames" type="string">

    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfset this.structName=arguments.structName>
        <cfset this.data=arguments.data>
        <cfreturn this>
    </cffunction>

    <cffunction name="setTable" access="public" returntype="any">
        <cfargument name="tableName" type="string" default="">
        <cfscript>
            if (len(arguments.tableName))
            {
                this.tableName = arguments.tableName;
            }
            else
            {
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.helper");
                current = helper.getStruct(this.structName, this.data);
                
                tables = arrayFilter(current.ListOfSummaries, function(elm) {
                    return elm.DBField.value neq "";
                });
                tables = arrayMap(tables, function(elm) {
                    return elm.DBField.tableName;
                });
                tables = helper.distinctArray(tables);

                if (arrayLen(tables) > 1)
                {
                    throw("Birden fazla tabloya toplam kaydı yapılamaz!");
                }
                else
                {
                    this.tableName = tables[1];
                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setFields" access="public" returntype="any">
        <cfargument name="fields" type="string" default="">
        <cfscript>
            if (len(arguments.fields))
            {
                this.fieldNames = arguments.fields;
            }
            else
            {
                
            }
        </cfscript>
    </cffunction>

</cfcomponent>