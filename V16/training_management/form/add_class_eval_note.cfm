<cfinclude template="../query/get_class_eval_note.cfm">
<cfif get_note.recordcount>
	<cflocation addtoken="no" url="#request.self#?fuseaction=training_management.popup_upd_class_eval_note&class_id=#attributes.class_id#">
</cfif>
<cfinclude template="../query/get_training_class_attender.cfm">
<cf_popup_box title="#getLang('training_management',215)#">
	<cfform name="add_class_eval_note" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_class_eval_note">
	<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#class_id#</cfoutput>">
		<table width="100%">
			<cfif get_class_attender.recordcount>
				<tr>
					<td valign="top">
						<table>
							<tr heighht="25" class="txtboldblue">
								<td><cf_get_lang_main no='158.Ad Soyad'></td>
								<td><cf_get_lang no='249.Görüşleri'></td>
							</tr>
							<input name="max_record_number" id="max_record_number" type="hidden" value="<cfoutput>#get_class_attender.recordcount#</cfoutput>">
							<cfoutput query="get_class_attender">
								<tr>
									<td>
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
									</td>
									<td><textarea type="text" name="NOTE_#currentrow#" id="NOTE_#currentrow#" rows="3" style="width:480px"></textarea></td>
								</tr>
							</cfoutput>
						</table>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td valign="top">
						<br/><cf_get_lang no='533.Kayıtlı Kullanıcı Yok'> !		
					</td>
				</tr>
			</cfif>
		</table>
		<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>
