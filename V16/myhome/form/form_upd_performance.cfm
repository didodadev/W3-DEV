<cfinclude template="../query/get_perf_detail.cfm">
<cfscript>
	attributes.emp_id = get_perf_detail.emp_id;
	attributes.employee_id = get_perf_detail.emp_id;
	attributes.QUIZ_ID = get_perf_detail.QUIZ_ID;
	QUIZ_ID = get_perf_detail.QUIZ_ID;
	//PERIOD_ID = get_perf_detail.PERIOD_YEAR;
	//attributes.PERIOD_ID = get_perf_detail.PERIOD_YEAR;
	//attributes.PERIOD_YEAR = get_perf_detail.PERIOD_YEAR;
	attributes.POSITION_ID = get_perf_detail.POSITION_ID;
	attributes.POSITION_NAME = get_perf_detail.POSITION_NAME;
	attributes.EMPLOYEE_NAME = get_perf_detail.EMPLOYEE_NAME;
	attributes.EMPLOYEE_SURNAME = get_perf_detail.EMPLOYEE_SURNAME;
	//attributes.PERIOD_PART_ID = get_perf_detail.PERIOD_PART_ID;
	//attributes.PERIOD_PART_NAME = get_perf_detail.PERIOD_PART_NAME;
	attributes.start_date = dateformat(get_perf_detail.start_date,dateformat_style);
	attributes.finish_date = dateformat(get_perf_detail.finish_date,dateformat_style);
</cfscript>
<cfinclude template="../query/get_quiz_info.cfm">
<cfinclude template="../query/get_emp_quiz_answers.cfm">
<cffunction name="GETEMPNAME">
  <cfargument name="empid" type="numeric" required="true">
  <cfquery name="GET_EMP_NAME" datasource="#DSN#">
	  SELECT 
	  	EMPLOYEE_NAME, EMPLOYEE_SURNAME
	  FROM 
	  	EMPLOYEES
	  WHERE
	  	EMPLOYEE_ID = #empid#
   </cfquery>
   <cfreturn GET_EMP_NAME>
</cffunction>
<cffunction name="GETPOSNAME">
  <cfargument name="posid" type="numeric" required="true">
  <cfquery name="GET_POS_NAME" datasource="#DSN#">
	  SELECT 
	  	POSITION_NAME
	  FROM 
	  	EMPLOYEE_POSITIONS
	  WHERE
	  	POSITION_CODE = #posid#
   </cfquery>
   <cfreturn GET_POS_NAME>
</cffunction>
    <input type="hidden" name="valid1" id="valid1" value="">
    <input type="hidden" name="valid2" id="valid2" value="">
  <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td class="headbold"><cfoutput>#GET_QUIZ_INFO.QUIZ_HEAD#</cfoutput> <cf_get_lang no='219.Formu'></td>
	  <td  style="text-align:right;">
	  <CF_NP tablename="EMPLOYEE_PERFORMANCE" primary_key="per_id" pointer="per_id=#attributes.per_id#" where="emp_id=#session.ep.userid#"> </td>
    </tr>
  </table>
  
  
  <table width="98%" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td valign="top">
				<table width="98%" cellspacing="1" cellpadding="2" class="color-border" align="center">
                <tr class="color-row"> 
                  <td height="35" class="txtboldblue"><cf_get_lang no='220.Bu değerlendirme formu, değerlendirme yapılacak çalışanın yöneticileri tarafından yapılacaktır'>.</td>
                </tr>
                <tr> 
                  <td class="color-row"><table>
                    <tr>
                      <td width="100"><cf_get_lang_main no='164.Çalışan'> </td>
                      <td width="185"><cfoutput>#attributes.employee_name#
                          #attributes.employee_surname#</cfoutput>
                          <input type="hidden" name="EMP_ID2" id="EMP_ID2" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                      </td>
                      <td width="100">1.<cf_get_lang_main no='1869.Amir'></td>
                      <td>
                        <input name="MANAGER_1_POS_NAME" type="text" id="MANAGER_1_POS_NAME" style="width:150px;" value="<cfif len(GET_PERF_DETAIL.MANAGER_1_POS)><cfoutput>#GET_EMP_MANG_1.EMPLOYEE_NAME# #GET_EMP_MANG_1.EMPLOYEE_SURNAME#</cfoutput></cfif>">
                        <input type="hidden" name="MANAGER_1_POS" id="MANAGER_1_POS" value="<cfoutput>#GET_PERF_DETAIL.MANAGER_1_POS#</cfoutput>">
                      </td>
                    </tr>
                    <tr>
                      <td><cf_get_lang no='221.Pozisyonu'></td>
                      <td><cfoutput>#attributes.position_name#</cfoutput></td>
                      <cfif GET_PERF_DETAIL.VALID_1 EQ "">
                        <td><cf_get_lang no='223.Onay ve Tarih'></td>
                        <td> <cf_get_lang no='224.ONAY veya RED belirtilmemiş'>. </td>
                        <cfelse>
                        <td><cf_get_lang no='223.Onay ve Tarih'></td>
                        <td>
                          <cfif GET_PERF_DETAIL.VALID_1 EQ 1>
                            <cf_get_lang_main no='1287.Onaylandı'> - <cfoutput>#DateFormat(GET_PERF_DETAIL.VALID_1_DATE,dateformat_style)#
                              #TimeFORMAT(GET_PERF_DETAIL.VALID_1_DATE,timeformat_style)# </cfoutput><br/>
                                        <cf_get_lang no='225.Onaylayan'>:
                                        <cfelseif GET_PERF_DETAIL.VALID_1 EQ 0>
                                        <cf_get_lang_main no='205..Reddedildi'> - <cfoutput>#DateFormat(GET_PERF_DETAIL.VALID_1_DATE,dateformat_style)#
                                          #TimeFORMAT(GET_PERF_DETAIL.VALID_1_DATE,timeformat_style)# </cfoutput><br/>
                      <cf_get_lang no='226.Reddeden'>:
                          </cfif>
                          <cfoutput>#GETEMPNAME(GET_PERF_DETAIL.VALID_1_EMP).EMPLOYEE_NAME#
                            #GETEMPNAME(GET_PERF_DETAIL.VALID_1_EMP).EMPLOYEE_SURNAME# </cfoutput> </td>
                      </cfif>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='1060.Dönem'></td>
                        <td><cfoutput>#DateFormat(attributes.START_DATE,dateformat_style)# - #DateFormat(attributes.FINISH_DATE,dateformat_style)#</cfoutput>
                          <input type="hidden" name="start_date" id="start_date" value="<cfoutput>#DateFormat(attributes.start_date,dateformat_style)#</cfoutput>">
                          <input type="hidden" name="finish_date" id="finish_date" value="<cfoutput>#DateFormat(attributes.finish_date,dateformat_style)#</cfoutput>">
                        </td>
                      <td>2.<cf_get_lang_main no='1869.Amir'></td>
                      <td><input name="MANAGER_2_POS_NAME" type="text" id="MANAGER_2_POS_NAME" style="width:150px;" value="<cfif len(GET_PERF_DETAIL.MANAGER_2_POS)><cfoutput>#GET_EMP_MANG_2.EMPLOYEE_NAME# #GET_EMP_MANG_2.EMPLOYEE_SURNAME#</cfoutput></cfif>">
                          <input type="hidden" name="MANAGER_2_POS" id="MANAGER_2_POS" value="<cfoutput>#GET_PERF_DETAIL.MANAGER_2_POS#</cfoutput>">
                      </td>
                    </tr>
                    <cfif GET_PERF_DETAIL.VALID_2 EQ "">
                      <tr>
                        <td></td>
                        <td></td>
                        <td><cf_get_lang no='223.Onay ve Tarih'></td>
                        <td> <cf_get_lang no='224.ONAY veya RED belirtilmemiş'>.</td>
                      </tr>
                      <cfelse>
                      <tr>
                        <td></td>
                        <td></td>
                        <td><cf_get_lang no='223.Onay ve Tarih'></td>
                        <td>
                          <cfif GET_PERF_DETAIL.VALID_2 EQ 1>
                            <cf_get_lang_main no='1287.Onaylandı'> - <cfoutput>#DateFormat(GET_PERF_DETAIL.VALID_2_DATE,dateformat_style)#
                              #TimeFORMAT(GET_PERF_DETAIL.VALID_2_DATE,timeformat_style)# </cfoutput><br/>
							<cf_get_lang no='225.Onaylayan'>:
							<cfelseif GET_PERF_DETAIL.VALID_2 EQ 0>
							<cf_get_lang_main no='205.Reddedildi'> - <cfoutput>#DateFormat(GET_PERF_DETAIL.VALID_2_DATE,dateformat_style)#
							  #TimeFORMAT(GET_PERF_DETAIL.VALID_2_DATE,timeformat_style)# </cfoutput><br/>
                      		<cf_get_lang no='226.Reddeden'>:
                          </cfif>
                          <cfoutput>#GETEMPNAME(GET_PERF_DETAIL.VALID_2_EMP).EMPLOYEE_NAME#
                            #GETEMPNAME(GET_PERF_DETAIL.VALID_2_EMP).EMPLOYEE_SURNAME# </cfoutput> </td>
                      </tr>
                    </cfif>
                  </table></td>
                </tr>
				<!--- seçilen form --->
				<cfinclude template="../../hr/display/performance_quiz_upd.cfm">
                <!--- <cfinclude template="../../hr/query/act_quiz_perf_point.cfm"> --->
                <!--- görüşler --->
                <tr class="color-list" height="22"> 
                  <td height="22" class="txtboldblue"><cf_get_lang no='233.Genel Görüşler'></td>
                </tr>
                <tr> 
                  <td class="color-row"> <table>
                      <tr> 
                        <td><cf_get_lang no='234.Güçlü Yönleri'></td>
                      </tr>
                      <tr> 
                        <td><textarea name="POWERFUL_ASPECTS" id="POWERFUL_ASPECTS" style="width:300px;height:40px;"><cfoutput>#GET_PERF_DETAIL.POWERFUL_ASPECTS#</cfoutput> </textarea></td>
                      </tr>
                      <tr> 
                        <td><cf_get_lang no='235.Geliştirmesi Gereken Yönleri'></td>
                      </tr>
                      <tr> 
                        <td><textarea name="TRAIN_NEED_ASPECTS" id="TRAIN_NEED_ASPECTS" style="width:300px;height:40px;"><cfoutput>#GET_PERF_DETAIL.TRAIN_NEED_ASPECTS#</cfoutput> </textarea></td>
                      </tr>
                      <tr> 
                        <td><cf_get_lang no='236.İkinci Amirin Değerlendirmesi'></td>
                      </tr>
                      <tr> 
                        <td><textarea name="MANAGER_2_EVALUATION" id="MANAGER_2_EVALUATION" style="width:300px;height:40px;"><cfoutput>#GET_PERF_DETAIL.MANAGER_2_EVALUATION#</cfoutput> </textarea></td>
                      </tr>
                    </table></td>
                </tr>
                <!--- görüşler Bitti --->
                <!--- gelişme potansiyel --->
                <tr class="color-list" height="22"> 
                  <td height="22" class="txtboldblue"><cf_get_lang no='237.Alması Gereken Eğitimler'></td>
                </tr>
                <tr> 
                  <td class="color-row"> <table width="450">
                      <tr> 
                        <td>1- 
                          <input name="LUCK_TRAIN_SUBJECT_1" type="text" id="LUCK_TRAIN_SUBJECT_1" style="width:150px;" maxlength="125" value="<cfoutput>#GET_PERF_DETAIL.LUCK_TRAIN_SUBJECT_1#</cfoutput>"> 
                        <td>5- 
                          <input name="LUCK_TRAIN_SUBJECT_5" type="text" id="LUCK_TRAIN_SUBJECT_5" style="width:150px;" maxlength="125" value="<cfoutput>#GET_PERF_DETAIL.LUCK_TRAIN_SUBJECT_5#</cfoutput>">
                      </tr>
                      <tr> 
                        <td>2- 
                          <input name="LUCK_TRAIN_SUBJECT_2" type="text" id="LUCK_TRAIN_SUBJECT_2" style="width:150px;" maxlength="125" value="<cfoutput>#GET_PERF_DETAIL.LUCK_TRAIN_SUBJECT_2#</cfoutput>">
                        <td>6- 
                          <input name="LUCK_TRAIN_SUBJECT_6" type="text" id="LUCK_TRAIN_SUBJECT_6" style="width:150px;" maxlength="125" value="<cfoutput>#GET_PERF_DETAIL.LUCK_TRAIN_SUBJECT_6#</cfoutput>">
                      </tr>
                      <tr> 
                        <td>3- 
                          <input name="LUCK_TRAIN_SUBJECT_3" type="text" id="LUCK_TRAIN_SUBJECT_3" style="width:150px;" maxlength="125" value="<cfoutput>#GET_PERF_DETAIL.LUCK_TRAIN_SUBJECT_3#</cfoutput>">
                        <td>7- 
                          <input name="LUCK_TRAIN_SUBJECT_7" type="text" id="LUCK_TRAIN_SUBJECT_7" style="width:150px;" maxlength="125" value="<cfoutput>#GET_PERF_DETAIL.LUCK_TRAIN_SUBJECT_7#</cfoutput>">
                      </tr>
                      <tr> 
                        <td>4- 
                          <input name="LUCK_TRAIN_SUBJECT_4" type="text" id="LUCK_TRAIN_SUBJECT_4" style="width:150px;" maxlength="125" value="<cfoutput>#GET_PERF_DETAIL.LUCK_TRAIN_SUBJECT_4#</cfoutput>">
                        <td>8- 
                          <input name="LUCK_TRAIN_SUBJECT_8" type="text" id="LUCK_TRAIN_SUBJECT_8" style="width:150px;" maxlength="125" value="<cfoutput>#GET_PERF_DETAIL.LUCK_TRAIN_SUBJECT_8#</cfoutput>">
                      </tr>
                    </table></td>
                </tr>

				<tr class="color-header" height="22"> 
                  <td height="22" class="form-title"><cf_get_lang no='238.Genel Değerlendirme (İK Departmanı)'></tD>
                </tr>
                <tr class="color-header" height="22">
                  <td valign="top" class="color-row">
                    <table width="400">
                      <tr>
                        <td><cf_get_lang no='239.Toplam Puan / Aldığınız Puan'></td>
                        <td>
                          <input name="PERFORM_POINT" readonly="Yes" value="<cfoutput>#get_perf_detail.PERFORM_POINT#</cfoutput>" type="text" id="PERFORM_POINT" style="width:40px;">
                          /
                          <input name="USER_POINT" readonly="Yes" value="<cfoutput>#get_perf_detail.USER_POINT#</cfoutput>" type="text" id="USER_POINT" style="width:40px;">
                          <!--- <cfoutput>#quiz_point#</cfoutput> --->
                        </td>
                      </tr>
                      <tr>
                        <td><input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="1" <cfif get_perf_detail.PERFORM_POINT_ID IS 1>checked</cfif>>
                          <cf_get_lang no='240.Beklenenin Üstü'> (+) <br/>
                          <input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="2" <cfif get_perf_detail.PERFORM_POINT_ID IS 2>checked</cfif>>
                          <cf_get_lang no='240.Beklenenin Üstü'> (-) <br/>
                          <input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="3" <cfif get_perf_detail.PERFORM_POINT_ID IS 3>checked</cfif>>
                          <cf_get_lang no='241.Beklenen Düzey'> (+) <br/>
                          <input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="4" <cfif get_perf_detail.PERFORM_POINT_ID IS 4>checked</cfif>>
                          <cf_get_lang no='241.Beklenen Düzey'> <br/>
                          <input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="5" <cfif get_perf_detail.PERFORM_POINT_ID IS 5>checked</cfif>>
                          <cf_get_lang no='241.Beklenen Düzey'> (-) <br/>
                          <input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="6" <cfif get_perf_detail.PERFORM_POINT_ID IS 6>checked</cfif>>
                          <cf_get_lang no='242.Beklenenin Altı'> (+) <br/>
                          <input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="7" <cfif get_perf_detail.PERFORM_POINT_ID IS 7>checked</cfif>>
                          <cf_get_lang no='242.Beklenenin Altı'> (-) <br/>
                          <input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="8" <cfif get_perf_detail.PERFORM_POINT_ID IS 8>checked</cfif>>
                          <cf_get_lang no='243.Değerlendirilemedi'> </td>
                        <td></td>
                      </tr>
                    </table>
                  </td>
                </tr>

                <!--- gelişme potansiyel Bitti --->
                <!--- değerlendirilen görüşleri Bitti --->
              </table></td>
          </tr>
        </table></td>

      <!--- Sağ Taraf Başladı Artık --->
      <td width="325" valign="top"> <table cellSpacing="0" cellpadding="0" width="98%" border="0" align="center">
          <tr class="color-border"> 
            <td valign="top"> <table cellspacing="1" cellpadding="2" width="100%" border="0">
                <tr class="color-header" height="22"> 
                  <td height="22" class="form-title"><cf_get_lang no='228.Değerlendirilenin Görüşleri'></tD>
                </tr>
                <tr class="color-header" height="22"> 
                  <td valign="top" class="color-row"><table>
					 <cfform name="add_perform" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_performance">
				  		  <input type="hidden" name="EMP_ID" id="EMP_ID" value="<cfoutput>#attributes.employee_id#</cfoutput>">
						  <input type="hidden" name="start_date" id="start_date" value="<cfoutput>#DateFormat(attributes.start_date,dateformat_style)#</cfoutput>">
						  <input type="hidden" name="finish_date" id="finish_date" value="<cfoutput>#DateFormat(attributes.finish_date,dateformat_style)#</cfoutput>">
						  <input type="hidden" name="QUIZ_ID" id="QUIZ_ID" value="<cfoutput>#QUIZ_ID#</cfoutput>">
                      <tr> 
                        <td><textarea name="EMPLOYEE_OPINION" id="EMPLOYEE_OPINION" style="width:310px;height:125px;"><cfoutput>#GET_PERF_DETAIL.EMPLOYEE_OPINION#</cfoutput></textarea></td>
                      </tr>
                      <tr> 
                        <td><input name="EMPLOYEE_OPINION_ID" id="EMPLOYEE_OPINION_ID" type="radio" value="1" <cfif GET_PERF_DETAIL.EMPLOYEE_OPINION_ID IS 1>checked</cfif>>
                          <cf_get_lang no='229.Değerlendirmeye katılıyorum'></td>
                      </tr>
                      <tr> 
                        <td><input name="EMPLOYEE_OPINION_ID" id="EMPLOYEE_OPINION_ID" type="radio" value="0" <cfif GET_PERF_DETAIL.EMPLOYEE_OPINION_ID IS 0>checked</cfif>>
                          <cf_get_lang no='230.Değerlendirmeye katılmıyorum'></td>
                      </tr>
                      <tr> 
                        <td><cfif len(GET_PERF_DETAIL.EMPLOYEE_OPINION_DATE)>&nbsp;&nbsp;<cfoutput>#dateformat(GET_PERF_DETAIL.EMPLOYEE_OPINION_DATE,dateformat_style)# #TimeFORMAT(GET_PERF_DETAIL.EMPLOYEE_OPINION_DATE,timeformat_style)# - #GETEMPNAME(GET_PERF_DETAIL.EMPLOYEE_OPINION_EMP_ID).EMPLOYEE_NAME# #GETEMPNAME(GET_PERF_DETAIL.EMPLOYEE_OPINION_EMP_ID).EMPLOYEE_SURNAME# </cfoutput><cfelse>&nbsp;&nbsp;<cf_get_lang_main no='215.Kayıt Tarihi'> - <cf_get_lang_main no='487.Kaydeden'></cfif></td>
                      </tr>
						<tr> 
						  <td height="35" align="center" class="color-row"> 
						  <cf_workcube_buttons is_upd='0'>
						  </td>
						</tr>
					  </cfform>
                    </table></td>
                </tr>
              </table>
    </tr>
  </table>
<!--- </cfform> --->
<br/>


