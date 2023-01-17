<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submitted")>
<cfquery name="get_head" datasource="#dsn#">
	SELECT
		HEADQUARTERS_ID,
		NAME
	FROM
		SETUP_HEADQUARTERS
	WHERE
		NAME IS NOT NULL
	<cfif len(attributes.keyword) and (len(attributes.keyword) eq 1)>
		AND NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
	<cfelseif len(attributes.keyword) and (len(attributes.keyword) gt 1)>
		AND NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
	</cfif>
	<cfif isdefined("attributes.upper_headquarters_id") and len(attributes.upper_headquarters_id) and len(attributes.upper_headquarters_name)>
		AND UPPER_HEADQUARTERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_headquarters_id#">
	</cfif>
	ORDER BY
		NAME
</cfquery>
<cfelse>
	<cfset get_head.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_head.RecordCount#">
<cfset url_str = "">
<cfif isdefined("attributes.upper_headquarters_id") and len(attributes.upper_headquarters_id) and len(attributes.upper_headquarters_name)>
	<cfset url_str = "#url_str#&upper_headquarters_id=#attributes.upper_headquarters_id#&upper_headquarters_name=#attributes.upper_headquarters_name#">
</cfif>
<cfif isdefined("attributes.hr")>
	<cfset formun_adresi = 'hr.list_headquarters&hr=1'>
<cfelse>
	<cfset formun_adresi = 'settings.list_headquarters'>
</cfif>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr> 
    <td class="headbold"><cf_get_lang no='951.Üst Düzey Birimler'></td>
	<!-- sil -->
    <td align="right" valign="bottom" style="text-align:right;">
      <table>
		<cfform name="form_head" action="#request.self#?fuseaction=#formun_adresi#" method="post">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<tr>
		  <td><cf_get_lang_main no='48.Filtre'>:</td>
		  <td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
			<td><cf_get_lang no='1280.Üst Grup'></td>
			<td>
			<input type="hidden" name="upper_headquarters_id" id="upper_headquarters_id" value="<cfif isdefined("attributes.upper_headquarters_id") and len(attributes.upper_headquarters_id) and len(attributes.upper_headquarters_name)><cfoutput>#attributes.upper_headquarters_id#</cfoutput></cfif>">
			<input type="text" name="upper_headquarters_name" id="upper_headquarters_name" value="<cfif isdefined("attributes.upper_headquarters_id") and len(attributes.upper_headquarters_id) and len(attributes.upper_headquarters_name)><cfoutput>#attributes.upper_headquarters_name#</cfoutput></cfif>" style="width:175px;">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_headquarters&field_name=form_head.upper_headquarters_name&field_id=form_head.upper_headquarters_id</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
			</td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</td>
			<td><cf_wrk_search_button></td>
			<cfif not isdefined("attributes.hr")><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></cfif>
		</tr>
		</cfform>
	</table>  
  </td>
  <!-- sil -->
  </tr>
</table> 
      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class=color-border>
        <tr class="color-header" height="23"> 
			<td class=form-title><cf_get_lang no='1001.Üst Düzey Birim'></td>
			<td width="15">
			<cfif isdefined("attributes.hr")>
				<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.form_add_headquarters&hr=1"><img src="/images/plus_square.gif" border="0"></a>
			<cfelse>
				<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_headquarters"><img src="/images/plus_square.gif" border="0"></a>
			</cfif>
			</td>
		</tr>
        <cfif get_head.RecordCount>
        <cfoutput query="get_head" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
          <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td>
			<cfif isdefined("attributes.hr")>
				<a href="#request.self#?fuseaction=hr.form_upd_headquarters&head_id=#get_head.headquarters_id#&hr=1" class="tableyazi">#NAME#</a>
			<cfelse>
				<a href="#request.self#?fuseaction=settings.form_upd_headquarters&head_id=#get_head.headquarters_id#" class="tableyazi">#NAME#</a>
			</cfif>
			</td>
            <td>
			<cfif isdefined("attributes.hr")>
				<a href="#request.self#?fuseaction=hr.form_upd_headquarters&head_id=#get_head.headquarters_id#&hr=1"><img src="/images/update_list.gif" border="0"></a>
			<cfelse>
				<a href="#request.self#?fuseaction=settings.form_upd_headquarters&head_id=#get_head.headquarters_id#"><img src="/images/update_list.gif" border="0"></a>
			</cfif>
			</td>
          </tr>
        </cfoutput> 
        <cfelse>
        <tr class="color-row" height="20"> 
          <td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
        </tr>
        </cfif>
      </table>
<cfif attributes.totalrecords gt attributes.maxrows>
<table cellpadding="0" cellspacing="0" border="0" height="25" width="98%" align="center">
  <tr> 
    <td>
		<cfif len(attributes.form_submitted)>
	        <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
         <cf_pages page="#attributes.page#"
              maxrows="#attributes.maxrows#"
              totalrecords="#attributes.totalrecords#"
              startrow="#attributes.startrow#"
              adres="#formun_adresi#&keyword=#attributes.keyword#&#url_str#"> 
     </td><br/>
    <!-- sil --><td align="right" style="text-align:right;">
	<cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
  </tr>
</table>
</cfif>
<script type="text/javascript">
   document.getElementById('keyword').focus();
</script>
<br/>
