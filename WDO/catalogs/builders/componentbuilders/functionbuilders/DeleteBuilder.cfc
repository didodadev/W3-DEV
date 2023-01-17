<cfcomponent>
    <cfproperty name="structName" type="string" setter="true">
    <cfproperty name="data" type="any" setter="true">
    <cfproperty name="delFormat" type="string" setter="true">
    <cfproperty name="argumentList" type="string" setter="true">
    <cfproperty name="sqlquery" type="string" setter="true">
    <cfproperty name="notfound" type="boolean" setter="true">

    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfset this.notfound="false">
        <cfset this.structName = arguments.structName>
        <cfset this.data = arguments.data>
        <cfset this.delFormat="%s">
        <cfscript>
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            current = helper.getStruct(this.structName, this.data);
            if (!arrayFind(current.ListOfElements, function(elm) {
                return elm.devUpdate eq 1;
            }) or !arrayFind(current.ListOfElements, function(elm) {
                return elm.isKey eq 1;
            }) )
            {
                this.notfound = "true";
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setFunc" access="public" returntype="any">
        <cfargument name="func" type="string" default="">
        <cfscript>
            if (len(func))
            {
                this.delFormat = func;
            }
            else
            {
                if (this.notfound) return this;
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.helper");
                current = helper.getStruct(this.structName, this.data);
                currentName = current.name & "_";

                this.delFormat = "<c" & 'ffunction name="' & currentName & 'delete" access="public" returntype="any">' & helper.crlf() & '%s' & helper.crlf() & '</cffunction>';
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
                if (this.notfound) return this;
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.helper");
                current = helper.getStruct(this.structName, this.data);
                if ( current.structType eq "Main" ) {

                    elements = helper.getElements("devUpdate", current.ListOfElements);
                    keys = helper.getElements("isKey", elements);
                    
                    argarr = arrayMap(keys, function(elm) {
                        return  helper.tab() & "<c" & 'fargument name="' & elm.label & '" type="' & helper.dataTypeToCFType(elm.dataType) & '" required="yes">';
                    });
                    
                    this.argumentList = arrayToList(argarr, helper.crlf());
                } else {
                    this.argumentList = helper.tab() & "<c" & 'fargument name="' & listlast( current.relation, '.' ) & '" required="yes">' & helper.crlf();
                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setSqlQuery" access="public" returntype="any">
        <cfargument name="sql" type="string" default="">
        <cfscript>
            if (this.notfound) return this;
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.helper");
            querybuilder = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.DeleteBuilder").init(this.structName, this.data);
            this.sqlquery = 
                helper.tab() & "<c" & 'fquery name="commonquery" datasource="##DSN##">' & helper.crlf() &
                helper.tab() & querybuilder
                    .setTable()
                    .setWheres()
                    .generate()
                & helper.crlf() & helper.tab() & "</cfquery>"
                ;
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            if (this.notfound) return "";
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            body = this.argumentList & helper.crlf() & helper.crlf() & this.sqlquery;
            result = helper.formatString(this.delFormat, [body]);
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>