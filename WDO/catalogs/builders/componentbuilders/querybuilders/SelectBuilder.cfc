<cfcomponent>
    <cfproperty name="structName" type="string" setter="true">
    <cfproperty name="data" type="any" setter="true">
    <cfproperty name="selectFormat" type="string" setter="true">
    
    <cfproperty name="tableNames" type="string" setter="true">
    <cfproperty name="fieldNames" type="string" setter="true">
    <cfproperty name="whereNames" type="string" setter="true">
    <cfproperty name="conditionStatement" type="string" setter="true">
    <cfproperty name="hasComputed" type="number" setter="true">
    <cfproperty name="gropbyStatement" type="string" setter="true">

    <cffunction name="init" access="public" returntype="any">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfset this.structName=arguments.structName>
        <cfset this.data=arguments.data>
        <cfset this.selectFormat="SELECT %s FROM %s %s">
        <cfset this.whereNames="">
        <cfset this.conditionStatement="%s">
        <cfset this.hasComputed = 0>
        <cfset this.groupbyStatement = "">
        <cfreturn this>
    </cffunction>

    <cffunction name="setTable" access="public" returntype="any">
        <cfargument name="tableNames" type="string" default="">
        <cfscript>
            if (len(arguments.tableNames))
            {
                this.tableNames = arguments.tableNames;
            }
            else
            {
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                elements = helper.getElements("devList", current.ListOfElements);

                distinctTable = helper.findTables(elements);
                
                this.tableNames = arrayToList(distinctTable, ", ");
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
                current = helper.getStruct(this.structName, this.data);
                elements = helper.getElements("devList", current.ListOfElements);

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

    <cffunction name="setWheres" access="public" returntype="any">
        <cfargument name="where" type="string" default="">
        <cfscript>
            if (len(where))
            {
                this.whereNames = arguments.where;
            }
            else
            {
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                listElements = helper.getElements("devSearch", current.ListOfElements);
                elements = arrayFilter( listElements, function( elm ) {
                    return elm.includeUpdate eq 1;
                });

                whereNames = arrayMap( elements, function(elm) {
                    
                    fieldName = elm.devDBField.alias & "." & elm.devDBField.field;
                    sqltype = helper.toSqlType(elm.dataType);
                    
                    if (isDefined("arguments.elm.filterAsRange") && elm.filterAsRange eq 1) {

                        sqlparam_min = helper.formatString( '<cfqueryparam cfsqltype="%s" value="%s">', [sqltype, helper.formatString(asEqualFormat(elm.dataType), ["arguments." & elm.label & "_min"])] );
                        sqlparam_max = helper.formatString( '<cfqueryparam cfsqltype="%s" value="%s">', [sqltype, helper.formatString(asEqualFormat(elm.dataType), ["arguments." & elm.label & "_max"])] );

                        equaltype_min = ' >= %s';
                        equaltype_max = ' <= %s';

                        wherecode_min = fieldName & " " & helper.formatString(equaltype_min, [sqlparam_min]);
                        wherecode_min = helper.crlf() & '<cfif isDefined("arguments.' & elm.label & '_min") and len(arguments.' & elm.label & '_min)>' & helper.crlf() & wherecode_min & helper.crlf() & '<cfelse> 1=1 </cfif>';

                        wherecode_max = fieldName & " " & helper.formatString(equaltype_max, [sqlparam_max]);
                        wherecode_max = helper.crlf() & '<cfif isDefined("arguments.' & elm.label & '_max") and len(arguments.' & elm.label & '_max)>' & helper.crlf() & wherecode_max & helper.crlf() & '<cfelse> 1=1 </cfif>';
                        
                        return wherecode_min & helper.crlf() & " AND " & wherecode_max;
                    }
                    else 
                    {
                            
                        
                        equaltype = helper.toEqualSign(elm.dataType);
                        sqlparam = helper.formatString('<cfqueryparam cfsqltype="%s" value="%s">', [sqltype, helper.formatString(asEqualFormat(elm.dataType), ["arguments." & elm.label])]);
                        
                        wherecode = fieldName & " " & helper.formatString(equaltype, [sqlparam]);
                        wherecode = helper.crlf() & '<cfif isDefined("arguments.' & elm.label & '") and len(arguments.' & elm.label & ')>' & helper.crlf() & wherecode & helper.crlf() & '<cfelse> 1=1 </cfif>'; 

                        return wherecode;
                    }

                });

                keyfield_index = arrayFind( current.ListOfElements, function(elm) {
                    return elm.isKey eq 1;
                });
                if (keyfield_index gt 0) {
                    keyfield = current.ListOfElements[keyfield_index];
                    keywordcode = '<c' & 'fif isDefined("arguments.keywordids")>' & helper.crlf();
                    keywordcode = keywordcode & keyfield.devDBField.alias & '.' & keyfield.devDBField.field & ' IN (##arguments.keywordids##)' & helper.crlf();
                    keywordcode = keywordcode & '<cfelse> 1=1 </cfif>' & helper.crlf();
                    arrayAppend( whereNames, keywordcode );
                }
                
                if (arrayLen(whereNames) > 0)
                {
                    this.whereNames = " WHERE (" & arrayToList(whereNames, " AND ") & ") ";
                }
                else
                {
                    this.whereNames = "";
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
                    return elm.isList eq 1 or elm.isSearch eq 1 or elm.type neq "Expression";
                });
                
                conds = arrayFilter( current.ListOfProperties, function(elm) {
                    return arrayFind( elm.ListOfConditions, function(fnd) {
                        return (elm.isList eq 1) and fnd.type eq "Expression";
                    }) gt 0;
                });

                if (arrayLen(conditions) or arrayLen(conds))
                {
                    condstr = "";
                    prev = 0;
                    for (i=1; i<=arrayLen(conditions); i++)
                    {
                        item = conditions[i];
                        switch (item.type) {
                            case "left":
                                condstr = condstr & " ( ";
                                prev = 1;
                                break;
                            case "right":
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
                                condstr = condstr & helper.condValue(item.left, item.comparison, item.right, "left") & " " & helper.comparisonToSign(item.comparison);
                                if (item.right.value eq "") 
                                {
                                    sqlType = helper.toSqlType(item.dataType);
                                    condstr = condstr & " " & helper.formatString('<cfqueryparam cfsqltype="%s" value="%s">', [sqltype, helper.formatString(asEqualFormat(item.dataType), ["arguments." & item.label])]);
                                }
                                else
                                {
                                    condstr = condstr & " " & helper.condValue(item.right, item.comparison, item.left, "right");
                                }

                                if (i < arrayLen(conditions)) condstr = condstr & " " & item.oper;
                                prev = 0;
                        }
                    }
                    pcondstr = "";
                    for (j=1; j<=arrayLen(conds); j++)
                    {
                        cond = conds[j];
                        for (i=1; i<=arrayLen(cond.ListOfConditions); i++) {
                            item = cond.ListOfConditions[i];
                            switch (item.type) {
                                case "left":
                                    pcondstr = pcondstr & " ( ";
                                    prev = 1;
                                    break;
                                case "right":
                                    if (prev eq 1)
                                    {
                                        pcondstr = mid(pcondstr, 1, len(pcondstr) - 3);
                                        prev = 0;
                                    }
                                    else
                                    {
                                        pcondstr = pcondstr & " ) ";
                                        if (i+j < (arrayLen(cond.ListOfConditions) + arrayLen(conds))) pcondstr = pcondstr & " " & item.oper;
                                    }
                                    break;
                                default:
                                    pcondstr = pcondstr & helper.crlf() & '<c' & 'fif isDefined("arguments.' & cond.label & '") and len(arguments.' & cond.label & ')>' & helper.crlf();
                                    pcondstr = pcondstr & helper.condValue(item.left, item.comparison, item.left, "left") & " " & helper.comparisonToSign(item.comparison);
                                    sqlType = helper.toSqlType(item.left.fieldType);
                                    pcondstr = pcondstr & " " & helper.formatString('<cfqueryparam cfsqltype="%s" value="%s">', [sqltype, helper.formatString(fromFieldType(item.left.fieldType), ["arguments." & cond.label])]);
                                    pcondstr = pcondstr & helper.crlf() & '<c' & 'felse> 1=1 </cfif>' & helper.crlf();
                                    if (i+j < (arrayLen(cond.ListOfConditions) + arrayLen(conds))) pcondstr = pcondstr & " " & item.oper;
                                    prev = 0;
                            }
                        }
                    }
                    if ( len(pcondstr) ) {
                        pcondstr = "(" & reReplace(pcondstr, "[AND|OR]+$", "") & ")";
                    }
                    if ( len(condstr) ) {
                        condstr = "(" & reReplace(condstr, "[AND|OR]+[\s]*\)", ")", "all") & ")";
                    }
                    if ( len(condstr) and len(pcondstr) ) condstr = condstr & " AND ";
                    condstr = condstr & pcondstr;
                    this.conditionStatement = "%s %s " & condstr;
                }
                else
                {
                    this.conditionStatement = "%s";
                }
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="setGroupBy" access="public" returntype="any">
        <cfargument name="groupby" type="string" default="">
        <cfscript>
            if (len(arguments.groupby))
            {
                this.groupbyStatement = arguments.groupby;
            }
            else if (this.hasComputed eq 1) 
            {
                helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
                current = helper.getStruct(this.structName, this.data);
                elements = helper.getElements("devList", current.ListOfElements);
                nonComputedElements = arrayFilter( elements, function( elm ) {
                    return len(elm.dataCompute) eq 0 or elm.dataCompute eq "FORMULA" or elm.dataCompute eq "CONCAT";
                });

                groupbyArray = arrayMap( nonComputedElements, function(elm) {
                    if (elm.dataCompute eq "FORMULA") {
                        result = arrayNew(1);
                        currentFormula = elm.formula;
                        matches = reMatch( "\[[a-zA-Z_]+\]", currentFormula );
                        for (match in matches) {
                            trimmedMatch = mid( match, 2, len(match) - 2 );
                            foundIndex = arrayFind( current.ListOfElements, function( elmf ) {
                                return elmf.label eq trimmedMatch;
                            });
                            foundedElm = current.ListOfElements[foundIndex];
                            arrayAppend(result, foundedElm.devDBField.alias & "." & foundedElm.devDBField.field);
                        }
                        return arrayToList(result);
                    }
                    return elm.devDBField.alias & "." & elm.devDBField.field;
                });

                this.groupbyStatement = "GROUP BY " & arrayToList(groupbyArray);
            }
        </cfscript>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            helper = CreateObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
            return helper.formatString(this.conditionStatement, [helper.formatString(this.selectFormat, [this.fieldNames, this.tableNames, this.whereNames]), iif(len(this.whereNames), DE(" AND "), DE(" WHERE "))]) & helper.crlf() & this.groupbyStatement & helper.crlf();
        </cfscript>
    </cffunction>

    <!--- local helpers --->
    <cffunction name="fromFieldType" access="private" returntype="string">
        <cfargument name="type" type="string">
        <cfscript>
            result = "";
            switch (type) {
                case "bit":
                case "tinyint":
                case "smallint":
                case "int":
                case "decimal":
                case "numeric":
                case "float":
                case "real":
                case "smallmoney":
                case "money":
                case "date":
                case "datetime":
                case "datetime2":
                case "smalldatetime":
                case "time":
                case "datetimeoffset":
                    result = "##%s##";
                    break;
                default:
                    result = "%%##%s##%%";
                    break;
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

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