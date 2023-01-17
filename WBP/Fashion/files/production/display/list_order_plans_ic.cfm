<cf_get_lang_set module_name="prod">
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
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%textile.tracking%">
		ORDER BY
			PT.PROCESS_NAME,
			PTR.LINE_NUMBER
	</cfquery>
	<cfquery name="GET_W" datasource="#dsn#">
		SELECT 
			STATION_ID,
			STATION_NAME,
			ISNULL(EXIT_DEP_ID,0) AS EXIT_DEP_ID,
			ISNULL(EXIT_LOC_ID,0) AS EXIT_LOC_ID,
			ISNULL(PRODUCTION_DEP_ID,0) AS PRODUCTION_DEP_ID,
			ISNULL(PRODUCTION_LOC_ID,0) AS PRODUCTION_LOC_ID
		FROM 
			#dsn3_alias#.WORKSTATIONS 
		<!---WHERE 
			DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# ) --->
		ORDER BY 
			STATION_NAME ASC
	</cfquery>
	
	<cf_grid_list id="list_order_big_list">
		<thead>
				<tr>
					<th></th>
					<th>S <cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58080.Resim'></th>
					<th><cf_get_lang dictionary_id='57611.Sipariş'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='36787.Teslim'></th>
					<th><cf_get_lang dictionary_id='62603.Numune'> <cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='62561.Müşteri Order No'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
					<th><cf_get_lang dictionary_id='58847.Marka'></th>
					<th><cf_get_lang dictionary_id='57457.Müşteri'></th>
					<th><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th><cf_get_lang dictionary_id='57636.Birim'></th>
					<th><cf_get_lang dictionary_id='33021.Marj'></th>
					<th><cf_get_lang dictionary_id='60554.Operasyon Miktarı'></th>
					<th><cf_get_lang dictionary_id='321.Üretilen Miktar'></th>
					<th colspan="3" width="15">&nbsp;</th>
				</tr>
		</thead>
		<cfif get_orders.recordcount>
			<cfset company_name_list =''>
			<cfset consumer_name_list =''>
			<cfset spect_name_list =''>
			<cfset order_row_id_list=''>
			<cfset plan_id_list=''>
			<cfset renk_id_list=''>
			<cfset stock_id_list=''>
			<cfset imagepathlist="">
			<cfoutput query="get_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(req_id) and not listfind(imagepathlist,req_id)>
					<cfset imagepathlist=listAppend(imagepathlist,req_id)>
				</cfif>
				<cfif len(ORDER_ROW_ID)>
					<cfset order_row_id_list = ListAppend(order_row_id_list,ORDER_ROW_ID)>
				</cfif>
				<cfif len(PLAN_ID)>
					<cfset plan_id_list = ListAppend(plan_id_list,PLAN_ID)>
				</cfif>
				<cfif len(RENK_ID)>
					<cfset renk_id_list = ListAppend(renk_id_list,RENK_ID)>
				</cfif>
				<cfif len(COMPANY_ID) and not listfind(company_name_list,COMPANY_ID)>
					<cfset company_name_list = ListAppend(company_name_list,COMPANY_ID)>
				</cfif>
				<cfif len(CONSUMER_ID) and not listfind(consumer_name_list,CONSUMER_ID)>
					  <cfset consumer_name_list = ListAppend(consumer_name_list,CONSUMER_ID)>
				</cfif>
				<cfif len(SPECT_VAR_ID) and not listfind(spect_name_list,SPECT_VAR_ID)>
					<cfset spect_name_list = ListAppend(spect_name_list,SPECT_VAR_ID)>
				</cfif>
				<cfif len(STOCK_ID) and not listfind(stock_id_list,STOCK_ID)>
					<cfset stock_id_list = listappend(stock_id_list,STOCK_ID)>
				</cfif>
			</cfoutput>
			
			<cfif len(company_name_list)>
				<cfset company_name_list=listsort(company_name_list,"numeric","ASC",",")>
				<cfquery name="get_company_name" datasource="#DSN#">
					SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_name_list#) ORDER BY COMPANY_ID
				</cfquery>
				<cfset company_name_list = listsort(listdeleteduplicates(valuelist(get_company_name.COMPANY_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(consumer_name_list)>
				<cfset consumer_name_list=listsort(consumer_name_list,"numeric","ASC",",")>
				<cfquery name="get_consumer_name" datasource="#DSN#">
					SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME AS CONSUMER_NAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_name_list#) ORDER BY CONSUMER_ID
				</cfquery>
				<cfset consumer_name_list = listsort(listdeleteduplicates(valuelist(get_consumer_name.CONSUMER_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(order_row_id_list)>
				<cfset order_row_id_list=listsort(order_row_id_list,"numeric","ASC",",")>
				<cfquery name="GET_PRODUCTION_INFO" datasource="#DSN3#">
					SELECT 
						ISNULL(SUM(PO.QUANTITY),0) AS QUANTITY,
						POR.ORDER_ROW_ID,
						ISNULL(POR.TYPE,1) AS TYPE 
					FROM 
						PRODUCTION_ORDERS PO,
						PRODUCTION_ORDERS_ROW POR,
						ORDER_ROW OR_
					WHERE
						OR_.ORDER_ROW_ID =POR.ORDER_ROW_ID AND
						OR_.STOCK_ID = PO.STOCK_ID AND
						PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID
						AND POR.ORDER_ROW_ID IN (#order_row_id_list#)
					GROUP BY 
						POR.ORDER_ROW_ID,
						POR.TYPE
				</cfquery>
				<cfscript>
					for(gpi_ind=1;gpi_ind lte GET_PRODUCTION_INFO.recordcount;gpi_ind=gpi_ind+1){//ayrı ayrı göstereceğimiz için grupladık
						if(GET_PRODUCTION_INFO.TYPE[gpi_ind] eq 1)
							'verilen_uretim_emri_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' = GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
						else
							'verilen_talep_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' = GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
						if(not isdefined('toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#'))
							'toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' =GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
						else
							'toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' = Evaluate('toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#')+GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
					}
				</cfscript>
			</cfif>
			<cfset _now_ = date_add('h',session.ep.TIME_ZONE,now())>	
			<cfquery name="get_station_times" datasource="#dsn#">
				SELECT * FROM SETUP_SHIFTS WHERE IS_PRODUCTION = 1 AND FINISHDATE > #_now_#
			</cfquery>
			<cfset works_prog = get_station_times.SHIFT_NAME>
			<cfset works_prog_id = get_station_times.SHIFT_ID>
			<cfset url_="">
			<cfset url_ = "#file_web_path#product/">
			<cfset uploadFolder = application.systemParam.systemParam().upload_folder />
			<cfset path = "#upload_folder#product#dir_seperator#">
			<cfoutput query="get_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tbody>
						<cfif isdefined('toplam_#PLAN_ID#')>
							<cfset kalan_uretim_emri = QUANTITY-Evaluate('toplam_#PLAN_ID#')>
						<cfelse>
							<cfset kalan_uretim_emri = QUANTITY>
						</cfif>
				<tr>
					<!-- sil -->
						<td align="center" id="order_row#currentrow#" onClick="gizle_goster(order_stocks_color_detail#currentrow#);connectAjaxDetail('#currentrow#','#PRODUCT_ID#','#STOCK_ID#','#kalan_uretim_emri#','#ORDER_ID#','','','#operasyon_id#','#plan_id#');gizle_goster(order_stocks_color_gizle#currentrow#);gizle_goster(order_stocks_color_goster#currentrow#);">
							<i id="order_stocks_color_goster#currentrow#" class="fa fa-chevron-circle-right fa-2x" aria-hidden="true" title="<cf_get_lang_main no ='1184.Göster'>"></i>	
							<i id="order_stocks_color_gizle#currentrow#" class="fa fa-chevron-circle-down fa-2x"  title="<cf_get_lang_main no ='1216.Gizle'>" style="display:none;"></i>
						</td>
					<!-- sil -->
					<td>#currentrow# </td>
					<td>
						<cfset assetFileName=asset_file_name>
						<cfset asset_id=asset_id>
						<cfset assetcat_id=assetcat_id>
						<cfset file_path = '#path##assetFileName#'>
						<cfif len(assetFileName) and FileExists(file_path)>
							<cfif len(assetFileName) and FileExists("#uploadFolder#thumbnails/middle/#assetFileName#")>
								<cfset imagePath = "documents/thumbnails/middle/#assetFileName#">
							<cfelse>
								<cfset imagePath = "documents/thumbnails/middle/#assetFileName#" />
							</cfif>
							<cfset icon = false>
						<cfelse>
							<cfset imagePath = "images/intranet/no-image.png">
							<cfset icon = true>
						</cfif>
						<div class="image">
							<cfif icon>
								<img src="#imagePath#" style="margin-left: 10px; width:70px; height:50px;">
							<cfelse>
							<cfset ext=lcase(listlast(assetFileName, '.')) />
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##assetFileName#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');">
									<img src="#imagePath#" style="margin: 10px; width:100px;" >
								</a>
							</cfif>
						</div>
					</td>
					<td nowrap="nowrap">
							<a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#">#order_number#</a>
					</td>
					<td> #dateformat(order_date,'dd/mm/yyyy')#</td>
					<td>
						<cfif is_show_delivery_date eq 1 and len(row_deliver_date)>
							#dateformat(row_deliver_date,'dd/mm/yyyy')#
						<cfelse>
							#dateformat(deliverdate,'dd/mm/yyyy')#
						</cfif>
					</td>
					<td>#REQ_HEAD#</td>
					<td>#PRODUCT_CODE#</td>
					<td>#PRODUCT_CODE_2#</td>
					<td></td>
					<td>#company_order_no#</td>
					<td>
					<cfif len(COMPANY_ID)>
						#get_company_name.FULLNAME[listfind(company_name_list,get_orders.COMPANY_ID,',')]#
					<cfelseif len(CONSUMER_ID)>
						#get_consumer_name.CONSUMER_NAME[listfind(consumer_name_list,get_orders.CONSUMER_ID,',')]#
					</cfif>
					</td>
					<td>#project_head# <input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#project_id#"><input type="hidden" name="req_id#currentrow#" id="req_id#currentrow#" value="#req_id#"></td>
					<td>#short_code#</td>
					<td>#project_company#</td>
					<td style="text-align:right;">
						#tlformat(QUANTITY)#
						<input type="hidden" name="orj_production_amount_grup#currentrow#" id="orj_production_amount_grup#currentrow#" value="#kalan_uretim_emri#"> 
					</td>
					<td>#unit#</td>
					<td><input type="text" name="marj_amount#currentrow#" id="marj_amount#currentrow#" style="width:50px;float:right; border:none;" class="moneybox" onblur="amount_marj('#currentrow#');" value="#tlformat(marj)#" readonly></td>
					  <cfset attributes.stock_id=stock_id>
					  <cfset attributes.order_id=order_id>
					<td style="text-align:right;">
						<cfif  not len(operation_amount) or operation_amount eq 0>
							<cfset op_amount=quantity>
						<cfelse>
							<cfset op_amount=operation_amount>
						</cfif>
						<input type="text" class="box" name="production_amount_grup#currentrow#" id="production_amount_grup#currentrow#" style="width:65px;float:right;" value="#tlformat(op_amount)#" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,3));">
					</td>
					<td nowrap style="text-align:right;">
						
						#TLFORMAT(FINISH_RESULT_AMOUNT)#
					</td>
					<!-- sil -->
	
						<td align="center" nowrap >
							<cfif is_send neq 1>
								<a href="javascript://" onClick="operasyon_dagit('#currentrow#','#PRODUCT_ID#','#STOCK_ID#','#kalan_uretim_emri#','#ORDER_ID#','','','#operasyon_id#','#plan_id#','#req_no#','#order_number#');"><i class="fa fa-paper-plane-o fa-2x" aria-hidden="true" title="Operasyon Başlat"></i></a>
							<cfelse>
								<a href="javascript://" onclick="operasyon_detay('#main_operation_id#','#req_id#','#order_id#','#order_number#')"><i class="fa fa-cog fa-2x" aria-hidden="true" title="Operasyon Dağıtım Görüntüle"></i></a>
							</cfif>
						</td>
						<td>
								<a href="javascript://" disabled onclick="ue_detay('#main_operation_id#','#req_id#','#order_id#','#order_number#')"><i class="fa fa-cogs fa-2x" aria-hidden="true" title="İlişkili  Ü.Emirleri Listele"></i> </a>
						</td>
						<td>
							<input type="hidden" name="row#currentrow#" id="row#currentrow#" value="#order_id#-#req_id#">
							<input type="hidden" id="order_id#currentrow#" name="order_id#currentrow#" value="#order_id#">
							<input type="hidden" id="product_id#currentrow#" name="product_id#currentrow#" value="#product_id#">
							<a href="javascript:void(0);" onclick="demand_convert_to_production(3, #currentrow#)"><i class="fa fa-cubes fa-2x" aria-hidden="true" title="Malzeme İhtiyaç Listesi"></i></a>
						</td>
					<!-- sil -->
				</tr>
				<tr id="order_stocks_detail#currentrow#" style="display:none;" class="nohover">
					<td colspan="#colspan_info_new#">
						<div align="left" id="DISPLAY_ORDER_STOCK_INFO#currentrow#"></div>
					</td>
				</tr>
				<tr id="order_stocks_color_detail#currentrow#" style="display:none;" class="nohover">
					<td colspan="#colspan_info_new#">
						<div align="left" id="DISPLAY_ORDER_STOCK_COLOR_DETAIL#currentrow#"></div>
					</td>
				</tr>
			
			</tbody>
			</cfoutput>
			<!-- sil -->
			<tfoot>
				<form name="add_production_demand" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.emptypopup_add_production_order_all_sub">
					<tr>
						<td colspan="<cfoutput>#colspan_info_new#</cfoutput>" style="text-align:right;">
							<input name="is_time_calculation" id="is_time_calculation" type="hidden" value="<cfoutput>#is_time_calculation#</cfoutput>">
							<input name="is_cue_theory" id="is_cue_theory" type="hidden" value="<cfoutput>#is_cue_theory#</cfoutput>">
							<input name="is_add_multi_demand" id="is_add_multi_demand" type="hidden" value="<cfoutput>#is_add_multi_demand#</cfoutput>">
							<input name="station_id_list" id="station_id_list" type="hidden" value="">
							<input name="works_prog_id_list" id="works_prog_id_list" type="hidden" value="">
							<input name="production_amount_list" id="production_amount_list" type="hidden" value="">
							<input name="order_row_id" id="order_row_id" type="hidden" value="">
							<input name="order_id" id="order_id" type="hidden" value="">
							<input name="is_select_sub_product" id="is_select_sub_product" type="hidden" value=""><!--- value="<cfoutput>#is_select_sub_product#</cfoutput>">---->

							<input name="production_start_date_list" id="production_start_date_list" type="hidden" value="">
							<input name="production_start_h_list" id="production_start_h_list" type="hidden" value="">
							<input name="production_start_m_list" id="production_start_m_list" type="hidden" value="">
							<input type="hidden" name="is_demand" id="is_demand" value="">
							<!---
							<input type="button" name="production_material" id="production_material" value="<cf_get_lang no ='210.Malzeme İhtiyaç Listesi'>" onClick="demand_convert_to_production(3);">
							--->
						</td>
					</tr> 
				</form>
				<form name="go_stock_list" id="go_stock_list" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=textile.tracking&event=material">
					<input type="hidden" name="orderids" id="orderids" value="">
					<input type="hidden" name="pids" id="pids" value="">
					<input type="hidden" name="amounts" id="amounts" value="">
					<input type="hidden" name="projectid" id="projectid" value="">
					<input type="hidden" name="req_id" id="req_id" value="">
				</form>
			<!-- sil -->
		<cfelse>
			<tbody>
				<tr>
					<td colspan="<cfoutput>#colspan_info_new#</cfoutput>"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
				</tr>
			</tbody>
		</cfif>
	</cf_grid_list>
	<script type="text/javascript">
		function calc_deliver_date(row_id,stock_id,amount,spec_main_id){
			document.getElementById('deliver_date_info'+row_id+'').style.display='';
			stock_id_list=''+stock_id+'-'+spec_main_id+'-'+amount+'-1';
			AjaxPageLoad(<cfoutput>'#request.self#?fuseaction=prod.popup_ajax_deliver_date_calc&from_p_order_list=1&row_id='+row_id+'&stock_id_list='+stock_id_list+''</cfoutput>,'deliver_date_info'+row_id+'',1,"<cf_get_lang no ='602 .Teslim Tarihi Hesaplanıyor'>");
		}
		function send_to_production_group(row_id,_type){
			if(_type != undefined && _type == 1)
				demand_ = '&is_demand=1';
			else
				demand_ = '';
			window.location="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.add_prod_order&production_amount="+document.getElementById('production_amount'+row_id).value+"&order_row_id="+document.getElementById('order_row_ids_'+row_id).value+"&order_id="+document.getElementById('order_ids_'+row_id).value+""+demand_;
		}
		function show_order_detail(row_id){
			order_ids =document.getElementById('order_ids_'+row_id).value;
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_ajax_list_order_comp_det&order_ids='+order_ids+'&row_id='+row_id+'&order_row_id='+document.getElementById('order_row_ids_'+row_id).value+'','order_det_info'+row_id);
		}
		function show_rezerved_orders_detail(row_id,stock_id,type){
			document.getElementById('show_rezerved_orders_detail'+row_id+'').style.display='';
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_reserved_orders&taken='+type+'&sid='+stock_id+'&row_id='+row_id+'&order_row_id='+document.getElementById('order_row_ids_'+row_id).value+'','show_rezerved_orders_detail'+row_id+'',1);
		}
		function show_rezerved_prod_detail(row_id,stock_id){
			document.getElementById('show_rezerved_prod_detail'+row_id+'').style.display='';
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_reserved_production_orders&type=1&sid='+stock_id+'&row_id='+row_id+'','show_rezerved_prod_detail'+row_id+'',1);
		}
	
		function product_control(){/*Ürün seçmeden spec seçemesin.*/
			if(document.getElementById('stock_id_').value=="" || document.getElementById('product_name').value == "" ){
				alert("<cf_get_lang no ='515.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
				return false;
			}
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=search.spect_main_id&field_name=search.spect_name&is_display=1&stock_id='+document.getElementById('stock_id_').value,'list');
		}
	
	function demand_convert_to_production(type,i)
	{
		var rowcount='<cfoutput>#get_orders.recordcount#</cfoutput>';
		var orderids_="";
		var pids_="";
		var amounts_='';
		var projectid = "";
		var req_id = "";
				
				orderids_=orderids_+document.getElementById('order_id'+i).value+',';
				pids_=pids_+document.getElementById('product_id'+i).value+',';
				projectid = projectid+document.getElementById('project_id'+i).value+',';
				marj=$('#marj_amount'+i).val();
				marj=filterNum(marj);
				amounts_=amounts_+marj+',';
				req_id = document.getElementById('req_id'+i).value;
				
				if(orderids_=='')
				{
					alert("<cf_get_lang_main no ='313.Ürün Seçiniz '>");
					return false;
				}
					$("#go_stock_list #orderids").val(orderids_);
					$("#go_stock_list #projectid").val(projectid);
                    $("#go_stock_list #pids").val(pids_);
					$("#go_stock_list #amounts").val(amounts_);
					$("#go_stock_list #amounts").val(amounts_);
					$("#go_stock_list #req_id").val(req_id);
					//$("#go_stock_list").submit();

				window.location.href="<cfoutput>#request.self#?</cfoutput>fuseaction=textile.tracking&event=material&amounts="+amounts_+"&orderids="+orderids_+"&pids="+pids_+"&projectid="+projectid+"&req_id="+req_id;
			
	}
		function amount_marj(params) {
		    order_amount=$('#orj_production_amount_grup'+params).val();
			marj=$('#marj_amount'+params).val();
			marj=filterNum(marj);
			order_amount=parseFloat(order_amount)+((parseFloat(order_amount)*parseFloat(marj))/100);
			order_amount=Math.round(order_amount);
			$('#production_amount_grup'+params).val(commaSplit(order_amount));
		}
		$(document).ready(function() {
			$("#list_order_big_list tbody").each((i,e) => amount_marj(i+1));
		});
	</script>