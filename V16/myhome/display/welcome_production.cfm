<cfinclude template="../query/my_sett.cfm">
<cf_catalystHeader>
<div class="row">
	<div class="col col-12">
		<div  class="row myhomeBox">
			<div class="col col-6 col-xs-12 sortArea">
				<!---Yeniden sipariş noktasına gelen ürünler--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30792.Yeniden Sipariş Noktasına Gelen Ürünler'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="come_again_sip" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('come_again_sip',false,'come_again_sip');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_less_product_ajaxproduct"></cf_catalyst-widget>
				
				<!---Beklenen Yedek Parçalar--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31500.Beklenen Yedek Parçalar'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="spare_part" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('spare_part',false,'spare_part');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_service_operation_ajaxservice"></cf_catalyst-widget>
			</div>
			<div class="col col-6 col-xs-12 sortArea">
				<!---İç Talepler--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30782.İç Talepler'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="internaldemand" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('internaldemand',false,'internaldemand');" box_page="#request.self#?fuseaction=myhome.emptypopup_list_internaldemand_ajaxdemand"></cf_catalyst-widget>

				<!---Yeni Stoklar--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31498.Yeni Stoklar'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="new_stocks" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('new_stocks',false,'new_stocks');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_new_stocks_ajaxstocks"></cf_catalyst-widget>

				<!--- Üretim Emirleri --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30804.Üretim Emirleri'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="product_orders" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('product_orders',false,'product_orders');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_prod_ajaxlist_prod"></cf_catalyst-widget>
			</div>
		</div>
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


				
			

								
				
		
		