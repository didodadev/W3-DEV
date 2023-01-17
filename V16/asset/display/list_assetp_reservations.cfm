<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">

<cfif len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>

<cfquery name="GET_ASSET_RESERVESS" datasource="#DSN#">
	SELECT
		*
	FROM
		ASSET_P_RESERVE
	WHERE 
		ASSETP_ID = #attributes.ASSETP_ID#
		<cfif len(attributes.startdate) and not len(attributes.finishdate)>
			AND FINISHDATE >= #attributes.startdate#
		<cfelseif len(attributes.finishdate)and not len(attributes.startdate)>
			AND STARTDATE <= #attributes.finishdate#
		<cfelseif len(attributes.startdate) and len(attributes.finishdate)>
			AND STARTDATE <= #attributes.finishdate# AND FINISHDATE >= #attributes.startdate#
		</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_asset_reservess.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../query/get_assetp.cfm">
<table cellSpacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr height="35"> 
    <td class="headbold"><cfoutput><cf_get_lang no='126.Rezervasyon'>: #get_assetp.assetp#</cfoutput></td>
    <td style="text-align:right;">
	<!--- Arama --->
      <table> 
        <cfform  name="search_asset" method="post" action="#request.self#?fuseaction=asset.popup_list_assetp_reservations&assetp_id=#assetp_id#">
		<input type="Hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#assetp_id#</cfoutput>">
		<tr>
			<td style="text-align:right;"><cf_get_lang_main no='48.Filtre'>:</td>
			<td style="text-align:right;">
			<cfif len(attributes.startdate)>
				<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='641.Başlangıç tarihi'></cfsavecontent>
				<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
				<cf_wrk_date_image date_field="startdate">
			<cfelse>
				<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='641.Başlangıç tarihi'></cfsavecontent>
				<cfinput type="text" name="startdate" value="" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
				<cf_wrk_date_image date_field="startdate">
			</cfif>
			<cfif len(attributes.finishdate)>
				<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent>
				<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
				<cf_wrk_date_image date_field="finishdate">
			<cfelse>
				<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent>
				<cfinput type="text" name="finishdate" value="" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
				<cf_wrk_date_image date_field="finishdate">
			</cfif>
			<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			<td style="text-align:right;"><cf_wrk_search_button search_function='check()'></td>
		</tr>
    	</cfform>
	  </table>
	  <!--- //Arama --->
	</td>
  </tr>
</table>
              <table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center"> 
          <tr class="color-header" height="22">
		<td class="form-title"><cf_get_lang_main no='1713.Olay'></td>
		<td class="form-title"><cf_get_lang no='129.Başlangıç - Bitiş'></td>
	</tr>
<cfif get_asset_reservess.recordcount>
	<cfoutput query="get_asset_reservess" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td>
			<cfif len(get_asset_reservess.event_id)>
				<cfset attributes.EVENT_ID = get_asset_reservess.event_id>
				<cfinclude template="../query/get_event_head.cfm">
				#event_head.event_head# (<cf_get_lang_main no='1713.Olay'>)
			<cfelseif len(get_asset_reservess.project_id)>
				<cfset attributes.project_id = get_asset_reservess.project_id>
				<cfinclude template="../query/get_project_name.cfm">
				#get_project_name.project_head# (<cf_get_lang_main no='4.Proje'>)
			<cfelseif len(get_asset_reservess.class_id)>
				<cfset attributes.class_id = get_asset_reservess.class_id>
				<cfinclude template="../query/get_class_name.cfm">
				#get_class_names.class_name# (<cf_get_lang no='128.Ders'>)
			<cfelse>
				<cf_get_lang no='73.Olaysız'>
			</cfif>  
		   </td> 
	<td>#dateformat(STARTDATE,dateformat_style)# (#timeformat(STARTDATE,timeformat_style)#) - #dateformat(FINISHDATE,dateformat_style)# (#timeformat(finishDATE,timeformat_style)#)</td>
	</tr>
	</cfoutput>
	<cfelse>
	<tr class="color-row">
		<td colspan="3" height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı !'></td>
	</tr>
	</cfif>
</table>
<cfif attributes.maxrows lt attributes.totalrecords>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" height="35">
    <tr> 
      <td> 
		<cfset adres=attributes.fuseaction>
		<cfset adres = "#adres#&assetp_id=#attributes.assetp_id#">
		<cfif len(attributes.finishdate)>
			<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
		</cfif>
		<cfif len(attributes.startdate)>
			<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
		</cfif>
		<cf_pages page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
      </td>
      <!-- sil --><td height="35"  style="text-align:right;">
	  	<cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput>
	  </td><!-- sil -->
    </tr>
  </table>
  <br/>
</cfif>
<script type="text/javascript">
function check(){
	if ( (document.search_asset.startdate.value != "") && (document.search_asset.finishdate.value != "") )
		return date_check(document.search_asset.startdate,document.search_asset.finishdate,"<cf_get_lang no='96.Başlangıç tarihi bitiş tarininden küçük olmalıdır !'>");
		return true;
}
</script>

