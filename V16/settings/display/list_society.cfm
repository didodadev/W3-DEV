<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submit")>
    <cfquery name="GET_CORP" datasource="#DSN#">
        SELECT 
            * 
        FROM 
            SETUP_CORPORATIONS
        WHERE 
            CORPORATION_ID IS NOT NULL
            <cfif len(attributes.keyword)>
             AND
             (
             CORPORATION_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
             CORPORATION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
             )
            </cfif>
    </cfquery>
<cfelse>
	<cfset GET_CORP.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.totalrecords" default='#get_corp.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!-- sil -->
<table width="100%" cellpadding="0" cellspacing="0" height="100%">
  <tr valign="top">
    <td valign="top">
	<!-- sil -->
      <table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
        <tr>
          <td class="headbold"><cf_get_lang no='155.Çalışılan Kurumlar'></td>
		  <!-- sil -->
          <td valign="bottom">
            <!--- Arama --->
            <table align="right">
              <tr height="35">
                <cfform name="search_corp" action="#request.self#?fuseaction=settings.list_society" method="post">
                <input type="hidden" name="form_submit" id="form_submit" value="1" />
                  <td align="right" style="text-align:right;"><cf_get_lang_main no ='48.Filtre'>: <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#"></td>
                  <td><cfsavecontent variable="message"><cf_get_lang_main no ='131.Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
                  <td><cf_wrk_search_button></td>
                </cfform>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			  </tr>
            </table>
            <!--- Arama --->
          </td>
		<!-- sil -->	  
        </tr>
      </table>
      <!--- Ünvan Kategorileri --->
            <table width="98%" border="0" cellpadding="2" cellspacing="1" class="color-border" align="center">
              <tr height="20" class="color-header">
			    <td class="form-title" width="30"><cf_get_lang_main no='75.No'></td>
                <td class="form-title" width="200"><cf_get_lang no='1122.Kurum Kodu'> </td>
                <td class="form-title" width="350"><cf_get_lang no='1123.Kurum Adı'></td>
                <td class="form-title"><cf_get_lang_main no='217.Açıklama'></td>
			    <td width="15"><a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_corp</cfoutput>','small');"><img src="/images/plus_square.gif" alt="<cf_get_lang no='146.Ürün Kategorisi Ekle'>" border="0" align="absmiddle"></a></td>
              <!-- sil -->
			  </tr>
              <cfif get_corp.recordcount>
                <cfoutput query="get_corp" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
         			<td>#currentrow#</td>
                    <td>#corporation_code#</td>
                    <td>#corporation_name#</td>
                    <td>#corporation_detail#</td>
                    <td width="15" align="right" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_upd_corp&c_id=#get_corp.CORPORATION_ID#','small');"><img src="/images/update_list.gif" alt="<cf_get_lang no='146.Ürün Kategorisi Ekle'>" border="0" align="absmiddle"></a></td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr height="20" class="color-row">
                  <td colspan="7"><cfif isdefined("attributes.form_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no="289.Filtre Ediniz">!</cfif></td>
                </tr>
              </cfif>
            </table>
      <cfif attributes.totalrecords gt attributes.maxrows>
        <table cellpadding="0" cellspacing="0" border="0" align="center" width="98%" height="35">
          <tr>
            <td><cfset url_string = "">
              <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                <cfset url_string = "#url_string#&keyword=#attributes.keyword#">
              </cfif>
              <cfif isDefined('attributes.form_submit') and len(attributes.form_submit)>
                <cfset url_string = "#url_string#&form_submit=#attributes.form_submit#">
              </cfif>
              <cf_pages page="#attributes.page#"
					  maxrows="#attributes.maxrows#"
					  totalrecords="#attributes.totalrecords#"
					  startrow="#attributes.startrow#"
					  adres="settings.list_society#url_string#">
			</td>
            <!-- sil --><td align="right" style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
          </tr>
        </table>
      </cfif>
	<!-- sil -->	  
    </td>
  </tr>
</table>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
