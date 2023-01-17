<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME3,
		TAX_OFFICE,
		TAX_NO
	FROM
		OUR_COMPANY
	WHERE
	<cfif isDefined('session.ep.company_id')>
	    COMP_ID = #session.ep.company_id#
	<cfelseif isDefined('session.pp.company')>	
	    COMP_ID = #session.pp.company_id#
	</cfif> 
</cfquery>
