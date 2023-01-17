<!--- Detail_Company.cfm sayfasindan ajax ile cagriliyor --->
<style>
	iframe body{background:white!important}
</style>
<cfsetting showdebugoutput="no">
<cfoutput>
<cfif isdefined("attributes.is_search")>
	<iframe scrolling="auto" width="99%" height="600px" frameborder="0" name="member_frame" id="member_frame" src="#request.self#?fuseaction=crm.popup_company_summary&cpid=#attributes.cpid#&iframe=1&is_company_upd=#is_company_upd#"></iframe>
<cfelseif isdefined("attributes.is_visit")>
    <iframe scrolling="auto" width="99%" height="600px" frameborder="0" name="member_frame" id="member_frame" src="#request.self#?fuseaction=crm.popup_list_visit_info&cpid=#attributes.cpid#&iframe=1"></iframe>
<cfelseif isdefined("attributes.is_activity")>
	<iframe scrolling="auto" width="99%" height="600px" frameborder="0" name="member_frame" id="member_frame" src="#request.self#?fuseaction=crm.popup_company_act_info&cpid=#attributes.cpid#&iframe=1"></iframe>
<cfelseif isdefined("attributes.is_branch")>
	<iframe scrolling="auto" width="99%" height="600px" frameborder="0" name="member_frame" id="member_frame" src="#request.self#?fuseaction=crm.popup_upd_consumer_branch&cpid=#attributes.cpid#&iframe=1"></iframe>
<cfelseif isdefined("attributes.is_open_popup")>
	<iframe scrolling="auto" width="99%" height="600px" frameborder="0" name="member_frame" id="member_frame" src="#request.self#?fuseaction=crm.popup_upd_consumer_branch&cpid=#attributes.cpid#&related_id=#attributes.related_id#&is_open_popup=#attributes.is_open_popup#&iframe=1"></iframe>
<cfelseif isdefined("attributes.is_open_request")>
	<iframe scrolling="auto" width="99%" height="600px" frameborder="0" name="member_frame" id="member_frame" src="#request.self#?fuseaction=crm.popup_list_company_requests&cpid=#attributes.cpid#&action_id=#attributes.action_id#&is_open_request=#attributes.is_open_request#&iframe=1"></iframe>
<cfelseif isdefined("attributes.is_open_securefund")>
	<iframe scrolling="auto" width="99%" height="600px" frameborder="0" name="member_frame" id="member_frame" src="#request.self#?fuseaction=crm.popup_list_securefund&cpid=#attributes.cpid#&action_id=#attributes.action_id#&is_open_securefund=#attributes.is_open_securefund#&iframe=1"></iframe>
<cfelse>
	<iframe scrolling="auto" width="99%" height="600px" frameborder="0" name="member_frame" id="member_frame" src="#request.self#?fuseaction=crm.popup_general_info&cpid=#attributes.cpid#&iframe=1"></iframe>
</cfif>
</cfoutput>
<script>
	$('iframe').load( function() {
		$('iframe').contents().find("body").css("background","#fff");
		$('iframe').contents().find("section").css("box-shadow","none");
		$('iframe').contents().find("div").css("box-shadow","none");
	});
</script>
