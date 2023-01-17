<!--- Query builder common helper --->
<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = dsn & "_product">
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>

    <!--- Find struct in domain model by struct name --->
    <cffunction name="getStruct" access="public" returntype="struct">
        <cfargument name="structName" type="string"><!--- Working struct name --->
        <cfargument name="data" type="any"><!--- The domain model --->
        <cfscript>
            current = {};
            for (stc in data)
            {
                if (stc.name eq structName) 
                {
                    current = stc;
                    break;
                }
            }
        </cfscript>
        <cfreturn current>
    </cffunction>

    <!--- Get element with event flags --->
    <cffunction name="getElements" access="public" returntype="array">
        <cfargument name="flag" type="string"><!--- event flag name (isAdd, isUpdate etc) --->
        <cfargument name="data" type="any"><!--- Working struct elements --->
        <cfscript>
            elements = arrayFilter(data, function(item) {
                return item[flag] eq 1 and item.devDBField.value neq "";
            });
        </cfscript>
        <cfreturn elements>
    </cffunction>

    <!--- Disticate an array --->
    <cffunction name="distinctArray" access="public" returntype="array">
        <cfargument name="data" type="array">
        <cfscript>
            var output = arrayNew(1);
		    output.addAll(createObject("java", "java.util.HashSet").init(arguments.data));
		    return output;
        </cfscript>
    </cffunction>

    <!--- Find distict singular table names --->
    <cffunction name="findTables" access="public" returntype="array">
        <cfargument name="data" type="array">
        <cfscript>
            allTables = arrayMap(data, function(elm) {
                return schemeToDsn(elm.devDBField.scheme) & "." & elm.devDBField.table & " " & elm.devDBField.alias;
            });
            distinctTable = distinctArray(allTables);
        </cfscript>
        <cfreturn distinctTable>
    </cffunction>

    <cffunction name="findTablesWithoutAlias" access="public" returntype="array">
        <cfargument name="data" type="array">
        <cfscript>
            allTables = arrayMap(data, function(elm) {
                return schemeToDsn(elm.devDBField.scheme) & "." & elm.devDBField.table;
            });
            distinctTable = distinctArray(allTables);
        </cfscript>
        <cfreturn distinctTable>
    </cffunction>

    <!--- Find distict singular alias --->
    <cffunction name="findAliases" access="public" returntype="array">
        <cfargument name="data" type="array">
        <cfscript>
            allAlias = arrayMap(data, function(elm) {
                return elm.devDBField.alias;
            });
        </cfscript>
        <cfreturn distinctAlias>
    </cffunction>

    <!--- Check given table has any key --->
    <cffunction name="tableKeyExists" access="public" returntype="boolean">
        <cfargument name="data" type="array">
        <cfargument name="struct" type="string">
        <cfargument name="tableName" type="string">
        <cfscript>
            currentStruct = getStruct(arguments.struct, arguments.data);
            filteredElements = arrayFilter(currentStruct.listOfElements, function (elm) {
                return elm.devDBField.value neq "" && elm.devDBField.table eq listLast( tableName, '.' )
                    && elm.isKey eq 1;
            });
            return arrayLen(filteredElements) > 0;
        </cfscript>
    </cffunction>

    <!--- Get conditions by table name and event type --->
    <cffunction name="findConditionByTableName" access="public" returntype="array">
        <cfargument name="data" type="array">
        <cfargument name="struct" type="string">
        <cfargument name="tableName" type="string">
        <cfargument name="event" type="string">
        <cfscript>
            currentStruct = getStruct(struct, data);
            return arrayFilter(currentStruct.listOfConditions, function (elm) {
                return elm.type eq "Expression" 
                && (
                    (elm.left.value neq "" 
                    && elm.left.type eq "db" 
                    && elm.left.table eq tableName 
                    && elm.right.value neq "" 
                    && elm.right.type eq "db" 
                    && elm.right.table neq tableName) 
                    || 
                    (elm.right.value neq "" 
                    && elm.right.type eq "db" 
                    && elm.right.table eq tableName 
                    && elm.left.value neq "" 
                    && elm.left.type eq "db" 
                    && elm.left.table neq tableName)
                    );
            });
        </cfscript>
    </cffunction>

    <!--- Check data table contains the field by utility --->
    <cffunction name="fieldExists" access="public" returntype="boolean">
        <cfargument name="scheme" type="string">
        <cfargument name="table" type="string">
        <cfargument name="column" type="string">
        <cfscript>
            databaseInfo = createObject("component", "utility.databaseinfo");
            infoQuery = databaseInfo.ColumnInfo(scheme, table, column);
            return infoQuery.recordcount > 0;
        </cfscript>
    </cffunction>

    <!--- String formatting with java --->
    <cffunction name="formatString" access="public" returntype="string">
        <cfargument name="format" type="string"><!--- Java string formatting expression --->
        <cfargument name="data" type="array"><!--- array of parameter values --->
        <cfscript>
            jString = createObject("java", "java.lang.String");
            return jString.format(format, data);
        </cfscript>
    </cffunction>

    <!--- sql data type to cf query param type --->
    <cffunction name="toSqlType" access="public" returntype="string">
        <cfargument name="type" type="string">
        <cfscript>
        result = "";
        switch (type) {
            case "int":
            case "Numeric":
                result = "CF_SQL_INTEGER";
                break;
            case "datetime":
            case "Date":
                result = "CF_SQL_DATE";
                break;
            case "float":
            case "Money":
                result = "CF_SQL_FLOAT";
                break;
            case "decimal":
                result = "CF_SQL_DECIMAL";
                break;
            case "bit":
                result = "CF_SQL_BIT";
            default:
                result = "CF_SQL_NVARCHAR";
                break;
        }
        </cfscript>
        <cfreturn result>
    </cffunction>

    <!--- Equal format from data type --->
    <cffunction name="toEqualSign" access="public" returntype="string">
        <cfargument name="type" type="string">
        <cfscript>
        result = "";
        switch (type) {
            case "Numeric":
            case "Date":
            case "Money":
                result = " = %s";
                break;
            default:
                result = " LIKE %s ";
                break;
        }
        </cfscript>
        <cfreturn result>
    </cffunction>

    <!--- Scheme to DSN names --->
    <cffunction name="schemeToDSN" access="public" returntype="string">
        <cfargument name="scheme" type="string">
        <cfscript>
            var dsns = {};
            dsns['#dsn#'] = '##dsn##';
            dsns['#dsn1#'] = '##dsn1##';
            dsns['#dsn2#'] = '##dsn2##';
            dsns['#dsn3#'] = '##dsn3##';
            dsnval = dsns[scheme];
        </cfscript>
        <cfreturn dsnval>
    </cffunction>

    <!--- Get condition value with formatter --->
    <cffunction name="condValue" access="public" returntype="string">
        <cfargument name="cond" type="struct">
        <cfargument name="comp" type="string">
        <cfargument name="otherfield" type="struct">
        <cfargument name="side" type="string">
        <cfscript>
            result = "";
            formatstr = "";
            subjectstr = "";
            if (cond.type eq "DB")
            {
                conditionFormatter = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.plugins.conditions.dbformatter");
                subjectstr = cond.alias & "." & cond.field;
            }
            else
            {
                conditionFormatter = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.plugins.conditions.paramformatter");
                subjectstr = cond.name;
            }
            formatStr = conditionFormatter.conditionFormatter(cond, comp, otherfield, side);
            result = result & " " & formatString(formatstr, [subjectstr]);
        </cfscript>
        <cfreturn result>
    </cffunction>

    <!--- Comparison to SQL comparison sign --->
    <cffunction name="comparisonToSign" access="public" returntype="string">
        <cfargument name="comp" type="string">
        <cfscript>
            result = "";
            switch (comp) {
                case "CONTAINS":
                case "START WITH":
                case "END WITH":
                    result = "LIKE";
                    break;
                case "NOT CONTAINS":
                    result = "NOT LIKE";
                    break;
                default:
                    result = comp;
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

    <!--- Get CRLF is java line sperator --->
    <cffunction name="crlf" access="public" returntype="string">
        <cfreturn CreateObject("java", "java.lang.System").getProperty("line.separator")>
    </cffunction>
    <!--- Get Tab is five space --->
    <cffunction name="tab" access="public" returntype="string">
        <cfreturn "    ">
    </cffunction>
</cfcomponent>