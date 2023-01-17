
<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_partner_all_app.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfset attributes.totalrecords =get_partner_all.recordcount>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td class="headbold" height="35">
      <cfif isdefined("attributes.comp_cat") and len(attributes.comp_cat) and (attributes.comp_cat neq 0)>
        <cfquery name="GET_SELECTED_CAT" datasource="#dsn#">
			SELECT 
				* 
			FROM 
				COMPANY_CAT 
			WHERE 
				COMPANYCAT_ID = #attributes.COMP_CAT#
        </cfquery>
        <cfif GET_SELECTED_CAT.recordcount>
          <cfoutput>#GET_SELECTED_CAT.COMPANYCAT# <cf_get_lang dictionary_id='58875.Çalışanlar'></cfoutput>
        </cfif>
        <cfelse>
        <cf_get_lang dictionary_id='30430.Tüm Çalışanlar'>
      </cfif>
    </td>
    <!-- sil -->
    <td  style="text-align:right;">
      <!---Arama --->
      <table>
        <cfform name="form" action="#request.self#?fuseaction=member.partner_list_app_comp" method="post">
          <tr>
            <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255"></td>
            <td>
              <select name="comp_cat" id="comp_cat" style="width:150px;" >
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> 
                <cfoutput query="get_companycat">
                  <cfif isdefined("attributes.comp_cat") and attributes.comp_cat is COMPANYCAT_ID>
                    <option selected value="#COMPANYCAT_ID#">#companycat#</option>
                    <cfelse>
                    <option value="#COMPANYCAT_ID#">#companycat#</option>
                  </cfif>
                </cfoutput>
              </select>
              <select name="search_type" id="search_type"  style="width:150px;" >
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
            <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'> 
			</tr>
        </cfform>
      </table>
      <!---Arama --->
    </td>
    <!-- sil -->
  </tr>
</table>



      <table cellspacing="1" cellpadding="2" width="98%" border="0" align="center" class="color-border">
        <tr class="color-header" height="22">
          <td width="150" class="form-title"><cf_get_lang dictionary_id='57658.Üye'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57574.Şirket'></td>
          <td class="form-title" width="100"><cf_get_lang dictionary_id='57571.Ünvan'></td>
          <td class="form-title" width="100"><cf_get_lang dictionary_id='30350.Yetki Grubu'></td>
		  <!-- sil -->
          <td class="form-title" width="100"><cf_get_lang dictionary_id='58143.İletişim'></td>
		  <!-- sil -->
        </tr>
        <cfif get_partner_all.recordcount>
          <cfparam name="attributes.page" default=1>
         <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
          <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
          <cfoutput query="get_partner_all" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td><a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#get_partner_all.partner_id#" class="tableyazi">&nbsp;#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</a></td>
              <td><a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_partner_all.COMPANY_ID#" class="tableyazi">&nbsp;#fullname#</a></td>
              <td>&nbsp;#title#</td>
              <td>&nbsp;</td>
			  <!-- sil -->
              <td>&nbsp;
                <cfif len(COMPANY_PARTNER_EMAIL)><a href="mailto:#COMPANY_PARTNER_EMAIL#"><img src="/images/mail.gif" width="18" height="21" title="<cf_get_lang dictionary_id='57428.E-mail'>:#COMPANY_PARTNER_EMAIL#" border="0"></a></cfif>
                <cfif len(COMPANY_PARTNER_TEL)>&nbsp;<img src="/images/tel.gif" width="17" height="21" title="<cf_get_lang dictionary_id='57499.Telefon'>:#COMPANY_PARTNER_TEL#" border="0"></cfif>
                <cfif len(COMPANY_PARTNER_FAX)>&nbsp;<img src="/images/fax.gif" width="22" height="21" title="<cf_get_lang dictionary_id='57488.Fax'>:#COMPANY_PARTNER_FAX#" border="0"></cfif>
                <cfif len(MOBIL_CODE) and  (session.ep.our_company_info.sms eq 1)>&nbsp;<img src="/images/mobil.gif" width="13" height="21" title="<cf_get_lang dictionary_id='30254.Kod/Mobil Tel'>:#MOBIL_CODE# #MOBILTEL#" border="0"></cfif>
              </td>
			  <!-- sil -->
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row" height="20">
            <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>


<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td>
	  			<cf_pages 
		  			page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#get_partner_all.recordcount#" 
					startrow="#attributes.startrow#" 
					adres="member.partner_list_app_comp"> </td>
      <!-- sil --><td  style="text-align:right;"> <cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
    </tr>
  </table>
</cfif>
