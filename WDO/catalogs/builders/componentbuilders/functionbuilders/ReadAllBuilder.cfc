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
                return elm.devList eq 1;
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

                this.readFormat = "<c" & 'ffunction name="' & currentName & 'list" access="public" returntype="any">' & helper.crlf() & '%s' & helper.crlf() & '<cfreturn commonquery>' & helper.crlf() & helper.tab() & '</cffunction>';
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
                elements = helper.getElements("devSearch", current.ListOfElements);

                argarr = arrayMap(elements, function(elm) {
                    if (isDefined("arguments.elm.filterAsRange") && arguments.elm.filterAsRange eq 1) {
                        return helper.tab() & "<c" & 'fargument name="' & elm.label & '_min" type="any">' & helper.crlf() & helper.tab() & "<c" & 'fargument name="' & elm.label & '_max" type="any">';
                    } else {
                        return helper.tab() & "<c" & 'fargument name="' & elm.label & '" type="any">';
                    }
                });
                arrayAppend(argarr, helper.tab() & '<c' & 'fargument name="keywordids">');

                props = helper.getProperties( "isList", current.ListOfProperties, 1 );
                pargarr = arrayMap(props, function(elm) {
                    return helper.tab() & "<c" & 'fargument name="' & elm.label & '" type="any">';
                });

                arrayAppend( argarr, pargarr, 1 );

                this.argumentList = arrayToList(argarr, helper.crlf()) & helper.crlf();
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
                conds = arrayFilter(current.ListOfConditions, function (elm) {
                    return (elm.isList eq 1);
                });
                
                condarr = [];
                for (cond in conds) 
                {
                    if (cond.right.value neq "" and cond.right.type neq "DB")
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
            querybuilder = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.SelectBuilder").init(this.structName, this.data);
            querybuilder
                .setTable()
                .setFields()
                .setWheres()
                .setGroupBy()
            ;

            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            current = helper.getStruct(this.structName, this.data);
            conds = arrayFind(current.ListOfConditions, function(elm) {
                return (elm.isList eq 1) and elm.type eq "Expression";
            });

            if (conds gt 0) {
                querybuilder.setConditions();
            } else {
                reducedConds = arrayReduce( current.ListOfProperties, function( acc, val ) {
                    acc = acc?:[];
                    for (c in val.ListOfConditions) {
                        arrayAppend(acc, c);
                    }
                    return acc;
                }, []);
                if (isDefined("reducedConds")) {
                    conds = arrayFind( reducedConds, function(elm) {
                        return (elm.isList eq 1) and elm.type eq "Expression";
                    });
                    if (conds gt 0) {
                        querybuilder.setConditions();
                    }
                }
            }

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
            result = helper.formatString(this.readFormat, [body]) & helper.crlf();
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>