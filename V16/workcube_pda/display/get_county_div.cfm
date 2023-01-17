<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"> 
	</cfquery>
</cfif>
<cfquery name="GET_COUNTY" datasource="#DSN#">
	SELECT
		SC.COUNTY_ID,
		SC.COUNTY_NAME
	FROM
		SETUP_COUNTY SC
	WHERE
		SC.COUNTY_NAME IS NOT NULL
		<cfif isdefined("attributes.city_id") and len(attributes.city_id)>AND SC.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"></cfif>
		<cfif len(attributes.keyword)>AND SC.COUNTY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
	ORDER BY
		SC.COUNTY_NAME
</cfquery>
<cf_box title="İlçeler <cfif isdefined('attributes.city_id') and len(attributes.city_id)><cfoutput>: #get_city.city_name#</cfoutput></cfif>" body_style="overflow-y:scroll;height:100px;" call_function='gizle(county_div);'>
<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
  	<tr class="color-border">
    	<td>
      		<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
				<tr class="color-header" style="height:22px;">		
					<td class="form-title" style="width:30px;"><cf_get_lang_main no='75.No'></td>
					<td class="form-title"><cf_get_lang_main no='1226.İlçe'></td>
				</tr>
				<cfif get_county.recordcount>
					<cfoutput query="get_county">		
						<tr class="color-row" style="height:20px;">
							<td style="width:30px;">#currentrow#</td>
							<td><a href="javascript://" class="tableyazi"  onClick="add_county_div('#county_id#','#county_name#')">#county_name#</a></td>
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
