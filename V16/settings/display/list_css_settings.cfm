<cfparam name="attributes.keyword" default="#session.ep.name#">
<cfparam name="attributes.menu_status" default="1">
<cfinclude template="../query/get_css_settings.cfm">	
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_CSS_SETTINGS.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

 <cfset url_string = "">
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)>
	<cfset url_string = "#url_string#&POSITION_CAT_ID=#attributes.POSITION_CAT_ID#">
</cfif>
<cfif isdefined("attributes.USER_GROUP_ID") and len(attributes.USER_GROUP_ID)>
	<cfset url_string = "#url_string#&USER_GROUP_ID=#attributes.USER_GROUP_ID#">
</cfif>
<cfset url_string = "#url_string#&menu_status=#attributes.menu_status#">
 
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no ='2431.Css Ayarları'></td>
    <td align="right" style="text-align:right;">
      <table>
        <tr>
          <cfform name="filter" action="#request.self#?fuseaction=settings.list_css_settings" method="post">
            <td><cf_get_lang_main no ='48.Filtre'></td>
			<td>
				<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>"> 
				<input type="text" name="employee_name" id="employee_name" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_name)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>" style="width:150px;"  maxlength="255">
			   <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=filter.employee_id&field_name=filter.employee_name&select_list=1','list');return false"><img SRC="/images/plus_thin.gif" BORDER="0" ALIGN="absmiddle"></a>
			</td>
            <td>
              <select name="menu_status" id="menu_status">
                <option value=''><cf_get_lang_main no ='296.Tümü'></option>
                <option value='1'<cfif attributes.menu_status eq 1> selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
                <option value='0'<cfif attributes.menu_status eq 0> selected</cfif>><cf_get_lang_main no ='82.Pasif'></option>
              </select>
            </td>
			<td>
			<cfsavecontent variable="alert"><cf_get_lang no ='1983.Hatalı sayı girdiniz'></cfsavecontent>
			<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#alert#">
            </td>
            <td><cf_wrk_search_button></td>
          </cfform>
        </tr>
      </table>
    </td>
  </tr>
</table>
      <table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
        <tr height="22" class="color-header">
          <td class="form-title"><cf_get_lang no ='2432.Css Adı'></td>
          <td width="65" class="form-title"><cf_get_lang_main no ='71.Kayıt'></td>
		  <td width="65" class="form-title"><cf_get_lang_main no ='215.Kayıt Tarihi'></td>
		  <td width="15"><cfoutput><a href="#request.self#?fuseaction=settings.form_add_css_setting"><img src="/images/plus_square.gif" border="0"></a></cfoutput></td>
        </tr>
       <cfif GET_CSS_SETTINGS.recordcount >
          <cfoutput query="GET_CSS_SETTINGS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
           <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td>#css_name#</td>
			  <td>#employee_name# #employee_surname#</td>
              <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
			  <td><a href="#request.self#?fuseaction=settings.form_upd_css_setting&css_id=#css_id#"><img src="/images/update_list.gif" border="0"></a></td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row" height="20">
            <td colspan="4"><cf_get_lang_main no ='1074.Kayıt Bulunamadı'></td>
          </tr>
        </cfif>
      </table>
<cfif attributes.maxrows lt attributes.totalrecords>
  <table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
    <tr>
      <td>
        <cfset adres = "settings.list_css_settings">
        <cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres##url_string#" >
				</td>
      <!-- sil --><td align="right" style="text-align:right;"> <cfoutput><cf_get_lang_main no ='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no ='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
