
<cfparam name="attributes.list_stock_id_" default="">
<cfparam name="attributes.list_product_name" default="">
<cfparam name="attributes.main_stock_id_" default="">
<cfsetting showdebugoutput="no">
<cfquery name="get_all_stations" datasource="#dsn3#">
    SELECT STATION_ID AS S_ID,STATION_NAME,COMMENT,ACTIVE FROM WORKSTATIONS ORDER BY STATION_NAME
</cfquery>
<cfquery name="GET_STOCK_STATIONS" datasource="#dsn3#">
     SELECT
		WSP.MAIN_STOCK_ID,
    	WSP.OPERATION_TYPE_ID, 
    	WSP.PROCESS,
        WSP.STOCK_ID,
		WSP.ASSET_ID,
        WS_P_ID,
        PRODUCTION_TIME,
        WS.CAPACITY,
        STATION_ID,
        STATION_NAME,
        PRODUCTION_TYPE,
        MIN_PRODUCT_AMOUNT,
        SETUP_TIME 
	FROM 
    	WORKSTATIONS_PRODUCTS WSP,
        WORKSTATIONS WS 
	WHERE 
    	WS.STATION_ID = WSP.WS_ID
    <cfif isdefined('attributes.stock_id')>
    	AND WSP.STOCK_ID = #attributes.stock_id#
	<cfelseif len(attributes.list_stock_id_) and len(attributes.list_product_name)>
    	AND WSP.STOCK_ID = #attributes.list_stock_id_#
	<cfelseif isdefined('attributes.operation_type_id') and len(attributes.operation_type_id)>
    	AND WSP.OPERATION_TYPE_ID = #attributes.operation_type_id#
	</cfif>
	<cfif isdefined("attributes.is_show_other_ws") and len(attributes.is_show_other_ws) and attributes.is_show_other_ws eq 0 and isdefined("attributes.main_stock_id") and len(attributes.main_stock_id)>
		AND WSP.MAIN_STOCK_ID = #listfirst(attributes.main_stock_id)#
	</cfif>
	<cfif isdefined('attributes.ws_id')>
		AND WS.STATION_ID = #attributes.ws_id# 
	</cfif>
</cfquery>
<cfquery name="GET_PROCESS" datasource="#DSN3#">
	SELECT OPERATION_TYPE_ID,OPERATION_TYPE,O_HOUR,O_MINUTE,OPERATION_COST FROM OPERATION_TYPES
</cfquery>
<cfset all_stations = listdeleteduplicates(ValueList(GET_STOCK_STATIONS.STATION_ID,','))>
<cfset all_stocks =  listdeleteduplicates(ValueList(GET_STOCK_STATIONS.STOCK_ID,','))>
<cfset all_operations = listdeleteduplicates(ValueList(GET_STOCK_STATIONS.OPERATION_TYPE_ID,','))>
<cfif not len(all_stocks)><cfset all_stocks = 0></cfif>
<cfquery name="get_stock_name" datasource="#dsn3#">
	SELECT PRODUCT_NAME,STOCK_ID FROM STOCKS WHERE STOCK_ID IN (#all_stocks#)
</cfquery>
<cfset send_ = "#request.self#?fuseaction=prod.emptypopup_add_ws_product_process">
        <cfform method="POST" name="upd_production_order" action="#request.self#?fuseaction=prod.emptypopup_add_ws_product_process">
            <cfoutput>
                <input type="hidden" name="all_stations" id="all_stations" value="#all_stations#">
                <input type="hidden" name="all_stocks" id="all_stocks" value="#all_stocks#">
                <input type="hidden" name="all_operations" id="all_operations" value="#all_operations#">
            </cfoutput>
            <cfparam name="attributes.page" default=1>
            <cfparam name="attributes.maxrows" default='5'>
            <cfparam name="attributes.totalrecords" default="#GET_STOCK_STATIONS.recordcount#">
            <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
            <cfset sayac = 0 >
            <cfif not isdefined('attributes.operation_type_id')><!--- operasyonda search gelmesin ancak sonradan eklenebilir.. --->
                <cf_box_search>
                    <div class="form-group">
                        <label class="col col-4">
                            <cf_get_lang dictionary_id='57657.Ürün'>
                        </label>
                        <cfoutput>
                            <input type="hidden" name="list_stock_id_" id="list_stock_id_" value="#attributes.list_stock_id_#">
                            <input type="text"  name="list_product_name" id="list_product_name"  value="#attributes.list_product_name#" onFocus="AutoComplete_Create('list_product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID','list_stock_id_','','3','225');" autocomplete="off" onKeyPress="if(event.keyCode==13)ajaxPage(1);">
                        </cfoutput>
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function='ajaxPage(1)'>
                    </div>
                </cf_box_search>
            </cfif>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id="57487.No"></th>
                        <th><cfoutput>#attributes.headers#</cfoutput></th>
                        <th><cf_get_lang dictionary_id='36420.Kapasite'><br/>(<cf_get_lang dictionary_id='57491.Saat'>)</th>
                        <th><cf_get_lang dictionary_id='34289.Setup(dk.)'></th>
                        <th><cf_get_lang dictionary_id ='36844.Üretim Zamanı(dk)'></th>
                        <th><cf_get_lang dictionary_id ='36845.Min Üretim Mik'></th>
                        <th width="150"><cf_get_lang dictionary_id="57630.Tip"></th>
                        <cfif isdefined("attributes.is_add_assetp") and attributes.is_add_assetp eq 1><th width="180"><cf_get_lang dictionary_id="58833.Fiziki Varlık"></th></cfif>
                        <th width="20"></th>
                    </tr>
                </thead>
                <tbody>
                <cfif GET_STOCK_STATIONS.recordcount><!--- <cfdump var="#GET_STOCK_STATIONS#"> --->
                    <cfset asset_id_list = "">
                    <cfoutput query="GET_STOCK_STATIONS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif isdefined("asset_id") and len(asset_id) and not listfind(asset_id_list,asset_id)>
                            <cfset asset_id_list=listappend(asset_id_list,asset_id)>
                        </cfif>
                    </cfoutput>
                    <cfif ListLen(asset_id_list)>
                        <cfquery name="get_asset" datasource="#dsn#">
                            SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#asset_id_list#) ORDER BY ASSETP_ID
                        </cfquery>
                        <cfset asset_id_list = ListSort(ListDeleteDuplicates(ValueList(get_asset.assetp_id)),'numeric','ASC',',')>
                    </cfif>
                    <cfoutput query="GET_STOCK_STATIONS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfset station_id = STATION_ID>
                        <cfset stock_id_ = STOCK_ID>
                        <cfset operation_id = OPERATION_TYPE_ID>
                        <cfset sayac = sayac +1 >
                        <cfset _MAIN_STOCK_ID_ = MAIN_STOCK_ID>
                            <tr <cfif not len(_MAIN_STOCK_ID_)>bgcolor="CCCCCC"<cfelseif _MAIN_STOCK_ID_ gt 0 and isdefined("attributes.main_stock_id") and len(attributes.main_stock_id) and _MAIN_STOCK_ID_ eq attributes.main_stock_id>class="color-row"<cfelse>bgcolor="FF9966"</cfif> id="station_row_id#sayac#" >
                                <td>#currentrow#</td>
                                <td>
                                    <input name="main_stock_id#sayac#" id="main_stock_id#sayac#" value="<cfif isdefined('_MAIN_STOCK_ID_')>#_MAIN_STOCK_ID_#</cfif>" type="hidden">
                                    <div class="form-group">
                                        <cfif isdefined('attributes.stock_id')>                                       
                                            <select name="station_id#sayac#" id="station_id#sayac#">
                                                <cfloop query="get_all_stations">
                                                    <option value="#S_ID#" <cfif active eq 0>style="color:##FF0000;"</cfif> <cfif S_ID eq station_id>selected</cfif>>#STATION_NAME#<cfif isdefined("attributes.is_show_ws_detail") and attributes.is_show_ws_detail  eq 1>-#COMMENT#</cfif></option>
                                                </cfloop>
                                            </select>
                                            <input type="hidden" name="stock_id#sayac#" id="stock_id#sayac#" value="#STOCK_ID#">
                                        <cfelseif isdefined('attributes.ws_id')>
                                            <input type="hidden" name="station_id#sayac#" id="station_id#sayac#" value="#station_id#">
                                            <cfif len(operation_id)>
                                                <cfquery name="GET_OPERATION_NAME" datasource="#DSN3#">
                                                    SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPE_ID = #operation_type_id#
                                                </cfquery>
                                                <div class="input-group">
                                                    <input type="hidden" name="operation_type_id#sayac#" id="operation_type_id#sayac#" value="#operation_type_id#">
                                                    <input type="text" name="operation_type#sayac#" id="operation_type#sayac#" style="background-color:FF9966;width:200px;" value="#GET_OPERATION_NAME.operation_type#">
                                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="open_product('#sayac#');"></span>
                                                </div>
                                            <cfelseif len(stock_id_)>   
                                                <input type="hidden" name="stock_id#sayac#" id="stock_id#sayac#" value="#stock_id_#">
                                                <cfquery name="_get_stock_name_" dbtype="query">
                                                    SELECT * FROM get_stock_name WHERE STOCK_ID = #stock_id_# 
                                                </cfquery>
                                                <div class="input-group">
                                                    <input type="text" name="stock_name#sayac#" id="stock_name#sayac#" value="#_get_stock_name_.PRODUCT_NAME#">
                                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="open_product('#sayac#');"></span>
                                                </div>
                                            </cfif>
                                        <cfelseif isdefined('attributes.operation_type_id')>
                                            <select name="station_id#sayac#" id="station_id#sayac#">
                                                <cfloop query="get_all_stations">
                                                    <option value="#S_ID#" <cfif active eq 0>style="color:##FF0000;"</cfif> <cfif S_ID eq station_id>selected</cfif>>#STATION_NAME#<cfif isdefined("attributes.is_show_ws_detail") and attributes.is_show_ws_detail  eq 1>-#COMMENT#</cfif></option>
                                                </cfloop>
                                            </select>
                                            <input type="hidden" name="operation_type_id#sayac#" id="operation_type_id#sayac#" value="#OPERATION_TYPE_ID#">
                                        </cfif>
                                    </div>
                                </td>
                                <td> 
                                    <div class="form-group">
                                        <input type="Text" name="capacity#sayac#" id="capacity#sayac#" style="text-align:right;" maxlength="100" onKeyup="return(FormatCurrency(this,event,8));" onBlur="calculate_time(3,#sayac#)" value="#CAPACITY#"> 
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="setup_time#sayac#" id="setup_time#sayac#" style="text-align:right;" value="#setup_time#">
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="production_time#sayac#" id="production_time#sayac#" value="#tlformat(production_time,6)#" style="text-align:right;" onKeyup="return(FormatCurrency(this,event,8));" onBlur="calculate_time(-1,#sayac#)">
                                        <input type="hidden" name="production_time_type#sayac#" id="production_time_type#sayac#" value="1">
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="min_product_amount#sayac#" id="min_product_amount#sayac#" style=" text-align:right;" value="#min_product_amount#">
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <select name="production_type#sayac#" id="production_type#sayac#"   >
                                            <option value="0" <cfif production_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='36842.Artarak Devam'></option>
                                            <option value="1" <cfif production_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='36843.Katları Şeklinde'></option>
                                        </select>
                                    </div>
                                </td>
                                <cfif isdefined("attributes.is_add_assetp") and attributes.is_add_assetp eq 1>
                                    <td>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <input type="hidden" name="asset_id#sayac#" id="asset_id#sayac#" value="<cfif isdefined("asset_id") and len(asset_id)>#asset_id#</cfif>">
                                                <input type="text" name="asset#sayac#" id="asset#sayac#" value="<cfif isdefined("asset_id") and len(asset_id)>#get_asset.assetp[ListFind(asset_id_list,asset_id,',')]#</cfif>">
                                                <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_asset2('#sayac#');"></span>
                                            </div>
                                        </div>
                                    </td>
                                </cfif>
                                <td>
                                    <ul class="ui-icon-list">
                                        <li><a href="javascript://" onClick="gizle(station_row_id#sayac#);upd_row('#WS_P_ID#','#sayac#','D');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>" alt="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a></li>
                                        <li><a href="javascript://" onClick="station_control('#STATION_ID#','#sayac#','#WS_P_ID#','U');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li>
                                    </ul>
                                </td>
                            </tr>
                    </cfoutput>
                    <tfoot>
                        <tr>
                            <td colspan="9" style="text-align:right;">
                                <cfset _lastpage_ = (attributes.totalrecords \ attributes.maxrows) + iif(attributes.totalrecords mod attributes.maxrows,1,0) >
                                <select name="select_pages" id="select_pages" onChange="ajaxPage(this.value);">
                                    <cfoutput>
                                    <cfloop from="1" to="#_lastpage_#" index="pp">
                                        <option value="#pp#"<cfif attributes.page eq pp >selected</cfif>>#pp#</option>
                                    </cfloop>
                                    </cfoutput>	
                                </select>
                            <cf_get_lang dictionary_id="58829.Kayıt Sayısı"> : <cfoutput>#GET_STOCK_STATIONS.recordcount#</cfoutput>&nbsp;
                            </td>
                        </tr>
                    </tfoot>
                <cfelse>
                    <tbody>
                        <tr>
                            <td colspan="9"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
                        </tr>  
                    </tbody>  
                </cfif>
            </cf_grid_list>
        </cfform>
<script language="javascript">
	<cfoutput>
		var is_calc_function = 0 ;//hesaplama fonksiyonu çalışmadı henüz...
		<cfif isdefined("attributes.is_show_other_ws") and len(attributes.is_show_other_ws)>
			is_show_other_ws = #attributes.is_show_other_ws#;
		<cfelse>
			is_show_other_ws = 1;
		</cfif>
		function station_control(station_id,sayac,ws_p_id,type)
		{
			var station_id_ = document.getElementById("station_id"+sayac).value;
			var get_station = wrk_safe_query('prdp_get_station','dsn3',0,station_id_);
			if(get_station.ACTIVE == 0)
			{
				alert("Satırdaki İstasyon Aktif Değil. Lütfen İstasyonu Değiştiriniz.");
				return false;
				//document.getElementById("station_id"+sayac).value = "";
			}
			return upd_row(ws_p_id,sayac,type);
		}
		function ajaxPage(page)
		{
			<cfif not isdefined('attributes.operation_type_id')>
				var list_stock_id=document.getElementById('list_stock_id_').value;
				var list_product_name=document.getElementById('list_product_name').value;
			<cfelse>
				var list_stock_id='';
				var list_product_name='';
			</cfif>
			<cfif isdefined('attributes.stock_id')>
				AjaxPageLoad('#request.self#?fuseaction=prod.popup_upd_ws_product&is_add_assetp=<cfif isdefined("attributes.is_add_assetp")>#attributes.is_add_assetp#</cfif>&is_show_other_ws='+is_show_other_ws+'&list_product_name='+list_product_name+'&list_stock_id_='+list_stock_id+'&main_stock_id=#attributes.main_stock_id#&headers=#attributes.headers#&stock_id=#attributes.stock_id#&page='+page+'','_show_stations_',1);
			<cfelseif isdefined('attributes.ws_id')>
				AjaxPageLoad('#request.self#?fuseaction=prod.popup_upd_ws_product&is_add_assetp=<cfif isdefined("attributes.is_add_assetp")>#attributes.is_add_assetp#</cfif>&is_show_other_ws='+is_show_other_ws+'&list_product_name='+list_product_name+'&list_stock_id_='+list_stock_id+'&headers=#attributes.headers#&ws_id=#attributes.ws_id#&page='+page+'','_show_stations_',1);
			<cfelseif isdefined('attributes.operation_type_id')>
				AjaxPageLoad('#request.self#?fuseaction=prod.popup_upd_ws_product&is_show_other_ws='+is_show_other_ws+'&headers=#attributes.headers#&operation_type_id=#attributes.operation_type_id#&page='+page+'','_show_stations_',1);
			</cfif>
			is_calc_function = 0; //burda tekrar sıfır atıyoruz ki yeni sayfada da çalışsın.
		}
		function all_calc()
		{
			for(j=1;j<='#sayac#';j++){//toplam en fazla 20 kayıt olacak..
				if(document.getElementById('capacity'+j) != undefined){
						calculate_time(-1,j);
						is_calc_function = 1;//fonksiyon çalıştı..
				}		
				else if (is_calc_function == 0){//foksiyon çalışmadı ise...
					setTimeout('all_calc()',20);
				}	
			}
		}
		all_calc();
		function upd_row(row_id,selected_row_id,type)
		{
			if(type=='U'){//update
			
				document.add_production_order.action = '#send_#'+'&is_show_other_ws='+is_show_other_ws+'&upd_row_id='+row_id+'&selected_row_id='+selected_row_id;
				AjaxFormSubmit('add_production_order','add_stations_info',1,"<cf_get_lang dictionary_id ='29723.Güncelleniyor'>","<cf_get_lang dictionary_id ='29724.Güncellendi'>!");
				document.add_production_order.action = '#send_#';
			}
			else{
				document.add_production_order.action = '#send_#'+'&del_row_id='+row_id;
				<cfif isdefined('attributes.stock_id')>
					AjaxFormSubmit('add_production_order','add_stations_info',1,"<cf_get_lang dictionary_id ='29726.Siliniyor'>..","<cf_get_lang dictionary_id ='29721.Silindi'>",'#request.self#?fuseaction=prod.popup_upd_ws_product&is_show_other_ws='+is_show_other_ws+'&main_stock_id=#attributes.main_stock_id#&headers=#attributes.headers#&stock_id=#attributes.stock_id#','_show_stations_');
				<cfelseif isdefined('attributes.ws_id')>
					AjaxFormSubmit('add_production_order','add_stations_info',1,"<cf_get_lang dictionary_id ='29726.Siliniyor'>..","<cf_get_lang dictionary_id ='29721.Silindi'>",'#request.self#?fuseaction=prod.popup_upd_ws_product&is_show_other_ws='+is_show_other_ws+'&headers=#attributes.headers#&ws_id=#attributes.ws_id#','_show_stations_');
				<cfelseif isdefined('attributes.operation_type_id')>
					AjaxFormSubmit('add_production_order','add_stations_info',1,"<cf_get_lang dictionary_id ='29726.Siliniyor'>..","<cf_get_lang dictionary_id ='29721.Silindi'>",'#request.self#?fuseaction=prod.popup_upd_ws_product&is_show_other_ws='+is_show_other_ws+'&headers=#attributes.headers#&operation_type_id=#attributes.operation_type_id#','_show_stations_');
				</cfif>
				document.add_production_order.action = '#send_#';
			}
		}
		function pencere_ac_asset2(no)
		{
			adres = '#request.self#?fuseaction=assetcare.popup_list_assetps';
			adres += '&field_id=asset_id' + no +'&field_name=asset' + no +'&event_id=0&motorized_vehicle=0';
			windowopen(adres,'list');
		}
	</cfoutput>
</script>
<cfabort>
