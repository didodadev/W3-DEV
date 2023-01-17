<cfinclude template="../query/get_tra_quiz.cfm">
<cfinclude template="../query/get_quiz_result_count.cfm">
<cfset attributes.names = 1>
<cfset training_sec = "">
<cfset training_cat = "">
<cfset training = "">
<cfif len(get_quiz.training_sec_id) and (get_quiz.training_sec_id neq 0)>
	<cfset attributes.training_sec_id = get_quiz.training_sec_id>
	<cfinclude template="../query/get_training_sec.cfm">
	<cfset training_sec = get_training_sec.section_name>
</cfif>
<cfif len(get_quiz.training_id) and (get_quiz.training_id neq 0)>
	<cfset attributes.train_id = get_quiz.training_id>
	<cfinclude template="../query/get_training_subject.cfm">
	<cfset training = GET_TRAINING_SUBJECT.TRAIN_HEAD>
</cfif>
<cfif len(get_quiz.training_cat_id)>
	<cfquery name="get_training_cat" datasource="#dsn#">
		SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT WHERE TRAINING_CAT_ID = #get_quiz.training_cat_id#
	</cfquery>
	<cfset training_cat = get_training_cat.training_cat>
</cfif>
<cfif len(get_quiz.RECORD_EMP)>
	<cfset attributes.employee_id = get_quiz.RECORD_EMP>
	<cfinclude template="../query/get_employee.cfm">
</cfif> 
<cfif len(get_quiz.RECORD_par)>
	<cfset attributes.partner_id = get_quiz.RECORD_PAR>
	<cfinclude template="../query/get_partner.cfm">
</cfif>
<cfinclude template="../query/get_quiz_questions.cfm">
<cfinclude template="../query/get_user_join_quiz.cfm">
<cfquery name="GET_QUESTION_COUNT" datasource="#dsn#">
	SELECT COUNT(QUESTION_ID) AS Q_COUNT
  	FROM
    	QUIZ_QUESTIONS
  	WHERE
    	QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.QUIZ_ID#">
</cfquery>

<!--- Sayfa ana kısım  --->
<cf_catalystHeader>
	<div class="col col-9 col-xs-12">
		<!---Geniş alan: içerik--->
		<cf_box
			id = "list_quiz_questions"
			title="#getLang('','Sınav Adı',62825)#: #DecodeForHTML(get_quiz.quiz_head)#" 
			add_href="javascript:openBoxDraggable('#request.self#?fuseaction=training_management.popup_form_add_question&quiz_id=#get_quiz.quiz_id#&training_id=#get_quiz.training_id#&training_sec_id=#get_quiz.training_sec_id#&training_cat_id=#get_quiz.training_cat_id#')"
			info_href="javascript:openBoxDraggable('#request.self#?fuseaction=training_management.popup_list_questions&quiz_id=#get_quiz.quiz_id#&training_id=#get_quiz.training_id#&training_sec_id=#get_quiz.training_sec_id#&training_cat_id=#get_quiz.training_cat_id#','add_question_to_quiz','ui-box-draggable-medium')"
			box_page="#request.self#?fuseaction=training_management.list_quizs&event=listQuestions&quiz_id=#get_quiz.quiz_id#">
			
		</cf_box>
	</div>
<div class="col col-3 col-xs-12">
		<!--- Yan kısım--->
	<cf_box>
		<cf_ajax_list>
			<tbody>
				<tr>
					<td width="75" class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
					<td><cfoutput>#training_cat#</cfoutput></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='583.Bölüm'></td>
					<td><cfoutput>#training_sec#</cfoutput></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='68.Konu'></td>
					<td><cfoutput>#training#</cfoutput></td>
				</tr>
				<cfif get_quiz.timing_style eq 1>
					<tr>
						<td class="txtbold"><cf_get_lang no='87.Toplam Süre'></td>
						<td><cfoutput>#get_quiz.total_time#</cfoutput> <cf_get_lang_main no='715.dakika'></td>
					</tr>
				</cfif>
				<cfinclude template="../query/get_quiz_join_count.cfm">
				<cfinclude template="../query/get_quiz_winner_count.cfm">
				<tr>
					<td class="txtbold"><cf_get_lang_main no='1573.Toplam Puan'></td>
					<td><cfoutput>#get_quiz.total_points#</cfoutput></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang no='88.İlk Katılım'></td>
					<td><cfoutput>#dateformat(get_quiz.quiz_startdate,dateformat_style)#</cfoutput></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang no='89.Son Katılım'></td>
					<td><cfoutput>#dateformat(get_quiz.quiz_finishdate,dateformat_style)#</cfoutput></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='1978.Hazırlayan'></td>
					<td>
						<cfif len(get_quiz.record_emp)>
							<cfoutput> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#get_quiz.record_emp#','project');" class="tableyazi">#get_emp_info(get_quiz.record_emp,0,0)#</a></cfoutput>
								<cfelseif len(get_quiz.record_par)>
							<cfoutput> <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_quiz.record_par#','medium');" class="tableyazi">#get_partner.company_partner_name# #get_partner.company_partner_surname#</a></cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="txtbold" colspan="2">
						<cf_get_lang_main no='71.Kayıt'> : 
						<cfoutput>#dateformat(get_quiz.record_date,dateformat_style)#</cfoutput>
					</td>
				</tr>
			</tbody>
		</cf_ajax_list>
	</cf_box>
	<cf_box closable="0" title="#getLang('training_management',90)#">
		<script src="JS/Chart.min.js"></script>
		<canvas id="myChart" style="height:100%"></canvas>
		<script>
		var ctx = document.getElementById('myChart');
			var myChart = new Chart(ctx, {
			type: 'doughnut',
			data: {
				labels: [ <cfoutput>"#getLang('training_management',505)#","#getLang('training_management',506)#"</cfoutput>],
				datasets: [{
				label: "Series 1",
				backgroundColor: [<cfloop from="1" to="2" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
				data: [<cfoutput>"#get_quiz_winner_count.total_winners#","#evaluate(get_quiz_join_count.total_attends-get_quiz_winner_count.total_winners)#"</cfoutput>],
				}]
			},
			options: {}
		});
		</script>	
	</cf_box>
</div>