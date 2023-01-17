<cfparam name="attributes.help" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfif isDefined('session.ww')>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
<cfelseif isDefined('session.pp')>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
</cfif>
<cfquery name="GET_HELP" datasource="#dsn#">
	SELECT
		HELP_ID,
		HELP_HEAD,
		HELP_TOPIC,
		RECORD_DATE
		RECORD_MEMBER,
		HELP_FUSEACTION,
		HELP_CIRCUIT,
		IS_STANDARD
	FROM 
		HELP_DESK
	WHERE 
		IS_INTERNET = 1
	<cfif isDefined("attributes.keyword") and (len(attributes.keyword) eq 1)>
		AND HELP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
	<cfelseif isDefined("attributes.keyword") and (len(attributes.keyword) gt 1)>
		AND 
		(
			HELP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 				
			HELP_TOPIC LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 				
			HELP_CIRCUIT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		)
	</cfif>
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_help.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table width="100%" align="center" cellpadding="2" cellspacing="1">
	 <tr>
		<cfform name="help_search" action="#request.self#?fuseaction=objects2.search_helpdesk" method="post">
			<td class="formbold" height="25"><cf_get_lang no ='1215.Yardımlar'></td>
			<td  style="text-align:right;">
				<cf_get_lang_main no='48.Filtre'>
				<cfinput type="text" name="keyword" maxlength="100" value="#attributes.keyword#">
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"onkeyup="isNumber(this);" onblur="isNumber(this);">
				<cf_wrk_search_button>
			</td>
		</cfform>
	</tr>
</table>
<table width="100%" align="center" cellpadding="2" cellspacing="1" class="color-border">
    <tr class="color-header" height="22">
		<td class="form-title" width="20"><cf_get_lang_main no='75.No'></td>
		<td class="form-title"><cf_get_lang_main no='68.Başlık'></td>
	</tr>
		<cfif get_help.recordcount>
          <cfoutput query="get_help" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td width="20">#currentrow#</td>
              <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_view_help&help_id=#get_help.help_id#','page')" class="tableyazi">#help_head#</a></td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr height="20" class="color-row">
            <td colspan="2"><cf_get_lang_main no='289.Filtre Ediniz'> !</td>
          </tr>
        </cfif>
	</table>
<cfif attributes.maxrows lt attributes.totalrecords>
  <table cellpadding="0" cellspacing="0" border="0" align="center" width="98%" height="35">
    <tr>
      <td>
        <cfset adres = attributes.fuseaction>
        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
        	<cfset adres = adres&"&keyword=#attributes.keyword#">
        </cfif>
        <cf_pages page="#attributes.page#"
		  maxrows="#attributes.maxrows#"
		  totalrecords="#attributes.totalrecords#"
		  startrow="#attributes.startrow#"
		  adres="#adres#">
	  </td>
      <!-- sil --><td  style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<script type="text/javascript">
	help_search.keyword.focus();
</script>
