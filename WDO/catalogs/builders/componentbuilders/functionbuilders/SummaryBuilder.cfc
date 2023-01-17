<cfcomponent>
    <cfproperty name="structName" type="string">
    <cfproperty name="data" type="any">
    <cfproperty name="argumentList" type="string">
    <cfproperty name="sqlQuery" type="string">
    <cfproperty name="notfound" type="boolean">
    <cfproperty name="updFormat" type="string">

    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfset this.notfound="false">
        <cfset this.structName=arguments.structName>
        <cfset this.data=arguments.data>
        <cfset this.updFormat="%s">
        <cfscript>
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.helper");
            current = helper.getStruct(this.structName, this.data);
            if (current.structType eq "Main" or arrayLen(current.ListOfSummaries) eq 0)
            {
                this.notfound = 1;
            }
            else if (current.relation eq "")
            {
                this.notfound = 1;
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setFunc" access="public" returntype="any">
        <cfargument name="func" type="string" default="">
        <cfscript>
            if (len(arguments.func))
            {
                this.updFormat = arguments.func; 
            }
            else
            {
                if (this.notfound) return this;
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.helper");
                current = helper.getStruct(this.structName, this.data);
                currentName = current.name & "_";
                this.updFormat = "<c" & 'ffunction name="' & currentName & 'summary" access="public" returntype="any">' & helper.crlf() & '%s' & helper.crlf() & "</cffunction>";
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setArguments" access="public" returntype="any">
        <cfargument name="args" type="string" default="">
        <cfscript>
            if (len(arguments.args))
            {
                this.argumentList = arguments.args;
            }
            else
            {
                if (this.notfound) return this;
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.helper");
                current = helper.getStruct(this.structName, this.data);
                arglist = arrayFilter(current.ListOfSummaries, function(elm) {
                    return elm.DBField.value neq "";
                });
                arglist = arrayMap(arglist, function(elm) {
                    return "<c" & 'fargument name="' & elm.label & '" type="' & helper.dataTypeToCFType(elm.dataType) & '">';
                });
                arrayAppend(arglist, "<c" & 'fargument name="' & listlast(current.relation, ".") & '" type="numeric">');
                this.argumentList = arrayToList(arglist, helper.crlf());
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setSqlQuery" access="public" returntype="any">
        <cfargument name="sql" type="string" default="">
        <cfscript>
            if (this.notfound) return this;

            // has no any dbfield
            if (arrayFind(this.data[arrayFind(
                this.data, function(struct) {
                    return struct.name eq this.structName;
                })].listOfSummaries, function(summary) {
                    return summary.DBField.value neq "";
            }) eq 0) return this;

            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.helper");

            querybuilder = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.summarybuilder").init(this.structName, this.data);
            this.sqlQuery = "<c" & 'fquery name="commonquery" datasource="##DSN##">' & helper.crlf() & querybuilder.setTable().setFields().setWheres().generate() & helper.crlf() & "</cfquery>";
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            if (this.notfound) return "";
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            body = this.argumentList & iif(isDefined("this.sqlquery"), "helper.crlf() & this.sqlquery", DE(""));
            result = helper.formatString(this.updFormat, [body]);
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>