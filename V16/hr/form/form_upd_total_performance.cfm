<cfinclude template="../query/get_total_performance.cfm">
<cfset attributes.employee_id = get_total_performance.EMP_ID>
<cfset employee_id = get_total_performance.EMP_ID>
<cfset firstdate = dateformat(get_total_performance.start_date,dateformat_style)>
<cfset lastdate = dateformat(get_total_performance.finish_date,dateformat_style)>
<cf_date tarih = 'firstdate'>
<cf_date tarih = 'lastdate'>
<cfinclude template="../query/get_total_perf_quizs.cfm">
<cfinclude template="../query/get_total_perf_targets.cfm">
<cffunction name="GETEMPNAME">
  <cfargument name="empid" type="numeric" required="true">
	  <cfquery name="GET_EMP_NAME" datasource="#dsn#">
		SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #EMPID#
	  </cfquery>
  <cfreturn get_emp_name>
</cffunction>
<cffunction name="GETPOSNAME">
  <cfargument name="posid" type="numeric" required="true">
	  <cfquery name="GET_POS_NAME" datasource="#dsn#">
		SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #POSID#
	  </cfquery>
  <cfreturn get_pos_name>
</cffunction>
<cfinclude template="../query/get_emp_chiefs.cfm">
<cfinclude template="../query/get_positions_notempty.cfm">
<!---

    <table class="dph">
  <tr>
    <td class="dpht"><cf_get_lang_main no='591.Performans'>: <cfoutput><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#attributes.employee_id#">#GETEMPNAME(attributes.employee_id).EMPLOYEE_NAME# #GETEMPNAME(attributes.employee_id).employee_surname#</a> (#get_positions.position_name#)</cfoutput> / <cfoutput>#DateFormat(firstdate,dateformat_style)# - #DateFormat(lastdate,dateformat_style)#</cfoutput></td>
  </tr>
</table>

--->


<cf_catalystHeader>
<cfform name="add_perform" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_total_performance">
    <div class="row">
        <div class="col col-12">
            <div class="row formContent" id="basket_main_div">
                <cf_basket_form id="form_add_assetp">
                    <div class="row" type="row">
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="blntfrt">
                                <label class="col col-4 col-xs-12"></label>
                                <div class="col col-8 col-xs-12">
                                </div>
                            </div>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="55119.Ölçme Değerlendirme Formları"></cfsavecontent>
                            <cf_seperator title="#message#" id="olcme_degerlendirme_formlari">
                                <table id="olcme_degerlendirme_formlari">
                                    <tr>
                                        <td>
                                            <cfif get_total_perf_quizs.recordcount>
                                                <cfoutput query="GET_TOTAL_PERF_QUIZS">
                                                    <cfif len(GET_TOTAL_PERF_QUIZS.MANAGER_1_POS)>
                                                        <cfquery name="GET_EMP_MANG_1" datasource="#dsn#">
                                                            SELECT EMPLOYEE_ID, POSITION_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #GET_TOTAL_PERF_QUIZS.MANAGER_1_POS#
                                                        </cfquery>
                                                    </cfif>
                                                    <cfif len(GET_TOTAL_PERF_QUIZS.MANAGER_2_POS)>
                                                        <cfquery name="GET_EMP_MANG_2" datasource="#dsn#">
                                                                SELECT EMPLOYEE_ID, POSITION_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #GET_TOTAL_PERF_QUIZS.MANAGER_2_POS#
                                                        </cfquery>
                                                    </cfif>
                                                    <cfset attributes.quiz_id = quiz_id>
                                                    <cfset attributes.survey_id = SURVEY_MAIN_ID>
                                                    <cfset attributes.RESULT_ID = SURVEY_MAIN_RESULT_ID>
                                                    <cfinclude template="../query/act_quiz_perf_point.cfm">
                                                        <table>  
                                                            <tr>
                                                                <td height="25" colspan="2" class="txtbold"><cf_get_lang dictionary_id='55608.Amirler ve Görüşleri'> : #GET_TOTAL_PERF_QUIZS.MANAGER_2_EVALUATION#</td>
                                                            </tr>
                                                            <tr>
                                                                <td width="200">
                                                                    <cfif len(GET_TOTAL_PERF_QUIZS.MANAGER_1_POS)>
                                                                        #GET_EMP_MANG_1.EMPLOYEE_NAME# #GET_EMP_MANG_1.EMPLOYEE_SURNAME#
                                                                    </cfif>
                                                                </td>
                                                                <td>:
                                                                <cfif Not Len (GET_TOTAL_PERF_QUIZS.VALID_1)><cf_get_lang dictionary_id='55528.Onay veya Red belirtilmemiş'>.
                                                                <cfelse>
                                                                <cfif GET_TOTAL_PERF_QUIZS.VALID_1 eq 1><cf_get_lang dictionary_id='58699.ONAYLANDI'> - #DateFormat(GET_TOTAL_PERF_QUIZS.VALID_1_DATE,dateformat_style)# #TimeFORMAT(GET_TOTAL_PERF_QUIZS.VALID_1_DATE,timeformat_style)#
                                                                <cfelseif GET_TOTAL_PERF_QUIZS.VALID_1 eq 0><cf_get_lang dictionary_id='57617.REDDEDİLDİ'> - #DateFormat(GET_TOTAL_PERF_QUIZS.VALID_1_DATE,dateformat_style)# #TimeFORMAT(GET_TOTAL_PERF_QUIZS.VALID_1_DATE,timeformat_style)#
                                                                </cfif>
                                                                    #GETEMPNAME(GET_TOTAL_PERF_QUIZS.VALID_1_EMP).EMPLOYEE_NAME# #GETEMPNAME(GET_TOTAL_PERF_QUIZS.VALID_1_EMP).EMPLOYEE_SURNAME#
                                                                </cfif>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td><cfif len(GET_TOTAL_PERF_QUIZS.MANAGER_2_POS)>#GET_EMP_MANG_2.EMPLOYEE_NAME# #GET_EMP_MANG_2.EMPLOYEE_SURNAME#</cfif></td>
                                                                <td>:
                                                                <cfif Not Len (GET_TOTAL_PERF_QUIZS.VALID_2)>
                                                                    <cf_get_lang dictionary_id='55528.Onay veya Red belirtilmemiş'>.
                                                                <cfelse>
                                                                <cfif GET_TOTAL_PERF_QUIZS.VALID_2 EQ 1>
                                                                    <cf_get_lang dictionary_id='58699.ONAYLANDI'> - #DateFormat(GET_TOTAL_PERF_QUIZS.VALID_2_DATE,dateformat_style)# #TimeFORMAT(GET_TOTAL_PERF_QUIZS.VALID_2_DATE,timeformat_style)#
                                                                <cfelseif GET_TOTAL_PERF_QUIZS.VALID_2 EQ 0>
                                                                    <cf_get_lang dictionary_id='57617.REDDEDİLDİ'> - #DateFormat(GET_TOTAL_PERF_QUIZS.VALID_2_DATE,dateformat_style)# #TimeFORMAT(GET_TOTAL_PERF_QUIZS.VALID_2_DATE,timeformat_style)##GET_EMP_MANG_2.EMPLOYEE_NAME#
                                                                </cfif>
                                                                    #GETEMPNAME(GET_TOTAL_PERF_QUIZS.VALID_2_EMP).EMPLOYEE_NAME# #GETEMPNAME(GET_TOTAL_PERF_QUIZS.VALID_2_EMP).EMPLOYEE_SURNAME#
                                                                </cfif>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td><cf_get_lang dictionary_id='55511.Güçlü Yönleri'></td>
                                                                <td>: #GET_TOTAL_PERF_QUIZS.POWERFUL_ASPECTS#</td>
                                                            </tr>
                                                            <tr>
                                                                <td><cf_get_lang dictionary_id='55512.Geliştirmesi Gereken Yönleri'></td>
                                                                <td>: #GET_TOTAL_PERF_QUIZS.TRAIN_NEED_ASPECTS#</td>
                                                            </tr>
                                                            <tr>
                                                                <td><cf_get_lang dictionary_id='55530.İkinci Amirin Değerlendirmesi'></td>
                                                                <td>: #GET_TOTAL_PERF_QUIZS.MANAGER_2_EVALUATION#</td>
                                                            </tr>
                                                    </table>
                                                    <table> 
                                                        <tr>
                                                        <td height="25" class="txtbold" colspan="2"><cf_get_lang dictionary_id='55531.Alması Gereken Eğitimler'></td>
                                                        </tr>
                                                        <cfloop from="1" to="8" index="train">
                                                        <cfif len(evaluate("GET_TOTAL_PERF_QUIZS.LUCK_TRAIN_SUBJECT_"&train))>
                                                            <tr>
                                                            <td> #train#- #evaluate("GET_TOTAL_PERF_QUIZS.LUCK_TRAIN_SUBJECT_"&train)# </td>
                                                            </tr>
                                                        </cfif>
                                                        </cfloop>
                                                    </table>
                                                    <table>
                                                        <tr>
                                                            <td height="25" class="txtbold" colspan="2"><cf_get_lang dictionary_id='55532.Genel Değerlendirme (İK Departmanı)'></td>
                                                        </tr>
                                                        <tr>
                                                            <td width="200"><cf_get_lang dictionary_id='57776.Toplam Puan / Kişinin Aldığı Puan'></td>
                                                            <td>: #GET_TOTAL_PERF_QUIZS.USER_POINT# / #GET_TOTAL_PERF_QUIZS.PERFORM_POINT# </td>
                                                        </tr>
                                                        <tr>
                                                            <td><cf_get_lang dictionary_id='57684.Sonuç'></td>
                                                            <td>: #get_total_perf_quizs.USER_POINT_OVER_5# / 5
                                                                <!--- 20051121 TolgaS eskiden kullanılan bir alanmış artık kullanılamdığı için kaldırıldı
                                                                <cfswitch expression = "#GET_TOTAL_PERF_QUIZS.PERFORM_POINT_ID#">
                                                                <cfcase value="1"><cf_get_lang no='450.Beklenenin Üstü'> (+)</cfcase>
                                                                <cfcase value="2"><cf_get_lang no='450.Beklenenin Üstü'> (-)</cfcase>
                                                                <cfcase value="3"><cf_get_lang no='452.Beklenen Düzey'> (+)</cfcase>
                                                                <cfcase value="4"><cf_get_lang no='452.Beklenen Düzey'></cfcase>
                                                                <cfcase value="5"><cf_get_lang no='452.Beklenen Düzey'>(-)</cfcase>
                                                                <cfcase value="6"><cf_get_lang no='455.Beklenenin Altı'> (+)</cfcase>
                                                                <cfcase value="7"><cf_get_lang no='455.Beklenenin Altı'> (-)</cfcase>
                                                                <cfcase value="8"><cf_get_lang no='462.Beklenenin'></cfcase>
                                                                </cfswitch> --->
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table>
                                                        <tr>
                                                        <td height="25" class="txtbold" colspan="2"><cf_get_lang dictionary_id='55534.Değerlendirilen Görüşleri'></td>
                                                        </tr>
                                                        <tr>
                                                        <td colspan="2">#GET_TOTAL_PERF_QUIZS.EMPLOYEE_OPINION# <b>
                                                            <cfif GET_TOTAL_PERF_QUIZS.EMPLOYEE_OPINION_ID IS 1><cf_get_lang dictionary_id='55543.Değerlendirmeye katılıyorum'>
                                                            <cfelseif GET_TOTAL_PERF_QUIZS.EMPLOYEE_OPINION_ID IS 0><cf_get_lang dictionary_id='55544.Değerlendirmeye katılmıyorum'>
                                                            </cfif>
                                                            </b>
                                                        </td>
                                                        </tr>
                                                        <cfif len(GET_TOTAL_PERF_QUIZS.EMPLOYEE_OPINION_DATE)>
                                                        <tr>
                                                            <td colspan="2">: #dateformat(GET_TOTAL_PERF_QUIZS.EMPLOYEE_OPINION_DATE,dateformat_style)# #TimeFORMAT(GET_TOTAL_PERF_QUIZS.EMPLOYEE_OPINION_DATE,timeformat_style)# - #GETEMPNAME(GET_TOTAL_PERF_QUIZS.EMPLOYEE_OPINION_EMP_ID).EMPLOYEE_NAME# #GETEMPNAME(GET_TOTAL_PERF_QUIZS.EMPLOYEE_OPINION_EMP_ID).EMPLOYEE_SURNAME#</td>
                                                        </tr>
                                                        <cfelse>
                                                        <tr>
                                                            <td class="txtbold" width="200"><cf_get_lang dictionary_id='55545.Kayıt Tarihi - Kaydeden'></td>
                                                            <td>: #dateformat(GET_TOTAL_PERF_QUIZS.record_date,dateformat_style)# - #get_emp_info(listlast(GET_TOTAL_PERF_QUIZS.record_key,'-'),0,0)#</td>
                                                        </tr>
                                                        </cfif>
                                                    </table>
                                                </cfoutput>
                                                <cfelse>
                                                    <table>
                                                        <tr>
                                                        <td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                                                        </tr>
                                                    </table>
                                            </cfif>
                                        </td>
                                    </tr>
                                </table>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="57964.Hedefler"></cfsavecontent>
                            <cf_seperator title="#message#" id="hedefler_">
                                <table id="hedefler_">
                                    <tr>
                                        <td>
                                        <cfif GET_TOTAL_PERF_TARGETS.recordcount>
                                        <cfoutput query="GET_TOTAL_PERF_TARGETS">
                                            <cfset targetcatid = GET_TOTAL_PERF_TARGETS.targetcat_id>
                                        <table>
                                            <tr>
                                            <td height="25" class="txtbold" colspan="2">#GET_TOTAL_PERF_TARGETS.target_head#</td>
                                            </tr>
                                            <tr>
                                            <td width="200" height="20" class="txtbold"><cf_get_lang dictionary_id='55763.Tarihler'></td>
                                            <td> #dateformat(GET_TOTAL_PERF_TARGETS.startdate,dateformat_style)# - #dateformat(GET_TOTAL_PERF_TARGETS.finishdate,dateformat_style)# 
                                            </tr>
                                            <tr>
                                            <td height="20" class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></td>
                                            <td> #GET_TOTAL_PERF_TARGETS.TARGETCAT_NAME# </td>
                                            </tr>
                                            <tr>
                                            <td valign="top" height="20" class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                                            <td>#GET_TOTAL_PERF_TARGETS.target_detail# </td>
                                            </tr>
                                            <tr>
                                            <td height="20" class="txtbold"><cf_get_lang dictionary_id='55486.Rakam'></td>
                                            <td>#GET_TOTAL_PERF_TARGETS.target_number# </td>
                                            </tr>
                                            <tr>
                                            <td valign="top" height="20" class="txtbold"><cf_get_lang dictionary_id='55607.Yöneticinin Görüşü (Sonuç)'></td>
                                            <td>#GET_TOTAL_PERF_TARGETS.PERFORM_COMMENT# -
                                            #get_total_perf_quizs.USER_POINT_OVER_5# / 5
                                            <!--- 20051121 TolgaS eskiden kullanılan bir alanmış artık kullanılamdığı için kaldırıldı
                                            <cfswitch expression = "#GET_TOTAL_PERF_TARGETS.PERFORM_POINT_ID#">
                                                <cfcase value="1"><cf_get_lang no='450.Beklenenin Üstü'> (+)</cfcase>
                                                <cfcase value="2"><cf_get_lang no='450.Beklenenin Üstü'> (-)</cfcase>
                                                <cfcase value="3"><cf_get_lang no='452.Beklenen Düzey'> (+)</cfcase>
                                                <cfcase value="4"><cf_get_lang no='452.Beklenen Düzey'></cfcase>
                                                <cfcase value="5"><cf_get_lang no='452.Beklenen Düzey'> (-)</cfcase>
                                                <cfcase value="6"><cf_get_lang no='455.Beklenenin Altı'> (+)</cfcase>
                                                <cfcase value="7"><cf_get_lang no='455.Beklenenin Altı'> (-)</cfcase>
                                                <cfcase value="8"><cf_get_lang no='462.Beklenenin'></cfcase>
                                                </cfswitch> --->
                                            </td>
                                            </tr>
                                        </table>
                                        </cfoutput> 
                                    <cfelse>
                                        <table>
                                            <tr>
                                                <td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                                            </tr>
                                        </table>
                                    </cfif>
                                        </td>
                                    </tr>
                                </table>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-12" type="column" index="2" sort="true">
                            <input type="hidden" name="PERFORMANCE_ID" id="PERFORMANCE_ID" value="<cfoutput>#GET_TOTAL_PERFORMANCE.PERFORMANCE_ID#</cfoutput>">
                            <input type="hidden" name="EMP_ID" id="EMP_ID" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                            <input type="hidden" name="start_date" id="start_date" value="<cfoutput>#DateFormat(firstdate,dateformat_style)#</cfoutput>">
                            <input type="hidden" name="finish_date" id="finish_date" value="<cfoutput>#DateFormat(lastdate,dateformat_style)#</cfoutput>">
                            <input type="hidden" name="TARGET_IDS" id="TARGET_IDS" value="<cfoutput>,#ValueList(get_total_perf_targets.TARGET_ID)#,</cfoutput>">
                            <input type="hidden" name="QUOTE_IDS" id="QUOTE_IDS" value="<cfoutput>,,</cfoutput>"><!--- #ValueList(get_total_perf_quotes.Q_ID)# --->
                            <input type="hidden" name="PER_IDS" id="PER_IDS" value="<cfoutput>,#ValueList(get_total_perf_quizs.PER_ID)#,</cfoutput>">
                            <div class="form-group" id="item-aciklama">
                                <label class="col col-12 formbold"><cf_get_lang dictionary_id='55557.Bu değerlendirme formu, değerlendirme yapılacak çalışanın yöneticileri tarafından yapılacaktır.'></label>
                            </div>
                            <div class="form-group" id="item-development_id1">
                                <label class="col-col-4 col-md-4 col-sm-6 col-xs-12 txtbold">
                                    <input name="DEVELOPMENT_ID" id="DEVELOPMENT_ID" type="radio" value="1" <cfif GET_TOTAL_PERFORMANCE.DEVELOPMENT_ID IS 1>checked</cfif>>
                                    <cf_get_lang dictionary_id='55558.Bir üst ünvana yükseltilmelidir'>.
                                </label>
                            </div>
                            <div class="form-group" id="item-POSSIBLE_PROMOTE_POS_NAME">
                                <label class="col col-6 col-md-4 col-sm-6 col-xs-12">
                                    <cf_get_lang dictionary_id='55559.Yükseltilebileceği ünvan'>
                                </label>
                                <div class="col col-6 col-md-8 col-sm-6 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="POSSIBLE_PROMOTE_POS" id="POSSIBLE_PROMOTE_POS" value="<cfoutput>#GET_TOTAL_PERFORMANCE.POSSIBLE_PROMOTE_POS#</cfoutput>">
                                        <input name="POSSIBLE_PROMOTE_POS_NAME" id="POSSIBLE_PROMOTE_POS_NAME" type="text" id="POSSIBLE_PROMOTE_POS_NAME" value="<cfif len(GET_TOTAL_PERFORMANCE.POSSIBLE_PROMOTE_POS)><cfoutput>#GETPOSNAME(GET_TOTAL_PERFORMANCE.POSSIBLE_PROMOTE_POS).POSITION_NAME#</cfoutput></cfif>">
                                        <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_pos_name=add_perform.POSSIBLE_PROMOTE_POS_NAME&field_code=add_perform.POSSIBLE_PROMOTE_POS&show_empty_pos=1','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-POSSIBLE_PROMOTE_TIME">
                                <label class="col col-6 col-md-4 col-sm-6 col-xs-12">
                                    <cf_get_lang dictionary_id='55560.Tahmini yükselme süresi (ay)'>
                                </label>
                                <div class="col col-6 col-md-8 col-sm-6 col-xs-12">
                                    <cfinput name="POSSIBLE_PROMOTE_TIME" type="text" id="POSSIBLE_PROMOTE_TIME" validate="integer" maxlength="2" message="Tahmini yükselme süresi (ay) !" value="#GET_TOTAL_PERFORMANCE.POSSIBLE_PROMOTE_TIME#">
                                </div>
                            </div>
                            <div class="form-group" id="item-MAX_POSSIBLE_PROMOTE_POS_NAME">
                                <label class="col col-6 col-md-4 col-sm-6 col-xs-12">
                                    <cf_get_lang dictionary_id='55561.Grup içinde yükselebileceği en yüksek ünvan'>
                                </label>
                                <div class="col col-6 col-md-8 col-sm-6 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="MAX_POSSIBLE_PROMOTE_POS" id="MAX_POSSIBLE_PROMOTE_POS" value="<cfoutput>#GET_TOTAL_PERFORMANCE.MAX_POSSIBLE_PROMOTE_POS#</cfoutput>">
                                        <input name="MAX_POSSIBLE_PROMOTE_POS_NAME" type="text" id="MAX_POSSIBLE_PROMOTE_POS_NAME" style="width:150px;" value="<cfif len(GET_TOTAL_PERFORMANCE.MAX_POSSIBLE_PROMOTE_POS)><cfoutput>#GETPOSNAME(GET_TOTAL_PERFORMANCE.MAX_POSSIBLE_PROMOTE_POS).POSITION_NAME#</cfoutput></cfif>">
                                        <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_pos_name=add_perform.MAX_POSSIBLE_PROMOTE_POS_NAME&field_code=add_perform.MAX_POSSIBLE_PROMOTE_POS&show_empty_pos=1','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-MAX_POSSIBLE_PROMOTE_TIME">
                                <label class="col col-6 col-md-4 col-sm-6 col-xs-12">
                                    <cf_get_lang dictionary_id='55562.Bu ünvana tahmini yükselme süresi'>
                                </label>
                                <div class="col col-6 col-md-8 col-sm-6 col-xs-12">
                                    <cfinput name="MAX_POSSIBLE_PROMOTE_TIME" type="text" id="MAX_POSSIBLE_PROMOTE_TIME" validate="integer" maxlength="2" message="Bu ünvana tahmini yükselme süresi !" value="#GET_TOTAL_PERFORMANCE.MAX_POSSIBLE_PROMOTE_TIME#">
                                </div>
                            </div>
                            <div class="form-group" id="item-development_id2">
                                <label class="col-col-4 col-md-4 col-sm-6 col-xs-12 txtbold">
                                    <input name="DEVELOPMENT_ID" id="DEVELOPMENT_ID" type="radio" value="2" <cfif GET_TOTAL_PERFORMANCE.DEVELOPMENT_ID IS 2>checked</cfif>>
                                    <cf_get_lang dictionary_id='55563.Bir üst ünvana yükseltilmesi için rotasyonla deneyim kazanması gerekir.'>
                                </label>
                            </div>
                            <div class="form-group" id="item-ROTATION_POS_NAME">
                                <label class="col col-6 col-md-4 col-sm-6 col-xs-12">
                                    <cf_get_lang dictionary_id='55559.Yükseltilebileceği ünvan'>
                                </label>
                                <div class="col col-6 col-md-8 col-sm-6 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="ROTATION_POS" id="ROTATION_POS" value="<cfoutput>#GET_TOTAL_PERFORMANCE.ROTATION_POS#</cfoutput>">
                                        <input name="ROTATION_POS_NAME" type="text" id="ROTATION_POS_NAME" style="width:150px;" value="<cfif len(GET_TOTAL_PERFORMANCE.ROTATION_POS)><cfoutput>#GETPOSNAME(GET_TOTAL_PERFORMANCE.ROTATION_POS).POSITION_NAME#</cfoutput></cfif>">
                                        <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_pos_name=add_perform.ROTATION_POS_NAME&field_code=add_perform.ROTATION_POS&show_empty_pos=1','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-development_id3">
                                <label class="col-col-4 col-md-4 col-sm-6 col-xs-12 txtbold">
                                    <input name="DEVELOPMENT_ID" id="DEVELOPMENT_ID" type="radio" value="3" <cfif GET_TOTAL_PERFORMANCE.DEVELOPMENT_ID IS 3>checked</cfif>>
                                    <cf_get_lang dictionary_id='55691.Bir üst ünvana yükseltilmesi için eğitim yoluyla gelişmesi gereklidir Alması gereken kariyer teknik eğitimler'>
                                </label>
                            </div>
                            <div class="form-group" id="item-urunMiktar">
                                    <label class="col col-6 col-xs-12 txtbold">
                                        <cf_get_lang dictionary_id='57657.Ürün'>
                                    </label>
                                    <label class="col col-6 col-xs-12 txtbold">
                                        <cf_get_lang dictionary_id='57635.Miktar'>
                                    </label>
                                </div>
                            <div class="form-group" id="item-LUCK_TRAIN">
                                <div class="form-group">
                                    <label class="col col-1 col-md-1 col-sm-1 col-xs-12">1-</label>
                                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                                        <div class="input-group">
                                            <input name="LUCK_TRAIN_SUBJECT_1" type="text" id="LUCK_TRAIN_SUBJECT_1" style="width:150px;" maxlength="125" value="<cfoutput>#GET_TOTAL_PERFORMANCE.LUCK_TRAIN_SUBJECT_1#</cfoutput>">
                                            <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_name=add_perform.LUCK_TRAIN_SUBJECT_1','list');"></span>
                                        </div>
                                    </div>
                                    <label class="col col-1 col-md-1 col-sm-1 col-xs-12">3-</label>
                                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                                        <div class="input-group">
                                            <input name="LUCK_TRAIN_SUBJECT_3" type="text" id="LUCK_TRAIN_SUBJECT_3" style="width:150px;" maxlength="125" value="<cfoutput>#GET_TOTAL_PERFORMANCE.LUCK_TRAIN_SUBJECT_3#</cfoutput>">
                                            <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_name=add_perform.LUCK_TRAIN_SUBJECT_3','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-1 col-md-1 col-sm-1 col-xs-12">2-</label>
                                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                                        <div class="input-group">
                                            <input name="LUCK_TRAIN_SUBJECT_2" type="text" id="LUCK_TRAIN_SUBJECT_2" style="width:150px;" maxlength="125" value="<cfoutput>#GET_TOTAL_PERFORMANCE.LUCK_TRAIN_SUBJECT_2#</cfoutput>">
                                            <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_name=add_perform.LUCK_TRAIN_SUBJECT_2','list');"></span>
                                        </div>
                                    </div>
                                    <label class="col col-1 col-md-1 col-sm-1 col-xs-12">4-</label>
                                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                                        <div class="input-group">
                                            <input name="LUCK_TRAIN_SUBJECT_4" type="text" id="LUCK_TRAIN_SUBJECT_4" style="width:150px;" maxlength="125" value="<cfoutput>#GET_TOTAL_PERFORMANCE.LUCK_TRAIN_SUBJECT_4#</cfoutput>">
                                            <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_name=add_perform.LUCK_TRAIN_SUBJECT_4','list');"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-guncelleme">
                                <cfif len(GET_TOTAL_PERFORMANCE.RECORD_KEY)>
                                    <cfif Left(GET_TOTAL_PERFORMANCE.RECORD_KEY,1) IS "e">
                                        <cfset isim = #GETEMPNAME(Right(GET_TOTAL_PERFORMANCE.RECORD_KEY,len(Trim(GET_TOTAL_PERFORMANCE.RECORD_KEY))-2)).EMPLOYEE_NAME#>
                                        <cfset soyisim = #GETEMPNAME(Right(GET_TOTAL_PERFORMANCE.RECORD_KEY,len(Trim(GET_TOTAL_PERFORMANCE.RECORD_KEY))-2)).EMPLOYEE_SURNAME#>
                                        <cfelseif Left(GET_TOTAL_PERFORMANCE.RECORD_KEY,1) IS "p">
                                        <cfquery DATASOURCE="#DSN#" NAME="GET_EVALUATOR">
                                            SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM
                                            COMPANY_PARTNER WHERE PARTNER_ID = #RIGHT(GET_TOTAL_PERFORMANCE.RECORD_KEY,LEN(TRIM(GET_TOTAL_PERFORMANCE.RECORD_KEY))-2)#
                                        </cfquery>
                                        <cfset isim = GET_EVALUATOR.COMPANY_PARTNER_NAME>
                                        <cfset soyisim = GET_EVALUATOR.COMPANY_PARTNER_SURNAME>
                                    </cfif>
                                </cfif>
                                <cfif len(GET_TOTAL_PERFORMANCE.UPDATE_KEY)>
                                    <cfif left(GET_TOTAL_PERFORMANCE.UPDATE_KEY,1) IS "e">
                                        <cfset isim2 = #GETEMPNAME(right(GET_TOTAL_PERFORMANCE.UPDATE_KEY,len(trim(GET_TOTAL_PERFORMANCE.UPDATE_KEY))-2)).EMPLOYEE_NAME#>
                                        <cfset soyisim2 = #GETEMPNAME(right(GET_TOTAL_PERFORMANCE.UPDATE_KEY,len(trim(GET_TOTAL_PERFORMANCE.UPDATE_KEY))-2)).EMPLOYEE_SURNAME#>
                                        <cfelseif left(GET_TOTAL_PERFORMANCE.UPDATE_KEY,1) IS "p">
                                        <cfquery DATASOURCE="#DSN#" NAME="GET_EVALUATOR">
                                            SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM
                                            COMPANY_PARTNER WHERE PARTNER_ID = #RIGHT(GET_TOTAL_PERFORMANCE.UPDATE_KEY,LEN(TRIM(GET_TOTAL_PERFORMANCE.UPDATE_KEY))-2)#
                                        </cfquery>
                                        <cfset isim2 = GET_EVALUATOR.COMPANY_PARTNER_NAME>
                                        <cfset soyisim2 = GET_EVALUATOR.COMPANY_PARTNER_SURNAME>
                                    </cfif>
                                </cfif>
                                <cfif len(GET_TOTAL_PERFORMANCE.RECORD_KEY)>
                                    <label class="col col-2 col-md-2 col-sm-12 col-xs-12 txtbold">
                                        <cf_get_lang dictionary_id='55316.Değerlendiren'>
                                    </label>
                                    <label class="col col-10 col-md-10 col-sm-12 col-xs-12">
                                        <cfoutput>#isim# #soyisim# - #DateFormat(GET_TOTAL_PERFORMANCE.RECORD_DATE,dateformat_style)# #TimeFormat(GET_TOTAL_PERFORMANCE.RECORD_DATE,"HH:mm:ss")#</cfoutput>
                                    </label>
                                </cfif>
                                <cfif len(GET_TOTAL_PERFORMANCE.UPDATE_KEY)>
                                    <label class="col col-2 col-md-2 col-sm-12 col-xs-12 txtbold">
                                        <cf_get_lang dictionary_id='57703.Güncelleme'>
                                    </label>
                                    <label class="col col-10 col-md-10 col-sm-12 col-xs-12">
                                        <cfoutput>#isim2# #soyisim2# - #DateFormat(GET_TOTAL_PERFORMANCE.UPDATE_DATE,dateformat_style)# #TimeFormat(GET_TOTAL_PERFORMANCE.UPDATE_DATE,"HH:mm:ss")#</cfoutput>
                                    </label>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="row" type="row">
                        <cf_form_box_footer><cf_workcube_buttons is_upd='0' insert_info="#getLang('','Güncelle',57464)#"></cf_form_box_footer>
                    </div>
                </cf_basket_form>
            </div>
        </div>
    </div>
</cfform>