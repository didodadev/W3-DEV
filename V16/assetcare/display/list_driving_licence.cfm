<!--- BU SAYFA HEM BASKET,HEM POPUPTA KULLANILDIĞI İÇİN TASARIMSAL OLARAK BASKETE GÖRE UYARLANMIŞTIR.  --->
<cfsetting showdebugoutput="no">
<cfquery name="get_driver_licence" datasource="#dsn#">
 	SELECT 
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.DEPARTMENT_ID,
		ZONE.ZONE_NAME,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		SETUP_POSITION_CAT.POSITION_CAT,
		SETUP_DRIVERLICENCE.LICENCECAT,
		EMPLOYEE_DRIVERLICENCE_ROWS.LICENCE_START_DATE,
		EMPLOYEE_DRIVERLICENCE_ROWS.LICENCE_NO,
		EMPLOYEES_IDENTY.BLOOD_TYPE
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		ZONE,
		SETUP_POSITION_CAT,
		EMPLOYEE_DRIVERLICENCE_ROWS,
		EMPLOYEES_IDENTY,
		SETUP_DRIVERLICENCE
	WHERE
		<!--- Sadece yetkili olunan şubeler gözüksün.  --->
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
		<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee_name)>AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.employee_id#</cfif>
 		<cfif isdefined("attributes.driver_licence_type") and len(attributes.driver_licence_type)>AND EMPLOYEE_DRIVERLICENCE_ROWS.LICENCECAT_ID = #attributes.driver_licence_type#</cfif>
 		<cfif isdefined("attributes.driver_licence_year") and len(attributes.driver_licence_year)>AND YEAR(EMPLOYEE_DRIVERLICENCE_ROWS.LICENCE_START_DATE) = #attributes.driver_licence_year#</cfif>
		AND EMPLOYEE_DRIVERLICENCE_ROWS.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
		AND EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
		AND SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
		AND DEPARTMENT.DEPARTMENT_ID = EMPLOYEE_POSITIONS.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND BRANCH.ZONE_ID = ZONE.ZONE_ID 
		AND SETUP_DRIVERLICENCE.LICENCECAT_ID = EMPLOYEE_DRIVERLICENCE_ROWS.LICENCECAT_ID
	ORDER BY
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME
</cfquery>
<cfif isdefined("attributes.is_submitted")>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_driver_licence.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<cf_box title="#getLang('','Ehliyet Bilgisi',29504)#" uidrop="1">


	<cf_grid_list>
	<thead>
		<tr>
			<th style="width:4%;"><cf_get_lang dictionary_id='57487.No'></th>
			<th style="width:14%;"><cf_get_lang dictionary_id='30031.Lokasyon'></th>
			<th style="width:14%;"><cf_get_lang dictionary_id='57544.Sorumlu'></th>
			<th style="width:12%;"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
			<th style="width:12%;"><cf_get_lang dictionary_id='48345.Ehliyet Tipi'></th>
			<th style="width:11%;"><cf_get_lang dictionary_id='44319.Ehliyet Yılı'></th>
			<th style="width:11%;"><cf_get_lang dictionary_id='34633.Ehliyet No'></th>
			<th style="width:11%;"><cf_get_lang dictionary_id='48348.Alındığı Yer'></th>
			<th style="width:11%;"><cf_get_lang dictionary_id='58441.Kan Grubu'></th>
		</tr>
	</thead>
    <tbody>
		<cfif isdefined("attributes.is_submitted")>
			<cfif get_driver_licence.recordcount>
				<cfoutput query="get_driver_licence" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" height="20">
					  <td>#currentrow#</td>
					  <td>#zone_name# / #branch_name# / #department_head#</td>
					  <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi">#employee_name# #employee_surname#</a></td>
					  <td>#position_cat#</td>
					  <td>#licencecat#</td>
					  <td><cfif len(licence_start_date)>#year(licence_start_date)#</cfif></td>
					  <td>#licence_no#</td>
					  <td></td>
					  <td><cfif len(blood_type)>
							<cfswitch expression="#blood_type#">
								<cfcase value="0">0 Rh+</cfcase>
								<cfcase value="1">0 Rh-</cfcase>
								<cfcase value="2">A Rh+</cfcase>
								<cfcase value="3">A Rh-</cfcase>
								<cfcase value="4">B Rh+</cfcase>
								<cfcase value="5">B Rh-</cfcase>
								<cfcase value="6">AB Rh+</cfcase>
								<cfcase value="7">AB Rh-</cfcase>
							</cfswitch>
						  </cfif></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr class="color-row">
					<td colspan="10" height="20"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		<cfelse>
			<tr class="color-row">
			  <td colspan="10" height="20"><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</td>
			</tr>
		</cfif>
    </tbody>
</cf_grid_list>

</cf_box>
<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined("attributes.employee_id")>
	  <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
	</cfif>
	<cfif isdefined("attributes.employee_name")>
	  <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
	</cfif>
	<cfif isdefined("attributes.branch_id")>
	  <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.branch")>
	  <cfset url_str = "#url_str#&branch=#attributes.branch#">
	</cfif>
	<cfif isdefined("attributes.is_submitted")>
	  <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
	</cfif>
	<cfif isdefined("attributes.driver_licence_type")>
	  <cfset url_str = "#url_str#&driver_licence_type=#attributes.driver_licence_type#">
	</cfif>
	<cfif isdefined("attributes.driver_licence_year")>
	  <cfset url_str = "#url_str#&driver_licence_year=#attributes.driver_licence_year#">
	</cfif>
	<cfif isdefined("attributes.start_date")>
	  <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date)#">
	</cfif>
	<cfif isdefined("attributes.finish_date")>
	  <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date)#">
	</cfif>	
	<!-- sil -->
	<table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
		<tr>
			<td><cf_pages page="#attributes.page#"
				  maxrows="#attributes.maxrows#"
				  totalrecords="#attributes.totalrecords#"
				  startrow="#attributes.startrow#"
				  adres="assetcare.popup_list_driving_licence#url_str#"></td>
			<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='59064.Toplam Kayıt'> : #attributes.totalrecords#&nbsp;-&nbsp; <cf_get_lang dictionary_id='57581.Sayfa'> :#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
  <!-- sil -->
</cfif>
