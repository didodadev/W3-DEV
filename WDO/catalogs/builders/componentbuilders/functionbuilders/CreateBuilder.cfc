<cfcomponent>
    <cfproperty name="structName" type="string" setter="true">
    <cfproperty name="data" type="any" setter="true">
    <cfproperty name="addFormat" type="string" setter="true">
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
        <cfset this.addFormat="%s">
        <cfset this.sqlquery = "">
        <cfscript>
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            current = helper.getStruct(this.structName, this.data);
            if (!arrayFind(current.ListOfElements, function(elm) {
                return elm.devAdd eq 1 and elm.includeAdd eq 1;
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
                this.addFormat = func;
            }
            else
            {
                if (this.notfound) return this;
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                currentName = current.name & "_";

                this.addFormat = "<c" & 'ffunction name="' & currentName & 'add" access="public" returntype="any">' & helper.crlf() & '%s' & helper.crlf() & "<c" & 'freturn result>' & helper.crlf() & '</cffunction>';
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
                current = helper.getStruct( this.structName, this.data );
                elements = helper.getElements( "devAdd", current.ListOfElements );
                elements = helper.getElements( "includeAdd", elements );

                argarr = arrayMap(elements, function(elm) {
                    return helper.tab() & "<c" & 'fargument name="' & elm.label & '" type="' & iif( elm.isRequired, de( helper.dataTypeToCFType( elm.dataType ) ), de( "any" ) ) & '" required="' & ( iif( elm.isRequired or elm.isKey, de( "yes" ), de( "no" ) ) ) & '">';
                });

                this.argumentList = arrayToList(argarr, helper.crlf());
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
                    return elm.isAdd eq 1 and elm.type eq "Expression";
                });
                condarr = [];
                for (cond in conds) 
                {
                    if (cond.right.type neq "DB")
                    {
                        codegen = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(cond.right.type);
                        arrayAppend(condarr, codegen.generate(cond.right));
                    }
                }
                this.codeList = arrayToList(condarr, helper.crlf());
                
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setSqlQuery" access="public" returntype="any">
        <cfargument name="sql" type="string" default="">
        <cfscript>
            if (this.notfound) return this;

            queryhelper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
            current = queryhelper.getStruct( this.structName, this.data );
            elements = queryhelper.getElements( "devAdd", current.ListOfElements );
            elements = queryhelper.getElements( "includeAdd", elements );
            distinctTable = helper.findTables( elements );

            querybuilder = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.InsertBuilder").init(this.structName, this.data);

            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");

            queries = [];

            for (dtable in distinctTable) {
            
                querybuilder
                    .setTable(dtable)
                    .setFields()
                    .setValues()
                ;

                plainTableName = listLast( dtable, "." );
                
                dquery = 
                    helper.tab() & "<c" & 'fquery name="' & plainTableName & '_query" datasource="##DSN##" result="' & plainTableName & '_query_result">' & helper.crlf() &
                    helper.tab() & querybuilder.generate() & helper.crlf() &
                    helper.tab() & "</c" & 'fquery>' & helper.crlf() &
                    helper.tab() & "<cfset result = " & plainTableName & "_query_result.generatedkey>"
                ;

                arrayAppend( queries, { depends: querybuilder.tableDepends, relations: querybuilder.tableRelations, query: dquery, table: listLast( dtable, "." ) } );

            }

            query_builded = [];
            while ( arrayLen(queries) > 0 ) {
                queries_size = arrayLen( queries );
                query_vector = 0;

                for ( i = 1; i <= queries_size; i++ ) {
                    qstruct = queries[ i - query_vector ];

                    if ( arrayLen( qstruct.depends ) eq 0 ) {
                        arrayAppend( query_builded, qstruct.table );
                        this.sqlquery = this.sqlquery & qstruct.query & helper.crlf();
                        arrayDelete( queries, qstruct );
                        query_vector++;
                    } else {
                        equal_depend_count = 0;
                        
                        for (depend in qstruct.depends) {
                            if ( arrayContains( query_builded, depend ) ) {
                                equal_depend_count++;
                            }
                        }
                        
                        if ( equal_depend_count eq arrayLen( qstruct.depends ) ) {
                            
                            for ( rel in qstruct.relations ) {
                                masterField = helper.masterContainsField( this.data, this.structName, rel );
                                
                                if ( masterField neq 0 ) {
                                    this.sqlquery = this.sqlquery & '<c' & 'fset ' & rel.table & "_" & rel.field & " = arguments." & masterField & ">" & helper.crlf();
                                } else {
                                    this.sqlquery = this.sqlquery & '<c' & 'fset ' & rel.table & '_' & rel.field & " = " & rel.table & '_query_result.GENERATEDKEY>' & helper.crlf();
                                }
                            }
                            
                            arrayAppend( query_builded, qstruct.table );
                            this.sqlquery = this.sqlquery & qstruct.query & helper.crlf();
                            arrayDelete( queries, qstruct );
                            query_vector++;
                        } else {
                            this.sqlquery = qstruct.query;
                            arrayDelete( queries, qstruct );
                        }
                    }
                    

                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            if (this.notfound) return "";
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.functionbuilders.Helper");
            body = this.argumentList & helper.crlf() & this.codeList & helper.crlf() & this.sqlquery;
            result = helper.formatString(this.addFormat, [body]) & helper.crlf();
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>