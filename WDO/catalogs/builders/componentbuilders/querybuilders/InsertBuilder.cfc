<cfcomponent>
    <cfproperty name="structName" type="string" setter="true">
    <cfproperty name="data" type="any" setter="true">
    <cfproperty name="insertFormat" type="string" setter="true">
    
    <cfproperty name="tableName" type="string" setter="true">
    <cfproperty name="aliasName" type="string" setter="true">
    <cfproperty name="fieldNames" type="string" setter="true">
    <cfproperty name="fieldValues" type="string" setter="true">
    <cfproperty name="tableDepends" type="array" setter="true">
    <cfproperty name="tableRelations" type="array" setter="true">
    <cfproperty name="conditionStatement" type="string" setter="true">
    
    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfset this.structName=arguments.structName>
        <cfset this.data=arguments.data>
        <cfset this.insertFormat="INSERT INTO %s(%s) VALUES(%s)">
        <cfset this.conditionStatement="%s">
        <cfset this.tableDepends = []>
        <cfset this.tableRelations = []>
        <cfset this.aliasDepends = []>
        <cfreturn this>
    </cffunction>

    <cffunction name="setTable" access="public" returntype="any">
        <cfargument name="tableName" type="string" default="">
        <cfscript>

            helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
            

            this.tableName = arguments.tableName;
            
            if (! helper.tableKeyExists( this.data, this.structName, this.tableName ) )
            {
                conditions = helper.findConditionByTableName( this.data, this.structName, listLast( this.tableName, '.' ) );
                conditionDepends = [];
                conditionRelations = [];

                for (cond in conditions) 
                {
                    if (cond.isAdd eq 1) {
                        if ( cond.left.table eq this.tableName ) {
                            arrayAppend( conditionDepends, cond.right.table );
                            arrayAppend( conditionRelations, { table: cond.right.table, field: cond.right.field, with: cond.left.field, type: cond.left.fieldType } );        
                        } else {
                            arrayAppend( conditionDepends, cond.left.table );
                            arrayAppend( conditionRelations, { table: cond.left.table, field: cond.left.field, with: cond.right.field, type: cond.right.fieldType } );
                        }
                    }
                }

                this.tableDepends = helper.distinctArray( conditionDepends );
                this.tableRelations = conditionRelations;
            }
            else
            {
                this.tableDepends = [];
                this.tableRelations = [];
                this.aliasDepends = [];
            }

        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setFields" access="public" returntype="any">
        <cfargument name="fields" type="string" default="">
        <cfscript>
            if (len(fields))
            {
                this.fieldNames = arguments.fields;
            }
            else
            {
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct( this.structName, this.data );
                elements = helper.getElements( "devAdd", current.ListOfElements );
                elements = helper.getElements( "includeAdd", elements );
                
                fieldNames = arrayMap(
                    arrayFilter(elements, function(elm) {
                        return elm.devDBField.table eq listLast( this.tableName, "." );
                    }), function(elm) {
                    return elm.devDBField.field;
                });
                relationNames = arrayMap( this.tableRelations, function(rel) { return rel.field; } );
                fieldNames.addAll( relationNames );

                this.fieldNames = arrayToList(fieldNames, ", ");

                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "RECORD_DATE"))
                {
                    this.fieldNames = this.fieldNames & ", RECORD_DATE";
                }
                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "RECORD_EMP"))
                {
                    this.fieldNames = this.fieldNames & '<cfif isDefined("this.EMP")>, RECORD_EMP</cfif>';
                }
                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "RECORD_IP"))
                {
                    this.fieldNames = this.fieldNames & ", RECORD_IP";
                }
                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "RECORD_PAR"))
                {
                    this.fieldNames = this.fieldNames & '<cfif isDefined("this.PAR")>, RECORD_PAR</cfif>';
                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setValues" access="public" returntype="any">
        <cfargument name="values" type="string" default="">
        <cfscript>
            if (len(values))
            {
                this.fieldValues = arguments.values;
            }
            else
            {
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct( this.structName, this.data );
                elements = helper.getElements( "devAdd", current.ListOfElements );
                elements = helper.getElements( "includeAdd", elements );

                fieldValues = arrayMap(
                    arrayFilter(elements, function(elm) {
                        return elm.devDBField.table eq listLast( this.tableName, "." );
                    }), function(elm) {
                    sqltype = len(elm.floatsize) and elm.dataType eq 'numeric' ? 'CF_SQL_FLOAT' : helper.toSqlType(elm.dataType);
                    isnullvalue = iif( elm.isRequired or elm.isKey, de( "no" ), de( "####iif( len( arguments." & elm.label & " ), de( 'no' ), de( 'yes' ) )####" ) );                    
                    return helper.formatString('<cfqueryparam cfsqltype="%s" value="##' & ((elm.dataType eq 'Numeric')?'replace(':'') & 'arguments.%s' & ((elm.dataType eq 'Numeric')?', ",", ".")':'') & '##" null="%s" '& ((elm.dataType eq 'Numeric' and len(elm.floatsize))?'scale="'&elm.floatsize&'"':'') &'>', [sqltype, elm.label, isnullvalue]);
                });
                fieldRelations = arrayMap( this.tableRelations, function(rel) {
                    sqltype = helper.toSqlType( rel.type );
                    return helper.formatString('<cfqueryparam cfsqltype="%s" value="##%s##">', [ sqltype, rel.table & '_' & rel.field ] );
                });
                fieldValues.addAll( fieldRelations );

                this.fieldValues = arrayToList(fieldValues, ", ");

                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "RECORD_DATE"))
                {
                    this.fieldValues = this.fieldValues & ', <cfqueryparam cfsqltype="CF_SQL_DATE" value="##this.DATE##>">';
                }
                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "RECORD_EMP"))
                {
                    this.fieldValues = this.fieldValues & '<cfif isDefined("this.EMP")>, <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="##this.EMP##"></cfif>';
                }
                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "RECORD_IP"))
                {
                    this.fieldValues = this.fieldValues & ', <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="##this.IP##">';
                }
                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "RECORD_PAR"))
                {
                    this.fieldValues = this.fieldValues & '<cfif isDefined("this.PAR")>, <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="##this.PAR##"></cfif>';
                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setConditions" access="public" returntype="any">
        <cfargument name="condition" type="string" default="">
        <cfscript>
            if (len(condition))
            {
                this.conditionStatement = condition;
            }
            else
            {
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                conditions = arrayFilter(current.ListOfConditions, function(elm) {
                    return (elm.isAdd eq 1 and elm.isSearch eq 0) or elm.type eq "left" or elm.type eq "right";
                });

                if (arrayLen(conditions) > 0 and arrayFind(conditions, function(elm) { return elm.type eq "Expression"; }))
                {
                    condstr = "";
                    condtables = [];
                    for (i=1; i <= arraylen(conditions); i++)
                    {
                        item = conditions[i];
                        if (len(item.label)) continue;
                        switch (item.type) {
                            case "left":
                                condstr = condstr & " ( ";
                                break;
                            case "right":
                                condstr = condstr & " ) ";
                                if (i < arrayLen(conditions)) condstr = condstr & " " & item.oper;
                                break;
                            default:
                                condstr = condstr & helper.condValue(item.left, item.comparison, item.right, "left") & " " & helper.comparisonToSign(item.comparison) & " " & helper.condValue(item.right, item.comparison, item.left, "right");
                                if (i < arrayLen(conditions)) condstr = condstr & " " & item.oper;
                                if (item.left.type eq "DB") arrayAppend(condtables, helper.schemeToDSN(item.left.scheme) & "." & item.left.table);
                                if (item.right.type eq "DB") arrayAppend(condtables, helper.schemeToDSN(item.right.scheme) & "." & item.right.table);
                        }
                    }
                    condstr = replace(condstr, "AND )", ")", "all");
                    condtables = helper.distinctArray(condtables);
                    this.conditionStatement = "IF EXISTS( SELECT TOP 1 * FROM " & arrayToList(condtables, ", ") & " WHERE " & condstr & ")" & helper.crlf() & " BEGIN " & helper.crlf() & "%s" & helper.crlf() & " END";
                }
                else
                {
                    this.conditionStatement = "%s";
                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            if (this.tableName eq "") return "";
            
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
            schemaName = helper.schemeToDSN( listFirst(this.tableName, ".") );
            this.tableName = schemaName & "." & listLast(this.tableName, ".");

            return helper.formatString(this.conditionStatement, [helper.formatString(this.insertFormat, [this.tableName, this.fieldNames, this.fieldValues])]);
        </cfscript>
    </cffunction>

    <!--- local helpers --->
</cfcomponent>