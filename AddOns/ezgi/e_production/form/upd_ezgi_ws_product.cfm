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
        WSP.DEFAULT_STATUS,
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
<cfset send_ = "#request.self#?fuseaction=prod.emptypopup_add_ezgi_ws_product_process">
<cfform method="POST" name="upd_production_order" action="#request.self#?fuseaction=prod.emptypopup_add_ws_product_process">
<cfoutput>
	<input type="hidden" name="all_stations" id="all_stations" value="#all_stations#">
	<input type="hidden" name="all_stocks" id="all_stocks" value="#all_stocks#">
	<input type="hidden" name="all_operations" id="all_operations" value="#all_operations#">
</cfoutput>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='20'>
<cfparam name="attributes.totalrecords" default="#GET_STOCK_STATIONS.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset sayac = 0 >
<cfif not isdefined('attributes.operation_type_id')><!--- operasyonda search gelmesin ancak sonradan eklenebilir.. --->
    <cf_medium_list_search>
        <cf_medium_list_search_area>
            <table>
                <tr>
                    <td><div id="no_record" style="position:relative;width:400px;"></div></td>
                    <td>
                        <cf_get_lang_main no='245.Ürün'>
                        <cfoutput>
                            <input type="hidden" name="list_stock_id_" id="list_stock_id_" value="#attributes.list_stock_id_#">
                            <input type="text"  name="list_product_name" id="list_product_name" style="width:125px;"  value="#attributes.list_product_name#" onFocus="AutoComplete_Create('list_product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID','list_stock_id_','','3','225');" autocomplete="off" onKeyPress="if(event.keyCode==13)ajaxPage(1);">
                        </cfoutput>
                        <cfoutput>
                        <input type="button" value="#getLang('main',153)#" onClick="ajaxPage(1);">
                        </cfoutput>
                    </td>
                </tr>
            </table>
        </cf_medium_list_search_area>
    </cf_medium_list_search>
</cfif>
    <cf_medium_list>
    <thead>
        <tr>
            <th style="width:25px;"><cf_get_lang_main no="75.No"></th>
           	<th style="width:15px;"><cf_get_lang_main no="1136.İlk"></th>
            <th style="width:150px;"><cfoutput>#attributes.headers#</cfoutput></th>
            <th style="width:150px;"><cf_get_lang no='107.Kapasite'><br/>(<cf_get_lang_main no='79.Saat'>)</th>
            <th style="width:150px;">Setup(dk.)</th>
            <th style="width:150px;"><cf_get_lang no ='531.Üretim Zamanı(dk)'></th>
            <th style="width:100px;"><cf_get_lang no ='532.Min Üretim Mik'></th>
            <th><cf_get_lang_main no="218.Type"></th>
			<cfif isdefined("attributes.is_add_assetp") and attributes.is_add_assetp eq 1><th><cf_get_lang_main no="1421.Fiziki Varlık"></th></cfif>
            <th width="1%"></th>
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
                     <td width="3">#currentrow#</td>
                     <td style="text-align:center"><input type="checkbox" name="ws_default#sayac#" id="ws_default#sayac#" value="" <cfif DEFAULT_STATUS eq 1>checked</cfif>></td>
                     <td nowrap="nowrap">
                       <input name="main_stock_id#sayac#" id="main_stock_id#sayac#" value="<cfif isdefined('_MAIN_STOCK_ID_')>#_MAIN_STOCK_ID_#</cfif>" type="hidden">
                       <cfif isdefined('attributes.stock_id')>
                            <select name="station_id#sayac#" id="station_id#sayac#" style="width:220px;">
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
                                <input type="hidden" name="operation_type_id#sayac#" id="operation_type_id#sayac#" value="#operation_type_id#">
                                <input type="text" name="operation_type#sayac#" id="operation_type#sayac#" style="background-color:FF9966;width:200px;" value="#GET_OPERATION_NAME.operation_type#">
                                <a href="javascript://" onClick="open_product('#sayac#');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" title="<cf_get_lang_main no ='245.Ürün'>"></a>
                             <cfelseif len(stock_id_)>   
                                 <input type="hidden" name="stock_id#sayac#" id="stock_id#sayac#" value="#stock_id_#">
                                 <cfquery name="_get_stock_name_" dbtype="query">
                                     SELECT * FROM get_stock_name WHERE STOCK_ID = #stock_id_# 
                                 </cfquery>
                                 <input type="text" name="stock_name#sayac#" id="stock_name#sayac#" style="width:200px;" value="#_get_stock_name_.PRODUCT_NAME#">
                                <a href="javascript://" onClick="open_product('#sayac#');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" title="<cf_get_lang_main no ='245.Ürün'>"></a>
                            </cfif>
                        <cfelseif isdefined('attributes.operation_type_id')>
                            <select name="station_id#sayac#" id="station_id#sayac#" style="width:220px;">
                                <cfloop query="get_all_stations">
                                    <option value="#S_ID#" <cfif active eq 0>style="color:##FF0000;"</cfif> <cfif S_ID eq station_id>selected</cfif>>#STATION_NAME#<cfif isdefined("attributes.is_show_ws_detail") and attributes.is_show_ws_detail  eq 1>-#COMMENT#</cfif></option>
                                </cfloop>
                            </select>
                            <input type="hidden" name="operation_type_id#sayac#" id="operation_type_id#sayac#" value="#OPERATION_TYPE_ID#">
                        </cfif>
                    </td>
                    <td> 
                        <cfsavecontent variable="message"><cf_get_lang no='402.Kapasite girmelisiniz'></cfsavecontent>
                        <input type="Text" name="capacity#sayac#" id="capacity#sayac#" style="width:150px;text-align:right;" maxlength="100" onKeyup="return(FormatCurrency(this,event,8));" onBlur="calculate_time(3,#sayac#)" value="#CAPACITY#"> 
                    </td>
                    <td nowrap>
                        <input type="text" name="setup_time#sayac#" id="setup_time#sayac#" style="text-align:right;width:150px" value="#setup_time#">
                    </td>
                    <td nowrap>
                        <input type="text" name="production_time#sayac#" id="production_time#sayac#" value="#tlformat(production_time,6)#" style="width:150px;text-align:right;" onKeyup="return(FormatCurrency(this,event,8));" onBlur="calculate_time(-1,#sayac#)">
                        <input type="hidden" name="production_time_type#sayac#" id="production_time_type#sayac#" value="1">
                    </td>
                    <td nowrap="nowrap">
                        <input type="text" name="min_product_amount#sayac#" id="min_product_amount#sayac#" style="width:100px; text-align:right;" value="#min_product_amount#">
                    </td>
                    <td>
                        <select name="production_type#sayac#" id="production_type#sayac#" style="width:100px;">
                            <option value="0" <cfif production_type eq 0>selected</cfif>><cf_get_lang no ='529.Artarak Devam'></option>
                            <option value="1" <cfif production_type eq 1>selected</cfif>><cf_get_lang no ='530.Katları Şeklinde'></option>
                        </select>
                    </td>
					<cfif isdefined("attributes.is_add_assetp") and attributes.is_add_assetp eq 1>
						<td>
							<input type="hidden" name="asset_id#sayac#" id="asset_id#sayac#" value="<cfif isdefined("asset_id") and len(asset_id)>#asset_id#</cfif>">
							<input type="text" name="asset#sayac#" id="asset#sayac#" value="<cfif isdefined("asset_id") and len(asset_id)>#get_asset.assetp[ListFind(asset_id_list,asset_id,',')]#</cfif>" style="width:100px;">
							<a href="javascript://" onClick="pencere_ac_asset('#sayac#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
						</td>
					</cfif>
                    <td nowrap>
                        <a href="javascript://" onClick="gizle(station_row_id#sayac#);upd_row('#WS_P_ID#','#sayac#','D');"><img title="<cf_get_lang_main no ='51.Sil'>" src="/images/delete_list.gif" width="15" style="cursor:pointer;" height="15" border="0" align="absmiddle"></a>
                        <a href="javascript://" onClick="station_control('#STATION_ID#','#sayac#','#WS_P_ID#','U');"><img title="<cf_get_lang_main no ='52.Güncelle'>" src="/images/update_list.gif" width="15" style="cursor:pointer;" height="15" border="0" align="absmiddle"></a>
                    </td>
                </tr>
        </cfoutput>
        <tfoot>
            <tr>
                <td colspan="10" style="text-align:right;">
                    <cfset _lastpage_ = (attributes.totalrecords \ attributes.maxrows) + iif(attributes.totalrecords mod attributes.maxrows,1,0) >
                    <select name="select_pages" id="select_pages" onChange="ajaxPage(this.value);">
                        <cfoutput>
                        <cfloop from="1" to="#_lastpage_#" index="pp">
                            <option value="#pp#"<cfif attributes.page eq pp >selected</cfif>>#pp#</option>
                        </cfloop>
                        </cfoutput>	
                    </select>
                   <cf_get_lang_main no="1417.Kayıt Sayısı"> : <cfoutput>#GET_STOCK_STATIONS.recordcount#</cfoutput>&nbsp;
                 </td>
            </tr>
        </tfoot>
    <cfelse>
    	<tbody>
            <tr>
                <td colspan="9"><cf_get_lang_main no="72.Kayıt Yok">!</td>
            </tr>  
        </tbody>  
    </cfif>
</cf_medium_list>
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
				alert("<cf_get_lang_main no='3445.Satırdaki İstasyon Aktif Değil.'> <cf_get_lang_main no='3446.Lütfen İstasyonu Değiştiriniz.'>");
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
				AjaxPageLoad('#request.self#?fuseaction=prod.popup_upd_ezgi_ws_product&is_show_other_ws='+is_show_other_ws+'&list_product_name='+list_product_name+'&list_stock_id_='+list_stock_id+'&main_stock_id=#attributes.main_stock_id#&headers=#attributes.headers#&stock_id=#attributes.stock_id#&page='+page+'','_show_stations_',1);
			<cfelseif isdefined('attributes.ws_id')>
				AjaxPageLoad('#request.self#?fuseaction=prod.popup_upd_ezgi_ws_product&is_show_other_ws='+is_show_other_ws+'&list_product_name='+list_product_name+'&list_stock_id_='+list_stock_id+'&headers=#attributes.headers#&ws_id=#attributes.ws_id#&page='+page+'','_show_stations_',1);
			<cfelseif isdefined('attributes.operation_type_id')>
				AjaxPageLoad('#request.self#?fuseaction=prod.popup_upd_ezgi_ws_product&is_show_other_ws='+is_show_other_ws+'&list_product_name='+list_product_name+'&list_stock_id_='+list_stock_id+'&headers=#attributes.headers#&operation_type_id=#attributes.operation_type_id#&page='+page+'','_show_stations_',1);
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
			
				document.upd_production_order.action = document.upd_production_order.action+'&is_show_other_ws='+is_show_other_ws+'&upd_row_id='+row_id+'&selected_row_id='+selected_row_id;
				AjaxFormSubmit('upd_production_order','add_stations_info',1,"<cf_get_lang_main no ='1926.Güncelleniyor'>","<cf_get_lang_main no ='1927.Güncellendi'>!");
				document.upd_production_order.action = '#send_#';
			}
			else{
				document.upd_production_order.action = document.upd_production_order.action+'&del_row_id='+row_id;
				<cfif isdefined('attributes.stock_id')>
					AjaxFormSubmit('upd_production_order','add_stations_info',1,"<cf_get_lang_main no ='1929.Siliniyor'>..","<cf_get_lang_main no ='1924.Silindi'>",'#request.self#?fuseaction=prod.popup_upd_ezgi_ws_product&is_show_other_ws='+is_show_other_ws+'&main_stock_id=#attributes.main_stock_id#&headers=#attributes.headers#&stock_id=#attributes.stock_id#','_show_stations_');
				<cfelseif isdefined('attributes.ws_id')>
					AjaxFormSubmit('upd_production_order','add_stations_info',1,"<cf_get_lang_main no ='1929.Siliniyor'>..","<cf_get_lang_main no ='1924.Silindi'>",'#request.self#?fuseaction=prod.popup_upd_ezgi_ws_product&is_show_other_ws='+is_show_other_ws+'&headers=#attributes.headers#&ws_id=#attributes.ws_id#','_show_stations_');
				<cfelseif isdefined('attributes.operation_type_id')>
					AjaxFormSubmit('upd_production_order','add_stations_info',1,"<cf_get_lang_main no ='1929.Siliniyor'>..","<cf_get_lang_main no ='1924.Silindi'>",'#request.self#?fuseaction=prod.popup_upd_ezgi_ws_product&is_show_other_ws='+is_show_other_ws+'&headers=#attributes.headers#&operation_type_id=#attributes.operation_type_id#','_show_stations_');
				</cfif>
				document.upd_production_order.action = '#send_#';
			}
		}
		function pencere_ac_asset(no)
		{
			adres = '#request.self#?fuseaction=assetcare.popup_list_assetps';
			adres += '&field_id=all.asset_id' + no +'&field_name=all.asset' + no +'&event_id=0&motorized_vehicle=0';
			windowopen(adres,'list');
		}
	</cfoutput>
</script>
<cfabort>