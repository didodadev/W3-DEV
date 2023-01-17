<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.totalrecords" default=#purchases.recordcount#>
<table cellSpacing="0" cellpadding="0"  border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header">
          <td height="22" class="form-title" width="75"><cf_get_lang_main no='330.tarih'></td>
          <td class="form-title" width="75"><cf_get_lang_main no='1372.referans no'></td>
          <td class="form-title"><cf_get_lang_main no='1121.belge tipi'></td>
          <td class="form-title"><cf_get_lang_main no='107.cari hedsap'></td>
          <td class="form-title"><cf_get_lang_main no='1351.depo'></td>
          <td class="form-title"><cf_get_lang_main no='261.tutar'></td>
          <!-- sil -->
          <td width="30" align="center"></td>
          <!-- sil -->
        </tr>
        <cfif purchases.recordcount>
          <cfoutput query="purchases" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td height="20">#dateformat(ship_date,dateformat_style)#</td>
              <td>
                <cfif purchases.purchase_sales eq 0>
                  <cfset strlink="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#ship_id#">
                <cfelseif purchases.purchase_sales eq 1>
					<cfif SHIP_TYPE eq 81>
					  <cfset strlink="#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#ship_id#">
					<cfelse>
	                  <cfset strlink="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#ship_id#">
				    </cfif>
                </cfif>
                <a href="#strlink#" class="tableyazi">#ship_number#</a> </td>
              <td> <a href="#strlink#" class="tableyazi">
                <cfif SHIP_TYPE eq 76><cf_get_lang_main no='1784.Mal Alım İrsaliyesi'>
                  <cfelseif SHIP_TYPE eq 78 ><cf_get_lang_main no='1787.Alım İade İrsaliyesi'>
                  <cfelseif SHIP_TYPE eq 77 ><cf_get_lang no='79.Konsinye Giriş'>
                  <cfelseif SHIP_TYPE eq 79 ><cf_get_lang no='80.Konsinye Giriş İade'>
                  <cfelseif SHIP_TYPE eq 80 ><cf_get_lang no='81.Müstahsil Makbuz'>
                  <cfelseif SHIP_TYPE eq 81 ><cf_get_lang_main no='1790.Sevk İrsaliyesi'>
                  <cfelseif SHIP_TYPE eq 71 ><cf_get_lang_main no='1340.Toptan Satış İrsaliyesi'>
                  <cfelseif SHIP_TYPE eq 70 ><cf_get_lang no='83.Parekande Satış İrsaliyesi'>
                  <cfelseif SHIP_TYPE eq 72 ><cf_get_lang_main no='1341.Konsinye Çıkış İrsaliyesi'>
                  <cfelseif SHIP_TYPE eq 73 ><cf_get_lang no='85.Parekande Satış İade İrsaliyesi'>
                  <cfelseif SHIP_TYPE eq 74 ><cf_get_lang_main no='1783.Toptan Satış İade İrsaliyesi'>
                  <cfelseif SHIP_TYPE eq 75 ><cf_get_lang_main no='1343.Konsinye Çıkış İade İrsaliyesi'>
                </cfif>
                </a>
				</td>
              <td>
                <cfif len(company_id) and (company_id neq 0)>
                  <cfset attributes.company_id = company_id>
                  <cfinclude template="../query/get_company_name.cfm">
                  #company_name.nickname#
                <cfelseif len(consumer_id)>
                  #get_cons_info(CONSUMER_ID,0,0)#
                </cfif>
              </td>
              <td>#department_head#</td>
              <td align="right" style="text-align:right;">#TLFormat(nettotal)# #session.ep.money#</td>
              <!-- sil -->
              <td align="center">
                <cfif purchases.purchase_sales eq 1>
                  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_temp_upd_sale&module=stock&id=#ship_id#&ship_id=#ship_id#&action=print','page');"><img src="/images/print2.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>" height="20"></a>
                </cfif>
              </td>
              <!-- sil -->
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row">
            <td colspan="7" height="20"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
    <tr>
      <td>
			<cfset adres="stock.list_purchase">
			<cfif isDefined('attributes.cat') and len(attributes.cat)>
			  <cfset adres = adres&"&cat="&attributes.cat>
			</cfif>
			<cfif len(attributes.keyword)>
			  <cfset adres = adres&"&keyword="&attributes.keyword>
			</cfif>
			<cfif isDefined('attributes.oby') and len(attributes.oby)>
			  <cfset adres = adres&'&oby='&attributes.oby>
			</cfif>
			<cfif isDefined('attributes.department_id') and len(attributes.department_id)>
			  <cfset adres = adres&'&department_id='&attributes.department_id>
			</cfif>
			<cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#adres#">
	  </td>
      <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='80.toplam'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>

