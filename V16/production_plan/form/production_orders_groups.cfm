<cfparam name="attributes.station_id" default="">
<cfparam name="_stock_id_list_specsiz_" default="-1">
<cfparam name="_spec_main_id_list_" default="0">
<cfsetting showdebugoutput="no">
<cfquery name="GET_W" datasource="#dsn3#">
	SELECT * FROM WORKSTATIONS ORDER BY STATION_NAME
</cfquery>
<cfquery name="get_all_production" datasource="#dsn3#">
    SELECT
        SUM(PO.QUANTITY) AS QUANTITY,
        PO.STOCK_ID,
        ISNULL(PO.SPEC_MAIN_ID,0) AS SPEC_MAIN_ID,
        S.STOCK_CODE,
        S.PRODUCT_NAME,
		PU.MAIN_UNIT
    FROM 
        PRODUCTION_ORDERS PO,
        STOCKS S,
		PRODUCT_UNIT PU
    WHERE
    	S.STOCK_ID = PO.STOCK_ID AND
    	S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
        PO.P_ORDER_ID IN (#attributes.p_order_id_list#)
    GROUP BY PO.STOCK_ID,PO.SPEC_MAIN_ID,S.STOCK_CODE,S.PRODUCT_NAME,PU.MAIN_UNIT
</cfquery>
<!--- Malzeme ihtiyaçlarını belirlemek için,gelen spec'li yada specsiz ürünler için 2 tane stock_list oluşturucaz.
ve aşağıda uniounlu bir query ile product_tree ve spect_main_row tablolarından bileşenleri çekicez.
 --->
 <cfquery name="get_all_production_1" dbtype="query"><!--- ÖNCELİKLE SPEC'İ OLMAYAN ÜRÜNLERİ QUERYOFQUERY İLE ÇEKİYORUZ. --->
	SELECT * FROM get_all_production WHERE SPEC_MAIN_ID = 0
</cfquery>
<cfif get_all_production_1.recordcount>
	<cfset _stock_id_list_specsiz_ = ValueList(get_all_production_1.STOCK_ID,',')>
</cfif>
<cfquery name="get_all_production_2" dbtype="query"><!--- DAHA SONRA MAIN_SPEC'I OLANLARI ÇEKİYORUZ. --->
	SELECT * FROM get_all_production WHERE SPEC_MAIN_ID IS NOT NULL
</cfquery>
<cfif get_all_production_2.recordcount>
	<cfset _spec_main_id_list_ = ValueList(get_all_production_2.SPEC_MAIN_ID,',')>
</cfif>
<cfloop query="get_all_production"><cfscript>'amounts_p_#STOCK_ID#_#SPEC_MAIN_ID#' = QUANTITY;</cfscript></cfloop>
<cf_box>
        <!-- sil -->
        <cfform name="upd_p_orders_group" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_p_orders_groups">
         <cf_box_elements>   
            <div class="col col-6 col-md-6 col-sm-12">
                <div class="form-group">
                    <label class="col col-3 col-sm-12"><cf_get_lang dictionary_id='58834.İstasyon'></label>
                    <input type="hidden" name="p_order_id_list" id="p_order_id_list" value="<cfoutput>#attributes.p_order_id_list#</cfoutput>">
                    <div class="col col-8 col-sm-12">
                        <select name="_station_id_" id="_station_id_" style="width:150px;">
                            <cfoutput query="get_w">
                                <option value="#station_id#"<cfif attributes.station_id eq station_id >selected</cfif>>#station_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-3 col-sm-12"><cf_get_lang dictionary_id ='36698.Lot No'></label>
                    <div class="col col-8 col-sm-12">
                        <cf_papers paper_type="production_lot">
                        <input type="text" name="_lot_no_" id="_lot_no_" value="<cfoutput>#paper_number#</cfoutput>" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-3 col-sm-12"><cf_get_lang dictionary_id ='57629.Açıklama'>/<cf_get_lang dictionary_id ='36919.Talimat'></label>
                	<div class="col col-8 col-sm-12">
                        <input  type="hidden" id="is_saved_paper" name="is_saved_paper" value="">
                        <input type="text" name="detail" id="detail">
                    
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-3 col-sm-12"><cf_get_lang dictionary_id ='36922.Direkt Operaötöre Gönder'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="checkbox" name="is_operator_display" id="is_operator_display" checked value="1">
                        </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-12">
                <cfset _now_ = date_add('h',session.ep.TIME_ZONE,now())>
                <cfquery name="get_station_times" datasource="#dsn#">
                    SELECT top 1 SHIFT_NAME,START_HOUR,START_MIN,END_HOUR,END_MIN FROM SETUP_SHIFTS WHERE IS_PRODUCTION = 1 AND FINISHDATE > #_now_#
                </cfquery>
                <cfoutput>
                        <div class="form-group">                
                            <label class="col col-3 col-sm-12"><cf_get_lang dictionary_id ='58467.Başlama'></label>                    
                            <div class="col col-4 col-sm-12">
                                <input type="text" name="p_start_date" id="p_start_date"  value="#dateformat(now(),dateformat_style)#">
                            </div>
                            <div class="col col-2 col-sm-12">
                                <select name="p_start_h" id="p_start_h">
                                    <cfloop from="0" to="23" index="i">
                                        <option value="#i#" <cfif get_station_times.START_HOUR eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
                            </div>
                            <div class="col col-2 col-sm-12">
                                <select name="p_start_m" id="p_start_m">
                                    <cfloop from="0" to="59" index="i">
                                        <option value="#i#" <cfif get_station_times.START_MIN eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-sm-12"><cf_get_lang dictionary_id ='57502.Bitiş'></label> 
                            <div class="col col-4 col-sm-12">
                                <input type="text" name="p_finish_date" id="p_finish_date"  value="#dateformat(now(),dateformat_style)#" >	
                            </div>
                            <div class="col col-2 col-sm-12">			
                                <select name="p_finish_h" id="p_finish_h">
                                    <cfloop from="0" to="23" index="i">
                                        <option value="#i#"  <cfif get_station_times.END_HOUR eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
                            </div>
                            <div class="col col-2 col-sm-12">
                                <select name="p_finish_m" id="p_finish_m">
                                    <cfloop from="0" to="59" index="i">
                                        <option value="#i#" <cfif get_station_times.END_MIN eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-sm-12"><cf_get_lang dictionary_id ='36795.Çalışma Programı'> : </label>
                            <div class="col col-8 col-sm-12"><font color="red">#get_station_times.SHIFT_NAME#</font></div>                 
                        </div>
                </cfoutput>
            </div>
            </cf_box_elements>
        </cfform>
        <cf_box_footer>
            <input type="button" id="production_group_button" value="<cf_get_lang dictionary_id ='36923.Parti Emri Ver'>" onClick="form_submit_group();">
            <input type="button" value="<cf_get_lang dictionary_id ='57858.Excel Getir'>" name="excelll" id="excelll" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_documenter&module=groups_p','small','popup_documenter');">
            <div id="_show_upd_message_"></div>
        </cf_box_footer>
        <!-- sil -->
        <cfif get_all_production.recordcount>
            <cfquery name="get_tree_p" datasource="#dsn3#">                
                 SELECT
                    0 SPECT_MAIN_ID,
                    AMOUNT AS  AMOUNT_,
                    PT.RELATED_ID,
                    S.PRODUCT_NAME AS REL_PRODUCT_NAME,
                    PT.STOCK_ID,
                    S.STOCK_CODE AS  REL_STOCK_CODE,
					'' SPECT_MAIN_NAME,
					PU.MAIN_UNIT
                FROM 
                    PRODUCT_TREE PT, 
                    STOCKS S,
					PRODUCT_UNIT PU
                WHERE 
                    S.STOCK_ID = PT.RELATED_ID AND 
                    S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND 
                    PT.STOCK_ID IN(#_stock_id_list_specsiz_#) 
            UNION ALL
                SELECT
                    SMR.SPECT_MAIN_ID,
                    SMR.AMOUNT AS AMOUNT_,
                    SMR.STOCK_ID AS RELATED_ID,
                    S.PRODUCT_NAME AS REL_PRODUCT_NAME,
                    SM.STOCK_ID,
                    S.STOCK_CODE AS REL_STOCK_CODE,
					SM.SPECT_MAIN_NAME,
					PU.MAIN_UNIT
                FROM
                    SPECT_MAIN_ROW SMR,
                    SPECT_MAIN SM,
                    STOCKS S,
					PRODUCT_UNIT PU
                WHERE
                    SMR.STOCK_ID IS NOT NULL AND
                    S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND 
                    SMR.STOCK_ID = S.STOCK_ID AND
                    SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID AND
                    SM.SPECT_MAIN_ID IN (#_spec_main_id_list_#)
            </cfquery>
            <cfset _stock_id_list_ = ''>
            <cfset girdiler_stock_id_list_ = ''>
            <cfloop query="get_tree_p"><!--- değerleri grupluyoruz. --->
                <cfscript>
                   if(not isdefined('products_values_#RELATED_ID#')){
				   		if(isdefined('amounts_p_#STOCK_ID#_#SPECT_MAIN_ID#'))
                       		'products_values_#RELATED_ID#' = '#REL_PRODUCT_NAME#█#Evaluate('amounts_p_#STOCK_ID#_#SPECT_MAIN_ID#')*AMOUNT_#█#SPECT_MAIN_NAME#█#MAIN_UNIT#';//alt+987
                        else
							'products_values_#RELATED_ID#' = '#REL_PRODUCT_NAME#█#AMOUNT_#█#SPECT_MAIN_NAME#█#MAIN_UNIT#';//alt+987
						_stock_id_list_ = ListAppend(_stock_id_list_,RELATED_ID,',');
                        _stock_id_list_ = ListAppend(_stock_id_list_,replace(REL_STOCK_CODE,',',';','all'),'-');
                    }	
                    else{
						if(isdefined('amounts_p_#STOCK_ID#_#SPECT_MAIN_ID#'))
                       		'products_values_#RELATED_ID#' = '#REL_PRODUCT_NAME#█#ListGetAt(Evaluate("products_values_#RELATED_ID#"),2,'█')+(Evaluate('amounts_p_#STOCK_ID#_#SPECT_MAIN_ID#')*AMOUNT_)#█#SPECT_MAIN_NAME#█#MAIN_UNIT#';
                   		else
							'products_values_#RELATED_ID#' = '#REL_PRODUCT_NAME#█#ListGetAt(Evaluate("products_values_#RELATED_ID#"),2,'█')+(AMOUNT_)#█#SPECT_MAIN_NAME#█#MAIN_UNIT#';	
				    }	
                </cfscript>
            </cfloop>
                <div class="col col-6 col-md-6 col-sm-12">
                    <cf_grid_list>
                    <thead>
                        <tr>
                            <th colspan="4"><cf_get_lang dictionary_id ='36472.Girdiler'>/<cf_get_lang dictionary_id ='30009.Sarflar'></th>
                        </tr>
                        <tr height="20">
                            <th width="80"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
                            <th width="200"><cf_get_lang dictionary_id ='57657.Ürün'>/<cf_get_lang dictionary_id ='57629.Açıklama'></th>
                            <th width="60" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></th>
                            <th width="40"><cf_get_lang dictionary_id ='57636.Birim'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop list="#_stock_id_list_#" index="_sid_" delimiters=",">
                        <tr>
                            <cfoutput>
                                <td>#ListGetAt(_sid_,2,'-')#</td>
                                <td>#ListGetAt(Evaluate('products_values_#ListGetAt(_sid_,1,'-')#'),1,'█')#</td>
                                <td style="text-align:right;">#tlformat(ListGetAt(Evaluate('products_values_#ListGetAt(_sid_,1,'-')#'),2,'█'))#</td>
                                <td style="text-align:right;">#ListGetAt(Evaluate('products_values_#ListGetAt(_sid_,1,'-')#'),4,'█')#</td>
                            </cfoutput>
                        </tr>
                        </cfloop>
                    </tbody>
                    </cf_grid_list>
                </div>                    
                <div class="col col-6 col-md-6 col-sm-12">
                    <cf_grid_list>
                    <thead>
                        <tr>
                            <th colspan="4"><cf_get_lang dictionary_id ='36476.Çıktılar'>/<cf_get_lang dictionary_id ='36789.Üretim Sonuçları'></th>
                        </tr>
                        <tr>
                            <th width="80"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
                            <th width="200"><cf_get_lang dictionary_id ='57657.Ürün'>/<cf_get_lang dictionary_id ='57629.Açıklama'></th>
                            <th width="60" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></th>
                            <th width="40"><cf_get_lang dictionary_id ='57636.Birim'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="get_all_production">
                            <tr class="color-row" eight="20">
                                <td>#STOCK_CODE#</td>
                                <td>#PRODUCT_NAME#-[#SPEC_MAIN_ID#]</td>
                                <td style="text-align:right;">#tlformat(QUANTITY)#</td>
                                <td style="text-align:right;">#MAIN_UNIT#</td>
                            </tr>					
                        </cfoutput>
                    </tbody>
                    </cf_grid_list>
                </div>
        </cfif>        
</cf_box>
<script type="text/javascript">
	function date_control(){
		if((document.getElementById('p_start_date').value != "") && (document.getElementById('p_finish_date').value != ""))
		return time_check(document.getElementById('p_start_date'), document.getElementById('p_start_h'), document.getElementById('p_start_m'), document.getElementById('p_finish_date'),  document.getElementById('p_finish_h'), document.getElementById('p_finish_m'), "<cf_get_lang dictionary_id ='36918.Üretim Başlama Tarihi,Bitiş Tarihinden Önce Olmalıdır'> !");
		else
		{
			alert("<cf_get_lang dictionary_id ='36830.Başlangıç ve Bitiş Tarihi Giriniz'>");return false;
		}
	}
	function form_submit_group(){
		_kontol_ = date_control();
		if(_kontol_ == true){
			if(document.getElementById('_lot_no_').value ==""){
				alert("<cf_get_lang dictionary_id ='36921.Lot No Boş Olamaz'>!");
				return false;
			}
			AjaxFormSubmit('upd_p_orders_group','_show_upd_message_',0,'Kaydediliyor..','Kaydedildi.','','',1)
		}
	}	
</script>
