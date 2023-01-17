<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">
<cfinclude template="../query/get_action_detail.cfm">
<!---
<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%; height:100%;">
	<tr class="color-list" style="vertical-align:middle;height:35px;">
	  	<td>
			<table align="center" style="width:98%;">
		  		<tr>
					<td class="headbold" style="vertical-align:bottom;"><cf_get_lang_main no ='423.Giden Havale'></td>
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
                            	<td class="txtbold" style="width:100px;"><cf_get_lang_main no ='330.Tarih'></td>
                            	<td>#dateformat(get_action_detail.action_date,"dd/mm/yyyy")#</td>
                            </tr>
                            <!--- hangi hesaptan --->
                            <tr style="height:20px;">
                            	<td class="txtbold"><cf_get_lang_main no ='240.Hesap'></td>
                                <td>
									<cfset account_id=get_action_detail.action_from_account_id>
                                    <cfinclude template="../query/get_action_account.cfm">
                                    #get_action_account.account_name#  <cf_get_lang no ='1220.Hesabından'>
                                </td>
                            </tr>
                            <!--- hangi cari hesaba --->
                            <cfif len(get_action_detail.action_to_company_id)>
                                <tr style="height:20px;">
                                	<td class="txtbold"><cf_get_lang_main no ='1195.Firma'></td>
                                	<td>#get_par_info(get_action_detail.action_to_company_id,1,1,0)# cari hesabına</td>
                                </tr>
                            </cfif>
                            <cfif len(get_action_detail.action_to_consumer_id)>
                                <tr style="height:20px;">
                                	<td class="txtbold"><cf_get_lang_main no ='246.Üye'></td>
                                	<td>#get_cons_info(get_action_detail.action_to_consumer_id,0,0)# hesabına</td>
                                </tr>
                            </cfif>
                            <cfif len(get_action_detail.action_to_employee_id)>
                                <tr style="height:20px;">
                                    <td class="txtbold"><cf_get_lang_main no ='164.Çalışan'></td>
                                    <td>#get_emp_info(get_action_detail.action_to_employee_id,0,0)# hesabına</td>
                                </tr>
                            </cfif>
                            <tr style="height:20px;">
                            	<td class="txtbold"><cf_get_lang_main no ='261.Tutar'></td>
                            	<td>#TLFormat(get_action_detail.action_value-get_action_detail.masraf)# #get_action_account.account_currency_id#</td>
                            </tr>
                            <tr style="height:20px;">
                            	<td class="txtbold"><cf_get_lang_main no ='644.Dövizli Tutar'></td>
                            	<td>#TLFormat(get_action_detail.other_cash_act_value)# #get_action_detail.other_money#</td>
                            </tr>
                            <tr style="height:20px;">
                            	<td valign="top" class="txtbold"><cf_get_lang_main no ='217.Açıklama'></td>
                            	<td>#get_action_detail.action_detail#</td>
                            </tr>
                      		<tr style="height:35px;">
                        		<td colspan="2"  style="text-align:right;">
                          			<input type="Button" value="Kapat" style="width:65px;" onclick="window.close();">
                        		</td>
                      		</tr>
                    	</table>
			  			</cfoutput> 
                    </td>
		  		</tr>
			</table>
	  	</td>
	</tr>
</table>
--->
<cfoutput>
    <hgroup class="finance_display">
        <h3><cf_get_lang dictionary_id ='57835.Giden Havale'></h3>
            <div class="area_colmn">
                <label><cf_get_lang dictionary_id ='57742.Tarih'></label><span>: #dateformat(get_action_detail.action_date,"dd/mm/yyyy")#</span>
            </div>
            <div class="area_colmn">
                <label><cf_get_lang dictionary_id ='57652.Hesap'></label>
                <span>:
                    <cfset account_id=get_action_detail.action_from_account_id>
                    <cfinclude template="../query/get_action_account.cfm">
                    #get_action_account.account_name#  <cf_get_lang dictionary_id ='48707.Hesabından'>
                </span>
            </div>
            <cfif len(get_action_detail.action_to_company_id)>
                <div class="area_colmn">
                    <label><cf_get_lang dictionary_id ='58607.Firma'></label><span>: #get_par_info(get_action_detail.action_to_company_id,1,1,0)#<cf_get_lang dictionary_id="48756.cari hesabına"> </span>
                </div>
            </cfif>
            <cfif len(get_action_detail.action_to_consumer_id)>
                <div class="area_colmn">
                    <label><cf_get_lang dictionary_id ='57658.Üye'></label><span>: #get_cons_info(get_action_detail.action_to_consumer_id,0,0)#<cf_get_lang dictionary_id="48708.hesabına"> </span>
                </div>
            </cfif>                       
            <cfif len(get_action_detail.action_to_employee_id)>
                <div class="area_colmn">
                    <label><cf_get_lang dictionary_id ='57576.Çalışan'></label><span>: #get_emp_info(get_action_detail.action_to_employee_id,0,0)# <cf_get_lang dictionary_id="48708.hesabına"> </span>
                </div>
            </cfif>
            <div class="area_colmn">
                <label><cf_get_lang dictionary_id ='57673.Tutar'></label><span>:<cfif len(get_action_detail.action_value) and len(get_action_detail.masraf)> #TLFormat(get_action_detail.action_value-get_action_detail.masraf)# #get_action_account.account_currency_id#</cfif></span>
            </div>
            <div class="area_colmn">
                <label><cf_get_lang dictionary_id ='58056.Dövizli Tutar'></label><span>:<cfif len(get_action_detail.other_cash_act_value)> #TLFormat(get_action_detail.other_cash_act_value)# #get_action_detail.other_money#</cfif></span>
            </div>
            <div class="area_colmn">
                <label><cf_get_lang dictionary_id ='57629.Açıklama'></label><span>: #get_action_detail.action_detail#</span>
            </div>
<!---             <div class="area_colmn">
                <input type="Button" value="Kapat" onclick="window.close();">
            </div> --->
    </hgroup>
</cfoutput>
