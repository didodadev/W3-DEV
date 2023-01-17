<cfinclude template="../query/get_training_class_attender.cfm">
<cfquery name="get_eval_note_list" datasource="#dsn#" maxrows="1">
	SELECT 
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM 
		TRAINING_CLASS_EVAL_NOTE 
	WHERE 
		CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#">
</cfquery>
<cfsavecontent variable="right">
	<cfoutput>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_eval_note&action=print&id=#url.class_id#&module=training_management','page');return false;"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_eval_note&action=mail&id=#url.class_id#&module=training_management','page')"><img src="/images/mail.gif" title="<cf_get_lang_main no='63.Mail Gönder'>" border="0"></a>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_eval_note&action=pdf&id=#url.class_id#&module=training_management','page')"><img src="/images/pdf.gif" title="<cf_get_lang_main no='66.PDF E Dönüştür'>" border="0"></a>
	</cfoutput>
</cfsavecontent>
<cf_popup_box title="#getLang('training_management',215)#" right_images="#right#">
	<cfform name="upd_class_eval_note" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_eval_note">
	<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#class_id#</cfoutput>">
	<table>
		<tr heighht="25" class="txtboldblue">
			<td><cf_get_lang_main no='158.Ad Soyad'></td>
			<td><cf_get_lang no='249.Görüşleri'></td>
		</tr>
		<input name="max_record_number" id="max_record_number" type="hidden" value="<cfoutput>#get_class_attender.recordcount#</cfoutput>">
		<cfoutput query="get_class_attender">
			<cfquery  name="get_kontrol" datasource="#DSN#">
				SELECT
					EMPLOYEE_ID,
					CON_ID,
					PAR_ID,
					DETAIL
				FROM
					TRAINING_CLASS_EVAL_NOTE
				WHERE
					CLASS_ID=#attributes.CLASS_ID# AND
					<cfif isdefined("EMP_ID") and len(EMP_ID)>
					EMPLOYEE_ID = #EMP_ID#
					<cfelseif isdefined("CON_ID") and len(CON_ID)>
					CON_ID = #CON_ID#
					<cfelseif isdefined("PAR_ID") and len(PAR_ID)>
					PAR_ID = #PAR_ID#
					</cfif>
			</cfquery>
		<tr>
			<td valign="top">
			<cfif get_kontrol.recordcount gt 0>
				<cfif len(emp_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');" class="tableyazi">#ad#</a>
					<input type="hidden" name="EMP_ID_#currentrow#" id="EMP_ID_#currentrow#" value="#get_kontrol.EMPLOYEE_ID#">
				<cfelseif len(con_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CON_ID#','medium');" class="tableyazi">#ad#</a>
					<input type="hidden" name="CON_ID_#currentrow#" id="CON_ID_#currentrow#" value="#get_kontrol.CON_ID#">
				<cfelseif len(par_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#PAR_ID#','medium');" class="tableyazi">#ad#</a>
					<input type="hidden" name="PAR_ID_#currentrow#" id="PAR_ID_#currentrow#" value="#get_kontrol.PAR_ID#">
				</cfif>
				<cfelse>
				<cfif len(emp_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#emp_id#','project');" class="tableyazi">#AD#</a>
					<input type="hidden" name="EMP_ID_#currentrow#" id="EMP_ID_#currentrow#" value="#EMP_ID#">
				<cfelseif len(con_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#con_id#','small');" class="tableyazi">#AD#</a>
					<input type="hidden" name="CON_ID_#currentrow#" id="CON_ID_#currentrow#" value="#CON_ID#">
				<cfelseif len(par_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#par_id#','small');" class="tableyazi">#AD#</a>
					<input type="hidden" name="PAR_ID_#currentrow#" id="PAR_ID_#currentrow#" value="#PAR_ID#">
				</cfif>
			</cfif>
			</td>
			<td>
				<cfif get_class_attender.recordcount>
					<textarea type="text" name="NOTE_#currentrow#" id="NOTE_#currentrow#" rows="3" style="width:480px">#get_kontrol.DETAIL#</textarea>
				<cfelse>
					<textarea type="text" name="NOTE_#currentrow#" id="NOTE_#currentrow#" rows="3" style="width:480px"></textarea>
				</cfif>
			</td>
		</tr>
		</cfoutput>
	</table>
	<cf_popup_box_footer>
		<cf_record_info query_name="get_eval_note_list">
		<cf_workcube_buttons type_format="1" is_upd='0'>
	</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
