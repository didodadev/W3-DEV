<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.county_id") and len(attributes.county_id)>
	<cfquery name="GET_COUNTY" datasource="#DSN#">
		SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#"> 
	</cfquery>
</cfif>

<cfquery name="GET_DISTRICT" datasource="#DSN#">
	SELECT
		SD.DISTRICT_ID,
		SD.DISTRICT_NAME
	FROM
		SETUP_DISTRICT SD
	WHERE
		SD.DISTRICT_NAME IS NOT NULL
		<cfif isdefined("attributes.county_id") and len(attributes.county_id)>AND SD.COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#"></cfif>
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>AND SD.DISTRICT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
	ORDER BY
		SD.DISTRICT_NAME
</cfquery>
<!--- <cfif isdefined("attributes.county_id") and len(attributes.county_id)><cfoutput>: #get_county.county_name#</cfoutput></cfif> --->

<cf_box title="Mahalleler" body_style="overflow-y:scroll;height:100px;">
	<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
		<tr class="color-border">
			<td>
				<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
					<tr class="color-header" style="height:22px;">		
						<td class="form-title" style="width:30px;"><cf_get_lang_main no='75.No'></td>
						<td class="form-title">Mahalle / Köy</td>
					</tr>
					<cfif get_district.recordcount>
						<cfoutput query="get_district">		
							<tr class="color-row" style="height:20px;">
								<td style="width:30px;">#currentrow#</td>
								<td><a href="javascript://" class="tableyazi"  onClick="add_district_div('#district_id#','#district_name#')">#district_name#</a></td>
							</tr>		
						</cfoutput>
					<cfelse>
						<tr class="color-row" style="height:20px;">
							<td colspan="3"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
	</table>
</cf_box>
