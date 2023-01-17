<cfinclude template="../query/my_sett.cfm">
<cf_catalystHeader>
<div id="aciklama"></div>
<div  class="row myhomeBox">
	<div class="col col-7 col-md-7 col-xs-12 sortArea">
		<!--- Kurumsal Üye Başvuruları --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30798.Kurumsal Üye Başvuruları'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="pot_partner" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('pot_partner',false,'pot_partner');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_company_app_ajaxcompany"></cf_catalyst-widget>
		<!--- Bireysel Üye Başvuruları --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30797.Bireysel Üye Başvuruları'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="pot_cons" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('pot_cons',false,'pot_cons');"  collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_consumer_app_ajaxconsumer"></cf_catalyst-widget>
		<!--- Kampanya --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30800.Gündemdeki Kampanyalar'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="campaign_now" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('campaign_now',false,'campaign_now');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_campaign_ajaxcampaign"></cf_catalyst-widget>
		<!--- Süresi Dolan Anlaşmalar --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31089.Süresi Dolan Anlaşmalar'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="old_contracts" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('old_contracts',false,'old_contracts');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_old_ajaxcontracts"></cf_catalyst-widget>
		
		<!--- BEGIN Servis Başvuruları --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30039.Servis Başvuruları'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="service_head" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('service_head',false,'service_head');"collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_service_ajaxlistservice"></cf_catalyst-widget>
		
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58468.Call Center Başvuruları'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="call_center_application" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('call_center_application',false,'call_center_application');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_callcenter_ajax"></cf_catalyst-widget>
		
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58729.Call Center Etkileşimler'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="call_center_interaction" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('call_center_interaction',false,'call_center_interaction');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_etkilesim_ajax"></cf_catalyst-widget>
		<!--- END Servis Başvuruları --->
		
		<!---Fırsatlar--->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='58694.Fırsatlar'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="promo_head" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('promo_head',false,'promo_head');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_opportunities_ajaxopportunities"></cf_catalyst-widget>
	
		<!---Verilecek Teklifler--->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30789.Verilecek Teklifler'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="offer_to_give" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('offer_to_give',false,'offer_to_give');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_offers_to_give_ajaxgive"></cf_catalyst-widget>

		<!---Sosyal medya--->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='29529.sosyal medya'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="social_media" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('social_media',false,'social_media');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_ajax_social_media"></cf_catalyst-widget>		
	</div>
	<div class="col col-5 col-md-5 col-xs-12 sortArea">				
		<!--- KURUMSAL ÜYE PROFILI  --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='30154.Kurumsal Üye Profili'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="company_member_graph" title="#message#" closable="0" collapsable="1" box_page="#request.self#?fuseaction=member.popup_comp_graph"></cf_catalyst-widget>
		
		<!--- Bireysel ÜYE PROFILI  --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='30159.Bireysel Üye Profili'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="member_graph" title="#message#" closable="0" collapsable="1" box_page="#request.self#?fuseaction=member.popup_cons_graph_ajax"></cf_catalyst-widget>
		
		<!--- Etkileşim  --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='32381.Etkileşim'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="call_center_graph" title="#message#" closable="0" collapsable="1" box_page="#request.self#?fuseaction=report.popup_help_summary"></cf_catalyst-widget>

		<!--- Ziyaretler  --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='57970.Ziyaretler'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="event_summary" title="#message#" closable="0" collapsable="1" box_page="#request.self#?fuseaction=report.popup_event_summary"></cf_catalyst-widget>
	</div>
</div>

<script type="text/javascript">

	$(function() {	
		
		$(".sortArea").sortable({
			connectWith		: '.sortArea',
			items			: '.col',
			handle			: '[id*="handle_"],.portHead',
			cursor			: 'move',
			opacity			: '0.6',
			placeholder		: 'col col-12 elementSortArea',
			tolerance		: 'pointer',
			revert			: 300,
			start: function(e, ui ){
				ui.placeholder.height(ui.helper.outerHeight());
				ui.item.css({'max-width':ui.placeholder.width()});				
			},
			stop: function(e, ui ) {					
				ui.item.css({'max-width':''});
			}//stop
		});	
	});//ready
	
</script>


				
			

								
				
		
		