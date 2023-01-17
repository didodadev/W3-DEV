<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_fuel_password_search.cfm">
<cfif isdefined("attributes.is_submitted")>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_fuel_password_search.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<table width="100%" class="color-header">
	<tr>
		<td style="text-align:right;">
			<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
		</td>
	</tr>
</table>
<table class="detail_basket_list">
    <thead>
        <tr>
            <th width="35"><cf_get_lang_main no='75.No'></th>
            <th><cf_get_lang_main no='2234.Lokasyon'></th>	
            <th><cf_get_lang no='470.Akaryakıt Şirketi'></th>
            <th><cf_get_lang_main no='70.Asama'></th>
            <th width="65"><cf_get_lang_main no='243.Baş Tarihi'></th>
            <th width="65"><cf_get_lang_main no='288.Bitiş Tarihi'></th>
            <th width="15"></th>
        </tr>    
    </thead>
    <tbody>
        <cfif isdefined("attributes.is_submitted")>
            <cfif get_fuel_password_search.recordcount>
                <cfoutput query="get_fuel_password_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#zone_name# / #branch_name#</td>
                        <td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium','popup_com_det');">#fullname#</a></td>
                        <td><cfif status eq 1><cf_get_lang_main no='81.Aktif'><cfelse><cf_get_lang_main no='82.Pasif'></cfif></td>
                        <td>#dateformat(start_date,dateformat_style)#</td>
                        <td>#dateformat(finish_date,dateformat_style)#</td>
                        <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_fuel_password_detail&password_id=#password_id#','medium','popup_upd_fuel_password_detail');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
            <cfelse>
                <tr>
                    <td colspan="7"><cf_get_lang_main no='289.Filtre Ediniz'>!</td>
                </tr>
        </cfif>
    </tbody>
</table>
<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
    <cfset url_str = "">
    <cfif isdefined("attributes.branch_id")>
      <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
    </cfif>
    <cfif isdefined("attributes.branch")>
      <cfset url_str = "#url_str#&branch=#attributes.branch#">
    </cfif>
    <cfif isdefined("attributes.is_submitted")>
      <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
    </cfif>
    <cfif isdefined("attributes.company_name")>
      <cfset url_str = "#url_str#&company_name=#attributes.company_name#">
    </cfif>
    <cfif isdefined("attributes.company_id")>
      <cfset url_str = "#url_str#&company_id=#attributes.company_id#">
    </cfif>
    <cfif isdefined("attributes.status")>
      <cfset url_str = "#url_str#&status=#attributes.status#">
    </cfif>
    <cfif isdefined("attributes.start_date")>
      <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date)#">
    </cfif>
    <cfif isdefined("attributes.finish_date")>
      <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date)#">
    </cfif>	
	<!-- sil -->
	<table width="99%" align="center" cellpadding="0" cellspacing="0" height="35">
		<tr>
			<td><cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="assetcare.popup_list_fuel_password_search#url_str#"></td>
			<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'> : #attributes.totalrecords#&nbsp;-&nbsp; <cf_get_lang_main no='169.Sayfa'> :#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
	<!-- sil -->
</cfif>
