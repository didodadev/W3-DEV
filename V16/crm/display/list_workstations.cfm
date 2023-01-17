<!---**************************
bu sayfanın bir kopyası üretim planlamada display/list_workstation.cfm
yapılacak değişiklikleri o sayfada da yapın
--->
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.keyword" default="">
<cfset send="crm.popup_list_workstations">
<cfinclude template="../query/get_workstations.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_workstations.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../../production/query/get_branch.cfm">
<cfinclude template="../../production/query/get_company_info_with_func.cfm">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td class="headbold" height="35"><cf_get_lang no='83.Kurumsal Üye İş İstasyonları'></td>
    <td  style="text-align:right;">
      <!--- Arama --->
      <table width="250">
        <cfform action="#request.self#?fuseaction=#send#&cpid=#attributes.cpid#" method="post">
          <tr>
            <td><cf_get_lang_main no='48.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            <td nowrap>
              <select name="branch_id" id="branch_id" style="width:150px;"  >
                <option value="" <cfif not len(attributes.branch_id)>selected</cfif>><cf_get_lang no='63.Tüm İstasyonlar'></option>
                <cfoutput query="get_branch">
                  <option value="#branch_id#"<cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                </cfoutput>
              </select>
              <select name="ws_status_" id="ws_status_" style="width:50px;">
                <option value="1" <cfif  isDefined('attributes.ws_status_') and attributes.ws_status_ eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                <option value="0" <cfif isDefined('attributes.ws_status_') and attributes.ws_status_ eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                <option value="2" <cfif isDefined('attributes.ws_status_') and attributes.ws_status_ eq 2>selected</cfif>><cf_get_lang no='11.Tümü'></option>
              </select>
			<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td>
              <cf_wrk_search_button>
            </td>
          </tr>
        </cfform>
      </table>
      <!--- Arama --->
    </td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-header" height="22">
          <td class="form-title" width="30"><cf_get_lang_main no='75.No'></td>
          <td class="form-title"><cf_get_lang no='300.İstasyon Adı'></td>
          <td class="form-title" width="100"><cf_get_lang_main no='41.Şube'></td>
          <td class="form-title"width="125"><cf_get_lang no='301.Dış Kaynak'></td>
          <td class="form-title" width="125"><cf_get_lang_main no='166.Yetkili'></td>
          <td  width="25" align="center"> <a href="<cfoutput>#request.self#?fuseaction=prod.popup_add_workstation</cfoutput>"> <img src="/images/plus_square.gif" title="<cf_get_lang no='304.İstasyon Ekle'>" border="0"> </a> </td>
        </tr>
        <cfif get_workstations.recordcount>
          <cfoutput query="get_workstations" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td>#STATION_ID#</td>
              <td> #STATION_NAME# </td>
              <td> #BRANCH_NAME# </td>
              <td width="175">
                <!--- sorgu burdan dosyaya alinacak!--->
                <cfif len(OUTSOURCE_PARTNER)>
                  <cfset COMPANY_ID=OUTSOURCE_PARTNER>
                  #get_par_info(COMPANY_ID,0,-1,1)#
                </cfif>
              </td>
              <td> <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi"> #EMPLOYEE_NAME# #EMPLOYEE_SURNAME# </a> </td>
              <td align="center">
                <cfif isdefined("attributes.field_id")>
                  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_list_workstation_orders&station_id=#STATION_ID#','list')"> <img src="/images/report_square2.gif" border="0" title="<cf_get_lang no='303.İstasyon Yükü'>"> </a>
                  <cfelse>
                  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_list_workstation_orders&station_id=#STATION_ID#','list')"> <img src="/images/report_square2.gif" border="0" title="<cf_get_lang no='303.İstasyon Yükü'>"> </a>
                </cfif>
              </td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row" height="20">
            <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<br/>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
    <tr>
      <td> <cf_pages page="#attributes.page#"
						  maxrows="#attributes.maxrows#"
						  totalrecords="#attributes.totalrecords#"
						  startrow="#attributes.startrow#"
						  adres="#send#&branch_id=#attributes.branch_id#&keyword=#attributes.keyword#&cpid=#attributes.cpid#"> </td>
      <!-- sil --><td  style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#get_workstations.recordcount#</cfoutput> &nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:<cfoutput>#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<script type="text/javascript">
	function add_product(id,name,capacity)
		{
			window.close();
			<cfif isdefined("attributes.field_name")>
				opener.<cfoutput>#field_name#</cfoutput>.value = name;
			</cfif>
			<cfif isdefined("attributes.field_capacity")>
				opener.<cfoutput>#field_capacity#</cfoutput>.value = capacity;
			</cfif>
			<cfif isdefined("attributes.field_id")>
				opener.<cfoutput>#field_id#</cfoutput>.value = id;
			</cfif>
			<cfif isdefined("attributes.c")>
				opener.add_production_order.route_name.value = "";
				opener.add_production_order.route_id.value = "";	
			</cfif>
		}
</script>

