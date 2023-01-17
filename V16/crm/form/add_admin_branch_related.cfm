<cfquery name="GET_PRO_TYPEROWS" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.form_add_company%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_RELATED" datasource="#dsn#">
	SELECT 
		COMPANY.FULLNAME,
		COMPANY.COMPANY_ID,
		COMPANY_BRANCH_RELATED.IS_SELECT, 
		COMPANY_BRANCH_RELATED.DEPO_STATUS, 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM,
		COMPANY_BRANCH_RELATED.RECORD_EMP,
		COMPANY_BRANCH_RELATED.RECORD_DATE,
		COMPANY_BRANCH_RELATED.UPDATE_EMP,
		COMPANY_BRANCH_RELATED.UPDATE_DATE,
		COMPANY_BRANCH_RELATED.VALID_DATE,
		COMPANY_BRANCH_RELATED.VALID_EMP
	FROM 
		COMPANY,
		COMPANY_BRANCH_RELATED
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.RELATED_ID = #attributes.related_id# AND
		COMPANY.COMPANY_ID = COMPANY_BRANCH_RELATED.COMPANY_ID
</cfquery>
<cfquery name="GET_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES 
</cfquery>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
    	<td valign="top" class="color-border">
		<table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1">
			<tr class="color-list">
		  		<td class="headbold" height="35"><cf_get_lang_main no='45.Müşteri '>: <cfoutput>#get_related.fullname#</cfoutput></td>
			</tr>
			<tr class="color-row">
		  		<td valign="top">
				<table>
				<cfform name="form_add_company" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_admin_branch_related">
				<input name="related_id" id="related_id" type="hidden" value="<cfoutput>#attributes.related_id#</cfoutput>">
				<input name="company_id" id="company_id" type="hidden" value="<cfoutput>#get_related.company_id#</cfoutput>">
				<input name="old_cat_status" id="old_cat_status" type="hidden" value="<cfoutput>#get_related.musteridurum#</cfoutput>">
					<tr>
						<td width="110">Cari/Potansiyel *</td>
						<td><input type="checkbox" name="is_select" id="is_select" <cfif get_related.is_select eq 1>checked</cfif>></td>
					</tr>
					<tr>
						<td>Süreç-Aşama *</td>
						<td>
							<select name="pro_rows" id="pro_rows" style="width:180px;">
							<cfoutput query="get_pro_typerows">
								<option value="#process_row_id#" <cfif get_related.depo_status eq process_row_id>selected</cfif>>#stage#</option>
							</cfoutput>
							</select>
						</td>
					<tr>
						<td><cf_get_lang_main no='482.Statü'> *</td>
						<td>
							<select name="cat_status" id="cat_status" style="width:180px;">
							<cfoutput query="get_status">
								<option value="#tr_id#" <cfif get_related.musteridurum eq tr_id>selected</cfif>>#tr_name#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no='71.Kayıt'></td>
						<td>: <cfoutput>#get_emp_info(get_related.record_emp,0,0)# <cfif len(get_related.record_date)> - #dateformat(get_related.record_date,dateformat_style)#</cfif></cfoutput></td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no='291.Son Güncelleme'></td>
						<td>: <cfoutput>#get_emp_info(get_related.update_emp,0,0)# <cfif len(get_related.update_date)>- #dateformat(get_related.update_date,dateformat_style)#</cfif></cfoutput></td>
					</tr>
					<tr>
						<td class="txtboldblue">Onay Tarihi</td>
						<td>: <cfoutput><cfif len(get_related.valid_date)>#dateformat(get_related.valid_date,dateformat_style)#</cfif></cfoutput></td>
					</tr>
					<tr>
						<td class="txtboldblue">Onaylayan</td>
						<td>: <cfoutput>#get_emp_info(get_related.valid_emp,0,0)#</cfoutput></td>
					</td>
				</tr>
				</cfform>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
