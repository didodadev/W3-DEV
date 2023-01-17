<cf_xml_page_edit fuseact="objects.popup_add_spect_list">

<script type="text/javascript">	
	function runProcessAction(mode,stage,tree_id,old_process_line)
	{
		create_adres_ = '<cfoutput>#request.self#?fuseaction=prod.emptypopup_run_process_action</cfoutput>';
		create_adres_= create_adres_ + '&mode=' + mode + '&process_stage=' + stage + '&tree_id=' + tree_id;
		
		if(old_process_line > 0) create_adres_= create_adres_ + '&old_process_line=' + old_process_line;
		AjaxPageLoad(create_adres_,'tree_action_page','1',"");
	}
	
	function openStationWindow(main_stock_id, stock_id, operation_type_id)
	{
		var params = "";
		if (main_stock_id != null && main_stock_id.length > 0) params += "&main_stock_id=" + main_stock_id;
		else if(stock_id != null && stock_id.length > 0) params += "&main_stock_id=" + stock_id;
		if (stock_id != null && stock_id.length > 0) params += "&stock_id=" + stock_id;
		if (operation_type_id != null && operation_type_id.length > 0) params += "&operation_type_id=" + operation_type_id;
		
		window.open("/index.cfm?fuseaction=prod.popup_add_ws_product&is_add_workstation=1" + params, "stationWindow", "width=1200,height=400,resizable=1");
	}
</script>
<table width="98%" height="98%"align="center">
	<tr>
		<td>
        <!---
		
			İhtiyaç duyulan parametreler
			
			serverAddress				Sunucu adresi
			companyID					session 'daki company_id
			userID						session 'daki userid
			periodID					session 'daki period_id
			periodYear					session 'daki period_year
			paramMoney					session 'daki birincil para birimi
			paramMoney2					session 'daki ikincil para birimi
			language					session 'daki dil tag i
			is_add_same_name_spect		spec ekleme sayfasında xml setup 'taki aynı isimde spec eklensin seçeneği
			
		--->
        	<div style="position:absolute; top:110px; left:50px; right:0px; bottom:0px;">
				<cfset flash_variables = "serverAddress=#cgi.HTTP_HOST#&companyID=#session.ep.company_id#&userID=#session.ep.userid#&positionCode=#session.ep.position_code#&periodID=#session.ep.period_id#&periodYear=#session.ep.period_year#&paramMoney=#session.ep.money#&paramMoney2=#session.ep.money2#&language=#session.ep.language#&allowSameNameForSpecs=#is_add_same_name_spect#">
                <script src="/js/AC_RunActiveContent.js" type="text/javascript"></script>
                <script type="text/javascript">
                AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0','width','100%','height','95%', 'id', 'product_tree','src','/V16/com_mx/product_tree?ud=09.09.2013','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','/V16/com_mx/product_tree?ud=09.09.2013','flashvars','<cfoutput>#flash_variables#</cfoutput>', 'allowScriptAccess', 'always','wmode','opaque'); //end AC code
                </script>
                <noscript>
                <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="100%" height="95%" id="product_tree">
                    <param name="movie" value="/V16/com_mx/product_tree.swf?ud=09.09.2013" />
                    <param name="wmode" value="opaque">
                    <param name="quality" value="high" />
                    <param name="flashvars" value="<cfoutput>#flash_variables#</cfoutput>"/>
                    <param name="allowScriptAccess" value="always"/>
                    <embed src="/V16/com_mx/product_tree.swf?ud=09.09.2013" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="95%"></embed>
                </object>
                </noscript>
                <div id="tree_action_page" style="position:absolute;overflow-y:auto;overflow-x:auto;height:1px;width:1px;"></div>
            </div>
    	</td>
    </tr>
</table>
