<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT RATE1,RATE2,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND COMPANY_ID = #SESSION.EP.COMPANY_ID#
</cfquery>
<cfset url_str = "">
<cfif isdefined("attributes.spect_main_id")>
	<cfset url_str = "#url_str#&spect_main_id=#attributes.spect_main_id#">
</cfif>
<cfif isdefined("attributes.field_main_id")>
	<cfset url_str = "#url_str#&field_main_id=#attributes.field_main_id#">
</cfif>
<cfif isdefined("attributes.create_main_spect_and_add_new_spect_id")>
	<cfset url_str = "#url_str#&create_main_spect_and_add_new_spect_id=#attributes.create_main_spect_and_add_new_spect_id#">
</cfif>
<cfif isdefined("attributes.stock_id")>
	<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
</cfif>
<cfif isdefined("attributes.product_id")>
	<cfset url_str = "#url_str#&product_id=#attributes.product_id#">
</cfif>
<cfif isdefined("attributes.row_id")>
	<cfset url_str = "#url_str#&row_id=#attributes.row_id#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.basket_id") and len(attributes.basket_id)>
	<cfset url_str = "#url_str#&basket_id=#attributes.basket_id#">
<cfelse>
	<cfset attributes.basket_id=2>
	<cfset url_str = "#url_str#&basket_id=2">
</cfif>
<cfif isdefined("attributes.is_refresh")>
	<cfset url_str = "#url_str#&is_refresh=#attributes.is_refresh#">
</cfif>
<cfif isdefined("attributes.form_name")>
	<cfset url_str = "#url_str#&form_name=#attributes.form_name#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfloop query="GET_MONEY">
	<cfif isdefined("attributes.#money#") >
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfif isdefined("attributes.search_process_date")>
	<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isdefined("attributes.main_stock_amount")>
	<cfset url_str = "#url_str#&main_stock_amount=#attributes.main_stock_amount#">
</cfif> 
<cfif isdefined("attributes.paper_location")>
	<cfset url_str = "#url_str#&paper_location=#attributes.paper_location#">
</cfif>
<cfif isdefined("attributes.paper_department")>
	<cfset url_str = "#url_str#&paper_department=#attributes.paper_department#">
</cfif>

<cfif isdefined("attributes.ship_id") and attributes.ship_id gt 0>
	<cfset url_str = "#url_str#&ship_id=#attributes.ship_id#">
</cfif>
<cfif isdefined("attributes.order_id") and attributes.order_id gt 0>
	<cfset url_str = "#url_str#&order_id=#attributes.order_id#">
</cfif>
<cfif isdefined("attributes.sepet_process_type") and attributes.sepet_process_type gt 0>
	<cfset url_str = "#url_str#&sepet_process_type=#attributes.sepet_process_type#">
</cfif>
<cfif isdefined("is_spect_name_to_property")>
	<cfset url_str = "#url_str#&is_spect_name_to_property=#is_spect_name_to_property#">
</cfif>
<!--- belge tarihi varsa onun uzerinden fiyat bulunur yoksa now dan--->
<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
	<cf_date tarih="attributes.search_process_date">
<cfelse>
	<cfset attributes.search_process_date=now()>
</cfif>
<cfif not isdefined("attributes.id")>
 	<cfif not isdefined("attributes.stock_id") or (isdefined("attributes.stock_id") and not len(attributes.stock_id))>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='57725.Ürün Seçiniz'>!");
			window.close();
		</script>
		<cfabort>
	<cfelse>
		<cfquery name="get_product_id" datasource="#dsn1#">
			SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #attributes.stock_id#
		</cfquery>
		<cfset attributes.product_id=get_product_id.PRODUCT_ID>
	</cfif>
</cfif> 
<cfif len(attributes.product_id)>
	<cfquery name="GET_PRODUCT" datasource="#dsn3#">
		SELECT IS_PROTOTYPE,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #attributes.product_id#
	</cfquery>
<cfelse>
	<cfset GET_PRODUCT.recordcount=0>
</cfif>
<cfif not isdefined('attributes.id')>
	<cfquery name="GET_MONEY_MAX" datasource="#dsn3#"><!--- elimizde bir spect olmadığı için sayfa içindeki görünmeyen hesapları yapmak içinde olsa,bir spect money'e ihtiyaç var,o sebeble spec_money'den en son kaydı çekiyoruz ki eksik para birimi olmasın diye --->
		SELECT MAX(ACTION_ID) ID FROM SPECT_MONEY
	</cfquery>	
</cfif>
<cfif isdefined('attributes.id') or (not isdefined('attributes.id') and len(GET_MONEY_MAX.ID))>
	<cfquery name="GET_MONEY" datasource="#dsn3#">
		SELECT
			MONEY_TYPE MONEY,
			RATE1,
			RATE2,
			IS_SELECTED
		FROM
			SPECT_MONEY
		WHERE
			ACTION_ID=<cfif isdefined('attributes.id')>#attributes.id#<cfelse>#GET_MONEY_MAX.ID#</cfif>
		ORDER BY MONEY_TYPE
	</cfquery>
<cfelse>
	<cfquery name="GET_MONEY" datasource="#dsn2#">
		SELECT
			MONEY,
			RATE1,
			RATE2,
			0 IS_SELECTED
		FROM
			SETUP_MONEY
	</cfquery>
</cfif>
<cfif GET_MONEY.recordcount eq 0 or GET_MONEY.rate2 eq 0>
	<cfquery name="GET_MONEY" datasource="#dsn2#">
		SELECT
			MONEY,
			RATE1,
			RATE2,
			0 IS_SELECTED
		FROM
			SETUP_MONEY
	</cfquery>
</cfif>
<cfif isdefined('attributes.id')>
<cfif GET_SPECT.PRODUCT_AMOUNT_CURRENCY is 'TL' and session.ep.period_year lt 2009>
	<cfset GET_SPECT.PRODUCT_AMOUNT_CURRENCY = 'YTL'>
</cfif>
</cfif>
<cfquery name="GET_MAIN_PRICE" dbtype="query">
    SELECT RATE2, RATE1 FROM GET_MONEY WHERE 
	<cfif not isdefined('GET_SPECT.PRODUCT_AMOUNT_CURRENCY') or (GET_SPECT.PRODUCT_AMOUNT_CURRENCY is 'YTL' or GET_SPECT.PRODUCT_AMOUNT_CURRENCY is 'TL')>
        MONEY = 'YTL' or MONEY = 'TL'
    <cfelse>
       MONEY = '#GET_SPECT.PRODUCT_AMOUNT_CURRENCY#'
    </cfif>
</cfquery>
<cfif not GET_MAIN_PRICE.recordcount and GET_SPECT.PRODUCT_AMOUNT_CURRENCY is 'TL'>
    <cfquery name="GET_MAIN_PRICE" dbtype="query">
        SELECT RATE2, RATE1 FROM GET_MONEY WHERE MONEY = 'YTL'
    </cfquery>
</cfif>
<cfif spec_purchasesales eq 1>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#dsn#">
			SELECT 
				PRICE_CAT 
			FROM 
				COMPANY_CREDIT 
			WHERE 
				COMPANY_ID = #attributes.company_id#  AND 
				OUR_COMPANY_ID = #session.ep.company_id#
		</cfquery>
		<cfif GET_PRICE_CAT_CREDIT.RECORDCOUNT and len(GET_PRICE_CAT_CREDIT.PRICE_CAT)>
			<cfset attributes.price_catid=GET_PRICE_CAT_CREDIT.PRICE_CAT>
		<cfelse>
			<cfquery name="GET_COMP_CAT" datasource="#dsn#">
				SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
			</cfquery>
			<cfquery name="GET_PRICE_CAT_COMP" datasource="#dsn3#">
				SELECT 
					PRICE_CATID
				FROM
					PRICE_CAT
				WHERE
					COMPANY_CAT LIKE '%,#GET_COMP_CAT.COMPANYCAT_ID#,%'
			</cfquery>
			<cfset attributes.price_catid=GET_PRICE_CAT_COMP.PRICE_CATID>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfquery name="GET_COMP_CAT" datasource="#DSN#">
			SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
		</cfquery>
		<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
			SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE '%,#get_comp_cat.consumer_cat_id#,%'
		</cfquery>
		<cfset attributes.price_catid=get_price_cat.PRICE_CATID>
	</cfif>
</cfif>
<cfquery name="get_money_2" dbtype="query">
	SELECT * FROM GET_MONEY WHERE MONEY = '#session.ep.money2#'
</cfquery>
<cfquery name="GET_SPECT_ROW" datasource="#dsn3#">
	<cfif not isdefined('attributes.upd_main_spect')><!--- Eğer Güncelleme Sayfası olarak çalışmayacaksa normal şekilde spect'den kayıtları alsın --->
		SELECT 
			STOCKS.IS_PRODUCTION,
			SPECTS_ROW.RELATED_SPECT_ID AS SPECT_MAIN_ID,
			SPECTS_ROW.*,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			STOCKS.IS_PRODUCTION,
            SPECTS_ROW.LINE_NUMBER,
			(SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = SPECTS_ROW.RELATED_SPECT_ID) SPECT_MAIN_NAME
		FROM 
			SPECTS_ROW,
			STOCKS
		WHERE 
			SPECT_ID = #attributes.id#
			AND SPECTS_ROW.STOCK_ID=STOCKS.STOCK_ID
	UNION 
		SELECT
			0 AS IS_PRODUCTION,
			SPECTS_ROW.RELATED_SPECT_ID AS SPECT_MAIN_ID,
			SPECTS_ROW.*,
			'',
			'',
			0 AS IS_PRODUCTION,
            SPECTS_ROW.LINE_NUMBER,
			(SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = SPECTS_ROW.RELATED_SPECT_ID) SPECT_MAIN_NAME
		FROM 
			SPECTS_ROW
		WHERE 
			SPECT_ID = #attributes.id# AND
			STOCK_ID IS NULL
       ORDER BY  
       		SPECTS_ROW.LINE_NUMBER    
	<cfelse><!--- Eğer main spec güncelle olarak çalışacaksa ise SPECT_MAIN'den kayıtları alsın. --->	
		SELECT
			0 AS DIFF_PRICE,
			0 AS TOTAL_VALUE,
			SPECT_MAIN_ROW.AMOUNT AS AMOUNT_VALUE,
			'#session.ep.money#' as MONEY_CURRENCY,
			STOCKS.IS_PRODUCTION,
			SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID AS SPECT_MAIN_ID,
			SPECT_MAIN_ROW.*,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			STOCKS.IS_PRODUCTION,
            SPECT_MAIN_ROW.LINE_NUMBER,
			(SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID) SPECT_MAIN_NAME
		FROM 
			SPECT_MAIN_ROW,
			STOCKS
		WHERE 
			SPECT_MAIN_ID = #attributes.SPECT_MAIN_ID#
			AND SPECT_MAIN_ROW.STOCK_ID=STOCKS.STOCK_ID
		UNION 
		SELECT
			0 AS DIFF_PRICE,
			1 AS TOTAL_VALUE,
			SPECT_MAIN_ROW.AMOUNT AS AMOUNT_VALUE,
			'#session.ep.money#' as MONEY_CURRENCY,
			0 AS IS_PRODUCTION,
			0 AS SPECT_MAIN_ID,
			SPECT_MAIN_ROW.*,
			'',
			'',
			0 AS IS_PRODUCTION,
            SPECT_MAIN_ROW.LINE_NUMBER,
			'' SPECT_MAIN_NAME
		FROM 
			SPECT_MAIN_ROW
		WHERE 
			SPECT_MAIN_ID = #attributes.SPECT_MAIN_ID# AND
			(STOCK_ID IS NULL OR STOCK_ID = 0)
       ORDER BY  
       		SPECT_MAIN_ROW.LINE_NUMBER    
	</cfif>	
</cfquery>
	<cfset all_product_id_list = listdeleteduplicates(ValueList(GET_SPECT_ROW.PRODUCT_ID,','))>
    <cfset all_product_conf_id_list = listdeleteduplicates(ValueList(GET_SPECT_ROW.CONFIGURATOR_VARIATION_ID,','))>
    <cfif listlen(all_product_conf_id_list,',')>
		<cfloop list="#all_product_conf_id_list#" index="pfi_">
        	<cfset 'selected_prod_conf_row_id_#pfi_#' = 1>
        </cfloop>
	</cfif>
	<cfif not isdefined('is_show_cost') or (isdefined('is_show_cost') and is_show_cost eq 1)>
	<!---Maliyet Kısmı  --->
	<cfif listlen(GET_SPECT_ROW.recordcount) and listlen(all_product_id_list)>
		<cfquery name="get_product_cost_all" datasource="#dsn1#"><!--- Maliyetler geliyor. --->
			SELECT  
				PRODUCT_ID,
				PURCHASE_NET_SYSTEM,
				PURCHASE_EXTRA_COST_SYSTEM
			FROM
				PRODUCT_COST	
			WHERE
				PRODUCT_COST_STATUS = 1
				AND PRODUCT_ID IN (#all_product_id_list#)
				ORDER BY START_DATE DESC,RECORD_DATE DESC
		</cfquery>
	</cfif>
	<!---Maliyet  --->
</cfif>
<cfset is_upd_ = 1>	
<cfquery name="GET_PROPERTY" dbtype="query">
	SELECT * FROM GET_SPECT_ROW WHERE IS_PROPERTY = 1
</cfquery>
<cfset row = get_spect_row.recordcount>
<cfset new_var_list = valuelist(GET_PROPERTY.CONFIGURATOR_VARIATION_ID)>
<cfset new_property_list = valuelist(GET_PROPERTY.property_id)>
<table style="width:100%; height:98%" cellspacing="1" cellpadding="2" class="color-border">
	<cfform  name="add_spect_variations" action="#request.self#?fuseaction=objects.emptypopup_upd_spect_query_new#url_str#" method="post" enctype="multipart/form-data">
    <tr class="color-row">
		<td valign="top">
        	<cfinclude template="add_spect_new_conf.cfm">
        </td>
        <td style="text-align:right;" valign="top">
            <table cellspacing="1" cellpadding="2" border="0" width="100%" class="color-border">
                <input type="hidden" name="new_price" id="new_price" value="">
				<tr class="color-list">
                  <td height="35" class="headbold">
                      <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>	
                            <td class="headbold"><cf_get_lang dictionary_id ='33919.Konfigürasyon/Spec'> :
                            <cfoutput>
                            <cfif isdefined('attributes.spect_main_id')>
                                 #attributes.spect_main_id#	
                                 <cfif isdefined("attributes.id") and len(attributes.id) and attributes.id neq 1>-#attributes.id#</cfif>
                            <cfelse>
                                <cfif isdefined('GET_SPECT') and GET_SPECT.RECORDCOUNT>#GET_SPECT.SPECT_MAIN_ID#-</cfif>
                                <cfif isdefined("attributes.id") and len(attributes.id)>#attributes.id#</cfif>
                            </cfif>	
                            </cfoutput>
                            </td>
                            <td  style="text-align:right;">
                                <cfoutput>
                                <cfif isdefined('GET_PRODUCT.IS_PROTOTYPE') and GET_PRODUCT.IS_PROTOTYPE> <!--- Üretilmeyen Ürünler Konfigüre Edilmez --->
                                <a href="#request.self#?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1#url_str#"><img src="/images/cuberelation.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='33920.Konfigüratör'>"></a>
                                </cfif>
                                </cfoutput>
                            </td>
                        </tr>
                      </table>
                  </td>
                </tr>
                <tr class="color-row">
                    <td>
                        <cfif isdefined('attributes.upd_main_spect')><input type="hidden" name="upd_main_spect" id="upd_main_spect" value="1"></cfif>
                        <input type="hidden" name="order_id" id="order_id" value=""><!---spectin acildigi saydadaki order idnin alinacagı alan--->
                        <input type="hidden" name="ship_id" id="ship_id" value=""><!---spectin acildigi saydadaki ship idnin alinacagı alan--->
                        <input type="hidden" name="search_process_date" id="search_process_date" value="<cfoutput>#attributes.search_process_date#</cfoutput>">
                        <cfif isdefined('attributes.sepet_process_type')><input type="hidden" name="sepet_process_type" id="sepet_process_type" value="<cfoutput>#attributes.sepet_process_type#</cfoutput>"></cfif>
                        <cfif isdefined("attributes.row_id")>
                        <input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
                        </cfif>
                        <input type="hidden" name="spect_id" id="spect_id" value="<cfif isdefined('attributes.id')><cfoutput>#attributes.id#</cfoutput></cfif>">
                        <input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput><cfif isdefined('GET_SPECT') and GET_SPECT.RECORDCOUNT>#GET_SPECT.SPECT_MAIN_ID#</cfif></cfoutput>">
                        <input type="hidden" name="is_change" id="is_change" value="0">	
                         <cfquery name="get_image" datasource="#DSN3#">
                            SELECT 
                            	(SELECT IS_LIMITED_STOCK FROM SPECT_MAIN WHERE SPECT_MAIN_ID=SPECTS.SPECT_MAIN_ID) AS IS_LIMITED_STOCK,
                                FILE_NAME,FILE_SERVER_ID,DETAIL,SPECIAL_CODE_1,SPECIAL_CODE_2,SPECIAL_CODE_3,SPECIAL_CODE_4
                            FROM SPECTS
                            WHERE SPECT_VAR_ID = <cfif isdefined('attributes.id')>#attributes.id#<cfelse>0</cfif>
                         </cfquery>
                        <table cellpadding="1" cellspacing="1" border="0">
                            <tr>
								<td width="65"><cf_get_lang dictionary_id='57647.Spect'></td>
                                <td>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='32755.spec girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="spect_name" required="yes" message="#message#" style="width:250;" value="#get_spect.spect_var_name#" maxlength="500">
                                </td>
                                <td><cf_get_lang dictionary_id ='33922.Fiyatı Güncelle'><input type="checkbox" name="is_price_change" id="is_price_change" value="1"></td>
                                <td width="100"><cf_get_lang dictionary_id='40169.Stoklarla Sınırlı'><input type="checkbox" name="is_limited_stock" id="is_limited_stock" value="1"<Cfif get_image.is_limited_stock eq 1>checked</Cfif>></td>
                                <cfif isdefined('attributes.upd_main_spect')>
                                	<td><cf_get_lang dictionary_id ='57493.Aktif'> <input type="checkbox" name="spect_status" id="spect_status" value="1" <cfif isdefined('GET_SPECT') and GET_SPECT.SPECT_STATUS EQ 1>checked</cfif>></td> 
                                </cfif>
                            </tr>
                            <tr>
                                <cfif isdefined('is_show_detail') and is_show_detail eq 1>
                                <td width="100" valign="top"><cf_get_lang dictionary_id='57771.Detay'>/<cf_get_lang dictionary_id ='33923.Talimat'></td>
                                <td width="170" rowspan="3"><textarea name="spect_detail" id="spect_detail" style="width:250px; height:65px;"><cfoutput>#get_image.DETAIL#</cfoutput></textarea></td>
                                </cfif>
                                <cfif not isdefined('attributes.upd_main_spect')>
                                    <td valign="top"><cf_get_lang dictionary_id ='57515.Dosya Ekle'></td>
                                        <input type="hidden" value="<cfoutput>#get_image.FILE_NAME#</cfoutput>" name="old_files" id="old_files">
                                        <input type="hidden" value="<cfoutput>#get_image.FILE_SERVER_ID#</cfoutput>" name="old_server_id" id="old_server_id">
                                    <td valign="top"><input type="file" name="spect_file_name" id="spect_file_name">
                                    <cfif len(get_image.FILE_NAME)><cf_get_server_file output_file="objects/#get_image.file_name#" output_server="#get_image.file_server_id#" output_type="2" small_image="/images/photo.gif" image_link="1">
                                        <input type="checkbox" value="1" name="del_attach" id="del_attach"><cf_get_lang dictionary_id ='33887.Dosya Sil'>
                                    </cfif>
                                    </td>
                                </cfif>
                            </tr>
                            <cfoutput>
 							<tr>
                            	<td></td>
								<cfif is_show_special_code_1 eq 1>
                               	 	<td><cf_get_lang dictionary_id='57789.Özel Kod'> 1 <input type="text" name="special_code_1" id="special_code_1" value="#get_image.special_code_1#" onBlur="if(!special_code_control('1',this.value))this.value='';"></td>
 								<cfelse>
									<input type="hidden" name="special_code_1" id="special_code_1" value="">
                               	</cfif>
								<cfif is_show_special_code_2 eq 1>
									<td><cf_get_lang dictionary_id='57789.Özel Kod'> 2 <input type="text" name="special_code_2" id="special_code_2" value="#get_image.special_code_2#" onBlur="if(!special_code_control('2',this.value))this.value='';"></td>
  								<cfelse>
									<input type="hidden" name="special_code_2" id="special_code_2" value="">
                              	</cfif>
                            </tr>
                            <script type="text/javascript">
                            	function special_code_control(type,value){
									if(type==1)
										special_code_query_text ="obj_sp_query_result_3";
									else
										special_code_query_text ="obj_sp_query_result_4";
									var sp_query_result = wrk_safe_query(special_code_query_text,'dsn3',value);
									if(sp_query_result.recordcount) {alert(''+sp_query_result.SPECT_MAIN_ID+' nolu Spec Main ve '+sp_query_result.SPECT_VAR_ID+' Spec Var ID de bu özel kodlar kullanılmış.'); return false}
									else return true;
									
								}
                            </script>
 							<tr>
                            	<td></td>
								<cfif is_show_special_code_1 eq 3>
									<td><cf_get_lang dictionary_id='57789.Özel Kod'> 3 <input type="text" name="special_code_3" id="special_code_3" value="#get_image.special_code_3#"></td>
   								<cfelse>
									<input type="hidden" name="special_code_3" id="special_code_3" value="">
                              	</cfif>
								<cfif is_show_special_code_1 eq 4>
                               		<td><cf_get_lang dictionary_id='57789.Özel Kod'> 4 <input type="text" name="special_code_4" id="special_code_4" value="#get_image.special_code_4#"></td>
    							<cfelse>
									<input type="hidden" name="special_code_4" id="special_code_4" value="">
                              	</cfif>
                           </tr>
                            </cfoutput>
                            <tr>
                                <td colspan="2">
                                    <cf_get_lang dictionary_id ='57483.Kayıt'> : <cfoutput>#get_emp_info(get_spect.record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_spect.record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_spect.record_date),timeformat_style)#</cfoutput>
                                    <cfif len(get_spect.update_emp)>
                                    &nbsp;<cf_get_lang dictionary_id ='57703.Güncelleme'> : <cfoutput>#get_emp_info(get_spect.update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_spect.update_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_spect.update_date),timeformat_style)#</cfoutput>
                                    </cfif>
                                </td>
                                <td colspan="2"><cfif isdefined('GET_PRODUCT.IS_PROTOTYPE') and GET_PRODUCT.IS_PROTOTYPE><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></cfif></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="color-header">
                    <td class="form-title" height="22"><cf_get_lang dictionary_id ='33826.Konfigüratör Birleşenleri'></td>
                </tr>
                <tr class="color-row">
                    <td>
                        <table>
                            <cfif session.ep.period_year gt 2008 and isdefined('GET_SPECT.PRODUCT_AMOUNT_CURRENCY') and GET_SPECT.PRODUCT_AMOUNT_CURRENCY is 'YTL'><cfset GET_SPECT.PRODUCT_AMOUNT_CURRENCY = 'TL'></cfif>
                            <cfif session.ep.period_year lt 2009 and isdefined('GET_SPECT.PRODUCT_AMOUNT_CURRENCY') and GET_SPECT.PRODUCT_AMOUNT_CURRENCY is 'TL'><cfset GET_SPECT.PRODUCT_AMOUNT_CURRENCY = 'YTL'></cfif>
                            <tr class="txtbold" height="20">
                                <td width="250" class="txtbold"><cfoutput>#GET_SPECT.SPECT_VAR_NAME#</cfoutput></td>
                                <td width="100"  class="txtbold" style="text-align:right;">1</td>
                                <cfif not isdefined('attributes.UPD_MAIN_SPECT')>
                                <td width="80"  class="txtbold" style="text-align:right;"><cfoutput>#GET_SPECT.PRODUCT_AMOUNT#</cfoutput></td>
                                <td  class="txtbold" style="text-align:right;"><cfoutput>#GET_SPECT.PRODUCT_AMOUNT_CURRENCY#</cfoutput></td>
                            </cfif>
                          </tr>
                        </table>
                    </td>
                </tr>
                <tr class="color-row">
                  <input type="hidden" name="is_update" id="is_update" value="1">
                  <input type="hidden" name="reference_amount" id="reference_amount" value="0">
                  <td colspan="s" valign="top">
                    <table name="table_tree" cellpadding="2" cellspacing="1" id="table_tree">
                      <tr class="color-list" height="20">
                            <td width="15"><input type="button" class="eklebuton" title="" onClick="open_tree_add_row();"></td>
                            <cfif isdefined('is_show_line_number') and is_show_line_number eq 1><td  class="txtboldblue" width="15">No</td></cfif>
                            <td width="120" class="txtboldblue"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
                            <td width="200" class="txtboldblue"><cf_get_lang dictionary_id='57657.Ürün'>/<cf_get_lang dictionary_id ='57629.Açıklama'></td>
							<cfif is_change_spect_name eq 1>
							  <td width="60" class="txtboldblue"><cf_get_lang dictionary_id='54851.Spec Adı'></td>
							</cfif>
							<td width="60" class="txtboldblue"><cf_get_lang dictionary_id='54850.Spec ID'></td>
                            <td width="15" class="txtboldblue"><cf_get_lang dictionary_id ='33926.Sevkte Birleştir'></td>
                            <td width="15" class="txtboldblue"><img src="/images/shema_list.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='33927.Alt Ağaç'>"></td>
                            <td width="45" class="txtboldblue"><cf_get_lang dictionary_id ='57635.Miktar'>*</td>
                            <td width="80" <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="display:none;"</cfif> class="txtboldblue"><cf_get_lang dictionary_id ='33928.Fiyat Farkı'>*</td>
                            <td width="60" <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none;"</cfif> class="txtboldblue"><cf_get_lang dictionary_id ='57489.Para Br'></td>
                            <td width="60" <cfif isdefined('is_show_cost') and is_show_cost eq 0> style="display:none;"</cfif> class="txtboldblue"><cf_get_lang dictionary_id='58258.Maliyet'></td>
                            <td width="100" <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none;"</cfif> class="txtboldblue"><cf_get_lang dictionary_id='58084.Fiyat'></td>
                      </tr>
                        <cfif isdefined("attributes.product_id")>
                            <input type="hidden" name="value_product_id" id="value_product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                            <input type="hidden" name="value_stock_id" id="value_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                            <input type="hidden" name="main_prod_price" id="main_prod_price" value="<cfif not isdefined('attributes.UPD_MAIN_SPECT')><cfoutput>#GET_SPECT.PRODUCT_AMOUNT#</cfoutput><cfelse>0</cfif>">
                            <input type="hidden" name="main_prod_price_currency" id="main_prod_price_currency" value="<cfif not isdefined('attributes.UPD_MAIN_SPECT')><cfoutput>#GET_SPECT.PRODUCT_AMOUNT_CURRENCY#</cfoutput><cfelse>0</cfif>">
                            <input type="hidden" name="main_std_money" id="main_std_money" value="<cfif not isdefined('attributes.UPD_MAIN_SPECT')><cfoutput>#GET_SPECT.PRODUCT_AMOUNT*(GET_MAIN_PRICE.RATE2/GET_MAIN_PRICE.RATE1)#</cfoutput><cfelse>0</cfif>">
                        </cfif>
                        <cfquery name="GET_SPECT_TREE" dbtype="query">
                            SELECT * FROM GET_SPECT_ROW WHERE IS_PROPERTY IN(0,3,4)
                        </cfquery>
						<cfset product_id_list = ''>
						<cfoutput query="GET_SPECT_TREE">
							<cfif len(product_id)>
                          	  <cfset product_id_list=listappend(product_id_list,product_id)>
							</cfif>
						</cfoutput>
                        <cfif isdefined("product_id_list") and len(product_id_list)>
                                <cfquery name="GET_ALTERNATE_PRODUCT" datasource="#dsn3#">
                                    SELECT
                                        DISTINCT
                                        AP.PRODUCT_ID ASIL_PRODUCT,
                                        AP.ALTERNATIVE_PRODUCT_ID,
                                        P.PRODUCT_NAME, 
                                        P.PRODUCT_ID,
                                        P.STOCK_ID,
                                        P.PROPERTY,
                                        P.IS_PRODUCTION
                                    FROM
                                        STOCKS AS P,
                                        ALTERNATIVE_PRODUCTS AS AP
                                    WHERE
                                        <cfif len(attributes.product_id)>
                                        P.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID=#attributes.product_id#) AND
                                        </cfif>
                                        (
                                            (
                                            P.PRODUCT_ID=AP.PRODUCT_ID AND
                                            AP.ALTERNATIVE_PRODUCT_ID IN (#product_id_list#)
                                            )
                                        OR
                                            (
                                            P.PRODUCT_ID=AP.ALTERNATIVE_PRODUCT_ID AND
                                            AP.PRODUCT_ID IN (#product_id_list#)
                                            )
                                        )
                                </cfquery>
                                <cfset product_id_alter_list=0>
                                <cfoutput query="GET_ALTERNATE_PRODUCT">
                                    <cfset product_id_alter_list=ListAppend(product_id_alter_list,GET_ALTERNATE_PRODUCT.PRODUCT_ID,',')>
                                </cfoutput>
                                <cfif spec_purchasesales eq 1>
                                    <cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
                                        <cfquery name="GET_PRICE" datasource="#dsn3#">
                                            SELECT
                                                PRICE_STANDART.PRODUCT_ID,
                                                SM.MONEY,
                                                PRICE_STANDART.PRICE,
                                                (PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
                                                (PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
                                                SM.RATE2,
                                                SM.RATE1
                                            FROM
                                                PRICE PRICE_STANDART,	
                                                PRODUCT_UNIT,
                                                #dsn_alias#.SETUP_MONEY AS SM
                                            WHERE
                                                PRICE_STANDART.PRICE_CATID=#attributes.price_catid# AND
												ISNULL(PRICE_STANDART.STOCK_ID,0)=0 AND
												ISNULL(PRICE_STANDART.SPECT_VAR_ID,0)=0 AND
                                                PRICE_STANDART.STARTDATE< #attributes.search_process_date# AND 
                                                (PRICE_STANDART.FINISHDATE >= #attributes.search_process_date# OR PRICE_STANDART.FINISHDATE IS NULL) AND
                                                PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                                                PRICE_STANDART.PRODUCT_ID IN (#product_id_alter_list#) AND 
                                                PRODUCT_UNIT.IS_MAIN = 1 AND
                                                 <cfif session.ep.period_year lt 2009>
                                                    ((SM.MONEY = PRICE_STANDART.MONEY) OR (SM.MONEY = 'YTL') AND PRICE_STANDART.MONEY = 'TL') AND
                                                <cfelse>
                                                    SM.MONEY = PRICE_STANDART.MONEY AND
                                                </cfif>
                                                SM.PERIOD_ID = #session.ep.period_id#
                                        </cfquery>
                                    </cfif>
                                </cfif>
                                <cfquery name="GET_PRICE_STANDART" datasource="#dsn3#">
                                    SELECT
                                        PRICE_STANDART.PRODUCT_ID,
                                        SM.MONEY,
                                        PRICE_STANDART.PRICE,
                                        (PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
                                        (PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
                                        SM.RATE2,
                                        SM.RATE1
                                    FROM
                                        PRODUCT,
                                        PRICE_STANDART,
                                        #dsn_alias#.SETUP_MONEY AS SM
                                    WHERE
                                        PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
                                        PURCHASESALES = <cfif spec_purchasesales eq 1>1<cfelse>0</cfif> AND
                                        PRICESTANDART_STATUS = 1 AND
                                         <cfif session.ep.period_year lt 2009>
                                            ((SM.MONEY = PRICE_STANDART.MONEY) OR (SM.MONEY = 'YTL') AND PRICE_STANDART.MONEY = 'TL') AND
                                        <cfelse>
                                            SM.MONEY = PRICE_STANDART.MONEY AND
                                        </cfif>
                                        SM.PERIOD_ID = #session.ep.period_id# AND
                                        PRODUCT.PRODUCT_ID IN (#product_id_alter_list#)
                                </cfquery>
                            </cfif>
                        <cfoutput query="GET_SPECT_TREE">
                            <cfif session.ep.period_year gt 2008 and GET_SPECT_TREE.MONEY_CURRENCY is 'YTL'><cfset GET_SPECT_TREE.MONEY_CURRENCY = 'TL'></cfif>
                            <cfif session.ep.period_year lt 2009 and GET_SPECT_TREE.MONEY_CURRENCY is 'TL'><cfset GET_SPECT_TREE.MONEY_CURRENCY = 'YTL'></cfif>
                            <cfif is_configure and len(product_id)>
                                <cfquery name="get_alternative" dbtype="query">
                                    SELECT * FROM GET_ALTERNATE_PRODUCT WHERE ASIL_PRODUCT=#PRODUCT_ID# OR ALTERNATIVE_PRODUCT_ID=#PRODUCT_ID#
                                </cfquery>
                            </cfif>
                            <tr id="tree_row#currentrow#"<cfif isdefined('is_show_configure') and is_show_configure eq 1 and IS_CONFIGURE neq 1> style="display:none;"</cfif>>
                                <input type="hidden" name="tree_row_kontrol#currentrow#" id="tree_row_kontrol#currentrow#" value="1">
                                <input type="hidden" name="tree_is_configure#currentrow#" id="tree_is_configure#currentrow#" value="<cfif is_configure>1</cfif>">
                                <td><cfif is_configure><a href="javascript://" onClick="sil_tree_row(#currentrow#)"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id ='50765.Ürün Sil'>" border="0"></a></cfif></td>
                                <cfif isdefined('is_show_line_number') and is_show_line_number eq 1><td align="center">
                                <input type="text" name="line_number#currentrow#" id="line_number#currentrow#" style="width:15px;text-align:right" class="box" readonly value="#LINE_NUMBER#"></td></cfif>
                                <td><input type="hidden" name="tree_stock_id#currentrow#" id="tree_stock_id#currentrow#" value="#GET_SPECT_TREE.STOCK_ID#">
                                <input type="text" name="tree_stock_code#currentrow#" id="tree_stock_code#currentrow#" value="#GET_SPECT_TREE.STOCK_CODE#" style="width:120px" readonly></td>
                                <cfquery name="GET_FISRT_PRO_PRICE" dbtype="query"><!--- Sistem para birimi cinsinden tutarı buluyoruz --->
                                    SELECT (RATE2/RATE1) RATE FROM GET_MONEY WHERE MONEY = '#GET_SPECT_TREE.MONEY_CURRENCY#'
                                </cfquery>
                                <cfset first_pro_rate=GET_FISRT_PRO_PRICE.RATE>
                                <cfif not len(first_pro_rate)><cfset first_pro_rate = 1></cfif><!--- Sonradan Eklenmiş Olan Para Birimi Varsa,bulamayacağı için 1 set ediyoruz. --->
								<td nowrap="nowrap" class="x-18">
									<div class="form-group mt-0">
										<div class="input-group col-12">	
											<select name="tree_product_id#currentrow#" id="tree_product_id#currentrow#" <cfif isdefined('get_alternative') and get_alternative.recordcount  and IS_CONFIGURE></cfif> onChange="UrunDegis(this,'#currentrow#');">
												<cfif not len(stock_id)><cfset stock_id_ = 0><cfset product_id_ = 0><cfelse><cfset stock_id_ = stock_id><cfset product_id_ = product_id></cfif>
												<cfif not len(operation_type_id)><cfset operation_type_id_ = 0><cfelse><cfset operation_type_id_ = operation_type_id></cfif>
												<option value="#product_id_#,#stock_id_#,#GET_SPECT_TREE.TOTAL_VALUE#,#GET_SPECT_TREE.MONEY_CURRENCY#,#GET_SPECT_TREE.TOTAL_VALUE*first_pro_rate#,'0',#replace(PRODUCT_NAME,',','')#,#IS_PRODUCTION#,#operation_type_id_#">#PRODUCT_NAME#</option>
												<cfif is_configure and len(product_id)>
													<cfloop query="get_alternative">
													<cfif isQuery(get_price)>
														<cfquery name="GET_PRICE_ALTER#get_alternative.currentrow#" dbtype="query">
															SELECT
																*
															FROM
																GET_PRICE
															WHERE
																PRODUCT_ID=#get_alternative.product_id#
														</cfquery>
													</cfif>
													<cfif not isdefined("GET_PRICE_ALTER#get_alternative.currentrow#") or evaluate('GET_PRICE_ALTER#get_alternative.currentrow#.RECORDCOUNT') eq 0 or evaluate('GET_PRICE_ALTER#get_alternative.currentrow#.price') eq 0>
														<cfquery name="GET_PRICE_ALTER#get_alternative.currentrow#" dbtype="query">
															SELECT
																*
															FROM
																GET_PRICE_STANDART
															WHERE
																PRODUCT_ID=#get_alternative.product_id#
														</cfquery>
													</cfif>
													<option value="#get_alternative.PRODUCT_ID#,#get_alternative.stock_id#,#evaluate('get_price_alter#get_alternative.currentrow#.price')#,#evaluate('get_price_alter#get_alternative.currentrow#.money')#,#evaluate('get_price_alter#get_alternative.currentrow#.PRICE_STDMONEY')#,#evaluate('get_price_alter#get_alternative.currentrow#.PRICE_KDV_STDMONEY')#,#get_alternative.product_name# #get_alternative.PROPERTY#, #get_alternative.IS_PRODUCTION#" <cfif get_alternative.stock_id eq GET_SPECT_TREE.stock_id>selected</cfif>>#get_alternative.product_name# #get_alternative.PROPERTY#</option>
												</cfloop>
											</cfif>
											</select>
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid='+list_getat(document.add_spect_variations.tree_product_id#currentrow#.value,1)+'&sid='+list_getat(document.add_spect_variations.tree_product_id#currentrow#.value,2),'medium')"></span>
										</div>
									</div>	
                                </td>
								<cfif is_change_spect_name eq 1>
									<td>
										<input type="text" id="related_spect_main_name#currentrow#" name="related_spect_main_name#currentrow#" value="#SPECT_MAIN_NAME#">	
									</td>
								</cfif>
                                <td><input id="related_spect_main_id#currentrow#" title="Spect Bileşenleri" <cfif is_production eq 1> style="cursor:pointer;" onClick="document.getElementById('tree_std_money#currentrow#').value=document.getElementById('old_tree_std_money#currentrow#').value;goster(SHOW_PRODUCT_TREE_ROW#currentrow#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax#xml_str#&stock_id='+list_getat(document.getElementById('tree_product_id#currentrow#').value,2,',')+'&product_id='+list_getat(document.getElementById('tree_product_id#currentrow#').value,1,',')+'&satir=#currentrow#&spec_purchasesales=#spec_purchasesales#&RATE1=#get_money_2.RATE1#&RATE2=#get_money_2.RATE2#&is_spect_or_tree='+document.getElementById('related_spect_main_id#currentrow#').value+'','SHOW_PRODUCT_TREE_INFO#currentrow#',1);"</cfif> name="related_spect_main_id#currentrow#" style="width:125px;" class="box" value="<cfif len(SPECT_MAIN_ID) and SPECT_MAIN_ID neq 0 and is_production eq 1>#SPECT_MAIN_ID#</cfif>" readonly></td><!--- Spec --->
                                <cfif is_production eq 1 and (not len(SPECT_MAIN_ID) or SPECT_MAIN_ID eq 0)><!--- Eğer ürün üretiliyor ise,o anki main spect'ini alıcaz ve 1 üst satırdaki related_spect_main_id kısmına yazdırıcaz --->
                                    <script type="text/javascript">
                                        var deger = workdata('get_main_spect_id','#stock_id#');
                                        if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz related_spect_main_id'yi
                                        var SPECT_MAIN_ID = deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
                                        document.getElementById('related_spect_main_id#currentrow#').value= SPECT_MAIN_ID;
                                        document.getElementById('related_spect_main_id#currentrow#').style.background ='CCCCCC';
                                    </script>
                                </cfif>
                                <td><input type="checkbox" name="tree_is_sevk#currentrow#" id="tree_is_sevk#currentrow#" value="1" <cfif GET_SPECT_TREE.IS_SEVK>checked</cfif>></td>
                                <!--- Alt Ağaç --->
                                <td><img src="/images/shema_list.gif" id="under_tree#currentrow#" title="<cf_get_lang dictionary_id ='33930.Ağaç Bileşenleri'>" style="cursor:pointer;" <cfif is_production neq 1>style="display:none"</cfif>  align="absmiddle" border="0" onClick="document.getElementById('tree_std_money#currentrow#').value=document.getElementById('old_tree_std_money#currentrow#').value;goster(SHOW_PRODUCT_TREE_ROW#currentrow#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax#xml_str#&stock_id='+list_getat(document.getElementById('tree_product_id#currentrow#').value,2,',')+'&product_id='+list_getat(document.getElementById('tree_product_id#currentrow#').value,1,',')+'&satir=#currentrow#&spec_purchasesales=#spec_purchasesales#&RATE1=#get_money_2.RATE1#&RATE2=#get_money_2.RATE2#','SHOW_PRODUCT_TREE_INFO#currentrow#',1);"></td>
                                <!--- Alt Ağaç --->
                                <td><input name="tree_amount#currentrow#" id="tree_amount#currentrow#" type="text" class="moneybox" style="width:col col-12" onFocus="document.getElementById('reference_amount').value=filterNum(this.value,8)"  onKeyUp="UrunDegis(document.getElementById('tree_product_id#currentrow#'),'#currentrow#',1);" value="#TLFormat(wrk_round(GET_SPECT_TREE.AMOUNT_VALUE,8,1),8)#" <cfif IS_CONFIGURE eq 0>readonly</cfif> autocomplete="off"></td>
                                <td <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="display:none;"</cfif>>
                                <!--- Ana ürün bazında fiyat farkı --->
                                <input type="hidden" name="tree_total_amount#currentrow#" id="tree_total_amount#currentrow#" value="#TLFormat(GET_SPECT_TREE.DIFF_PRICE,8)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" onBlur="hesapla('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
                                <!--- Kendi para biriminde fiyat farkı --->
                                <input type="text" name="tree_diff_price#currentrow#" id="tree_diff_price#currentrow#" value="#TLFormat(0,8)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" onBlur="hesapla('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
                                <!--- <input type="hidden" name="tree_kdvstd_money#currentrow#" value="#get_price_main.price_kdv_stdmoney#"> --->
                                <!--- Fiyat Farkı --->
                                </td>
                                <td <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none"</cfif>><input name="tree_total_amount_money#currentrow#" id="tree_total_amount_money#currentrow#" class="box" readonly  type="text" value="#GET_SPECT_TREE.money_currency#" style="width:50px"></td><!--- Para Br --->
                                <cfif not isdefined('is_show_cost') or (isdefined('is_show_cost') and is_show_cost eq 1)>
                                <!--- Maliyet --->
								<cfif len(PRODUCT_ID)>
									<cfquery name="get_product_cost" dbtype="query"><!--- Maliyetler geliyor. --->
										SELECT * FROM get_product_cost_all WHERE PRODUCT_ID = #PRODUCT_ID#
									</cfquery>
								<cfelse>
									<cfset get_product_cost.PURCHASE_NET_SYSTEM = 0>
									<cfset get_product_cost.PURCHASE_EXTRA_COST_SYSTEM = 0>
								</cfif>
                                <!--- maliyetleri yoksa 0 set ediliyor. --->
                                <cfif len(get_product_cost.PURCHASE_NET_SYSTEM)><cfset PURCHASE_NET_SYSTEM = get_product_cost.PURCHASE_NET_SYSTEM><cfelse><cfset PURCHASE_NET_SYSTEM = 0></cfif>
                                <cfif len(get_product_cost.PURCHASE_EXTRA_COST_SYSTEM)><cfset PURCHASE_EXTRA_COST_SYSTEM = get_product_cost.PURCHASE_EXTRA_COST_SYSTEM><cfelse><cfset PURCHASE_EXTRA_COST_SYSTEM = 0></cfif>
                                <td><input type="text" name="tree_product_cost#currentrow#" id="tree_product_cost#currentrow#" value="#TLFormat(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM,8)#" readonly class="moneybox" style="width:50px"></td>
                                <!--- Maliyet --->
                                </cfif>
                                <!--- spectin satırlarındaki secili ürünlerin fiyatlarının session.ep.money cinsinden tutarını bulmak için kur seçiliyor--->
                                <td <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none"</cfif>>
                                <input type="hidden" name="reference_std_money#currentrow#" id="reference_std_money#currentrow#" value="#TLFormat(GET_SPECT_TREE.TOTAL_VALUE*first_pro_rate,8)#" class="moneybox" style="width:50px">
                                <input type="hidden" name="old_tree_std_money#currentrow#" id="old_tree_std_money#currentrow#" value="#TLFormat(GET_SPECT_TREE.TOTAL_VALUE*first_pro_rate,8)#" class="moneybox" style="width:50px">
                                <input type="text" name="tree_std_money#currentrow#" id="tree_std_money#currentrow#" value="#TLFormat(GET_SPECT_TREE.TOTAL_VALUE*first_pro_rate,8)#"class="moneybox" style="width:50px">
                            </td>
                            </tr>
                            <tr id="SHOW_PRODUCT_TREE_ROW#currentrow#" style="display:none;">
                                <td colspan="11"><div id="SHOW_PRODUCT_TREE_INFO#currentrow#"></div></td>
                            </tr>
                        </cfoutput>
                    <input type="hidden" name="tree_record_num" id="tree_record_num" value="<cfoutput>#GET_SPECT_TREE.RECORDCOUNT#</cfoutput>">
                  </table>
                </td>
                </tr>
                <cfif isdefined("is_show_property_and_calculate") and is_show_property_and_calculate eq 1><!--- ÖZellikler görüntülenmek isteniyorsa --->
                    <tr class="color-header">
                        <td class="form-title" height="22"><cf_get_lang dictionary_id ='33722.Özellikler/İşlemler'></td>
                    </tr>
                    <tr class="color-row">
                        <td>
                            <table id="property_table">
							<input type="hidden" name="pro_record_num" id="pro_record_num" value="0">
							</table>
							</td>
						</tr>
                </cfif>	
                <tr class="color-list" <cfif isdefined('attributes.upd_main_spect')> style="display:none" </cfif>><!--- Eğer main_spect güncelleme sayfası olarak kullanılacaksa para birimlerini hiç göstermiyoruz. --->
                    <td>
                      <table cellspacing="0" cellpadding="0" border="0">
                        <tr class="color-list">
                          <td rowspan="2"  width="140">
                            <table width="100%" height="10" border="0" cellpadding="2" cellspacing="1">
                              <tr class="color-header">
                                <td colspan="3" class="form-title" >&nbsp;&nbsp;<cf_get_lang dictionary_id ='33851.Dövizler'></td>
                              </tr>
                                <cfoutput>
									<cfset money_selected_list = ValueList(get_money.IS_SELECTED,',')>
									<!--- Bu kısım eğer üretim emrinden spect güncelleme ekranı açılırsa rd_money boş geldiği için eklendi,M.ER --->
									<!--- Eğer get_money'dan true değer dönmüyorsa yani hepsi 0 geliyor ise rd_money'i get_money query'sinin içinden  session.ep.money2'i hangisine eşitse onu seçiyorum. --->
									<cfif not ListFind(money_selected_list,true,',') and len(session.ep.money2)>
										<cfset rd_money = ListGetAt(ValueList(get_money.MONEY,','),ListFind(ValueList(get_money.MONEY,','),session.ep.money2,','),',')>
									</cfif>
									<input type="hidden" name="rd_money_num" id="rd_money_num" value="#get_money.recordcount#">
									<cfloop query="get_money">
										<cfset _money_ = money >
										<cfif session.ep.period_year gt 2008 and money is 'YTL'><cfset _money_ = 'TL'></cfif>
										<cfif session.ep.period_year lt 2009 and money is 'TL'><cfset _money_ = 'YTL'></cfif>
										<tr>
											<input type="hidden" name="urun_para_birimi#_money_#" id="urun_para_birimi#_money_#" value="#rate2/rate1#">
											<input type="hidden" name="rd_money_name_#currentrow#" id="rd_money_name_#currentrow#" value="#_money_#">
											<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
											<td><input type="radio" name="rd_money" id="rd_money" value="#_money_#,#rate1#,#rate2#" onClick="hesapla('');" <cfif is_selected or (isdefined('rd_money') and rd_money eq _money_) or _money_ eq session.ep.money>checked</cfif>><!--- money eq get_spect.other_money_currency --->#_money_#</td>
											<td>#TLFormat(rate1,8)#/</td>
											<td><input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,8)#" style="width:50px;" class="box" onkeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla();"></td>
										</tr>
									</cfloop>
                                </cfoutput>
                            </table>
                          </td>
                          <td valign="top">
                            <table border="0" style="text-align:right;" cellpadding="2" cellspacing="1">
                                <tr class="form-title">
                                    <td  class="color-header" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam'></td>
                                    <td  class="color-header" style="text-align:right;"><cf_get_lang dictionary_id ='58124.Döviz Toplam'></td>
                                </tr>
                                <cfoutput>
									<tr class="color-list">
										<td  valign="top" nowrap style="text-align:right;">
											<input type="text" name="toplam_miktar" id="toplam_miktar" value="<cfif not isdefined('attributes.upd_main_spect')>#tlformat(get_spect.total_amount,8)#<cfelse>0</cfif>" style="width:100px;" class="box" readonly=""><cfoutput>#session.ep.money#</cfoutput>
										</td>
										<td  valign="top" style="text-align:right;">
											<input type="text" name="other_toplam" id="other_toplam" value="<cfif not isdefined('attributes.upd_main_spect')>#tlformat(get_spect.other_total_amount,8)#<cfelse>0</cfif>" style="width:100px;" class="box" readonly="">&nbsp;
											<input type="text" name="doviz_name" id="doviz_name" value="<cfif not isdefined('attributes.upd_main_spect')>#get_spect.other_money_currency#<cfelse>#session.ep.money#</cfif>" style="width:50px;" class="box" readonly="">
										</td>
									</tr>
                                </cfoutput>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                </tr>
              </table>
		</td>
	</tr>
	</cfform>
</table>
<script type="text/javascript">
//order dan geliyorsa popupı açan sayfadan order_id almak için
if(opener!=undefined && opener.document.all.order_id!=undefined)
	document.add_spect_variations.order_id.value=opener.document.all.order_id.value;
//ship_id icin
if(opener!=undefined && opener.document.all.upd_id!=undefined)
	document.add_spect_variations.ship_id.value=opener.document.all.upd_id.value;
<cfif isdefined("GET_MAIN_PRICE") and GET_MAIN_PRICE.RATE2 neq 0>
	var product_rate=<cfoutput>#GET_MAIN_PRICE.RATE2/GET_MAIN_PRICE.RATE1#</cfoutput>;
	var product_rate2=<cfoutput>#GET_MAIN_PRICE.RATE1/GET_MAIN_PRICE.RATE2#</cfoutput>;
<cfelse>
	var product_rate=1;
	var product_rate2=1;
</cfif>
function UrunDegis(field,no,type)
{
	var urun_para_birimi = document.getElementById('urun_para_birimi'+list_getat(field.value,4,',')).value;
	if(type==undefined)gizle(document.getElementById('SHOW_PRODUCT_TREE_ROW'+no));//ürün değiştiğinde değişen ürüne ait açılmış bir detayı varsa kapatıyoruz.
	var _stock_id_ = list_getat(field.value,2,',');//stock id göndererek main spect id'si varsa onu alıyoruz.
	var _is_production_ = list_getat(field.value,8,',')//is_production olup olmadığı
	if(type==undefined)
	{	
		if(_is_production_ == 1)
		{
			var deger = workdata('get_main_spect_id',_stock_id_);
			if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz spect_main_id'yi
			var SPECT_MAIN_ID =deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
			document.getElementById('related_spect_main_id'+no).value = SPECT_MAIN_ID;//spect_main_id değiştir.
			goster(document.getElementById('under_tree'+no));//alt ağaç ikonunu göster
		} 
		else
		{
			gizle(document.getElementById('under_tree'+no));
			document.getElementById('related_spect_main_id'+no).value ='';
		}
	}	
	var price = list_getat(field.value,5,',');//5.ci eleman sistem para birimini ifade ediyor(YTL).
	if(price=="")price=0;
	var miktar = parseFloat(filterNum(document.getElementById('tree_amount'+no).value,8));
	if(isNaN(miktar) == true || miktar<=0 || miktar==''){document.getElementById('tree_amount'+no).value=1;miktar=1;}//alert(miktar);
	var fark = miktar*(price-parseFloat(filterNum(document.getElementById('reference_std_money'+no).value,8),8));//alert(fark);
	main_product_rate=product_rate2;
	form_total_amount=filterNum(document.getElementById('tree_total_amount'+no).value,8);//fiyat farkı
	document.getElementById('tree_total_amount'+no).value = commaSplit(parseFloat(form_total_amount-main_product_rate*(filterNum(document.getElementById('tree_std_money'+no).value,8)-price)),8);//fiyat farkı yazdırılıyor 
	document.getElementById('tree_diff_price'+no).value = commaSplit(fark/urun_para_birimi,8);//seçilen ürünün para birimi  bazında fiyat farkı
	document.getElementById('tree_std_money'+no).value=commaSplit(price,8);//satırdaki fiyat yazdırılıyor(seçilen alternatif ürünün fiyatı YTL olarak)
	hesapla();
}
tree_row_count=<cfoutput>#GET_SPECT_TREE.RECORDCOUNT#</cfoutput>;
function open_product_detail(pro_id,s_id)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pro_id+'&sid='+s_id,'list'); 
}
function open_tree_add_row()
{
	var money='';
	satir =-1 ;
	var islem_tarih='<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>';
	if(opener.moneyArray!=undefined && opener.rate2Array!=undefined && opener.rate1Array!=undefined)
		for(var i=0;i<opener.moneyArray.length;i++)
			money=money+'&'+opener.moneyArray[i]+'='+parseFloat(opener.rate2Array[i]/opener.rate1Array[i],8);
	else
		money=money+'<cfoutput query="get_money">&#get_money.money#=#get_money.rate2/get_money.rate1#</cfoutput>';
	if(opener.form_basket!=undefined && opener.form_basket.search_process_date!=undefined)
	    islem_tarih= window.opener.document.getElementById(search_process_date).value;
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&_spec_page_=2&update_product_row_id=0&<cfif isdefined("attributes.company_id")>company_id=#attributes.company_id#</cfif></cfoutput>&is_sale_product=1'+money+'&rowCount='+tree_row_count+'&search_process_date='+islem_tarih+'&sepet_process_type=-1&int_basket_id=<cfoutput>#attributes.basket_id#</cfoutput><cfif isdefined('attributes.unsalable')>&unsalable=1</cfif>&is_condition_sale_or_purchase=1&satir='+satir,'list');//is_price=1&is_price_other=1&is_cost=1&
}
function add_basket_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id, amount_,product_account_code,is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id)
{
	if(document.getElementById('value_stock_id').value==stock_id)
	{
		alert("<cf_get_lang dictionary_id ='33934.Ana ürünü kendine bileşen olarak ekleyemezsiniz'>!");
		return false;
	}
	add_spect_variations.is_change.value=1;
	if(money != document.add_spect_variations.main_prod_price_currency.value)
		price_other=wrk_round(price*product_rate2,8);//ana ürün fiyat dışındaki bir para biri ise onun ana ürün fiyatı cinsinden fiyat farkı
	tree_row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_tree").insertRow(document.getElementById("table_tree").rows.length);
	newRow.setAttribute("name","tree_row" + tree_row_count);
	newRow.setAttribute("id","tree_row" + tree_row_count);		
	newRow.setAttribute("NAME","tree_row" + tree_row_count);
	newRow.setAttribute("ID","tree_row" + tree_row_count);
	document.add_spect_variations.tree_record_num.value=tree_row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" id="tree_is_configure'+tree_row_count+'" name="tree_is_configure'+tree_row_count+'" value="1"><input type="hidden" id="tree_row_kontrol'+tree_row_count+'"  name="tree_row_kontrol'+tree_row_count+'" value="1"><input type="hidden" name="tree_product_id'+tree_row_count+'" id="tree_product_id'+tree_row_count+'" value="'+product_id+','+stock_id+','+price_other+','+money+','+price+',0,'+product_name+' "><a href="javascript://" onClick="sil_tree_row('+tree_row_count+')"><img src="/images/delete_list.gif" alt="<cf_get_lang dictionary_id ='50765.Ürün Sil'>" border="0"></a>';
	<cfif isdefined('is_show_line_number') and is_show_line_number eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<td></td>';
	</cfif>
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="tree_stock_id'+tree_row_count+'" id="tree_stock_id'+tree_row_count+'" value="'+stock_id+'"><input type="text" name="tree_stock_code'+tree_row_count+'" value="'+stock_code+'" style="width:120px" readonly>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group mt-0"><div class="input-group col-12"><input type="text" name="tree_product_name'+tree_row_count+'" id="tree_product_name'+tree_row_count+'" value="'+product_name+'" style="col col-12" readonly><span class="input-group-addon btnPointer icon-ellipsis"  onclick="open_product_detail('+product_id+','+stock_id+')"> </span></div></div>';
	//spec
	newCell = newRow.insertCell(newRow.cells.length);
	if(is_production==1)//üretilen ürün ise ve spectli bir ürün seçilmemiş ise
		{
			if(spect_id == '')
			{
				var deger = workdata('get_main_spect_id',stock_id);
				if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz spect_main_id'yi
				{
					var SPECT_MAIN_ID =deger.SPECT_MAIN_ID;
					var SPECT_MAIN_NAME =deger.SPECT_MAIN_NAME;
				}
				else
				{
					var SPECT_MAIN_ID ='';
					var SPECT_MAIN_NAME ='';
				}
			}
			else if(spect_id != '')
				{
					var _get_main_spect_ = wrk_safe_query('obj_get_main_spect','dsn3',0,spect_id);
					var SPECT_MAIN_ID = _get_main_spect_.SPECT_MAIN_ID;
					var SPECT_MAIN_NAME = _get_main_spect_.SPECT_VAR_NAME;
				}
			newCell.innerHTML = '<input name="related_spect_main_name'+tree_row_count+'" id="related_spect_main_name'+tree_row_count+'"  value="'+SPECT_MAIN_NAME+'" readonly>';
			//newCell.innerHTML = '<input name="related_spect_main_id'+tree_row_count+'" id="related_spect_main_id'+tree_row_count+'" style="width:43px;" class="box" value="'+SPECT_MAIN_ID+'" readonly>';
		}
	else	
	{
		var SPECT_MAIN_NAME = "";
		newCell.innerHTML = '<input name="related_spect_main_name'+tree_row_count+'" id="related_spect_main_name'+tree_row_count+'"  value="'+SPECT_MAIN_NAME+'" readonly>';
	}
	//spec	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input name="related_spect_main_id'+tree_row_count+'" id="related_spect_main_id'+tree_row_count+'" style="col col-12" class="box" value="" readonly>';
	//sb
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="checkbox" name="tree_is_sevk'+tree_row_count+'" id="tree_is_sevk'+tree_row_count+'" value="1">';
	//sb
	//alt ağaç
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '';
	//alt ağaç
	//miktar
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="tree_amount'+tree_row_count+'" id="tree_amount'+tree_row_count+'" value="1" class="moneybox" style="col col-12" onBlur="hesapla();">';
	//miktar
	//fiyat farkı
	newCell = newRow.insertCell(newRow.cells.length);<cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0>newCell.style.display='none';</cfif>
	newCell.innerHTML = '<input type="hidden" name="tree_total_amount'+tree_row_count+'" id="tree_total_amount'+tree_row_count+'" value="'+commaSplit(price_other,8)+'" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" onBlur="hesapla();" style="width:80px"><input type="text" name="tree_diff_price'+tree_row_count+'" id="tree_diff_price'+tree_row_count+'" value="'+commaSplit(price/document.getElementById('urun_para_birimi'+money).value,8)+'" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" onBlur="hesapla();" style="width:80px"><input type="hidden" name="tree_kdvstd_money'+tree_row_count+'" value="">';
	//fiyat farkı
	newCell = newRow.insertCell(newRow.cells.length);<cfif isdefined('is_show_price') and is_show_price eq 0>newCell.style.display='none';</cfif>
	newCell.innerHTML = '<input name="tree_total_amount_money'+tree_row_count+'" id="tree_total_amount_money'+tree_row_count+'" class="box" readonly  type="text" value="'+money+'" class="moneybox" style="width:50px">';//para br
	<cfif isdefined('is_show_cost') and is_show_cost eq 1>
	//maliyet
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="tree_product_cost'+tree_row_count+'" id="tree_product_cost'+tree_row_count+'" value="'+commaSplit(net_maliyet,8)+'" readonly class="moneybox" style="width:50px">';//maliyet
	//maliyet
	</cfif>
	//toplam miktar sistem para birimini tutar
	newCell = newRow.insertCell(newRow.cells.length);<cfif isdefined('is_show_price') and is_show_price eq 0>newCell.style.display='none';</cfif>
	newCell.innerHTML = '<input type="text" name="tree_std_money'+tree_row_count+'" id="tree_std_money'+tree_row_count+'" value="'+commaSplit(price,8)+'" class="moneybox" style="width:50px"><input type="hidden" name="reference_std_money'+tree_row_count+'" id="reference_std_money'+tree_row_count+'" value="'+commaSplit(price,8)+'"style="width:50px"><input type="hidden" name="old_tree_std_money'+tree_row_count+'" value="'+commaSplit(price,8)+'" style="width:50px">';
	//toplam miktar
	hesapla();
}
function sil_tree_row(sy)
{
	var my_element=document.getElementById("tree_row_kontrol"+sy);
	my_element.value=0;
	var my_element=document.getElementById("tree_row"+sy);
	my_element.style.display="none";
	hesapla();
}
function hesapla()
{	
	var is_change=0;
	toplam_deger = 0;
	for (var r=1;r<=add_spect_variations.tree_record_num.value;r++)
	{
			console.log(r);
			$("#tree_row_kontrol"+r).val();
			$("#tree_is_configure"+r).val();
		if(document.getElementById('tree_row_kontrol'+r)!=undefined && document.getElementById('tree_row_kontrol'+r).value!='0' && document.getElementById('tree_is_configure'+r).value == 1)
		{
			console.log(r);
			form_amount = document.getElementById('tree_amount'+r);
			form_total_amount = document.getElementById('tree_total_amount'+r);
			form_total_amount.value = filterNum(form_total_amount.value,8);
			if(form_amount.value == "")
				value_form_amount = 0;
			else
				value_form_amount = filterNum(form_amount.value,8);
			if(form_total_amount.value == "")
				form_total_amount.value = 0;
			toplam_deger = toplam_deger + (value_form_amount*form_total_amount.value);
			form_total_amount.value=commaSplit(form_total_amount.value,8);
			if(document.getElementById('tree_product_id'+r).selectedIndex>0 && is_change!=1)is_change=1;
		}
	}
	toplam_deger=parseFloat(toplam_deger*product_rate,8);
	<cfif isdefined('is_show_property_and_calculate') and is_show_property_and_calculate eq 1><!--- ÖZellikler görüntülenmek isteniyorsa --->
	for (var r=1;r<=add_spect_variations.pro_record_num.value;r++)
		{
			is_change=1;
			form_sum_amount = document.getElementById('pro_sum_amount'+r);
			form_amount = document.getElementById('pro_amount'+r);
			form_total_amount = document.getElementById('pro_total_amount'+r);
			form_money_type = document.getElementById('pro_money_type'+r);
			form_total_amount.value = filterNum(form_total_amount.value,8);
			form_sum_amount.value=commaSplit(filterNum(form_amount.value)*filterNum(form_total_amount.value),8);
			if(form_amount.value == "")
				value_form_amount = 0;
			else
				value_form_amount = filterNum(form_amount.value,8);
			if(form_total_amount.value == "")
				form_total_amount.value = 0;
			value_money_type = form_money_type.value.split(',');
			value_money_type_ilk = value_money_type[0];
			value_money_type_son = value_money_type[1];
			toplam_deger = toplam_deger + (value_form_amount*(form_total_amount.value*(value_money_type_son/value_money_type_ilk)));
			form_total_amount.value = commaSplit(form_total_amount.value,8);
		}
	</cfif>
	add_spect_variations.toplam_miktar.value = toplam=parseFloat(add_spect_variations.main_std_money.value,8)+parseFloat(toplam_deger,8);
	for(var j=0;j<add_spect_variations.rd_money.length;j++)
	{
		if(document.add_spect_variations.rd_money[j].checked)
		{
			value_deger_rd_money_orta=filterNum(document.getElementById('txt_rate1_'+(j+1)).value,8);
			value_deger_rd_money_son=filterNum(document.getElementById('txt_rate2_'+(j+1)).value,8);
			value_deger_rd_money_ilk=document.getElementById('rd_money_name_'+(j+1)).value;
		}
	}
	if(!value_deger_rd_money_son || (value_deger_rd_money_son!=undefined && value_deger_rd_money_son.value==''))
	{
		value_deger_rd_money_orta=1;
		value_deger_rd_money_son=1;
	}
	add_spect_variations.doviz_name.value = value_deger_rd_money_ilk;
	add_spect_variations.other_toplam.value = commaSplit(parseFloat(add_spect_variations.toplam_miktar.value,8) * (parseFloat(value_deger_rd_money_orta,8)/parseFloat(value_deger_rd_money_son,8)),8);
	add_spect_variations.toplam_miktar.value = commaSplit(add_spect_variations.toplam_miktar.value,8);
	add_spect_variations.is_change.value =is_change;
}
function kontrol()
{
	if(document.getElementById('tree_record_num').value==0)
		{
			alert("<cf_get_lang dictionary_id='60234.Satıra Ürün Ekleyiniz'>!");
			return false;	
		}
	hesapla();
	for (var r=1;r<=add_spect_variations.tree_record_num.value;r++)
	{
			form_tree_amount = document.getElementById('tree_amount'+r);
			form_tree_total_amount = document.getElementById('tree_total_amount'+r);
			form_tree_diff_price = document.getElementById('tree_diff_price'+r);
			form_tree_std_money = document.getElementById('tree_std_money'+r);
			form_tree_amount.value = filterNum(form_tree_amount.value,8);
			form_tree_total_amount.value = filterNum(form_tree_total_amount.value,8);
			form_tree_std_money.value=filterNum(form_tree_std_money.value,8);
			form_tree_diff_price.value=filterNum(form_tree_diff_price.value,8);

	}
	<cfif isdefined('is_show_property_and_calculate') and is_show_property_and_calculate eq 1><!--- ÖZellikler görüntülenmek isteniyorsa --->
	//özellikler
	for (var r=1;r<=add_spect_variations.pro_record_num.value;r++)
	{
		form_pro_tolerance = document.getElementById('pro_tolerance'+r);
		form_pro_amount = document.getElementById('pro_amount'+r);
		form_pro_total_amount = document.getElementById('pro_total_amount'+r);
		pro_total_min =document.getElementById('pro_total_min'+r);
		pro_total_max =document.getElementById('pro_total_max'+r);
		pro_dimension =document.getElementById('pro_dimension'+r);
		pro_dimension.value =filterNum(pro_dimension.value,8);
		form_pro_tolerance.value=filterNum(form_pro_tolerance.value,8);
		pro_total_min.value=filterNum(pro_total_min.value,8);
		pro_total_max.value=filterNum(pro_total_max.value,8);
		form_pro_amount.value = filterNum(form_pro_amount.value,8);
		form_pro_total_amount.value = filterNum(form_pro_total_amount.value,8);
	}
	</cfif>
	for (var r=1;r<=add_spect_variations.rd_money_num.value;r++)
	{
			form_txt_rate1 = document.getElementById('txt_rate1_'+r);
			form_txt_rate2 = document.getElementById('txt_rate2_'+r);
			form_txt_rate1.value = filterNum(form_txt_rate1.value,8);
			form_txt_rate2.value = filterNum(form_txt_rate2.value,8);
	}
	add_spect_variations.toplam_miktar.value = filterNum(add_spect_variations.toplam_miktar.value,8);
	add_spect_variations.other_toplam.value = filterNum(add_spect_variations.other_toplam.value,8);	
}
hesapla();
</script>

