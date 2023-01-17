<cfsetting showdebugoutput="no">
<cfset attributes.fullname = trim(attributes.fullname)>
<cfset attributes.telcode = trim(attributes.telcode)>
<cfset attributes.telno = trim(attributes.telno)>
<cfset attributes.name = trim(attributes.name)>
<cfset attributes.surname = trim(attributes.surname)>
<cfset attributes.mobile_telcode = trim(attributes.mobile_telcode)>
<cfset attributes.mobile_telno = trim(attributes.mobile_telno)>
<cfset attributes.city_id = trim(attributes.city_id)>
<cfset attributes.county_id = trim(attributes.county_id)>
<cfset attributes.city = trim(attributes.city)>
<cfset attributes.county = trim(attributes.county)>
<cfquery name="GET_COMP" datasource="#DSN#">
	SELECT 	
		C.COMPANY_ID,
		C.FULLNAME, 
		C.NICKNAME, 
		C.COMPANY_TELCODE, 
		C.COMPANY_TEL1,
		CP.COMPANY_PARTNER_NAME, 
		CP.COMPANY_PARTNER_SURNAME, 
		CP.PARTNER_ID
	FROM 
		COMPANY C,
		COMPANY_PARTNER CP
	WHERE 
		C.COMPANY_ID = CP.COMPANY_ID
		<!--- <cfif session.pda.admin eq 0 and session.pda.power_user eq 0><!---  and session.pda.member_view_control --->
			AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">		
			AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">  
		</cfif> --->
		<cfif len(attributes.fullname)>
			AND 
			(
				C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fullname#%"> OR 
				C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fullname#%"> 
			)
		</cfif>
		<cfif len(attributes.name) or len(attributes.surname)>
			AND CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME LIKE '<cfif len(attributes.name) gt 1>%</cfif>#attributes.name# #attributes.surname#%'			
		</cfif>
		<cfif len(attributes.telcode) and len(attributes.telno)>
			AND 
			(
				C.COMPANY_TELCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.telcode#"> AND
				C.COMPANY_TEL1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.telno#">
			)
		</cfif>
		<cfif len(attributes.mobile_telcode) and len(attributes.mobile_telno)>
			AND 
			(
				CP.MOBIL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobile_telcode#"> AND
				CP.MOBILTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobile_telno#">
			)
		</cfif>
		<cfif len(attributes.city_id) and len(attributes.city)>
			AND 
			(
				C.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"> 
				<cfif len(attributes.county_id) and len(attributes.county)>
					AND C.COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
				</cfif>
			)
		</cfif>
		AND COMPANYCAT_ID IN (SELECT COMPANYCAT_ID FROM GET_MY_COMPANYCAT WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">)
	ORDER BY
		C.FULLNAME,
		CP.COMPANY_PARTNER_NAME, 
		CP.COMPANY_PARTNER_SURNAME
</cfquery>
<cf_box title="Kurumsal Üyeler" body_style="overflow-y:scroll;height:100px;" call_function='gizle(kontrol_precompany_div);'>

<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
  	<tr class="color-border">
    	<td>
      		<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
				<tr class="color-header" style="height:22px;">		
					<td class="form-title">Şirket Unvanı</td>
					<td class="form-title">Yetkili Ad Soyad</td>
				</tr>
				<cfif get_comp.recordcount>
					<cfoutput query="get_comp">		
						<tr class="color-row" style="height:20px;">
							<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#company_id#" class="tableyazi">#fullname#</a></td>
							<td class="infotag">#company_partner_name# #company_partner_surname#</td>
						</tr>		
					</cfoutput>
				<cfelse>
					<tr class="color-row" style="height:20px;">
						<td colspan="4" class="infotag">Kayıt Bulunamadı !</td>
					</tr>
				</cfif>
	  		</table>
		</td>
  	</tr>
</table>
</cf_box>

