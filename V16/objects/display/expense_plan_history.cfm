<cfquery name="GET_HISTORY" datasource="#DSN2#">
	SELECT
		*
	FROM
    EXPENSE_ITEM_PLAN_REQUESTS E,
    EXPENSE_ITEM_PLAN_REQUESTS_HISTORY EH
	WHERE
		EH.EXPENSE_ID = E.EXPENSE_ID AND
		EH.EXPENSE_ID = #attributes.act_id#
</cfquery>
<cfquery name="GET_HISTORY_ROW" datasource="#DSN2#">
	SELECT
		*
	FROM
    EXPENSE_ITEM_PLAN_REQUESTS_ROWS ER,
    EXPENSE_ITEM_PLAN_REQUESTS_ROW_HISTORY ERH
	WHERE
		ERH.EXPENSE_ID = ER.EXPENSE_ID AND
		ERH.EXPENSE_ID = #attributes.act_id#
</cfquery>
<cfif get_history.recordcount>
    <cfif len(get_history.expense_stage)>
        <cfquery name="GET_PROCESS_ROW" datasource="#DSN#">
            SELECT
                STAGE
            FROM
            PROCESS_TYPE_ROWS
            WHERE
            PROCESS_ROW_ID =  #get_history.expense_stage#
        </cfquery>
    </cfif>
	<cfset record_list = "">
	<cfoutput query="get_history">
		<cfif len(record_emp) and not listfind(record_list,record_emp)>
			<cfset record_list=listappend(record_list,record_emp)>
		</cfif>
		<cfif len(update_emp) and not listfind(record_list,update_emp)>
			<cfset record_list=listappend(record_list,update_emp)>
		</cfif>
	</cfoutput>
	<cfif len(record_list)>
		<cfset record_list = listsort(record_list,'numeric','ASC',',')>
		<cfquery name="GET_RECORD" datasource="#DSN#">
			 SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_list#) ORDER BY EMPLOYEE_ID
		</cfquery>
		<cfset record_list = listsort(listdeleteduplicates(valuelist(get_record.employee_id,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<style type="text/css">.wrk_history_body tr td {font-size:11px !important;}</style>
    <!---<table class="wrk_history_body" width="100%">--->
    <cfset temp_ = 0>
        <cfif get_history.recordcount>
            <cfoutput query="get_history">
            <cfset txt = "">
             <cfset temp_ = temp_ +1>
             <cfsavecontent variable="txt"><cfif len(update_date) and update_emp>#DateFormat(update_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)# - #get_record.employee_name[listfind(record_list,update_emp,',')]# #get_record.employee_surname[listfind(record_list,update_emp,',')]#<cfelseif len(record_date) and len(record_emp)>#DateFormat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#-#get_record.employee_name[listfind(record_list,record_emp,',')]# #get_record.employee_surname[listfind(record_list,record_emp,',')]#</cfif></cfsavecontent>
         <cf_seperator id="history_#temp_#" header="#txt#" is_closed="1">
        <table id="history_#temp_#" style="display:none;" class="ajax_list">
                <tr>
                    <td><b><cf_get_lang dictionary_id='58616.Belge Numarası'></b></td>
                    <td>#paper_no#</td>
                    <td><b><cf_get_lang dictionary_id='31173.Harcama Yapan'></b></td>
                    <td>#get_emp_info(emp_id,0,0)#</td>
                    <td><b><cf_get_lang dictionary_id='51328.Harcama Tarihi'></b></td>
                    <td>#expense_date#</td>
                </tr>
                <tr>
                    <td><b><cf_get_lang dictionary_id='29534.Toplam Tutar'></b></td>
                    <td>#TLformat(total_amount)#</td>
                    <td><b><cf_get_lang dictionary_id='31169.KDV Tutar'></b></td>
                    <td>#TLformat(net_total_amount)#</td>
                    <td><b><cf_get_lang dictionary_id='51316.KDVli Tutar'></b></td>
                    <td>#TLformat(net_kdv_amount)#</td>
                </tr>
                <tr>
                    <td><b><cf_get_lang dictionary_id='57899.Kaydeden'></b></td>
                    <td>
                        <cfif len(record_list) and len(update_emp)>
                            <strong>#get_record.employee_name[listfind(record_list,update_emp,',')]# #get_record.employee_surname[listfind(record_list,update_emp,',')]#</strong>
                        <cfelseif len(record_list) and len(record_emp)>
                            <strong>#get_record.employee_name[listfind(record_list,record_emp,',')]# #get_record.employee_surname[listfind(record_list,record_emp,',')]#</strong>
                        <cfelseif len(record_cons_list) and len(record_emp)>
                            <strong>#get_record.employee_name[listfind(record_list,update_emp,',')]# #get_record.employee_surname[listfind(record_list,update_emp,',')]#</strong>
                        </cfif>
                    </td>
                    <td>  <cfif len(record_list) and len(update_emp)>
                        <strong>#DateFormat(update_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#</strong>
                    <cfelseif len(record_list) and len(record_emp)>
                        <strong>#DateFormat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</strong>
                    <cfelseif len(record_cons_list) and len(record_emp)>
                        <strong>#DateFormat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</strong>
                    </cfif></td>
                    <td><b><cf_get_lang dictionary_id='58859.Süreç'></b></td>
                    <td><cfif isdefined("GET_PROCESS_ROW") and GET_PROCESS_ROW.recordCount>#GET_PROCESS_ROW.STAGE#</cfif></td>
                    <td></td>
                    <td></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr height="20">
                <td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
            </tr>
        </cfif>
    </table>







