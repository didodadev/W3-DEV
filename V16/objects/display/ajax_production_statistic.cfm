<cfsetting showdebugoutput="no">
<cfquery name="GET_STATIONS_PRODUCT" datasource="#DSN3#">
	SELECT 
		WS.STATION_NAME,
		WSP.*
	FROM 
		WORKSTATIONS_PRODUCTS WSP ,
		WORKSTATIONS WS
	WHERE
	WS.STATION_ID =WSP.WS_ID AND
	WSP.STOCK_ID =   #attributes.sid#
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" class="color-header">
	<tr height="25" class="color-list">
		<td class="txtboldblue" colspan="5"><cf_get_lang dictionary_id='60015.Ürünün Üretilebileceği İstasyonlar'></td>
	</tr>
	<tr height="25" class="color-list">
		<td width="1%" class="txtboldblue"><cf_get_lang dictionary_id='57487.No'></td>
		<td class="txtboldblue" width="100"><cf_get_lang dictionary_id='58834.İstasyon'></td>
		<td class="txtboldblue" width="200"><cf_get_lang dictionary_id='60016.Siparişin Üretim Zamanı'></td>
	</tr>
<cfif GET_STATIONS_PRODUCT.recordcount>
	<cfoutput query="GET_STATIONS_PRODUCT">
	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td width="1%">#currentrow#</td>
		<td width="100">#STATION_NAME#</td>
		<cfset tahmini_uretim_zamanı = PRODUCTION_TIME*attributes.amount>
		<cfif tahmini_uretim_zamanı gt 59>
			<cfset tahmini_uretim_zamanı_saat = Int(tahmini_uretim_zamanı/60)>	
			<cfset tahmini_uretim_zamanı_dakika = tahmini_uretim_zamanı mod 60>
		</cfif>
		<td width="200"  style="text-align:right;">
			<cfif isdefined('tahmini_uretim_zamanı_saat')>
				<cfif tahmini_uretim_zamanı_saat gt 23>
					<cfset tahmini_uretim_zamanı_gun = Int(tahmini_uretim_zamanı_saat/24)>
					<cfset tahmini_uretim_zamanı_saat = tahmini_uretim_zamanı_saat mod 24>
				</cfif>
				<cfif isdefined('tahmini_uretim_zamanı_gun')>
					#tahmini_uretim_zamanı_gun# Gün
				</cfif>
				#tahmini_uretim_zamanı_saat# Saat
				#tahmini_uretim_zamanı_dakika# dk
			<cfelse>
				#tahmini_uretim_zamanı# dk
			</cfif>
		</td>
	</tr>
	</cfoutput>
<cfelse>
	<tr class="color-row" height="22">
		<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
	</tr>
</cfif>
</table>

