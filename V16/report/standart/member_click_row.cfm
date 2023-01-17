<cfsetting showdebugoutput="no">
<cfquery name="get_demand_click_row" datasource="workcube_cf_report">
    SELECT  
         CASE USER_TYPE WHEN   1 THEN (SELECT COMPANY_PARTNER_NAME +' '+COMPANY_PARTNER_SURNAME AS NAME FROM workcube_cf.COMPANY_PARTNER WHERE PARTNER_ID =wvp.USER_ID) 
                        WHEN   0 THEN (SELECT EMPLOYEE_NAME + '' + EMPLOYEE_SURNAME AS NAME FROM workcube_cf.EMPLOYEES WHERE EMPLOYEE_ID = wvp.USER_ID) 
                        WHEN   2 THEN (SELECT CONSUMER_NAME + '' + CONSUMER_SURNAME AS NAME FROM workcube_cf.CONSUMER WHERE CONSUMER_ID = wvp.USER_ID)   
         ELSE 'Ziyaretçi' END AS USERNAME,
         CASE USER_TYPE WHEN 1 THEN 'Partner'
         				WHEN 2 THEN 'Consumer'
                        WHEN 0 THEN 'Çalışan'
                        ELSE 'Ziyaretçi' END AS TIP,
         VISIT_DATE
    FROM 
         WRK_VISIT_2012_<cfoutput>#month#</cfoutput>_MEMBER wvp
    WHERE 
    	PROCESS_ID = #attributes.object_name#
    ORDER BY 
    	VISIT_DATE DESC
</cfquery>


<cf_form_list>
	<thead>
        <tr>
			<th><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th><cf_get_lang dictionary_id='41644.İşlemi Yapan'></th>
            <th><cf_get_lang dictionary_id='43926.Üye Tipi'></th>
            <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
		</tr>
	</thead>
	<tbody>
	<cfoutput query="get_demand_click_row">
        <tr>
            <td>#currentrow#</td>
            <td>#USERNAME#</td>
            <td>#TIP#</td>
            <td>#DATEFORMAT(VISIT_DATE,dateformat_style)#</td>
        </tr>
    </cfoutput>		
	</tbody>
</cf_form_list>

