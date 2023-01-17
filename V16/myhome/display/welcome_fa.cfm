<cfinclude template="../query/my_sett.cfm">
<div id="aciklama"></div>
<cfset pageHead="FA #getLang('','Gündem',57413)#">
<cf_catalystHeader>
<div class="row margin-top-5">	
<cfinclude template="../query/get_summary.cfm">
    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
        <div class="dashboard-stat2 ">
            <div class="display">
                <div class="number">
                    <h4 class="font-green-sharp">
                    <cfset attributes.purchase_sales=1> 
					<cfinclude template="../includes/get_money_total.cfm"> 
                        <span data-counter="counterup"><cfoutput>#TLFormat(MONEY_SALES)#&nbsp;#session.ep.money#</cfoutput></span>
                        <small class="font-green-sharp"></small>
                    </h4>
                    <small><cf_get_lang dictionary_id='30815.Satışlar'></small>
                </div>
                <div class="icon">
                    <i class="icon-level-up"></i>
                </div>
            </div>
            <div class="progress-info">
                <div class="progress">
                    <span style="width: 100%;" class="progress-bar progress-bar-success green-sharp">
                    </span>
                </div>
                <div class="status">
                    <div class="status-title"><cf_get_lang dictionary_id='30772.Alışlar'></div>
                    <div class="status-number">
                    <cfset attributes.purchase_sales=0>
					<cfinclude template="../includes/get_money_total.cfm"> 
					<cfoutput>#TLFormat(MONEY_PURCHASE)#&nbsp;#session.ep.money#</cfoutput>
                    </div>
                </div>
            </div>
        </div>
    </div>   
    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
        <div class="dashboard-stat2 ">
            <div class="display">
                <div class="number">
                    <h4 class="font-red-haze">
                        <span data-counter="counterup">
							<cfset attributes.BA=32>
                            <cfset attributes.BA1=34>
                            <cfinclude template="../includes/get_acc_money.cfm"> 
                            <cfoutput>#TLFormat(get_acc_money.amount_money)#&nbsp;#session.ep.money#</cfoutput>
                        </span>
                        <small class="font-red-haze"></small>
                    </h4>
                    <small><cf_get_lang dictionary_id='58658.Ödemeler'></small>
                </div>
                <div class="icon">
                    <i class="icon-level-down"></i>
                </div>
            </div>
            <div class="progress-info">
                <div class="progress">
                    <span style="width: 100%;" class="progress-bar progress-bar-success red-haze">                        
                    </span>
                </div>
                <div class="status">
                    <div class="status-title"><cf_get_lang dictionary_id='30771.Tahsilatlar'></div>
                    <div class="status-number">
                    		
                     </div>
                </div>
            </div>
        </div>
    </div>  
    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
        <div class="dashboard-stat2 ">
            <div class="display">
                <div class="number">
                    <h4 class="font-blue-sharp">
                        <span data-counter="counterup" data-value="567">                    
                        	<cfoutput><cfif total_debt lt 0>#TLFormat(total_debt)#&nbsp;#session.ep.money#<cfelse>#TLFormat(total_debt)#&nbsp;#session.ep.money#</cfif></cfoutput>
                        </span>
                        <small></small>
                    </h4>
                    <small><cf_get_lang dictionary_id='57587.Borç'></small>
                </div>
            </div>
            <div class="progress-info">
                <div class="progress">
                    <span style="width: 100%;" class="progress-bar progress-bar-success blue-sharp">                        
                    </span>
                </div>
                <div class="status">
                    <div class="status-title"><cf_get_lang dictionary_id='57588.Alacak'></div>
                    <div class="status-number"><cfoutput>#TLFormat(total_claim)#&nbsp;#session.ep.money#</cfoutput></div>
                </div>
            </div>
        </div>
    </div>  
    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
        <cfscript>
            CreateCompenent = CreateObject("component","/../workdata/get_open_order_ships");
            get_open_order_ships = CreateCompenent.getCompenentFunction();
            get_open_order_ships_pur = CreateCompenent.getCompenentFunction(is_purchase:1);
            order_total = get_open_order_ships.order_total;
            order_total_purchase = get_open_order_ships_pur.order_total;
            ship_total = get_open_order_ships.ship_total;
            ship_total_purchase = -1*get_open_order_ships_pur.ship_total;
        </cfscript>
        <div class="dashboard-stat2 ">
            <div class="display">
                <div class="number">
                    <h4 class="font-purple-soft">
                        <span data-counter="counterup"><cfoutput>#TLFormat(order_total)#&nbsp;#session.ep.money#</cfoutput></span>
                    </h4>
                    <small><cf_get_lang dictionary_id='30842.Alınan Siparişler'></small>
                </div>
            </div>
            <div class="progress-info">
                <div class="progress">
                    <span style="width: 100%;" class="progress-bar progress-bar-success purple-soft">
                        <span class="sr-only"></span>
                    </span>
                </div>
                <div class="status">
                    <div class="status-title"><cf_get_lang dictionary_id='30851.Verilen Siparişler'></div>
                    <div class="status-number"><cfoutput>#TLFormat(order_total_purchase)#&nbsp;#session.ep.money#</cfoutput></div>
                </div>
            </div>
        </div>
    </div>   
</div>
<div  class="row myhomeBox">
    <div class="col col-6 col-xs-12 sortArea">
        <!--- Yoneticiye Ozet --->		
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='30765.Yöneticiye Özet'></cfsavecontent>
        <cf_catalyst-widget id="pay_claim" title="#message#"  closable="0" close_href="javascript:HomeBox.onBoxRemove('pay_claim',false,'pay_claim');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_dsp_summary_ajaxsummary"></cf_catalyst-widget>
        
        <!---Bugün Yapılacak Ödemeler --->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='30806.Bugün Yapılacak Ödemeler'></cfsavecontent>
        <cf_catalyst-widget id="pay" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('pay',false,'pay');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_pay_today_ajaxpaytoday"></cf_catalyst-widget>
        
        <!---Bugün yapılacak tahsilatlar --->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='30805.Bugün Yapılacak Tahsilatlar'></cfsavecontent>
        <cf_catalyst-widget id="now_claim" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('now_claim',false,'claim');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_rev_today_ajaxrevtoday"></cf_catalyst-widget>
    </div>
    <div class="col col-6 col-xs-12 sortArea">
        <!---Bugünkü alış faturaları --->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='30874.Bugünkü Alış Faturaları'></cfsavecontent>
        <cf_catalyst-widget id="purchase_today" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('purchase_today',false,'purchase_today');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_bill_ajaxlistbill"></cf_catalyst-widget>
        
        <!--- Bugünkü Satış Faturaları --->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='30786.Bugünkü Satış Faturaları'></cfsavecontent>
        <cf_catalyst-widget id="sell_today" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('sell_today',false,'sell_today');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_sale_bill_ajaxlistsale&maxrows=#attributes.maxrows#"></cf_catalyst-widget>
    
        <!--- Fatura --->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='30801.Kesilecek Faturalar'></cfsavecontent>
        <cf_catalyst-widget id="pre_invoice" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('pre_invoice',false,'pre_invoice');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_purchase_ajaxpurchase&xml_is_salaried=1"></cf_catalyst-widget>
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


				
			

								
				
		
		