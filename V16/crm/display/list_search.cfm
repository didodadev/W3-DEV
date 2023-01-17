<cfparam name="attributes.keyword" default="">
<cfif isdefined("form.comp_cat") and form.comp_cat neq "0">
  <cfquery name="GET_SEARCH_RESULT" datasource="#dsn#">
	  SELECT 
		  * 
	  FROM 
		  COMPANY C, 
		  COMPANY_PARTNER CP, 
		  COMPANY_CAT CC 
	  WHERE 
		  C.COMPANY_ID = CP.COMPANY_ID AND 
		  CC.COMPANYCAT_ID = C.COMPANYCAT_ID AND 
		  C.FULLNAME 
	  LIKE
		  '%#attributes.keyword#%'
  </cfquery>
  <cfelseif form.cons_cat neq "0">
  <cfquery name="GET_SEARCH_RESULT" datasource="#dsn#">
	  SELECT 
		  * 
	  FROM 
		  CONSUMER C, 
		  CONSUMER_CAT CC 
	  WHERE 
		  C.CONSUMER_CAT_ID = CC.CONSCAT_ID
	  AND 
		  C.CONSUMER_NAME 
	  LIKE 
		  '%#attributes.keyword#%'
  </cfquery>
</cfif>
<cfif isdefined("form.comp_cat") and form.comp_cat neq "0">
  <cfform action="" method="post" name="add_service2" >
    <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
      <tr>
        <td class="headbold" height="35">
          <cfif isdefined("url.COMPANYCAT_ID")>
            <cfoutput>#get_cmp_ct.companycat# <cf_get_lang no='288.Listesi'></cfoutput>
            <cfelse>
            <cf_get_lang no='288.Partner Portal'>
          </cfif>
        </td>
        <td  style="text-align:right;">
          <!---Arama --->
          <table>
            <cfform name="search" action="#request.self#?fuseaction=crm.welcome&p=list" method="post" onsubmit="return form_goz();">
              <tr>
                <td><cf_get_lang_main no='48.Filtre'>:</td>
				<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                <td>
                  <select name="comp_cat" id="comp_cat" style="width:150px;" onchange="gozat(1);">
                    <option value="0"><cf_get_lang_main no='74.Kategori'> 
                    <cfoutput query="get_compaNycat">
                      <option value="#COMPANYCAT_ID#">#COMPANYCAT#</option>
                    </cfoutput>
                  </select>
                <td>
                  <select name="cons_cat" id="cons_cat" style="width:150px;" onchange="gozat(0);">
                    <option value="0"><cf_get_lang_main no='74.Kategori'> 
                    <cfoutput query="get_consumer_cat">
                      <option value="#CONSCAT_ID#">#CONSCAT#</option>
                    </cfoutput>
                  </select>
                </td>
                <td><cf_wrk_search_button></td>
              </tr>
            </cfform>
          </table>
          <!---Arama --->
        </td>
      </tr>
    </table>
    <table cellspacing="0" cellpadding="0" width="97%" border="0" align="center" id="service2">
      <tr class="color-border">
        <td>
          <table cellspacing="1" cellpadding="2" width="100%" border="0">
            <tr height="22" class="color-header">
              <td class="form-title" width="10%"><cf_get_lang_main no='246.Üye'><cf_get_lang_main no='75.No'></td>
              <td class="form-title" width="15%"><cf_get_lang_main no='158.Ad Soyad'></td>
              <td class="form-title" width="15%"><cf_get_lang_main no='162.Şirket'></td>
              <td class="form-title" width="15%"><cf_get_lang_main no='74.Kategori'></td>
              <td class="form-title"><cf_get_lang_main no='1311.Adres'></td>
              <td class="form-title" width="15%"><cf_get_lang_main no='87.Telefon'></td>
            </tr>
            <cfoutput query="get_search_result">
              <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td><a href="#request.self#?fuseaction=sales.form_add_order&cid=#company_id#&pid=#partner_id#">#COMPANY_ID# - #PARTNER_ID#</a></td>
                <td>#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</td>
                <td>#FULLNAME#</td>
                <td>#COMPANYCAT#</td>
                <td>#COMPANY_ADDRESS#</td>
                <td>#COMPANY_TELCODE#-#COMPANY_TEL1#</td>
              </tr>
            </cfoutput>
          </table>
        </td>
      </tr>
    </table>
  </cfform>
  <cfelseif form.cons_cat neq "0">
  <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td height="35" class="headbold"><cf_get_lang no='298.Bireysel Kategori'>:&nbsp;<cf_get_lang no='299.Kategori İsmi Gelecek! '></td>
      <td height="35"  style="text-align:right;">
        <table>
          <cfform name="search" action="#request.self#?fuseaction=crm.welcome&p=list" method="post">
            <tr>
              <td><cf_get_lang_main no='48.Filtre'>:</td>
				<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
              <td>
                <select name="comp_cat" id="comp_cat" style="width:150px;" onchange="gozat(1);">
                  <option value="0"><cf_get_lang_main no='74.Kategori'> 
                  <cfoutput query="get_compaNycat">
                    <option value="#COMPANYCAT_ID#">#COMPANYCAT#</option>
                  </cfoutput>
                </select>
              <td>
                <select name="cons_cat" id="cons_cat" style="width:150px;" onchange="gozat(0);">
                  <option value="0"><cf_get_lang_main no='246.Üye'><cf_get_lang_main no='74.Kategori'> 
                  <cfoutput query="get_consumer_cat">
                    <option value="#CONSCAT_ID#">#CONSCAT#</option>
                  </cfoutput>
                </select>
              </td>
              <td><input type="image" src="/images/ara.gif" border="0" onClick="if (!form_goz()) return false;"></td>
            </tr>
          </cfform>
        </table>
      </td>
    </tr>
  </table>
  <table cellspacing="0" cellpadding="0" width="97%" border="0" align="center" id="service2">
    <tr class="color-border">
      <td>
        <table cellspacing="1" cellpadding="2" width="100%" border="0">
          <tr height="22" class="color-header">
            <td class="form-title" width="10%"><cf_get_lang_main no='246.Üye'><cf_get_lang_main no='75.No'></td>
            <td class="form-title" width="15%"><cf_get_lang_main no='158.Ad Soyad'></td>
            <td class="form-title" width="15%"><cf_get_lang_main no='162.Şirket'></td>
            <td class="form-title" width="15%"><cf_get_lang_main no='74.Kategori'></td>
            <td class="form-title"><cf_get_lang_main no='1311.Adres'></td>
            <td class="form-title" width="15%"><cf_get_lang_main no='87.Telefon'></td>
          </tr>
          <cfoutput query="get_search_result">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td><a href="#request.self#?fuseaction=sales.form_add_order&cid=#CONSUMER_ID#&typ=cons">#CONSUMER_ID#</a></td>
              <td>#CONSUMER_NAME# #CONSUMER_SURNAME#</td>
              <td>#COMPANY#</td>
              <td>#CONSCAT#</td>
              <td>#HOMEADDRESS#</td>
              <td>#CONSUMER_HOMETELCODE#-#CONSUMER_HOMETEL#</td>
            </tr>
          </cfoutput>
        </table>
      </td>
    </tr>
  </table>
</cfif>
