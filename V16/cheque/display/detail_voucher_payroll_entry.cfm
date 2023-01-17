<cfset attributes.TABLE_NAME="VOUCHER_PAYROLL">
<cfset attributes.VOUCHER_PAYROLL_ID=attributes.PAYROLL_ACTION_ID>
<cfset url.id=attributes.PAYROLL_ACTION_ID>
<cfinclude template="../query/get_cashes.cfm">
<cfinclude template="../query/get_money_rate.cfm">
<cfinclude template="../query/get_action_detail.cfm">
<cfquery name="GET_VOUCHER_DETAIL" datasource="#dsn2#">
	SELECT * FROM VOUCHER WHERE	VOUCHER_PAYROLL_ID = #attributes.VOUCHER_PAYROLL_ID#
</cfquery>
<div align="center">
  <cfif not isDefined("attributes.print")>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
      <tr class="color-border">
        <td colspan="2">
          <table width="100%" border="0" cellspacing="1" cellpadding="2">
            <tr>
              <td  class="color-row" style="text-align:right;">
			 <cfif not listfindnocase(denied_pages,'cheque.popup_detail_voucher_payrol_entry')>
			 	<a href="javascript://" onClick="<cfoutput>windowopen('#request.self#?fuseaction=cheque.popup_detail_voucher_payrol_entry&print=true#page_code#','page')</cfoutput>"><img src="/images/print.gif" alt="<cf_get_lang_main no='62.Yazıcıya Gönder'>" title="<cf_get_lang_main no='62.Yazıcıya Gönder'>" border="0"></a> 
			  </cfif>
			  <a href="javascript://" onClick="window.close();"><img src="/images/close.gif" alt="<cf_get_lang_main no='141.Kapat'>" title="<cf_get_lang_main no='141.Kapat'>" border="0"></a></td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
    <cfelse>
    <script type="text/javascript">
		function waitfor(){
		  window.close();
		}
		setTimeout("waitfor()",3000);
		window.opener.close();
		window.print();
	</script>
  </cfif>
  <br/>
  <cfmodule template="../../index.cfm" fuseaction="objects.popup_view_company_info_logo">
  <table width="650">
    <tr>
      <td><cf_get_lang no='87.Tahsilat Makbuzu No'>:<cfoutput><strong>#get_action_detail.PAYROLL_NO#</strong></cfoutput></td>
      <td  style="text-align:right;"> <cf_get_lang_main no='330.Tarih'>:
        <cfoutput><strong>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</strong></cfoutput> </td>
    </tr>
    <tr>
      <td height="50" colspan="2">
        <cfif len(get_action_detail.COMPANY_ID)>
          <cfoutput><strong>#get_par_info(get_action_detail.COMPANY_ID,1,1,0)#</strong></cfoutput>
        </cfif>
        '<cf_get_lang no='88.dan hesabına mahsuben yalnız'>
        <cfset mynumber = get_action_detail.PAYROLL_TOTAL_VALUE>
        <cf_n2txt number="myNumber" para_birimi="#get_action_detail.CURRENCY_ID#">
		<cfoutput><strong>#myNumber#</strong></cfoutput>
		 <cf_get_lang dictionary_id = "33219.Senet Alınmıştır."></td>
      </td>
    </tr>
  </table>
  <table width="650">
    <tr height="22" class="txtbold">
      <td><cf_get_lang dictionary_id="58502.Senet No"></td>
	  <td><cf_get_lang dictionary_id="58182.Portföy No"></td>
	  <td><cf_get_lang dictionary_id="58180.Borçlu"></td>
      <td><cf_get_lang_main no='228.Vade'></td>
      <td><cf_get_lang_main no='261.Tutar'></td>
    </tr>
    <cfoutput query="GET_VOUCHER_DETAIL">
      <tr>
        <td>#VOUCHER_NO#</td>
		<td>#VOUCHER_PURSE_NO#</td>
		<td>#DEBTOR_NAME#</td>
        <td>#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
        <td>#TLFormat(VOUCHER_VALUE)#</td>
      </tr>
      <tr valign="top">
        <td colspan="5"><hr>
        </td>
      </tr>
    </cfoutput>
  </table>
  <table width="650">
    <tr>
      <td  style="text-align:right;">
        <table>
          <tr>
            <td width="50"><strong><cf_get_lang_main no='1233.Nakit'></strong></td>
            <td width="150">:</td>
            <td width="75"><strong><cf_get_lang no='38.Tahsil Eden'></strong></td>
            <td>:
              <cfif isdefined("attributes.EMP_ID") and len(attributes.EMP_ID)>
                <cfoutput>#get_emp_info(attributes.EMP_ID,0,0)#</cfoutput>
              </cfif>
            </td>
          </tr>
          <tr>
            <td><strong>Senet</strong></td>
            <td>: <cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</cfoutput></td>
            <td><strong><cf_get_lang_main no='80.Toplam'></strong></td>
            <td>: <cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</cfoutput></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</div>

