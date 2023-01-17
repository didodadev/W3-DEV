<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfset firstdate = attributes.start_date>
<cfset lastdate = attributes.finish_date>
<cf_date tarih=firstdate>
<cf_date tarih=lastdate>
<cfquery name="GET_TARIH" datasource="#DSN#">
	SELECT
		START_DATE,
		FINISH_DATE
	FROM	
		EMPLOYEE_TOTAL_PERFORMANCE
	WHERE
		START_DATE = #firstdate# AND FINISH_DATE = #lastdate# AND EMP_ID = #attributes.employee_id#
</cfquery>

<cfif get_tarih.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='38676.Aynı Döneme Birden Fazla Performans Formu Eklenemez'>!");
		history.back();
	</script>
</cfif>
<cfinclude template="../query/get_total_perf_quizs.cfm">
<cfinclude template="../query/get_total_perf_targets.cfm">
<cffunction name="GETEMPNAME">
  <cfargument name="empid" type="numeric" required="true">
	<cfquery name="GET_EMP_NAME" datasource="#dsn#">
		SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #EMPID#
	</cfquery>
  <cfreturn GET_EMP_NAME>
</cffunction>
<cfinclude template="../query/get_positions_notempty.cfm">

<cf_catalystHeader>
<!--- Sayfa başlığı ve ikonlar --->
<!---

    <table class="dph">
			<tr>
				<td class="dpht">
					<cf_get_lang_main no='591.Performans'>:
					<cfoutput>
                        <a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#attributes.employee_id#">#GETEMPNAME(attributes.employee_id).EMPLOYEE_NAME# #GETEMPNAME(attributes.employee_id).employee_surname#</a> (#get_positions.position_name#)</cfoutput> / <cfoutput>#DateFormat(firstdate,dateformat_style)# - #DateFormat(lastdate,dateformat_style)#
                    </cfoutput> 
				</td>
				<td class="dphb">
				</td>
			</tr>
		</table>

--->

<cfform name="add_perform" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_total_performance">
        <cf_box>
            <cf_box_elements>
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
                                    <cfinclude template="../query/get_emp_chiefs.cfm">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="55119.Ölçme Değerlendirme Formları"></cfsavecontent>
                                    <cf_seperator id="olcme" title="#message#">
                                        <table id="olcme" width="100%" border="0" cellspacing="1" cellpadding="2">
                                            <cfif not get_total_perf_quizs.recordcount>
                                                <tr>
                                                    <td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                                                </tr>
                                            <cfelse>
                                                <cfoutput query="get_total_perf_quizs">
                                                <tr>
                                                    <td>
                                                        <!--- Sol iç --->
                                                            <cfset attributes.survey_id = SURVEY_MAIN_ID>
                                                            <cfset attributes.result_id = SURVEY_MAIN_RESULT_ID>
                                                            <cfinclude template="../query/act_quiz_perf_point.cfm">
                                                            <cfif len(get_main_result_info.MANAGER1_POS)>
                                                                <cfquery name="GET_EMP_MANG_1" datasource="#dsn#">
                                                                    SELECT
                                                                    EMPLOYEE_ID,
                                                                    POSITION_ID,
                                                                    EMPLOYEE_NAME,
                                                                    EMPLOYEE_SURNAME
                                                                    FROM
                                                                    EMPLOYEE_POSITIONS
                                                                    WHERE
                                                                    POSITION_CODE = #get_main_result_info.MANAGER1_POS#
                                                                </cfquery>
                                                            </cfif>
                                                            <cfif len(get_main_result_info.MANAGER2_POS)>
                                                                <cfquery name="GET_EMP_MANG_2" datasource="#dsn#">
                                                                    SELECT
                                                                    EMPLOYEE_ID,
                                                                    POSITION_ID,
                                                                    EMPLOYEE_NAME,
                                                                    EMPLOYEE_SURNAME
                                                                    FROM
                                                                    EMPLOYEE_POSITIONS
                                                                    WHERE
                                                                    POSITION_CODE = #get_main_result_info.MANAGER2_POS#
                                                                </cfquery>
                                                            </cfif>
                                                            <table>
                                                                <tr>
                                                                    <td class="bold" colspan="2">#get_total_perf_quizs.SURVEY_MAIN_HEAD# (#DateFormat(START_DATE,dateformat_style)# - #DateFormat(FINISH_DATE,dateformat_style)#)</td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2" class="bold" height="22"> <cf_get_lang dictionary_id='55527.Amirlerin Görüşleri'></td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="200" height="20">
                                                                        <cfif len(get_main_result_info.MANAGER1_POS)>
                                                                            #GET_EMP_MANG_1.EMPLOYEE_NAME# #GET_EMP_MANG_1.EMPLOYEE_SURNAME#
                                                                        </cfif>
                                                                    </td>
                                                                    <td>
                                                                        <cfif not Len(get_total_perf_quizs.VALID_2)>
                                                                            <cf_get_lang dictionary_id='55528.Onay veya Red belirtilmemiş'>
                                                                        <cfelse>
                                                                            <cfif get_total_perf_quizs.VALID_1 EQ 1>
                                                                                <cf_get_lang dictionary_id='58699.Onaylandı'> -
                                                                                #DateFormat(get_total_perf_quizs.VALID_1_DATE,dateformat_style)# #TimeFORMAT(get_total_perf_quizs.VALID_1_DATE,timeformat_style)# <br/>
                                                                                <cf_get_lang dictionary_id='55260.Onaylayan'>
                                                                                <cfelseif get_total_perf_quizs.VALID_1 EQ 0>
                                                                                <cf_get_lang dictionary_id='57617.Reddedildi'> - #DateFormat(get_total_perf_quizs.VALID_1_DATE,dateformat_style)# #TimeFORMAT(get_total_perf_quizs.VALID_1_DATE,timeformat_style)# <br/>
                                                                                <cf_get_lang dictionary_id='55529.Reddeden'>
                                                                            </cfif>
                                                                            #GETEMPNAME(get_total_perf_quizs.VALID_1_EMP).EMPLOYEE_NAME# #GETEMPNAME(get_total_perf_quizs.VALID_1_EMP).EMPLOYEE_SURNAME#
                                                                        </cfif>
                                                                    </td>
                                                                </tr>
                                                                <tr height="20">
                                                                    <td class="bold">
                                                                        <cfif len(get_total_perf_quizs.MANAGER_2_POS)>
                                                                            #GET_EMP_MANG_2.EMPLOYEE_NAME# #GET_EMP_MANG_2.EMPLOYEE_SURNAME#
                                                                        </cfif>
                                                                    </td>
                                                                    <td>
                                                                        <cfif Not Len(get_total_perf_quizs.VALID_2)>
                                                                            <cf_get_lang dictionary_id='55528.Onay veya Red belirtilmemiş'>
                                                                        <cfelse>
                                                                            <cfif get_total_perf_quizs.VALID_2 EQ 1>
                                                                                <cf_get_lang dictionary_id='58699.Onaylandı'>- #DateFormat(get_total_perf_quizs.VALID_2_DATE,dateformat_style)# #TimeFORMAT(get_total_perf_quizs.VALID_2_DATE,timeformat_style)# <br/>
                                                                                <cf_get_lang dictionary_id='55260.Onaylayan'>
                                                                            <cfelseif get_total_perf_quizs.VALID_2 EQ 0>
                                                                                <cf_get_lang dictionary_id='57617.Reddedildi'> - #DateFormat(get_total_perf_quizs.VALID_2_DATE,dateformat_style)# #TimeFORMAT(get_total_perf_quizs.VALID_2_DATE,timeformat_style)# <br/>
                                                                                <cf_get_lang dictionary_id='55529.Reddeden'>
                                                                            </cfif>
                                                                                #GETEMPNAME(get_total_perf_quizs.VALID_2_EMP).EMPLOYEE_NAME# #GETEMPNAME(get_total_perf_quizs.VALID_2_EMP).EMPLOYEE_SURNAME#
                                                                        </cfif>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <table>
                                                                <tr height="20">
                                                                    <td class="bold" width="200">
                                                                        <cf_get_lang dictionary_id='55511.Güçlü Yönleri'>
                                                                    </td>
                                                                    <td>#get_total_perf_quizs.POWERFUL_ASPECTS#</td>
                                                                </tr>
                                                                <tr height="20">
                                                                    <td class="bold"><cf_get_lang dictionary_id='29805.Yorum'></td>
                                                                    <td>#get_main_result_info.comment# </td>
                                                                </tr>
                                                                <tr height="20">
                                                                    <td class="bold"><cf_get_lang dictionary_id='57422.Notlar'></td>
                                                                    <td>#get_main_result_info.result_note# </td>
                                                                </tr>
                                                            </table>
                                                            <table>
                                                                <tr>
                                                                    <td class="bold" height="22"> <cf_get_lang dictionary_id='55531.Alması Gereken Eğitimler'> </td>
                                                                </tr>
                                                                <tr height="20">
                                                                    <td>
                                                                        <cfloop from="1" to="8" index="train">
                                                                            <cfif len(evaluate("get_total_perf_quizs.LUCK_TRAIN_SUBJECT_"&train))>
                                                                                #train#- #evaluate('get_total_perf_quizs.LUCK_TRAIN_SUBJECT_'&train)#<br/>
                                                                            </cfif>
                                                                        </cfloop>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <table>
                                                                <tr>
                                                                    <td colspan="2" height="22" class="bold"><cf_get_lang dictionary_id='55532.Genel Değerlendirme (İK Departmanı)'></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="bold" height="20" width="200"><cf_get_lang dictionary_id='57776.Toplam Puan / Kişinin Aldığı Puan'></td>
                                                                    <cfif len(get_main_result_info.score_result)>
                                                                        <input type="hidden" name="total_point" id="total_point" value="#get_main_result_info.score_result#">
                                                                    <cfelse>
                                                                        <input type="hidden" name="total_point" id="total_point" value="0">
                                                                    </cfif>
                                                                    <td>#TlFormat(get_main_result_info.score_result)# / #get_survey_main.total_score#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="bold"><cf_get_lang dictionary_id='57684.Sonuç'></td>
                                                                    <td>
                                                                        #TlFormat(get_main_result_info.score_result)# / 5
                                                                    </td>
                                                                </tr>
                                                                <tr class="txtboldblue" height="22">
                                                                    <td class="bold" height="22" colspan="2"><cf_get_lang dictionary_id='55534.Değerlendirilenin Görüşleri'></td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">#get_total_perf_quizs.EMPLOYEE_OPINION#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <cfif get_total_perf_quizs.EMPLOYEE_OPINION_ID IS 1>
                                                                            <cf_get_lang dictionary_id='55543.Değerlendirmeye katılıyorum'>
                                                                        <cfelseif get_total_perf_quizs.EMPLOYEE_OPINION_ID IS 0>
                                                                            <cf_get_lang dictionary_id='55544.Değerlendirmeye katılmıyorum'>
                                                                        </cfif>
                                                                    </td>
                                                                </tr>
                                                                    <cfif len(get_total_perf_quizs.record_date)>
                                                                        <tr>
                                                                            <td colspan="2" class="bold">
                                                                                <cf_get_lang dictionary_id='55545.Kayıt Tarihi - Kaydeden'>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                #dateFormat(get_main_result_info.record_date, 'DD/MM/YYY')# - #get_emp_info(get_main_result_info.record_emp,0,0)#
                                                                            </td>
                                                                        </tr>
                                                                    </cfif>
                                                            </table>
                                                            <hr>
                                                        </td>
                                                    </tr>
                                                </cfoutput>
                                            </cfif>
                                        </table>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57964.Hedefler"></cfsavecontent>
                                    <cf_seperator id="hedef" title="#message#">
                                    <table id="hedef">
                                        <cfif GET_TOTAL_PERF_TARGETS.recordcount>
                                            <cfoutput query="GET_TOTAL_PERF_TARGETS">
                                            <cfset targetcatid = GET_TOTAL_PERF_TARGETS.targetcat_id>
                                            <tr>
                                                <td width="200" class="txtbold" height="20"><cf_get_lang dictionary_id='57501.Başlangıç'></td>
                                                    <td> #dateformat(GET_TOTAL_PERF_TARGETS.startdate,dateformat_style)#</td>
                                                </tr>
                                                <tr>
                                                    <td class="txtbold" height="20"><cf_get_lang dictionary_id='57502.Bitiş'></td>
                                                    <td>#dateformat(GET_TOTAL_PERF_TARGETS.finishdate,dateformat_style)#</td>
                                                </tr>
                                                <tr>
                                    <td class="txtbold" height="20"><cf_get_lang dictionary_id='57486.Kategori'></td>
                                    <td> #GET_TOTAL_PERF_TARGETS.TARGETCAT_NAME# </td>
                                    </tr>
                                    <tr>
                                    <td class="txtbold" height="20"><cf_get_lang dictionary_id='57951.Hedef'></td>
                                    <td> #GET_TOTAL_PERF_TARGETS.target_head# </td>
                                    </tr>
                                    <tr>
                                    <td class="txtbold" height="20"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                                    <td valign="top">#GET_TOTAL_PERF_TARGETS.target_detail# </td>
                                    </tr>
                                    <tr>
                                    <td class="txtbold" height="20"><cf_get_lang dictionary_id='55486.Rakam'></td>
                                    <td>#GET_TOTAL_PERF_TARGETS.target_number# </td>
                                    </tr>
                                    <tr>
                                    <td colspan="2" height="22" class="txtboldblue"><cf_get_lang dictionary_id='55546.Yöneticisinin Görüşü'></td>
                                    </tr>
                                    <tr>
                                    <td valign="top" class="txtbold" height="20"><cf_get_lang dictionary_id='57684.Sonuç'></td>
                                    <td>#GET_TOTAL_PERF_TARGETS.PERFORM_COMMENT# </td>
                                    </tr>
                                    <tr>
                                    <td></td>
                                    <td>
                                    <!--- #get_total_perf_quizs.USER_POINT_OVER_5# / 5 --->
                                    <!--- 20051121 TolgaS eskiden kullanılan bir alanmış artık kullanılamdığı için kaldırıldı
                                    <cfswitch expression = "#GET_TOTAL_PERF_TARGETS.PERFORM_POINT_ID#">
                                    <cfcase value="1">
                                    <cf_get_lang no='450.Beklenenin Üstü'> (+)
                                    </cfcase>
                                    <cfcase value="2">
                                    <cf_get_lang no='450.Beklenenin Üstü'> (-)
                                    </cfcase>
                                    <cfcase value="3">
                                    <cf_get_lang no='452.Beklenen Düzey'> (+)
                                    </cfcase>
                                    <cfcase value="4">
                                    <cf_get_lang no='452.Beklenen Düzey'>
                                    </cfcase>
                                    <cfcase value="5">
                                    <cf_get_lang no='452.Beklenen Düzey'> (-)
                                    </cfcase>
                                    <cfcase value="6">
                                    <cf_get_lang no='455.Beklenenin Altı'> (+)
                                    </cfcase>
                                    <cfcase value="7">
                                    <cf_get_lang no='455.Beklenenin Altı'> (-)
                                    </cfcase>
                                    <cfcase value="8">
                                    <cf_get_lang no='462.Beklenenin'>
                                    </cfcase>
                                    </cfswitch> --->
                                    </td>
                                    </tr>
                                    </cfoutput>
                                    <cfelse>
                                    <tr>
                                    <td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                                    </tr>
                                    </cfif>
                                    </table>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="2" sort="true">
                                    <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                                    <input type="hidden" name="start_date" id="start_date" value="<cfoutput>#DateFormat(firstdate,dateformat_style)#</cfoutput>">
                                    <input type="hidden" name="finish_date" id="finish_date" value="<cfoutput>#DateFormat(lastdate,dateformat_style)#</cfoutput>">
                                    <input type="hidden" name="target_ids" id="target_ids" value="<cfoutput>,#ValueList(get_total_perf_targets.TARGET_ID)#,</cfoutput>">
                                    <input type="hidden" name="quote_ids" id="quote_ids" value="<cfoutput>,,</cfoutput>">
                                    <input type="hidden" name="per_ids" id="per_ids" value="<cfoutput>,#ValueList(get_total_perf_quizs.PER_ID)#,</cfoutput>">
                                    <div class="form-group" id="item-aciklama">
                                        <label class="col col-12 formbold"><cf_get_lang dictionary_id='55557.Bu değerlendirme formu, değerlendirme yapılacak çalışanın yöneticileri tarafından yapılacaktır.'></label>
                                    </div>
                                    <div class="form-group" id="item-development_id1">
                                        <label class="col-col-4 col-md-4 col-sm-6 col-xs-12 txtbold">
                                            <input name="DEVELOPMENT_ID" id="DEVELOPMENT_ID" type="radio" value="1" checked>
                                            <cf_get_lang dictionary_id='55558.Bir üst ünvana yükseltilmelidir.'>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-POSSIBLE_PROMOTE_POS">
                                        <label class="col col-6 col-md-4 col-sm-6 col-xs-12">
                                            <cf_get_lang dictionary_id='55559.Yükseltilebileceği ünvan'>
                                        </label>
                                        <div class="col col-6 col-md-8 col-sm-6 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="POSSIBLE_PROMOTE_POS" id="POSSIBLE_PROMOTE_POS">
                                                <input name="POSSIBLE_PROMOTE_POS_NAME" type="text" id="possible_promote_pos_name">
                                                <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_pos_name=add_perform.POSSIBLE_PROMOTE_POS_NAME&field_code=add_perform.POSSIBLE_PROMOTE_POS&show_empty_pos=1','list','popup_list_positions');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-POSSIBLE_PROMOTE_TIME">
                                        <label class="col col-6 col-md-4 col-sm-6 col-xs-12">
                                            <cf_get_lang dictionary_id='55560.Tahmini yükselme süresi (ay)'>
                                        </label>
                                        <div class="col col-6 col-md-8 col-sm-6 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55460.Tahmini yükselme süresi (ay) girmelisiniz'></cfsavecontent>
                                            <cfinput name="POSSIBLE_PROMOTE_TIME" type="text" id="POSSIBLE_PROMOTE_TIME" validate="integer" maxlength="2" message="#message#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-MAX_POSSIBLE_PROMOTE_POS_NAME">
                                        <label class="col col-6 col-md-4 col-sm-6 col-xs-12">
                                            <cf_get_lang dictionary_id='55561.Grup içinde yükselebileceği en yüksek ünvan'>
                                        </label>
                                        <div class="col col-6 col-md-8 col-sm-6 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="MAX_POSSIBLE_PROMOTE_POS" id="MAX_POSSIBLE_PROMOTE_POS">
                                                <input name="MAX_POSSIBLE_PROMOTE_POS_NAME" type="text" id="MAX_POSSIBLE_PROMOTE_POS_NAME">                                        <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_pos_name=add_perform.MAX_POSSIBLE_PROMOTE_POS_NAME&field_code=add_perform.MAX_POSSIBLE_PROMOTE_POS&show_empty_pos=1','list','popup_list_positions');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-MAX_POSSIBLE_PROMOTE_TIME">
                                        <label class="col col-6 col-md-4 col-sm-6 col-xs-12">
                                            <cf_get_lang dictionary_id='55562.Bu ünvana tahmini yükselme süresi'>
                                        </label>
                                        <div class="col col-6 col-md-8 col-sm-6 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55461.Bu ünvana tahmini yükselme süresi girmelisiniz'></cfsavecontent>
                                            <cfinput name="MAX_POSSIBLE_PROMOTE_TIME" type="text" id="MAX_POSSIBLE_PROMOTE_TIME" validate="integer" maxlength="2" message="#message#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-development_id2">
                                        <label class="col-col-4 col-md-4 col-sm-6 col-xs-12 txtbold">
                                            <input name="DEVELOPMENT_ID" id="DEVELOPMENT_ID" type="radio" value="2">
                                            <cf_get_lang dictionary_id='55563.Bir üst ünvana yükseltilmesi için rotasyonla deneyim kazanması gerekir'>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-ROTATION_POS_NAME">
                                        <label class="col col-6 col-md-4 col-sm-6 col-xs-12">
                                            <cf_get_lang dictionary_id='55564.Rotasyonla geçebileceği ünvan'>
                                        </label>
                                        <div class="col col-6 col-md-8 col-sm-6 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="ROTATION_POS" id="ROTATION_POS">
                                                <input name="ROTATION_POS_NAME" type="text" id="ROTATION_POS_NAME">
                                                <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_pos_name=add_perform.ROTATION_POS_NAME&field_code=add_perform.ROTATION_POS&show_empty_pos=1','list','popup_list_positions');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-development_id3">
                                        <label class="col-col-4 col-md-4 col-sm-6 col-xs-12 txtbold">
                                            <input name="DEVELOPMENT_ID" id="DEVELOPMENT_ID" type="radio" value="3">
                                            <cf_get_lang dictionary_id='55565.Bir üst ünvana yükseltilmesi için eğitim yoluyla gelişmesi gereklidir Alması gereken kariyer teknik eğitimler'>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-urunMiktar">
                                        <label class="col col-6 col-xs-12 txtbold">
                                            <cf_get_lang dictionary_id='30994.Alması Gereken Eğitimler'>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-LUCK_TRAIN">
                                        <div class="form-group">
                                            <label class="col col-1 col-md-1 col-sm-1 col-xs-1">1-</label>
                                            <div class="col col-5 col-md-5 col-sm-12 col-xs-12">
                                                <div class="input-group">
                                                    <input name="LUCK_TRAIN_SUBJECT_1" type="text" id="LUCK_TRAIN_SUBJECT_1" style="width:150px;" maxlength="125">
                                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_name=add_perform.LUCK_TRAIN_SUBJECT_1','list','popup_list_training_subjects');"></span>
                                                </div>
                                            </div>
                                            <label class="col col-1 col-md-1 col-sm-1 col-xs-1">3-</label>
                                            <div class="col col-5 col-md-5 col-sm-12 col-xs-12">
                                                <div class="input-group">
                                                    <input name="LUCK_TRAIN_SUBJECT_3" type="text" id="LUCK_TRAIN_SUBJECT_3" style="width:150px;" maxlength="125">
                                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_name=add_perform.LUCK_TRAIN_SUBJECT_3','list','popup_list_training_subjects');"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-1 col-md-1 col-sm-1 col-xs-1">2-</label>
                                            <div class="col col-5 col-md-5 col-sm-12 col-xs-12">
                                                <div class="input-group">
                                                    <input name="LUCK_TRAIN_SUBJECT_2" type="text" id="LUCK_TRAIN_SUBJECT_2" style="width:150px;" maxlength="125">
                                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_name=add_perform.LUCK_TRAIN_SUBJECT_2','list')"></span>
                                                </div>
                                            </div>
                                            <label class="col col-1 col-md-1 col-sm-1 col-xs-1">4-</label>
                                            <div class="col col-5 col-md-5 col-sm-12 col-xs-12">
                                                <div class="input-group">
                                                    <input name="LUCK_TRAIN_SUBJECT_4" type="text" id="LUCK_TRAIN_SUBJECT_4" style="width:150px;" maxlength="125">
                                                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_name=add_perform.LUCK_TRAIN_SUBJECT_4','list')"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div><br>
                            <div class="row" type="row">
                                <cf_form_box_footer><cf_workcube_buttons is_upd='0'></cf_form_box_footer>
                            </div>
                        </cf_basket_form>
                    </div>
                </div>
            </cf_box_elements>
        </cf_box>
</cfform>