<div id="aciklama"></div>
<cfprocessingdirective suppresswhitespace="Yes">
<script type="text/javascript" src="/JS/widget/domdrag.js"></script>
<script type="text/javascript" src="/JS/widget/homebox.js"></script>
<!--- E.A storeproca cevrildi 20130109 6 aya silinsin --->
<cfset attributes.position_id= session.ep.position_code>
<cfinclude template="../../hr/query/get_position_detail.cfm">
<!--- Menu Pozisyonları --->
<cfstoredproc procedure="GET_MY_SETTINGS_POSITIONS" datasource="#DSN#">
	<cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	<cfprocresult name="MENU_POS">
</cfstoredproc>
<!---Column Tanımlama--->
<cfset lastColumn = 0>

<cfset columnName = ArrayNew(1)>
<cfset ArrayAppend(columnName, "homeColumnLeft")>
<cfset ArrayAppend(columnName, "homeColumnCenter")>
<cfset ArrayAppend(columnName, "homeColumnRight")>

<cfset columnWidth = ArrayNew(1)>  
<cfset ArrayAppend(columnWidth, "col col-3 col-md-6 col-sm-12 homeSortArea")>
<cfset ArrayAppend(columnWidth, "col col-6 col-md-6 col-sm-12 homeSortArea")>
<cfset ArrayAppend(columnWidth, "col col-3 col-md-6 col-sm-12 homeSortArea")>
<div  class="row myhomeBox">
	<cfloop query="menu_pos">
		<cfif (menu_pos.column_index neq lastColumn && lastColumn neq 0)>
		 	</div>		 
		</cfif>		
		<cfif menu_pos.column_index neq lastColumn> 		
         <div class="<cfoutput>#columnWidth[menu_pos.column_index]#</cfoutput>" id="<cfoutput>#columnName[menu_pos.column_index]#</cfoutput>">		 	
		 </cfif>	
		 <cfif isdefined('get_position_detail.time_cost_control') and get_position_detail.time_cost_control eq 1>
			<cfif menu_pos.panel_name is 'homebox_pdks' and my_sett.hr_pdks eq 1>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='32077.Çalışma Saatlerim'>- <cf_get_lang dictionary_id='58009.PDKS'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="mypdks" title="#message#"  unload_body="#menu_pos.is_close#" closable="1" close_href="javascript:HomeBox.onBoxRemove('mypdks',false,'mypdks');" collapsed="1" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_mypdks_info"></cf_catalyst-widget>
			</cfif>
		</cfif>
		<cfif menu_pos.panel_name is 'homebox_pay_claim' and fusebox.use_period and get_module_user(36) and (my_sett.pay_claim eq 1)>
			<!--- Yoneticiye Ozet --->		
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='30765.Yöneticiye Özet'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="pay_claim" title="#message#"  unload_body="#menu_pos.is_close#" closable="1" close_href="javascript:HomeBox.onBoxRemove('pay_claim',false,'pay_claim');" collapsed="1" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_dsp_summary_ajaxsummary"></cf_catalyst-widget>
		</cfif>
		
		<cfif menu_pos.panel_name is 'homebox_video' and my_sett.is_video eq 1>
			<!--- Video ---> 
			<cfsavecontent variable="message_video"><cf_get_lang dictionary_id='58153.TV'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="video" title="#message_video#" unload_body="#menu_pos.is_close#" closable="1" close_href="javascript:HomeBox.onBoxRemove('video',false,'is_video');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_video_asset_ajaxvideo"></cf_catalyst-widget>
		</cfif>
		
		<cfif menu_pos.panel_name is 'homebox_announcement' and my_sett.announcement eq 1>
			<!--- Duyurular --->
			<cfsavecontent variable="duyurumessage"><cf_get_lang dictionary_id='58118.DUYURULAR'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="announcement" title="#duyurumessage#" unload_body="#menu_pos.is_close#" scroll="3" closable="1" close_href="javascript:HomeBox.onBoxRemove('announcement',false,'announcement');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_anoncement_ajaxanoncement"></cf_catalyst-widget>
		</cfif>

		<cfif menu_pos.panel_name is 'homebox_notes' and my_sett.notes eq 1>
			<!---Notlar --->
			<cfsavecontent variable="notesmessage"><cf_get_lang dictionary_id='57422.notlar'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="notes" title="#notesmessage#" unload_body="#menu_pos.is_close#" add_href_3="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_nott','','ui-draggable-box-small')" box_page="#request.self#?fuseaction=myhome.emptypopup_list_visited_notes_ajaxnotes" refresh="1" closable="1" collapsable="1" close_href="javascript:HomeBox.onBoxRemove('notes',false,'notes');" info_href="openBoxDraggable('#request.self#?fuseaction=objects.popup_all_visiting','','ui-draggable-box-small')"></cf_catalyst-widget>
		</cfif>	
        
<!---		<cfif menu_pos.panel_name is 'homebox_notes' and my_sett.notes eq 1>
			<!---Notlar --->
			<cfsavecontent variable="notesmessage"><cf_get_lang_main no='10.notlar'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="notes" title="#notesmessage#" unload_body="#menu_pos.is_close#" closable="1" close_href="javascript:HomeBox.onBoxRemove('notes',false,'notes');" info_href="#request.self#?fuseaction=objects.popup_all_visiting" collapsable="1" add_href="#request.self#?fuseaction=objects.popup_add_nott" box_page="#request.self#?fuseaction=myhome.emptypopup_list_visited_notes_ajaxnotes"></cf_catalyst-widget>
		</cfif>	--->		
			
		<!---Anketler --->
		<cfif menu_pos.panel_name is 'homebox_poll_now' and my_sett.poll_now eq 1>
			<script src="JS/Chart.min.js"></script>
			<cfsavecontent variable="pollsmessage"><cf_get_lang dictionary_id='58662.Anket'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="poll_now" title="#pollsmessage#" unload_body="#menu_pos.is_close#" closable="1" close_href="javascript:HomeBox.onBoxRemove('poll_now',false,'poll_now');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_surveys"></cf_catalyst-widget>
		</cfif>

		<cfif my_sett.recordcount>		
			<cfif menu_pos.panel_name is 'homebox_main_news' and my_sett.main_news eq 1>
				<!---Workcube Taze içerik --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='30779.WorkCube Taze İçerik'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="main_news" title="#message#" unload_body="#menu_pos.is_close#" closable="1" close_href="javascript:HomeBox.onBoxRemove('main_news',false,'main_news');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_main_news_ajaxnews"></cf_catalyst-widget>
			</cfif>          
			<cfif menu_pos.panel_name is 'homebox_employee_profile' and get_module_user(3) and my_sett.employee_profile eq 1>
				<!---Çalışan Profili(HR)--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='29499.Çalışan Profili'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="employee_profile" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('employee_profile',false,'employee_profile');" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_employee_profile_ajaxempprofile"></cf_catalyst-widget>
			</cfif>
			 <cfif menu_pos.panel_name is 'homebox_branch_profile' and my_sett.branch_profile eq 1 and get_module_user(3)>
				<!---Şube Profili(HR)--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='29505.Şube Profili'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="branch_profile" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('branch_profile',false,'branch_profile');" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_branch_profile_ajaxbranchprofile" ></cf_catalyst-widget>
			</cfif> 
			<cfif menu_pos.panel_name is 'homebox_myworks' and  my_sett.myworks eq 1>
				<!---İşlerim --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30780.İşlerim'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="myworks" title="#message#"   unload_body="#menu_pos.is_close#" closable="1" close_href="javascript:HomeBox.onBoxRemove('myworks',false,'myworks');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_my_works_ajaxmyworks&xml_list_work=#xml_list_work#&x_show_work_complete=#x_show_work_complete#&xml_work_cc=#xml_work_cc#"></cf_catalyst-widget>
			</cfif>
			
			<cfif menu_pos.panel_name is 'homebox_correspondence' and my_sett.correspondence eq 1>
				<!---Yazışmalar sayfası--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57459.Yazışmalar'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="correspondence" title="#message#" collapsed="1" closable="1" close_href="javascript:HomeBox.onBoxRemove('correspondence',false,'correspondence');" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_correspondence_ajaxcorrespondence"></cf_catalyst-widget>
			</cfif>
			
			<cfif menu_pos.panel_name is 'homebox_internaldemand' and  my_sett.internaldemand eq 1>
				<!---İç Talepler--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30782.İç Talepler'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="internaldemand" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('internaldemand',false,'internaldemand');" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_internaldemand_ajaxdemand"></cf_catalyst-widget>
			</cfif>
			<cfif menu_pos.panel_name is 'homebox_career' and my_sett.is_kariyer eq 1>
				<!---Kariyerim--->
				<cfsavecontent variable="message"><cfoutput>#session.ep.company_nick# <cf_get_lang dictionary_id ='31532.İş Fırsatları'></cfoutput></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="career" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('career',false,'is_kariyer');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_dsp_career_ajaxcareer"></cf_catalyst-widget>
			</cfif>
			
			<cfif menu_pos.panel_name is 'homebox_pot_cons' and get_module_user(4) and my_sett.pot_cons eq 1>
				<!--- Bireysel Üye Başvuruları --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30797.Bireysel Üye Başvuruları'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="pot_cons" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('pot_cons',false,'pot_cons');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_consumer_app_ajaxconsumer"></cf_catalyst-widget>
			</cfif>
			
			<cfif menu_pos.panel_name is 'homebox_pot_partner' and get_module_user(4) and my_sett.pot_partner eq 1>
				<!--- Kurumsal Üye Başvuruları --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30798.Kurumsal Üye Başvuruları'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="pot_partner" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('pot_partner',false,'pot_partner');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_company_app_ajaxcompany"></cf_catalyst-widget>
			</cfif>
			
			<cfif menu_pos.panel_name is 'homebox_hr' and get_module_user(3) and my_sett.hr eq 1>
				<!--- CV Başvuruları --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31497.CV Başvuruları'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="hr" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('hr',false,'hr');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_apps_ajaxapps"></cf_catalyst-widget>
			</cfif>
			
			<cfif menu_pos.panel_name is 'homebox_finished_test_times' and get_module_user(3) and my_sett.finished_test_times eq 1>
				<!--- Deneme Süresi Bitenler --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31121.Deneme Süresi Bitenler'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="finished_test_times" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('finished_test_times',false,'finished_test_times');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_my_perform_emp_ajaxmyperfom"></cf_catalyst-widget>
			</cfif>
			
			<cfif menu_pos.panel_name is 'homebox_finished_contract' and get_module_user(3) and my_sett.sureli_is_finishdate eq 1>
				<!--- Sözleşmesi Bitenler --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31989.Sözleşmesi Bitenler'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="finished_contract" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('finished_contract',false,'sureli_is_finishdate');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_finish_contract_ajaxlistcontract"></cf_catalyst-widget>
			</cfif>
			
			<cfif fusebox.use_period>
				<!--- Satış İşlemleri --->
				<cfif get_module_user(11)>
					<cfif menu_pos.panel_name is 'homebox_orders_come' and my_sett.orders_come eq 1>
						<!---Satış Siparişleri--->	
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58207.Satış Siparişleri'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="orders_come" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('orders_come',false,'orders_come');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_order_ajaxorder"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_offer_given' and my_sett.offer_given eq 1>
						<!---Verilen Teklifler--->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30785.Verilen Teklifler'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="offer_given" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('offer_given',false,'offer_given');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_offers_give_ajaxoffersgive"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_sell_today' and my_sett.sell_today eq 1>
						<!--- Bugünkü Satış Faturaları --->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30786.Bugünkü Satış Faturaları'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="sell_today" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('sell_today',false,'sell_today');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_sale_bill_ajaxlistsale&maxrows=#attributes.maxrows#"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_promo_head' and my_sett.promo_head eq 1>
						<!---Fırsatlar--->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58694.Fırsatlar'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="promo_head" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('promo_head',false,'promo_head');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_opportunities_ajaxopportunities"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_most_sell_stock' and my_sett.most_sell_stock eq 1>
						<!---En çok Satan Ürünler--->
						<script src="JS/Chart.min.js"></script>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30788.En Çok Satan Ürünler'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="most_sell_stock" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('most_sell_stock',false,'most_sell_stock');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_top_products_ajaxtopproducts"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_offer_to_give' and my_sett.offer_to_give eq 1>
						<!---Verilecek Teklifler--->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30789.Verilecek Teklifler'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="offer_to_give" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('offer_to_give',false,'offer_to_give');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_offers_to_give_ajaxgive"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_new_stocks' and my_sett.new_stocks eq 1>
						<!---Yeni Stoklar--->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31498.Yeni Stoklar'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="new_stocks" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('new_stocks',false,'new_stocks');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_new_stocks_ajaxstocks"></cf_catalyst-widget>
					</cfif>
				</cfif>
				<!--- //Satış İşlemleri --->
			
				<!--- Satınalma işlemleri --->
				<cfif get_module_user(12)>
					<cfif menu_pos.panel_name is 'homebox_orders_give' and my_sett.orders_give eq 1>
						<!---Satın Alma Siparişleri--->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30790.Satınalma  Siparişleri'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="orders_give" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('orders_give',false,'orders_give');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_orderp_ajaxorderp"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_offer_taken' and my_sett.offer_taken eq 1>
						<!--- Alınan Teklifler --->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30791.Alınan Teklifler'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="offer_taken" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('offer_taken',false,'offer_taken');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_offers_take_ajaxofferstake"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_come_again_sip' and my_sett.come_again_sip eq 1>
						<!---Yeniden sipariş noktasına gelen ürünler--->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30792.Yeniden Sipariş Noktasına Gelen Ürünler'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="come_again_sip" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('come_again_sip',false,'come_again_sip');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_less_product_ajaxproduct"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_purchase_today' and my_sett.purchase_today eq 1>
						<!---Bugünkü alış faturaları --->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30874.Bugünkü Alış Faturaları'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="purchase_today" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('purchase_today',false,'purchase_today');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_bill_ajaxlistbill"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_more_stocks' and my_sett.more_stocks_id eq 1>
						<!---Fazla Stoklar---->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30794.Fazla Stoklar'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="more_stocks" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('more_stocks',false,'more_stocks_id');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_more_product_ajaxmoreproduct"></cf_catalyst-widget>
					</cfif>
					
					<cfif menu_pos.panel_name is 'homebox_send_order' and my_sett.send_order eq 1>
						<!--- Sevk Emirleri --->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30795.Sevk Emirleri'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="send_order" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('send_order',false,'send_order');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_send_order_ajaxsendorder"></cf_catalyst-widget>
					</cfif>
					
					<!--- <cfif menu_pos.panel_name is 'homebox_offer_to_take' and my_sett.offer_to_take eq 1>
						<!---Alınacak Teklifler--->
						<cfsavecontent variable="message"><cf_get_lang no ='98.Alınacak Teklifler'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="offer_to_take" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('offer_to_take',false,'offer_to_take');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_offers_to_take_ajaxtake"></cf_catalyst-widget>
					</cfif> --->
					
					<cfif menu_pos.panel_name is 'homebox_new_product' and my_sett.new_product eq 1>
						<!---Yeni Ürünler--->
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30796.Yeni Ürünler'></cfsavecontent>
						<cf_catalyst-widget dragDrop="1" id="new_product" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('new_product',false,'new_product');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_new_products_ajaxnewproducts"></cf_catalyst-widget>
					</cfif>
					
				</cfif>
				<!--- //Satınalma işlemleri --->
				
				<cfif menu_pos.panel_name is 'homebox_campaign_now' and get_module_user(15) and my_sett.campaign_now eq 1>
					<!--- Kampanya --->
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30800.Gündemdeki Kampanyalar'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="campaign_now" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('campaign_now',false,'campaign_now');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_campaign_ajaxcampaign"></cf_catalyst-widget>
				</cfif>
				
				<cfif menu_pos.panel_name is 'homebox_pre_invoice' and get_module_user(20) and my_sett.pre_invoice eq 1>
					<!--- Fatura --->
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30801.Kesilecek Faturalar'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="pre_invoice" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('pre_invoice',false,'pre_invoice');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_purchase_ajaxpurchase&xml_is_salaried=#xml_is_salaried#"></cf_catalyst-widget>
				</cfif>
				
				<!--- Servis Başvuruları --->
				<cfif menu_pos.panel_name is 'homebox_service_head' and  get_module_user(14) and my_sett.service_head eq 1>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30039.Servis Başvuruları'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="service_head" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('service_head',false,'service_head');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_service_ajaxlistservice"></cf_catalyst-widget>
				</cfif>
				
				<cfif menu_pos.panel_name is 'homebox_call_center_application' and get_module_user(27) and my_sett.call_center_application eq 1>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58468.Call Center Başvuruları'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="call_center_application" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('call_center_application',false,'call_center_application');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_callcenter_ajax"></cf_catalyst-widget>
				</cfif>
				
				<cfif menu_pos.panel_name is 'homebox_call_center_interaction' and get_module_user(27) and my_sett.call_center_interaction eq 1>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58729.Call Center Etkileşimler'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="call_center_interaction" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('call_center_interaction',false,'call_center_interaction');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_etkilesim_ajax"></cf_catalyst-widget>
				</cfif>
				
				<!--- <cfif menu_pos.panel_name is 'homebox_over_time_acc' and listgetat(session.ep.user_level, 14) and my_sett.over_time_acc eq 1>
					<!---Süresi Dolan Destek Hesapları--->
					<cfsavecontent variable="message"><cf_get_lang no ='46.Süresi Dolan Destek Hesapları'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="over_time_acc" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('over_time_acc',false,'over_time_acc');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_support_ajaxsupport"></cf_catalyst-widget>
				</cfif> --->
				
				<cfif menu_pos.panel_name is 'homebox_spare_part' and get_module_user(14) and my_sett.spare_part eq 1>
					<!---Beklenen Yedek Parçalar--->
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31500.Beklenen Yedek Parçalar'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="spare_part" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('spare_part',false,'spare_part');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_service_operation_ajaxservice"></cf_catalyst-widget>
				</cfif>
				
				<cfif menu_pos.panel_name is 'homebox_product_orders' and get_module_user(26) and my_sett.product_orders eq 1>
					<!--- Üretim Emirleri --->
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30804.Üretim Emirleri'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="product_orders" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('product_orders',false,'product_orders');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_prod_ajaxlist_prod"></cf_catalyst-widget>
				</cfif>
				
				<!--- Finans --->
				
				<cfif menu_pos.panel_name is 'homebox_pay' and get_module_user(16) and my_sett.pay eq 1>
					<!---Bugün Yapılacak Ödemeler --->
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30806.Bugün Yapılacak Ödemeler'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="pay" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('pay',false,'pay');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_pay_today_ajaxpaytoday"></cf_catalyst-widget>
				</cfif>
				
				<cfif menu_pos.panel_name is 'homebox_now_claim' and get_module_user(16) and my_sett.claim eq 1>
					<!---Bugün yapılacak tahsilatlar --->
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30805.Bugün Yapılacak Tahsilatlar'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="now_claim" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('now_claim',false,'claim');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_rev_today_ajaxrevtoday"></cf_catalyst-widget>
				</cfif>
				<!--- //Finans --->
				
				<!--- Contracts --->
				<cfif menu_pos.panel_name is 'homebox_old_contracts' and  get_module_user(17) and my_sett.old_contracts eq 1>
					<!--- Süresi Dolan Anlaşmalar --->
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31089.Süresi Dolan Anlaşmalar'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="old_contracts" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('old_contracts',false,'old_contracts');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_old_ajaxcontracts"></cf_catalyst-widget>
				</cfif>
								
				<cfif menu_pos.panel_name is 'homebox_forum' and  my_sett.is_forum eq 1>
					<!---Forumlar--->
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58128.Forumlar'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="forum" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('forum',false,'is_forum');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_my_forums_ajaxforums"></cf_catalyst-widget>
				</cfif>
				
				<cfif menu_pos.panel_name is 'homebox_social_media' and  my_sett.social_media eq 1>
					<!---Sosyal medya--->
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='29529.sosyal medya'></cfsavecontent>
					<cf_catalyst-widget dragDrop="1" id="social_media" title="#message#" closable="1" close_href="javascript:HomeBox.onBoxRemove('social_media',false,'social_media');" collapsed="1" unload_body="#menu_pos.is_close#" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_ajax_social_media"></cf_catalyst-widget>
				</cfif>
				<!--- //Contracts --->
			</cfif>
		</cfif>
        
		<cfif menu_pos.panel_name is 'homebox_hr_agenda' and my_sett.hr_agenda eq 1 and get_module_user(3)>
			<!---HR Ajanda--->
			 <cfsavecontent variable="message">HR <cf_get_lang dictionary_id ='57415.Ajanda'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="hr_agenda" title="#message#" unload_body="#menu_pos.is_close#" collapsable="1" closable="1" close_href="javascript:HomeBox.onBoxRemove('hr_agenda',false,'hr_agenda');" box_page="#request.self#?fuseaction=myhome.emptypopup_list_hr_agenda_ajaxhragenda&x_hr_agenda=#x_hr_agenda#"></cf_catalyst-widget>
		</cfif>
        
		<cfif menu_pos.panel_name is 'homebox_hr_in_out' and my_sett.hr_in_out eq 1 and get_module_user(3)>
			<!---HR Giris-Cikis--->
			 <cfsavecontent variable="message"><cf_get_lang dictionary_id ='29518.Girisler ve Cikislar'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="hr_in_out" title="#message#" unload_body="#menu_pos.is_close#" collapsable="1" closable="1" close_href="javascript:HomeBox.onBoxRemove('hr_in_out',false,'hr_in_out');" box_page="#request.self#?fuseaction=myhome.emptypopup_list_hr_in_out_ajaxhrinout"></cf_catalyst-widget>
		</cfif>
        
		<cfif (my_sett.day_agenda eq 1) or (my_sett.markets eq 1)>
			<!--- anasayfadayken başka ajandaya geçilmediği yorum satırı içine alınmıştır.
				<cfif isdefined("session.agenda_userid")>
				<cfset agenda = structdelete(session, "agenda_userid")>
			</cfif>
			------>
			<cfif menu_pos.panel_name is 'homebox_day_agenda' and get_module_user(6) and my_sett.day_agenda eq 1>
				<!--- Ajanda --->
				<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
				<cfset tarih = dateformat(date_add("h",session.ep.time_zone,attributes.to_day),'dd.mm.yyyy')>
				<cfsavecontent variable="agendamessage"><cf_get_lang dictionary_id='57415.Ajanda'></cfsavecontent>
				<cf_catalyst-widget dragDrop="1" id="day_agenda" title="#agendamessage#" unload_body="#menu_pos.is_close#" collapsable="1"  closable="1" close_href="javascript:HomeBox.onBoxRemove('day_agenda',false,'day_agenda');" write_info="#tarih#" add_href="#request.self#?fuseaction=agenda.view_daily&event=add&date=#tarih#" box_page="#request.self#?fuseaction=myhome.emptypopup_dsp_daily_agenda_ajaxagenda&date_interval=#attributes.date_interval#"></cf_catalyst-widget>
			</cfif>
		</cfif>
        
		<cfif menu_pos.panel_name is 'homebox_birthdate' and my_sett.is_birthdate eq 1 && isDefined("xml_birthdate_permission") && xml_birthdate_permission>
			<!---Dogum Günleri--->
			 <cfsavecontent variable="birthdatemessage"><cf_get_lang dictionary_id ='57896.Dogum Gunleri'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="birthdate" title="#birthdatemessage#" unload_body="#menu_pos.is_close#" collapsable="1" closable="1" scroll="3" close_href="javascript:HomeBox.onBoxRemove('birthdate',false,'is_birthdate');" box_page="#request.self#?fuseaction=myhome.emptypopup_dsp_birthdate_ajaxbirthdate&is_all_employee=#is_all_employee#&is_daily_birthday=#is_daily_birthday#"></cf_catalyst-widget>
		</cfif>
		
		<cfif menu_pos.panel_name is 'homebox_attending_workers' and my_sett.attending_workers eq 1>
			<!---İşe Yeni Başlayanlar--->
			 <cfsavecontent variable="workersmessage"><cf_get_lang dictionary_id ='30852.ise yeni baslayanlar'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="attending_workers" title="#workersmessage#"  unload_body="#menu_pos.is_close#" closable="1" close_href="javascript:HomeBox.onBoxRemove('attending_workers',false,'attending_workers');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_attending_workers_ajaxattending"></cf_catalyst-widget>
		</cfif>
		
		<cfif menu_pos.panel_name is 'homebox_employee_permittion' and my_sett.is_permittion eq 1 && isDefined("xml_offtime_permission") && xml_offtime_permission>
			<!---Izinliler--->
			 <cfsavecontent variable="permittionmessage"><cf_get_lang dictionary_id ='32390.İzinliler'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="employee_permittion" title="#permittionmessage#" unload_body="#menu_pos.is_close#" closable="1" close_href="javascript:HomeBox.onBoxRemove('employee_permittion',false,'is_permittion');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_employee_permittion_ajax&xml_show_offtime_days=#xml_show_offtime_days#"></cf_catalyst-widget>
		</cfif>	
	
		<cfif menu_pos.panel_name is 'homebox_markets' and my_sett.markets eq 1 and fusebox.use_period>
			<!---Piyasalar--->
			<cfsavecontent variable="workersmessage"><cf_get_lang dictionary_id='30839.Piyasalar'></cfsavecontent>
			<cf_catalyst-widget dragDrop="1" id="markets" title="#workersmessage#"  unload_body="#menu_pos.is_close#" collapsable="1" closable="1" close_href="javascript:HomeBox.onBoxRemove('markets',false,'markets');" box_page="#request.self#?fuseaction=myhome.emptypopup_list_markets_ajaxmarkets"></cf_catalyst-widget>
		</cfif>
		
		<cfif (lastColumn eq 1 and menu_pos.column_index eq 2) and (lastColumn eq 2 and menu_pos.column_index eq 3)>			
				</div>			
			</div>
		</cfif>
        
		<cfset lastColumn = menu_pos.column_index>
		
	</cfloop>
</div>

</cfprocessingdirective>

<script type="text/javascript">

	function homeMasonry(){
		var $container = $('.myhomeBox');	
		$container.masonry({itemSelector: '.homeSortArea'});
	}
	
	$(function() {
		HomeBox.onBoxRemove = function(x,isWidget,column) {
				var obj = document.getElementById('homebox_'+x);
				panelName = '&panelName=homebox_'+x;
				if (isWidget){						
					AjaxPageLoad('index.cfm?fuseaction=myhome.emptypopup_menu_positions&islem=del'+panelName,'sonuc',1);
					obj.style.display='none';
				}else if (column!=""){
					AjaxPageLoad('index.cfm?fuseaction=myhome.emptypopup_menu_positions&islem=del2'+panelName+'&column='+column,'sonuc',1);
					obj.style.display='none';
				}		
			};

		$(".homeSortArea").sortable({
			connectWith		: '.homeSortArea',//homeSortAreaCenter
			items			: '.col',
			handle			: '[id*="handle_"]',
			cursor			: 'move',
			opacity			: '0.6',
			placeholder		: 'col col-12 elementSortArea',
			tolerance		: 'pointer',
			revert			: 300,
			start: function(e, ui ){
				ui.placeholder.height(ui.helper.outerHeight());
				ui.item.css({'max-width':ui.placeholder.width()});
				oldTarget = ui.item.index()-1;	
				switch(ui.item.parent('div').attr('id')) {
						case 'homeColumnLeft':
							oldCol = 1;
							break;
						case 'homeColumnCenter':
							oldCol = 2;
							break;	
						case 'homeColumnRight':
							oldCol = 3;
							break;
					}			
			},
			stop: function(e, ui ) {					
					ui.item.css({'max-width':''});
					var target = ui.item.index()-1;
					var panelName = ui.item.attr('id');					
					switch(ui.item.parent('div').attr('id')) {
						case 'homeColumnLeft':
							var col = 1;
							break;
						case 'homeColumnCenter':
							var col = 2;
							break;	
						case 'homeColumnRight':
							var col = 3;
							break;
					}
					var adres = '&panelName=' + panelName;
					adres += '&targetPanelName='+ target;
					adres += '&col='+ col;					
					if(col != oldCol){
						AjaxPageLoad('index.cfm?fuseaction=myhome.emptypopup_menu_positions&islem=change'+adres,'sonuc',1);
					}else if(target != oldTarget){
						AjaxPageLoad('index.cfm?fuseaction=myhome.emptypopup_menu_positions&islem=change'+adres,'sonuc',1);	
					}			
			}//stop
		});		
		homeMasonry();
	});//ready
	$( ".portHead span" ).click(function() {
		homeMasonry();
	});
	$('.myhomeBox').bind('DOMNodeInserted DOMNodeRemoved', function() {
		homeMasonry();
	});
	
</script>