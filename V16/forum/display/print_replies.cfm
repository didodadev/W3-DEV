<cfsetting showdebugoutput="no">

<cfset adres = "objects.emptypopup_print_files_inner">
<cfif isdefined("attributes.iid") and len(attributes.iid)>
	<cfset adres = "#adres#&iid=#attributes.iid#">
</cfif>

<!--- Silme !!! Tatmetal icin eklendi. Bizdede gerekirse ikinci degiskenler icin kullanilabilir. BK 20081218 --->
<cfif isdefined("attributes.iiid") and len(attributes.iiid)>
	<cfset adres = "#adres#&iiid=#attributes.iiid#">
</cfif>
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfset adres = "#adres#&action_id=#attributes.action_id#">
</cfif>
<cfif isdefined("attributes.action_type") and len(attributes.action_type)>
	<cfset adres = "#adres#&action_type=#attributes.action_type#">
</cfif>
<cfif isdefined("attributes.action_table") and len(attributes.action_table)>
	<cfset adres = "#adres#&action_table=#attributes.action_table#">
</cfif>
<cfif isdefined("attributes.action_row_id") and len(attributes.action_row_id)>
	<cfset adres = "#adres#&action_row_id=#attributes.action_row_id#">
</cfif>
<cfif isdefined("attributes.date1") and len(attributes.date1)>
	<cfset adres = "#adres#&date1=#attributes.date1#">
</cfif>
<cfif isdefined("attributes.date2") and len(attributes.date2)>
	<cfset adres = "#adres#&date2=#attributes.date2#">
</cfif>
<cfif isdefined("attributes.action_date1") and len(attributes.action_date1)>
	<cfset adres = "#adres#&action_date1=#attributes.action_date1#">
</cfif>
<cfif isdefined("attributes.action_date2") and len(attributes.action_date2)>
	<cfset adres = "#adres#&action_date2=#attributes.action_date2#">
</cfif>
<cfif isdefined("attributes.money_info") and len(attributes.money_info)>
	<cfset adres = "#adres#&money_info=#attributes.money_info#">
</cfif>
<cfif isdefined("attributes.money_type_info") and len(attributes.money_type_info)>
	<cfset adres = "#adres#&money_type_info=#attributes.money_type_info#">
</cfif>
<cfif isdefined("attributes.is_pay_cheques") and len(attributes.is_pay_cheques)>
	<cfset adres = "#adres#&is_pay_cheques=#attributes.is_pay_cheques#">
</cfif>
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.print_type") and len(attributes.print_type)>
	<cfset adres = "#adres#&print_type=#attributes.print_type#">
</cfif>
<cfif isdefined("attributes.row_consumer") and len(attributes.row_consumer)>
	<cfset adres = "#adres#&row_consumer=#attributes.row_consumer#">
</cfif>
<cfif isdefined("attributes.row_company") and len(attributes.row_company)>
	<cfset adres = "#adres#&row_company=#attributes.row_company#">
</cfif>
<cfif isdefined("attributes.checked_value") and len(attributes.checked_value)><!--- Banka talimatları listesindeki toplu printde kullanılıyor silmeyiniz --->
	<cfset adres = "#adres#&checked_value=#attributes.checked_value#">
</cfif>
<cfparam name="attributes.form_kontrol" default="">

<cfsavecontent variable="right">
<cfform name="page_print" method="post" action="#request.self#?fuseaction=objects.popupflush_print_files&is_special=1">
    <a href="javascript://" onclick="iframe_yazdir();"><img src="/images/print.gif" border="0"></a>
    <cfif isdefined("attributes.print_type") and len(attributes.print_type) and (attributes.print_type eq 321 or attributes.print_type eq 320)><!--- Eğitim yönetimi modülünden çağrılmışsa mail adreslerini formdan alıyor --->
        <cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0' extra_parameters="mail_list.mails">
    <cfelseif isdefined("attributes.print_type") and len(attributes.print_type) and isdefined("attributes.action_id") and len(attributes.action_id)>
        <cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0' print_type="#attributes.print_type#"  action_id="#attributes.action_id#" simple="1">
    <cfelse>
        <cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0' simple="1">
    </cfif>
</cfform>
</cfsavecontent>

<cf_popup_box right_images="#right#">
	<iframe scrolling="auto" name="auto_print_page" id="auto_print_page" width="100%" height="450" frameborder="0" src="<cfoutput>#request.self#?fuseaction=forum.emptypopup_print_content&topicid=#attributes.topicid#</cfoutput>" onload="autoResize('auto_print_page');"></iframe>
</cf_popup_box>


<script language="javascript">
	function iframe_yazdir()
	{
		parent.auto_print_page.focus(); 
		parent.auto_print_page.print();
	}
	$(window).resize(function()
		{
		autoResize('auto_print_page');
		});
	function autoResize(id){
		if(document.body.scrollHeight < 540)
			document.getElementById(id).height = "420px";
		else
			document.getElementById(id).height= document.body.scrollHeight - 80 + "px";
	}
</script>
