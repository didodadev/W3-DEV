<cffunction name="preview" access="public" returntype="any">
    <cfargument name="model" type="any">
    <cfscript>
        textgenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.compositbuilders.textgenerator");
        result = textgenerator.createComponents(deserializeJSON(arguments.model), "");
    </cfscript>
    <cfreturn result>
</cffunction>

<cffunction name="save" access="public" returntype="any">
    <cfargument name="model" type="any">
    <cftry>
        <cfquery name="wrkquery" result="wrkresult" datasource="#dsn#">
            SELECT wo.FULL_FUSEACTION, wo.HEAD, wo.DICTIONARY_ID, wf.WRK_FAMILY_ID, wf.FAMILY, ws.WRK_SOLUTION_ID, ws.SOLUTION 
            FROM WRK_OBJECTS wo
            INNER JOIN WRK_MODULE wm ON wo.MODULE_NO = wm.MODULE_NO
            INNER JOIN WRK_FAMILY wf ON wm.FAMILY_ID = wf.WRK_FAMILY_ID
            INNER JOIN WRK_SOLUTION ws ON wf.WRK_SOLUTION_ID = ws.WRK_SOLUTION_ID 
            WHERE FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.fuseact#">
        </cfquery>
        <cfif wrkresult.recordcount>
            <cfquery name="modelquery" result="modelresult" datasource="#dsn#">
                SELECT MODELJSON FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.FULL_FUSEACTION#">
            </cfquery>
            <cfif modelresult.recordcount>
                <cfquery name="modelupdatequery" datasource="#dsn#">
                    UPDATE WRK_MODEL SET MODELJSON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.model#"> WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.FULL_FUSEACTION#">
                </cfquery>
            <cfelse>
                <cfquery name="modelinsertquery" datasource="#dsn#">
                    INSERT INTO WRK_MODEL(MODEL_FUSEACTION, MODELNAME, MODELLANG, MODELJSON, MODELFAMILYID, MODELFAMILY, MODELSOLUTIONID, MODELSOLUTION) VALUES(
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.FULL_FUSEACTION#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.HEAD#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.DICTIONARY_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.model#">,
                        <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#wrkquery.WRK_FAMILY_ID#'>,
                        <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#wrkquery.FAMILY#'>,
                        <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#wrkquery.WRK_SOLUTION_ID#'>,
                        <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#wrkquery.SOLUTION#'>
                    )
                </cfquery>
            </cfif>
        </cfif>
        <cfreturn 1>
        <cfcatch>
            <cfreturn cfcatch>
        </cfcatch>
    </cftry>
</cffunction>

<cffunction name="saveandgenerate" access="public" returntype="any">
    <cfargument name="model" type="any">
    <cftry>
        <cfquery name="wrkquery" result="wrkresult" datasource="#dsn#">
            SELECT wo.FULL_FUSEACTION, wo.HEAD, wo.DICTIONARY_ID, wf.WRK_FAMILY_ID, wf.FAMILY, ws.WRK_SOLUTION_ID, ws.SOLUTION 
            FROM WRK_OBJECTS wo
            INNER JOIN WRK_MODULE wm ON wo.MODULE_NO = wm.MODULE_NO
            INNER JOIN WRK_FAMILY wf ON wm.FAMILY_ID = wf.WRK_FAMILY_ID
            INNER JOIN WRK_SOLUTION ws ON wf.WRK_SOLUTION_ID = ws.WRK_SOLUTION_ID 
            WHERE FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.fuseact#">
        </cfquery>
        <cfif wrkresult.recordcount>
            <cfscript>
                textgenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.compositbuilders.textgenerator");
                code = textgenerator.createComponents(deserializeJSON(arguments.model), "");
            </cfscript>
            <cfquery name="modelquery" result="modelresult" datasource="#dsn#">
                SELECT MODELJSON FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.FULL_FUSEACTION#">
            </cfquery>
            <cfif modelresult.recordcount>
                <cfquery name="modelupdatequery" datasource="#dsn#">
                    UPDATE WRK_MODEL SET MODELJSON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.model#">, MODELCOMPONENT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#code#"> WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.FULL_FUSEACTION#">
                </cfquery>
            <cfelse>
                <cfquery name="modelinsertquery" datasource="#dsn#">
                    INSERT INTO WRK_MODEL(MODEL_FUSEACTION, MODELNAME, MODELLANG, MODELJSON, MODELCOMPONENT, MODELFAMILYID, MODELFAMILY, MODELSOLUTIONID, MODELSOLUTION) VALUES(
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.FULL_FUSEACTION#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.HEAD#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.DICTIONARY_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.model#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#code#">,
                        <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#wrkquery.WRK_FAMILY_ID#'>,
                        <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#wrkquery.FAMILY#'>,
                        <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#wrkquery.WRK_SOLUTION_ID#'>,
                        <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#wrkquery.SOLUTION#'>
                    )
                </cfquery>
            </cfif>
        </cfif>
        <cfreturn 1>
        <cfcatch>
            <cfreturn cfcatch>
        </cfcatch>
    </cftry>
</cffunction>

<cffunction name="load" access="public" returntype="any">
    <cfargument name="fuseact" type="string">
        <cfquery name="modelquery" result="modelresult" datasource="#dsn#">
            SELECT MODELJSON FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuseact#">
        </cfquery>
        <cfif modelresult.recordcount>
            <cfreturn modelquery.MODELJSON>
        </cfif>
</cffunction>

<cffunction name="obj_uses" access="public" returntype="any">
    <cfargument name="fuseact" type="string">
    <cfquery name="wrkquery" datasource="#dsn#">
        SELECT * FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseact#'>
    </cfquery>
    <cfreturn wrkquery>
</cffunction>