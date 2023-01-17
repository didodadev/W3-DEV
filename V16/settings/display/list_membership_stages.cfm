<cfparam name="attributes.keyword" default="">
<cfquery name="get_membership_stages" datasource="#dsn#">
	SELECT
		SETUP_MEMBERSHIP_STAGES.RECORD_EMP,
		SETUP_MEMBERSHIP_STAGES.TR_ID,
		SETUP_MEMBERSHIP_STAGES.TR_NAME,
		SETUP_MEMBERSHIP_STAGES.RECORD_DATE
	FROM
		SETUP_MEMBERSHIP_STAGES
	WHERE
		SETUP_MEMBERSHIP_STAGES.TR_ID IS NOT NULL
		<cfif len(attributes.keyword)>AND SETUP_MEMBERSHIP_STAGES.TR_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
	ORDER BY
		SETUP_MEMBERSHIP_STAGES.TR_ID
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_membership_stages.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
    </td>
    <td valign="top">
      <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="headbold"><cf_get_lang no='596.Üye Durum'></td>
          <!-- sil -->
          <td valign="bottom">
		  <table align="right">
              <cfform name="search" action="#request.self#?fuseaction=settings.list_membership_stages" method="post">
                <tr><input type="hidden" value="<cfoutput>#attributes.keyword#</cfoutput>">
					<td><cf_get_lang_main no='48.Filtre'>:</td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
					<td><cf_wrk_search_button></td>
                </tr>
              </cfform>
            </table>
          </td>
          <!-- sil -->
        </tr>
      </table>
            <table cellspacing="1" cellpadding="2" width="98%" border="0" align="center" class="color-border">
              <tr class="color-header">
                <td class="form-title"><cf_get_lang_main no='344.Durum'></td>
                <td class="form-title" width="300"><cf_get_lang_main no='487.Kaydeden'></td>
                <td class="form-title" width="300"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
                <td width="15"><a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_membership_stages</cfoutput>','small');"><img src="/images/plus_square.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0" align="absmiddle"></a></td>
              </tr>
              <cfif get_membership_stages.recordcount>
                <cfoutput query="get_membership_stages" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>#tr_name#</td>
                    <td>#get_emp_info(record_emp,0,1)#</td>
                    <td>#dateformat(record_date,dateformat_style)#</td>
                    <td width="15" align="right" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_upd_membership_stages&tr_id=#tr_id#','small');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absmiddle"></a></td>
                </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td height="20" colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı!'></td>
                </tr>
              </cfif>
            </table>
      <cfif attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
        <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
          <tr>
            <td><cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="settings.list_membership_stages#url_str#"> </td>
            <!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
          </tr>
        </table>
      </cfif>
    </td>
  </tr>
</table>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
