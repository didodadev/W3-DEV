<div align="center">
  <table  width="650" height="35">
    <tr>
      <td class="headbold"><cf_get_lang_main no='2284.Nakit Tahsilat'></td>
    </tr>
  </table>
  <table width="650">
    <cfoutput>
      <tr>
        <td width="100" class="txtbold"><cf_get_lang no='20.Makbuz No'></td>
        <td>: #get_action_detail.paper_no# </td>
      </tr>
      <tr>
        <td class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
        <td>: #dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</td>
      </tr>
    </cfoutput>
    <tr>
      <td class="txtbold"><cf_get_lang no='22.Tahsil Eden'></td>
      <td>: <cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput> 
    </tr>
    <tr>
      <td class="txtbold"><cf_get_lang_main no='107.cari Hesap'></td>
      <td>:<cfoutput>#get_par_info(get_action_detail.CASH_ACTION_FROM_COMPANY_ID,1,1,0)#</cfoutput></td>
    </tr>
    <tr>
      <td class="txtbold"><cf_get_lang_main no='108.Kasa'></td>
      <td>:<cfoutput query="get_cashes">
          <cfif CASH_ID eq get_action_detail.CASH_ACTION_TO_CASH_ID>
            <cfset currency=CASH_CURRENCY_ID>
            <cfinclude template="../query/get_action_rate.cfm">
            #CASH_NAME#&nbsp;#get_action_rate.MONEY#
          </cfif>
        </cfoutput>
	  </td>
    </tr>
    <tr>
      <td class="txtbold"><cf_get_lang_main no='261.Tutar'></td>
      <td>: #get_action_detail.CASH_ACTION_VALUE#</td>
    </tr>
    <tr>
      <td valign="top" class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
      <td>: <cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput> </td>
    </tr>
  </table>
</div>

