<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("m",-3,now())>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = now()>
</cfif>


<cfparam name="attributes.gun" default="30">
<cfparam name="attributes.gun2" default="60">
<cfparam name="attributes.add_stock_gun" default="15">
<cfparam name="attributes.new_page" default="0">
<cfparam name="attributes.layout_id" default="">



<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#" enctype="multipart/form-data">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <cfinput type="hidden" name="search_startdate" value="#dateformat(attributes.search_startdate,'dd/mm/yyyy')#">
            <cfinput type="hidden" name="search_finishdate" value="#dateformat(attributes.search_finishdate,'dd/mm/yyyy')#">
            <cfinput name="layout_id" id="layout_id" type="hidden" value="#attributes.layout_id#">
            <cfinput name="new_page" id="new_page" type="hidden" value="#attributes.new_page#">
            <cfinput type="hidden" name="search_department_id" value="">
            <cfinput type="hidden" name="is_purchase_type" value="">
            <cfinput type="hidden" name="dept_count_" value="">
            <cfinput type="hidden" name="old_product_list" value="">
            <cf_box_elements>
                <div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group col col-12 col-md-1 col-sm-6 col-xs-12" id="item-promotion_status">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57633.Barkod'> - <cf_get_lang dictionary_id='58800.Ürün Kodu'> - <cf_get_lang dictionary_id='58221.Ürün Adı'> - <cf_get_lang dictionary_id='33087.Liste Fiyatı'> - <cf_get_lang dictionary_id='57641.İskonto'> 1 - <cf_get_lang dictionary_id='57641.İskonto'> 2 - <cf_get_lang dictionary_id='57641.İskonto'> 3 - <cf_get_lang dictionary_id='57641.İskonto'> 4 - <cf_get_lang dictionary_id='57641.İskonto'> 5 - <cf_get_lang dictionary_id='63669.Dahil Maliyet'>
                        </label>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='63670.Toplu Aktar'></label>
                        <input type="file" name="excel_file" value=""/>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='63671.Promosyon Tanımı'></label>
                        <cfinput type="text" name="promotion_head" required="yes" message="#getLang('','Promosyon Tanımı Girmelisiniz',61637)#">
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <input type="submit" value="<cf_get_lang dictionary_id='48868.Yükle'>"/>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
	document.getElementById('search_department_id').value = window.opener.document.getElementById('department_id_list').value;
	document.getElementById('is_purchase_type').value = window.opener.document.getElementById('is_purchase_type').value;
	document.getElementById('dept_count_').value = list_len(window.opener.document.getElementById('department_id_list').value);
	document.getElementById('old_product_list').value = window.opener.document.getElementById('all_product_list').value;
</script>

<cfif isdefined("attributes.is_form_submitted")>
        <cfset attributes.update_product_list = "">
		<cfset upload_folder = "#upload_folder##dir_seperator#">
        <cftry>
            <cffile action="UPLOAD" filefield="excel_file" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE">
            <cfset file_name = createUUID()>
            <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
            <cfset dosya_ = "#file_name#.#cffile.serverfileext#">
            
            <cfspreadsheet action="read" src="#upload_folder##file_name#.#cffile.serverfileext#" query="queryData"> 
            <cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
                    
            <cfset product_list_ = "">
            

	
            <cfoutput query="queryData">
                <cfif currentrow neq 1>
                    <cfquery name="get_product" datasource="#dsn3#">
                        SELECT 
                            S.PRODUCT_ID 
                        FROM 
                            STOCKS_BARCODES SB,
                            STOCKS S
                        WHERE
                            SB.STOCK_ID = S.STOCK_ID AND
                            SB.BARCODE = '#COL_1#' 
                    </cfquery>
                    <cfif get_product.recordcount and (not listlen(attributes.old_product_list) or not listfindnocase(attributes.old_product_list,get_product.product_id))>
                        <cfset product_list_ = listappend(product_list_,get_product.PRODUCT_ID)>
                        <cfset 'get_table_info.standart_alis_#get_product.PRODUCT_ID#_0_0' = "#col_4#">
                        <cfset 'get_table_info.standart_alis_indirim_tutar_#get_product.PRODUCT_ID#_0_0' = 0>
                        <cfset discount_list = ''>
                        <cfif len(col_5)>
                        	<cfset deger_ = replace(col_5,'%','','all')>
                            <cfset discount_list = listappend(discount_list,deger_,'+')>
                        </cfif>
                        <cfif len(col_6)>
                        	<cfset deger_ = replace(col_6,'%','','all')>
                            <cfset discount_list = listappend(discount_list,deger_,'+')>
                        </cfif>
                        <cfif len(col_7)>
                        	<cfset deger_ = replace(col_7,'%','','all')>
                            <cfset discount_list = listappend(discount_list,deger_,'+')>
                        </cfif>
                        <cfif len(col_8)>
                        	<cfset deger_ = replace(col_8,'%','','all')>
                            <cfset discount_list = listappend(discount_list,deger_,'+')>
                        </cfif>
                        <cfif len(col_9)>
                        	<cfset deger_ = replace(col_9,'%','','all')>
                            <cfset discount_list = listappend(discount_list,deger_,'+')>
                        </cfif>
                        <cfset 'get_table_info.standart_alis_indirim_yuzde_#get_product.PRODUCT_ID#_0_0' = discount_list>
                    <cfelseif listlen(attributes.old_product_list) and listfindnocase(attributes.old_product_list,get_product.product_id)>
                    	<cfset attributes.is_update_rows = 1>
                        <cfif not listfind(attributes.update_product_list,get_product.product_id)>
                        	<cfset attributes.update_product_list = listappend(attributes.update_product_list,get_product.product_id)>
                        </cfif>
                        <cfset 'get_table_info.standart_alis_#get_product.PRODUCT_ID#_0_0' = "#col_4#">
                        <cfset 'get_table_info.standart_alis_indirim_tutar_#get_product.PRODUCT_ID#_0_0' = 0>
                        <cfset discount_list = ''>
                        <cfif len(col_5)>
                        	<cfset deger_ = replace(col_5,'%','','all')>
                            <cfset discount_list = listappend(discount_list,deger_,'+')>
                        </cfif>
                        <cfif len(col_6)>
                        	<cfset deger_ = replace(col_6,'%','','all')>
                            <cfset discount_list = listappend(discount_list,deger_,'+')>
                        </cfif>
                        <cfif len(col_7)>
                        	<cfset deger_ = replace(col_7,'%','','all')>
                            <cfset discount_list = listappend(discount_list,deger_,'+')>
                        </cfif>
                        <cfif len(col_8)>
                        	<cfset deger_ = replace(col_8,'%','','all')>
                            <cfset discount_list = listappend(discount_list,deger_,'+')>
                        </cfif>
                        <cfif len(col_9)>
                        	<cfset deger_ = replace(col_9,'%','','all')>
                            <cfset discount_list = listappend(discount_list,deger_,'+')>
                        </cfif>
                        <cfset 'get_table_info.standart_alis_indirim_yuzde_#get_product.PRODUCT_ID#_0_0' = discount_list>
                        <script>
							standart_alis_#get_product.PRODUCT_ID# = #wrk_round(col_4)#;
							standart_alis_indirim_tutar_#get_product.PRODUCT_ID# = 0;
							standart_alis_indirim_yuzde_#get_product.PRODUCT_ID# = '#discount_list#';
						</script>
                    </cfif>
                </cfif>
            </cfoutput>
            
            <cfset attributes.table_code = ''>
            <cfset attributes.product_id = product_list_> 
            <cfset attributes.is_excel = 1>
            <cfset attributes.add_action = 1>
            <cfset attributes.new_page = 1>
            <cfinclude template="add_row_to_speed_manage_product_inner.cfm">
            <cfcatch type="any">
            	<!---<cfdump var="#queryData#">
		<cfdump var="#cfcatch#">--->
				<script>
                    alert('<cf_get_lang dictionary_id='63672.Dosya Uygun Değil'>!');
                    //history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
</cfif>