<!--- 
ACTION_TYPE : Hangi sayfadan istek yapıldığını belirtiyor (CONSUMER Bireysel üye sayfasından,PARTNER Partner sayfasından) 
Bireysel uye sayfasından istek yapiliyorsa ekleme ekranında sadece Public Adresleri gozukur
Partner tarafından istek yapılıyorsa ekleme ekranında sadece Partner Adresleri

ACTION_ID : Bireysel üye icin CID, partner için PID

SITE_TYPE : Ekleme ekranında hem Public hem de Partner Adresleri gozukmesi icin 1 degeri gecilmelidir. 

Ornek Kullanimi:

Birseysel uye (Sadece Public Adresleri Gozukur ) <cf_get_workcube_domains action_type='CONSUMER' action_id="#attributes.cid#" >
Partner (Sadece Partner Adresleri Gozukur ) <cf_get_workcube_domains action_type='PARTNER' action_id="#attributes.pid#">
Public ve Partner Adresleri secebilmek icin <cf_get_workcube_domains action_type='CONSUMER' action_id='#attributes.cid#' site_type='1'>
 --->
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.action_id" default="">
<cfset action_url="&action_type=#attributes.action_type#&action_id=#attributes.action_id#"> 

<cfsavecontent variable="addLink">
	<cfif isDefined("cid") and Len(cid)><!--- Bireysel uye sayfasi --->
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_add_site_relation&consumer_id=#url.cid#<cfif isDefined("attributes.site_type")>&site_type=#attributes.site_type#</cfif></cfoutput>');
	<cfelseif isDefined("pid") and Len(pid)><!--- Partner uye sayfasi --->
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_add_site_relation&partner_id=#url.pid#&<cfif isDefined("attributes.site_type")>&site_type=#attributes.site_type#</cfif></cfoutput>');
	</cfif>
</cfsavecontent>

<!--- Site Erisim Haklari --->
<cf_box
	id="box_list_domains"
	title="#caller.getLang('main','Site Erişim Hakları',58442)#"
	closable="0"
	add_href="#addLink#"
	box_page="#request.self#?fuseaction=objects.emptypopup_list_domains#action_url#"
	unload_body="1">
</cf_box>
