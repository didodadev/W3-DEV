<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.accident_type_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfif len(attributes.form_submitted)>
<cfquery name="GET_ACCIDENTS" datasource="#dsn#">
	SELECT  
		ASSET_P.ASSETP,
		ASSET_P_ACCIDENT.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		SETUP_ACCIDENT_TYPE.ACCIDENT_TYPE_NAME,
		ASSET_P_ACCIDENT.ACCIDENT_DATE
	FROM
		ASSET_P,
		ASSET_P_ACCIDENT,
		SETUP_ACCIDENT_TYPE,
		EMPLOYEES
	WHERE 
		ASSET_P.ASSETP_ID = #attributes.assetp_id#
		AND ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID
		AND ASSET_P_ACCIDENT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
		AND ASSET_P_ACCIDENT.ACCIDENT_TYPE_ID = SETUP_ACCIDENT_TYPE.ACCIDENT_TYPE_ID
		<cfif len(attributes.employee_id) and len(attributes.employee_name)>AND ASSET_P_ACCIDENT.EMPLOYEE_ID = #attributes.employee_id#</cfif>
		<cfif len(attributes.accident_type_id)>AND ASSET_P_ACCIDENT.ACCIDENT_TYPE_ID = #attributes.accident_type_id#</cfif>	
</cfquery>
<cfelse>
<cfset GET_ACCIDENTS.recordcount = 0>
</cfif>
<cfquery name="get_accident_type" datasource="#dsn#">
	SELECT ACCIDENT_TYPE_NAME, ACCIDENT_TYPE_ID FROM SETUP_ACCIDENT_TYPE
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_ACCIDENTS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_medium_list_search title="#getLang('main',366)#">
	<cf_medium_list_search_area>
	<cfform name="search_accident" action="#request.self#?fuseaction=assetcare.popup_list_kaza_detail" method="post">
	<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<table>
			<tr>
				<td><cf_get_lang_main no='1463.Çalışanlar'></td>
				<td><input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
				<input type="text" name="employee_name" id="employee_name" style="width:135px;" maxlength="255" value="<cfoutput>#attributes.employee_name#</cfoutput>">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_accident.employee_id&field_name=search_accident.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1463.Çalışanlar'>" border="0" align="absmiddle"></a></td>
				<td>
					<cf_wrk_combo
						name="accident_type_id"
						query_name="GET_ACCIDENT_TYPE"
						value="#attributes.accident_type_id#"
						option_name="accident_type_name"
						option_value="accident_type_id"
						width="140">
				</td>
				<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
				<td><cf_wrk_search_button></td>
			</tr>
		</table>
	</cfform>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th><cf_get_lang_main no='1656.Plaka'></th>
			<th><cf_get_lang_main no='132.Sorumlu'></th>
			<th><cf_get_lang no='397.Kaza Tipi'></th>
			<th><cf_get_lang no='106.Kaza Kaydı'></th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_ACCIDENTS.recordcount>
        <cfoutput query="GET_ACCIDENTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfset sorumlu_list=''>
		<cfif len(EMPLOYEE_ID) and not listfind(sorumlu_list,EMPLOYEE_ID)>
			<cfset sorumlu_list = Listappend(sorumlu_list,EMPLOYEE_ID)>
		</cfif>
		<cfif len(sorumlu_list)>
			<cfquery name="get_sorumlu" datasource="#dsn#">
			SELECT
				EMPLOYEE_ID,
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
			FROM
				EMPLOYEES
			WHERE
				EMPLOYEES.EMPLOYEE_ID IN (#sorumlu_list#)
		</cfquery>
		</cfif>
			<tr>
				   <td>#ASSETP#</td>
				  <td><!--- #get_emp_info(employee_id,0,1)# --->
				  <cfif len(EMPLOYEE_ID)>
					<cfquery name="get_sorumlu_record" dbtype="query">
						SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM get_sorumlu WHERE EMPLOYEE_ID = #EMPLOYEE_ID#
					</cfquery>
					#get_sorumlu_record.EMPLOYEE_NAME# #get_sorumlu_record.EMPLOYEE_SURNAME#
				 </cfif>
				  </td>
				  <td>#ACCIDENT_TYPE_NAME#</td>
				  <td>#dateformat(accident_date,dateformat_style)#</td>
			</tr>
          </cfoutput>
        <cfelse>
          <tr>
            <td colspan="8"><cfif len(attributes.form_submitted)><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
          </tr>
        </cfif>
	</tbody>
</cf_medium_list>
<cfif (attributes.totalrecords gt attributes.maxrows)> 	
	<cfset url_str = "">
	<cfif len(attributes.keyword)>
	  <cfset url_str = "#url_str#&keyword=#attributes.employee_id#">
	</cfif>
	<cfif len(attributes.assetp_id)>
	  <cfset url_str = "#url_str#&assetp_id=#attributes.assetp_id#">
	</cfif>
	<cfif len(attributes.employee_name)>
	  <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
	</cfif>
	<cfif len(attributes.employee_id)>
	  <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
	</cfif>
	<table width="99%" align="center">
		<tr>
			<td><cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="assetcare.popup_list_kaza_detail#url_str#"></td>
			<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
		</tr>
	</table>
</cfif>
