<cfcomponent>

    <cfproperty name="structName" type="string" setter="true">
    <cfproperty name="data" type="any" setter="true">
    <cfproperty name="selectFormat" type="string" setter="true">
    
    <cfproperty name="tableNames" type="string" setter="true">
    <cfproperty name="fieldNames" type="string" setter="true">
    <cfproperty name="whereNames" type="string" setter="true">
    <cfproperty name="conditionStatement" type="string" setter="true">

    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfset this.structName = arguments.structName>
        <cfset this.data = arguments.data>
        <cfset this.selectFormat = "SELECT %s FROM %s %s">
        <cfset this.whereNames = "">
        <cfset this.conditionStatement = "">
        <cfreturn this>
    </cffunction>

    <cffunction name="setTable" access="public" returntype="any">
        <cfargument name="tableNames" type="string" default="">
        <cfscript>
            if ( len( arguments.tableNames ) ) 
            {
                this.tableNames = arguments.tableNames;
            }
            else 
            {
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct( this.structName, this.data );
                elements = helper.getElements( "devDash", current.ListOfElements );

                distinctTable = helper.findTables( elements );

                this.tableNames = arrayToList( distinctTable, ", " );
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setFields" access="public" returntype="any">
        <cfargument name="fields" type="string" default="">
        <cfscript>
            if ( len( fields ) )
            {
                this.fieldNames = arguments.fields;
            }
            else 
            {
                helper = CreateObject( "component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper" );
                current = helper.getStruct( this.structName, this.data );
                elements = helper.getElements( "devDash", current.ListOfElements );

                fieldNames = arrayMap( elements, function( elm ) {
                    return helper.schemeTODSN( elm.devDBField.scheme ) & "." & elm.devDBField.table & "." & elm.devDBField.field & " AS " & elm.label;
                });

                this.fieldNames = arrayToList( fieldNames, ", " );
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setWheres" access="public" returntype="any">
        <cfargument name="where" type="string" default="">
        <cfscript>
            if ( len( where ) )
            {
                this.whereNames = arguments.where;
            }
            else
            {
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");

                this.whereNames = " WHERE 1=1 ";
                this.whereNames = this.whereNames & helper.crlf() & '<c' & 'fif isDefined("arguments.dashparams")>'; 
                this.whereNames = this.whereNames & helper.crlf() & '<c' & 'floop array="##arguments.dashparams##" item="dashitem">';
                this.whereNames = this.whereNames & helper.crlf() & '<c' & 'fif len(dashitem.label)>';
                this.whereNames = this.whereNames & helper.crlf() & " AND ##dashitem.dbField## ##super.equalityToSql(dashitem.equality)## <cfqueryparam cfsqltype='##super.toSqlType(dashitem.dataType)##' value='##dashitem.label##'>";
                this.whereNames = this.whereNames & helper.crlf() & '</cfif>';
                this.whereNames = this.whereNames & helper.crlf() & '</cfloop>';
                this.whereNames = this.whereNames & helper.crlf() & '</cfif>';

                /*
                current = helper.getStruct( this.structName, this.data );
                elements = helper.getElements( "devDash", current.ListOfElements );

                whereNames = arrayMap( elements, function( elm ) {
                    fieldName = helper.schemeTODSN( elm.devDBField.scheme ) & "." & elm.devDBField.table & "." & elm.devDBField.field;
                    sqltype = helper.toSqlType( elm.dataType );
                    equaltype = helper.toEqualSign( elm.dataType );
                    sqlparam = helper.formatString( '<cfqueryparam cfsqltype="%s" value="%s">', [ sqltype, helper.formatString( asEqualFormat( elm.dataType ), ["arguments." & elm.label] ) ] );

                    whereCode = fieldName & " " & helper.formatString( equaltype, [ sqlparam ] );
                    whereCode = helper.crlf() & '<cfif isDefined("arguments.' & elm.label & '") and len(arguments.' & elm.label & ')>' & helper.crlf() & whereCode & helper.crlf() & '<cfelse> 1=1 </cfif>';

                    return whereCode;
                });
                if ( arrayLen( whereNames ) > 0 )
                {
                    this.whereNames = " WHERE (" & arrayToList( whereNames, " AND " ) & ") ";
                }
                else
                {
                    this.whereNames = "";
                }
                */
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
            return helper.formatString( this.selectFormat, [ this.fieldNames, this.tableNames, this.whereNames ] ) & helper.crlf();
        </cfscript>
    </cffunction>

    <!--- local helpers --->

    <cffunction name="asEqualFormat" access="private" returntype="string">
        <cfargument name="type" type="string">
        <cfscript>
            result = "";
            switch (type) {
                case "Numeric":
                case "Date":
                case "Money":
                    result = "##%s##";
                    break;
                default:
                    result = "%%##%s##%%";
                    break;
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>