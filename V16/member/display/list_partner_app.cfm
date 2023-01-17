<cfif isDefined('attributes.search_type') and attributes.search_type is 0>
	<cfinclude template="list_company_app">
	<cfabort>
</cfif>
<cfparam name="attributes.keyword" default="">

<cfinclude template="../query/get_partner_all_app.cfm">
<cfinclude template="../query/get_company_cat.cfm">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_partner_all.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="GET_CMP_CT" datasource="#dsn#">
	SELECT 
		COMPANYCAT_ID, 
		COMPANYCAT 
	FROM 
		COMPANY_CAT
	<cfif isDefined("URL.COMPANYCAT_ID")>
	WHERE 
		COMPANYCAT_ID=#URL.COMPANYCAT_ID#
	</cfif>
</cfquery>
<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td class="headbold" height="35"> 
      <cfif isdefined("url.COMPANYCAT_ID")>
		<cfoutput>#get_cmp_ct.companycat# <cf_get_lang dictionary_id='57509.Liste'></cfoutput> 
      <cfelse>
		<cf_get_lang dictionary_id='30426.Partner Portal'> 
      </cfif>
    </td>
    <td  style="text-align:right;">
	<!---Arama --->
	<table>
		<cfform name="form" action="#request.self#?fuseaction=member.partner_list_app" method="post">		
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
			</td>
	        <td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">			
			</td>
	        <td><cf_wrk_search_button></td>
	</tr>
	</cfform>
  </table>
	<!---Arama --->
	</td>
  </tr>
</table>


      <table cellspacing="1" cellpadding="2" width="98%" border="0" align="center" class="color-border">
        <tr class="color-header"> 
          <td height="22">&nbsp;</td>
          <cfoutput>
		    <td width="150" class="form-title"><img src="/images/listele.gif" border="0" align="absbottom"><a href="#request.self#?fuseaction=member.partner_list<cfif isdefined("url.companycat_id")>&companycat_id=#url.companycat_id#</cfif>&mem=1&ord=mem<cfif isdefined("url.ord") and (not isdefined("url.poz"))>&poz=1</cfif>" class="form-title"><cf_get_lang dictionary_id='57658.Üye'></a></td>
		    <td class="form-title"><img src="/images/listele.gif" border="0" align="absbottom"><a href="#request.self#?fuseaction=member.partner_list<cfif isdefined("url.companycat_id")>&companycat_id=#url.companycat_id#</cfif>&mem=1&ord=comp<cfif isdefined("url.ord") and (not isdefined("url.poz"))>&poz=1</cfif>" class="form-title"><cf_get_lang dictionary_id='57574.Şirket'></a></td>
		  </cfoutput>
          <td class="form-title" width="100"><cf_get_lang dictionary_id='57571.Ünvan'></td>
          <td class="form-title" width="100"><cf_get_lang dictionary_id='30397.Kullanıcı Grubu'></td>
          <td class="form-title" width="150"><cf_get_lang dictionary_id='58143.İletişim'></td>
        </tr>
        <cfoutput query="get_partner_all" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">    
         <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td width="21" height="20"><cf_online id="#get_partner_all.partner_id#" zone="pp"></td>
			<td><a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#get_partner_all.partner_id#" class="tableyazi">&nbsp;#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</a></td>
            <td><a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_partner_all.COMPANY_ID#" class="tableyazi">&nbsp;#fullname#</a></td>
            <td>&nbsp;#title#</td>
            <td>&nbsp;</td>
            <td>&nbsp;
              <cfif len(COMPANY_PARTNER_EMAIL)>
              <a href="mailto:#COMPANY_PARTNER_EMAIL#"><img src="/images/mail.gif" width="18" height="21" title="<cf_get_lang dictionary_id='57428.E-mail'>:" border="0"></a> 
              </cfif>
              <cfif len(im)>
				  <cfif imcat_id is 7>
					  <img src="/images/icon_msn.gif" width="21" height="17" title="Msn:" border="0">
				  <cfelseif imcat_id is 8>
					  <img src="/images/icon_icq.gif" width="18" height="18" title="Icq:" border="0">
				  <cfelseif imcat_id is 9>
					  <img src="/images/yahoo.gif" width="16" height="15" title="Yahoo:" border="0">
				  <cfelseif imcat_id is 10>
					  <img src="/images/icon_aol.gif" title="Aol:" border="0">
				  </cfif>
              </cfif>
              <cfif len(COMPANY_PARTNER_TEL)>
              &nbsp;<img src="/images/tel.gif" width="17" height="21" title="<cf_get_lang dictionary_id='57499.Telefon'>:" border="0">
              </cfif>
              <cfif len(COMPANY_PARTNER_FAX)>
              &nbsp;<img src="/images/fax.gif" width="22" height="21" title="<cf_get_lang dictionary_id='57488.Fax'>:" border="0">
              </cfif>
              <cfif len(mobiltel) and  (session.ep.our_company_info.sms eq 1)>
              &nbsp;<img src="/images/mobil.gif" width="13" height="21" title="<cf_get_lang dictionary_id='30254.Kod/Mobil Tel'>:" border="0">
              </cfif>
            </td>
          </tr>
        </cfoutput> 
      </table>

<table cellpadding="0" cellspacing="0" border="0" width="97%" height="35" align="center">
	<tr> 
	<cfif get_partner_all.recordcount>
		<td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="member.partner_list"></td>
		<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
	<cfelse>
		<td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
	</cfif>
	</tr>
</table>
