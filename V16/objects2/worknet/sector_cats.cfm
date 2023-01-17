<cfquery name="GET_SECTOR_CAT" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_SECTOR_CATS
	WHERE
		IS_INTERNET = 1 AND
		SECTOR_UPPER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector#">
	ORDER BY 
		SECTOR_CAT
</cfquery>

<table width="100%" align="center">
<cfif GET_SECTOR_CAT.recordcount>
	<cfset dongu_ = 0>
	<cfoutput query="GET_SECTOR_CAT">
		<cfset dongu_ = dongu_ + 1>
		<cfif dongu_ mod 2 eq 1 or dongu_ eq 1><tr></cfif>
				<ul>
					<td>
						<a href="#request.self#?fuseaction=worknet.list_company&sector=#sector_cat_id#&form_submitted=1" class="tableyazi">
							<img src="../objects2/image/sectors_part_list_icon.gif" border="0" align="absmiddle">&nbsp;&nbsp;#sector_cat#
						</a>
					</td>
				</ul>
			<cfif currentrow eq GET_SECTOR_CAT.recordcount>
				<cfloop from="1" to="#2-(dongu_ mod 2)#" index="x"><td></td><td></td></cfloop>
			</cfif>
		<cfif dongu_ mod 2 eq 0>
			</tr>
		</cfif>
	</cfoutput>
</cfif>
</table>

