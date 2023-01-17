<cfquery name="GET_SERVICE_OPS" datasource="#DSN3#">
    SELECT 
        SO.SERVICE_EMP_ID, 
        SO.SERVICE_ID,
        ISNULL(SUM(SO.PREDICTED_AMOUNT),0) AS PREDICTED_AMOUNT, 
        ISNULL(SUM(SO.AMOUNT),0) AS AMOUNT,
        UNIT
    FROM 
    	SERVICE_OPERATION SO
    WHERE 
        SO.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">  
    GROUP BY 
        SO.SERVICE_EMP_ID, 
        SO.SERVICE_ID,
        UNIT
</cfquery>
<cfset service_emp_list = ''>
<cfoutput query="get_service_ops">
	<cfif len(service_emp_id) and not listfindnocase(service_emp_list,service_emp_id,',')>
    	<cfset service_emp_list = listAppend(service_emp_list,service_emp_id,',')>
    </cfif>
</cfoutput>

<cfquery name="GET_SERVICE_WORKS" datasource="#DSN#">
	SELECT
    	WORK_ID
    FROM
    	PRO_WORKS
    WHERE
    	SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        AND OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>

<cfset ser_work_id_list = ''>
<cfoutput query="get_service_works">
	<cfif len(work_id) and not listfindnocase(ser_work_id_list,work_id,',')>
    	<cfset ser_work_id_list = listAppend(ser_work_id_list,work_id,',')>
    </cfif>
</cfoutput>

<cfquery name="GET_SERVICE_TIME_COSTS" datasource="#DSN#">
    SELECT 
        TC.EMPLOYEE_ID, 
        TC.SERVICE_ID, 
        ISNULL(SUM(TC.EXPENSED_MINUTE),0) AS TOTAL_EXPENSED_TIME 
    FROM 
        #dsn_alias#.TIME_COST TC 
    WHERE 
        TC.OUR_COMPANY_ID = #session.ep.company_id# AND
        TC.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> 
		<cfif len(ser_work_id_list)>
			OR TC.WORK_ID IN (#ser_work_id_list#)
        </cfif>
    GROUP BY 
        TC.EMPLOYEE_ID , 
        TC.SERVICE_ID
</cfquery>

<cfoutput query="get_service_time_costs">
	<cfif len(employee_id) and not listfindnocase(service_emp_list,employee_id,',')>
    	<cfset service_emp_list = listAppend(service_emp_list,employee_id,',')>
    </cfif>
</cfoutput>

<cf_ajax_list>
	<thead>
        <tr>
            <th><cf_get_lang_main no='164.Çalışan'></th>
            <th style="text-align:right;"><cf_get_lang no='71.Öngörülen'></th>
            <th style="text-align:right;"><cf_get_lang no='83.Gerçekleşen'></th>
            <th style="text-align:right;"><cf_get_lang no='86.Faturalanan'></th>
        </tr>
    </thead>
    <tbody>
	    <cfif listlen(service_emp_list,',') gte 1>
        	<cfset total_predicted_amount = 0>
        	<cfset sub_total_expensed_time = 0>
        	<cfset total_amount = 0>
			<cfoutput>
                <cfloop from="1" to="#listlen(service_emp_list,',')#" index="i">
                    <cfquery name="GET_SERVICE_OP" dbtype="query">
                        SELECT * FROM GET_SERVICE_OPS WHERE SERVICE_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(service_emp_list,i,',')#">
                    </cfquery>
                    <cfquery name="GET_SERVICE_TIME_COST" dbtype="query">
                        SELECT * FROM GET_SERVICE_TIME_COSTS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(service_emp_list,i,',')#">
                    </cfquery>
                    <cfif get_service_time_cost.recordcount>
                        <cfset exp_hour = listgetat(get_service_time_cost.total_expensed_time / 60,1,'.')>
                        <cfset total_exp_hour = exp_hour * 60>
                        <cfset exp_min = get_service_time_cost.total_expensed_time - total_exp_hour>
	                    <cfset sub_total_expensed_time = sub_total_expensed_time + get_service_time_cost.total_expensed_time>
                    <cfelse>
                        <cfset exp_hour = 0>
                        <cfset exp_min = 0>
                    </cfif>
                    <cfif get_service_op.recordcount>
                        <cfset predicted_amount = get_service_op.predicted_amount>
                        <cfset amount = get_service_op.amount>
                        <cfset total_predicted_amount = total_predicted_amount + get_service_op.predicted_amount>
                        <cfset total_amount = total_amount + get_service_op.amount>                        
                    <cfelse>
                        <cfset predicted_amount = 0>
                        <cfset amount = 0>
                    </cfif>
                    <tr>
                        <td>#get_emp_info(listgetat(service_emp_list,i,','),0,1)#</td>
                        <td style="text-align:right;">
                            <cfloop query="get_service_op" group ="unit">
                                #predicted_amount# #unit#
                            </cfloop>
                        </td>
                        <td style="text-align:right;">#exp_hour# : #exp_min# <cf_get_lang_main no='79.saat'></td>
                        <td style="text-align:right;">
                            <cfloop query="get_service_op" group ="unit">
                                #amount# #unit#
                            </cfloop>
                        </td>
                    </tr>
                </cfloop>         
				<cfset sub_exp_hour = listgetat(sub_total_expensed_time / 60,1,'.')>
                <cfset sub_total_exp_hour = sub_exp_hour * 60>
                <cfset sub_exp_min = sub_total_expensed_time - sub_total_exp_hour>
                <tfoot>
                    <tr>
                        <td class="txtbold"><cf_get_lang_main no='1737.Toplam Tutar'> :</td>
                        <td class="txtbold" style="text-align:right;">
                            <cfloop query="get_service_ops" group ="unit"> 
                                #predicted_amount# #unit# <br>
                            </cfloop>
                        </td>
                        <td class="txtbold" style="text-align:right;">#sub_exp_hour# : #sub_exp_min# <cf_get_lang_main no='79.saat'> </td>
                        <td class="txtbold" style="text-align:right;">
                            <cfloop query="get_service_ops" group ="unit"> 
                                #amount# #unit# <br>
                            </cfloop>
                        </td>
                    </tr>
                </tfoot>
            </cfoutput>
        <cfelse>
        	<tr>
    			<td colspan="4"><cf_get_lang_main no='72.Kayıt Yok'></td>        	
            </tr>
	    </cfif>
    </tbody>
</cf_ajax_list>
