
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn3_alias = "#dsn3#">
    <cffunction name="get_asset_server" access="public" returntype="query">
        <cfargument name="assetp_cat_ids" default="0"  hint="Varlık Tipi Id">
        <cfargument name="ready_sale_subs" default="0"  hint="Süreç / Aşama Id">
		<cfquery name="get_asset_server" datasource="#dsn#">
        WITH T1 AS( SELECT  DISTINCT SUBSCRIPTION_IAM.IAM_USER_NAME,
				ASSET_P.ASSETP,
                ASSET_P.ASSETP_ID,
                ASSET_P_IT.ASSET_IP,
                ASSET_P_IT.IT_PRO,
                ASSET_P_IT.IT_MEMORY,
                ASSET_P_IT.IT_HDD,
                SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID,
                ASSET_P_IT.NUMBER_OF_USERS,
                SUBSCRIPTION_IAM.IAM_ACTIVE
			FROM 
				ASSET_P
                LEFT JOIN ASSET_P_IT ON ASSET_P_IT.ASSETP_ID = ASSET_P.ASSETP_ID
                LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT ON SUBSCRIPTION_CONTRACT.ASSETP_ID = ASSET_P.ASSETP_ID
                LEFT JOIN SUBSCRIPTION_IAM ON SUBSCRIPTION_IAM.SUBSCRIPTION_ID = SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID 
            WHERE 
                 ASSET_P.STATUS = 1
                 AND SUBSCRIPTION_CONTRACT.ASSETP_ID IS NOT NULL
                 AND SUBSCRIPTION_IAM.IAM_USER_NAME IS NOT NULL
                <cfif isDefined('arguments.assetp_cat_ids') and len(arguments.assetp_cat_ids)>
                    AND ASSET_P.ASSETP_CATID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_cat_ids#" list="true">) 
                </cfif>
                <cfif isDefined('arguments.ready_sale_subs') and len(arguments.ready_sale_subs)>
                    AND SUBSCRIPTION_CONTRACT.SUBSCRIPTION_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ready_sale_subs#" list="true">) 
                </cfif>
                )
                SELECT ASSETP,
                    ASSETP_ID,
                    ASSET_IP,
                    IT_PRO,
                    IT_MEMORY,
                    IT_HDD,
                    COUNT(DISTINCT SUBSCRIPTION_ID) AS SUM_SUBS,
                    COUNT(DISTINCT IAM_USER_NAME) AS TOTAL_USER,
                    COUNT(DISTINCT SUBSCRIPTION_ID) AS READY_SUBS,
                    NUMBER_OF_USERS,
                    SUM(CONVERT(INT, IAM_ACTIVE)) AS ACTIVE_USER
                FROM T1
                GROUP BY 
                    ASSETP,
                    ASSETP_ID,
                    ASSET_IP,
                    IT_PRO,
                    IT_MEMORY,
                    IT_HDD,
                    NUMBER_OF_USERS
        </cfquery>
		<cfreturn get_asset_server>
	</cffunction>
</cfcomponent>