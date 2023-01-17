<!--- Delete query builder from a domain struct --->
<cfcomponent>
    <cfproperty name="structName" type="string" setter="true"><!--- Working struct name --->
    <cfproperty name="data" type="any" setter="true"><!--- The domain struct place holder --->
    <cfproperty name="deleteFormat" type="string" setter="true"><!--- Delete statement format string --->

    <cfproperty name="tableName" type="string" setter="true"><!--- Target table name place holder --->
    <cfproperty name="whereNames" type="string" setter="true"><!--- Target table filtering key field names --->

    <!--- Component constructor, please call first for construction and use returned object --->
    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfset this.structName=arguments.structName>
        <cfset this.data=arguments.data>
        <cfset this.deleteFormat="DELETE FROM %s %s">
        <cfset this.whereNames="">
        <cfreturn this>
    </cffunction>

    <!--- Set the table name --->
    <cffunction name="setTable" access="public" returntype="any">
        <cfargument name="tableName" type="string" default=""><!--- Auto find table name if not set --->
        <cfscript>
            if (len(arguments.tableName))
            {
                this.tableName = arguments.tableName;
            }
            else
            {
                //query helper
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                elements = helper.getElements("devUpdate", current.ListOfElements);
                wheres = helper.getElements("isKey", current.ListOfElements);
                
                //distinct singular table names
                distinctTable = helper.findTablesWithoutAlias(wheres);

                //Delete record only one table
                if (arrayLen(distinctTable) > 1) 
                {
                    cfthrow(message="Birden fazla tablo üzerinde silme işlemi yapılamaz!");
                }
                else if (arrayLen(distinctTable) eq 0) {
                    cfthrow(message="Key alanı olmayan bir tabloda silme işlemi yapılamaz!");
                }
                this.tableName = distinctTable[1];
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <!--- Set key based field names --->
    <cffunction name="setWheres" access="public" returntype="any">
        <cfargument name="wheres" type="string" default="">
        <cfscript>
            if (len(wheres))
            {
                this.whereNames = wheres;
            }
            else
            {
                //query helper
                helepr = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                elements = helepr.getElements("devUpdate", current.ListOfElements);

                if ( current.structType eq "Main" ) {

                    wheres = helper.getElements("isKey", elements);

                    //find field names then convert with queryparam
                    fieldNames = arrayMap(wheres, function(elm) {
                        fieldName = elm.devDBField.scheme & "." & elm.devDBField.table & "." & elm.devDBField.field;
                        sqltype = helper.toSqlType(elm.dataType);
                        return fieldName & " = " & helper.formatString('<cfqueryparam cfsqltype="%s" value="##arguments.%s##">', [sqltype, elm.label]);
                    });

                } else {

                    wheres = arrayFilter( elements, function( elm ) {
                        return elm.label eq replace( current.relation, '.', '' );
                    });

                    //find field names then convert with queryparam
                    fieldNames = arrayMap(wheres, function(elm) {
                        fieldName = elm.devDBField.scheme & "." & elm.devDBField.table & "." & elm.devDBField.field;
                        sqltype = helper.toSqlType(elm.dataType);
                        return fieldName & " = " & helper.formatString('<cfqueryparam cfsqltype="%s" value="##arguments.%s##">', [sqltype, listlast( current.relation, '.' )]);
                    });
                }
                
                if (arrayLen(fieldNames) gt 0) 
                {
                    this.whereNames = " WHERE (" & arrayToList(fieldNames, ", ") & ") ";
                }
                else
                {
                    cfthrow(message="Key alan(lar) olmadan tablodan kayıt silemezsiniz!");
                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <!--- Generate with builder pattern --->
    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
            //formatting query string
            return helper.formatString(this.deleteFormat, [this.tableName, this.whereNames]);
        </cfscript>
    </cffunction>

</cfcomponent>