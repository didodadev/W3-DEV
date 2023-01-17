<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_quiz_results.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" cellpadding="0" cellspacing="0" border="0" height="35" align="center">
  <tr>
    <td class="headbold"><cf_get_lang no='68.Testi Sonucu'>: <cfoutput><a href="#request.self#?fuseaction=training.quiz&quiz_id=#get_quiz.quiz_id#">#get_quiz.quiz_head#</a></cfoutput> </td>
    <td align="right" style="text-align:right;">
	<CF_NP tablename="QUIZ_RESULTS" primary_key="QUIZ_ID" pointer="QUIZ_ID=#QUIZ_ID#" where="EMP_ID = #session.ep.userid#"></td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" >
  <cfif isDefined("session.quiz_start")>
    <tr>
      <td> <font color="red"><cf_get_lang no='69.Sınavınızı bitirmeden çıktığınız için boş kağıt vermiş sayıldınız !'></font><br/>
        <cfscript>
		structDelete(session,"quiz_start");
		structDelete(session,"result_id");
		structDelete(session,"quiz_id");
		if (isDefined("session.random_list"))
			structdelete(session,"random_list");
		</cfscript>
      </td>
    </tr>
  </cfif>
  <tr>
    <td valign="top">
	
      <table width="98%" cellpadding="0" cellspacing="0" border="0">
        <tr class="color-border">
          <td>
            <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0">
              <tr height="20" class="color-row">
                <td colspan="8">
                  <table>
                    <cfif get_quiz_question_count.counted LT get_quiz.max_questions>
                      <cfset question_limit = get_quiz_question_count.counted>
                    <cfelse>
                      <cfset question_limit = get_quiz.max_questions>
                    </cfif>
                    <tr height="20">
                      <td class="txtbold"><cf_get_lang no='56.Toplam Soru'>:</td>
                      <td width="50"><cfoutput>#question_limit#</cfoutput></td>
                      <td class="txtbold"><cf_get_lang no='70.Doğru Cevap Ortalaması'>:</td>
                      <td><cfoutput>#get_quiz_right_sum.right_sum#</cfoutput></td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr class="color-header" height="22">
                <td width="50" class="form-title"><cf_get_lang_main no='1512.Sıralama'></td>
                <td width="75" class="form-title"><cf_get_lang no='60.Sınav Kağıdı'></td>
				<td class="form-title"><cf_get_lang_main no='1983.Katılımcı'></td>
                <td width="80" class="form-title"><cf_get_lang_main no='330.Tarih'></td>
                <td width="80" class="form-title"><cf_get_lang no='56.Toplam Soru'></td>
                <td width="50" class="form-title"><cf_get_lang no='57.Doğru'></td>
                <td width="50" class="form-title"><cf_get_lang no='58.Yanlış'></td>
                <td width="50" class="form-title"><cf_get_lang_main no='1572.Puan'></td>
              </tr>
              <cfif get_quiz_results_emp.recordcount>
                <cfoutput query="get_quiz_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
               <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>#currentrow#</td>
					<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_user_quiz_result&result_id=#result_id#','medium');"><img src="/images/file.gif" border="0"></a></td>
                    <td>
                      <cfif len(emp_id) and (emp_id neq session.ep.userid)>
							#get_emp_info(emp_id,0,1)#
                      <cfelseif len(emp_id) and (emp_id eq session.ep.userid)>
							#get_emp_info(emp_id,0,1)#
                      <cfelseif len(partner_id)>
                      <cfelseif len(partner_id)>
                        <cfset attributes.partner_id = partner_id>
                        <cfinclude template="../query/get_partner.cfm">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&partner_id=#attributes.partner_id#','medium');" class="tableyazi">#get_partner.company_partner_name# #get_partner.company_partner_surname#</a>
                      </cfif>
                    </td>
                    <td>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# (#TIMEFORMAT(date_add('h',session.ep.time_zone,RECORD_DATE),timeformat_style)#)</td>
                    <td>#question_count#</td>
                    <td>#user_right_count#</td>
                    <td>#user_wrong_count#</td>
                    <td>#user_point#</td>
                  </tr>
                </cfoutput>
              <cfelse>
                <tr height="20" class="color-row">
                  <td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
        <cfif get_quiz_results.recordcount and (attributes.totalrecords gt attributes.maxrows)>
            <tr>
              <td>
                <table width="100%">
                  <tr>
                    <td> <cf_pages
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="training.quiz_results&quiz_id=#attributes.quiz_id#"> </td>
                    <!-- sil --><td width="275" align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
                  </tr>
                </table>
              </td>
            </tr>
        </cfif>
      </table>
    </td>
    <td width="350">
      <!-- Grafik -->
            <table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
              <tr height="22" class="color-header">
                <td class="form-title"><cf_get_lang no='33.Başarım'></td>
              </tr>
              <tr class="color-row">
                <td align="center" height="300" bgcolor="#FFFFFF">
                
                  <script src="JS/Chart.min.js"></script>
									<canvas id="myChart" style="height:100%;Width:100%;"></canvas>
									<script>
									var ctx = document.getElementById('myChart');
										var myChart = new Chart(ctx, {
										type: 'bar',
										data: {
											labels: [ <cfoutput>"#getLang('training',155)#","#getLang('training',156)#"</cfoutput>],
											datasets: [{
											label: "Series 1",
											backgroundColor: [<cfloop from="1" to="2" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
											data: [<cfoutput>"#get_quiz_winner_count.total_winners#","#evaluate(get_quiz_join_count.total_attends-get_quiz_winner_count.total_winners)#"</cfoutput>],
											}]
										},
										options: {}
									});
									</script>	
                </td>
              </tr>
            </table>
      <br/>
      <!-- //Grafik -->
    </td>
  </tr>
</table>

