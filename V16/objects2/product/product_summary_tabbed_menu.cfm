<cfif isdefined("attributes.stock_id")>
	<cfset attributes.sid = attributes.stock_id>
</cfif>
<cfif isdefined('attributes.product_id')>
	<cfset attributes.pid = attributes.product_id>
</cfif>
<cfif not (isNumeric(attributes.sid) and isNumeric(attributes.pid))>
	<script language="javascript">
		alert("Yetkisiz Erişim");
		history.back(-1);
	</script>
	<cfabort>
</cfif>
<cfif isdefined('attributes.is_content_type_id') and len(attributes.is_content_type_id)>
	<cfset attributes.is_content_type_id = #attributes.is_content_type_id#>
<cfelse>
	<cfset attributes.is_content_type_id = ''>
</cfif>
<cfif isdefined('attributes.last_user_price_list') and len(attributes.last_user_price_list)>
	<cfset attributes.last_user_price_list = #attributes.last_user_price_list#>
<cfelse>
	<cfset attributes.last_user_price_list = ''>
</cfif>
<cfquery name="GET_PROD_TREE" datasource="#DSN3#">
	SELECT 
		PRODUCT_TREE.PRODUCT_TREE_ID
	FROM
		PRODUCT_TREE
	WHERE
		PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
</cfquery>
	<cfoutput>
    <ul id="menu1" class="ajax_tab_menu">
        <li class="selected" id="link1"><a onclick="AjaxPageLoad('#request.self#?fuseaction=objects2.emptypopup_get_summary_tabbed&pid=#attributes.pid#&type=1&is_content_type_id=#attributes.is_content_type_id#<cfif isdefined('attributes.is_body') and len(attributes.is_body)>&is_body=#attributes.is_body#</cfif><cfif isDefined('attributes.is_content_print')>&is_content_print=#attributes.is_content_print#</cfif><cfif isDefined('attributes.is_content_webmail')>&is_content_webmail=#attributes.is_content_webmail#</cfif>&is_content_outhor=0','show_product',0,'Yükleniyor',link1);"><cf_get_lang no='5.Detaylar'></a></li>
        <cfif isdefined('attributes.my_product_property') and attributes.my_product_property eq 1><li id="link6"><a onclick="pageload(6,link6);"><cf_get_lang_main no='1498.Özellikler'></a></li></cfif>
        <cfif isDefined('attributes.my_product_tree') and attributes.my_product_tree eq 1 and get_prod_tree.recordcount><li id="link8"><a onclick="pageload(8,link8);"><cf_get_lang no='1379.Bileşenler'></a></li></cfif>
        <cfif isDefined('attributes.my_product_images') and attributes.my_product_images eq 1><li id="link2"><a onclick="pageload(2,link2);"><cf_get_lang no='173.Resimler'></a></li></cfif>
        <cfif isDefined('attributes.my_product_asset') and attributes.my_product_asset eq 1><li id="link3"><a onclick="pageload(3,link3);"><cf_get_lang_main no='156.Belgeler'></a></li></cfif>
        <cfif isDefined('attributes.my_product_payment') and attributes.my_product_payment eq 1><li id="link7"><a onclick="pageload(7,link7);"><cf_get_lang no='1381.Ödeme Seçenekleri'></a></li></cfif>
        <cfif isDefined('attributes.my_product_comment') and attributes.my_product_comment eq 1><li id="link4"><a onclick="pageload(4,link4);"><cf_get_lang_main no='773.Yorumlar'></a></li></cfif>
        <cfif isDefined('attributes.my_product_relation_prod') and attributes.my_product_relation_prod eq 1><li id="link5"><a onclick="pageload(5,link5);"><cf_get_lang no='1382.İlişkili Ürünler'></a></li></cfif>
    </ul>
    <div id="show_product" class="tabbed_menu_div">
        <cfset attributes.is_body = 1>
        <cfset attributes.is_content_print = 0>
        <cfset attributes.is_content_webmail = 0>
        <cfset attributes.is_content_outhor = 0>
        <!---<cfset attributes.is_content_type_id = ''>--->
        <cfinclude template="../product/product_detail_content.cfm">
        <!--- arama motorlari icin degistirmeyiniz --->
    </div>
	<script type="text/javascript">
        function pageload(page,_link_)
        {
            if(page==2)
            var url_str = "#request.self#?fuseaction=objects2.emptypopup_get_summary_tabbed&pid=#attributes.pid#&type="+page+"<cfif isDefined('attributes.product_image_maxrows')>&product_image_maxrows=#attributes.product_image_maxrows#</cfif><cfif isDefined('attributes.product_image_name')>&product_image_name=#attributes.product_image_name#</cfif><cfif isDefined('attributes.product_image_id')>&product_image_id=#attributes.product_image_id#</cfif><cfif isDefined('product_image_view')>&product_image_view=#attributes.product_image_view#</cfif><cfif isDefined('attributes.product_image_size')>&product_image_size=#attributes.product_image_size#</cfif><cfif isDefined('attributes.product_image_width')>&product_image_width=#attributes.product_image_width#</cfif><cfif isDefined('attributes.product_image_height')>&product_image_height=#attributes.product_image_height#</cfif><cfif isDefined('attributes.prod_image_mode')>&prod_image_mode=#attributes.prod_image_mode#</cfif>"
            else if(page==3)
            var url_str = "#request.self#?fuseaction=objects2.emptypopup_get_summary_tabbed&pid=#attributes.pid#&type="+page+"<cfif isDefined('attributes.product_asset_maxrows')>&product_asset_maxrows=#attributes.product_asset_maxrows#</cfif><cfif isDefined('attributes.product_asset_name')>&product_asset_name=#attributes.product_asset_name#</cfif><cfif isDefined('attributes.product_asset_detail')>&product_asset_detail=#attributes.product_asset_detail#</cfif><cfif isDefined('attributes.product_asset_type')>&product_asset_type=#attributes.product_asset_type#</cfif>"
            else if(page==4)
            var url_str = "#request.self#?fuseaction=objects2.emptypopup_get_summary_tabbed&pid=#attributes.pid#&type="+page+"<cfif isDefined('attributes.my_add_product_comment')>&my_add_product_comment=#attributes.my_add_product_comment#</cfif><cfif isdefined('attributes.is_comment_graph')>&is_comment_graph=#attributes.is_comment_graph#</cfif>"
            else if(page==5)
            var url_str = "#request.self#?fuseaction=objects2.emptypopup_get_summary_tabbed&pid=#attributes.pid#&type="+page+"<cfif isDefined('attributes.prod_relation_prod_maxrows')>&prod_relation_prod_maxrows=#attributes.prod_relation_prod_maxrows#</cfif>&last_user_price_list=#attributes.last_user_price_list#<cfif isDefined('attributes.prod_relation_prod_name')>&prod_relation_prod_name=#attributes.prod_relation_prod_name#</cfif><cfif isDefined('attributes.prod_relation_prod_price')>&prod_relation_prod_price=#attributes.prod_relation_prod_price#</cfif><cfif isDefined('attributes.prod_relation_prod_detail2')>&prod_relation_prod_detail2=#attributes.prod_relation_prod_detail2#</cfif><cfif isDefined('attributes.prod_relation_prod_image')>&prod_relation_prod_image=#attributes.prod_relation_prod_image#</cfif><cfif isDefined('attributes.prod_relation_prod_width')>&prod_relation_prod_width=#attributes.prod_relation_prod_width#</cfif><cfif isDefined('attributes.prod_relation_prod_height')>&prod_relation_prod_height&#attributes.prod_relation_prod_height#</cfif><cfif isDefined('attributes.prod_relation_prod_detail')>&prod_relation_prod_detail=#attributes.prod_relation_prod_detail#</cfif>&prod_relation_prod_position=#attributes.prod_relation_prod_position#"
            else if(page==6)
            var url_str = "#request.self#?fuseaction=objects2.emptypopup_get_summary_tabbed&pid=#attributes.pid#&type="+page+""
            else if(page==7)
            var url_str = "#request.self#?fuseaction=objects2.emptypopup_get_summary_tabbed&pid=#attributes.pid#&type="+page+"<cfif isdefined('attributes.price_kdv')and len(attributes.price_kdv)>&price_kdv=#attributes.price_kdv#<cfelse>&price_kdv=''</cfif><cfif isdefined('attributes.price_money')and len(attributes.price_money)>&price_money=#attributes.price_money#<cfelse>&price_money=''</cfif>"
            else if(page==8)
            var url_str = "#request.self#?fuseaction=objects2.emptypopup_get_summary_tabbed&pid=#attributes.pid#&sid=#attributes.sid#&type="+page+"&tree_stock_code=#attributes.tree_stock_code#&tree_image=#attributes.tree_image#&tree_product_link=#attributes.tree_product_link#&tree_amount=#attributes.tree_amount#&tree_product_detail=#attributes.tree_product_detail#&tree_alphabetic_type=#attributes.tree_alphabetic_type#&product_tree_image_width=#attributes.product_tree_image_width#&product_tree_image_height=#attributes.product_tree_image_height#"
            AjaxPageLoad(url_str,'show_product',1,'Yükleniyor',_link_);
        }
    </script>
</cfoutput> 
