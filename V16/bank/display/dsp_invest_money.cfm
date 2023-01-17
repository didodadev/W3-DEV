<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.TABLE_NAME="BANK_ACTIONS">
<cfinclude template="../query/get_cashes.cfm">
<cfinclude template="../query/get_accounts.cfm">
<cfinclude template="../query/get_action_detail.cfm">
<cfsavecontent variable="img">
	<cfoutput>
        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_invest_money" target="_blank"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang dictionary_id ="57582.Ekle">" title="<cf_get_lang dictionary_id ="57582.Ekle">"></a>
        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_invest_money&ID=#attributes.ID#" target="_blank"><img src="/images/plus.gif" border="0" alt="<cf_get_lang dictionary_id ="57476.Kopyala">" title="<cf_get_lang dictionary_id ="57476.Kopyala">"></a>
    </cfoutput>
</cfsavecontent>
<cfif not get_action_detail.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='590.Böyle Bir Çek Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cf_popup_box title="#getLang('bank',82)#" right_images="#img#">
          <cfoutput>
            <cfif ATTRIBUTES.TABLE_NAME eq "BANK_ACTIONS">
              <cfset cash=get_action_detail.ACTION_FROM_CASH_ID>
              <cfset acc=get_action_detail.ACTION_TO_ACCOUNT_ID>
              <cfset value=get_action_detail.ACTION_VALUE>
              <cfset emp_id=get_action_detail.ACTION_EMPLOYEE_ID>
              <cfelse>
              <cfset cash=get_action_detail.CASH_ACTION_FROM_CASH_ID>
              <cfset acc=get_action_detail.CASH_ACTION_TO_ACCOUNT_ID>
              <cfset value=get_action_detail.CASH_ACTION_VALUE>
              <cfset empl_id=get_action_detail.PAYER_ID>
            </cfif>
          </cfoutput>
      <table>
        <tr>
          <td width="100" class="txtbold">Parayı Yatıran</td>
          <td>: <cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput> </td>
        </tr>
        <cfoutput>
          <tr>
            <td class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
            <td>:<cfoutput>#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</cfoutput></td>
          </tr>
        </cfoutput>
        <td class="txtbold"><cf_get_lang_main no='108.Kasa'></td>
          <td>: <cfoutput query="get_cashes">
              <cfif CASH_ID eq cash>
                <cfset currency=CASH_CURRENCY_ID>
                <cfinclude template="../query/get_action_rate.cfm">
                #CASH_NAME#&nbsp;#get_action_rate.MONEY#
              </cfif>
            </cfoutput> </td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang_main no='240.Hesap'></td>
          <td>: <cfoutput query="get_accounts">
              <cfif ACCOUNT_ID eq acc>
                <cfset currency=ACCOUNT_CURRENCY_ID>
                <cfinclude template="../query/get_action_rate.cfm">
                #ACCOUNT_NAME#&nbsp;#get_action_rate.MONEY#
              </cfif>
            </cfoutput> </td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang_main no='261.Tutar'></td>
          <td>: <cfoutput>#TLFormat(value)# #currency#</cfoutput> </td>
        </tr>
        <tr>
          <td valign="top" class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
          <td>: <cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput> </td>
        </tr>
      </table>
    <table width="100%">
        <tr>
        	<td class="txtbold"><cf_get_lang no='74.Bu İşlemi Banka İşlemleri Bölümünde Güncelleyebilirsiniz'></td>
        </tr>
    </table>
    <cf_popup_box_footer>
        <table width="100%">
        	<tr>
                <td>
					<cfif len(get_action_detail.RECORD_EMP)>
                        <cf_get_lang_main no='71.Kayıt'> : <cfoutput> #get_emp_info(get_action_detail.RECORD_EMP,0,0)# &nbsp;#dateformat(date_add('h',session.ep.time_zone,GET_ACTION_DETAIL.RECORD_DATE),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,GET_ACTION_DETAIL.RECORD_DATE),timeformat_style)#</cfoutput></td>
                    </cfif>
                </td>
                <td style="text-align:right;">
                    <input type="button" value="<cf_get_lang_main no='141.Kapat'>" onClick="javascript:window.close();" style="width:65px;" name="button">
                    &nbsp;&nbsp;&nbsp;</td>
            </tr>
        </table>
    </cf_popup_box_footer>
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
</cfif>
