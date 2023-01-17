<cfparam name="attributes.is_mix_product" type="any" default="0"><!--- 0: Ürün ağacından kayıt yapılıyor, 1: Karma koliden kayıt yapılıyor. --->
<cfif isdefined('attributes.is_spect_name_to_property')>
    <cfquery name="get_product_name" datasource="#dsn3#">
        SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #attributes.value_stock_id#
    </cfquery>
    <!--- configure_spec_name Bu Değişken Aşağıdaki include içinde değiştirilir,ve ürünün altındaki bileşenlerinde configüre edilenlerinden spec ismi oluşur... --->
    <cfset configure_spec_name =get_product_name.PRODUCT_NAME>
    <cfif attributes.is_spect_name_to_property eq 1 and not isdefined("GetProductConf")><!--- XML ayarlarından Ürün Adı Bileşenlerden Oluşturulsun Denmiş İse... --->
	    <cfinclude template="../functions/get_conf_components.cfm">
    <cfelseif attributes.is_spect_name_to_property eq 2 and not isdefined("GetProductConf_comp")><!--- XML ayarlarından  Ürün Adı Özelliklerden Denmiş ise --->
    	<cfinclude template="../functions/get_conf_components_property.cfm">
    </cfif>
</cfif>
<cfif not isdefined("attributes.is_add_same_name_spect")><cfset attributes.is_add_same_name_spect = 0></cfif>
<cfif isdefined('attributes.upd_main_spect')>
	<cfinclude template="upd_spect_main.cfm">
<cfelse>
	<cflock name="#createUUID()#" timeout="20">
		<cftransaction>
			<cfscript>
				main_stock_id = attributes.value_stock_id;
				main_product_id = attributes.value_product_id;
				spec_name = attributes.spect_name;
				row_count=0;
				spec_total_value = attributes.toplam_miktar?: 0;
				spec_other_total_value = attributes.other_toplam?: 0;
				if(isdefined("attributes.rd_money"))
					other_money = listgetat(attributes.rd_money,1,',');
				else
					other_money = session.ep.money;
				main_prod_price = attributes.main_prod_price;
				main_product_money = attributes.main_prod_price_currency;
				if(isdefined('attributes.is_change') and attributes.is_change) spec_is_tree = 0; else spec_is_tree = 1;
				stock_id_list="";
				product_id_list="";
				product_name_list="";
				amount_list="";
				sevk_list="";
				diff_price_list="";
				product_price_list="";
				product_money_list="";
				configure_list="";
				is_property_list="";
				property_id_list = "";
				variation_id_list = "";
				total_min_list = "";
				total_max_list = "";
				tolerance_list = "";
				related_spect_main_id_list ="";
				related_spect_name_list =  "";
				line_number_list = "";
				dimension_list="";
				configurator_variation_id_list="";
				operation_type_id_list="";
				special_code_1 = attributes.special_code_1?: "";
				special_code_2 = attributes.special_code_2?: "";
				special_code_3 = attributes.special_code_3?: "";
				special_code_4 = attributes.special_code_4?: "";
				is_limited_stock = isdefined('attributes.is_limited_stock') ? 1 : 0;
				spect_file_name = attributes.spect_file_name?: "";
				old_files = attributes.old_files?: "";
				old_server_id = attributes.old_server_id?: "";
				del_attach = isdefined('attributes.del_attach') ? 1 : 0;
				spect_detail = attributes.spect_detail?:"";
				is_spect_name_to_property = attributes.is_spect_name_to_property?:"";
				process_stage = attributes.process_stage?:"";
				employee_id = (isdefined('attributes.employee_id') and isDefined("attributes.employee_name") and len(attributes.employee_name)) ? attributes.employee_id : "";
				save_date = attributes.save_date?:"";
				is_quality_tpye_list = '';
				quality_tpye_id_list = '';
				quality_standart_value_list = '';
				quality_quality_measure_list = '';
				quality_tolerance_list = '';
				diameter = attributes.diameter?: "";
				cap_unit = attributes.cap_unit?: "";
				width = attributes.width?: "";
				height = attributes.height?: "";
				width_unit = attributes.width_unit?: "";
				size = attributes.size?: "";
				size_unit = attributes.size_unit?: "";
				thickness = attributes.thickness?: ""; 
				inner_diameter = attributes.iccap?: "";
				outer_diameter = attributes.discap?: "";
				outer_unit = attributes.icdiscap_unit?: "";
				butt_sheet_thickness = attributes.butt_sheet_thickness?: "";
				butt_overlap = attributes.butt_overlap?: "";
				butt_seam_length = attributes.butt_seam_length?: "";
				butt_root_gap = attributes.butt_root_gap?: "";
				butt_cap = attributes.butt_cap?: "";
				butt_penetration = attributes.butt_penetration?: "";
				butt_steel_density = attributes.butt_steel_density?: "";
				single_butt_sheet_thickness = attributes.single_butt_sheet_thickness?: "";
				single_butt_seam_length = attributes.single_butt_seam_length?: "";
				single_butt_root_gap = attributes.single_butt_root_gap?: "";
				single_butt_cap = attributes.single_butt_cap?: "";
				single_butt_penetration = attributes.single_butt_penetration?: "";
				single_butt_overlap = attributes.single_butt_overlap?: "";
				single_butt_depth_of_root_face = attributes.single_butt_depth_of_root_face?: "";
				single_butt_alpha1 = attributes.single_butt_alpha1?: "";
				single_butt_alpha2 = attributes.single_butt_alpha2?: "";
				single_butt_steel_density = attributes.single_butt_steel_density?: "";
				double_butt_sheet_thickness = attributes.double_butt_sheet_thickness?: "";
				double_butt_seam_length = attributes.double_butt_seam_length?: "";
				double_butt_root_gap = attributes.double_butt_root_gap?: "";
				double_butt_cap = attributes.double_butt_cap?: "";
				double_butt_cap2 = attributes.double_butt_cap_2?: "";
				double_butt_seam_groove = attributes.double_butt_seam_groove?: "";
				double_butt_overlap = attributes.double_butt_overlap?: "";
				double_butt_depth_of_root_face = attributes.double_butt_depth_of_root_face?: "";
				double_butt_alpha1 = attributes.double_butt_alpha1?: "";
				double_butt_alpha2 = attributes.double_butt_alpha2?: "";
				double_butt_alpha3 = attributes.double_butt_alpha3?: "";
				double_butt_alpha4 = attributes.double_butt_alpha4?: "";
				double_butt_steel_density = attributes.double_butt_steel_density?: "";
				fillet_butt_sheet_thickness = attributes.fillet_butt_sheet_thickness?: "";
				fillet_butt_seam_length = attributes.fillet_butt_seam_length?: "";
				fillet_butt_cap = attributes.fillet_butt_cap?: "";
				fillet_butt_steel_density = attributes.fillet_butt_steel_density?: "";
				product_configurator_id = attributes.product_configurator_id?: "";
				if(isdefined('attributes.is_tree') and len(attributes.is_tree)) is_tree = attributes.is_tree; else is_tree = 1;
				if (isdefined("attributes.cat") and attributes.cat neq "||"){cat = ListGetAt(attributes.cat,1,'|')?: "";}
				else {cat="";}
				if (isdefined("attributes.quality") and attributes.quality neq "||"){quality = ListGetAt(attributes.quality,1,'|')?: "";}
				else {quality="";}
				welding_id = attributes.welding_id?: "";
				if( attributes.is_mix_product eq 0 and isdefined("attributes.tree_record_num")){//Karma koli değilse
					if(len(attributes.tree_record_num) and attributes.tree_record_num gt 0){//sarflar
						for(i=1;i lte attributes.tree_record_num;i=i+1)
						{
							if(isdefined("attributes.tree_row_kontrol#i#") and evaluate("attributes.tree_row_kontrol#i#") eq 1)
							{
								row_count=row_count+1;
								product_id_list = listappend(product_id_list,listgetat(evaluate("attributes.tree_product_id#i#"),1,','),',');
								if(listlen(evaluate("attributes.tree_product_id#i#")) gt 8)
									operation_type_id_list = listappend(operation_type_id_list,listgetat(evaluate("attributes.tree_product_id#i#"),9,','),',');
								else
									operation_type_id_list = listappend(operation_type_id_list,0,',');
								stock_id_list = listappend(stock_id_list,listgetat(evaluate("attributes.tree_product_id#i#"),2,','),',');
								product_name_list = listappend(product_name_list,listgetat(evaluate("attributes.tree_product_id#i#"),7,','),'|@|');
								if(isdefined("attributes.tree_amount#i#") and len(evaluate("attributes.tree_amount#i#")))
									amount_list=listappend(amount_list,evaluate("attributes.tree_amount#i#"),',');
								else
									amount_list=listappend(amount_list,0,',');
								if(isdefined("attributes.tree_is_sevk#i#")) sevk_list=listappend(sevk_list,1,','); else sevk_list=listappend(sevk_list,0,',');
								diff_price_list=listappend(diff_price_list,evaluate("attributes.tree_total_amount#i#"),',');
								product_price_list = listappend(product_price_list,Evaluate("attributes.tree_std_money#i#")/Evaluate("attributes.urun_para_birimi#ListGetAt(evaluate("attributes.tree_product_id#i#"),4)#"),',');
								product_money_list = listappend(product_money_list,listgetat(evaluate("attributes.tree_product_id#i#"),4,','),',');
								if(isdefined("attributes.tree_is_configure#i#")) configure_list=listappend(configure_list,1,','); else configure_list=listappend(configure_list,0,',');
								is_property_list=listappend(is_property_list,0,',');
								property_id_list =listappend(property_id_list,0,',');
								variation_id_list = listappend(variation_id_list,0,',');
								dimension_list = listappend(dimension_list,0,',');
								total_min_list =listappend(total_min_list,'-',',');
								total_max_list =listappend(total_max_list,'-',',');
								tolerance_list = listappend(tolerance_list,'-',',');
								if(len(Evaluate("attributes.related_spect_main_id#i#")))
								related_spect_main_id_list  = ListAppend(related_spect_main_id_list,Evaluate("attributes.related_spect_main_id#i#"),',');
								else
								related_spect_main_id_list  = ListAppend(related_spect_main_id_list,0,',');
								if(isdefined('attributes.line_number#i#') and Evaluate("attributes.line_number#i#") gt 0)
									line_number_list = ListAppend(line_number_list,Evaluate("attributes.line_number#i#"),',');
								else// if(isdefined('attributes.line_number#i#') and not len(Evaluate("attributes.line_number#i#")))	
									line_number_list = ListAppend(line_number_list,0,',');
								configurator_variation_id_list= listappend(configurator_variation_id_list,0,',');
								is_quality_tpye_list= listappend(is_quality_tpye_list,0,',');
								quality_tpye_id_list= listappend(quality_tpye_id_list,0,',');
								quality_standart_value_list= listappend(quality_standart_value_list,'-',',');
								quality_quality_measure_list= listappend(quality_quality_measure_list,'-',',');
								quality_tolerance_list= listappend(quality_tolerance_list,'-',',');
							}
						}
					}
				}else if(isdefined("attributes.record_num")){//Karma koliyse
					if(len(attributes.record_num) and attributes.record_num gt 0){
						for(i=1;i lte attributes.record_num;i=i+1)
						{
							if(isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1)
							{
								row_count=row_count+1;
								product_id_list = listappend(product_id_list,evaluate("attributes.product_id#i#"),',');
								operation_type_id_list = listappend(operation_type_id_list,evaluate("attributes.is_production#i#"),',');
								stock_id_list = listappend(stock_id_list,evaluate("attributes.stock_id#i#"),',');
								product_name_list = listappend(product_name_list,evaluate("attributes.product_name#i#"),'|@|');
								amount_list = (isdefined("attributes.row_amount#i#") and len(evaluate("attributes.row_amount#i#"))) ? listappend(amount_list,evaluate("attributes.row_amount#i#"),',') : listappend(amount_list,0,',');
								sevk_list = listappend(sevk_list,0,',');
								diff_price_list=listappend(diff_price_list,0,',');
								product_price_list = listappend(product_price_list,Evaluate("attributes.total_product_price#i#")/Evaluate("attributes.urun_para_birimi#ListGetAt(evaluate("attributes.product_money#i#"),1,';')#"),',');
								product_money_list = listappend(product_money_list,ListGetAt(evaluate("attributes.product_money#i#"),1,';'),',');
								configure_list=listappend(configure_list,0,',');
								is_property_list=listappend(is_property_list,0,',');
								property_id_list =listappend(property_id_list,0,',');
								variation_id_list = listappend(variation_id_list,0,',');
								dimension_list = listappend(dimension_list,0,',');
								total_min_list =listappend(total_min_list,'-',',');
								total_max_list =listappend(total_max_list,'-',',');
								tolerance_list = listappend(tolerance_list,'-',',');
								if(len(Evaluate("attributes.spec_main_id#i#")))
								related_spect_main_id_list  = ListAppend(related_spect_main_id_list,Evaluate("attributes.spec_main_id#i#"),',');
								else
								related_spect_main_id_list  = ListAppend(related_spect_main_id_list,0,',');
								line_number_list = (isdefined('attributes.line_number#i#') and Evaluate("attributes.line_number#i#") gt 0) ? ListAppend(line_number_list,Evaluate("attributes.line_number#i#"),',') : ListAppend(line_number_list,0,',');
								configurator_variation_id_list= listappend(configurator_variation_id_list,0,',');
								is_quality_tpye_list= listappend(is_quality_tpye_list,0,',');
								quality_tpye_id_list= listappend(quality_tpye_id_list,0,',');
								quality_standart_value_list= listappend(quality_standart_value_list,'-',',');
								quality_quality_measure_list= listappend(quality_quality_measure_list,'-',',');
								quality_tolerance_list= listappend(quality_tolerance_list,'-',',');
							}
						}
					}
				}
			</cfscript>
			<cfif not isdefined("attributes.is_old_style") and isdefined("attributes.product_configurator_id") and len(attributes.product_configurator_id)>
				<cfset property_counter = 0 />
				<cfquery name="get_conf_compenents" datasource="#dsn3#">
					SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_COMPONENTS WHERE PRODUCT_CONFIGURATOR_ID = #attributes.product_configurator_id# ORDER BY ORDER_NO
				</cfquery>
				<cfquery name="get_conf_variations" datasource="#dsn3#">
					SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE PRODUCT_CONFIGURATOR_ID = #attributes.product_configurator_id#
				</cfquery>
				<cfoutput query="get_conf_compenents">
					<cfset price_type_ = get_conf_compenents.price_type>
					<cfset property_id_ = get_conf_compenents.property_id>
					<cfset property_id_row_ = get_conf_compenents.property_id_row>
					<cfset amount_type_ = get_conf_compenents.amount_type>
					<cfset require_type_ = get_conf_compenents.require_type>
					<cfset formula_id_ = get_conf_compenents.formula_id>
					<cfset amount_ = get_conf_compenents.amount>
					<cfset row_id_ = get_conf_compenents.product_configurator_compenents_id>
					<cfif (require_type_ neq 1 and isdefined("attributes.req_type_#row_id_#") and evaluate("attributes.req_type_#row_id_#") eq 1) or require_type_ eq 1>
						<cfif listfind('1,2',amount_type_)>
							<cfset property_id_list = listappend(property_id_list,property_id_)>
							<cfset amount_list = listappend(amount_list,filternum(evaluate("attributes.amount_#row_id_#")))>
							<cfset variation_id_list = listappend(variation_id_list,0)>
							<cfset property_counter++ />
						<cfelseif listfind('3',amount_type_)>
							<cfset property_id_list = listappend(property_id_list,property_id_)>
							<cfset amount_list = listappend(amount_list,filternum(evaluate("attributes.amount_value_#row_id_#")))>
							<cfset variation_id_list = listappend(variation_id_list,0)>
							<cfset property_counter++ />
						<cfelseif listfind('4,5',amount_type_)>
							<cfquery name="get_conf_variation_row" dbtype="query">
								SELECT * FROM get_conf_variations WHERE PRODUCT_COMPENENT_ID = #row_id_#
							</cfquery>
							<cfloop query="get_conf_variation_row">
								<cfif (amount_type_ eq 4 and evaluate("attributes.configurator_variation_id_#row_id_#") and not listfind(variation_id_list,evaluate("attributes.configurator_variation_id_#row_id_#")))>
									<cfset property_id_list = listappend(property_id_list,property_id_)>
									<cfset variation_id_list = listappend(variation_id_list,evaluate("attributes.configurator_variation_id_#row_id_#"))>
									<cfset amount_list = listappend(amount_list,filternum(evaluate("attributes.variation_value_#row_id_#_#variation_property_detail_id#")))>
									<cfset property_counter++ />
								<cfelseif amount_type_ neq 4>
									<cfset property_id_list = listappend(property_id_list,property_id_)>
									<cfset variation_id_list = listappend(variation_id_list,get_conf_variation_row.variation_property_detail_id)>
									<cfset amount_list = listappend(amount_list,filternum(evaluate("attributes.variation_value_#row_id_#_#variation_property_detail_id#")))>
									<cfset property_counter++ />
								</cfif>
							</cfloop>
						<cfelseif listfind('6',amount_type_)>
							<cfquery name="get_conf_formula" datasource="#dsn3#">
								SELECT * FROM SETUP_PRODUCT_FORMULA_COMPONENTS WHERE PRODUCT_FORMULA_ID = #formula_id_#
							</cfquery>
							<cfloop query="get_conf_formula">
								<cfset amount_type_formula = get_conf_formula.amount_type>
								<cfset amount_formula = get_conf_formula.amount>
								<cfset property_detail_row_id = get_conf_formula.property_id>
								<cfif listfind('1',amount_type_formula)>
									<cfset property_id_list = listappend(property_id_list,property_detail_row_id)>
									<cfset amount_list = listappend(amount_list,filternum(evaluate("attributes.amount_formula_#row_id_#_#property_detail_row_id#")))>
									<cfset variation_id_list = listappend(variation_id_list,0)>
									<cfset property_counter++ />
								<cfelseif listfind('4',amount_type_formula)>
									<cfquery name="get_conf_variation_formula" datasource="#dsn3#">
										SELECT * FROM SETUP_PRODUCT_FORMULA_VARIATION WHERE PRODUCT_FORMULA_ID = #formula_id_#
									</cfquery>
									<cfloop query="get_conf_variation_formula">
										<cfif (amount_type_formula eq 4 and evaluate("attributes.configurator_variation_id_formula_#row_id_#") and not listfind(variation_id_list,evaluate("attributes.configurator_variation_id_formula_#row_id_#")))>
											<cfset property_id_list = listappend(property_id_list,evaluate("attributes.configurator_variation_id_formula_#row_id_#"))>
											<cfset variation_id_list = listappend(variation_id_list,get_conf_variation_formula.property_detail_row_id)>
											<cfset amount_list = listappend(amount_list,filternum(evaluate("attributes.variation_value_formula_#row_id_#_#property_detail_row_id#")))>
											<cfset property_counter++ />
										<cfelseif amount_type_formula neq 4>
											<cfset property_id_list = listappend(property_id_list,property_detail_row_id)>
											<cfset variation_id_list = listappend(variation_id_list,get_conf_variation_formula.property_detail_row_id)>
											<cfset amount_list = listappend(amount_list,filternum(evaluate("attributes.variation_value_formula_#row_id_#_#property_detail_row_id#")))>
											<cfset property_counter++ />
										</cfif>
									</cfloop>
								</cfif>
							</cfloop>
						</cfif>
					</cfif>
				</cfoutput>

				<cfloop from="1" to="#property_counter#" index="kk">
					<cfscript>
						sevk_list=listappend(sevk_list,0,',');
						diff_price_list=listappend(diff_price_list,0,',');
						configure_list=listappend(configure_list,0,',');
						is_property_list=listappend(is_property_list,1,',');
						product_id_list = listappend(product_id_list,0,',');
						stock_id_list = listappend(stock_id_list,0,',');
						total_min_list =listappend(total_min_list,'-',',');
						total_max_list =listappend(total_max_list,'-',',');
						tolerance_list =listappend(tolerance_list,'-',',');
						related_spect_main_id_list  = ListAppend(related_spect_main_id_list,0,',');
						operation_type_id_list = listappend(operation_type_id_list,0,',');
						dimension_list = listappend(dimension_list,0,',');
						product_price_list = listappend(product_price_list,0,',');
						product_money_list = listappend(product_money_list,session.ep.money,',');
						is_quality_tpye_list= listappend(is_quality_tpye_list,0,',');
						quality_tpye_id_list= listappend(quality_tpye_id_list,0,',');
						quality_standart_value_list= listappend(quality_standart_value_list,'-',',');
						quality_quality_measure_list= listappend(quality_quality_measure_list,'-',',');
						quality_tolerance_list= listappend(quality_tolerance_list,'-',',');
					</cfscript>
				</cfloop>

				<cfif IsDefined("attributes.testParameterCount") and attributes.testParameterCount gt 0>
					<cfquery name="get_conf_test_parameters" datasource="#dsn3#">
						SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_PARAMETER WHERE PRODUCT_CONFIGURATOR_ID = <cfqueryparam value = "#attributes.product_configurator_id#" CFSQLType = "cf_sql_integer">
					</cfquery>
					<cfif get_conf_test_parameters.recordcount and attributes.tree_record_num gt 0>
						<cfoutput query="get_conf_test_parameters">
							<cfset row_id = PRODUCT_CONFIGURATOR_PARAMETER_ID />
							<cfset is_quality_tpye_list = listappend(is_quality_tpye_list,1,',') />
							<cfset quality_tpye_id_list = listappend(quality_tpye_id_list,get_conf_test_parameters.TYPE_ID)>
							<cfset quality_standart_value_list = listappend(quality_standart_value_list,filternum(evaluate("attributes.standart_value#row_id#")))>
							<cfset quality_quality_measure_list = listappend(quality_quality_measure_list,filternum(evaluate("attributes.quality_measure#row_id#")))>
							<cfset quality_tolerance_list = listappend(quality_tolerance_list,filternum(evaluate("attributes.quality_tolerance#row_id#")))>
							<cfscript>
								sevk_list=listappend(sevk_list,0,',');
								diff_price_list=listappend(diff_price_list,0,',');
								configure_list=listappend(configure_list,0,',');
								is_property_list=listappend(is_property_list,1,',');
								product_id_list = listappend(product_id_list,0,',');
								stock_id_list = listappend(stock_id_list,0,',');
								total_min_list =listappend(total_min_list,'-',',');
								total_max_list =listappend(total_max_list,'-',',');
								tolerance_list =listappend(tolerance_list,'-',',');
								related_spect_main_id_list  = ListAppend(related_spect_main_id_list,0,',');
								operation_type_id_list = listappend(operation_type_id_list,0,',');
								dimension_list = listappend(dimension_list,0,',');
								product_price_list = listappend(product_price_list,0,',');
								product_money_list = listappend(product_money_list,session.ep.money,',');
								property_id_list = listappend(property_id_list,0,',');
								variation_id_list = listappend(variation_id_list,0,',');
								amount_list = listappend(amount_list,0,',');
							</cfscript>
						</cfoutput>
					</cfif>
				</cfif>
			</cfif>

			<cfset row_count = listlen(property_id_list)>

			<cfscript>
				if(isdefined('attributes.pro_record_num') and len(attributes.pro_record_num) and attributes.pro_record_num gt 0)//özellikler
				{
					for(i=1;i lte attributes.pro_record_num;i=i+1)
					{				
						if(isdefined('attributes.is_active#i#') and Evaluate('attributes.is_active#i#') eq 1)
						{
							row_count=row_count+1;
							product_id_list = listappend(product_id_list,0,',');
							operation_type_id_list = listappend(operation_type_id_list,0,',');
							stock_id_list = listappend(stock_id_list,0,',');
							if(len(evaluate("attributes.pro_product_name#i#")))
								product_name_list = listappend(product_name_list,evaluate("attributes.pro_product_name#i#"),'|@|');
							else
								product_name_list = listappend(product_name_list,'-','|@|');
							if(isdefined("attributes.pro_amount#i#") and len(Evaluate("attributes.pro_amount#i#")))
								amount_list=listappend(amount_list,evaluate("attributes.pro_amount#i#"),',');
							else
								amount_list=listappend(amount_list,0,',');
							sevk_list=listappend(sevk_list,0,',');
							diff_price_list=listappend(diff_price_list,0,',');
							if(isdefined('attributes.pro_total_amount#i#'))
								product_price_list = listappend(product_price_list,evaluate("attributes.pro_total_amount#i#"),',');
							else
								product_price_list = listappend(product_price_list,0,',');
							if(isdefined('attributes.pro_total_amount#i#'))
								product_money_list = listappend(product_money_list,listgetat(evaluate("attributes.pro_money_type#i#"),3,','),',');
							else
								product_money_list = listappend(product_money_list,session.ep.money,',');
							configure_list=listappend(configure_list,0,',');
							is_property_list=listappend(is_property_list,1,',');
							
							if(not isdefined("attributes.is_old_style"))
								property_id_list =listappend(property_id_list,evaluate("attributes.pro_property_id_new#i#"),',');
							else
								property_id_list =listappend(property_id_list,evaluate("attributes.pro_property_id#i#"),',');
							
							if(isdefined("attributes.pro_variation_id#i#") and len(evaluate("attributes.pro_variation_id#i#")))
								variation_id_list = listappend(variation_id_list,evaluate("attributes.pro_variation_id#i#"),',');
							else
								variation_id_list = listappend(variation_id_list,0,',');
							
							if(isdefined("attributes.pro_dimension#i#") and len(evaluate("attributes.pro_dimension#i#")))
								dimension_list = listappend(dimension_list,evaluate("attributes.pro_dimension#i#"),',');
							else
								dimension_list = listappend(dimension_list,0,',');
							if(isdefined("attributes.pro_total_min#i#") and len(evaluate("attributes.pro_total_min#i#")))
								total_min_list =listappend(total_min_list,evaluate("attributes.pro_total_min#i#"),',');
							else
								total_min_list =listappend(total_min_list,'-',',');
							if(isdefined("attributes.pro_total_max#i#") and len(evaluate("attributes.pro_total_max#i#")))
								total_max_list =listappend(total_max_list,evaluate("attributes.pro_total_max#i#"),',');
							else
								total_max_list =listappend(total_max_list,'-',',');
							if(isdefined("attributes.pro_tolerance#i#") and len(evaluate("attributes.pro_tolerance#i#")))
								tolerance_list =listappend(tolerance_list,evaluate("attributes.pro_tolerance#i#"),',');
							else
								tolerance_list =listappend(tolerance_list,'-',',');
							related_spect_main_id_list  = ListAppend(related_spect_main_id_list,0,',');
							if(isdefined("attributes.pro_conf_variation_id#i#"))
								configurator_variation_id_list = ListAppend(configurator_variation_id_list,evaluate("attributes.pro_conf_variation_id#i#"),',');
							is_quality_tpye_list= listappend(is_quality_tpye_list,0,',');
							quality_tpye_id_list= listappend(quality_tpye_id_list,0,',');
							quality_standart_value_list= listappend(quality_standart_value_list,'-',',');
							quality_quality_measure_list= listappend(quality_quality_measure_list,'-',',');
							quality_tolerance_list= listappend(quality_tolerance_list,'-',',');
						}
					}
				}
			</cfscript>
			<cfscript>
				money_list="";
				money_rate1_list="";
				money_rate2_list="";
				spec_money_select=attributes.doviz_name?: "";
				if(isdefined("attributes.rd_money_num") and attributes.rd_money_num gt 0)
				{
					for(i=1;i lte attributes.rd_money_num;i=i+1)
					{
						money_list = listappend(money_list,evaluate("attributes.rd_money_name_#i#"),',');
						money_rate1_list = listappend(money_rate1_list,evaluate("attributes.txt_rate1_#i#"),',');
						money_rate2_list = listappend(money_rate2_list,evaluate("attributes.txt_rate2_#i#"),',');
					}
				}

				//guncelleme sayfasından geliyor ise
				if(isdefined('attributes.is_update') and attributes.is_update eq 1){is_update=1;}
				else {is_update=''; attributes.spect_id='';}

				if(not isdefined('attributes.add_main_spect'))//main spec ekleme sayfasından gelmiyorsa normal olarak spect ekleniyor
				{
					specer_return_value_list=specer(
						dsn_type : dsn3,
						spec_type : 1,
						insert_spec : iif(len(is_update),0,1),
						spec_id : iif(len(is_update),de('#attributes.spect_id#'),de('')),
						main_stock_id : main_stock_id,
						main_product_id : main_product_id,
						spec_name : spec_name,
						spec_total_value : spec_total_value,
						main_prod_price  : main_prod_price ,
						main_product_money : main_product_money,
						spec_other_total_value : spec_other_total_value,
						other_money : other_money,
						money_list : money_list,
						money_rate1_list : money_rate1_list,
						money_rate2_list : money_rate2_list,
						spec_row_count : row_count,
						stock_id_list : stock_id_list,
						product_id_list : product_id_list,
						product_name_list : product_name_list,
						amount_list : amount_list,
						is_sevk_list : sevk_list,
						is_configure_list : configure_list,
						is_property_list : is_property_list,
						property_id_list : property_id_list,
						variation_id_list : variation_id_list,
						total_min_list : total_min_list,
						total_max_list : total_max_list,
						diff_price_list : diff_price_list,
						product_price_list : product_price_list,
						product_money_list : product_money_list,
						tolerance_list : tolerance_list,
						related_spect_id_list : related_spect_main_id_list,
						spect_file_name : spect_file_name,
						old_files : old_files,
						old_server_id : old_server_id,
						del_attach : del_attach,
						spect_detail : spect_detail,
						line_number_list : line_number_list,
						dimension_list:dimension_list,
						configurator_variation_id_list:configurator_variation_id_list,
						is_limited_stock : is_limited_stock,
						special_code_1 : special_code_1,
						special_code_2 : special_code_2,
						special_code_3 : special_code_3,
						special_code_4 : special_code_4,
						is_add_same_name_spect : attributes.is_add_same_name_spect,
						operation_type_id_list : operation_type_id_list,
						is_spect_name_to_property : is_spect_name_to_property,
						process_stage : process_stage,
						employee_id : employee_id,
						save_date : save_date,
						is_quality_tpye_list: is_quality_tpye_list,
						quality_tpye_id_list : quality_tpye_id_list,
						quality_standart_value_list : quality_standart_value_list,
						quality_quality_measure_list : quality_quality_measure_list,
						quality_tolerance_list : quality_tolerance_list,
						is_mix_product: attributes.is_mix_product,
						product_configurator_id : product_configurator_id,
						is_tree : is_tree
					);	
				}
				else if(isdefined('attributes.add_main_spect'))//main spect sayfasından geliyor ise sadece main spect eklemesi yapıcaz...
				{
					
					specer_return_value_list=specer(
						dsn_type: dsn3,
						spec_type: 1,
						spec_is_tree: 0,
						only_main_spec: 1,
						main_stock_id: main_stock_id,
						main_product_id: main_product_id,
						spec_name: spec_name,
						spec_row_count: row_count,
						stock_id_list: stock_id_list,
						product_id_list: product_id_list,
						product_name_list: product_name_list,
						amount_list: amount_list,
						is_sevk_list: sevk_list,	
						is_configure_list: configure_list,
						is_property_list: is_property_list,
						property_id_list: property_id_list,
						variation_id_list: variation_id_list,
						total_min_list: total_min_list,
						total_max_list : total_max_list,
						tolerance_list : tolerance_list,
						related_spect_id_list : related_spect_main_id_list,
						spect_file_name : spect_file_name,
						old_files : old_files,
						old_server_id : old_server_id,
						del_attach : del_attach,
						spect_detail : spect_detail,
						spect_status : 1,
						line_number_list : line_number_list,
						dimension_list:dimension_list,
						configurator_variation_id_list:configurator_variation_id_list,
						is_limited_stock : is_limited_stock,
						special_code_1 : special_code_1,special_code_2 : special_code_2,special_code_3 : special_code_3,special_code_4 : special_code_4,
						is_add_same_name_spect : attributes.is_add_same_name_spect,
						operation_type_id_list : operation_type_id_list,
						is_spect_name_to_property : is_spect_name_to_property,
						process_stage : process_stage,
						employee_id : employee_id,
						save_date : save_date,
						is_quality_tpye_list: is_quality_tpye_list,
						quality_tpye_id_list : quality_tpye_id_list,
						quality_standart_value_list : quality_standart_value_list,
						quality_quality_measure_list : quality_quality_measure_list,
						quality_tolerance_list : quality_tolerance_list,
						is_mix_product: attributes.is_mix_product,
						product_configurator_id : product_configurator_id,
						is_tree : is_tree
					);
				}
			</cfscript>
			<cfscript>
				//XML=>Spect Adını =>Konfigüre Edilen Ürünlerden Oluştur Denilmiş ise
				if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1)
				{
					GetProductConf(listgetat(specer_return_value_list,1,','));
				}
				else if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 2)
				{
					GetProductConf_comp(listgetat(specer_return_value_list,1,','));
				}
				if(isdefined("specer_return_value_list"))
					new_spect_var_name = listgetat(specer_return_value_list,3,',');					
			</cfscript>
			<cfif isdefined('attributes.is_spect_name_to_property') and (attributes.is_spect_name_to_property eq 1 or attributes.is_spect_name_to_property eq 2)>
				<cfquery name="UpdateSpecNameQuery" datasource="#dsn3#">
					UPDATE SPECT_MAIN SET SPECT_MAIN_NAME = '#left(configure_spec_name,499)#' WHERE SPECT_MAIN_ID = #listgetat(specer_return_value_list,1,',')#              
				</cfquery>
				<cfif len(listgetat(specer_return_value_list,1,',')) and listgetat(specer_return_value_list,1,',') gt 0>
					<cfquery name="UpdateS_V_SpecNameQuery" datasource="#dsn3#">
						UPDATE SPECTS SET SPECT_VAR_NAME = '#left(configure_spec_name,499)#' WHERE SPECT_VAR_ID = #listgetat(specer_return_value_list,2,',')#
					</cfquery>
				</cfif>
				<cfset new_spect_var_name = left(configure_spec_name,499)>
			</cfif>
		</cftransaction>
	</cflock>
	<cfinclude template="../../../WBP/Plpc/Files/add_welding_form_plpc.cfm">
    <cfif isdefined("attributes.new_price") and len(attributes.new_price)>
		<script type="text/javascript">
			<cfoutput>
				<cfif isdefined("attributes.row_id")>
					var satir = <cfoutput>#isdefined("attributes.row_id") and len(attributes.row_id) ? attributes.row_id : -1#</cfoutput>;
					if(<cfif not isDefined("attributes.draggable")>window.opener.</cfif>basket && satir > -1) 
					{
						<cfif not isDefined("attributes.draggable")>window.opener.</cfif>updateBasketItemFromPopup(satir, 
						{ 
							SPECT_ID: '#listgetat(specer_return_value_list,2,',')#', 
							SPECT_NAME: '#new_spect_var_name#' 
							<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
								,PRICE_OTHER: '#attributes.new_price#'
							</cfif>  
						});
						<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
							<cfif not isDefined("attributes.draggable")>opener.</cfif>hesapla('price_other',#attributes.row_id#);
						</cfif>
					}
				</cfif>
				<cfif isDefined("attributes.draggable") and isDefined("attributes.modal_id")>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')<cfelse>window.close()</cfif>;
			</cfoutput>
		</script>
	<cfelse>
		<cfif isdefined("attributes.from_product_config")>
				<cfquery name="GET_SPECTS_PRODUCT" datasource="#DSN3#" maxrows="1">
					SELECT 
						P.PRODUCT_ID,
						PU.UNIT_MULTIPLIER,
						PU.PRODUCT_UNIT_ID,
						S.STOCK_CODE,
						S.BARCOD,
						S.MANUFACT_CODE,
						P.PRODUCT_NAME,
						S.TAX
					FROM
						STOCKS S,
						PRODUCT P,
						PRODUCT_UNIT PU
					WHERE
						S.PRODUCT_ID=P.PRODUCT_ID
						AND P.PRODUCT_ID=PU.PRODUCT_ID
						AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
				</cfquery>
			<cfscript>
				attributes.product_id=GET_SPECTS_PRODUCT.product_id;
				attributes.unit_multiplier=GET_SPECTS_PRODUCT.UNIT_MULTIPLIER;
				attributes.unit_id=GET_SPECTS_PRODUCT.PRODUCT_UNIT_ID;
				attributes.stock_code=GET_SPECTS_PRODUCT.stock_code;
				attributes.barcod=GET_SPECTS_PRODUCT.barcod;
				attributes.manufact_code=GET_SPECTS_PRODUCT.manufact_code;
				attributes.product_name=GET_SPECTS_PRODUCT.product_name;
				attributes.tax=GET_SPECTS_PRODUCT.tax;
				attributes.amount=1;
				attributes.price_catid=-2;
			</cfscript>
			<cfinclude template="add_basket_row_js.cfm">
	</cfif>
		<cfinclude template="../form/add_spec_js.cfm">
	</cfif>
</cfif>