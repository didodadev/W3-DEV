<cfif isdefined("attributes.is_submitted")>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfquery name="get_fuel_password_search" datasource="#dsn#">
	SELECT
		COMPANY.FULLNAME,
		ASSET_P_FUEL_PASSWORD.PASSWORD_ID,
		ASSET_P_FUEL_PASSWORD.BRANCH_ID,
		ASSET_P_FUEL_PASSWORD.COMPANY_ID,
		ASSET_P_FUEL_PASSWORD.STATUS,
		ASSET_P_FUEL_PASSWORD.START_DATE,
		ASSET_P_FUEL_PASSWORD.FINISH_DATE,
		ZONE.ZONE_NAME,
		BRANCH.BRANCH_NAME,
		CARD_NO
	FROM
		ASSET_P_FUEL_PASSWORD,
		COMPANY,
		BRANCH,
		ZONE
	WHERE
		ASSET_P_FUEL_PASSWORD.PASSWORD_ID IS NOT NULL
	<cfif isdefined("attributes.branch_id") and len(attributes.branch)>
		AND BRANCH.BRANCH_ID = #attributes.branch_id#
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_name)>
		AND ASSET_P_FUEL_PASSWORD.COMPANY_ID = #attributes.company_id#
	</cfif>
	<cfif isdefined("attributes.status") and (attributes.status eq 1)> AND ASSET_P_FUEL_PASSWORD.STATUS = 1 
		<cfelseif isdefined("attributes.status") and (attributes.status eq 0)> AND ASSET_P_FUEL_PASSWORD.STATUS= 0 
	</cfif>
	<cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND ASSET_P_FUEL_PASSWORD.START_DATE >= #attributes.start_date#</cfif>
	<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND ASSET_P_FUEL_PASSWORD.FINISH_DATE <= #attributes.finish_date#</cfif>
		AND ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID
		<!--- Sadece yetkili olunan şubeler gözüksün. Onur P. --->
		AND ASSET_P_FUEL_PASSWORD.BRANCH_ID IN 
			 					(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		AND ASSET_P_FUEL_PASSWORD.BRANCH_ID = BRANCH.BRANCH_ID
		AND BRANCH.ZONE_ID = ZONE.ZONE_ID
	ORDER BY
		PASSWORD_ID DESC
</cfquery>
</cfif>
