<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">
<cfinclude template="../query/get_action_detail.cfm">
<!---
<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%; height:100%;">
	<tr class="color-list" style="vertical-align:middle;height:35px;"> 
		<td> 
			<table align="center" style="width:98%;">
				<tr> 
					<td class="headbold" style="vertical-align:bottom;"><cf_get_lang_main no='422.Gelen Havale'></td>
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
								<cfset adate=dateformat(get_action_detail.action_date,'dd/mm/yyyy')>
								<td>#adate#</td>
							</tr>
							<!--- hangi cari hesaptan --->
                            <tr style="height:20px;"> 
                            	<td class="txtbold"><cf_get_lang_main no ='107.Cari Hesap'></td>
                                <td>
									<cfif len(get_action_detail.action_from_company_id)>
                                        #get_par_info(get_action_detail.action_from_company_id,1,1,0)# <cf_get_lang no ='1254.cari hesabından'>
                                    <cfelse>
                                        #get_cons_info(get_action_detail.action_from_consumer_id,0,0)#<cf_get_lang no ='1220.Hesabından'> 
                                    </cfif>
                            	</td>
                            </tr>
                            <!--- hangi hesaba --->
                            <tr style="height:20px;">  
                            	<td class="txtbold"><cf_get_lang_main no ='240.Hesap'></td>
                                <td>
                                    <cfset account_id = get_action_detail.action_to_account_id>
                                    <cfinclude template="../query/get_action_account.cfm">
                                    #get_action_account.account_name#<cf_get_lang no ='1253.Hesabına'> 
                                </td>
                            </tr>
                            <tr style="height:20px;">  
                            	<td class="txtbold"><cf_get_lang_main no ='261.Tutar'></td>
                            	<td> #TLFormat(get_action_detail.action_value)# #get_action_account.account_currency_id#</td>
                            </tr>
                            <tr style="height:20px;"> 
                            	<td class="txtbold"><cf_get_lang_main no ='644.Dövizli Tutar'></td>
                            	<td> #TLFormat(get_action_detail.other_cash_act_value)# #get_action_detail.other_money#</td>
                            </tr>
                            <tr style="height:20px;"> 
                            	<td class="txtbold" style="vertical-align:top;"><cf_get_lang_main no ='217.Açıklama'></td>
                            	<td> 
                            		#get_action_detail.action_detail#
                            	</td>
                            </tr>
                            </cfoutput>
                            <tr style="height:35px;"> 
                            	<td colspan="2" style="text-align:right;"> 
                            		<input type="Button" style="width:65px;" value="Kapat" onclick="window.close();">
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
<cfoutput> 
    <hgroup class="finance_display">
        <h3><cf_get_lang_main no='422.Gelen Havale'></h3>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='330.Tarih'></label><span>: <cfset adate=dateformat(get_action_detail.action_date,'dd/mm/yyyy')> #adate#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='107.Cari Hesap'></label>
            <span>: 
                <cfif len(get_action_detail.action_from_company_id)>
                    #get_par_info(get_action_detail.action_from_company_id,1,1,0)# <cf_get_lang dictionary_id ='48728.cari hesabından'>
                <cfelse>
                    #get_cons_info(get_action_detail.action_from_consumer_id,0,0)#<cf_get_lang dictionary_id ='35541.Hesabından'> 
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='240.Hesap'></label>
            <span>: 
                <cfset account_id = get_action_detail.action_to_account_id>
                <cfinclude template="../query/get_action_account.cfm">
                #get_action_account.account_name# <cf_get_lang dictionary_id ='35574.Hesabına'> 
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='261.Tutar'></label><span>: #TLFormat(get_action_detail.action_value)# #get_action_account.account_currency_id#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='644.Dövizli Tutar'></label><span>: #TLFormat(get_action_detail.other_cash_act_value)# #get_action_detail.other_money#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='217.Açıklama'></label><span>: #get_action_detail.action_detail#</span>
        </div>
        <!--- <div class="area_colmn">
            <input type="button" value="Kapat" onclick="window.close();">
        </div> --->
    </hgroup>
</cfoutput>
