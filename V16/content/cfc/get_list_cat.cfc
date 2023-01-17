<cfcomponent> <!--- Dil ile ilişkili kategorileri getirir --->
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_cat_list_fnc" access="remote" returntype="any" returnformat="plain">
		<cfargument name="language_id" type="string" required="yes">
			<cfset myResult="">
            <cfquery name="get_language_cat" datasource="#dsn#">
                SELECT 
                    CC.CONTENTCAT,
                    CC.CONTENTCAT_ID
                FROM 
                    CONTENT_CAT CC,
                    CONTENT_CAT_COMPANY CCC 
                WHERE 
                    CC.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#"> AND
                    CCC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                    CCC.CONTENTCAT_ID = CC.CONTENTCAT_ID
            </cfquery>
			<cfset xxx = SerializeJSON(get_language_cat)>
		<cfreturn replace(xxx,'//','')>
	</cffunction>
    <cffunction name="get_chapter_list_fnc" access="remote" returntype="any" returnformat="plain"><!--- Kategori ile ilişkili bölümler gelir --->
		<cfargument name="cont_catid" type="string" required="yes">
            <cfquery name="get_language_chapter" datasource="#dsn#">
                SELECT CHAPTER_ID,CHAPTER FROM CONTENT_CHAPTER WHERE CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cont_catid#">
            </cfquery>   
		<cfreturn SerializeJSON(get_language_chapter)>
	</cffunction>
</cfcomponent>

