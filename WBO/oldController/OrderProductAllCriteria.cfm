<cf_get_lang_set module_name="purchase">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact="purchase.add_order_product_all_criteria">
	<cfif x_select_order_demand eq 0 or isdefined("attributes.from_purchase_order") or isdefined("attributes.from_sale_order")>
        <cfparam name="attributes.category_name" default="">
        <cfparam name="attributes.cat_id" default="">
        <cfparam name="attributes.brand_id" default="">
        <cfparam name="attributes.stock_control_type" default="">
        <cfif isdefined('attributes.order_id') and len(attributes.order_id)>
            <cfquery name="GET_ORDER_DETAIL" datasource="#dsn3#">
                SELECT 
                    *
                FROM 
                    ORDERS 
                WHERE 
                    ORDER_ID = #attributes.order_id# 
                    <cfif isdefined("attributes.from_sale_order") and attributes.from_sale_order eq 1>
                        AND	
                        (
                            (PURCHASE_SALES = 1 AND ORDER_ZONE = 0)  
                        OR
                            (PURCHASE_SALES = 0 AND ORDER_ZONE = 1)
                        ) 
                    <cfelseif isdefined("attributes.from_purchase_order") and attributes.from_purchase_order eq 1>
                        AND	
                        (
                            (PURCHASE_SALES = 0 AND ORDER_ZONE = 0)  
                        ) 
                    </cfif>
            </cfquery>
            <cfset attributes.project_id =  GET_ORDER_DETAIL.PROJECT_ID>
        </cfif>
    <cfelse>
		<!--- Siparişler / İç Talepler -- toplu sipariş verme sayfasından xml ile bağlı olarak geliyor. list_orders_internaldemands--->
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.order_stage" default="">
        <cfparam name="attributes.internaldemand_stage" default="">
        <cfparam name="attributes.order_row_currency" default="">
        <cfparam name="attributes.order_internaldemand" default="">
        <cfparam name="attributes.project_id" default="">
        <cfparam name="attributes.order_employee_id" default="">
        <cfparam name="attributes.order_employee" default="">
        <cfparam name="attributes.project_head" default="">
        <cfparam name="attributes.company_" default="">
        <cfparam name="attributes.company_id_" default="">
        <cfparam name="attributes.department_out_id" default="">
        <cfparam name="attributes.department_in_id" default="">
        <cfparam name="attributes.status" default="1">
        <cfparam name="attributes.product_id" default="">
        <cfparam name="attributes.product_name" default="">
        <cfparam name="attributes.prod_cat" default="">
        <cfparam name="attributes.brand_id" default="">
        <cfparam name="attributes.short_code_id" default="">
        <cfparam name="attributes.short_code_name" default="">
        <cfparam name="attributes.from_employee_id" default="">
        <cfparam name="attributes.from_employee_name" default="">
        <cfparam name="attributes.to_position_code" default="">
        <cfparam name="attributes.to_position_name" default= "">
        <cfparam name="attributes.sale_add_option" default= "">
        <cfparam name="attributes.priority" default= "">
        <cfparam name="attributes.start_date" default= "">
        <cfparam name="attributes.finish_date" default= "">
        <cfparam name="attributes.start_date1" default= "">
        <cfparam name="attributes.finish_date1" default= "">
        <cfparam name="attributes.start_date2" default= "">
        <cfparam name="attributes.finish_date2" default= "">
        <cfparam name="attributes.order_deliver_date" default= "">
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfinclude template="../sales/query/get_sale_add_option.cfm">
        <cfinclude template="../sales/query/get_product_cats.cfm">
        <cfinclude template="../sales/query/get_priority.cfm">
        <cfinclude template="../purchase/query/get_stores2.cfm">
        <cfquery name="get_process_type" datasource="#DSN#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID,
                PT.PROCESS_NAME,
                PT.PROCESS_ID
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_order%">
            ORDER BY
                PT.PROCESS_NAME,
                PTR.LINE_NUMBER
        </cfquery>
        <cfquery name="get_process_type2" datasource="#dsn#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PTR.PROCESS_ID = PT.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_internaldemand%">
        </cfquery>
        <cfif isdefined("attributes.form_submitted")>
            <cfinclude template="../purchase/query/get_order_demand_list.cfm">
        <cfelse>
            <cfset get_order_demand.recordcount = 0>
        </cfif>
        <style type="text/css"> @media screen and (max-width:1500px){.big_list thead tr th,.big_list tbody tr td  {padding:2px; font-size:11px; background-image:none;}} </style>
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfparam name="attributes.totalrecords" default='#get_order_demand.recordcount#'>
        <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
	</cfif>        
</cfif>


<script type="text/javascript">
	<cfif x_select_order_demand eq 0 or isdefined("attributes.from_purchase_order") or isdefined("attributes.from_sale_order")>
		function given_control()
		{
			if(document.add_order.stock_control_type != undefined && document.add_order.stock_control_type.value == 4 && document.add_order.brand_id!=undefined && document.add_order.brand_id.value == '')
			{
				alert('Marka Seçiniz !');
				return false;
			}
			if(document.getElementById('deliver_loc_id').value=='')
			{
				alert("<cf_get_lang no='177.Teslim yeri Seçiniz'> !");
				return false;
			}
			return true;
		}
		function change_stock_control_type()
		{
			if(document.add_order.stock_control_type.value == 4)
			{
				is_category_name.style.display = '';
				is_brand_id.style.display = '';
			}
			else
			{
				is_category_name.style.display = 'none';
				is_brand_id.style.display = 'none';
			}
		}
	<cfelse>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
		function get_comp_cat()
		{
			var get_comp_cat=wrk_query("SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID ="+document.form_basket_2.company_id.value,"dsn");
			var get_price_cat=wrk_query("SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS=1 AND IS_PURCHASE=1 AND COMPANY_CAT LIKE '%,"+get_comp_cat.COMPANYCAT_ID+",%' ORDER BY PRICE_CAT ASC","dsn3");
			var price_len = eval('document.getElementById("price_catid")').options.length;
			for(kk=price_len;kk>=0;kk--)
				eval('document.getElementById("price_catid")').options[kk] = null;	
				
			eval('document.getElementById("price_catid")').options[0] = new Option('Fiyat Listesi','');
	
			for(var jj=0;jj < get_price_cat.recordcount;jj++)
				eval('document.getElementById("price_catid")').options[jj+1]=new Option(get_price_cat.PRICE_CAT[jj],get_price_cat.PRICE_CATID[jj]);
	
		}
		function add_order()
		{
			if((document.form_basket_2.company_id.value == '' && document.form_basket_2.consumer_id.value == '') ||  document.form_basket_2.company.value == '')
			{
				alert("Cari Hesap Seçmelisiniz !");
				return false;
			}
			if(document.form_basket_2.deliver_dept_name.value == '' && document.form_basket_2.deliver_dept_id.value == '')
			{
				alert("Teslim Yeri Seçmelisiniz !");
				return false;
			}
			if(document.form_basket_2.deliverdate.value == '')
			{
				alert("Teslim Tarihi Girmelisiniz !");
				return false;
			}
			<cfif x_show_price_list eq 1>
			if(document.form_basket_2.price_catid.value == '')
			{
				alert("Fiyat Listesi Seçmelisiniz !");
				return false;
			}
			</cfif>
			var convert_stocks_id ='';
			var convert_spect_id ='';
			var convert_amount_stocks_id ='';
			var convert_wrk_row_id ='';
			var convert_order_row_id ='';
			var convert_demand_row_id ='';
			var convert_product_id ='';
			zero_list = '';
			if(document.all.report_row_stock_id_.length != undefined)
			{
				var checked_item_ = document.all.report_row_stock_id_;
				var convert_stocks_id ='';
				var convert_amount_stocks_id ='';
				var convert_spect_id ='';
				var convert_wrk_row_id ='';
				var convert_order_row_id ='';
				var convert_demand_row_id ='';
				var convert_product_id ='';
				for(var xx=0; xx < document.all.report_row_stock_id_.length; xx++)
				{
					if(checked_item_[xx].checked)
					{
						var type=list_getat(checked_item_[xx].value,1,';');
						var action_row_id=list_getat(checked_item_[xx].value,2,';');
						var stock_id_=list_getat(checked_item_[xx].value,3,';');
						var spect_id_=list_getat(checked_item_[xx].value,4,';');
						var wrk_row_id_=list_getat(checked_item_[xx].value,5,';');
						var product_id_=list_getat(checked_item_[xx].value,6,';');
						var amount_old_=list_getat(checked_item_[xx].value,7,';');
						var amount=eval("document.form_basket_2.demand_amount_"+wrk_row_id_).value;
						var product_name=eval("document.form_basket_2.product_name_"+wrk_row_id_).value;
						if(amount > 0)
						{
							var is_selected_row = 1;
							if(list_len(convert_stocks_id,',') == 0)
							{
								if(type == 1)
									convert_order_row_id+=action_row_id;
								else
									convert_demand_row_id+=action_row_id;
								convert_wrk_row_id+=wrk_row_id_;
								convert_stocks_id+=stock_id_;
								convert_product_id+=product_id_;
								convert_amount_stocks_id+=amount;
								convert_spect_id+=spect_id_;
							}
							else
							{
								if(type == 1)
								{
									if(list_len(convert_order_row_id,',') == 0)
										convert_order_row_id+=action_row_id;
									else
										convert_order_row_id+=","+action_row_id;
								}
								else
								{
									if(list_len(convert_demand_row_id,',') == 0)
										convert_demand_row_id+=action_row_id;
									else
										convert_demand_row_id+=","+action_row_id;
								}
								convert_wrk_row_id+=","+wrk_row_id_;
								convert_product_id+=","+product_id_;
								convert_amount_stocks_id+=","+amount;
								convert_spect_id+=","+spect_id_;
							}
						}
						else
						{
							
							if(list_len(zero_list,',') == 0)
								zero_list+=product_name;
							else
								zero_list+=","+product_name;
						}
					}
				}
			}
			else if(document.all.report_row_stock_id_)
			{
				var type=list_getat(document.all.report_row_stock_id_.value,1,';');
				var action_row_id=list_getat(document.all.report_row_stock_id_.value,2,';');
				var stock_id_=list_getat(document.all.report_row_stock_id_.value,3,';');
				var spect_id_=list_getat(document.all.report_row_stock_id_.value,4,';');
				var wrk_row_id_=list_getat(document.all.report_row_stock_id_.value,5,';');
				var product_id_=list_getat(document.all.report_row_stock_id_.value,6,';');
				var amount_old_=list_getat(document.all.report_row_stock_id_.value,7,';');
				var amount=eval("document.form_basket_2.demand_amount_"+wrk_row_id_).value;
				var product_name=eval("document.form_basket_2.product_name_"+wrk_row_id_).value;
				if(amount > 0)
				{
					var is_selected_row = 1;
					if(list_len(convert_stocks_id,',') == 0)
					{
						if(type == 1)
							convert_order_row_id+=action_row_id;
						else
							convert_demand_row_id+=action_row_id;
						convert_wrk_row_id+=wrk_row_id_;
						convert_stocks_id+=stock_id_;
						convert_product_id+=product_id_;
						convert_amount_stocks_id+=amount;
						convert_spect_id+=spect_id_;
					}
					else
					{
						if(type == 1)
						{
							if(list_len(convert_order_row_id,',') == 0)
								convert_order_row_id+=action_row_id;
							else
								convert_order_row_id+=","+action_row_id;
						}
						else
						{
							if(list_len(convert_demand_row_id,',') == 0)
								convert_demand_row_id+=action_row_id;
							else
								convert_demand_row_id+=","+action_row_id;
						}
						convert_wrk_row_id+=","+wrk_row_id_;
						convert_stocks_id+=","+stock_id;
						convert_product_id+=","+product_id_;
						convert_amount_stocks_id+=","+amount;
						convert_spect_id+=","+spect_id_;
					}
				}
				else
				{
					if(list_len(zero_list,',') == 0)
						zero_list+=product_name;
					else
						zero_list+=","+product_name;
				}
			}
			if(is_selected_row == undefined)
			{
				alert("Ürün Seçiniz!");
				return false;
			}
			else if(list_len(zero_list,',') != 0)
			{
				alert("Aşağıdaki Ürünler İçin Sipariş Miktarı Sıfır Olduğu İçin Baskete Atılmayacaktır !\n\n\n"+product_name);
			}
			if(list_len(convert_stocks_id,',') > 0)
			{
				convert_stocks_id+=0;
				var paper_date_ = js_date(form_basket_2.date_new.value.toString() );
				var str_price_row="SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT PP WHERE PRODUCT_ID IN("+convert_product_id+") AND PRODUCT_ID NOT IN(SELECT P.PRODUCT_ID FROM PRICE P WHERE P.PRODUCT_ID = PP.PRODUCT_ID AND P.PRICE_CATID="+document.form_basket_2.price_catid.value+" AND (FINISHDATE >="+paper_date_+" OR FINISHDATE IS NULL))";
				var get_price_row=wrk_query(str_price_row,"dsn3");
				if(get_price_row.recordcount)
				{
					fiyatsiz_urunler = '';
					for(kk=0;kk<get_price_row.recordcount;kk++)
						fiyatsiz_urunler = fiyatsiz_urunler + get_price_row.PRODUCT_NAME[kk] + '\n';
					if(!confirm('Aşağıdaki Ürünler İçin Seçilen Fiyat Listesinde Fiyat Bulunmamaktadır. Devam Etmek İstiyor musunuz ? \n\n'+fiyatsiz_urunler))
						return false;
				}
				document.all.convert_wrk_row_id.value=convert_wrk_row_id;
				document.all.convert_stocks_id.value=convert_stocks_id;
				document.all.convert_spect_id.value=convert_spect_id;
				document.all.convert_amount_stocks_id.value=convert_amount_stocks_id;
				document.all.convert_demand_row_id.value=convert_demand_row_id;
				document.all.convert_order_row_id.value=convert_order_row_id;
				if(document.getElementById('project_id') != undefined && document.getElementById('project_id').value != '' && document.getElementById('project_head') != undefined && document.getElementById('project_head').value != '')
				{
					document.all.convert_project_id.value = document.getElementById('project_id').value;
					document.all.convert_project_head.value = document.getElementById('project_head').value;
				}
				else
				{
					document.all.convert_project_id.value = '';
					document.all.convert_project_head.value = '';
				}
				document.form_basket_2.action='<cfoutput>#request.self#?fuseaction=purchase.list_order&event=add&type=convert&is_from_report=1&is_wrk_row_id=1</cfoutput>';
				document.form_basket_2.submit();
				return true;
			}
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'purchase.add_order_product_all_criteria';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'purchase/form/give_order_product_criteria.cfm';
	
	
</cfscript>
