<cfinclude template="../query/get_assetp_cats_reserve.cfm">
<cfinclude template="../query/get_assetps_reserve.cfm">

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.asset_catid" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_assetps_reserve.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset adres = "">
<cfif isDefined('attributes.work_id') and len(attributes.work_id)>
	<cfset adres = "#adres#&work_id=#attributes.work_id#">
</cfif>
<cfif isDefined('attributes.class_id') and len(attributes.class_id)>
	<cfset adres = "#adres#&class_id=#attributes.class_id#">
</cfif>
<cfif isDefined('attributes.event_id') and len(attributes.event_id)>
	<cfset adres = "#adres#&event_id=#attributes.event_id#">
</cfif>
<cfif isDefined('attributes.field_id') and len(attributes.field_id)>
	<cfset adres = "#adres#&field_id=#attributes.field_id#">
</cfif>
<cfif isDefined('attributes.field_name') and len(attributes.field_name)>
	<cfset adres = "#adres#&field_name=#attributes.field_name#">
</cfif>
 <cfif isDefined('attributes.work_startdate') and len(attributes.work_startdate)>
	<cfset adres = "#adres#&work_startdate=#attributes.work_startdate#">
</cfif>
<cfif isDefined('attributes.work_finishdate') and len(attributes.work_finishdate)>
	<cfset adres = "#adres#&work_finishdate=#attributes.work_finishdate#">
</cfif> 
<div class="row form-inline">
<label class="headbold" height="35"><cf_get_lang dictionary_id='30004.Fiziki Varlıklar'></label>
		<cfform name="search_asset" action="#request.self#?fuseaction=objects.popup_list_work_assets#adres#" method="post">
	<div class="form-group" id="item-keyword">
		<div class="input-group x-12">	
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
				<cfinput type="text" name="keyword" style="width:100px;" placeholder="#message#" value="#attributes.keyword#" maxlength="255">
				</div>
			</div>
	<div class="form-group" id="item-asset_catid">
        <div class="input-group x-22">				
				<select name="asset_catid" id="asset_catid">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_assetp_cats_reserve">
							<option value="#assetp_catid#" <cfif attributes.asset_catid eq assetp_catid>selected</cfif>>#assetp_cat#</option>
						</cfoutput>
					</select>
				</div>
			</div>	
		<div class="form-group x-3_5">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
		<div class="form-group">
				<cf_wrk_search_button>
				</div>
		</cfform>
	</div>
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
	<tr class="color-header" height="22">
		<td class="form-title"></td>
		<td class="form-title"><cf_get_lang dictionary_id='29452.Varlık'></td>
		<td class="form-title"><cf_get_lang dictionary_id='57486.Kategori'></td>
		<td class="form-title" width="130"><cf_get_lang dictionary_id='30031.Lokasyon'></td>
		<td class="form-title" width="130"><cf_get_lang dictionary_id='57544.Sorumlu'></td>
		<td class="form-title" width="22"></td>
	</tr>
  <cfif get_assetps_reserve.recordcount>
	<cfoutput query="get_assetps_reserve" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	<cfset attributes.assetp_id = assetp_id>
	<cfinclude template="../query/get_assetp_reserve.cfm">
	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td width="20" align="center" valign="middle">
			<cfif get_assetp_reserve.recordcount neq 1>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_assetp_reserve&assetp_id=#assetp_id#<cfif isDefined("attributes.work_id")>&work_id=#attributes.work_id#</cfif><cfif isDefined("attributes.class_id")>&class_id=#attributes.class_id#</cfif>&work_startdate=#attributes.work_startdate#&work_finishdate=#attributes.work_finishdate#','small');"><img border="0" src="/images/start.gif" title="<cf_get_lang dictionary_id='32932.Kaynak Rezerve Edin'> !"></a>
			<cfelse>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_assetp_reserve&assetp_id=#assetp_id#<cfif isDefined("attributes.work_id")>&work_id=#attributes.work_id#</cfif><cfif isDefined("attributes.class_id")>&class_id=#attributes.class_id#</cfif>&work_startdate=#attributes.work_startdate#&work_finishdate=#attributes.work_finishdate#','small');"><img border="0" src="/images/start_grey.gif" title="<cf_get_lang dictionary_id='32931.Kaynak Şu anda Müsait Değil'> !"></a>
			</cfif>
		</td>
		<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_assetp_info&assetp_id=#assetp_id#','project')" class="tableyazi">#assetp#</a> </td>
		<td>#assetp_cat#</td>

		<td>#zone_name# / #branch_name# / #department_head#</td>
		<td><cfif len(POSITION_CODE)>#get_emp_info(POSITION_CODE,1,0)#</cfif></td>
		<td>
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_asset_reserve_history&asset_id=#get_assetps_reserve.assetp_id#','list');"><img src="/images/table.gif" title="<cf_get_lang dictionary_id='32455.Rezervasyon Tarihçe'>" border></a>
		</td>
	</tr>
  </cfoutput>
  <cfelse>
	<tr class="color-row">
		<td height="20" colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
  	</tr>
  </cfif>
</table>

<cfif isDefined('attributes.asset_catid') and len(attributes.asset_catid)>
	<cfset adres = "#adres#&asset_catid=#attributes.asset_catid#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>

<cfif attributes.totalrecords gt attributes.maxrows>
	<table cellpadding="0" cellspacing="0" border="0" align="center" width="98%">
		<tr>
			<td><cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="objects.popup_list_pro_assets#adres#">
			</td>
			<!-- sil --><td height="30" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#get_assetps_reserve.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
function asset_care(id,assetp)
{
	<cfif isdefined("attributes.field_id")>
		window.opener.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		window.opener.<cfoutput>#field_name#</cfoutput>.value = assetp;
	</cfif>
	window.close();
}
</script>
