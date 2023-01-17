<cfset cfc= createObject("component","V16.training_management.cfc.TrainingTest")>
<cfset GET_QUIZ=cfc.GET_QUIZS_FUNC(quiz_id:url.quiz_id)>
<cfset get_quiz_question_count=cfc.GET_QUIZ_QUESTIONS(quiz_id:url.quiz_id)>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset get_quiz_results =cfc.GET_QUIZ_RESULTS_FUNC(quiz_id:url.quiz_id)>
<cfset get_quiz_right_sum =cfc.GET_QUIZ_RIGHT_SUM_FUNC(quiz_id:url.quiz_id)>
<cfset get_quiz_right_sum_1 =cfc.GET_QUIZ_RIGHT_SUM_FUNC(quiz_id:url.quiz_id,
user_point:iif(isdefined("get_quiz.quiz_average"),"get_quiz.quiz_average",DE("")))>
<cfparam name="attributes.totalrecords" default=#get_quiz_results.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_QUESTIONS" datasource="#dsn#">
	SELECT DISTINCT
		QRD.QUESTION_RIGHTS,
		Q.QUESTION_ID,
		Q.QUESTION,
		Q.TRAINING_ID,
		Q.TRAINING_SEC_ID,
		Q.TRAINING_CAT_ID,
		Q.RECORD_EMP,
		Q.RECORD_PAR,
		Q.RECORD_DATE
	FROM 
		QUIZ_QUESTIONS QQ
			INNER JOIN QUESTION Q ON Q.QUESTION_ID = QQ.QUESTION_ID
			LEFT JOIN QUIZ_RESULTS_DETAILS QRD ON QRD.QUESTION_ID = QQ.QUESTION_ID
	WHERE
		QQ.QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
</cfquery>

<cf_catalystHeader>
<div class="row">
	<div class="col col-9 col-xs-12 uniqueRow"><!--- Sayfa ana kısım  --->
		<cf_box  title="#DecodeForHTML(get_quiz.quiz_head)#" closable="0">
			<!---Geniş alan: içerik---> 
			<cf_box_elements>
				<cfif isDefined("session.quiz_start")>
					<font color="red"><cf_get_lang no='107.Sınavınızı bitirmeden çıktığınız için boş kağıt vermiş sayıldınız'>!</font>
					<cfscript>
						structDelete(session,"quiz_start");
						structDelete(session,"result_id");
						structDelete(session,"quiz_id");
						if (isDefined("session.random_list"))
						{
							structdelete(session,"random_list");
						}
					</cfscript>
				</cfif>
				<cfif get_quiz_question_count.counted LT get_quiz.max_questions>
					<cfset question_limit = get_quiz_question_count.counted>
				<cfelse>
					<cfset question_limit = get_quiz.max_questions>
				</cfif>
				<div class="col col-12 col-md-12 col-xs-12">
					<div class="ui-info-bottom">
						<table>
							<tr>
								<td class="txtbold"><cf_get_lang no='63.Başarı Sınır Puanı'>:</td>
								<td width="50"><cfoutput>#get_quiz.quiz_average#</cfoutput></td>
								<td class="txtbold"><cf_get_lang no='60.Toplam Soru'>:</td>
								<td width="50"><cfoutput>#question_limit#</cfoutput></td>
								<td class="txtbold"><cf_get_lang no='108.Doğru Cevap Ortalaması'>:</td>
								<td><cfoutput>#get_quiz_right_sum.right_sum#</cfoutput></td>
							</tr>
						</table>
					</div>
				</div>
				<cf_grid_list>
					<thead>
						<tr>
							<th width="40"><cf_get_lang_main no='1165.Sıra'></th>
							<th><cf_get_lang_main no='1983.Katılımcı'></th>
							<th style="text-align:center" width="80"><cf_get_lang no='60.Toplam Soru'></th>
							<th style="text-align:center" width="40"><cf_get_lang dictionary_id="46258.Doğru"></th>
							<th style="text-align:center" width="40"><cf_get_lang dictionary_id='46058.Yanlış'></th>
							<th style="text-align:center" width="40"><cf_get_lang_main no='1572.Puan'></th>
							<!----<th width="90"><cf_get_lang no='84.Açık Uçlu Soru'></th>---><!--- kapatıldı daha sonra düzenleme yapılabilir.SG 20120718 --->
							<th width="15"><i class="fa fa-bar-chart"></i></th>
						</tr>
					</thead>
					<tbody>
					<cfif get_quiz_results.recordcount>
						<cfoutput query="get_quiz_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td style="text-align:center">#currentrow#</td>
							<td>
							<cfif type is 'employee'>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#user_id#','project');" class="tableyazi">
							<cfelseif type is 'partner'>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#user_id#','medium');" class="tableyazi">
							</cfif>	
								#ad# #soyad#
								</a>
							</td>
							<td style="text-align:center">#question_count#</td>
							<td style="text-align:center">#user_right_count#</td>
							<td style="text-align:center">#user_wrong_count#</td>
							<td style="text-align:center">#user_point#</td>
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training.popup_user_quiz_result&result_id=#result_id#','user_quiz_result_box', 'ui-draggable-box-medium');"><i class="fa fa-bar-chart"></i></a></td>
							<!---<td><a href="#request.self#?fuseaction=training_management.form_read_result&result_id=#result_id#&quiz_id=#quiz_id#"><img src="/images/quiz.gif" border="0" title="<cf_get_lang no='151.Not Ver'>"></a></td>--->
						</tr>
						</cfoutput>
						<cfelse>
						<tr height="20" class="color-row">
							<td colspan="9"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
					</tbody>
					<cfif get_quiz_results.recordcount and (attributes.totalrecords gt attributes.maxrows)>
						<cf_paging
							page="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="training_management.quiz_results&quiz_id=#attributes.quiz_id#">
					</cfif>
				</cf_grid_list>
			</cf_box_elements>
		</cf_box>
		<cf_box title="#getLang('','Sorular',58087)#">
			<cf_flat_list>
				<thead>
					<tr>
						<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th><cf_get_lang dictionary_id='58810.Soru'></th>
						<th><cf_get_lang dictionary_id='46053.Doğru Cevap'></th>
						<th><cf_get_lang dictionary_id='46269.Yanlış Cevap'></th>
						<th><cf_get_lang dictionary_id='62838.Toplam Cevap'></th>
						<th>% <cf_get_lang dictionary_id='46053.Doğru Cevap'></th>
						<th><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.popup_form_add_question')"><i class="fa fa-plus" alt="" ></i></a></th>
					</tr>
				</thead>
				<tbody>
				
					<cfif get_questions.recordcount>
						<cfoutput query="get_questions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td width="35">#currentrow#</td>
								<td height="22"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_form_upd_question&question_id=#question_id#');" class="tableyazi">#left(QUESTION,100)#</a></td>
								<td style="text-align:center">
									<cfif QUESTION_RIGHTS gt 0>
										#QUESTION_RIGHTS#
									<cfelse>
										0
									</cfif>
								</td>
								<td style="text-align:center">
									#val(get_quiz_results.question_count) - val(QUESTION_RIGHTS)#
								</td>
								<td style="text-align:center">
									#get_quiz_results.question_count#
								</td>
								<td style="text-align:center">
									<cfif get_quiz_results.question_count gt 0>
										% #100 * val(QUESTION_RIGHTS) / val(get_quiz_results.question_count)#
									<cfelse>
										0
									</cfif>
								</td>
								<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_form_upd_question&question_id=#question_id#')"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
						</tr>
					</cfif>
				</tbody>
			</cf_flat_list>

			<cfset url_str = "">
			<cfif get_questions.recordcount gt 0 and (attributes.totalrecords gt attributes.maxrows)>
				<cfif len(attributes.keyword)>
					<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
				</cfif>
				<cfif len(attributes.form_submitted)>
					<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
				</cfif>
				<cfif isdefined("attributes.training_sec_id")>
				<cfset url_str = "#url_str#&training_sec_id=#training_sec_id#">
				<cfelse>
					<cfset attributes.training_sec_id = 0>
				</cfif>
				<cfif isdefined("attributes.training_cat_id")>
				<cfset url_str = "#url_str#&training_cat_id=#training_cat_id#">
				<cfelse>
					<cfset attributes.training_cat_id = 0>
				</cfif>
				<cfif isdefined("attributes.training_subject_id")>
				<cfset url_str = "#url_str#&training_subject_id=#training_subject_id#">
				<cfelse>
					<cfset attributes.training_subject_id = 0>
				</cfif>
				<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="training_management.list_questions#url_str#"></td>
			</cfif>
		</cf_box>
	</div>
	<div class="col col-3 col-xs-12"><!--- Yan kısım--->
		<cf_box closable="0" title="#getLang('training_management',90)#">
			<cf_form_list>
				<cfif get_quiz_results.recordcount neq 0>
					<script src="JS/Chart.min.js"></script>
					<canvas id="myChart" style="height:100%;Width:100%;"></canvas>
					<script>
						var ctx = document.getElementById('myChart');
							var myChart = new Chart(ctx, {
							type: 'doughnut',
							data: {
								labels: [ <cfoutput>"#getLang('training_management',505)#","#getLang('training_management',506)#"</cfoutput>],
								datasets: [{
								label: "Series 1",
								backgroundColor: [<cfloop from="1" to="2" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
								data: [<cfoutput>"#get_quiz_right_sum_1.total_winners#","#evaluate(get_quiz_right_sum.total_attends-get_quiz_right_sum_1.total_winners)#"</cfoutput>],
								}]
							},
							options: {}
						});
					</script>					
				</cfif>				
			</cf_form_list>
		</cf_box>
	</div>	
</div>