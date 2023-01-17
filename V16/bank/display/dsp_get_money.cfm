<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.TABLE_NAME = "BANK_ACTIONS">
<cfinclude template="../query/get_cashes.cfm">
<cfinclude template="../query/get_accounts.cfm">
<cfinclude template="../query/get_money_rate.cfm">
<cfinclude template="../query/get_action_detail.cfm">
<cfif session.ep.isBranchAuthorization and (get_cashes.recordcount eq 0) or (get_accounts.recordcount eq 0) or (get_action_detail.recordcount eq 0)>
	<script type="text/javascript">
    	alert("<cf_get_lang_main no='2705.Banka ya da Kasanın Şubesine Yetkiniz Bulunmamaktadır'>!");
		window.opener.location.reload();
		window.close();
    </script>
    <cfabort>
</cfif>
<cfsavecontent variable="img">
    <cfoutput>
        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_get_money" target="_blank"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a>
        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_get_money&ID=#attributes.ID#" target="_blank"><img src="/images/plus.gif" border="0" alt="<cf_get_lang dictionary_id='57476.Kopyala'>" title="<cf_get_lang dictionary_id='57476.Kopyala'>"></a>
    </cfoutput>
</cfsavecontent>
<cf_popup_box title="#getLang('bank',73)#" right_images="#img#">
	<cfoutput>
      <cfif attributes.TABLE_NAME eq "BANK_ACTIONS">
        <cfset cash=get_action_detail.ACTION_TO_CASH_ID>
        <cfset acc=get_action_detail.ACTION_FROM_ACCOUNT_ID>
        <cfset value=get_action_detail.ACTION_VALUE>
        <cfset emp_id=get_action_detail.ACTION_EMPLOYEE_ID>
      <cfelse>
        <cfset cash=get_action_detail.CASH_ACTION_TO_CASH_ID>
        <cfset acc=get_action_detail.CASH_ACTION_FROM_ACCOUNT_ID>
        <cfset value=get_action_detail.CASH_ACTION_VALUE>
        <cfset emp_id=get_action_detail.REVENUE_COLLECTOR_ID>
      </cfif>
    </cfoutput>
    <table>
        <tr>
            <td width="100" class="txtbold"><cf_get_lang no='51.Parayı Çeken'></td>
            <td><cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput></td>
        </tr>
        <cfoutput>
        <tr>
            <td class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
            <td>#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</td>
        </tr>
        </cfoutput>
        <tr>
            <td class="txtbold"><cf_get_lang_main no='108.Kasa'></td>
            <td> 
                <cfoutput query="get_cashes">
                <cfif CASH_ID eq cash>
                    <cfset currency=CASH_CURRENCY_ID>
                    <cfinclude template="../query/get_action_rate.cfm">
                    #CASH_NAME#&nbsp;#get_action_rate.MONEY#
                </cfif>
                </cfoutput> 
            </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang_main no='240.Hesap'></td>
            <td> 
                <cfoutput query="get_accounts">
                    <cfif ACCOUNT_ID eq acc>
                        <cfset currency=ACCOUNT_CURRENCY_ID>
                        <cfinclude template="../query/get_action_rate.cfm">
                        #ACCOUNT_NAME#&nbsp;#get_action_rate.MONEY#
                    </cfif>
                </cfoutput> 
            </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang_main no='261.Tutar'></td>
            <td><cfoutput>#TLFormat(value)# #currency#</cfoutput></td>
        </tr>
        <tr>
            <td valign="top" class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
            <td><cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput></td>
        </tr>
    </table>
    <table>
        <tr>
            <td class="txtbold"><cf_get_lang no='74.Bu İşlemi Banka İşlemleri Bölümünde güncelleyebilirsiniz'></td>
        </tr>											
    </table>
    <cf_popup_box_footer>
        <table width="100%">
            <tr>
                <td><cf_record_info query_name="get_action_detail"></td>
                <td style="text-align:right;">
                    <input type="button" value="<cf_get_lang_main no='141.Kapat'>" onClick="javascript:window.close()" style="width:65px;">
                </td>
            </tr>
        </table>
    </cf_popup_box_footer>
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

