<cfif attributes.report_type eq 3 or attributes.report_type eq 4 >
	<cfset title_name = 'PRODUCT_NAME'>
	<cfset table_name = 'PRODUCT'>
    <cfset title_table = #dsn1_alias#&'.'&'WORKNET_PRODUCT'>
    <cfset attributes.uid = attributes.pid>
    <cfset uniqe_id = 'PRODUCT_ID'>
<cfelseif attributes.report_type eq 5>
	<cfset title_name = 'DEMAND_HEAD'>
	<cfset table_name = 'DEMAND'>
    <cfset title_table = 'WORKNET_DEMAND'>
    <cfset uniqe_id = 'DEMAND_ID'>
    <cfset attributes.uid = attributes.demand_id>
<cfelseif attributes.report_type eq 1>
	<cfset uniqe_id = 'COMPANY_ID'>
	<cfset title_name = 'FULLNAME'>
	<cfset table_name = 'MEMBER'>
    <cfset title_table = 'COMPANY'>
    <cfset attributes.uid = attributes.member_id>
</cfif>
<cfloop index="aa" from="1" to="12">
    <cfquery name="get_count_product_#aa#" datasource="#dsn#_report">
       if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_VISIT_2012_#aa#_GENERAL')
       BEGIN
        SELECT COUNT(USER_ID) AS TOPLAM,PROCESS_ID FROM  WRK_VISIT_2012_#aa#_GENERAL WHERE PROCESS_ID = #attributes.uid# AND PROCESS_TYPE='#table_name#' GROUP BY PROCESS_ID
       END
    </cfquery>
</cfloop>

<cfquery name="get_product_name" datasource="#dsn#">
	SELECT #title_name# AS NAME   FROM #title_table# WHERE #uniqe_id# = #attributes.uid#
</cfquery>

<cf_big_list_search title="<cfoutput>#get_product_name.NAME#</cfoutput>"></cf_big_list_search>
<cf_big_list>
	<thead>
    	<th><cf_get_lang dictionary_id='58672.Aylar'></th>
        <th><cf_get_lang dictionary_id='59164.Tıklanma Sayısı'></th>
    </thead>
	<tbody>
    	<cfloop index="bb" from="1" to="12">
	        <cfoutput>
                <tr>
                    <td id="file_row#attributes.uid##bb#" onClick="gizle_goster(file_row_detail#bb##attributes.uid#);connectAjax('#bb#','#attributes.uid#');">
                        <img id="file_goster#bb##attributes.uid#" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">#listGetAt(ay_list(),bb,',')#
                    </td>
                    <td><cfif isdefined("get_count_product_#bb#") and  Evaluate("get_count_product_#bb#.recordcount") >#Evaluate("get_count_product_#bb#.TOPLAM")#<cfelse>0</cfif></td>
                </tr>
                <tr id="file_row_detail#bb##attributes.uid#" style="display:none" class="nohover">
                    <td colspan="2">
                        <div align="left" id="file_row_div#bb##attributes.uid#"></div>
                    </td>
                </tr>
            </cfoutput>
        </cfloop>
	</tbody>
</cf_big_list>

<script language="javascript">
	function connectAjax(crtrow,pid)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=report.emptypopup_list_product_row</cfoutput>&month='+crtrow+'&object_name='+ pid+'&report_type='+<cfoutput>#attributes.report_type#</cfoutput>;
		AjaxPageLoad(bb,'file_row_div'+crtrow+<cfoutput>#attributes.uid#</cfoutput>,1);
	}
</script>

