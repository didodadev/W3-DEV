<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
		SECTOR_CAT_ID
	FROM
		COMPANY C
	WHERE
		C.SECTOR_CAT_ID IS NOT NULL AND
		C.COMPANY_STATUS = 1
</cfquery>
<cfquery name="GET_COMPANY_SECTORS" datasource="#DSN#">
	SELECT * FROM SETUP_SECTOR_CATS WHERE IS_INTERNET = 1 ORDER BY SECTOR_CAT
</cfquery>
<table width="100%" align="center">
<cfif get_company_sectors.recordcount>
	<cfset dongu_ = 0>
	<cfoutput query="get_company_sectors">
		<cfquery name="GET_COMPANY_" dbtype="query">
			SELECT SECTOR_CAT_ID FROM get_companies WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMPANY_SECTORS.SECTOR_CAT_ID#"> 
		</cfquery>
		<cfif get_company_.recordcount>
			<cfset dongu_ = dongu_ + 1>
			<cfif dongu_ mod 3 eq 1 or dongu_ eq 1><tr></cfif>
					<td width="90" height="110">
					<cfif len(GET_COMPANY_SECTORS.sector_image)>
						<cf_get_server_file output_file="settings/#sector_image#" output_server="#server_sector_image_id#" output_type="0" image_width="90" image_height="90" alt="#getLang('main',668)#" title="#getLang('main',668)#">
					</cfif>
					<a href="#request.self#?fuseaction=objects2.list_sector&sector=#sector_cat_id#" class="tableyazi">#sector_cat# (#get_company_.recordcount#)</a>
					</td>
				<cfif currentrow eq get_company_sectors.recordcount>
					<cfloop from="1" to="#3-(dongu_ mod 3)#" index="x"><td></td><td></td></cfloop>
				</cfif>
			<cfif dongu_ mod 3 eq 0>
				</tr>
			</cfif>
		</cfif>
	</cfoutput>
</cfif>
</table>
