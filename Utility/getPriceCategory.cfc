<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan		
Analys Date : 26/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility Fiyat Listelerini getirir.
----------------------------------------------------------------------->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>    
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="pcat_id" type="numeric" default="" required="no">
        <cfargument name="xml_related_position_cat" type="numeric" default="0" required="no">
            <cfquery name="get" datasource="#dsn3#">
                SELECT 
                     * 
                FROM 
                    PRICE_CAT
                        <cfif isDefined("arguments.xml_related_position_cat") and arguments.xml_related_position_cat eq 1>
                            OUTER APPLY
                            (
                                SELECT item FROM #dsn#.[fnSplit](PRICE_CAT.POSITION_CAT,',')
                            ) AS XXX
                            JOIN #dsn#.EMPLOYEE_POSITIONS  EP
                                ON EP.POSITION_CAT_ID = XXX.item
                        </cfif>
                WHERE
                    PRICE_CATID IS NOT NULL AND
                    PRICE_CAT_STATUS = 1
                    <cfif session.ep.isBranchAuthorization >
                        AND BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
                    </cfif>
                    <cfif isDefined("arguments.pcat_id") and len(arguments.pcat_id) and arguments.pcat_id neq 0>
                        AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pcat_id#">
                    </cfif>
                    <!--- Pozisyon tipine gore yetki veriliyor  --->
                    <cfif isDefined("xml_related_position_cat") and xml_related_position_cat eq 1>
                        AND EP.POSITION_CODE = #session.ep.position_code#
                    </cfif>
                ORDER BY
                    PRICE_CAT
            </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>