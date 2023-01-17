<cfsetting showdebugoutput="no">
<cfset attributes.name = trim(attributes.name)>
<cfif isDefined('attributes.surname')>
	<cfset attributes.surname = trim(attributes.surname)>
<cfelse>
	<cfset attributes.surname = ''>
</cfif>

<cfif isDefined('attributes.telcode')>
	<cfset attributes.telcode = trim(attributes.telcode)>
<cfelse>
	<cfset attributes.telcode = ''>
</cfif>

<cfif isDefined('attributes.telno')>
	<cfset attributes.telno = trim(attributes.telno)>
<cfelse>
	<cfset attributes.telno = ''>
</cfif>

<cfif isDefined('attributes.mobile_telcode')>
	<cfset attributes.mobile_telcode = trim(attributes.mobile_telcode)>
<cfelse>
	<cfset attributes.mobile_telcode = ''>
</cfif>

<cfif isDefined('attributes.mobile_telno')>
	<cfset attributes.mobile_telno = trim(attributes.mobile_telno)>
<cfelse>
	<cfset attributes.mobile_telno = ''>
</cfif>

<cfif isDefined('attributes.city_id')>
	<cfset attributes.city_id = trim(attributes.city_id)>
<cfelse>
	<cfset attributes.city_id = ''>
</cfif>

<cfif isDefined('attributes.county_id')>
	<cfset attributes.county_id = trim(attributes.county_id)>
<cfelse>
	<cfset attributes.county_id = ''>
</cfif>

<cfif isDefined('attributes.city')>
	<cfset attributes.city = trim(attributes.city)>
<cfelse>
	<cfset attributes.city = ''>
</cfif>

<cfif isDefined('attributes.county')>
	<cfset attributes.county = trim(attributes.county)>
<cfelse>
	<cfset attributes.county = ''>
</cfif>

<cfquery name="GET_CONSUMERS" datasource="#DSN#">
	SELECT
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		IMS_CODE_ID
	FROM	
		CONSUMER
	WHERE
		','+CONSUMER_NAME + ' ' + CONSUMER_SURNAME LIKE '<cfif len(attributes.name) gt 1>%</cfif>#attributes.name#%'
		<cfif len(attributes.city_id) and len(attributes.city)>
			AND 
			(
				HOME_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"> 
				<cfif len(attributes.county_id) and len(attributes.county)>
					AND HOME_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
				</cfif>
			)
		</cfif>
		<cfif len(attributes.mobile_telcode) and len(attributes.mobile_telno)>
			AND 
			(
				MOBIL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobile_telcode#"> AND
				MOBILTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobile_telno#">
			)
		</cfif>
		<cfif len(attributes.telcode) and len(attributes.telno)>
			AND 
			(
				CONSUMER_HOMETELCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.telcode#"> AND
				CONSUMER_HOMETEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.teno#">
			)
		</cfif>
</cfquery>

<cfif len(get_consumers.ims_code_id)>
	<cfquery name="GET_IMS_CODE" datasource="#DSN#">
		SELECT
			IMS_CODE_ID,
			IMS_CODE,
			IMS_CODE_NAME
		FROM
			SETUP_IMS_CODE
		WHERE
			IMS_CODE_ID = #get_consumers.ims_code_id#
	</cfquery>
</cfif>

<cf_box title="Bireysel Üyeler" body_style="overflow-y:scroll;height:100px;" call_function="gizle(control_consumer_div);">
	<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
		<tr class="color-border">
			<td>
				<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
					<tr class="color-header" style="height:22px;">		
						<td class="form-title">Ad Soyad</td>
					</tr>
					<cfif get_consumers.recordcount>
						<cfoutput query="get_consumers">		
							<tr class="color-row" style="height:20px;">
								<td>
									<cfif isDefined('attributes.type') and attributes.type eq 1>
										<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_consumer&consid=#consumer_id#" class="tableyazi">#consumer_name# #consumer_surname#</a>
									<cfelse>
										<a onClick="add_consumer_div('#consumer_name#','#consumer_surname#','#get_ims_code.ims_code_id#','#get_ims_code.ims_code#','#get_ims_code.ims_code_name#'<cfif isDefined('attributes.crntrw')>,'#attributes.crntrw#'</cfif>)" style="cursor:hand;">#consumer_name# #consumer_surname#</a>
									</cfif>
								</td>
							</tr>		
						</cfoutput>
					<cfelse>
						<tr class="color-row" style="height:20px;">
							<td colspan="4">Kayıt Bulunamadı !</td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
	</table>
</cf_box>

