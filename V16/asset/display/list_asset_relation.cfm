<cfquery name="get_assets" datasource="#DSN#">
	SELECT 
		ASSET_ID,
		ASSETCAT_ID,
		ASSET_NAME
	FROM
		ASSETS
	WHERE
		ASSET_ID IS NOT NULL 
</cfquery>
<cfif isdefined("attributes.qid")>
	<cfinclude template="../query/add_asset_RELATION.cfm">
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cfset sayac=0>
<cfset adres="">
<cfif isDefined('attributes.train_id') and len(attributes.train_id)>
	<cfset adres = adres&"&train_id="&attributes.train_id>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_assets.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellpadding="0" cellspacing="0" border="0" width="98%" align="center">
  <tr>
    <td class="color-border" valign="top">
      <table width="100%" cellpadding="2" cellspacing="1" border="0">
        <tr class="color-header" height="22">
		 <td class="form-title">
		   <cf_get_lang_main no='675.Sorular'>
		 </td>
	    </tr>
		<cfif get_assets.recordcount>
		<cfoutput query="get_questions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td>
			<a href="#request.self#?fuseaction=asset.popup_list_asset_relation&training_id=#url.training_id#&QUESTION=#QUESTION#&qid=#QUESTION_ID##adres#" class="tableyazi">#QUESTION#</a>
			</td>
		</tr>
		</cfoutput>
		<cfelse>
		<tr class="color-row" height="20">
		  <td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'></td>
		</tr> 
		</cfif>
	  </table>
	</td>
  </tr>
</table>
