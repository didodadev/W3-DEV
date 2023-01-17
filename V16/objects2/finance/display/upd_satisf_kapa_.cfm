<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfinclude template="../query/get_action_detail.cfm">
<!---
<table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%;">
  	<tr class="color-border"> 
    	<td style="vertical-align:middle;"> 
      		<table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:100%;">
        		<tr class="color-list" style="vertical-align:middle; height:35px;"> 
                    <td> 
                        <table align="center" style="width:98%;">
                            <tr> 
	                            <td class="headbold" style="vertical-align:bottom;"><cf_get_lang no ='1262.Satış Faturası Kapama'></td>
                            </tr>
                        </table>
                    </td>
        		</tr>
                <tr class="color-row"> 
                    <td style="vertical-align:top;"> 
		                <table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%;">
                			<tr> 
                                <td colspan="2" style="vertical-align:top;">
                                	<br/>
                                	<table>
                                		<tr style="height:20px;"> 
                                            <td class="txtbold" style="width:100px;"><cf_get_lang_main no ='330.Tarih'></td>
                                            <cfset adate=dateformat(get_action_detail.ACTION_DATE,'dd/mm/yyyy')>
                                            <td><cfoutput>#adate#</cfoutput></td>
                                        </tr>
                                        <!--- hangi kasadan --->
                                        <!--- hangi firmaya --->
                                        <tr style="height:20px;">
                                            <td class="txtbold"><cf_get_lang_main no='29.Fatura'></td>
                                            <td> 
                                            <cfset bill_id=get_action_detail.bill_id>
                                            <cfinclude template="../query/get_action_bill.cfm">
                                            <cfoutput>#get_action_bill.invoice_number# no'lu fatura</cfoutput>
                                            </td>
                                        </tr>
                                        <tr style="height:20px;"> 
                                            <td class="txtbold"><cf_get_lang no ='1260.Kasaya'></td>
                                            <td> 
                                            <cfset cash_id=get_action_detail.cash_action_to_cash_id>
                                            <cfinclude template="../query/get_action_cash.cfm">
                                            <cfoutput>#get_action_cash.cash_name#</cfoutput>
                                            </td>
                                            <td class="txtbold"><cf_get_lang no ='1261.kasasına'></td>
                                        </tr>
                                        <tr style="height:20px;"> 
                                            <td class="txtbold"><cf_get_lang_main no ='261.Tutar'></td>
                                            <td><cfoutput>#TLFormat(get_action_detail.cash_action_value)# #session_base.money#</cfoutput></td>
                                        </tr>
                                        <tr style="height:20px;"> 
                                            <td class="txtbold"><cf_get_lang_main no ='644.Dövizli Tutar'></td>
                                            <td><cfoutput>#TLFormat(get_action_detail.other_cash_act_value)#&nbsp;#get_action_detail.other_money#</cfoutput></td>
                                        </tr>
                                        <tr style="height:20px;"> 
                                            <td class="txtbold" style="vertical-align:top;"><cf_get_lang_main no ='217.Açıklama'></td>
                                            <td><cfoutput>#get_action_detail.action_detail#</cfoutput></td>
                                        </tr>		
                                        <cfif len(get_action_detail.record_emp)>
                                            <tr>
                                                <td nowrap colspan="4" class="txtbold">
                                                    <cf_get_lang_main no='71.Kayıt'> : 
                                                    <cfoutput>
                                                        #get_emp_info(get_action_detail.record_emp,0,0)#
                                                        #dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# 
                                                        #timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#
                                                    </cfoutput>
                                                </td>
                                            </tr>
                                        </cfif>
                                        <tr style="height:35px;"> 
                                        	<td colspan="2" style="text-align:right;"><input type="button" value="Kapat"  onclick="window.close();" style="width:65px;"></td>
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
    <h3><cf_get_lang no ='1262.Satış Faturası Kapama'></h3>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='330.Tarih'></label>
        <span>:
            <cfset adate=dateformat(get_action_detail.ACTION_DATE,'dd/mm/yyyy')>
            <cfoutput>#adate#</cfoutput>
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no='29.Fatura'></label>
        <span>:
            <cfset bill_id=get_action_detail.bill_id>
            <cfinclude template="../query/get_action_bill.cfm">
            <cfoutput>#get_action_bill.invoice_number# no'lu fatura</cfoutput>
         </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang no ='1260.Kasaya'></label>
        <span>:
            <cfset cash_id=get_action_detail.cash_action_to_cash_id>
            <cfinclude template="../query/get_action_cash.cfm">
            <cfoutput>#get_action_cash.cash_name#</cfoutput><cf_get_lang no ='1261.kasasına'>
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='261.Tutar'></label>
        <span>:
        	<cfoutput>#TLFormat(get_action_detail.cash_action_value)# #session_base.money#</cfoutput>
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='644.Dövizli Tutar'></label>
        <span>:
        	<cfoutput>#TLFormat(get_action_detail.other_cash_act_value)#&nbsp;#get_action_detail.other_money#</cfoutput>
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='217.Açıklama'></label>
        <span>:
        	<cfoutput>#get_action_detail.action_detail#</cfoutput>
        </span>
    </div>
    <cfif len(get_action_detail.record_emp)>
        <div class="area_colmn">
            <label><cf_get_lang_main no='71.Kayıt'></label>
            <span>: 
                <cfoutput>
                    #get_emp_info(get_action_detail.record_emp,0,0)#
                    #dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# 
                    #timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#
                </cfoutput>
            </span>
        </div>
    </cfif>
    <div class="area_colmn">
        <input type="button" value="Kapat"  onclick="window.close();">
    </div>
</hgroup>
