<!--- 
Description :   
    Document Template 
Parameters :
	action_type     required:Analizin nereden kaydedilecegi MEMBER(Uye Detayı),OPPORTUNITY(Fırsat),OFFER(Teklif),PROJECT(Proje) istenilirse yeni degerler buraya eklenmeli
	action_type_id          :Analizin uye detayi disindaki kullanildigi yerlerde id ifadesi icin kullanilmali. Ornegin Fırsat icin OPPORTUNITY_ID degeri
	company_id  not required:kurumsal icin yapilan analizlerdeki company_id degeri
	partner_id  not required:kurumsal icin yapilan analizlerdeki partner_id degeri
	consumer_id not required:bireysel üye icin yapılan analizlerdeki consumer_id degeri
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
<cfsetting showdebugoutput="no">
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.action_type_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.is_analysis_link" default="1">
<cfset url_address ="&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#&consumer_id=#attributes.consumer_id#&is_analysis_link=#attributes.is_analysis_link#">
<table cellpadding="2" cellspacing="1" border="0" width="98%" class="color-border">
	<tr class="color-header" height="20">
		<td class="form-title">
			<img src="/images/listele_down.gif"  border="0" align="absmiddle" id="listele_analysis_down_img" style="display:none;cursor:pointer;" onclick="gizle_goster(list_analysis_id);gizle_goster_img(listele_analysis_down_img,listele_analysis_img,analysis_list);list_analysis_id_yukle();">
			<img src="/images/listele.gif" border="0" align="absmiddle" id="listele_analysis_img" style="display:;cursor:pointer;" onclick="gizle_goster(list_analysis_id);gizle_goster_img(listele_analysis_down_img,listele_analysis_img,analysis_list);list_analysis_id_yukle();">
			<a style="cursor:pointer;" onclick="gizle_goster(list_analysis_id);gizle_goster_img('listele_analysis_down_img','listele_analysis_img','analysis_list');list_analysis_id_yukle();">&nbsp;&nbsp;<cfoutput>#caller.getLang('main',1387)#</cfoutput></a> <!--- Analizler --->
		</td>
	</tr>
	<tr id="list_analysis_id" class="color-row" style="display:none;">
		<td colspan="2"><div id="analysis_list"></div></td>
	</tr>
</table>
<script type="text/javascript">
function list_analysis_id_yukle()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_list_survey_relation#url_address#</cfoutput>','analysis_list',1);
}
</script>
