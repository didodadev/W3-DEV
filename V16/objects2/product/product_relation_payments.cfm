<cfif isdefined('attributes.price_kdv') and len(attributes.price_kdv)>
	<cfset tum_toplam_komisyonsuz = #attributes.price_kdv#>
<cfelse>
	<cfset tum_toplam_komisyonsuz = ''>
</cfif>

<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		ACCOUNTS.ACCOUNT_CURRENCY_ID,
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO,
		CPT.POS_TYPE,
		CPT.SERVICE_RATE,
		CPT.NUMBER_OF_INSTALMENT, 
		CPT.FIRST_INTEREST_RATE,
		<cfif isDefined("session.pp")>CPT.COMMISSION_MULTIPLIER,<cfelse>CPT.PUBLIC_COMMISSION_MULTIPLIER COMMISSION_MULTIPLIER,</cfif>
		CPT.COMMISSION_MULTIPLIER_DSP,
		CPT.DUEDATE,
		CPT.VFT_CODE
	FROM
		ACCOUNTS ACCOUNTS,
		CREDITCARD_PAYMENT_TYPE CPT
	WHERE
		ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
		CPT.IS_ACTIVE = 1 AND
		<cfif isDefined("session.pp")>
            CPT.IS_PARTNER = 1 AND
        <cfelse>
            CPT.IS_PUBLIC = 1 AND
        </cfif>
		CPT.POS_TYPE IS NOT NULL
	ORDER BY
		CARD_NO
</cfquery>

<table class="color-border" cellpadding="2" cellspacing="1" border="0" style="width:100%;">
	<tr style="height:30px;">
		<td colspan="4" class="txtbold"><font color="red"><cf_get_lang no ='1377.Kdv Dahil Ödeme Seçenekleri'></font></td>
	</tr>
	<tr class="color-header" style="height:20px;">
		<td class="form-title"><cf_get_lang no ='1142.Kart'></td>
		<td class="form-title" style="width:80px;"><cf_get_lang no ='373.Taksit Sayisi'></td>
		<td  class="form-title" style="text-align:right; width:90px;"><cf_get_lang no ='1011.Taksit Tutari'></td>
		<td  class="form-title" style="text-align:right;"><cf_get_lang_main no='1737.Toplam Tutar'></td>
	</tr>
	<cfif get_accounts.recordcount>
        <cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
            SELECT 
                (RATE2/RATE1) RATE
            FROM 
                SETUP_MONEY
            WHERE
                MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.price_money#">
        </cfquery>
		<cfset renk_ = 0>
		<cfoutput query="get_accounts">
            <cfif len(vft_code)>
                <cfset main_total = tum_toplam_komisyonsuz>
            <cfelseif len(commission_multiplier) and commission_multiplier gt 0>
                <cfset main_total = tum_toplam_komisyonsuz + wrk_round(tum_toplam_komisyonsuz * commission_multiplier/100)>
            <cfelse>
                <cfset main_total = tum_toplam_komisyonsuz>
            </cfif>
            <cfif len(number_of_instalment) and number_of_instalment neq 0>
                <cfset taksit_tutar = main_total / number_of_instalment>
            <cfelse>
                <cfset taksit_tutar = main_total>
            </cfif>
            <cfif len(first_interest_rate)>
                <cfset taksit_tutar = taksit_tutar * ((100-first_interest_rate) / 100)>
                <cfset main_total = main_total * ((100-first_interest_rate) / 100)>
            </cfif>
			<cfset renk_ = renk_ + 1>
            <tr <cfif renk_ mod 2></cfif>>
                <td class="txtbold">#card_no# <cfif len(first_interest_rate)>---> %#first_interest_rate# İndirimli</cfif></td>
                <td  style="text-align:right;">#number_of_instalment#</td>
                <td  style="text-align:right;">#TLFormat(taksit_tutar*get_money_info.rate)#  #session_base.money#</td>
                <td  style="text-align:right;"><font color="red">#TLFormat(main_total*get_money_info.rate)# #session_base.money#</font></td>
            </tr>
        </cfoutput>
    </cfif>
</table>


