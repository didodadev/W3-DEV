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
        <cfset this.notfound="false">
        <cfset this.structName=arguments.structName>
        <cfset this.data=arguments.data>
        <cfset this.whereNames="">
        <cfscript>
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            current = helper.getStruct(this.structName, this.data);
            if (!arrayFind(current.ListOfElements, function(elm) {
                return elm.devUpdate eq 1;
            })) 
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
                this.readFormat = func;
            }
            else
            {
                if (this.notfound) return this;
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                currentName = current.name & "_";

                this.readFormat = "<c" & 'ffunction name="' & currentName & 'get" access="public" returntype="any">' & helper.crlf() & '%s' & helper.crlf() & helper.tab() & '<cfreturn commonquery>' & helper.crlf() & '</cffunction>' & helper.crlf();
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
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                if ( current.structType eq "Main" ) {

                    elementsUpd = helper.getElements("devUpdate", current.ListOfElements);
                    elements = helper.getElements("isKey", elementsUpd);
                    
                    argarr = arrayMap(elements, function(elm) {
                        return helper.tab() & "<c" & 'fargument name="' & elm.label & '" type="' & helper.dataTypeToCFType(elm.dataType) & '" required="yes">';
                    });
                    
                    this.argumentList = arrayToList(argarr, helper.crlf()) & helper.crlf();
                
                } else {

                    this.argumentList = helper.tab() & "<c" & 'fargument name="' & listlast( current.relation, '.' ) & '">' & helper.crlf();

                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setCodes" access="public" returntype="any">
        <cfargument name="codes" type="string" default="">
        <cfscript>
            if (len(codes)) 
            {
                this.codeList = codes;
            }
            else
            {
                if (this.notfound) return this;
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
                currrent = helper.getStruct(this.structName, this.data);
                conds = arrayFilter(current.ListOfConditions, function(elm) {
                    return elm.isUpd eq 1;
                });

                condarr = [];
                for (cond in conds) 
                {
                    if (cond.right.type neq "DB")
                    {
                        codegen = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(cond.right.type);
                        arrayAppend(condarr, helper.tab() & codegen.generate(cond.right));
                    }
                }
                this.codeList = arrayToList(condarr, helper.crlf()) & helper.crlf();
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setSqlQuery" access="public" returntype="any">
        <cfargument name="sql" type="string" default="">
        <cfscript>
            if (this.notfound) return this;
            querybuilder = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.GetBuilder").init(this.structName, this.data);
            querybuilder
                .setTable()
                .setFields()
                .setWheres();
            
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            currrent = helper.getStruct(this.structName, this.data);
            conds = arrayFind(current.ListOfConditions, function(elm) {
                return elm.isUpd eq 1;
            });
            if (conds > 0)
                querybuilder.setConditions();
            
            this.sqlquery = 
                helper.tab() & "<c" & 'fquery name="commonquery" datasource="##DSN##">' & helper.crlf() &
                helper.tab() & querybuilder.generate() & helper.crlf() & 
                helper.tab() & "</c" & 'fquery>'
                ;
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            if (this.notfound) return "";
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            body = this.argumentList & helper.crlf() & this.codeList & helper.crlf() & this.sqlquery;
            result = helper.formatString(this.readFormat, [body]);
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>