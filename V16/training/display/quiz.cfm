<cfinclude template="../query/get_quiz.cfm">
<cfset attributes.names = 1>
<cfif len(get_quiz.training_cat_id)>
	<cfset attributes.training_cat_id = get_quiz.training_cat_id>
	<cfinclude template="../query/get_training_cat.cfm">
</cfif>
<cfif len(get_quiz.training_id)>
	<cfset attributes.train_id = get_quiz.training_id>
	<cfinclude template="../query/get_training_subject.cfm">
</cfif>
<cfif len(get_quiz.RECORD_par)>
	<cfset attributes.partner_id = get_quiz.RECORD_PAR>
	<cfinclude template="../query/get_partner.cfm">
</cfif>
<cfinclude template="../query/get_quiz_questions.cfm">
<cfinclude template="../query/get_user_join_quiz.cfm">
<!--- Sayfa başlığı ve ikonlar --->
<table class="dph">
	<tr>
		<td class="dpht">
			<cf_get_lang_main no='1414.Test'>: <cfoutput>#get_quiz.quiz_head#</cfoutput>
		</td>
		<td class="dphb">
			 <cfif (get_quiz_questions.recordcount) AND (get_user_join_quiz.recordcount LT get_quiz.take_limit) and ((dateformat(get_quiz.quiz_startdate,"yyyymmdd") lte dateformat(now(),"yyyymmdd")) and (dateformat(get_quiz.quiz_finishdate,"yyyymmdd") gte dateformat(now(),"yyyymmdd")))>
			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_make_quiz&quiz_id=#attributes.quiz_id#</cfoutput>','list');"><img src="/images/quiz.gif"  title="<cf_get_lang no='34.Sınavı Başlat'>" border="0"></a>
			</cfif>
			  <cf_np tablename="quiz" primary_key="quiz_id" pointer="quiz_id=#quiz_id#" where="QUIZ_DEPARTMENTS IS NOT NULL">
		</td>
	</tr>
</table>
<!--- Sayfa ana kısım  --->
<table class="dpm">
	<tr>
		<td valign="top">
			<!---Geniş alan: içerik--->
            <cf_form_box width="100%"> 
                <table>
                    <tr>
                        <td class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
                        <td><cfif len(get_quiz.training_cat_id)>
                            <cfoutput>#get_training_cat.training_cat#</cfoutput></cfif>
                        </td>
                    </tr>
                    <tr> 
                        <td class="txtbold"><cf_get_lang_main no='68.Konu'></td>
                        <td><cfif len(get_quiz.training_id)>
                          <cfoutput>#get_training_subject.train_head#</cfoutput></cfif>
                        </td>
                    </tr>
                    <cfif get_quiz.timing_style eq 1>
                        <tr> 
                            <td class="txtbold"><cf_get_lang no='28.Toplam Süre'></td>
                            <td><cfoutput>#get_quiz.total_time#</cfoutput> <cf_get_lang_main no='1415.dk'></td>
                        </tr>
                    </cfif>
                    <cfif len(get_quiz.max_questions)>
                        <tr>
                            <td class="txtbold"><cf_get_lang no='29.Toplam Soru Sayısı'></td>
                            <td><cfoutput>#get_quiz.max_questions#</cfoutput></td>
                        </tr>
                    </cfif>
                    <cfinclude template="../query/get_quiz_join_count.cfm"> 
                    <cfinclude template="../query/get_quiz_winner_count.cfm"> 
                    <tr>
                        <td class="txtbold"><cf_get_lang_main no='1573.Toplam Puan'></td>
                        <td><cfoutput>#get_quiz.total_points#</cfoutput></td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang no='32.İlk Katılım'></td>
                        <td><cfoutput>#dateformat(get_quiz.quiz_startdate,dateformat_style)#</cfoutput></td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang no='31.Son Katılım'></td>
                        <td><cfoutput>#dateformat(get_quiz.quiz_finishdate,dateformat_style)#</cfoutput></td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang_main no='1978.Hazırlayan'></td>
                        <td><cfif len(get_quiz.record_emp)>
                                <cfoutput>#get_emp_info(get_quiz.record_emp,0,0)#</cfoutput>
                            <cfelseif len(get_quiz.record_par)>
                                <cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput>
                            </cfif>
                        </td>
                    </tr>
                   </table><br />
                   <cf_form_box_footer>
                   		<cf_record_info query_name="get_quiz">
                   </cf_form_box_footer>
            </cf_form_box>
		</td>
		<td valign="top" class="dpmr">
			<!--- Yan kısım--->
           <cf_box title="#getLang('training',33)#" closable="0">   <!---Başarım--->
               <cf_ajax_list>
  <thead>
                        <tr>
                                <cfsavecontent variable="message"><cf_get_lang no ='155.Başarılılar'></cfsavecontent>
                                <cfsavecontent variable="message1"><cf_get_lang no ='156.Başarısızlar'></cfsavecontent>
                            <th bgcolor="#FFFFFF">
                                
                            <script src="JS/Chart.min.js"></script>
                            <canvas id="myChart" style="height:100%;"></canvas>
                            <script>
                                var ctx = document.getElementById('myChart');
                                    var myChart = new Chart(ctx, {
                                        type: 'doughnut',
                                        data: {
                                            labels: [<cfoutput>"#message#","#message1#"</cfoutput>],
                                            datasets: [{
                                                label: "basarim grafigi",
                                                backgroundColor: ['rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)','rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',],
                                                data: [<cfoutput>"#get_quiz_winner_count.total_winners#","#evaluate(get_quiz_join_count.total_attends-get_quiz_winner_count.total_winners)#"</cfoutput>],
                                            }]
                                        },
                                        options: {}
                                });
                            </script>	

                            </th>
                        </tr>
                    </thead>
                </cf_ajax_list> 
            </cf_box>
		</td>
	</tr>
</table>
