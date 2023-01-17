<cfcomponent>
    <cfproperty name="structName" type="string">
    <cfproperty name="data" type="any">

    <cfproperty name="tableName" type="string">
    <cfproperty name="fieldNames" type="string">
    <cfproperty name="wheres" type="string">

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
                    return elm.DBField.table;
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
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.helper");
                current = helper.getStruct(this.structName, this.data);

                fields = arrayFilter(current.ListOfSummaries, function(elm) {
                    return elm.DBField.value neq "";
                });
                fields = arrayMap(current.ListOfSummaries, function(elm) {
                    fieldName = helper.schemeToDSN(elm.DBField.scheme) & elm.DBField.table & "." & elm.DBField.field;
                    sqltype = helper.toSqlType(elm.dataType);
                    return fieldName & " = " & helper.formatString("<c" & 'fqueryparam cfsqltype="%s" value="##%s##">', [sqltype, elm.label]);
                });
                this.fieldNames = arrayToList(fields, ", ");
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setWheres" access="public" returntype="any">
        <cfargument name="where" type="string" default="">
        <cfscript>
            if (len(arguments.where))
            {
                this.wheres = arguments.where;
            }
            else
            {
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.helper");
                current = helper.getStruct(this.structName, this.data);

                relationalStructName = listfirst(current.relation, ".");
                relationalStructLabel = listlast(current.relation, ".");
                relationalStruct = helper.getStruct(relationalStructName, this.data);
                
                relationIndex = arrayFind(relationalStruct.ListOfElements, function(elm) {
                    return elm.label eq listlast(current.relation, ".");
                });
                relationalDBField = relationalStruct.ListOfElements[relationIndex].devDBField;

                this.wheres = " WHERE " & relationalDBField.field & " = " & helper.formatString("<c" & 'fqueryparam cfsqltype="%s" value="##arguments.%s##">', [helper.toSqlType(relationalDBField.fieldType), relationalStructLabel]);
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.helper");
            return helper.formatString("UPDATE %s SET %s %s", [this.tableName, this.fieldNames, this.wheres]);
        </cfscript>
    </cffunction>

</cfcomponent>