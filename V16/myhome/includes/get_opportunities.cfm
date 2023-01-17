<cfinclude template="../../member/query/get_ims_control.cfm">
<cfif not isdefined("attributes.to_day") or not len(attributes.to_day)>
	<cfset attributes.to_day = now()>
</cfif>
<cfquery name="GET_OPPORTUNITIES" datasource="#dsn3#">
	SELECT
		CONSUMER_ID,
		PARTNER_ID,
		OPP_HEAD,
		OPP_DATE,
		PROBABILITY,
		INCOME,
		SALES_EMP_ID,
		SALES_PARTNER_ID,
		OPP_ID
	FROM
		OPPORTUNITIES
	WHERE
		OPP_STATUS = 1 AND
		OPP_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.to_day)#"> AND
		OPP_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-1,attributes.to_day)#">
        <!---Satış Bölgelerine Göre Fırsatlar Alanı--->
		<cfif session.ep.our_company_info.sales_zone_followup eq 1>
            AND
                (
                ( CONSUMER_ID IS NULL AND OPPORTUNITIES.COMPANY_ID IS NULL ) 
                    OR (COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#) )
                    OR (CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#) )
                )
        </cfif>	
		<cfif session.ep.their_records_only eq 1>
			AND SALES_EMP_ID = #session.ep.userid#
		</cfif>
        <!---Satış Bölgelerine Göre Fırsatlar Alanı--->
	ORDER BY
		OPP_DATE DESC
</cfquery>

