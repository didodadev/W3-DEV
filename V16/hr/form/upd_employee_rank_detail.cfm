<!--- sayfanin en altinda kapanisi var --->
<cfquery name="get_factors" datasource="#dsn#">
	SELECT GRADE FROM SALARY_FACTORS ORDER BY GRADE
</cfquery>
<cfquery name="get_rank" datasource="#dsn#">
	SELECT
		ID,
		EMPLOYEE_ID,
		GRADE,
		STEP,
		PROMOTION_START,
		PROMOTION_FINISH,
		PROMOTION_REASON,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		UPDATE_EMP,
		UPDATE_DATE,
		UPDATE_IP
	FROM
		EMPLOYEES_RANK_DETAIL
	WHERE
		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfsavecontent variable="right">
	<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_add_rank&employee_id=#attributes.EMPLOYEE_ID#</cfoutput>"><img src="/images/plus1.gif" alt="<cf_get_lang_main no='170.Ekle'>"  title="<cf_get_lang_main no='170.Ekle'>"></a>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="37568.Derece/Kademe Bilgileri"></cfsavecontent>
<cf_popup_box title="#message#" right_images="#right#">
	<cfform name="add_rank" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_rank">
	<input type="hidden" name="ID" id="ID" value="<cfoutput>#attributes.ID#</cfoutput>"> 
	<input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#get_rank.EMPLOYEE_ID#</cfoutput>"> 
		<cf_area>
			<table>
				<tr>
					<td width="100"><cf_get_lang dictionary_id="37566.Derece / Kademe"> *</td>
					<td>
						<select name="grade" id="grade" style="width:45px;">
							<cfoutput query="get_factors">
								<option value="#grade#"<cfif get_rank.grade eq grade>selected</cfif>>#grade#</option>
							</cfoutput>	
						</select>
						/
						<select name="step" id="step" style="width:45px;">
							<cfoutput>
							<cfloop from="1" to="4" index="i">
								<option value="#i#"<cfif get_rank.step eq i>selected</cfif>>#i#</option>
							</cfloop>
							</cfoutput>	
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="37757.Terfi Başlangıç"> *</td>
					<td>                          
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="37757.Terfi Başlangıç">!</cfsavecontent>
						<cfinput validate="#validate_style#" type="text" name="promotion_start" id="promotion_start" value="#dateformat(get_rank.promotion_start,dateformat_style)#" style="width:100px;" required="yes" message="#message#">
						<cf_wrk_date_image date_field="promotion_start">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="34746.Terfi Bitiş"> *</td>
					<td>                          
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="34746.Terfi Bitiş">!</cfsavecontent>
						<cfinput validate="#validate_style#" type="text" name="promotion_finish" id="promotion_finish" value="#dateformat(get_rank.promotion_finish,dateformat_style)#" style="width:100px;" required="yes" message="#message#">
						<cf_wrk_date_image date_field="promotion_finish">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="34723.Terfi Nedeni"></td>
					<td>
						<select name="promotion_reason" id="promotion_reason" style="width:120px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1"<cfif get_rank.promotion_reason eq 1>selected</cfif>><cf_get_lang dictionary_id="34715.Hizmet İntibakı"></option>
							<option value="2"<cfif get_rank.promotion_reason eq 2>selected</cfif>><cf_get_lang dictionary_id="58567.Terfi"></option>
							<option value="3"<cfif get_rank.promotion_reason eq 3>selected</cfif>><cf_get_lang dictionary_id="30483.Yüksek Lisans"></option>
							<option value="4"<cfif get_rank.promotion_reason eq 4>selected</cfif>><cf_get_lang dictionary_id="31293.Doktora"></option>
                            <option value="5"<cfif get_rank.promotion_reason eq 5>selected</cfif>><cf_get_lang dictionary_id="34713.Lise Hazırlık"></option>
                            <option value="6"<cfif get_rank.promotion_reason eq 6>selected</cfif>><cf_get_lang dictionary_id="34704.İlk Görev"></option>
                            <option value="7"<cfif get_rank.promotion_reason eq 7>selected</cfif>><cf_get_lang dictionary_id="58156.Diğer"></option>
						</select>
					</td>
				</tr>
			</table>
		</cf_area>
		<cf_area new_line="1">	
			<br/>
			<cfinclude template="../display/list_emp_ranks.cfm">
		</cf_area>
	<cf_popup_box_footer>
		<cf_record_info query_name='get_rank'>
		<cf_workcube_buttons is_upd='1' insert_alert='' delete_page_url='#request.self#?fuseaction=#listFirst(attributes.fuseaction,'.')#.emptypopup_del_rank&id=#attributes.id#&employee_id=#attributes.employee_id#'> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
	</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
