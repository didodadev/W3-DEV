<!--- 
Description :   
    Document Template 
Parameters :
	action_type     required:Analizin nereden kaydedilecegi MEMBER(Uye Detayı),OPPORTUNITY(Fırsat),OFFER(Teklif),PROJECT(Proje) istenilirse yeni degerler buraya eklenmeli
	action_type_id          :Analizin uye detayi disindaki kullanildigi yerlerde id ifadesi icin kullanilmali. Ornegin Fırsat icin OPPORTUNITY_ID degeri
	company_id  not required:kurumsal icin yapilan analizlerdeki company_id degeri
	partner_id  not required:kurumsal icin yapilan analizlerdeki partner_id degeri
	consumer_id not required:bireysel üye icin yapılan analizlerdeki consumer_id degeri
	rival_id not required:rakip icin yapılan analizlerdeki rival_id degeri
	is_analysis_link degeri ise ilgili analiz detay linkinin gorulmeyecegi zamanlarda gonderilir. Defaultu 1 dir. Sadece proje detayında xmlden gelen deger gonderilir.
Syntax :
	<cf_get_member_analysis action_type='<action_type>' company_id='<company_id>' partner_id='<partner_id>'>
	<cf_get_member_analysis action_type='<action_type>' consumer_id='<consumer_id>'>
Sample :
	<cf_get_member_analysis action_type='MEMBER' company_id='35' partner_id='42'>
	<cf_get_member_analysis action_type='OPPORTUNITY' action_type_id='#attributes.opp_id#' company_id='#get_opportunity.company_id#' partner_id='#get_opportunity.partner_id#' consumer_id='#get_opportunity.consumer_id#'>
	<cf_get_member_analysis action_type='OFFER' action_type_id='#attributes.offer_id#' company_id='#get_offer.company_id#' partner_id='#get_offer.partner_id#' consumer_id='#get_offer.consumer_id#'>
	<cf_get_member_analysis action_type='PROJECT' action_type_id='#attributes.project_id#' company_id='#project_detail.company_id#' partner_id='#project_detail.partner_id#' consumer_id='#project_detail.consumer_id#'>
	created 20081229 BK
 --->

<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.action_type_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.rival_id" default="">
<cfparam name="attributes.is_analysis_link" default="1">
<cfparam name="attributes.result_status" default="1">
<cfparam name="attributes.fuseaction" default="">
<cfparam name="attributes.closable" default="0">
<cfset url_address ="&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#&consumer_id=#attributes.consumer_id#&rival_id=#attributes.rival_id#&is_analysis_link=#attributes.is_analysis_link#">
<!---  box_page="#request.self#?fuseaction=objects.emptypopup_list_analysis_relation#url_address#&result_status=#attributes.result_status#" --->
<cf_box id="get_analysis_list" popup_box="1" closable="#attributes.closable#" title="#caller.getLang('main',1387)#" close_href="javascript:gizle_('ui-draggable-box')">
	<cf_box_search more="0">				
		<div class="form-group">
            <cfoutput>
                <select name="result_status" id="result_status">
                    <option value="">#caller.getLang('main',296)#</option> <!--- Tumu --->
                    <option value="1" <cfif isdefined("attributes.result_status") and attributes.result_status eq 1>selected</cfif>>#caller.getLang('main',81)#</option> <!--- Aktif --->
                    <option value="0" <cfif isdefined("attributes.result_status") and attributes.result_status eq 0>selected</cfif>>#caller.getLang('main',82)#</option> <!--- Pasif --->
                </select>
			</cfoutput>
		</div>
		<div class="form-group">
			<cf_wrk_search_button button_type="4" search_function="list_analysis_id_yukle()">
		</div>
    </cf_box_search>
	<div id="body_analyses"></div>
</cf_box>
<script type="text/javascript">
	function gizle_(){
		$('.ui-draggable-box').hide();
	}
	function list_analysis_id_yukle()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_list_analysis_relation#url_address#</cfoutput>&result_status='+document.getElementById('result_status').value,'body_analyses',1);
	}
</script>
