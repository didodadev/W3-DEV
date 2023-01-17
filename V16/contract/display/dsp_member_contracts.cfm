<cfquery name="get_contact_detail" datasource="#DSN3#">
	SELECT 
		RC.CONTRACT_ID, 
		RC.CONTRACT_CAT_ID, 
		RC.STARTDATE, 
		RC.FINISHDATE, 
		RC.CONTRACT_HEAD, 
		RC.CONTRACT_BODY, 
		RC.COMPANY, 
		RC.COMPANY_PARTNER, 
		RC.EMPLOYEE, 
		RC.EMPLOYEE_VALID, 
		RC.CONSUMERS, 
		RC.STAGE_ID,
		RC.OUR_COMPANY_ID, 
		RC.COMPANY_ID, 
		RC.CONSUMER_ID, 
		RC.CONTRACT_TYPE, 
		RC.RECORD_DATE, 
		RC.RECORD_EMP, 
		RC.RECORD_IP, 
		RC.UPDATE_DATE, 
		RC.UPDATE_EMP, 
		RC.UPDATE_IP, 
		RC.PROJECT_ID ,
		PTR.STAGE STAGE_NAME
    FROM 
    	RELATED_CONTRACT  RC
		LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = RC.STAGE_ID
    WHERE 
    	RC.CONTRACT_ID = #attributes.contract_id#
</cfquery>
<cfset attributes.contract_cat_id = get_contact_detail.contract_cat_id>
<cfset attributes.stage_id = get_contact_detail.stage_id>
<cfinclude template="../query/get_cat.cfm">
<cfquery name="get_asset_info" datasource="#dsn#">
	SELECT
		A.ASSET_ID,
		A.ASSET_NAME,
		A.ASSETCAT_ID,
		A.ASSET_FILE_NAME,
		A.ASSET_FILE_SERVER_ID,
		AC.ASSETCAT_PATH,
		A.*
	FROM
		ASSET A,
		ASSET_CAT AC
	WHERE
		A.ASSETCAT_ID = AC.ASSETCAT_ID AND
		A.IS_SPECIAL = 0 AND
		A.ACTION_SECTION = 'CONTRACT_ID' AND
		A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contract_id#"> AND
		A.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="17"> AND
		A.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfsavecontent variable="head_">
	<cf_get_lang_main no='25.Anlaşmalar'> : <cfoutput><cfif Len(get_contact_detail.company_id)>#get_par_info(get_contact_detail.company_id,1,1,0)#<cfelseif Len(get_contact_detail.consumer_id)>#get_cons_info(get_contact_detail.consumer_id,0,0)#</cfif></cfoutput>
</cfsavecontent>
<cf_popup_box title="#head_#">
	<table>
		<cfoutput>
		<tr>
			<td width="150" class="formbold"><cf_get_lang_main no='68.Konu'></td>
			<td colspan="3">#get_contact_detail.contract_head#</td>
		</tr>
		<tr>
			<td class="formbold" width="150"><cf_get_lang_main no='74.Kategori'></td>
			<td width="250">#get_cat.contract_cat#</td>
			<td width="150" class="formbold"><cf_get_lang_main no='70.Aşama'></td>
			<td width="250">#get_contact_detail.stage_name#</td>
		</tr>
		<tr>
			<td class="formbold"><cf_get_lang_main no='243.Başlama Tarihi'></td>
			<td>#DateFormat(get_contact_detail.STARTDATE,'DD/MM/YYY')#</td>
			<td class="formbold"><cf_get_lang_main no='288.Bitiş Tarihi'></td>
			<td>#DateFormat(get_contact_detail.FINISHDATE,'DD/MM/YYY')#</td>
		</tr>
		<tr>
			<td class="formbold"><cf_get_lang_main no='71.Kayıt'></td>
			<td>#get_emp_info(get_contact_detail.RECORD_EMP,0,0)# - #dateformat(get_contact_detail.RECORD_DATE,dateformat_style)#</td>
			<td class="formbold"><cf_get_lang_main no='291.Güncelleme'></td>
			<td><cfif len(get_contact_detail.UPDATE_EMP)>#get_emp_info(get_contact_detail.UPDATE_EMP,0,0)#  - #dateformat(get_contact_detail.UPDATE_DATE,dateformat_style)#</cfif></td>
		</tr>
		<tr valign="top">
			<td class="formbold"><cf_get_lang no='6.Taraflar'> (<cf_get_lang_main no='164.Çalışan'>)</td>
			<td><cfloop list="#ListDeleteDuplicates(get_contact_detail.employee)#" index="xx">
					<cfquery name="get_employee_info" datasource="#dsn#">
						SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = #xx#
					</cfquery>
					#get_employee_info.employee_name# #get_employee_info.employee_surname#<br />
				</cfloop>
			</td>
			<td class="formbold"><cf_get_lang no='6.Taraflar'> (<cf_get_lang_main no='1473.Partner'>)</td>
			<td><cfloop list="#ListDeleteDuplicates(get_contact_detail.company_partner)#" index="yy">
					#get_par_info(yy,0,0,0)#<br />
				</cfloop>
			</td>
		</tr>
		<tr valign="top">
			<td class="formbold"><cf_get_lang_main no="4.Proje"></td>
			<td><cfif Len(get_contact_detail.project_id)>
					<cfloop list="#ListDeleteDuplicates(get_contact_detail.project_id)#" index="zz">
						#get_project_name(zz)#<br />
					</cfloop>
				</cfif>
			</td>
			<td class="formbold"><cf_get_lang_main no="156.Belgeler"></td>
			<td><cfloop query="get_asset_info">
					<a href="#request.self#?fuseaction=objects.popup_download_file&file_name=<cfif assetcat_id gt 0>asset/</cfif>#assetcat_path#/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#" class="tableyazi">#asset_name#</a><br />
				</cfloop>
			</td>
		</tr>
		<tr valign="top">
			<td class="formbold"><cf_get_lang_main no='241.İçerik'></td>
			<td colspan="3"><hr />#get_contact_detail.contract_body#</td>
		</tr>
		</cfoutput>
	</table>
</cf_popup_box>
