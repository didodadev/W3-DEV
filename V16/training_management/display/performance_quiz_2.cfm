<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<cfset last_point="">
<cfinclude template="../query/get_training_eval_quiz_chapters.cfm">
<cfif get_quiz_chapters.recordcount and get_emp_att.recordcount>
	<tr class="color-row">
		<td valign="top" height="80%">
			<table border="0">
				<cfoutput query="get_emp_att">
					<cfset emp_id_loop = get_emp_att.EMP_ID>
					<cfquery name="GET_TRAINING_PERF" datasource="#dsn#">
						SELECT
							TRAINING_PERFORMANCE_ID,
							CLASS_ID,
							USER_POINT,
							PERFORM_POINT,
							TRAINING_DETAIL,
							RECORD_EMP
						FROM 
							TRAINING_PERFORMANCE
						WHERE
							TRAINING_QUIZ_ID = #attributes.quiz_id# AND
							ENTRY_EMP_ID = #emp_id_loop# AND
							CLASS_ID = #attributes.class_id#
					</cfquery>
					<tr>
						<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
						<cfif GET_TRAINING_PERF.RecordCount>
						<td>
							<cfloop query="GET_TRAINING_PERF">
								<cfif not GET_TRAINING_PERF.perform_point gt 0>
									<cfset last_point=0>
								<cfelse>
									<cfif GET_TRAINING_PERF.USER_POINT gt 0 >
										<cfset last_point = ((GET_TRAINING_PERF.USER_POINT / GET_TRAINING_PERF.PERFORM_POINT) * 100)>
									<cfelse>
										<cfset last_point=0>
									</cfif>
								</cfif>
							</cfloop>
							<cfif len(last_point)>#Round(last_point)#&nbsp;/&nbsp;100</cfif>
						</td>
						<cfif not listfindnocase(denied_pages,'training_management.form_upd_training_performance')>
							<td>
								Açıklama :  <input type="text" name="training_detail_#GET_TRAINING_PERF.TRAINING_PERFORMANCE_ID#" id="training_detail_#GET_TRAINING_PERF.TRAINING_PERFORMANCE_ID#" style="width:220px;" maxlength="150" value="<cfif len(GET_TRAINING_PERF.TRAINING_DETAIL)>#GET_TRAINING_PERF.TRAINING_DETAIL#</cfif>">
							</td>
							<td>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_form_upd_training_performance&quiz_id=#attributes.QUIZ_ID#&employee_id=#emp_id_loop#&class_id=#attributes.CLASS_ID#&training_per_id=#GET_TRAINING_PERF.TRAINING_PERFORMANCE_ID#','page')"> <img src="/images/update_list.gif" border="0" title="Formu Güncelle" align="absmiddle"> </a>
								<cfif GET_TRAINING_PERF.RECORD_EMP eq session.ep.userid><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.emptypopup_del_training_performance&training_per_id=#GET_TRAINING_PERF.TRAINING_PERFORMANCE_ID#','page')"> <img src="/images/delete_list.gif" border="0" title="Formu Sil" align="absmiddle"> </a>	</cfif>
							</td>
						</cfif>
						<cfelse>
							<td>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_form_add_training_performance&quiz_id=#attributes.QUIZ_ID#&employee_id=#emp_id_loop#&class_id=#attributes.CLASS_ID#','page')"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='350.Formu Doldur'>" border="0" align="absmiddle"></a>
							</td>
						</cfif>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
<cfelse>
	<tr class="color-row">
		<td valign="top">Eğitime kayıtlı katılımcı bulunmamaktır..</td>
	</tr>
</cfif>

