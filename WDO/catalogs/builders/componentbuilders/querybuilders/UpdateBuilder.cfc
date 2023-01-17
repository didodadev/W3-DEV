<!--- Update query builder from a domain struct --->
<cfcomponent>
    <cfproperty name="structName" type="string" setter="true"><!--- Working struct name --->
    <cfproperty name="data" type="any" setter="true"><!--- The domain struct place holder --->
    <cfproperty name="updateFormat" type="string" setter="true"><!--- Update statement format string --->
    
    <cfproperty name="tableName" type="string" setter="true"><!--- Target table name place holder --->
    <cfproperty name="fieldNames" type="string" setter="true"><!--- Target table field names place holder --->
    <cfproperty name="whereNames" type="string" setter="true"><!--- Target table filtering key field names place holder --->
    <cfproperty name="tableDepends" type="array" setter="true"><!--- Depended tables for sorting run --->
    <cfproperty name="tableRelations" type="array" setter="true"><!--- Table relations place holder --->
    <cfproperty name="conditionStatement" type="string" setter="true"><!--- Temporary condition statement --->

    <!--- Component constructor, please call first for construction and use returned object --->
    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfset this.structName=arguments.structName>
        <cfset this.data=arguments.data>
        <cfset this.updateFormat="UPDATE %s SET %s %s">
        <cfset this.whereNames="">
        <cfset this.tableDepends = []>
        <cfset this.tableRelations = []>
        <cfset this.conditionStatement="%s">
        <cfreturn this>
    </cffunction>

    <!--- Set the table name for finding depends --->
    <cffunction name="setTable" access="public" returntype="any">
        <cfargument name="tableName" type="string" default=""><!--- Optional table name --->
        <cfscript>
            // query helper
            helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
			
            this.tableName = arguments.tableName;
            
            if (! helper.tableKeyExists(this.data, this.structName, this.tableName))
            {
                // find conditions from struct by table name
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

                this.tableDepends = helper.distinctArray(conditionDepends);
                this.tableRelations = conditionRelations;
            }
            else
            {
                this.tableDepends = [];
                this.tableRelations = [];
            }
            
        </cfscript>
        <cfreturn this>
    </cffunction>

    <!--- Set field names --->
    <cffunction name="setFields" access="public" returntype="any">
        <cfargument name="fields" type="string" default=""><!--- Auto find field names if not set --->
        <cfscript>
            if (len(fields))
            {
                this.fieldNames = arguments.fields;
            }
            else
            {
                //query helper
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct( this.structName, this.data );
                elements = helper.getElements( "devUpdate", current.ListOfElements );
                elements = helper.getElements( "includeUpdate", elements );
                whereElements = helper.getElements( "isKey", elements );

                fieldNamesArr = [];
                for (elm in elements)
                {
                    if (arrayFind(whereElements, function (w) {
                        return w.label eq elm.label;
                    } )) continue;

                    fieldName = helper.schemeToDSN(elm.devDBField.scheme) & "." & elm.devDBField.table & "." & elm.devDBField.field;
                    sqltype = len(elm.floatsize) and elm.dataType eq 'numeric' ? 'CF_SQL_FLOAT' : helper.toSqlType(elm.dataType);
                    arrayAppend( fieldNamesArr, helper.formatString( '<cfif len( arguments.%s )>' & fieldName & ' = <cfqueryparam cfsqltype="%s" value="##' & ((elm.dataType eq 'Numeric')?'replace(':'') & 'arguments.%s' & ((elm.dataType eq 'Numeric')?', ",", ".")':'') & '##" '& ((elm.dataType eq 'Numeric' and len(elm.floatsize))?'scale="'&elm.floatsize&'"':'') &'>', [elm.label, sqltype, elm.label]) & "<cfelse>" & fieldName & " = " & fieldName & "</cfif>" & helper.crlf() );
                }
                relationNames = arrayMap( this.tableRelations, function(rel) { return rel.field; } );
                fieldNamesArr.addAll( relationNames );

                this.fieldNames = arrayToList(fieldNamesArr, ", ");

                // set the default table fields
                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "UPDATE_DATE"))
                {
                    this.fieldNames = this.fieldNames & ', <cfqueryparam cfsqltype="CF_SQL_DATE" value="##this.DATE##>">';
                }
                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "UPDATE_EMP"))
                {
                    this.fieldNames = this.fieldNames & '<cfif isDefined("this.EMP")>, <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="##this.EMP##"></cfif>';
                }
                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "UPDATE_IP"))
                {
                    this.fieldNames = this.fieldNames & ', <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="##this.IP##">';
                }
                if (helper.fieldExists(listFirst(this.tableName, "."), listLast(this.tableName, "."), "UPDATE_PAR"))
                {
                    this.fieldNames = this.fieldNames & '<cfif isDefined("this.PAR")>, <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="##this.PAR##"></cfif>';
                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <!--- Set key based field names --->
    <cffunction name="setWheres" access="public" returntype="any">
        <cfargument name="wheres" type="string" default=""><!--- Auto find field names if not set --->
        <cfscript>
            if (len(wheres))
            {
                this.whereNames = wheres;
            }
            else
            {
                //query helper
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                updElements = helper.getElements("devUpdate", current.ListOfElements);
                elements = helper.getElements("isKey", updElements);

                //find field names then convert with queryparam
                fieldNames = arrayMap(elements, function(elm) {
                    fieldName = helper.schemeToDSN(elm.devDBField.scheme) & "." & elm.devDBField.table & "." & elm.devDBField.field;
                    sqltype = helper.toSqlType(elm.dataType);
                    return fieldName & " = " & helper.formatString('<cfqueryparam cfsqltype="%s" value="##arguments.%s##">', [sqltype, elm.label]);
                });
                //merge keys to where statement
                if (arrayLen(fieldNames) > 0)
                {
                    this.whereNames = " WHERE (" & arrayToList(fieldNames, ", ") & ") ";
                }
                else
                {
                    this.whereNames = "";
                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <!--- Set conditional field names --->
    <cffunction name="setConditions" access="public" returntype="any">
        <cfargument name="condition" type="string" default=""><!--- Auto find field names if not set --->
        <cfscript>
            if (len(condition))
            {
                this.conditionStatement = condition;
            }
            else
            {
                //query helper
                helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                conditions = arrayFilter(current.ListOfConditions, function(elm) {
                    return (elm.isUpd eq 1 and elm.isSearch eq 0) or elm.type eq "left" or elm.type eq "right";
                });

                //check conditions
                if (arrayLen(conditions))
                {
                    condstr = "";
                    prev = 0;
                    for (i=1; i<=arrayLen(conditions); i++)
                    {
                        item = conditions[i];
                        switch (item.type) {
                            case "left": //left parenthesis
                                condstr = condstr & " ( ";
                                prev = 1;
                                break;
                            case "right": //right parenthesis
                                //remove last join operator (AND, OR)
                                if (prev eq 1)
                                {
                                    condstr = mid(condstr, 1, len(condstr) - 3);
                                    prev = 0;
                                }
                                else
                                {
                                    condstr = condstr & " ) ";
                                    if (i < arrayLen(conditions)) condstr = condstr & " " & item.oper;
                                }
                                break;
                            default:
                                //generate condition statement
                                condstr = condstr & helper.condValue(item.left, item.comparison, item.right, "left") & " " & helper.comparisonToSign(item.comparison) & " " & helper.condValue(item.right, item.comparison, item.left, "right");
                                if (i < arrayLen(conditions)) condstr = condstr & " " & item.oper;
                                prev = 0;
                        }
                    }
                    //clear condition string
                    condstr = "(" & replace(condstr, "AND )", ")", "all") & ")";
                    condstr = replace(condstr, "AND)", ")", "all");
                    condstr = replace(condstr, "OR )", ")", "all");
                    condstr = replace(condstr, "OR)", ")", "all");
                    //formatting condition string
                    this.conditionStatement = "%s %s " & condstr;
                }
                else
                {
                    //no have condition
                    this.conditionStatement = "%s";
                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <!--- Generate with builder pattern --->
    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            if (this.tableName eq "") return "";
            
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
            schemaName = helper.schemeToDSN( listFirst(this.tableName, ".") );
            this.tableName = schemaName & "." & listLast(this.tableName, ".");

            return helper.formatString(this.conditionStatement, [helper.formatString(this.updateFormat, [this.tableName, this.fieldNames, this.whereNames]), iif(len(this.whereNames), DE(" AND "), DE(" WHERE "))]);
        </cfscript>
    </cffunction>

</cfcomponent>