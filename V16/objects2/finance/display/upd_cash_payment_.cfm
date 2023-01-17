<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfinclude template="../query/get_action_detail.cfm">
<cfquery name="GET_COST_WITH_EXPENSE_ROWS_ID" datasource="#db_adres#">
	SELECT 
		EXPENSE_CENTER_ID,
        EXPENSE_ITEM_ID
	FROM 
		EXPENSE_ITEMS_ROWS 
	WHERE	
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfif len(get_cost_with_expense_rows_id.expense_center_id)>
    <cfquery name="GET_EXPENSE" datasource="#db_adres#">
      	SELECT 
          	EXPENSE
      	FROM 
          	EXPENSE_CENTER 
      	WHERE 
          	EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_cost_with_expense_rows_id.expense_center_id#">
    </cfquery>
</cfif>
<cfif len(get_cost_with_expense_rows_id.expense_item_id)>
    <cfquery name="GET_EXPENSE_ITEM" datasource="#db_adres#">
        SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cost_with_expense_rows_id.expense_item_id#">
    </cfquery>
</cfif>
<!---
<table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%;">
	<tr class="color-border"> 
    	<td style="vertical-align:middle;"> 
      		<table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:100%;">
        		<tr class="color-list" style="height:35px;vertical-align:middle;"> 
          			<td> 
            			<table align="center" style="width:98%;">
              				<tr> 
                				<td class="headbold" style="vertical-align:bottom;"><cf_get_lang no ='1250.Ödeme İşlemi'></td>
              				</tr>
            			</table>
          			</td>
        		</tr>
            	<tr class="color-row"> 
                 	<td style="vertical-align:top;">  
                   		<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%;">
                        	<tr> 
                          		<td colspan="2">
                                	<br/>				
                                    <table>
                                        <cfoutput>
                                            <tr style="height:20px;">
                                                <td class="txtbold" style="width:100px;"><cf_get_lang no ='1249.Makbuz No'></td>
                                                <td>#get_action_detail.paper_no#</td>
                                            </tr>
                                            <tr style="height:20px;">     	  
                                                <td class="txtbold"><cf_get_lang_main no ='330.Tarih'></td>
                                                <td>#dateformat(get_action_detail.action_date,'dd/mm/yyyy')#</td>
                                            </tr>
                                            <tr style="height:20px;">
                                                <td class="txtbold"><cf_get_lang no ='1229.Ödeme Yapan'></td>
                                                <td><cfif len(get_action_detail.payer_id)>#get_emp_info(get_action_detail.payer_id,0,0)#</cfif></td>
                                            </tr>
                                            <tr style="height:20px;">
                                                <td class="txtbold"><cf_get_lang_main no ='108.Kasa'></td>
                                                <td> 
                                                    <cfset cash_id=get_action_detail.cash_action_from_cash_id>
                                                    <cfinclude template="../query/get_action_cash.cfm">
                                                    #get_action_cash.cash_name#
                                                </td>
                                            </tr>
                                            <cfif len(get_action_detail.cash_action_to_company_id)>
                                                <tr style="height:20px;">
                                                    <td class="txtbold"><cf_get_lang_main no ='1195.Firma'></td>
                                                    <td>#get_par_info(get_action_detail.cash_action_to_company_id,1,1,0)#</td>
                                                </tr>
                                            </cfif>
                                            <cfif len(get_action_detail.cash_action_to_employee_id)>
                                                <tr style="height:20px;">
                                                    <td class="txtbold"><cf_get_lang_main no ='164.Çalışan'></td>
                                                    <td>#get_emp_info(get_action_detail.cash_action_to_employee_id,0,0)#</td>
                                                </tr>
                                            </cfif>
                                            <cfif len(get_action_detail.cash_action_to_consumer_id)>
                                                <tr style="height:20px;">
                                                    <td class="txtbold"><cf_get_lang_main no ='246.Üye'></td>
                                                    <td>#get_cons_info(get_action_detail.cash_action_to_consumer_id,0,0)#</td>
                                                </tr>
                                            </cfif>
                                            <tr>
                                                <td class="txtbold"><cf_get_lang_main no ='1048.Masraf Merkezi'></td>
                                                <td><cfif len(get_cost_with_expense_rows_id.expense_center_id)>#get_expense.expense#</cfif></td>
                                            </tr>
                                            <tr>
                                                <td class="txtbold"><cf_get_lang_main no ='1139.Gider Kalemi'></td>
                                                <td><cfif len(get_cost_with_expense_rows_id.expense_item_id)>#get_expense_item.expense_item_name#</cfif></td>
                                            </tr>
                                            <tr>
                                                <td class="txtbold" style="height:20px;"><cf_get_lang_main no ='261.Tutar'></td>
                                                <td>#TLFormat(get_action_detail.cash_action_value)# #get_action_detail.cash_action_currency_id#</td>
                                            </tr>
                                            <tr>
                                                <td class="txtbold" style="height:20px;"><cf_get_lang_main no ='644.Dövizli Tutar'></td>
                                                <td>#TLFormat(get_action_detail.other_cash_act_value)# #get_action_detail.other_money#</td>
                                            </tr>
                                            <tr style="height:20px;">
                                                <td class="txtbold" style="vertical-align:top;"><cf_get_lang_main no ='217.Açıklama'></td>
                                                <td>#get_action_detail.action_detail#</td>
                                            </tr>		
                                        </cfoutput>
										<cfif len(get_action_detail.record_emp)>
                                            <tr>
                                                <td nowrap class="txtbold" colspan="2"><cf_get_lang_main no='71.Kayıt'> :<cfoutput>#get_emp_info(get_action_detail.record_emp,0,0)# 
                                                    &nbsp;
                                                    <cfif isdefined("session.pp.time_zone")>
                                                        #dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#</td>
                                                    <cfelseif isdefined("session.ww.time_zone")>
                                                        #dateformat(date_add('h',session.ww.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.ww.time_zone,get_action_detail.record_date),'HH:MM')#</td>
                                                </cfif>
                                            </cfoutput>
                                            </tr>
                                    	</cfif>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td colspan="2" style="height:35px;text-align:right;"> 
                                    <input type="button" value="Kapat" style="width:65px;" onclick="window.close();">
                                </td>
                            </tr>
                        </table>												            
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
--->
<hgroup class="finance_display">
    <h3><cf_get_lang dictionary_id ='54462.Ödeme İşlemi'></h3>
    <cfoutput>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='50417.Makbuz No'></label><span>: #get_action_detail.paper_no#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='57742.Tarih'></label><span>: #dateformat(get_action_detail.action_date,'dd/mm/yyyy')#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='51313.Ödeme Yapan'></label><span>: <cfif len(get_action_detail.payer_id)>#get_emp_info(get_action_detail.payer_id,0,0)#</cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='57520.Kasa'></label>
            <span>:
                <cfset cash_id=get_action_detail.cash_action_from_cash_id>
                <cfinclude template="../query/get_action_cash.cfm">
                #get_action_cash.cash_name#
            </span>
        </div>
        <cfif len(get_action_detail.cash_action_to_company_id)>
            <div class="area_colmn">
                <label><cf_get_lang dictionary_id ='58607.Firma'></label><span>: #get_par_info(get_action_detail.cash_action_to_company_id,1,1,0)#</span>
            </div>  
        </cfif>
        <cfif len(get_action_detail.cash_action_to_employee_id)>
            <div class="area_colmn">
                <label><cf_get_lang dictionary_id ='57576.Çalışan'></label><span>: #get_emp_info(get_action_detail.cash_action_to_employee_id,0,0)#</span>
            </div>
        </cfif>
        <cfif len(get_action_detail.cash_action_to_consumer_id)>
            <div class="area_colmn">
                <label><cf_get_lang dictionary_id ='57658.Üye'></label><span>: #get_cons_info(get_action_detail.cash_action_to_consumer_id,0,0)#</span>
            </div>
        </cfif>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='58460.Masraf Merkezi'></label><span>: <cfif len(get_cost_with_expense_rows_id.expense_center_id)>#get_expense.expense#</cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='58551.Gider Kalemi'></label><span>: <cfif len(get_cost_with_expense_rows_id.expense_item_id)>#get_expense_item.expense_item_name#</cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='57673.Tutar'></label><span>: #TLFormat(get_action_detail.cash_action_value)# #get_action_detail.cash_action_currency_id#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='58056.Dövizli Tutar'></label><span>: #TLFormat(get_action_detail.other_cash_act_value)# #get_action_detail.other_money#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='57629.Açıklama'></label><span>: #get_action_detail.action_detail#</span>
        </div>
    </cfoutput>
    <cfif len(get_action_detail.record_emp)>                                   
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57483.Kayıt'> </label>
            <span>:
                <cfoutput>#get_emp_info(get_action_detail.record_emp,0,0)# 
                    <cfif isdefined("session.pp.time_zone")>
                        #dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#
                    <cfelseif isdefined("session.ww.time_zone")>
                        #dateformat(date_add('h',session.ww.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.ww.time_zone,get_action_detail.record_date),'HH:MM')#
                    </cfif>
                </cfoutput>
            </span>
        </div>
    </cfif>
<!---     <div class="area_colmn">
         <input type="button" value="<cf_get_lang_main no='141.Kapat'>" onclick="window.close();">
    </div> --->
</hgroup>
