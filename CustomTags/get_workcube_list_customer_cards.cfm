<!--- Kart Numaralari; Bireysel Uye ve Kurumsal Uye Calisani Ekranlarinda Kullanilmaktadir--->
<!--- modified Emin Yasarturk 20130729 (Ajax yapisina cevrildi) --->
<cfset attributes.style=1>
<!--- Member: Kart No --->
<cfset url_str = ''>
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
    <cfset url_str =url_str&'&action_id=#attributes.action_id#'>
</cfif>
<cfif isdefined("attributes.action_type") and len(attributes.action_type)>
    <cfset url_str =url_str&'&action_type=#attributes.action_type#'>
</cfif>
<cf_box id="get_card_no" title="#caller.getLang('','Sadakat Kart-Cüzdan',62535)#" collapsed="#iif(attributes.style,1,0)#" closable="0" add_href_size="small" add_href="#request.self#?fuseaction=member.popup_detail_customer_cards&action_id=#attributes.action_id#&action_type_id=#attributes.action_type#" box_page="#request.self#?fuseaction=objects.ajax_list_customer_card&#url_str#"></cf_box>

