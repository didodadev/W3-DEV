<!---  bu dosya basket popup ın nasıl gelecegini gösteriyor. Haber vermeden ellemeyin --->
<cfscript>
	sales_list='invoice_bill_upd,invoice_bill,ship_sale_store,basket_upd_take_order,invoice_bill_store';
	sales_list=sales_list & ",popup_upd_offer_product_page,basket_add_give_offer,basket_upd_give_offer,";
	sales_list=sales_list & "basket_upd_give_offer,basket_add_give_offer,basket_opp_offer_request,basket_add_give_offer_product,basket_cpy_offer_request";
	sales_list=sales_list & ",basket_add_take_order,ship_sale,ship_sale_upd,ship_order";
	sales_list=sales_list & ",cat_pro,cat_pro_add,sale_dispatch_store,sale_dispatch_upd_store,upd_ship_dispatch,sale_dispatch,sale_dispatch_upd";
	if (isDefined('attributes.var_') and listfindnocase(sales_list,var_,','))
		{
		sale_product = 1;
		if (not isDefined('attributes.price_catid')) attributes.price_catid=-2;//satis fiyatlari
		}
	else 
		{
		sale_product = 0;
		//if (not isDefined('attributes.price_catid')) attributes.price_catid=-1;//alis fiyatlari
		}
</cfscript>
