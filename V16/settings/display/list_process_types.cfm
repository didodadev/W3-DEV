<cfset upload_folder = '#GetDirectoryFromPath(GetCurrentTemplatePath())#..#dir_seperator#..#dir_seperator#admin_tools#dir_seperator#'>
<cffile action="read" variable="xmldosyam" file="#upload_folder#xml#dir_seperator#setup_process_cat.xml" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.workcube_process_types.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrow" default='200'>
<cfparam name="attributes.totalrecords" default='#d_boyut#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id='57777.İşlemler'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#head#" resize="0" collapsable="0">
	<cf_grid_list>
    <thead>
		<tr>
			<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57692.İşlem'></th>
			<th><cf_get_lang dictionary_id='42781.İşlem ID'></th>
			<th><cf_get_lang dictionary_id='42178.Modül'></th>
			<cfif session.ep.our_company_info.is_efatura eq 1><th><cf_get_lang dictionary_id='60261.E-Fatura Tipi'></hd></cfif>
		</tr>
	</thead>
    <cfset list_invoice_type_code= ''>
	<cfif isDefined('d_boyut')>    
      <cfloop from='#attributes.startrow#' to='#iif(attributes.totalrecords gt (attributes.maxrow+attributes.startrow),attributes.maxrow+attributes.startrow-1,attributes.totalrecords)#' index='i'>
      	<cfif len(dosyam.workcube_process_types.process[i].invoice_type_code.XmlText)>
        	<cfset list_invoice_type_code= listappend(list_invoice_type_code,dosyam.workcube_process_types.process[i].process_type.XmlText,',')>
        </cfif>
        <cfoutput>        
        <tr>
            <td>
                <cfset alan_1 = dosyam.workcube_process_types.process[i].process_type.XmlText>
                <cfif session.ep.language is 'tr'>
                    <cfset alan_2 = dosyam.workcube_process_types.process[i].process_cat.XmlText>
                <cfelse>
                    <cfset alan_2 = dosyam.workcube_process_types.process[i].process_cat_eng.XmlText>
                </cfif>
                <cfset alan_3 = dosyam.workcube_process_types.process[i].process_module_id.XmlText>
                <cfset alan_4 = dosyam.workcube_process_types.process[i].process_fuseaction.XmlText>
                <cfif session.ep.our_company_info.is_efatura eq 1>
					<cfset alan_5 = dosyam.workcube_process_types.process[i].profile_id.XmlText>
                    <cfset alan_6 = dosyam.workcube_process_types.process[i].invoice_type_code.XmlText> 
                <cfelse>
					<cfset alan_5 = ''>
                    <cfset alan_6 = ''>                 
                </cfif>
                <cfset alan_7 = dosyam.workcube_process_types.process[i].process_multi_type.XmlText>
                <cfset rm = '#chr(13)#' >
                <cfset alan_2 = ReplaceList(alan_2,rm,'')>
                <cfset rm = '#chr(10)#' >
                <cfset alan_2 = ReplaceList(alan_2,rm,'')>						
                <a href="javascript://" onClick="javascript:ekle('#alan_1#','#alan_2#','#alan_3#','#alan_4#','#alan_5#','#alan_6#','#alan_7#');" class="tableyazi">#i#</a>
            </td>
            <td>
                <a href="javascript://" onClick="javascript:ekle('#alan_1#','#alan_2#','#alan_3#','#alan_4#','#alan_5#','#alan_6#','#alan_7#');" class="tableyazi">
                <cfif session.ep.language is 'tr'>
                    #dosyam.workcube_process_types.process[i].process_cat.XmlText#
                <cfelse>
                    #dosyam.workcube_process_types.process[i].process_cat_eng.XmlText#
                </cfif>
                </a>
            </td>
            <td>#dosyam.workcube_process_types.process[i].process_type.XmlText#</td>
            <td>#dosyam.workcube_process_types.process[i].process_module_name.XmlText#</td>
            <cfif session.ep.our_company_info.is_efatura eq 1><td>#dosyam.workcube_process_types.process[i].invoice_type_code.XmlText#</td></cfif>
        </tr>
        </cfoutput>
      </cfloop>
    <cfelse>
        <tr>
            <td colspan="5"><cf_get_lang dictionary_id='57484.kayıt yok'></td>
        </tr>
	</cfif>
</cf_grid_list>
</cf_box>
</div>

<cfif isDefined('attributes.field_id') and isDefined('attributes.field_name')>
  <script type="text/javascript">
  <cfif isDefined('attributes.field_module_id')>
	function ekle(process_type,process_cat,module_id,details,profile_id,invoice_type_code,process_multi_type)
	{	
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value=process_type;
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value=process_cat;
		opener.<cfoutput>#attributes.field_module_id#</cfoutput>.value=module_id;
		opener.<cfoutput>#attributes.detail#</cfoutput>.value=details;	
		<cfif session.ep.our_company_info.is_efatura eq 1>
			opener.<cfoutput>#attributes.profile_id#</cfoutput>.value=profile_id;
			opener.<cfoutput>#attributes.invoice_type_code#</cfoutput>.value=invoice_type_code;
		</cfif>
		opener.<cfoutput>#attributes.process_multi_type#</cfoutput>.value=process_multi_type;
		inv_process_type = "'50','51','52','53','531','532','54','55','56','561','57','58','59','591','592','60','601','61','62','63','64','65','66','67','68','690','691'";
		if(inv_process_type.search("'" + process_type + "'")>=0) 						
		{
			opener.discount.style.display='';
			if(opener._is_due_date_based_cari_)
				opener._is_due_date_based_cari_.style.display='';
			if(opener._is_paymethod_based_cari_)
				opener._is_paymethod_based_cari_.style.display='';	
			if(opener._is_row_project_based_cari_)
				opener._is_row_project_based_cari_.style.display='';	
		}
		else
		{
			if(opener._is_due_date_based_cari_)
				opener._is_due_date_based_cari_.style.display='none';	
			if(opener._is_paymethod_based_cari_)
				opener._is_paymethod_based_cari_.style.display='none';	
			if(opener._is_row_project_based_cari_)
				opener._is_row_project_based_cari_.style.display='none';	
		}
		(process_type != 122) ? opener._is_inventory_valuation.style.display='none' : opener._is_inventory_valuation.style.display='block';
		if(process_type == 530)  opener.document.getElementById("tr_is_cari").style.display="none"; 
		if(process_type != 5311){
			opener.export_product.style.display='none';
			opener.export_registered.style.display='none';
		}
		else{
			opener.export_product.style.display='block';
			opener.export_registered.style.display='block';
		}
		if(process_type == 2503 || process_type == 1201){
			opener.allowance_deduction.style.display='block';
		}
		else{
			opener.allowance_deduction.style.display='none';
		}
		if(list_find('55,62',process_type)){ // iade faturalarında tevkifat muhasebeleşmesin seçeneği gösterilir
			opener.document.getElementById("_is_visible_tevkifat").style.display="block";
		}else{
			opener.document.getElementById("_is_visible_tevkifat").style.display="none";
		}
		if(process_type == 120 || process_type == 121)//masraf ve gelir fişleri için ödeme yönt baznda carileşme seçeneği
		{
			if(opener._is_paymethod_based_cari_)
				opener._is_paymethod_based_cari_.style.display='';
			if(opener._is_row_project_based_cari_)
				opener._is_row_project_based_cari_.style.display='';	
		}
		stock_process_type = "'171','52','53','54','55','59','62','64','65','66','69','690','591','592','531','532','70','71','72','73','74','75','76','77','78','79','80','81','811','82','83','84','88','761','110','111','112','113','1131','114','115','116','120','118','1182'";
		if(stock_process_type.search("'" + process_type + "'")>=0)
		{
			opener.stock.style.display='';
			opener.zero_stock.style.display='';
		}
		else
		{
			opener.stock.style.display='none';
			opener.zero_stock.style.display='none';
		}
		if(list_find('2502,2504,2505,2506,2507,2508,2509,2510,2511,2512,2513',process_type))
		{
			 opener.document.getElementById("tr_is_cari").style.display="none";
			 opener.document.getElementById('tr_is_account').style.display='none';
			 opener.document.getElementById('tr_is_budget').style.display='none';
			 opener.document.getElementById('tr_is_project_based_acc').style.display='none';
			 opener.document.getElementById('tr_is_account_group').style.display='none'; 
			 opener.document.getElementById('next_periods_accrual_action').style.display='none';
			 opener.document.getElementById('accrual_budget_action').style.display='none'; 
			 opener.document.getElementById('is_project_based_budget_field').style.display='none';

		}
		prod_cost_acc_action = "'52','53','54','55','56','531'";
		if(prod_cost_acc_action.search("'" + process_type + "'")>=0)
			opener.account_prod_cost.style.display='';
		else
			opener.account_prod_cost.style.display='none';
		
		cost_process_type = "'59','76','171','54','55','73','74','62','78','114','115','116','811','591','58','81','113','1131','811','1182'";
		if(cost_process_type.search("'" + process_type + "'")>=0)
			opener.sales_cost.style.display='';
		
		cheque_process_type = "'90','91','92','93','94','95','105','1057'";
		if(cheque_process_type.search("'" + process_type + "'")>=0)
		{	
			opener.cheque.style.display='';
			opener.cheque1.style.display='';
		}
		else
		{
			opener.cheque.style.display='none';
			opener.cheque1.style.display='none';
		}
		exp_process_type = "'120','121'";
		if(exp_process_type.search("'" + process_type + "'")>=0)
			opener._is_exp_based_acc_.style.display='';
		else
			opener._is_exp_based_acc_.style.display='none';
		
		inv_process_type = "'71','74','73'";
		if(inv_process_type.search("'" + process_type + "'")>=0)
			opener._is_add_inventory_.style.display='';
		else
			opener._is_add_inventory_.style.display='none';
			
		dept_process_type = "'113','112','115','110','119','122','62','592','531','53','591','532','59','52','54','55','171','81','690','64','811'";
		if(dept_process_type.search("'" + process_type + "'")>=0)
			opener._is_dept_based_acc_.style.display='';
		else
			opener._is_dept_based_acc_.style.display='none';

		eshipment_types = "'70','71','72','73','74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','761'";
		if(eshipment_types.search("'" + process_type + "'")>=0)
		{
			opener.despatch_advice_type_.style.display='';
			opener.despatch_advice_type.value = '';
			opener.eshipment_profile_id_.style.display='';
			opener.eshipment_profile_id.value='';
		}
		else
		{
			opener.despatch_advice_type_.style.display='none';
			opener.despatch_advice_type.value = '';
			opener.eshipment_profile_id_.style.display='none';
			opener.eshipment_profile_id.value='';
		}
		
		//belirtilen islem tiplerinde belge tipi ve odeme seklinin goruntulenmemesini saglar (tahakkuk, mahsup, tediye, tahsil)
		process_edefter_list = "'160','11','12','13'";
		if(process_edefter_list.search("'" + process_type + "'")>=0)
		{
			opener.document.getElementById("tr_document_type").style.display = 'none';
			opener.document.getElementById("tr_document_type").value = '';
			opener.document.getElementById("tr_payment_type").style.display = 'none';
			opener.document.getElementById("tr_payment_type").value = '';
		}
		else
		{
			opener.document.getElementById("tr_document_type").style.display = '';
			opener.document.getElementById("tr_payment_type").style.display = '';
		}
		
		//e-defter kullaniliyorsa belirtilen islem tiplerinde hesap bazinda gruplamayi kilitliyor (toplu gelen havale, toplu giden havale, toplu tahsilat, toplu ödeme)
        <cfif session.ep.our_company_info.is_edefter eq 1>
			account_edefter_list = "'240','253','310','320','2410'";
			if(account_edefter_list.search("'" + process_type + "'")>=0)
			{
				opener.document.getElementById("tr_is_account_group").style.display = 'none';
				opener.document.getElementById("tr_is_account_group").value = '';
			}
		
		</cfif>
		//belirtilen fatura islem tiplerinde secilecek olan irsaliye tipinin gosterilmesini saglar 20140617
		process_ship_list = "'62','52','53','690','592','531','591','532','64','59','54','55'";
		if(process_ship_list.search("'" + process_type + "'")>=0)
		{
			opener.document.getElementById("ship_type_").style.display = '';
			opener.document.getElementById("ship_type2_").style.display = '';
			if (process_type == 62)
				ship_type_id = 78;
			else if (process_type == 52)
				ship_type_id = 70;
			else if (process_type == 53)
				ship_type_id = 71;
			else if (process_type == 690)
				ship_type_id = 84;
			else if (process_type == 592)
				ship_type_id = 761;
			else if (process_type == 531)
				ship_type_id = 88;
			else if (process_type == 591)
				ship_type_id = 87;
			else if (process_type == 532)
				ship_type_id = 72;
			else if (process_type == 64)
				ship_type_id = 80;
			else if (process_type == 59)
				ship_type_id = 76;
			else if (process_type == 54)
				ship_type_id = 73;
			else if (process_type == 55)
				ship_type_id = 74;
			else
				ship_type_id = "";
			var ship_process_types = wrk_safe_query("get_ship_types","dsn3",0,ship_type_id);
			if(ship_process_types.recordcount != 0)
			{
				var option_count_sub = window.opener.document.getElementById('ship_type').options.length;
				for(y=option_count_sub;y>=0;y--)
					window.opener.document.getElementById('ship_type').options[y] = null;
				for(var xx=0;xx<ship_process_types.recordcount;xx++)
					window.opener.addOption(ship_process_types.PROCESS_CAT[xx],ship_process_types.PROCESS_CAT_ID[xx]);
			}
		}
		else
		{
			if(opener.document.getElementById("ship_type_") != undefined && opener.document.getElementById("ship_type2_") != undefined)
			{
				opener.document.getElementById("ship_type_").style.display = 'none';
				opener.document.getElementById("ship_type2_").style.display = 'none';
			}
		}

		invoice_type_code_list = "<cfoutput>#list_invoice_type_code#</cfoutput>";
		if(opener.document.getElementById('invoice_type_code') && opener.document.getElementById('profile_id') && !list_find(invoice_type_code_list,process_type))
	   	{
			opener.document.getElementById('invoice_type_code_tr').style.display = 'none' ; 	
			opener.document.getElementById('profile_id_tr').style.display = 'none'; 
	   	}
		else
		{
			opener.document.getElementById('invoice_type_code_tr').style.display = '';
			opener.document.getElementById('profile_id_tr').style.display = '';   
		}
		window.close();
	}
	<cfelse>
	function ekle(process_type,process_cat)
	{	
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value=process_type;
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value=process_cat;
		<cfif isdefined("attributes.call_function")>
			try{opener.<cfoutput>#attributes.call_function#</cfoutput>;}
				catch(e){};
		</cfif>
		window.close();
	}
	</cfif>
  </script>
</cfif>