<cf_xml_page_edit>
<script type="text/javascript">
	function calculate_time(type,id)
		{
			var capacity = document.getElementById('capacity'+id).value;
			var uretim =  document.getElementById('production_time'+id).value;
			if ((type==1 || type==-1) && uretim != "")//dk ise
			{
				if(uretim != 0)
					document.getElementById('capacity'+id).value = commaSplit(wrk_round(60 / filterNum(uretim,6),2),6);
				else
					document.getElementById('capacity'+id).value = commaSplit(0,6);
			}
			if (type==2 && uretim != "")//saat girilmiş ise
				{document.getElementById('capacity'+id).value = commaSplit(1/filterNum(uretim,6),6);}
			if (type==3 && capacity !="")
			{
				if(capacity !=0)
					document.getElementById('production_time'+id).value = commaSplit(60 / filterNum(capacity,6),6);
				else
					document.getElementById('production_time'+id).value = commaSplit(0,6);
			}
		}
	function control()
		{
			if (document.add_production_order.capacity.value == "")
				{	alert("<cfoutput><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='36420.Kapasite'></cfoutput>")
					return false;
				}
			if (document.add_production_order.production_time.value=="")	
				{	alert("<cf_get_lang dictionary_id ='36840.Ürün için üretim zamanı giriniz'>")
					return false;
				}
					document.add_production_order.capacity.value= filterNum(document.add_production_order.capacity.value);
					document.add_production_order.production_time.value= filterNum(document.add_production_order.production_time.value);
		}
</script> 
<cfif isdefined('attributes.stock_id')>
	<cfquery name="get_stocks_name" datasource="#dsn3#">
    	SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #attributes.stock_id#
    </cfquery>
    <cfset page_info = "#getLang('main',245)# : #get_stocks_name.PRODUCT_NAME#">
    <cfset headers = getLang('main',1422)>
<cfelseif isdefined('attributes.ws_id')>
	<cfquery name="get_station_name" datasource="#dsn3#">
    	SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = #attributes.ws_id#
    </cfquery>
    <cfset page_info = "#getLang('main',1422)# : #get_station_name.STATION_NAME#">
    <cfset headers = "#getLang('main',245)#-#getLang('main',1622)#">
<cfelseif isdefined('attributes.operation_type_id')>
	<cfquery name="get_operation_name" datasource="#dsn3#">
    	SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPE_ID = #attributes.operation_type_id#
    </cfquery>
    <cfset page_info = "#getLang('main',1622)# : #get_operation_name.OPERATION_TYPE#">
    <cfset headers = getLang('main',1422)>
</cfif> 
<cfquery name="get_all_stations" datasource="#dsn3#">
  	SELECT STATION_ID AS S_ID,STATION_NAME,COMMENT FROM WORKSTATIONS WHERE ACTIVE = 1 ORDER BY STATION_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('prod',528)# : #page_info#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform method="POST" name="add_production_order" action="#request.self#?fuseaction=prod.emptypopup_add_ws_product_process&is_add=1">
			<cfoutput>
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57734.Seçiniz'></label>
							<div class="col col-8 col-sm-12">
								<cfif isdefined('attributes.stock_id')>
									<input name="main_stock_id" id="main_stock_id" value="<cfif isdefined('attributes.main_stock_id')>#attributes.main_stock_id#<cfelse>#attributes.stock_id#</cfif>" type="hidden">
									<select name="station_id0" id="station_id0">
										<option value=""><cf_get_lang dictionary_id="34288.İstasyon Seçiniz"></option>
										<cfloop query="get_all_stations">
											<option value="#S_ID#">#STATION_NAME#<cfif is_show_ws_detail eq 1>-#COMMENT#</cfif></option>
										</cfloop>
									</select>
									<input type="hidden" name="stock_id0" id="stock_id0" value="#STOCK_ID#">
								<cfelseif isdefined('attributes.ws_id')>
									<div class="input-group">
										<input type="hidden" name="station_id0" id="station_id0" value="#attributes.ws_id#">
										<input type="hidden" name="stock_id0" id="stock_id0" value="">
										<input type="text" name="stock_name0" id="stock_name0" value="">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="open_product(0);"></span>
									</div>									
								<cfelseif isdefined('attributes.operation_type_id')>
									<input  type="hidden" name="main_stock_id" id="main_stock_id" value="<cfif isdefined('attributes.main_stock_id')>#attributes.main_stock_id#<cfelseif isdefined('attributes.stock_id')>#attributes.stock_id#</cfif>">
									<select name="station_id0" id="station_id0">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_all_stations">
											<option value="#S_ID#">#STATION_NAME#<cfif is_show_ws_detail eq 1>-#COMMENT#</cfif></option>
										</cfloop>
									</select>
									<input type="hidden" name="operation_type_id0" id="operation_type_id0" value="#attributes.operation_type_id#">
									<input type="hidden" name="stock_id0" id="stock_id0" value="">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='36420.Kapasite'></label>
							<div class="col col-8 col-sm-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='36715.Kapasite girmelisiniz'></cfsavecontent>
								<input type="text" name="capacity0" id="capacity0" style="width:80px;text-align:right;" maxlength="100" onKeyup="return(FormatCurrency(this,event,8));" onBlur="calculate_time(3,0)" value="#tlformat(60,2)#"> 
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='34289.Setup(dk.)'></label>
							<div class="col col-8 col-sm-12">
								<input type="text" name="setup_time0" id="setup_time0"  style="text-align:right;width:80px" value="0">
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36844.Üretim Zamanı(dk)'></label>
							<div class="col col-8 col-sm-12">
								<input type="hidden" name="production_time_type0" id="production_time_type0" value="1">
								<input type="text" name="production_time0" id="production_time0" value="#tlformat(1,6)#" style="width:80px;text-align:right;" onKeyup="return(FormatCurrency(this,event,8));" onBlur="calculate_time(-1,0)">
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36845.Min Üretim Mik'></label>
							<div class="col col-8 col-sm-12">
								<input type="text" name="min_product_amount0" id="min_product_amount0" style="width:65px" value="1">
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="57630.Tip"></label>
							<div class="col col-8 col-sm-12">
								<select name="production_type0" id="production_type0" style="width:100px;">
									<option value="0"><cf_get_lang dictionary_id ='36842.Artarak Devam'></option>
									<option value="1"><cf_get_lang dictionary_id ='36843.Katları Şeklinde'></option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58833.Fiziki Varlık"></label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">	
									<cfif isdefined("is_add_assetp") and is_add_assetp eq 1>
										<input type="hidden" name="asset_id0" id="asset_id0" value="">
										<input type="text" name="asset0" id="asset0" value="" style="width:120px;">
										<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_asset(0);"></span>
									</cfif>
								</div>
							</div>
						</div>
					</div>
					<div  class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">
					<cf_seperator title="#getLang('','İstasyon',29473)#" id="_show_stations_">
						<div id="_show_stations_"></div>
					</div>
				</cf_box_elements>
			</cfoutput>
			<cf_box_footer>
				<cf_workcube_buttons add_function="control()">
			</cf_box_footer>
			<table>
				<tr>
					<td><div id="add_stations_info" style="float:right;"></div></td>
				</tr>
			</table>
		</cfform>
	</cf_box>
</div>
<cfif isdefined('attributes.main_stock_id')>
	<cfset mainStockId=attributes.main_stock_id>
<cfelse>
	<cfset mainStockId=''>
</cfif>
<script type="text/javascript">
	<cfoutput>
		calculate_time(-1,0);
		function open_product(rows)
		{
			if(rows==0)
				windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=add_production_order.stock_id'+rows+'&field_name=add_production_order.stock_name'+rows+'','medium');
			else
				windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=upd_production_order.stock_id'+rows+'&field_name=upd_production_order.stock_name'+rows+'','medium');
		}
		<cfif isdefined('attributes.stock_id')>
			AjaxPageLoad('#request.self#?fuseaction=prod.popup_upd_ws_product&is_show_other_ws=#is_show_other_ws#&is_show_ws_detail=#is_show_ws_detail#&is_add_assetp=#is_add_assetp#&headers=#headers#&main_stock_id=#mainStockId#&main_stock_id_=#mainStockId#&stock_id=#attributes.stock_id#','_show_stations_',1);
		<cfelseif isdefined('attributes.ws_id')>
			adres_ = '#request.self#?fuseaction=prod.popup_upd_ws_product&is_show_other_ws=#is_show_other_ws#&is_show_ws_detail=#is_show_ws_detail#&is_add_assetp=#is_add_assetp#&headers=#headers#&ws_id=#attributes.ws_id#';
			AjaxPageLoad(adres_,'_show_stations_','1');
		<cfelseif isdefined('attributes.operation_type_id')>
			AjaxPageLoad('#request.self#?fuseaction=prod.popup_upd_ws_product&is_show_other_ws=#is_show_other_ws#&is_show_ws_detail=#is_show_ws_detail#&is_add_assetp=#is_add_assetp#&headers=#headers#&main_stock_id=#mainStockId#&main_stock_id_=#mainStockId#&operation_type_id=#attributes.operation_type_id#','_show_stations_',1);
		</cfif>
		function control()
		{
			var station_id = document.getElementById('station_id0').value;
			var all_station = document.getElementById('all_stations').value;
			var stock_id = document.getElementById('stock_id0').value;
			var all_stock = document.getElementById('all_stocks').value;
			if(station_id == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58834.İstasyon'>");
				return false;
			}
			if(document.getElementById('setup_time0').value == '')
			{
				alert("<cf_get_lang dictionary_id='34289.Setup(dk.)'>");	
				return false;
			}
			
			if(document.getElementById('capacity0').value == '')
			{
				alert('<cfoutput><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="36420.Kapasite"></cfoutput>');	
				return false;
			}
			
			if(document.getElementById('production_time0').value == '')
			{
				alert('<cfoutput><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="36844.Üretim zamanı"></cfoutput>');	
				return false;
			}

			if(document.getElementById('min_product_amount0').value == '')
			{
				alert('<cfoutput><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="36840.Üretim zamanı"></cfoutput>');	
				return false;
			}
			<cfif isdefined('attributes.stock_id')>
				if(list_find(all_station,station_id,',') == 0)//daha önceden eklenmemiş ise
					AjaxFormSubmit('add_production_order','add_stations_info','1',"<cf_get_lang dictionary_id='58889.Kaydediliyor'>..","<cf_get_lang dictionary_id='58890.Kaydedildi'>",'#request.self#?fuseaction=prod.popup_upd_ws_product&is_show_other_ws=#is_show_other_ws#&is_show_ws_detail=#is_show_ws_detail#&is_add_assetp=#is_add_assetp#&headers=#headers#&main_stock_id=#mainStockId#&main_stock_id_=#mainStockId#&stock_id=#attributes.stock_id#','_show_stations_');
				else
					alert("<cf_get_lang dictionary_id ='36846.Bu İstasyon Daha Önce Eklenmiş'>!");
			<cfelseif isdefined('attributes.ws_id')>
				if(stock_id != "")
				{
					if(list_find(all_stock,stock_id,',') == 0)//daha önceden eklenmemiş ise
						AjaxFormSubmit('add_production_order','add_stations_info','1',"<cf_get_lang dictionary_id='58889.Kaydediliyor'>..","<cf_get_lang dictionary_id='58890.Kaydedildi'>",'#request.self#?fuseaction=prod.popup_upd_ws_product&is_show_other_ws=#is_show_other_ws#&is_show_ws_detail=#is_show_ws_detail#&is_add_assetp=#is_add_assetp#&headers=#headers#&ws_id=#attributes.ws_id#','_show_stations_');		
					else
						alert("<cf_get_lang dictionary_id ='36847.Bu Ürün Daha Önce Eklenmiş'>!");
				}
				else
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='57657.Ürün'>!");		
			<cfelseif isdefined('attributes.operation_type_id')>
				if(list_find(all_station,station_id,',') == 0)//daha önceden eklenmemiş ise
					AjaxFormSubmit('add_production_order','add_stations_info','1',"<cf_get_lang dictionary_id='58889.Kaydediliyor'>..","<cf_get_lang dictionary_id='58890.Kaydedildi'>",'#request.self#?fuseaction=prod.popup_upd_ws_product&is_show_other_ws=#is_show_other_ws#&is_show_ws_detail=#is_show_ws_detail#&is_add_assetp=#is_add_assetp#&main_stock_id=#mainStockId#&main_stock_id_=#mainStockId#&headers=#headers#&operation_type_id=#attributes.operation_type_id#','_show_stations_');
				else
					alert("<cf_get_lang dictionary_id ='36846.Bu İstasyon Daha Önce Eklenmiş'>!"); 
			</cfif>
			return false;
		}
		function pencere_ac_asset(no)
		{
			adres = '#request.self#?fuseaction=assetcare.popup_list_assetps';
			adres += '&field_id=asset_id' + no +'&field_name=asset' + no +'&event_id=0&motorized_vehicle=0';
			windowopen(adres,'list');
		}
	</cfoutput>
</script>
