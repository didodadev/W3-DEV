<!--- 
	17112003 ARZUBT
	Basket deki veya arguments.var_ degerine sahip session degiskenlerini silmek icin kullanilir.	
	<cfscript>
		get_delete_session(var_);  //yada 
		get_delete_session();
	</cfscript>
--->
<cffunction name="get_delete_session" hint="Session Temizler">
	<cfargument name="var_" required="false" type="string">
	<cfscript>
		if (isdefined("arguments.var_") and len(arguments.var_))
		{
			if (isdefined("session.#arguments.var_#")) session = structdelete(session, "#arguments.var_#");
			if (isdefined("session.#arguments.var_#_id_comp")) session = structdelete(session,"#arguments.var_#_id_comp");
			if (isdefined("session.#arguments.var_#_id_person")) session = structdelete(session,"#arguments.var_#_id_person");
			if (isdefined("session.#arguments.var_#_id_consumer")) session = structdelete(session,"#arguments.var_#_id_consumer");
			if (isdefined("session.#arguments.var_#_discount")) session = structdelete(session,"#arguments.var_#_discount");
			if (isdefined("session.#arguments.var_#_name_person")) session = structdelete(session,"#arguments.var_#_name_person");
			if (isdefined("session.#arguments.var_#_person")) session = structdelete(session,"#arguments.var_#_person");
			if (isdefined("session.#arguments.var_#_currency")) session = structdelete(session, "#arguments.var_#_currency");
			if (isdefined("session.#arguments.var_#_sa_discount")) session = structdelete(session, "#arguments.var_#_sa_discount");
			if (isdefined("session.#arguments.var_#_total")) session = structdelete(session,"#arguments.var_#_total");
			if (isdefined("session.#arguments.var_#_net_total")) session = structdelete(session,"#arguments.var_#_net_total");
			if (isdefined("session.#arguments.var_#_kdvlist")) session = structdelete(session,"#arguments.var_#_kdvlist");
			if (isdefined("session.#arguments.var_#_kdvpricelist")) session = structdelete(session,"#arguments.var_#_kdvpricelist");
			if (isdefined("session.#arguments.var_#_total_tax")) session = structdelete(session,"#arguments.var_#_total_tax");
			if (isdefined("session.#arguments.var_#_upd")) session = structdelete(session,"#arguments.var_#_upd");
			if (isdefined("session.#arguments.var_#_other_money")) session = structdelete(session,"#arguments.var_#_other_money");
			if (isdefined("session.#arguments.var_#_other_money_value")) session = structdelete(session,"#arguments.var_#_other_money_value");
			if (isdefined("session.#arguments.var_#_prom_list")) session = structdelete(session,"#arguments.var_#_prom_list");
			if (isdefined("session.#arguments.var_#_name_cari")) session = structdelete(session,"#arguments.var_#_name_cari");	
			if (isdefined("session.check_purchase_upd")) session = structdelete(session,"check_purchase_upd");
			if (isdefined("session.check_purchase")) session = structdelete(session,"check_purchase"); 
			if (isdefined("session.check_upd")) session = structdelete(session,"check_upd");
			if (isdefined("session.check")) session = structdelete(session,"check");			
			if (isdefined("session.method_id_purchase_upd")) session = structdelete(session,"consumer_id_purchase_upd");
			if (isdefined("session.method_id")) session = structdelete(session,"method_id"); 
			if (isdefined("session.store")) session = structdelete(session,"store");
			if (isdefined("session.store_id")) session = structdelete(session,"store_id");
			if (isdefined("session.store_id_upd")) session = structdelete(session,"store_id_upd");
			if (isdefined("session.store_id_purchase")) session = structdelete(session,"store_id_purchase");
			if (isdefined("session.upd_id_invoice_sale")) session = structdelete(session,"upd_id_invoice_sale");
			if (isdefined("session.ship_order_row_list")) session = structdelete(session,"session.ship_order_row_list"); 
			if (isdefined("session.LOCATION_ID")) session = structdelete(session,"LOCATION_ID");
			if (isdefined("session.LOCATION_ID_PURCHASE_UPD")) session = structdelete(session,"LOCATION_ID_PURCHASE_UPD");				
			if (isdefined("session.liste_purchase_upd")) session = structdelete(session,"liste_purchase_upd");
			if (isdefined("session.liste_sale")) session = structdelete(session,"liste_sale");
			if (isdefined("session.liste_puchase")) session = structdelete(session,"liste_puchase");			
			if (isdefined("session.LISTE_SALE_upd")) session = structdelete(session,"LISTE_SALE_upd");
			if (isdefined("session.comp_id")) session = structdelete(session,"comp_id");
			if (isdefined("session.consumer_id")) session = structdelete(session,"consumer_id");
			if (isdefined("session.partner_id_purchase_upd")) session = structdelete(session,"partner_id_purchase_upd");
			if (isdefined("session.consumer_id_purchase_upd")) session = structdelete(session,"consumer_id_purchase_upd");

		}
		if (isdefined("session.rate1")) session = structdelete(session,"rate1");
		if (isdefined("session.rate2")) session = structdelete(session,"rate2");
		if (isdefined("session.count")) session = structdelete(session,"count"); 
	</cfscript>
</cffunction>
