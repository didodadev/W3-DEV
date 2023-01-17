<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_potential" default="">
<cfparam name="attributes.search_status" default=1>
<cfinclude template="../query/get_sales_branches.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_company.cfm">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_company.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35" class="headbold">
  <tr>
    <td>
      <cfif isdefined("attributes.comp_cat") and len(attributes.comp_cat) and attributes.comp_cat neq 0>
        <cfquery name="GET_SELECTED_CAT" datasource="#DSN#">
			SELECT 
				* 
			FROM 
				COMPANY_CAT 
			WHERE 
				COMPANYCAT_ID = #attributes.COMP_CAT#
        </cfquery>
        <cfif GET_SELECTED_CAT.recordcount>
          <cfoutput>#GET_SELECTED_CAT.COMPANYCAT# </cfoutput>
        </cfif>
        <cfelse>
        <cf_get_lang_main no='1731.Tedarikçiler'>
      </cfif>
    </td>
    <!-- sil -->
    <td valign="bottom" style="text-align:right;">
      <!--- Arama --->
      <table>
        <cfform name="form" action="#request.self#?fuseaction=crm.form_list_company" method="post">
          <tr>
            <td><cf_get_lang_main no='48.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255"></td>
            <td  style="text-align:right;">
              <select name="comp_cat" id="comp_cat">
                <option value=""><cf_get_lang_main no='74.Kategori'>
                <cfoutput query="get_companycat">
                  <option value="#COMPANYCAT_ID#" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat is COMPANYCAT_ID> selected</cfif>>#companycat#</option>
                </cfoutput>
              </select>
			  <select name="search_potential" id="search_potential">
               	<option value=""  <cfif not len(attributes.search_potential)>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
			    <option value="1" <cfif attributes.search_potential is 1>selected</cfif>><cf_get_lang_main no='165.Potansiyel'></option>
                <option value="0" <cfif attributes.search_potential is 0>selected</cfif>><cf_get_lang_main no='649.Cari'></option>                
			  </select></td>
            <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
            <td><cf_wrk_search_button></td>
            <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'> </tr>
        
      </table>
      <!--- Arama --->
    </td>
    <!-- sil -->
  </tr>
</table>
<cfset sayac = 0>
<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr style="text-align:right;" class="color-list">
		<td height="22" colspan="9">
		<table>
		  <tr>
		    <td>
                <select name="search_type" id="search_type">
                    <option value="0" <cfif isDefined('attributes.search_type') and attributes.search_type is 0>selected</cfif>><cf_get_lang no='365.Şirketler'></option>
                    <option value="1" <cfif isDefined('attributes.search_type') and attributes.search_type is 1>selected</cfif>><cf_get_lang_main no='1463.Çalışanlar'></option>
                </select>
                <select name="search_status" id="search_status">
                    <option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                    <option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                    <option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang no='286.Tüm Kayıtlar'></option>
                </select>
                <select name="responsible_branch_id" id="responsible_branch_id">
                    <option value="0"><cf_get_lang_main no='41.Şube'></option>
                    <cfoutput query="get_branchs"> 
                        <option value="#branch_id#" <cfif isdefined("attributes.responsible_branch_id") and len(attributes.responsible_branch_id) and attributes.responsible_branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                    </cfoutput> 
                </select>
			</td>
		    </tr>
			</cfform>
		  </table>
		  </td>
		</tr>
		<tr class="color-header">
          <td height="22" class="form-title"><cf_get_lang_main no='162.Şirket'></td>
          <td class="form-title" width="125"><cf_get_lang_main no='74.Kategori'></td>
          <td class="form-title" width="150"><cf_get_lang_main no='1714.Yönetici'></td>
          <!-- sil -->
          <td class="form-title" width="150"><cf_get_lang_main no='496.Temsilci'></td>
		  <td class="form-title" width="65"><cf_get_lang_main no='165.Potansiyel'></td>
          <td width="70" class="form-title"><cf_get_lang_main no='731.İletişim'></td>
          <td class="form-title" width="30"><cf_get_lang_main no='41.Şube'></td>
          <td class="form-title" width="25"><cf_get_lang_main no='2034.Kişi'></td>
          <!-- sil -->
	  	  <!--- finans module kullanılıyorsa ve kullanıcının finance modulunde yetkisi varsa cari hesap görülebilir--->
          <cfif get_module_user(16)>
		  	<td  class="form-title" style="text-align:right;"><cf_get_lang_main no='177.Bakiye'></td>
		  </cfif>
        </tr>
        <cfif get_company.recordcount>
          <cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
          <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td> <a href="#request.self#?fuseaction=member.detail_company&cpid=#COMPANY_ID#" class="tableyazi">#fullname#</a></td>
              <cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
				  SELECT 
					  COMPANYCAT_ID, 
					  COMPANYCAT 
				  FROM 
					  COMPANY_CAT 
				  WHERE 
					  COMPANYCAT_ID=#COMPANYCAT_ID#
              </cfquery>
              <td>#GET_COMPANY_CAT.COMPANYCAT#</td>
              <td>
                <cfif len(MANAGER_PARTNER_ID) and MANAGER_PARTNER_ID neq 0>
                  <cfquery name="GET_PARTNER" datasource="#DSN#">
					  SELECT 
						  COMPANY_PARTNER_NAME, 
						  COMPANY_PARTNER_SURNAME, 
						  COMPANY_PARTNER_EMAIL
					  FROM 
						  COMPANY_PARTNER 
					  WHERE 
						  PARTNER_ID = #MANAGER_PARTNER_ID#
                  </cfquery>
                  <a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#MANAGER_PARTNER_ID#" class="tableyazi">#get_partner.company_partner_name#&nbsp;#get_partner.company_partner_surname#</a>
                <cfelse>
                  <cf_get_lang no='363.Tanımlı Değil'>
                </cfif>
              </td>
              <!-- sil -->
              <td>
                <cfif len(pos_code)>
                  <cfquery name="GET_EMPLOYEE_POSITIONS" datasource="#dsn#">
					  SELECT 
						  POSITION_CODE, 
						  EMPLOYEE_NAME, 
						  EMPLOYEE_ID, 
						  EMPLOYEE_SURNAME
					  FROM 
						  EMPLOYEE_POSITIONS 
					  WHERE 
						  POSITION_CODE = #GET_COMPANY.POS_CODE# 
					  AND
						  POSITION_STATUS = 1
                  </cfquery>
                  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_EMPLOYEE_POSITIONS.EMPLOYEE_ID#','medium')" class="tableyazi">#GET_EMPLOYEE_POSITIONS.EMPLOYEE_NAME# #GET_EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME#</a>
                <cfelse>
                  <cf_get_lang no='363.Tanımlı Değil'>
                </cfif>
              </td>
			  <td>
			  <cfif ISPOTANTIAL eq 1>
			  <cf_get_lang_main no='165.Potansiyel'>
			  <cfelse>
			  <cf_get_lang no='364.Potansiyel Değil'>
			  </cfif></td>
              <td>
                <cfif len(COMPANY_EMAIL)>
                  <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&special_mail=#COMPANY_EMAIL#','list')"><img src="/images/mail.gif" title="<cf_get_lang no='367.Mail Olarak Yolla'>" border="0"></a>
                </cfif>
                <cfif len(COMPANY_TEL1)>
                  <img src="/images/tel.gif" border="0" title="Telefon:#COMPANY_TELCODE# - #COMPANY_TEL1#">
                </cfif>
                <cfif len(COMPANY_FAX)>
				&nbsp;<img src="/images/fax.gif"  title="Fax:#COMPANY_TELCODE# - #COMPANY_FAX#" border="0">
                </cfif>
              </td>
              <td align="center"><a href="#request.self#?fuseaction=member.form_add_branch&cpid=#company_id#"><img src="/images/branch_plus.gif" border="0" title="<cf_get_lang no='318.Şube Ekle'>"></a></td>
              <td align="center"><a href="#request.self#?fuseaction=member.form_add_partner&comp_cat=#companycat_id#&compid=#company_id#"><img src="/images/partner_plus.gif" border="0" title="<cf_get_lang no='368.Kişi Ekle'>" ></a></td>
              <!-- sil -->
			  <cfif get_module_user(16)>
				  <cfquery name="GET_BAKIYE" datasource="#DSN2#">
					  SELECT 
						  BAKIYE 
					  FROM 
						  COMPANY_REMAINDER 
					  WHERE 
						  COMPANY_ID=#GET_COMPANY.COMPANY_ID#
				  </cfquery>
				  <cfif get_bakiye.recordcount>
					<cfset bakiye=get_bakiye.bakiye>
				  <cfelse>
					<cfset bakiye=0>
				  </cfif>
				  <td  style="text-align:right;"> #TLFormat(ABS(bakiye))# #session.ep.money# <cfif bakiye lte 0>(A)<cfelse>(B)</cfif></td>
			  </cfif>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row" height="20">
            <td colspan="9"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td>
        <cfset adres = attributes.fuseaction>
        <cfset adres = adres&"&search_status="&attributes.search_status>
        <cfset adres = adres&"&search_potential="&attributes.search_potential>
		<cfif len(attributes.keyword)>
			<cfset adres = adres&"&keyword="&attributes.keyword>
		</cfif>
		<cfif isDefined('attributes.comp_cat') and len(attributes.comp_cat)>
			<cfset adres = adres&"&comp_cat="&attributes.comp_cat>
		</cfif>
		<cfif isDefined('attributes.search_type') and len(attributes.search_type)>
			<cfset adres = adres&"&search_type="&attributes.search_type>
		</cfif>
		<cfif isDefined('attributes.responsible_branch_id') and len(attributes.responsible_branch_id)>
			<cfset adres = adres&"&responsible_branch_id="&attributes.responsible_branch_id>
		</cfif>
	  <cf_pages 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#">
	  </td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<br/>
<!-- sil -->
<script type="text/javascript">
	document.form.keyword.focus();
</script>
<!-- sil -->
