<cfinclude template="../query/get_company_app.cfm">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default=#get_company.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.comp_cat")>
	<cfset url_string = "#url_string#&comp_cat=#comp_cat#">
</cfif>
<cfif isdefined("attributes.search_type")>
	<cfset url_string = "#url_string#&search_type=#search_type#">
</cfif>
<cfif isdefined("attributes.search_status")>
	<cfset url_string = "#url_string#&search_status=#search_status#">
</cfif>
<cfinclude template="../query/get_company_cat.cfm">
<!-- sil -->
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <cfif fuseaction does not contain "popup">
      <td valign="top" width="135">
        <cfinclude template="potential_left_menu.cfm">
      </td>
    </cfif>
    <td valign="top">
<!-- sil -->	
      <!--- sales offer dan geliyorsa  --->
      <cfset add_offer=0>
      <cfif isdefined("url.add_offer")>
        <cfset add_offer=1>
      </cfif>
      <!--- sales order dan geliyorsa  --->
      <cfset add_order=0>
      <cfif isdefined("url.add_order")>
        <cfset add_order=1>
      </cfif>
      <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td height="35" class="headbold"><cf_get_lang dictionary_id='30417.Potansiyel Kurumsal Üyeler'></td>
          <!-- sil -->
          <td  valign="bottom" style="text-align:right;">
            <!--- Arama --->
            <table>
              <cfform name="form" action="#request.self#?fuseaction=member.list_company_app" method="post">
                <tr>
                  <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
				  <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                  <td>
                    <cfif isdefined("form.comp_cat")>
                      <cfset attributes.comp_cat = form.comp_cat>
                    </cfif>
                    <select name="comp_cat" id="comp_cat">
                      <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> 
                      <cfoutput query="get_companycat">
                        <cfif isdefined("attributes.comp_cat") and attributes.comp_cat is COMPANYCAT_ID>
                          <option selected value="#COMPANYCAT_ID#">#companycat#</option>
                          <cfelse>
                          <option value="#COMPANYCAT_ID#">#companycat#</option>
                        </cfif>
                      </cfoutput>
                    </select>
                    <select name="search_type" id="search_type">
                      <option value="0" <cfif isDefined('attributes.search_type') and #attributes.search_type# is 0>selected</cfif>><cf_get_lang dictionary_id='29531.Şirketler'>
                      <option value="1" <cfif isDefined('attributes.search_type') and #attributes.search_type# is 1>selected</cfif>><cf_get_lang dictionary_id='58875.Çalışanlar'>
                    </select>
                    <select name="search_status" id="search_status">
                      <!--- Ömür --->
                      <option value="1" <cfif isDefined('attributes.search_status') and #attributes.search_status# is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                      <option value="0" <cfif isDefined('attributes.search_status') and #attributes.search_status# is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
                      <option value="" <cfif isDefined('attributes.search_status') and not Len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
                    </select>
                  </td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
                  <td><cf_wrk_search_button></td>
                  <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'></tr>
              </cfform>
            </table>
            <!--- Arama --->
          </td>
          <!-- sil -->
        </tr>
      </table>
      <cfset sayac = 0>
	  
	 
            <table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
              <tr class="color-header">
                <td height="22" class="form-title"><cf_get_lang dictionary_id='57574.Şirket'></td>
                <td class="form-title"><cf_get_lang dictionary_id='57908.Temsilci'></td>
                <td class="form-title"><cf_get_lang dictionary_id='29511.Yönetici'></td>
				<!-- sil -->
                <td class="form-title" width="100"><cf_get_lang dictionary_id='58143.İletişim'></td>				
                <td class="form-title" width="30"><cf_get_lang dictionary_id='57453.Şube'></td>
                <td class="form-title" width="30"><cf_get_lang dictionary_id='29831.Kişi'></td>
				<!-- sil -->
              </tr>
              <cfquery name="GET_EMP" datasource="#dsn#">
				  SELECT 
					  * 
				  FROM 
					  EMPLOYEE_POSITIONS 
				  WHERE 
					  POSITION_STATUS = 1
              </cfquery>
              <cfif get_company.recordcount>
                <cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td><a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#COMPANY_ID#<cfif add_offer>&add_offer=1</cfif><cfif add_order>&add_order=1</cfif>" class="tableyazi">#fullname#</a>
					</td>
                    <td>
                      <cfif pos_code is 0 or pos_code is "">
                        <cfset agent_ = 1>
                        <cfelse>
                        <cfset agent_ = 0>
                      </cfif>
                      <cfloop from="1" to="#get_emp.recordcount#" index="i">
                        <cfif get_emp.POSITION_CODE[i] is pos_code>
                          <a href="mailto:#get_emp.employee_email#" class="tableyazi">#get_emp.EMPLOYEE_NAME[i]# #get_emp.EMPLOYEE_SURNAME[i]#</a>
                        </cfif>
                      </cfloop>
                      <cfif agent_ is 1>
                        <font face="Verdana" color="##ff0000"><cf_get_lang dictionary_id='30418.Temsilci Seçilmemiş'></font>
                      </cfif>
                    </td>
                    <td>
                      <cfif Len(MANAGER_PARTNER_ID) and Len(MANAGER_PARTNER_ID)>
                        <cfquery name="GET_MANAGER" datasource="#dsn#">
							SELECT 
								COMPANY_PARTNER_NAME, 
								COMPANY_PARTNER_SURNAME,
								COMPANY_PARTNER_EMAIL 
							FROM 
								COMPANY_PARTNER 
							WHERE 
								PARTNER_ID = #MANAGER_PARTNER_ID#
                        </cfquery>
                        <a href="mailto:#get_manager.company_partner_email#" class="tableyazi">#GET_MANAGER.COMPANY_PARTNER_NAME# #GET_MANAGER.COMPANY_PARTNER_SURNAME#</a> &nbsp;
                        <cfelse>
                        <font face="Verdana" color="##ff0000"><cf_get_lang dictionary_id='30419.Yönetici Seçilmemiş'></font>
                      </cfif>
                    </td>
					<!-- sil -->
                    <td>
                      <cfif Len(COMPANY_EMAIL)>
                        <a href="mailto:#COMPANY_EMAIL#"><img src="/images/mail.gif" border="0" title="E-mail:#COMPANY_EMAIL#"></a>
                      </cfif>
                      <img src="/images/tel.gif" border="0" title="Tel:#COMPANY_TELCODE#-#COMPANY_TEL1#">
                      <cfif company_fax is "">
						&nbsp;
                        <cfelse>
                        <img src="/images/fax.gif" border="0" title="Fax:#COMPANY_TELCODE#-#COMPANY_FAX#">
                      </cfif>
                    </td>
                    <td align="center"><a href="#request.self#?fuseaction=member.form_add_branch&cpid=#company_id#"><img src="/images/branch_plus.gif" border="0" title="<cf_get_lang dictionary_id='30191.Adres/Şube Ekle'>" width="17" height="21"></a></td>
                    <td align="center"><a href="#request.self#?fuseaction=member.form_add_partner&comp_cat=#companycat_id#&compid=#company_id#<cfif add_offer>&add_offer=1</cfif><cfif add_order>&add_order=1</cfif>"><img src="/images/partner_plus.gif" border="0" title="<cf_get_lang dictionary_id='30190.Kişi Ekle'>" width="19" height="21"></a></td>
					<!-- sil -->
                  </tr>
                </cfoutput>
                <cfelse>
                <tr height="20" class="color-row">
                  <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>			

      <cfif attributes.totalrecords gt attributes.maxrows>
        <table width="97%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td>
			<cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="member.list_company_app#url_string#">
				</td>
            <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
          </tr>
        </table>
      </cfif>
    </td>
  </tr>
</table>

