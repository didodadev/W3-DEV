<cfset attributes.var_type = 3>
<cfinclude template="decrypt_finance.cfm">
<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfquery name="GET_PERIOD" datasource="#DSN#">
		SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_CHEQUE" datasource="#db_adres#">
	SELECT 
    	ACCOUNT_ID, 
        CHEQUE_PURSE_NO, 
        CHEQUE_NO, 
        COMPANY_ID, 
        CONSUMER_ID,
        CHEQUE_DUEDATE, 
        CHEQUE_VALUE, 
        CURRENCY_ID, 
        OTHER_MONEY_VALUE, 
        OTHER_MONEY_VALUE2, 
        OTHER_MONEY2, 
        CHEQUE_CITY, 
        CHEQUE_CODE 
    FROM 
    	CHEQUE 
    WHERE 
    	CHEQUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfif len(get_cheque.account_id)>
	<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
		SELECT ACCOUNT_NAME FROM ACCOUNTS WHERE ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cheque.account_id#">
	</cfquery>
</cfif>
<cfoutput query="get_cheque">
    <table cellspacing="0" cellpadding="0" style="width:100%; height:100%;">
      	<tr class="color-border">
        	<td style="vertical-align:top;">
        		<table cellpadding="2" cellspacing="1" style="width:100%; height:100%;">
          			<tr clasS="color-list" style="height:35px;">
            			<td class="headbold"><cf_get_lang dictionary_id = '35537.Çek Detay'></td>
          			</tr>
                  	<tr class="color-row">
                        <td style="vertical-align:top;">
                            <table border="0">
                              	<tr style="height:22px;">
                                    <td class="txtbold" style="width:120px;"><cf_get_lang dictionary_id = '35391.PörtföyNo'></td>
                                    <td align="left">#cheque_purse_no#</td>
                              	</tr>
                              	<tr style="height:22px;">
                                    <td class="txtbold"><cf_get_lang dictionary_id = '35392.Müşteri Hesap No'></td>
                                    <td><cfif len(get_cheque.account_id)>#get_accounts.account_name#</cfif>&nbsp;</td>
                              	</tr>
                              	<tr style="height:22px;">
                                    <td class="txtbold"><cf_get_lang dictionary_id = '54490.Çek No'></td>
                                    <td>#cheque_no#&nbsp;</td>
                              	</tr>
                              	<tr style="height:22px;">
                                    <td class="txtbold"><cf_get_lang dictionary_id = '57519.Cari Hesap'></td>
                                    <td><cfif len(company_id)>#get_par_info(company_id,1,1,0)#<cfelseif len(consumer_id)>#get_cons_info(consumer_id,0,0)# </cfif>&nbsp;</td>
                              	</tr>
                              	<tr style="height:22px;">
                                    <td class="txtbold"><cf_get_lang dictionary_id = '57640.Vade'></td>
                                    <td>#dateformat(cheque_duedate,'dd/mm/yyyy')#&nbsp;</td>
                              	</tr>
                              	<tr style="height:22px;">
                                    <td class="txtbold"><cf_get_lang dictionary_id = '57673.Tutar'></td>
                                    <td>#TLFormat(cheque_value)# #currency_id#&nbsp;</td>
                               	</tr>
                              	<tr style="height:22px;">
                                  	<td class="txtbold"><cf_get_lang dictionary_id = '35395.Sistem Tutarı'></td>
                                  	<td>#TLFormat(other_money_value)# <cfif isDefined('session.pp.userid')>#session.pp.money#<cfelse>#session.ww.money#</cfif>&nbsp;</td>
                               	</tr>
                              	<tr style="height:22px;">
                                  	<td class="txtbold"><cf_get_lang dictionary_id = '35393.Döviz İşlemi'></td>
                                  	<td>#tlformat(other_money_value2)# #other_money2#&nbsp;</td>
                       			</tr>
                              	<tr style="height:22px;">
                        	  		<td class="txtbold"><cf_get_lang dictionary_id = '58181.Ödeme Yeri'></td>
                          			<td>#cheque_city#&nbsp;</td>
                   				</tr>
                              	<tr style="height:22px;">
                      				<td class="txtbold"><cf_get_lang dictionary_id = '57789.Özel Kod'></td>
                      				<td>#cheque_code#&nbsp;</td>
                   				</tr>
                			</table>
              			</td>
            		</tr>
          		</table>
        	</td>
       	</tr>
    </table>
</cfoutput>
