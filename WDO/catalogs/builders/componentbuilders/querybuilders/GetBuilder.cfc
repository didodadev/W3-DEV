<!--- Get single record (detail forms etc) query builder from a domain struct --->
<cfcomponent>
    <cfproperty name="structName" type="string" setter="true"><!--- Working struct name --->
    <cfproperty name="data" type="any" setter="true"><!--- The domain struct place holder --->
    <cfproperty name="selectFormat" type="string" setter="true"><!--- Select statement format string --->
    
    <cfproperty name="tableNames" type="string" setter="true"><!--- From table name place holder --->
    <cfproperty name="fieldNames" type="string" setter="true"><!--- From table field names place holder --->
    <cfproperty name="whereNames" type="string" setter="true"><!--- From table filtering key field names place holder --->
    <cfproperty name="conditionStatement" type="string" setter="true"><!--- Temporary condition statement --->

    <!--- Component constructor, please call first for construction and use returned object --->
    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfset this.structName=arguments.structName>
        <cfset this.data=arguments.data>
        <cfset this.selectFormat="SELECT %s FROM %s %s">
        <cfset this.whereNames="">
        <cfset this.conditionStatement="%s">
        <cfreturn this>
    </cffunction>

    <!--- Set the table name --->
    <cffunction name="setTable" access="public" returntype="any">
        <cfargument name="tableNames" type="string" default=""><!--- Auto find table names if not set --->
        <cfscript>
            if (len(arguments.tableNames))
            {
                this.tableNames = arguments.tableNames;
            }
            else
            {
                //query helper
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                elements = helper.getElements("devUpdate", current.ListOfElements);

                //get singular distinct table names
                if (arrayLen(elements)) 
                {
                    distinctTable = helper.findTables(elements);
                    this.tableNames = arrayToList(distinctTable, ", ");
                }
                else 
                {
                    this.tableNames = "";
                }
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
                current = helper.getStruct(this.structName, this.data);
                elements = helper.getElements("devUpdate", current.ListOfElements);

                //find field names and convert to element label
                fieldNames = arrayMap(elements, function(elm) {
                    if (isDefined("elm.dataCompute") eq 1 and len(elm.dataCompute) gt 0) {
                        if (elm.dataCompute neq "FORMULA")
                            this.hasComputed = 1;
                        
                            return setComputeField( elm, current.ListOfElements, helper );
                    }
                    return elm.devDBField.alias & "." & elm.devDBField.field & " AS " & elm.label;
                });
                
                this.fieldNames = arrayToList(fieldNames, ", ");
            }
        </cfscript>
        <cfreturn this>
    </cffunction>


    <!--- Set key based field names --->
    <cffunction name="setWheres" access="public" returntype="any">
        <cfargument name="where" type="string" default=""><!--- Auto find field names if not set --->
        <cfscript>
            if (len(where))
            {
                this.whereNames = arguments.where;
            }
            else
            {
                //query helper
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                listElements = helper.getElements("devUpdate", current.ListOfElements);

                if ( current.structType eq "Main" ) {

                    elements = helper.getElements("isKey", listElements);

                    //find field names then convert with queryparam
                    whereNames = arrayMap(elements, function(elm) {
                        fieldName = elm.devDBField.alias & "." & elm.devDBField.field;
                        sqltype = helper.toSqlType(elm.dataType);
                        equaltype = helper.toEqualSign(elm.dataType);
                        isnullvalue = iif( elm.isRequired or elm.isKey, de( "no" ), de( "####iif( len( arguments." & elm.label & " ), de( 'no' ), de( 'yes' ) )####" ) );
                        sqlparam = helper.formatString('<cfqueryparam cfsqltype="%s" value="%s" null="%s">', [sqltype, helper.formatString(asEqualFormat(elm.dataType), ["arguments." & elm.label]), isnullvalue ]);
                        return fieldName & " " & helper.formatString(equaltype, [sqlparam]);
                    });

                } else {

                    elements = arrayFilter( listElements, function( elm ) {
                        return elm.label eq replace( current.relation, '.', '' );
                    });

                    whereNames = arrayMap(elements, function(elm) {
                        fieldName = elm.devDBField.alias & "." & elm.devDBField.field;
                        sqltype = helper.toSqlType(elm.dataType);
                        equaltype = helper.toEqualSign(elm.dataType);
                        sqlparam = helper.formatString('<cfqueryparam cfsqltype="%s" value="%s">', [sqltype, helper.formatString(asEqualFormat(elm.dataType), ["arguments." & listlast( current.relation, '.' )])]);
                        return fieldName & " " & helper.formatString(equaltype, [sqlparam]);
                    });
                }

                
                if (arrayLen(whereNames) > 0)
                {
                    this.whereNames = " WHERE (" & arrayToList(whereNames, " and ") & ") ";
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
                    return (elm.isUpd eq 1) or elm.type eq "left" or elm.type eq "right";
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
            //escape query result if have not table names
            if (this.tableNames eq "") return "";
            helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
            //formatting query string
            return helper.formatString(this.conditionStatement, [helper.formatString(this.selectFormat, [this.fieldNames, this.tableNames, this.whereNames]), iif(len(this.whereNames), DE(" AND "), DE(" WHERE "))]);
        </cfscript>
    </cffunction>

    <cffunction name="setComputeField" access="private">
        <cfargument name="element" type="struct">
        <cfargument name="elements" type="array">
        <cfargument name="helper">
        <cfscript>
            switch (arguments.element.dataCompute) {
                case "SUM":
                    return "SUM(" & arguments.element.devDBField.alias & "." & arguments.element.devDBField.field & ") AS " & arguments.element.label;
                case "COUNT":
                    return "COUNT(" & arguments.element.devDBField.alias & "." & arguments.element.devDBField.field & ") AS " & arguments.element.label;
                case "MIN":
                    return "MIN(" & arguments.element.devDBField.alias & "." & arguments.element.devDBField.field & ") AS " & arguments.element.label;
                case "MAX":
                    return "MAX(" & arguments.element.devDBField.alias & "." & arguments.element.devDBField.field & ") AS " & arguments.element.label;
                case "CONCAT":
                    fieldlist = arguments.element.formula;
                    formulaArray = arrayNew(1);

                    for (match in listToArray(fieldlist)) {
                        foundIndex = arrayFind( arguments.elements, function( elm ) {
                            return elm.label eq match;
                        });
                        foundedElm = arguments.elements[foundIndex];
                        arrayAppend( formulaArray, foundedElm.devDBField.alias & "." & foundedElm.devDBField.field );
                    }
                    currentFormula = "CONCAT(" & arrayToList( formulaArray, ", ' ', " ) & ") AS " & arguments.element.label;
                    return currentFormula; 
                case "FORMULA":
                    currentFormula = arguments.element.formula;
                    matches = reMatch( "\[[a-zA-Z_]+\]", currentFormula );
                    for (match in matches) {
                        trimmedMatch = mid( match, 2, len(match) - 2 );
                        foundIndex = arrayFind( arguments.elements, function( elm ) {
                            return elm.label eq trimmedMatch;
                        });
                        foundedElm = arguments.elements[foundIndex];
                        currentFormula = replaceNoCase( currentFormula, match, foundedElm.devDBField.alias & "." & foundedElm.devDBField.field );
                    }
                    currentFormula = "(" & currentFormula & ") AS " & arguments.element.label;
                    return currentFormula; 
            }
        </cfscript>
    </cffunction>

    <!--- local helpers --->

    <!--- Equal formatting from element type in using key fields --->
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