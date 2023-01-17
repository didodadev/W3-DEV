<cfcomponent>

    <cfproperty name="structName" type="string" setter="true">
    <cfproperty name="data" type="any" setter="true">
    <cfproperty name="readFormat" type="string" setter="true">
    <cfproperty name="argumentList" type="string" setter="true">
    <cfproperty name="codeList" type="string" setter="true">
    <cfproperty name="sqlquery" type="string" setter="true">
    <cfproperty name="notfound" type="boolean" setter="true">

    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfset this.notfound = "false">
        <cfset this.structName = arguments.structName>
        <cfset this.data = arguments.data>
        <cfset this.whereNames = "">
        <cfscript>
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            current = helper.getStruct( this.structName, this.data );
            if ( !arrayFind( current.listOfElements, function( elm ) {
                return elm.devDash eq 1;
            } ) )
            {
                this.notfound = "true";
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setFunc" access="public" returntype="any">
        <cfargument name="func" type="string" default="">
        <cfscript>
            if ( len( func ) ) 
            {
                this.readFormat = func;
            }
            else 
            {
                if ( this.notfound ) return this;
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
                current = helper.getStruct( this.structName, this.data );
                currentName = current.name & "_";

                this.readFormat = "<c" & 'ffunction name="' & currentName & 'dash" access="public" returntype="any">' & helper.crlf() & '%s' & helper.crlf() & '<cfreturn commonquery>' & helper.crlf() & helper.tab() & '</cffunction>';
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setArguments" access="public" returntype="any">
        <cfargument name="args" type="string" default="">
        <cfscript>
            if (len(args))
            {
                this.argumentList = args;
            }
            else
            {
                if ( this.notfound ) return this;
                this.argumentList = '<c' & 'fargument name="dashparams">';
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setCodes" access="public" returntype="any">
        <cfargument name="codes" type="string" default="">
        <cfscript>
            if ( len( codes ) ) 
            {
                this.codeList = codes;
            }
            else 
            {
                this.codeList = "";    
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setSqlQuery" access="public" returntype="any">
        <cfargument name="sql" type="string" default="">
        <cfscript>
            if ( this.notfound ) return this;
            querybuilder = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.chartquerybuilder").init(this.structName, this.data);
            querybuilder
                .setTable()
                .setFields()
                .setWheres()
            ;
            
            this.sqlquery = helper.tab() & "<c" & 'fquery name="commonquery" datasource="##DSN##">' & helper.crlf();
            this.sqlquery = this.sqlquery & helper.tab() & querybuilder.generate() & helper.crlf();
            this.sqlquery = this.sqlquery & helper.tab() & "</c" & 'fquery>';
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            if ( this.notfound ) return "";
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            body = this.argumentList & helper.crlf() & this.codeList & helper.crlf() & this.sqlquery;
            result = helper.formatString(this.readFormat, [body]) & helper.crlf();
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>