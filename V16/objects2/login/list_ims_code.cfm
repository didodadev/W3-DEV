<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.plate_code" default="">
<cfparam name="attributes.ims_code_ids" default="0">
<cfparam name="attributes.related_ids" default="0">
<cfquery name="GET_IMS_CODE" datasource="#dsn#">
	SELECT
		IMS_CODE_ID,
		IMS_CODE,
		IMS_CODE_NAME
	FROM
		SETUP_IMS_CODE
	WHERE
		IMS_CODE_ID IS NOT NULL
		<cfif len(attributes.keyword)>
		AND
			(
			IMS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
			IMS_CODE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
		</cfif>
		<cfif len(attributes.plate_code)>AND IMS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="0#numberformat(attributes.plate_code,'00')#%"></cfif>
		<cfif isdefined("attributes.bsm_id")>AND IMS_CODE_ID IN 
		(	
			SELECT 
				SALES_ZONES_TEAM_IMS_CODE.IMS_ID
			FROM
				SALES_ZONES_TEAM,
				SALES_ZONES_TEAM_IMS_CODE
			WHERE
				<!--- SALES_ZONES_TEAM.LEADER_POSITION_CODE = #session.ep.position_code# AND --->
				SALES_ZONES_TEAM.TEAM_ID = SALES_ZONES_TEAM_IMS_CODE.TEAM_ID
		)</cfif>
	ORDER BY
		IMS_CODE
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_ims_code.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	function gonder(id,name)
	{
	   <cfif isDefined("attributes.field_id")>
			opener.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			opener.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
		</cfif>
		window.close();
	}
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr><td height="35" class="headbold"><cf_get_lang no='487.IMS Bölge Kodları'></td>
	<td  style="text-align:right;">
	<table>
	   <cfform name="search_ims" action="#request.self#?fuseaction=objects2.popup_list_ims_code" method="post">
	 		<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
			<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
			<input type="hidden" name="plate_code" id="plate_code" value="<cfoutput>#attributes.plate_code#</cfoutput>">
	 	 <!-- sil -->
        <tr>
		   <td><cf_get_lang_main no='48.Filtre'></td>
			<td><cfinput type="Text" maxlength="255" value="#attributes.keyword#" name="keyword"></td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
			<td><cf_wrk_search_button></td>
			<td><input type="hidden" name="is_submitted" id="is_submitted" value="1"></td>
			</tr>
			</cfform>
		 <!-- sil -->
      </table>
	</td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
	<tr height="22" class="color-header">		
        <td class="form-title" width="30"><cf_get_lang_main no='75.No'></td>
		<td class="form-title" width="150"><cf_get_lang no='488.IMS Kod Numarası'></td>
		<td class="form-title"><cf_get_lang no='489.IMS Bölge Adı'></td>
	</tr>
		<cfif get_ims_code.recordcount>
		<cfoutput query="get_ims_code" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="30">#currentrow#</td>
				<td><a href="javascript://" class="tableyazi"  onClick="gonder('#ims_code_id#','#ims_code# #ims_code_name#')">#ims_code#</a></td>
				<td>#ims_code_name#</td>
			</tr>		
		</cfoutput>
	<cfelse>
	<tr class="color-row">
		<td colspan="4" height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
	</tr>
	</cfif>
</table>
</td>
</tr>
</table>
<!-- sil -->
<cfif attributes.maxrows lt attributes.totalrecords>
	<cfset url_string = "">
	<cfif isdefined("field_id")>
		<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
	</cfif>
	<cfif isdefined("field_name")>
		<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
	</cfif>
	<cfif isdefined("keyword")>
		<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.il_id")>
		<cfset url_string = "#url_string#&il_id=#attributes.il_id#">
	</cfif>
	<cfif isdefined("attributes.plate_code")>
		<cfset url_string ="#url_string#&plate_code=#attributes.plate_code#">
	</cfif>
<table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
  <tr> 
    <td><cf_pages 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="objects2.popup_list_ims_code#url_string#"></td>
    <td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>#attributes.page#/#lastpage#</cfoutput></td>
  </tr>
</table>
</cfif>
