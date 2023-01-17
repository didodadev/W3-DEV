<cf_xml_page_edit fuseact="purchase.detail_offer_ta">
<cfquery name="get_avg_tech_point" datasource="#dsn3#">
    SELECT ISNULL(SUM(TECHNICAL_POINT),0) AS SUM_POINT, ISNULL(AVG(TECHNICAL_POINT),0) AS AVG_POINT, COUNT(TECHNICAL_POINT) AS COUNT_POINT, OFFER_ID, RECORD_EMP FROM PURCHASE_TECHNICAL_POINT WHERE FOR_OFFER_ID = #attributes.offer_id# GROUP BY OFFER_ID, RECORD_EMP ORDER BY OFFER_ID
</cfquery>
<div style="position:absolute;margin-left:50px;margin-top:41px;width:500px;z-index: 99999" id="technical_point_div"></div>
<cf_grid_list>
    <cfquery name="get_group_offer" datasource="#dsn3#">
        SELECT OFFER_ID FROM OFFER WHERE FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
    </cfquery>
    <thead>
            <tr>
                <th rowspan="2"><cf_get_lang dictionary_id="31937.Değerlendiren"></th>
                <cfoutput query="get_group_offer">
                    <cfquery name="get_offer_number" datasource="#dsn3#">
                        SELECT OFFER_NUMBER, OFFER_TO_PARTNER, OFFER_TO FROM OFFER WHERE OFFER_ID = #offer_id#
                    </cfquery>
                    <cfquery name="get_tech_pnt_offer_id" datasource="#dsn3#">
                        SELECT RECORD_DATE FROM PURCHASE_TECHNICAL_POINT WHERE FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#offer_id#"> GROUP BY RECORD_DATE
                    </cfquery>
                    <cfquery name="get_tech_pnt_offer_record_emp" datasource="#dsn3#">
                        SELECT RECORD_DATE FROM PURCHASE_TECHNICAL_POINT WHERE FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#offer_id#"> AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> GROUP BY RECORD_DATE
                    </cfquery>
                    <th colspan="2" style="text-align:center;"><a title="#get_par_info(listdeleteduplicates(get_offer_number.offer_to_partner),0,1,0,1)#" target="_blank" href="#request.self#?fuseaction=objects.technical_point&event=add&offer_id=#offer_id#">#get_offer_number.OFFER_NUMBER#</a></th>
                    <th style="text-align:center;">
                        <cfif len(x_offer_max_rating)>
                            <cfif get_tech_pnt_offer_id.recordCount lt x_offer_max_rating>
                                <cfif get_tech_pnt_offer_record_emp.recordCount lt x_emp_max_rating>
                                    <a onClick="open_technical_point_div(<cfoutput>#listdeleteduplicates(get_offer_number.offer_to_partner)#,#offer_id#,#listdeleteduplicates(get_offer_number.offer_to)#</cfoutput>);"><i class="fa fa-wrench" title="<cf_get_lang dictionary_id='35341.Teknik Puanlama'>"></i></a>
                                <cfelse>
                                    <i style="color:##E08283;" class="fa fa-wrench" title="<cf_get_lang dictionary_id='60290.Bu teklif için kullanıcı başına belirlenen maximum puanlama sayısına ulaşılmıştır'>"></i>
                                </cfif>
                            <cfelse>
                                <i style="color:##E08283;" class="fa fa-wrench" title="<cf_get_lang dictionary_id='60289.Bu teklif için belirlenen maximum puanlama sayısına ulaşılmıştır'>"></i>
                            </cfif>
                        <cfelse>
                            <a onClick="open_technical_point_div(<cfoutput>#listdeleteduplicates(get_offer_number.offer_to_partner)#,#offer_id#,#listdeleteduplicates(get_offer_number.offer_to)#</cfoutput>);"><i class="fa fa-wrench" title="<cf_get_lang dictionary_id='35341.Teknik Puanlama'>"></i></a>
                        </cfif>
                    </th>
                </cfoutput>
            </tr>
            <tr>
                <cfloop query="get_group_offer">
                    <cfset 'total_avg_#offer_id#' = 0>
                    <cfset 'avg_row_count_#offer_id#' = 0>
                    <th style="text-align:center;" title="<cf_get_lang dictionary_id="34228.Toplam Satır">">TS</th>
                    <th style="text-align:center;" title="<cf_get_lang dictionary_id="58985.Toplam Puan">">TP</th>
                    <th style="text-align:center;" title="<cf_get_lang dictionary_id="39247.Ortalama Puan">">OP</th>
                </cfloop>
            </tr>
    </thead>
    <tbody>
        <cfquery name="get_group_emp" dbtype="query">
            SELECT RECORD_EMP FROM get_avg_tech_point GROUP BY RECORD_EMP
        </cfquery>
        <cfoutput query="get_group_emp">
            <tr>
                <td>
                    <a style="color:##808080;" href="javascript://" onclick="nModal({head: 'Profil',page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#'});">
                        #get_emp_info(record_emp,0,0)#
                    </a>
                </td>
                <cfloop query="get_group_offer">
                    <cfquery name="get_details_pnt_emp" dbtype="query">
                        SELECT OFFER_ID, SUM(SUM_POINT) AS SUMP, SUM(COUNT_POINT) AS CNTP FROM get_avg_tech_point WHERE RECORD_EMP = #get_group_emp.record_emp# AND OFFER_ID = #OFFER_ID# GROUP BY OFFER_ID
                    </cfquery>
                    <cfif get_details_pnt_emp.recordCount>
                        <cfset avgp = wrk_round(get_details_pnt_emp.SUMP/get_details_pnt_emp.CNTP, 2)>
                        <cfset 'total_avg_#offer_id#' = wrk_round(evaluate('total_avg_#offer_id#') + avgp, 2)>
                        <cfset 'avg_row_count_#offer_id#' = evaluate('avg_row_count_#offer_id#') + 1>
                        <td style="text-align:center;">#get_details_pnt_emp.CNTP#</td>
                        <td style="text-align:center;">#get_details_pnt_emp.SUMP#</td>
                        <td style="text-align:center;">#AVGP#</td>
                    <cfelse>
                        <td style="text-align:center;">-</td>
                        <td style="text-align:center;">-</td>
                        <td style="text-align:center;">-</td>
                    </cfif>
                </cfloop>
            </tr>
        </cfoutput>
        <tr>
            <td class="txtboldblue"><cf_get_lang dictionary_id="39247.Ortalama Puan"></td>
            <cfoutput query="get_group_offer">
                <td class="txtboldblue" colspan="3" style="text-align:center;"><cfif evaluate('avg_row_count_#offer_id#') neq 0>#wrk_round(evaluate('total_avg_#offer_id#')/evaluate('avg_row_count_#offer_id#'),2)#<cfelse>-</cfif></td>
            </cfoutput>
        </tr>
    </tbody>
</cf_grid_list>
<script type="text/javascript">
    function open_technical_point_div(comp_par_id,coming_offer_id,comp_id) {
        document.getElementById("technical_point_div").style.display ='';
        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.technical_point&event=add&for_offer_id=<cfoutput>#attributes.offer_id#</cfoutput>&comp_par_id='+comp_par_id+'&coming_offer_id='+coming_offer_id+'&company_id='+comp_id,'technical_point_div',1);
        return false;
    }
</script>