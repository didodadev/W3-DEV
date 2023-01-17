<!--- sayfanin en altinda kapanisi var --->
<cf_get_lang_set module_name="hr">
<cfquery name="get_factors" datasource="#dsn#">
	SELECT GRADE FROM SALARY_FACTORS ORDER BY GRADE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="37568.Derece/Kademe Bilgileri"></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_rank" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_rank">
	<input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>"> 
		<cf_area>
			<table>
				<tr>
					<td width="100"><cf_get_lang dictionary_id="37566.Derece / Kademe"> *</td>
					<td>
						<select name="grade" id="grade" style="width:45px;">
							<cfoutput query="get_factors">
								<option value="#grade#">#grade#</option>
							</cfoutput>	
						</select>
						/
						<select name="step" id="step" style="width:45px;">
							<cfoutput>
							<cfloop from="1" to="4" index="i">
								<option value="#i#">#i#</option>
							</cfloop>
							</cfoutput>	
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="37757.Terfi Başlangıç"> *</td>
					<td>                          
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="37757.Terfi Başlangıç">!</cfsavecontent>
						<cfinput validate="#validate_style#" type="text" name="promotion_start" id="promotion_start" value="" style="width:100px;" required="yes" message="#message#">
						<cf_wrk_date_image date_field="promotion_start">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="34746.Terfi Bitiş"> *</td>
					<td>                          
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="34746.Terfi Bitiş">!</cfsavecontent>
						<cfinput validate="#validate_style#" type="text" name="promotion_finish" id="promotion_finish" value="" style="width:100px;" required="yes" message="#message#">
						<cf_wrk_date_image date_field="promotion_finish">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="34723.Terfi Nedeni"></td>
					<td>
						<select name="promotion_reason" id="promotion_reason" style="width:120px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1"><cf_get_lang dictionary_id="34715.Hizmet İntibakı"></option>
							<option value="2"><cf_get_lang dictionary_id="58567.Terfi"></option>
							<option value="3"><cf_get_lang dictionary_id="30483.Yüksek Lisans"></option>
							<option value="4"><cf_get_lang dictionary_id="31293.Doktora"></option>
                            <option value="5"><cf_get_lang dictionary_id="34713.Lise Hazırlık"></option>
                            <option value="6"><cf_get_lang dictionary_id="34704.İlk Görev"></option>
                            <option value="7"><cf_get_lang dictionary_id="58156.Diğer"></option>
                        </select>
					</td>
				</tr>
			</table>
		</cf_area>
		<cf_area new_line="1">
		<br/>
		<cfinclude template="../display/list_emp_ranks.cfm">
		</cf_area>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' insert_alert='' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_rank' , #attributes.modal_id#)"),DE(""))#'>
		</cf_box_footer>
	</cfform>
</cf_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">