<cf_xml_page_edit fuseact="training_management.popup_form_upd_class_results">
<cfinclude template="../query/get_emp_att.cfm">
<cfquery name="get_training_class_result" datasource="#dsn#" maxrows="1">
	SELECT RECORD_EMP,UPDATE_EMP,RECORD_DATE,UPDATE_DATE FROM TRAINING_CLASS_RESULTS WHERE CLASS_ID=#attributes.CLASS_ID#
</cfquery>
<cf_popup_box title="#getLang('training_management',9)#">
	<cfform name="add_class_results" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_results">
		<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#class_id#</cfoutput>">
		<table>
			<tr class="txtboldblue">
				<td height="25"><cf_get_lang_main no='158.Ad Soyad'></td>
				<td><cf_get_lang no='247.Ön Test S'></td>
				<td><cf_get_lang no='248.Son Test S'></td>
                <cfif xml_test3_view eq 1>
                	<td><cf_get_lang no='38. 3 Test Sonuçları'></td>
				</cfif>
			</tr>
			<input name="max_record_number" id="max_record_number" type="hidden" value="<cfoutput>#get_emp_att.recordcount#</cfoutput>">
			<cfoutput query="get_emp_att">
			<tr>
				<td>
					<cfif len(emp_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');" class="tableyazi">#ad#</a>
					<input type="hidden" name="EMP_ID_#currentrow#" id="EMP_ID_#currentrow#" value="#EMP_ID#">
					<cfelseif len(con_id)>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#con_id#','medium');" class="tableyazi">#ad#</a>
						<input type="hidden" name="CON_ID_#currentrow#" id="CON_ID_#currentrow#" value="#CON_ID#">
					<cfelseif len(par_id)>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#par_id#','medium');" class="tableyazi">#ad#</a>
						<input type="hidden" name="PAR_ID_#currentrow#" id="PAR_ID_#currentrow#" value="#PAR_ID#">
					</cfif>
				</td>
				<cfquery name="get_class_results" datasource="#dsn#">
					SELECT
						PRETEST_POINT,
						FINALTEST_POINT,
                        THIRDTEST_POINT
					FROM
						TRAINING_CLASS_RESULTS 
					WHERE
						CLASS_ID = #get_emp_att.class_id#  
						<cfif len(get_emp_att.emp_id)>AND EMP_ID = #get_emp_att.emp_id#
						<cfelseif len(get_emp_att.par_id)>AND PAR_ID = #get_emp_att.par_id#
						<cfelseif len(get_emp_att.con_id)>AND CON_ID = #get_emp_att.con_id#
						</cfif>
				</cfquery>
				<cfif get_class_results.recordcount>
					<td><input type="text" name="PRETEST_POINT_#currentrow#" id="PRETEST_POINT_#currentrow#" style="width:60px" value="#get_class_results.PRETEST_POINT#"></td>
					<td><input type="text" name="FINALTEST_POINT_#currentrow#" id="FINALTEST_POINT_#currentrow#" style="width:60px" value="#get_class_results.FINALTEST_POINT#"></td>
					<cfif xml_test3_view eq 1>
                    	<td><input type="text" name="THIRDTEST_POINT_#currentrow#" id="THIRDTEST_POINT_#currentrow#" style="width:60px" value="#get_class_results.THIRDTEST_POINT#"></td>
                    </cfif>
				<cfelse>
					<td><input type="text" name="PRETEST_POINT_#currentrow#" id="PRETEST_POINT_#currentrow#" style="width:60px" value=""></td>
					<td><input type="text" name="FINALTEST_POINT_#currentrow#" id="FINALTEST_POINT_#currentrow#" style="width:60px" value=""></td>
                    <cfif xml_test3_view eq 1>
                    	<td><input type="text" name="THIRDTEST_POINT_#currentrow#" id="THIRDTEST_POINT_#currentrow#" style="width:60px" value=""></td>
                    </cfif>
				</cfif>
			</tr>
			</cfoutput>
		</table>
		<cf_popup_box_footer>
			<cf_record_info query_name="get_training_class_result">
			<cf_workcube_buttons is_upd='1' is_delete='0'>
		</cf_popup_box_footer>					
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function gizle(id1)
{
	if(id1.style.display=='')
		id1.style.display='none';
	else
		id1.style.display='';
}
</script>

