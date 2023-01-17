<cfquery name="get_count_DEMAND_12" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_12_DEMAND')
   BEGIN
    SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_12_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END
</cfquery>

<cfquery name="get_count_DEMAND_11" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_11_DEMAND')
   BEGIN
    SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_11_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END
</cfquery>

<cfquery name="get_count_DEMAND_10" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_10_DEMAND')
   BEGIN
    SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_10_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END
</cfquery>

<cfquery name="get_count_DEMAND_9" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_9_DEMAND')
   BEGIN
    SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_9_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END
</cfquery>

<cfquery name="get_count_DEMAND_8" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_8_DEMAND')
   BEGIN
    SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_8_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END
</cfquery>

<cfquery name="get_count_DEMAND_7" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_7_DEMAND')
   BEGIN
     SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_7_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END
</cfquery>

<cfquery name="get_count_DEMAND_6" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_6_DEMAND')
   BEGIN
    SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_6_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END 
</cfquery>

<cfquery name="get_count_DEMAND_5" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_5_DEMAND')
   BEGIN
    SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_5_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END
</cfquery>

<cfquery name="get_count_DEMAND_4" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_4_DEMAND')
   BEGIN
    SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_4_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END
</cfquery>

<cfquery name="get_count_DEMAND_3" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_3_DEMAND')
   BEGIN
    SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_3_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END
</cfquery>

<cfquery name="get_count_DEMAND_2" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_2_DEMAND')
   BEGIN
    SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_2_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END
</cfquery>

<cfquery name="get_count_DEMAND_1" datasource="workcube_cf_report">
   if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_1_DEMAND')
   BEGIN
        SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_1_DEMAND WHERE PROCESS_ID = #attributes.demand_id# GROUP BY PROCESS_ID
   END 
</cfquery>
<cfquery name="get_DEMAND_name" datasource="#dsn#">
	SELECT DEMAND_HEAD FROM WORKNET_DEMAND WHERE DEMAND_ID = #attributes.demand_id#
</cfquery>

<cf_big_list_search title="<cfoutput>#get_DEMAND_name.DEMAND_HEAD#</cfoutput>"></cf_big_list_search>
<cf_big_list>
	<thead>
    	<th>Aylar</th>
        <th>Tıklanma Sayısı</th>
    </thead>
	<tbody>
        <tr> 
            <td id="file_row1" onClick="gizle_goster(file_row_detail1);connectAjax('1','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster1" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57592.Ocak'>
            </td>
            <td>
                <cfoutput>
                    <cfif  isdefined("get_count_DEMAND_1") and  get_count_DEMAND_1.recordcount >#get_count_DEMAND_1.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail1" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div1"></div>
            </td>
        </tr>
        <tr> 
            <td nowrap id="file_row2" onClick="gizle_goster(file_row_detail2);connectAjax('2','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster2" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57593.Subat'>
            </td>
            <td>
                <cfoutput>
                    <cfif isdefined("get_count_DEMAND_2") and get_count_DEMAND_2.recordcount>#get_count_DEMAND_2.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail2" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div2"></div>
            </td>
        </tr>
        <tr> 
            <td nowrap id="file_row3" onClick="gizle_goster(file_row_detail3);connectAjax('3','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster3" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57594.Mart'>
            </td>
            <td>
                <cfoutput>
                    <cfif isdefined("get_count_DEMAND_3") and get_count_DEMAND_3.recordcount>#get_count_DEMAND_3.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail3" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div3"></div>
            </td>
        </tr>
        <tr> 
            <td nowrap id="file_row4" onClick="gizle_goster(file_row_detail4);connectAjax('4','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster4" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57595.Nisan'>
            </td>
            <td>
                <cfoutput>
                    <cfif isdefined("get_count_DEMAND_4") and get_count_DEMAND_4.recordcount>#get_count_DEMAND_4.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail4" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div4"></div>
            </td>
        </tr>
        <tr> 
            <td nowrap id="file_row5" onClick="gizle_goster(file_row_detail5);connectAjax('5','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster5" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57596.Mayıs'>
            </td>
            <td>
                <cfoutput>
                    <cfif isdefined("get_count_DEMAND_5") and get_count_DEMAND_5.recordcount>#get_count_DEMAND_5.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail5" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div5"></div>
            </td>
        </tr>
        <tr> 
            <td nowrap id="file_row6" onClick="gizle_goster(file_row_detail6);connectAjax('6','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster6" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57597.Haziran'>
            </td>
            <td>
                <cfoutput>
                    <cfif isdefined("get_count_DEMAND_6") and get_count_DEMAND_6.recordcount>#get_count_DEMAND_6.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail6" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div6"></div>
            </td>
        </tr>
        <tr> 
            <td nowrap id="file_row7" onClick="gizle_goster(file_row_detail7);connectAjax('7','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster7" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57598.Temmuz'>
            </td>
            <td>
                <cfoutput>
                    <cfif  isdefined("get_count_DEMAND_7") and get_count_DEMAND_7.recordcount>#get_count_DEMAND_7.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail7" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div7"></div>
            </td>
        </tr>
        <tr> 
            <td nowrap id="file_row8" onClick="gizle_goster(file_row_detail8);connectAjax('8','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster8" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57599.Agustos'>
            </td>
            <td>
                <cfoutput>
                    <cfif isdefined("get_count_DEMAND_8") and get_count_DEMAND_8.recordcount>#get_count_DEMAND_8.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail8" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div8"></div>
            </td>
        </tr>
        <tr> 
            <td nowrap id="file_row9" onClick="gizle_goster(file_row_detail9);connectAjax('9','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster9" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57600.Eylul'>
            </td>
            <td>
                <cfoutput>
                    <cfif isdefined("get_count_DEMAND_9") and get_count_DEMAND_9.recordcount>#get_count_DEMAND_9.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail9" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div9"></div>
            </td>
        </tr>
        <tr> 
            <td nowrap id="file_row10" onClick="gizle_goster(file_row_detail10);connectAjax('10','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster10" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57601.Ekim'>
            </td>
            <td>
                <cfoutput>
                    <cfif isdefined("get_count_DEMAND_10") and get_count_DEMAND_10.recordcount>#get_count_DEMAND_10.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail10" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div10"></div>
            </td>
        </tr>
        
        <tr> 
            <td nowrap id="file_row11" onClick="gizle_goster(file_row_detail11);connectAjax('11','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster11" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57602.Kasım'>
            </td>
            <td>
                <cfoutput>
                    <cfif isdefined("get_count_DEMAND_11") and get_count_DEMAND_11.recordcount>#get_count_DEMAND_11.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail11" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div11"></div>
            </td>
        </tr>
        <tr> 
            <td nowrap id="file_row12" onClick="gizle_goster(file_row_detail12);connectAjax('12','<cfoutput>#attributes.demand_id#</cfoutput>');">
                <img id="file_goster12" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>"><cf_get_lang dictionary_id='57603.Aralık'>
            </td>
            <td>
                <cfoutput>
                    <cfif isdefined("get_count_DEMAND_12") and get_count_DEMAND_12.recordcount>#get_count_DEMAND_12.TOPLAM#<cfelse>0</cfif>
                </cfoutput>
            </td>
        </tr>
        <tr id="file_row_detail12" style="display:none" class="nohover">
            <td colspan="2">
                <div align="left" id="file_row_div12"></div>
            </td>
        </tr>
	</tbody>
</cf_big_list>

<script language="javascript">
	function connectAjax(crtrow,demand_id)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=report.emptypopup_list_demand_row</cfoutput>&month='+crtrow+'&object_name='+ demand_id;
		AjaxPageLoad(bb,'file_row_div'+crtrow,1);
	}
</script>

