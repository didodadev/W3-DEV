<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT
		CITY_NAME,
		CITY_ID,
		PHONE_CODE
	FROM
		SETUP_CITY
	WHERE
		CITY_NAME IS NOT NULL
		<cfif isdefined("attributes.country_id")>
			AND COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">
		</cfif>
		<cfif len(attributes.keyword)>
			AND CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
		</cfif>
	ORDER BY
		CITY_NAME
</cfquery>
<cf_box title="İller" body_style="overflow-y:scroll;height:100px;" call_function="gizle(city_div)">
	<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
  		<tr class="color-border">
			<td>
				<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
	  				<tr class="color-header" style="height:22px;">		
						<td class="form-title" style="width:30px;"><cf_get_lang_main no='75.No'></td>
						<td class="form-title"><cf_get_lang_main no='559.Şehir'></td>
	  				</tr>
	  				<cfif get_city.recordcount>
	  					<cfoutput query="get_city">		
	  						<tr class="color-row" style="height:20px;">
								<td style="width:30px;">#currentrow#</td>
								<td><a href="javascript://" class="tableyazi" onClick="add_city_div('#city_id#','#trim(city_name)#','#phone_code#');">#city_name#</a></td>
	  						</tr>		
	  					</cfoutput>
	  				<cfelse>
	  					<tr class="color-row" style="height:30px;">
							<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
	  					</tr>
	  				</cfif>
				</table>
   			</td>
  		</tr>
	</table>
</cf_box>

