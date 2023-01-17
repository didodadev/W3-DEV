<cfsetting showdebugoutput="no">
<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
<cfquery name="GET_CARE_REPORT" datasource="#DSN#" maxrows="50">
	SELECT
		ASSET_CARE_REPORT.CARE_DATE,
		ASSET_CARE_REPORT.COMPANY_ID, 
		ASSET_CARE_REPORT.CARE_KM,
		ASSET_CARE_REPORT.EXPENSE_AMOUNT, 
		ASSET_CARE_REPORT.AMOUNT_CURRENCY,
		ASSET_CARE_REPORT.COMPANY_ID,
		ASSET_CARE_REPORT.COMPANY_PARTNER_ID,
		ASSET_CARE_REPORT.C_EMPLOYEE1_ID,
		ASSET_P.ASSETP,
		ASSET_CARE_CAT.ASSET_CARE
	FROM
		ASSET_CARE_REPORT, 
		ASSET_P, 
		ASSET_CARE_CAT 
	WHERE
		ASSET_CARE_REPORT.ASSET_ID = #attributes.assetp_id# AND
		ASSET_P.ASSETP_ID = ASSET_CARE_REPORT.ASSET_ID AND
		ASSET_CARE_CAT.ASSET_CARE_ID = ASSET_CARE_REPORT.CARE_TYPE
	ORDER BY
		ASSET_CARE_REPORT.CARE_REPORT_ID DESC
</cfquery>
<cfset pageHead = "#getLang('asset',72)# : #getLang('main',1656)# : #get_assetp.assetp#">
<cf_catalystHeader>
<cfsavecontent variable="head_">
	<cf_get_lang no='34.Bakım Sonucu'><cfif get_care_report.recordcount eq 50>(Son 50 Kayıt)</cfif>
</cfsavecontent>
<div id="care_div">
<cf_box>
<cf_grid_list>
	<thead>
		<tr>
        	<th><cf_get_lang_main no="1165. Sıra"></th>
			<th><cf_get_lang_main no='330.Tarih'></th>
			<th><cf_get_lang_main no='1656.Plaka'></th>
			<th><cf_get_lang no='42.Bakım Tipi'></th>
			<th><cf_get_lang no='240.Bakım Yapan Firma'> - <cf_get_lang_main no='166.Yetkili'></th>
			<th><cf_get_lang no='38.Bakım Yapan Çalışan'></th>
			<th style="text-align:right;"><cf_get_lang no='241.Bakım KM'></th>
			<th style="text-align:right;"><cf_get_lang_main no='261.Toplam Tutar'></th>
		</tr>
	</thead>
	<tbody>
		<cfset company_id_list=''>
		<cfset company_partner_id_list=''>
		<cfset emp_id_list=''>
        <cfif get_care_report.recordcount>			
		<cfoutput query="get_care_report">
		<cfif len(company_id) and not listfind(company_id_list,company_id)>
			<cfset company_id_list=listappend(company_id_list,company_id)>
		</cfif>
		<cfif len(company_partner_id) and not listfind(company_partner_id_list,company_partner_id)>
			<cfset company_partner_id_list=listappend(company_partner_id_list,company_partner_id)>
		</cfif>
		<cfif len(c_employee1_id) and not listfind(emp_id_list,c_employee1_id)> 
			<cfset emp_id_list=listappend(emp_id_list,c_employee1_id)>
		</cfif>
		</cfoutput>
		<cfif len(company_id_list)>
			<cfquery name="get_company_detail" datasource="#dsn#">
				SELECT COMPANY_ID,NICKNAME,FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#)
			</cfquery>
		</cfif>
		<cfif len(company_partner_id_list)>
			<cfquery name="get_company_partner_detail" datasource="#dsn#">
				SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#company_partner_id_list#)
			</cfquery>
		</cfif>			
		<cfif len(emp_id_list)>
			<cfquery name="get_employee_detail" datasource="#dsn#">
				SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_id_list#)
			</cfquery>			
		</cfif>	
			<cfoutput query="get_care_report">
				<tr>
					<td>#currentrow#</td>
					<td>#dateformat(care_date,dateformat_style)#</td>
					<td>#assetp#</td>
					<td>#asset_care#</td>
					<td><!--- Company --->
					<cfif len(company_id)>
						<cfquery name="get_company_name_record" dbtype="query">
							SELECT * FROM get_company_detail WHERE COMPANY_ID=#company_id#
						</cfquery>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_company_name_record.company_id#','medium');">#get_company_name_record.fullname#</a>
					</cfif>
					<!--- Company Partner --->
					<cfif len(company_partner_id)>
						<cfquery name="get_company_partner_name_record" dbtype="query">
							SELECT * FROM get_company_partner_detail WHERE PARTNER_ID=#company_partner_id#
						</cfquery>
						- <a href="javascript://" class="tableyazi"onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_company_partner_name_record.partner_id#','medium');">#get_company_partner_name_record.company_partner_name# #get_company_partner_name_record.company_partner_surname#</a>
					</cfif></td>
					<td><!--- Bakım Yapan Çalışan --->
					<cfif len(c_employee1_id)>
						<cfquery name="get_employee_name_record" dbtype="query">
							SELECT * FROM get_employee_detail WHERE EMPLOYEE_ID=#c_employee1_id#
						</cfquery>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_employee_name_record.employee_id#','medium');" >#get_employee_name_record.EMPLOYEE_NAME# #get_employee_name_record.EMPLOYEE_SURNAME#</a>
					</cfif></td>
					<td style="text-align:right;">#tlformat(care_km,0)#</td>
					<td style="text-align:right;"><cfif len(expense_amount)>#tlformat(expense_amount)# #amount_currency#</cfif></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
</cf_box>
</div>
