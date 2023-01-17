<cfinclude template="../query/check_user_vote.cfm">
<cfinclude template="../query/get_survey_alts.cfm">	
<cfinclude template="../query/get_survey_votes_count.cfm">	
<cfparam name="attributes.chart_type" default="bar">
<cfinclude template="../query/get_survey.cfm">
<cfinclude template="../query/get_survey_alts.cfm">	
<cf_catalystHeader>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="58662.Üye Analiz Formları"></cfsavecontent>
<!--- Sayfa başlığı ve ikonlar --->
<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
<!--- Sayfa ana kısım  --->
        <!---Geniş alan: içerik--->
    <cf_box title="#getLang('','Anket Sonuçları','49322')#" closable="0">
        <cfquery name="GET_EMP_NAMES" datasource="#DSN#">
            SELECT 
                DISTINCT EMPLOYEES.EMPLOYEE_NAME AS AD, 
                EMPLOYEES.EMPLOYEE_SURNAME AS SOYAD, 
                EMPLOYEES.EMPLOYEE_ID AS NO,
                SURVEY_VOTES.VOTES AS OY,
                SURVEY_VOTES.RECORD_DATE AS REC_DATE,
                '1' AS TIP
            FROM 
                EMPLOYEES, 
                SURVEY_VOTES
            WHERE 
                SURVEY_VOTES.SURVEY_ID = #attributes.survey_id# AND
                SURVEY_VOTES.EMP_ID = EMPLOYEES.EMPLOYEE_ID
                    
            UNION
            
            SELECT 
                COMPANY_PARTNER.COMPANY_PARTNER_NAME AS ad,
                COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS soyad, 
                COMPANY_PARTNER.PARTNER_ID AS no,
                SURVEY_VOTES.VOTES  AS oy,
                SURVEY_VOTES.RECORD_DATE AS REC_DATE,
                '2' AS TIP
            FROM 
                COMPANY_PARTNER,
                SURVEY_VOTES 
            WHERE 
                SURVEY_VOTES.SURVEY_ID = #attributes.survey_id# AND
                SURVEY_VOTES.PAR_ID = COMPANY_PARTNER.PARTNER_ID
                    
            UNION
            SELECT 
                CONSUMER.CONSUMER_NAME AS AD,
                CONSUMER.CONSUMER_SURNAME AS SOYAD, 
                CONSUMER.CONSUMER_ID AS NO,
                SURVEY_VOTES.VOTES  AS OY,
                SURVEY_VOTES.RECORD_DATE AS REC_DATE,
                '3' AS TIP
            FROM 
                CONSUMER, 
                SURVEY_VOTES
            WHERE 
                SURVEY_VOTES.SURVEY_ID = #attributes.survey_id# AND
                SURVEY_VOTES.CON_ID = CONSUMER.CONSUMER_ID
            UNION
            SELECT 
                RECORD_IP AS AD,
                ' - Misafir' AS SOYAD,
                0 AS NO,	
                VOTES AS OY,
                RECORD_DATE AS REC_DATE,
                '4' AS TIP
            FROM 
                SURVEY_VOTES 
            WHERE 
                GUEST = 1 AND
                SURVEY_ID = #attributes.survey_id# 
        </cfquery>
        <cfquery name="get_survey_name" datasource="#dsn#">
            SELECT SURVEY FROM SURVEY WHERE SURVEY_ID = #attributes.survey_id# 
        </cfquery>
        <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
        <cfparam name="attributes.page" default=1>
        <cfparam name="lastpage" default=1>
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <cfparam name="attributes.totalrecords" default="#get_emp_names.recordcount#">
        <div class="ui-info-bottom">
            <p><cfoutput>#get_survey_name.survey#</cfoutput></p>
        </div>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='29780.Katılımcı'></th>
                    <th><cf_get_lang dictionary_id='58654.Cevap'></th>
                    <th width="100"><cf_get_lang dictionary_id='57742.Tarih'></th>
                </tr>
            </thead>
            <tbody>
                <cfset answer_list="">
                <cfoutput query="get_emp_names">
                    <cfif len(oy) and not listfind (answer_list,oy)>
                        <cfset answer_list = listappend (answer_list,oy)>
                    </cfif>
                </cfoutput>
                <cfif len(answer_list)>
                    <cfset answer_list = listsort(answer_list,"numeric","ASC",",")>
                        <cfquery name="GET_ANS" datasource="#DSN#">
                            SELECT 
                                ALT,
                                ALT_ID
                            FROM 
                                SURVEY_ALTS 
                            WHERE 
                                ALT_ID IN (#answer_list#)
                            ORDER BY
                                ALT_ID
                        </cfquery>
                    <cfset answer_list= listsort(listdeleteduplicates(valuelist(GET_ANS.ALT_ID,',')),'numeric','ASC',',')>
                </cfif>
                <cfif get_emp_names.recordcount>
                <cfoutput query="get_emp_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>
                        <cfif get_emp_names.tip eq 1>
                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp_names.no#','medium');">#get_emp_names.ad# #get_emp_names.soyad#</a>
                        <cfelseif get_emp_names.tip eq 2>
                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_emp_names.no#','medium');">#get_emp_names.ad# #get_emp_names.soyad#</a>
                        <cfelseif get_emp_names.tip eq 3>
                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_emp_names.no#','medium');">#get_emp_names.ad# #get_emp_names.soyad#</a>
                        <cfelse>
                            #get_emp_names.ad# - <cf_get_lang dictionary_id='49516.Misafir'>
                        </cfif>
                    </td>
                    <td><cfloop list="#listsort(get_emp_names.oy,'numeric','asc',',')#" index="x">
                            #get_ans.alt[listfind(answer_list,x,',')]#
                            <cfif listlast(listsort(get_emp_names.oy,'numeric','asc',',')) neq x>,</cfif>
                        </cfloop>
                    </td>
                    <td><cfif len(get_emp_names.rec_date)>#dateformat(get_emp_names.rec_date,dateformat_style)# #timeformat(date_add('H',session.ep.time_zone,get_emp_names.rec_date),timeformat_style)#</cfif></td>
                </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.maxrows lt attributes.totalrecords>
            <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="campaign.list_survey&event=dashboard&survey_id=#attributes.survey_id#">>
        </cfif>
    </cf_box>
</div>
<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
    <!--- Yan kısım--->
    <cf_box title="#getLang('','Grafik','49450')#" closable="0">
        <cfform name="vote_survey"  action="#request.self#?fuseaction=campaign.popup_ajax_anket&survey_id=#attributes.survey_id#&iframe=1">
            <!---Anket Grafiği --->
            <div id="yeni">
                <cf_box_search more="0">
                    <div class="form-group large">
                        <select name="chart_type" id="chart_type">
                            <option value="polarArea" <cfif attributes.chart_type is "area">selected</cfif>><cf_get_lang dictionary_id='57662.Alan'></option>
                            <option value="bar" <cfif attributes.chart_type is "bar">selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                            <option value="line" <cfif attributes.chart_type is "line">selected</cfif>><cf_get_lang dictionary_id='57667.Çizgi'></option>
                            <option value="pie" <cfif attributes.chart_type is "pie">selected</cfif>><cf_get_lang dictionary_id='57668.Pay'></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button  is_excel='0' button_type="4" search_function="ajax_function()">
                    </div>
                </cf_box_search>
                <cf_ajax_list>
                    <cfif attributes.chart_type eq 'bar'>
                        <tbody>
                            <tr>
                                <td>
                                    <cfif get_survey_alts.recordcount>
                                        <cfoutput query="get_survey_alts">
                                            <cfif len(alt) GT 35>
                                                <cfset 'item_#currentrow#'="#Left(alt,35)#...">
                                                <cfset 'value_#currentrow#'="#vote_count#">
                                            <cfelse>
                                                <cfset 'item_#currentrow#'="#alt#">
                                                <cfset 'value_#currentrow#'="#vote_count#">
                                            </cfif>
                                        </cfoutput>
                                        <script src="JS/Chart.min.js"></script>
                                        <canvas id="myChart1" style="float:left;max-height:450px;max-width:450px;"></canvas>
                                        <script>
                                            var ctx = document.getElementById('myChart1');
                                            var myChart1 = new Chart(ctx, {
                                                type: '<cfoutput>#attributes.chart_type#</cfoutput>',
                                                data: {
                                                        labels: [<cfloop from="1" to="#get_survey_alts.recordcount#" index="jj">
                                                            <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                        datasets: [{
                                                        label: "Anket",
                                                        backgroundColor: [<cfloop from="1" to="#get_survey_alts.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                        data: [<cfloop from="1" to="#get_survey_alts.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                            }]
                                                        },
                                                options: {}
                                            });
                                        </script>
                                    </cfif>
                                </td>
                            </tr>
                        </tbody>
                    
                    </cfif>
                </cf_ajax_list>
            </div>
        </cfform>
    </cf_box>
</div>
<script>
    function ajax_function()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=campaign.popup_ajax_anket&survey_id=#attributes.survey_id#&iframe=1&chart_type=#attributes.chart_type#</cfoutput>' ,'yeni');
		return false;
	}
</script>