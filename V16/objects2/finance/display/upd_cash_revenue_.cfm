<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">
<cfinclude template="../query/get_action_detail.cfm">
<!---
<table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%;">
	<tr class="color-border">
		<td style="vertical-align:middle;">
			<table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:100%;">
				<tr class="color-list" style="height:35px;">
					<td style="vertical-align:middle;">
						<table align="center" style="width:98%;">
                            <tr>
                            	<td class="headbold"><cf_get_lang no ='1251.Nakit Tahsilat'></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="color-row" style="vertical-align:top;">
                 	<td>
                    	<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%;">
                            <tr>
                            	<td colspan="2"><br/>
                            		<table>
                            			<cfoutput>
                                            <tr style="height:20px;">
                                            	<td class="txtbold" style="width:100px;"><cf_get_lang no ='1249.Makbuz No'></td>
                                            	<td>#get_action_detail.paper_no#</td>
                                            </tr>
                                            <tr style="height:20px;">
                                            	<td class="txtbold"><cf_get_lang_main no ='330.Tarih'></td>
                                            	<cfset adate=dateformat(get_action_detail.action_date,'dd/mm/yyyy')>
                                            	<td>#adate#</td>
                                            </tr>
                                            <tr style="height:20px;">
                                            	<td class="txtbold"><cf_get_lang no ='1252.Tahsil Eden'></td>
                                            	<td>#get_emp_info(get_action_detail.revenue_collector_id,0,0)#</td>
                                            </tr>
                                            <tr style="height:20px;">
                                            	<td class="txtbold"><cf_get_lang_main no ='1195.Firma'></td>
                                            	<td align="left">#get_par_info(get_action_detail.cash_action_from_company_id,1,1,0)#</td>
                                            </tr>
                                            <tr style="height:20px;">
                                                <td class="txtbold"><cf_get_lang_main no ='108.Kasa'></td>
                                                <td>
                                                <cfset cash_id=get_action_detail.cash_action_to_cash_id>
                                                <cfinclude template="../query/get_action_cash.cfm">
                                                #get_action_cash.cash_name# 
                                                </td>
                                            </tr>
                                            <tr style="height:20px;">
                                            	<td class="txtbold"><cf_get_lang_main no ='261.Tutar'></td>
                                                <td>#TLFormat(get_action_detail.cash_action_value)# #get_action_detail.cash_action_currency_id#</td>
                                            </tr>
                                            <tr style="height:20px;">
                                            	<td class="txtbold"><cf_get_lang_main no ='644.Dövizli Tutar'></td>
                                            	<td>#TLFormat(get_action_detail.other_cash_act_value)# #get_action_detail.other_money#</td>
                                            </tr>
                                            <tr style="height:20px;">
                                            	<td valign="top" class="txtbold"><cf_get_lang_main no ='217.Açıklama'></td>
                                            	<td>#get_action_detail.action_detail#</td>
                                            </tr>
										</cfoutput>
                                        <cfif len(get_action_detail.record_emp)>
                                            <tr>
                                                <td nowrap class="txtbold" colspan="2">
                                                    <cf_get_lang_main no='71.Kayıt'> : 
													<cfoutput>#get_emp_info(get_action_detail.record_emp,0,0)#&nbsp;
                                                    <cfif isdefined("session.pp.time_zone")>
                                                    	#dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#
                                                    <cfelseif isdefined("session.ww.time_zone")>
                                                    	#dateformat(date_add('h',session.ww.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.ww.time_zone,get_action_detail.record_date),'HH:MM')#
                                                    </cfif>
													</cfoutput>
                                            	</td>
                                            </tr>
                                        </cfif>
                                        <tr style="height:35px;">
                                            <td colspan="2"  style="text-align:right;"><input type="button" value="Kapat"  onclick="window.close();" style="width:65px;"></td>
                                        </tr>
                                    </table>
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
    <h3><cf_get_lang dictionary_id ='30081.Nakit Tahsilat'></h3>
    <cfoutput>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='50417.Makbuz No'></label><span>: #get_action_detail.paper_no#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='330.Tarih'></label><span>: <cfset adate=dateformat(get_action_detail.action_date,'dd/mm/yyyy')> #adate#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='50233.Tahsil Eden'></label><span>: #get_emp_info(get_action_detail.revenue_collector_id,0,0)#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='1195.Firma'></label><span>: #get_par_info(get_action_detail.cash_action_from_company_id,1,1,0)#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='108.Kasa'></label>
            <span>:
                <cfset cash_id=get_action_detail.cash_action_to_cash_id>
                <cfinclude template="../query/get_action_cash.cfm">
                #get_action_cash.cash_name# 
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='261.Tutar'></label><span>: #TLFormat(get_action_detail.cash_action_value)# #get_action_detail.cash_action_currency_id#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='644.Dövizli Tutar'></label><span>: #TLFormat(get_action_detail.other_cash_act_value)# #get_action_detail.other_money#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='217.Açıklama'></label><span>: #get_action_detail.action_detail#</span>
        </div>
    </cfoutput>
    <cfif len(get_action_detail.record_emp)>
        <div class="area_colmn">
            <label><cf_get_lang_main no='71.Kayıt'> </label>
            <span>:
                <cfoutput>#get_emp_info(get_action_detail.record_emp,0,0)#&nbsp;
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
        <input type="button" value="Kapat" onclick="window.close();">
    </div> --->
</hgroup>
