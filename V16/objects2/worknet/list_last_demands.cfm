<cfquery name="get_all_demand" datasource="#dsn#" maxrows="#attributes.is_demand_count#">
	SELECT 
		*
	FROM
		WORKNET_DEMAND
	WHERE
		<cfif isdefined("attributes.is_demand_type") and attributes.is_demand_type eq 1>
			DEMAND_TYPE = 1
		<cfelseif isdefined("attributes.is_demand_type") and attributes.is_demand_type eq 2>
			DEMAND_TYPE = 2
		<cfelse>
			1 = 1
		</cfif>
		<cfif isdefined("attributes.is_demand_sector_cat") and len(attributes.is_demand_sector_cat)>
			AND SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_demand_sector_cat#">
		</cfif>
	ORDER BY
		<cfif isdefined("attributes.is_demand_order") and attributes.is_demand_order eq 0>
			RECORD_DATE 
		<cfelseif isdefined("attributes.is_demand_order") and attributes.is_demand_order eq 1>	
			TOTAL_AMOUNT
		<cfelse>
			RECORD_DATE
		</cfif>
	 DESC
</cfquery>
<table width="100%">
	<tr>
		<td>
		<cfoutput query="get_all_demand">
			<img src="../objects2/image/arrow_green.gif" align="baseline" border="0">&nbsp;
			<a href="#request.self#?fuseaction=worknet.detail_demand_worknet&demand_id=#demand_id#" class="tableyazi">
				<cfif len(demand_head) gt 25>
					#left(demand_head,25)#...
				<cfelse>
					#demand_head#
				</cfif>
			</a>
			<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<b>Üye</b>&nbsp;&nbsp;&nbsp;:&nbsp;
			<cfif len(company_id)><a href="#request.self#?fuseaction=worknet.detail_company&company_id=#company_id#" class="tableyazi"></cfif>
			<cfif len(member_name) gt 25>
				#left(member_name,25)#...
			<cfelse>
				#member_name#
			</cfif>
			<cfif len(company_id)></a></cfif>
			<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<b>Tarih</b> : &nbsp;
			#dateformat(record_date,'dd/mm/yyyy')#
			<br/>
		</cfoutput>
		</td>
	</tr>
</table>
