<cfcomponent>
    <cfproperty name="structName" type="string" setter="true">
    <cfproperty name="data" type="any" setter="true">

    <cfproperty name="getterfunctionPattern" type="any">
    <cfproperty name="codeList" type="any">
    <cfproperty name="sqlCommands" type="any">

    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">

        <cfset this.structName = arguments.structName>
        <cfset this.data = arguments.data>
        <cfset this.codeList = "">
        <cfset this.sqlCommands = "">
        <cfreturn this>
    </cffunction>

    <cffunction name="setFunctions" access="public" returntype="any">
        <cfargument name="propName" type="string">
        <cfscript>
            helper = createObject( "component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper" );            
            
            currentProperty = findProperty( arguments.propName );

            if ( ! isStruct( currentProperty ) ) {
                this.getterfunctionPattern = "";
                return this;
            }
            this.getterfunctionPattern = 
                "<c" & 'ffunction name="get_dynamic_property_' & this.structName & '_' & currentProperty.label & '" access="public" returntype="any">'
                & helper.crlf() & helper.tab() & "<c" & 'fargument name="argval">'
                & helper.crlf() & helper.tab() & '%s'
                & helper.crlf() & '</c' & "ffunction>";
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setCodes" access="public" returntype="any">
        <cfargument name="propName" type="string">
        <cfscript>
            currentProperty = findProperty( arguments.propName );

            if ( arrayLen( currentProperty.listOfConditions ) eq 0 ) {
                return this;
            }

            helper = createObject( "component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper" );

            condarr = [];
            for ( cond in currentProperty.listOfConditions ) 
            {
                if ( isDefined( "cond.right.type" ) and cond.right.type neq "DB" ) 
                {
                    codegen = createObject( "component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator" ).createGenerator( cond.right.type );
                    arrayAppend( condarr, helper.tab() & codegen.generate( cond.right ) );
                }
            }
            this.codeList = arrayToList( condarr, helper.crlf() ) & helper.crlf();
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setConditions" access="public" returntype="any">
        <cfargument name="propName" type="string">
        <cfscript>
            helper = createObject( "component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper" );  
            queryHelper = createObject( "component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper" );
            
            currentProperty = findProperty( arguments.propName );

            if ( ! isStruct( currentProperty ) ) {
                return this;
            }

            tables = findTables( currentProperty.listOfConditions );

            sqlCode = "SELECT COUNT(*) AS CNT FROM ("
                & helper.crlf() & "SELECT TOP 1 1 AS C "
                & helper.crlf() & "FROM " & arrayToList( tables, ", " )
                & helper.crlf() & "WHERE "
                ;

            if ( arrayLen( currentProperty.listOfConditions ) ) {

                condstr = "";
                prev = 0;
                for ( i = 1; i <= arrayLen( currentProperty.listOfConditions ); i++ ) 
                {
                    item = currentProperty.listOfConditions[i];
                    switch (item.type) {
                        case "left":
                            condstr = condstr & " ( ";
                            prev = 1;
                            break;
                        case "right":
                            if (prev eq 1)
                            {
                                condstr = mid( condstr, 1, len(condstr) - 3 );
                                prev = 0;
                            }
                            else
                            {
                                condstr = condstr & " ) ";
                                if ( i < arrayLen( currentProperty.listOfConditions ) ) condstr = condstr & " " & item.oper;
                            }
                            break;
                        default:
                            condstr = condstr & helper.condValue( item.left, item.comparison, item.right, "left" ) & " " & helper.comparisonToSign( item.comparison );
                            if ( isDefined( "item.right.value" ) and item.right.value eq "") 
                            {
                                sqlType = queryHelper.toSqlType( item.left.fieldType );
                                condstr = condstr & " " & helper.formatString( '<cfqueryparam cfsqltype="%s" value="##%s##">', [sqltype, 'arguments.argval'] );
                            }
                            else
                            {
                                condstr = condstr & " " & helper.condValue( item.right, item.comparison, item.left, "right" );
                            }

                            if ( i < arrayLen( currentProperty.listOfConditions ) ) condstr = condstr & " " & item.oper;
                            prev = 0;
                    }
                }
                condstr = "(" & replace( condstr, "AND )", ")", "all" ) & ")";
                this.sqlCommands = sqlCode & condstr & ") T";
            }

        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            
            helper = createObject( "component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper" );

            generatedCode = helper.crlf() & this.getterfunctionPattern;
            
            injectCode = "<c" & 'fset retval = argval>' & helper.crlf();

            if ( isDefined( "this.codeList" ) && this.codeList neq "" )
            {
                injectCode = injectCode & helper.crlf() & this.codeList;
            }

            sqlinject = "";
            if ( isDefined( "this.sqlCommands" ) && this.sqlCommands neq "" )
            {
                sqlinject = "<c" & 'fquery name="commonQuery" datasource="##dsn##">';
                sqlinject = sqlinject & helper.crlf() & this.sqlCommands;
                sqlinject = sqlinject & helper.crlf() & "</c" & 'fquery>';
                sqlinject = sqlinject & helper.crlf() & "<c" & "fset retval = commonQuery['CNT'][1]>";
            }

            injectCode = injectCode & helper.crlf() & sqlinject & helper.crlf() & '<c' & "freturn retval>" & helper.crlf() ;
            
            generatedCode = helper.formatString( generatedCode, [ injectCode ] );
            //writeDump(generatedCode);abort;

        </cfscript>
        <cfreturn generatedCode>
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
                    result = "%s";
                    break;
                default:
                    result = "%%##%s##%%";
                    break;
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="findProperty" access="private" returntype="any">
        <cfargument name="propName" type="string">
        <cfscript>
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");

            currentStruct = helper.getStruct( this.structName, this.data );
            currentProperty = arrayfilter( currentStruct.listOfProperties, function( elm ) {
                return elm.label eq propName;
            });

            if ( arrayLen( currentProperty ) ) {
                return currentProperty[1];
            } else {
                return 0;
            }
        </cfscript>
    </cffunction>

    <cffunction name="findTables" access="private" returntype="any">
        <cfargument name="conditions" type="any">
        <cfscript>
            allTables = [];
            for ( cond in conditions ) 
            {
                if ( cond.left.type eq "DB" )
                {
                    arrayAppend( alltables, cond.left.scheme & "." & cond.left.table );
                }
                if ( cond.right.value neq "" and cond.right.type eq "DB" )
                {
                    arrayAppend( allTables, cond.right.scheme & "." & cond.right.table );
                }
            }

            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");

            allTables = helper.distinctArray( allTables );
        </cfscript>
        <cfreturn allTables>
    </cffunction>

</cfcomponent>