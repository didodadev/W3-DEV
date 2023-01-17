<cfcomponent>
	<cfset dsn_alias= '#application.systemParam.systemParam().dsn#'>
    
	<cffunction name="addCCNOKey" access="public" returntype="any">
		<cfargument name="ccno_key1" type="string" required="no" default="">
        <cfargument name="ccno_key2" type="string" required="no" default="">
		
        <cfif len(arguments.ccno_key1)>
            <cfquery name="Add_CCNO_Key1" datasource="#this.dsn#">
                INSERT INTO
                    #dsn_alias#.CCNO_KEY1
                (
                    CCNOKEY,
                    RECORD_IP,
                    RECORD_DATE,
                    RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ccno_key1#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    #now()#,
                    #session.ep.userid#
                )
            </cfquery>
        <cfelseif len(arguments.ccno_key2)>
            <cfquery name="Add_CCNO_Key2" datasource="#this.dsn#">
                INSERT INTO
                    #dsn_alias#.CCNO_KEY2
                (
                    CCNOKEY,
                    RECORD_IP,
                    RECORD_DATE,
                    RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ccno_key2#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    #now()#,
                    #session.ep.userid#
                )
            </cfquery>
        </cfif>
	</cffunction>

	<cffunction name="getCCNOKey1" access="public" returntype="query">
		<cfquery name="get_ccno_key1" datasource="#this.dsn#">
			SELECT * FROM #dsn_alias#.CCNO_KEY1
		</cfquery>
        
		<cfreturn get_ccno_key1>
	</cffunction>
    
    <cffunction name="getCCNOKey2" access="public" returntype="query">
		<cfquery name="get_ccno_key2" datasource="#this.dsn#">
			SELECT * FROM #dsn_alias#.CCNO_KEY2
		</cfquery>
        
		<cfreturn get_ccno_key2>
	</cffunction>
</cfcomponent>
