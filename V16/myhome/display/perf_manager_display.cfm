<!--- Bu sayfanın aynısı hr displayde de var degisikliklerin ordada yapilmasi gerekiyor--->
<cfinclude template="../query/get_perf_detail.cfm">
<cfscript>
	attributes.emp_id = get_perf_detail.emp_id;
	attributes.employee_id = get_perf_detail.emp_id;
	attributes.quiz_id = get_perf_detail.quiz_id;
	quiz_id = get_perf_detail.quiz_id;
	//attributes.position_id = get_perf_detail.position_id;
	attributes.position_name = get_perf_detail.EMP_POSITION_NAME;
	attributes.employee_name = get_perf_detail.employee_name;
	attributes.employee_surname = get_perf_detail.employee_surname;
</cfscript>
<cfinclude template="../query/get_quiz_info.cfm">
<cfinclude template="../query/get_emp_quiz_answers.cfm">
<cfset chapter_not_gd='1205,1206,1207,1208,1201,1202,1203,1204,1193,1194,1195,1196,1189,1190,1191,1192,1169,1170,1171,1172,1197,1198,1199,1200,1182,1183,1184,1186,1178,1179,1180,1185'>
  <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td class="headbold"><cf_get_lang dictionary_id ='31927.Görüş Bildiren Değerlendirme'></td>
    <!-- sil -->  <td  style="text-align:right;"><cf_workcube_file_action pdf="0" print="1" mail="0"> </td><!-- sil -->
    </tr>
  </table>
  
  <table width="98%" align="center" cellpadding="0" cellspacing="0">
    <tr>
     <td valign="top">

              <table width="98%" cellspacing="1" cellpadding="2" class="color-border" align="center">
                <tr class="color-row">
                  <td height="22" class="txtboldblue"><cf_get_lang dictionary_id='57629.Açıklama'>/<cf_get_lang dictionary_id ='31420.Örnek Olaylar: Bekleneni Karşılıyor (3) dışında değerlendirdiğiniz davranış ifadeleri için Açıklama kısımlarını doldurunuz'></td>
                </tr>
                <tr>
                  <td class="color-row"><table>
                      <tr>
                        <td width="100"><cf_get_lang dictionary_id='57576.Çalışan'> </td>
                        <td width="200"><cfoutput>#attributes.employee_name# #attributes.employee_surname#</cfoutput></td>
						<cfif get_quiz_info.is_manager_1 is 1>
						<td width="100">1.<cf_get_lang dictionary_id='29666.Amir'></td>
						<td><cfif len(get_perf_detail.MANAGER_1_EMP_ID)><cfoutput>#GET_EMP_MANG_1.employee_name# #GET_EMP_MANG_1.employee_surname#</cfoutput></cfif></td>
						</cfif>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id='58497.Pozisyon'></td>
                        <td><cfoutput>#attributes.position_name#</cfoutput></td>
						<cfif get_quiz_info.is_manager_2 is 1>
						<td>2.<cf_get_lang dictionary_id='29666.Amir'></td>
						<td><cfif len(get_perf_detail.MANAGER_2_EMP_ID)><cfoutput>#GET_EMP_MANG_2.employee_name# #GET_EMP_MANG_2.employee_surname#</cfoutput></cfif></td>
						</cfif>
 	                  </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id='58472.Dönem'>*</td>
                        <td><cfoutput>#DateFormat(get_perf_detail.start_date,dateformat_style)#	- #DateFormat(get_perf_detail.finish_date,dateformat_style)#</cfoutput></td>
						<cfif get_quiz_info.is_manager_3 is 1>
						<td><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td>
						<td><cfif len(get_perf_detail.MANAGER_3_EMP_ID)><cfoutput>#GET_EMP_MANG_3.employee_name# #GET_EMP_MANG_3.employee_surname#</cfoutput></cfif></td>
						</cfif>
			          </tr>
                      <tr>
						<td><cf_get_lang dictionary_id ='31401.Değerlendirme Tarihi'></td>
						<td><cfoutput>#DateFormat(get_perf_detail.eval_date,dateformat_style)#</cfoutput>
					  </tr>
					  <tr>
                        <td colspan="4">
						<cf_get_lang dictionary_id='57483.Kayıt'>: <cfoutput>#get_emp_info(ListLast(GET_PERF_DETAIL.RECORD_KEY,'-'),0,0)# #DateFormat(date_add('h',session.ep.time_zone,GET_PERF_DETAIL.RECORD_DATE),dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,GET_PERF_DETAIL.RECORD_DATE),'HH:mm:ss')#</cfoutput>
					  	&nbsp;<cfif len(GET_PERF_DETAIL.UPDATE_KEY)>
						<cf_get_lang dictionary_id ='57703.Güncelleme'>: 
						<cfoutput>#get_emp_info(ListLast(GET_PERF_DETAIL.UPDATE_KEY,'-'),0,0)# #DateFormat(date_add('h',session.ep.time_zone,GET_PERF_DETAIL.UPDATE_DATE),dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,GET_PERF_DETAIL.UPDATE_DATE),'HH:mm:ss')#</cfoutput>
						</cfif>
						</td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <!--- seçilen form --->
<cfinclude template="../query/get_quiz_chapters.cfm">
<cfif get_quiz_chapters.recordcount>
  <cfoutput query="get_quiz_chapters">
	  <cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
	  <cfset attributes.CHAPTER_ID = CHAPTER_ID>
	  <cfquery name="chapter_exp_#get_quiz_chapters.currentrow#" datasource="#dsn#">
		SELECT EXPLANATION,MANAGER_EXPLANATION,EXPLANATION1,EXPLANATION2,EXPLANATION3,EXPLANATION4 FROM EMPLOYEE_QUIZ_CHAPTER_EXPL WHERE CHAPTER_ID=#CHAPTER_ID# AND RESULT_ID=<cfif isdefined('GET_PERF_DETAIL.RESULT_ID')and len(GET_PERF_DETAIL.RESULT_ID)>#GET_PERF_DETAIL.RESULT_ID#<cfelse>#GET_APP_PERF_DETAIL.RESULT_ID#</cfif>
	  </cfquery>
	  <cfscript>
		for (i=1; i lte 20; i = i+1)
			{
			"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
			"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
			"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
			}
	  </cfscript>
	  <tr class="color-list">
		<td>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr height="20">
			  <td class="txtboldblue"><cf_get_lang dictionary_id ='57995.Bölüm'>  #get_quiz_chapters.currentrow#: #chapter# </td>
			</tr>
			<cfif len(chapter_info)>
			  <tr height="20" class="color-list">
				<td> #chapter_info# </td>
			  </tr>
			</cfif>
		  </table>
		</td>
	  </tr>
	   <tr class="color-row">
  <td>
  <table width="100%" cellpadding="0" cellspacing="0">
  	<cfinclude template="../query/get_quiz_questions.cfm">
  	<cfif get_quiz_questions.recordcount>
	 <cfif not listfind(chapter_not_gd,attributes.CHAPTER_ID,',')>
  <tr class="color-row">
    <td>
      <table border="0">
        <tr class="color-list" align="center">
          <td> </td>
		   <td class="txtbold" width="30">GD</td>
          <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
          <cfif get_quiz_chapters.ANSWER_NUMBER neq 0>
            <cfloop from="1" to="20" index="i">
              <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                <td class="txtbold"> 
				#evaluate('answer#i#_text')# 
                  <cfif len(evaluate("answer"&i&"_photo"))>
                    <!---  <img src="#file_web_path#hr/#evaluate("answer"&i&"_photo")#" border="0"> --->
					 <cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1">
                  </cfif>
                  </td>
              </cfif>
            </cfloop>
          </cfif>
        </tr>
        <!--- Sorular basliyor --->
        <cfloop query="get_quiz_questions">
          <cfset q_id = get_quiz_questions.QUESTION_ID>
          <tr class="color-list" height="20">
            <td class="txtbold"><cfif get_quiz_info.IS_VIEW_QUESTION is 1>#get_quiz_questions.currentrow#-#get_quiz_questions.question#<cfelse>D-#get_quiz_questions.currentrow#</cfif>
			</td>
            <td class="txtboldblue" align="center">
			<cfloop query="GET_EMP_QUIZ_ANSWERS">
				<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and GET_EMP_QUIZ_ANSWERS.QUESTION_ID is q_id and GET_EMP_QUIZ_ANSWERS.MANAGER3_GD is 1>
					<!--- GD --->*
				</cfif>
			</cfloop>
			</td>
            <cfif ANSWER_NUMBER_gelen neq 0>
            <cfloop from="1" to="20" index="i">
              <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
                <td  align="center">
                 	<cfloop query="GET_EMP_QUIZ_ANSWERS">
						<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") and IsDefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id and GET_EMP_QUIZ_ANSWERS.MANAGER3_ANSWERS is i> * </cfif>
					</cfloop>
                </td>
              </cfif>
            </cfloop>
          </tr class="color-list">
          <cfelse>
          <td> </td>
          </tr>
          <cfloop from="1" to="20" index="i">
            <cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
              <tr class="color-list">
	            <td align="center">GD</td>
                <td>
					<cfloop query="GET_EMP_QUIZ_ANSWERS">
						<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and	isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and	GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id>
							#GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS#
						</cfif>
					</cfloop>
					#evaluate('get_quiz_questions.answer#i#_text')#
                  <cfif len(evaluate("answer"&i&"_photo"))>
                     <!--- <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0"> --->
					 <cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1">
                  </cfif>
                  <br/>
                </td>
              </tr>
            </cfif>
          </cfloop>
          </cfif>
          <cfif len(question_info)>
            <tr height="20">
              <td colspan="11">#get_quiz_questions.question_info#</td>
            </tr>
          </cfif>
        </cfloop>
		</cfif>
		<cfif get_quiz_chapters.is_emp_exp1 eq 1 and get_quiz_chapters.is_chief1_exp1 eq 1 and get_quiz_chapters.is_chief2_exp1 eq 1 and get_quiz_chapters.is_chief3_exp1 neq 1>
		<cfif (get_quiz_chapters.is_exp1 eq 1) and len(get_quiz_chapters.exp1_name)>
		<tr>
			<td colspan="11" valign="top">#get_quiz_chapters.exp1_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="11" valign="top">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION1")#</td>
		</tr>
		</cfif>
		</cfif>
		<cfif get_quiz_chapters.is_emp_exp2 eq 1 and get_quiz_chapters.is_chief1_exp2 eq 1 and get_quiz_chapters.is_chief2_exp2 eq 1 and get_quiz_chapters.is_chief3_exp2 neq 1>
		<cfif (get_quiz_chapters.is_exp2 eq 1) and len(get_quiz_chapters.exp2_name)>
		<tr>
			<td colspan="11" valign="top">#get_quiz_chapters.exp2_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="11" valign="top">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION2")#</td>
		</tr>
		</cfif>
		</cfif>
		<cfif get_quiz_chapters.is_emp_exp3 eq 1 and get_quiz_chapters.is_chief1_exp3 eq 1 and get_quiz_chapters.is_chief2_exp3 eq 1 and get_quiz_chapters.is_chief3_exp3 neq 1>
		<cfif (get_quiz_chapters.is_exp3 eq 1) and len(get_quiz_chapters.exp3_name)>
		<tr>
			<td colspan="11" valign="top">#get_quiz_chapters.exp3_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="11" valign="top">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION3")#</td>
		</tr>
		</cfif>
		</cfif>
		<cfif get_quiz_chapters.is_emp_exp4 eq 1 and get_quiz_chapters.is_chief1_exp4 eq 1 and get_quiz_chapters.is_chief2_exp4 eq 1 and get_quiz_chapters.is_chief3_exp4 neq 1>
		<cfif (get_quiz_chapters.is_exp4 eq 1) and len(get_quiz_chapters.exp4_name)>
		<tr>
			<td colspan="11" valign="top">#get_quiz_chapters.exp4_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="11" valign="top">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION4")#</td>
		</tr>
		</cfif>
		</cfif>
      </table>
    </td>
  </tr>
  </table>
  </td></tr>
  <cfelse>
  <tr height="20" class="color-row">
    <td><cf_get_lang dictionary_id ='31428.Kayıtlı Soru Bulunamadı'>!</td>
  </tr>
</cfif>
</cfoutput>
<cfelse>
<tr height="20" class="color-row">
  <td><cf_get_lang dictionary_id ='31429.Kayıtlı Bölüm Bulunamadı'>!</td>
</tr>
</cfif>
                <!--- görüşler --->
                <cfif get_quiz_info.is_opinion is 1>
				<tr class="color-list" height="22">
                  <td height="22" class="txtboldblue"><cf_get_lang dictionary_id ='30990.Genel Görüşler'></td>
                </tr>
                <tr>
                  <td class="color-row">
                    <table>
					  <tr>
                        <td><cf_get_lang dictionary_id ='31725.Görüş Bildirenin Görüş ve Düşünceleri'></td>
                      </tr>
                      <tr>
                        <td><cfoutput>#get_perf_detail.MANAGER_3_EVALUATION#</cfoutput></td>
                      </tr>
                    </table>
                  </td>
                </tr>
				</cfif>
                <!--- görüşler Bitti --->
				<cfif get_quiz_info.is_career is 1>
				<tr class="color-list" height="22">
					<td height="22" class="txtboldblue"><cf_get_lang dictionary_id ='31727.Kariyer Durumu'></td>
				</tr>
				<tr>
					<td class="color-row">
					<table id="b_carrer">
						<tr align="center" class="color-list">
							<td class="txtboldblue"><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td>
							<td>
							  <cfif get_perf_detail.manager_3_career_status eq 1><cf_get_lang dictionary_id ='31732.Bir Üst Görev İçin Uygun Değildir'>
							  <cfelseif get_perf_detail.manager_3_career_status eq 2><cf_get_lang dictionary_id ='31733.Bir Üst Görev İçin Henüz Yetişmektedir'>	
							  <cfelseif get_perf_detail.manager_3_career_status eq 3><cf_get_lang dictionary_id ='31734.Bir Üst Görev İçin Yetişmiştir'>	
							  <cfelseif get_perf_detail.manager_3_career_status eq 4><cf_get_lang dictionary_id ='31735.Bir Üst Göreve Yükseltilebilir'>
							  <cfelseif get_perf_detail.manager_3_career_status eq 5><cf_get_lang dictionary_id ='31736.Bir Üst Göreve Yükseltilmesi Gereklidir'>
							  </cfif>		
							</td>
						</tr>
						<tr class="color-list">
							<td class="txtboldblue"><cf_get_lang dictionary_id ='31728.Görüş Bildiren Açıklama'></td>
							<td colspan="3"><cfoutput>#get_perf_detail.manager_3_career_exp#</cfoutput></td>
						</tr>
					</table>
					</td>
				</tr>
				</cfif>
				<cfif get_quiz_info.is_training is 1>
				<tr class="color-list" height="22"  onClick="gizle_goster(b_gelisim);" style="cursor:pointer;">
					<td height="22" class="txtboldblue"><cf_get_lang dictionary_id ='31730.Gelişim'></td>
				</tr>
				<tr>
					<td class="color-row">
					<cfquery name="get_training_cat" datasource="#dsn#">
						SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
					</cfquery>
						<table id="b_gelisim">
							<tr class="color-list">
								<td class="txtbold"><cf_get_lang dictionary_id ='29912.Eğitimler'></td>
								<td class="txtbold" align="center"><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td>
							</tr>
							<cfoutput query="get_training_cat">
							<tr class="color-list">
								<td class="txtboldblue">#get_training_cat.training_cat#</td>
								<td align="center"><cfif listfind(get_perf_detail.manager_3_training_cat,get_training_cat.training_cat_id,',')>*</cfif></td>
							</tr>
							</cfoutput>
							<tr class="color-list">
								<td class="txtboldblue"><cf_get_lang dictionary_id ='31728.Görüş Bildiren Açıklama'></td>
								<td colspan="2"><cfoutput>#get_perf_detail.manager_3_training_exp#</cfoutput></td>
							</tr>
						</table>
					</td>
				</tr>
				</cfif>
              </table>
            </td>
          </tr>
        </table>
