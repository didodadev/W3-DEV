<cfquery name="GET_INVOICE_CLOSE" datasource="#DSN2#">
	SELECT  
    	CARI_CLOSED_HISTORY.*,
        ISNULL(CARI_CLOSED_HISTORY.UPDATE_DATE,CARI_CLOSED_HISTORY.RECORD_DATE) AS UPDATE_DATE1,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS UPDATE_NAME 
	FROM
		CARI_CLOSED_HISTORY
        LEFT JOIN #dsn_alias#.EMPLOYEES E ON CARI_CLOSED_HISTORY.UPDATE_EMP = E.EMPLOYEE_ID
	WHERE
		CLOSED_ID = #attributes.act_id# AND 
        HISTORY_ACT_TYPE = #attributes.action_type#							
    ORDER BY
        UPDATE_DATE DESC     
</cfquery>
<cfset record_list = "">
<cfset process_stage_list=''>
<cfset paymet_hod_list=''>
<cfset temp_ = 0>
<cfoutput query="get_invoice_close">
	<cfif len(record_emp) and not listfind(record_list,record_emp)>
		<cfset record_list=listappend(record_list,record_emp)>
    </cfif>
    <cfif len(update_emp) and not listfind(record_list,update_emp)>
		<cfset record_list=listappend(record_list,update_emp)>
    </cfif>
	<cfif len(process_stage) and not listfind(process_stage_list,process_stage)>
        <cfset process_stage_list=listappend(process_stage_list,process_stage)>
    </cfif>
    <cfif len(paymethod_id) and not listfind(paymet_hod_list,paymethod_id)>
        <cfset paymet_hod_list=listappend(paymet_hod_list,paymethod_id)>
    </cfif>
</cfoutput>
<cfif len(process_stage_list)>
	<cfquery name="get_process_names" datasource="#dsn#">
    	SELECT 
            STAGE,
            PROCESS_ROW_ID
        FROM 
            PROCESS_TYPE_ROWS
        WHERE 
            PROCESS_ROW_ID IN(#process_stage_list#) 
        ORDER BY
        	PROCESS_ROW_ID
    </cfquery>
    <cfset main_process_stage_list = listsort(listdeleteduplicates(valuelist(get_process_names.PROCESS_ROW_ID,',')),'numeric','ASC',',')>
</cfif>
<cfif len(paymet_hod_list)>
	<cfquery name="get_paym_1" datasource="#dsn#">
          SELECT 
              PAYMETHOD,
              PAYMETHOD_ID
          FROM 
              SETUP_PAYMETHOD
          WHERE 
              PAYMETHOD_ID IN(#paymet_hod_list#)
          ORDER BY
          	  PAYMETHOD_ID    
   </cfquery>
   <cfset result_paymet_hod_list = listsort(listdeleteduplicates(valuelist(get_paym_1.PAYMETHOD_ID,',')),'numeric','ASC',',')>
</cfif>
<cfif len(record_list)>
	<cfset record_list = listsort(record_list,'numeric','ASC',',')>
	<cfquery name="get_record" datasource="#DSN#">
		SELECT 
			EMPLOYEE_ID,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM 
			EMPLOYEES
		WHERE
			EMPLOYEE_ID IN (#record_list#) 
		ORDER BY
			EMPLOYEE_ID
	</cfquery>
	<cfset record_list = listsort(listdeleteduplicates(valuelist(get_record.employee_id,',')),'numeric','ASC',',')>
</cfif>
<cfif GET_INVOICE_CLOSE.recordcount>
	<cfoutput query="GET_INVOICE_CLOSE">
		<cfquery name="GET_INVOICE_CLOSE_ROW" datasource="#dsn2#">
			SELECT 
				CR.PAPER_NO,
				CR.ACTION_NAME,
				ICR.OTHER_PAYMENT_VALUE,
				ICR.OTHER_P_ORDER_VALUE,
				ICR.OTHER_CLOSED_AMOUNT,
				ICR.OTHER_MONEY
			FROM 
				CARI_CLOSED_ROW_HISTORY ICR,
				CARI_ROWS CR
			WHERE
				ICR.CLOSED_ID = #GET_INVOICE_CLOSE.CLOSED_ID#
				AND ICR.WRK_ID = '#GET_INVOICE_CLOSE.WRK_ID#'
				AND CR.ACTION_ID = ICR.ACTION_ID
				AND	CR.OTHER_MONEY = ICR.OTHER_MONEY 
				AND	CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
				AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
				AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
		</cfquery>
        <cfset temp_ = temp_ +1>
        <cf_seperator id="history_#temp_#" header="#dateformat(update_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,update_date1),timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
		<table class="ajax_list" id="history_#temp_#" >			
		
					<tbody>
						<tr>
							<td><cf_get_lang dictionary_id='57587.Borç'> </td>
							<td>#TLFormat(get_invoice_close.payment_debt_amount_value)# #get_invoice_close.other_money#</td>
							<td><cf_get_lang dictionary_id='57742.Tarih'></td>
							<td>#dateformat(get_invoice_close.PAPER_ACTION_DATE,dateformat_style)#</td>
							<td><cf_get_lang dictionary_id='57482.Aşama'></td>
							<td>
								<cfif len(process_stage_list) and len(process_stage)>
									#get_process_names.STAGE[listfind(main_process_stage_list,process_stage)]#
								</cfif>
						   </td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57588.Alacak'></td>
							<td>#TLFormat(get_invoice_close.payment_claim_amount_value)# #get_invoice_close.other_money#</td>
							<td><cf_get_lang dictionary_id='57861.Ortalama Vade'></td>
							<td>#dateformat(get_invoice_close.PAPER_DUE_DATE,dateformat_style)# </td>
							<td><cf_get_lang dictionary_id='57416.Proje'></td>
							<td><cfif len(get_invoice_close.project_id)>#get_project_name(get_invoice_close.project_id)#</cfif></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57673.Tutar'></td>
							<td>#TLFormat(get_invoice_close.payment_diff_amount_value)# #get_invoice_close.other_money# 
							   #TLFormat(get_invoice_close.difference_amount_value)#
							</td>
							<td><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
							<td>
							   <cfif len(paymet_hod_list) and len(paymethod_id)>
									#get_paym_1.PAYMETHOD[listfind(result_paymet_hod_list,paymethod_id)]#
								</cfif>
							</td>
							<td><cf_get_lang dictionary_id='36199.Açıklama'></td>
							<td colspan="2">#get_invoice_close.ACTION_DETAIL#</td>
						 </tr>
						<tr>
							<td><cf_get_lang dictionary_id='57880.Belge No'></td>
							<td><cf_get_lang dictionary_id='57800.İşlem Tipi'></td>
							<td><cf_get_lang dictionary_id='57673.Tutar'></td>
							<td><cf_get_lang dictionary_id='58121.İşlem Dövizi'></td>
								<td></td>
								<td></td>
						</tr>
						<cfloop query="GET_INVOICE_CLOSE_ROW">						
							<tr>
								<td>#PAPER_NO#</td> 
								<td>#ACTION_NAME#</td>
								<td>
									<cfif attributes.action_type eq 1>
										#tlformat(other_closed_amount)#
									<cfelseif attributes.action_type eq 2>
										#tlformat(other_payment_value)#
									<cfelseif attributes.action_type eq 3>
										#tlformat(other_p_order_value)#
									</cfif>
								</td>
								<td>
									#other_money#
								</td>	
								<td></td>	
								<td></td>						
							</tr>
						</cfloop>
							<tr colspan="10">
								<td><cf_get_lang dictionary_id='57899.Kaydeden'></td>
								<td>
									#get_record.employee_name[listfind(record_list,record_emp,',')]# #get_record.employee_surname[listfind(record_list,record_emp,',')]# 						
								</td>
								<td>
									#DateFormat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#
								</td>
							</tr>
				 </tbody>  
				
		</table>
		
	</cfoutput>
<cfelse>
	<cf_get_lang dictionary_id='57484.Kayıt yok'> !
</cfif>
