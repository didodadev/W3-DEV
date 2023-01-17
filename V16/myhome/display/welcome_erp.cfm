<cf_catalystheader>
<cfinclude template="../query/my_sett.cfm">

<div  class="row myhomeBox">
	<div class="col col-6 col-xs-12 sortArea">
		<!---Yeniden sipariş noktasına gelen ürünler--->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30792.Yeniden Sipariş Noktasına Gelen Ürünler'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="come_again_sip" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('come_again_sip',false,'come_again_sip');" collapsed="0"  collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_less_product_ajaxproduct"></cf_catalyst-widget>
		
		<!---Satış Siparişleri--->	
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58207.Satış Siparişleri'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="orders_come" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('orders_come',false,'orders_come');" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_order_ajaxorder"></cf_catalyst-widget>
		
		<!---Satın Alma Siparişleri--->
		  <cfsavecontent variable="message"><cf_get_lang dictionary_id ='30790.Satınalma  Siparişleri'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="orders_give" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('orders_give',false,'orders_give');" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_orderp_ajaxorderp"></cf_catalyst-widget>
		
		<!--- Süresi Dolan Anlaşmalar --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31089.Süresi Dolan Anlaşmalar'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="old_contracts" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('old_contracts',false,'old_contracts');" collapsed="0"  collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_old_ajaxcontracts"></cf_catalyst-widget>
		
		<!---İç Talepler--->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30782.İç Talepler'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="internaldemand" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('internaldemand',false,'internaldemand');" collapsable="0" box_page="#request.self#?fuseaction=myhome.emptypopup_list_internaldemand_ajaxdemand"></cf_catalyst-widget>
		
		<!---En çok Satan Ürünler--->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30788.En Çok Satan Ürünler'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="most_sell_stock" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('most_sell_stock',false,'most_sell_stock');" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_top_products_ajaxtopproducts"></cf_catalyst-widget>
	</div>
<div class="col col-6 col-xs-12 sortArea">
		<!---Fazla Stoklar---->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30794.Fazla Stoklar'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="more_stocks" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('more_stocks',false,'more_stocks_id');" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_more_product_ajaxmoreproduct"></cf_catalyst-widget>
		
		<!--- Sevk Emirleri --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30795.Sevk Emirleri'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="send_order" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('send_order',false,'send_order');" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_send_order_ajaxsendorder"></cf_catalyst-widget>
		
		<!--- Alınan Teklifler --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30791.Alınan Teklifler'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="offer_taken" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('offer_taken',false,'offer_taken');" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_offers_take_ajaxofferstake"></cf_catalyst-widget>
		
		<!---Yeni Stoklar--->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31498.Yeni Stoklar'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="new_stocks" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('new_stocks',false,'new_stocks');" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_new_stocks_ajaxstocks"></cf_catalyst-widget>
	
		<!---Bugünkü alış faturaları --->
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30874.Bugünkü Alış Faturaları'></cfsavecontent>
		<cf_catalyst-widget dragDrop="1" id="purchase_today" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('purchase_today',false,'purchase_today');" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_bill_ajaxlistbill"></cf_catalyst-widget>

	</div>
</div>>

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


				
			

								
				
		
		