<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.totalrecords" default=#fis.recordcount#>

<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header">
          <td height="22" class="form-title" width="75"><cf_get_lang_main no='330.tarih'></td>
          <td class="form-title" width="75"><cf_get_lang_main no='1372.referans no'></td>
          <td class="form-title"><cf_get_lang_main no='1121.belge tipi'></td>
          <td class="form-title"><cf_get_lang_main no='363.teslim alan'></td>
          <td class="form-title"><cf_get_lang no='96.depo giriş'></td>
          <td class="form-title"><cf_get_lang_main no='1631.depo çıkış'></td>
        </tr>
        <cfif fis.recordcount>
          <cfoutput query="fis" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td height="20">#dateformat(fis_date,dateformat_style)#</td>
              <td>
                <cfif fis_type eq 114>
                  <cfset url_param="form_add_open_fis&event=upd">
                  <cfelse>
                  <cfset url_param="form_upd_fis">
                </cfif>
                <a href="#request.self#?fuseaction=stock.#url_param#&upd_id=#fis_id#"class="tableyazi">#fis_number#</a></td>
              <td> <a href="#request.self#?fuseaction=stock.#url_param#&upd_id=#fis_id#"class="tableyazi">
                <cfif fis_type eq 111><cf_get_lang_main no='1831.Sarf Fişi'>
                  <cfelseif fis_type eq 112><cf_get_lang_main no='1832.Fire Fişi'>
                  <cfelseif fis_type eq 110><cf_get_lang no='90.Üretimden Giriş Fişi'>
                  <cfelseif fis_type eq 114><cf_get_lang_main no='1834.Devir Fişi'>
                  <cfelseif fis_type eq 113><cf_get_lang no='92.Depo Fişi'>
                  <cfelseif fis_type eq 115><cf_get_lang_main no='1835.Sayım Fişi'>
                </cfif>
                </a> </td>
              <td><cfif len(FIS.EMPLOYEE_ID)>
                  #get_emp_info(FIS.EMPLOYEE_ID,0,0)#
                </cfif>
              </td>
              <td>
                <cfif len(FIS.DEPARTMENT_IN)>
                  <cfquery name="GET_DEPARTMENT" datasource="#dsn#">
                  		SELECT * FROM DEPARTMENT WHERE DEPARTMENT_ID=#FIS.DEPARTMENT_IN#
                  </cfquery>
                  #get_department.department_head#
                  <cfelse>
					&nbsp;
                </cfif>
              </td>
              <td>
                <cfif len(FIS.DEPARTMENT_OUT)>
                  <cfquery name="GET_DEPARTMENT_2" datasource="#dsn#">
                  		SELECT * FROM DEPARTMENT WHERE DEPARTMENT_ID=#FIS.DEPARTMENT_OUT#
                  </cfquery>
                  #get_department_2.department_head#
                  <cfelse>
					&nbsp;
                </cfif>
              </td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row">
            <td colspan="7" height="20"><cf_get_lang_main no='72.Kayıt Yok '> !</td>
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
        <cfset adres="stock.list_purchase" >
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
			adres="#adres#"> </td>
      <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='80.toplam'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>

