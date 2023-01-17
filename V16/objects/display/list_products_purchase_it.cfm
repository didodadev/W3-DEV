<cfparam name="attributes.price_catid" default = "-1">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.consumer_id" default = "">
<cfparam name="attributes.company_id" default = "">
<cfparam name="attributes.int_basket_id" default = "">
<cfparam name="attributes.keyword" default = "">
<cfparam name="attributes.manufact_code" default = "">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.serial_number" default="">
<cfif isdefined("xml_sort_type")>
	<cfparam name="attributes.sort_type" default="#xml_sort_type#">
<cfelse>
	<cfparam name="attributes.sort_type" default="0">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfinclude template="../query/get_price_cats.cfm">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.is_lot_no_based')>
	<cfset is_lot_no_based = attributes.is_lot_no_based>
</cfif>
<cfif isDefined('attributes.amount_multiplier')>
	<cfset attributes.amount_multiplier = filterNum(attributes.amount_multiplier)>
</cfif>
<cfif not (isDefined('attributes.amount_multiplier') and isnumeric(attributes.amount_multiplier) and attributes.amount_multiplier gt 0)>
	<cfset attributes.amount_multiplier = 1>
</cfif>
<cfif len(attributes.serial_number)>
	<cfquery name="GET_SERIAL_PRODUCTS" datasource="#DSN3#">
		SELECT DISTINCT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.serial_number#">
	</cfquery>
	<cfif get_serial_products.recordcount>
		<cfset seri_stock_id_list = valuelist(get_serial_products.stock_id)>
	<cfelse>
		<cfset seri_stock_id_list = "">
	</cfif>
</cfif>
<cfif isdefined('prj_disc_price_catid') and len(prj_disc_price_catid)><!---belgede seçilen projenin bağlantısında seçili fiyat listesi --->
	<cfset attributes.price_catid=prj_disc_price_catid>
</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
			SELECT 
				PRICE_CAT_PURCHASE PRICE_CAT
			FROM 
				COMPANY_CREDIT
			WHERE 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				AND OUR_COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfquery name="GET_COMP_CAT" datasource="#DSN#">
			SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
			SELECT 
				PRICE_CATID,
				PRICE_CAT 
			FROM 
				PRICE_CAT 
			WHERE
				<cfif (isdefined('xml_use_member_price_cat_purchase') and xml_use_member_price_cat_purchase eq 1)><!--- xmlde sadece risk bilgilerinde tanımlı fiyat listesi gelsin secili ise --->
					<cfif GET_CREDIT_LIMIT.RECORDCOUNT and len(GET_CREDIT_LIMIT.PRICE_CAT)>
						(
							PRICE_CAT_STATUS = 1
							AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND PC.ACT_TYPE = 2 AND PC.PURCHASE_SALES =0)
						) 
					<cfelse>
						1=2
					</cfif>
				<cfelse>
					<cfif GET_CREDIT_LIMIT.RECORDCOUNT and len(GET_CREDIT_LIMIT.PRICE_CAT)>
						(
							PRICE_CAT_STATUS = 1
							AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.PRICE_CAT#">
						) 
						OR 
					</cfif>
					(
						PRICE_CAT_STATUS = 1
						<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 13>
							AND COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
						<cfelse><!--- fiyat listeli popupda odeme yontemine gore fiyat listeleri gelir --->
							<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
								AND PRICE_CAT.PAYMETHOD = 4
							<cfelseif isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)>
								AND PRICE_CAT.PAYMETHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_vehicle#">
							<cfelseif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>
								AND PRICE_CAT.PAYMETHOD = ISNULL((SELECT PAYMENT_VEHICLE FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">),0)
							</cfif>
						</cfif>
					)
				</cfif>
				<cfif (isdefined("attributes.var_") and (session.ep.isBranchAuthorization)) or (isdefined('attributes.is_store_module'))>
					AND PRICE_CAT.BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
				</cfif>
				<cfif attributes.is_sale_product eq 0>
					AND IS_PURCHASE = 1
				<cfelse>
					AND IS_SALES = 1
				</cfif>
				<!--- Pozisyon tipine gore yetki veriliyor  --->
				<cfif xml_related_position_cat eq 1>
					AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
				</cfif>
				<!--- //Pozisyon tipine gore yetki veriliyor  --->
			ORDER BY
				PRICE_CAT
		</cfquery>
		<cfif not GET_PRICE_CAT.RECORDCOUNT>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='34070.Kurumsal Üyeyi Bir Fiyat Listesine Dahil Ediniz'>!");
				window.close();
			</script>
			<cfabort>
		</cfif>
		<cfif isdefined('prj_disc_price_catid') and len(prj_disc_price_catid)><!---belgede seçilen projenin bağlantısında seçili fiyat listesi --->
			<cfset attributes.price_catid=prj_disc_price_catid>
		<cfelseif GET_CREDIT_LIMIT.recordcount and len(GET_CREDIT_LIMIT.PRICE_CAT)>
			<cfset attributes.price_catid = GET_CREDIT_LIMIT.PRICE_CAT>
		<cfelseif isdefined('xml_use_standard_price_cat') and len(xml_use_standard_price_cat)>
			<cfset attributes.price_catid = xml_use_standard_price_cat>
		<cfelseif GET_PRICE_CAT.RECORDCOUNT>
			<cfset attributes.price_catid=-1>
		</cfif>
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
			SELECT 
				PRICE_CAT_PURCHASE PRICE_CAT
			FROM 
				COMPANY_CREDIT
			WHERE 
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfquery name="GET_COMP_CAT" datasource="#DSN#">
			SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfquery>
		<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
			SELECT 
				PRICE_CATID,
				PRICE_CAT 
			FROM 
				PRICE_CAT 
			WHERE
				<cfif (isdefined('xml_use_member_price_cat_sales') and xml_use_member_price_cat_sales eq 1)>
					<cfif GET_CREDIT_LIMIT.RECORDCOUNT and len(GET_CREDIT_LIMIT.PRICE_CAT)>
						(
							PRICE_CAT_STATUS = 1
							AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.PRICE_CAT#">
						)
					<cfelse>
						1=2
					</cfif>
				<cfelse>
					<cfif GET_CREDIT_LIMIT.RECORDCOUNT and len(GET_CREDIT_LIMIT.PRICE_CAT)>
						(
							PRICE_CAT_STATUS = 1
							AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.PRICE_CAT#">
						) 
						OR
					</cfif>
					(
						PRICE_CAT_STATUS = 1
						<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 13>
							AND CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
						<cfelse><!--- fiyat listeli popupda odeme yontemine gore fiyat listeleri gelir --->
							<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
								AND PRICE_CAT.PAYMETHOD = 4
							<cfelseif isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)>
								AND PRICE_CAT.PAYMETHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_vehicle#">
							</cfif>
							<cfif (isdefined("attributes.var_") and (session.ep.isBranchAuthorization)) or (isdefined('attributes.is_store_module'))>
								AND PRICE_CAT.BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
							</cfif>
						</cfif>
					)
				</cfif>
				<cfif (isdefined("attributes.var_") and (session.ep.isBranchAuthorization)) or (isdefined('attributes.is_store_module'))>
					AND PRICE_CAT.BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
				</cfif>
				<cfif attributes.is_sale_product eq 0>
					AND IS_PURCHASE = 1
				<cfelse>
					AND IS_SALES = 1
				</cfif>
				<!--- Pozisyon tipine gore yetki veriliyor  --->
				<cfif xml_related_position_cat eq 1>
					AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
				</cfif>
				<!--- //Pozisyon tipine gore yetki veriliyor  --->
			ORDER BY
				PRICE_CAT
		</cfquery>
		<cfif not get_price_cat.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='34071.Bireysel Üyeyi Bir Fiyat Listesine Dahil Ediniz'>!");
				window.close();
			</script>
			<cfabort>
		</cfif>
		<cfif isdefined('prj_disc_price_catid') and len(prj_disc_price_catid)><!---belgede seçilen projenin bağlantısında seçili fiyat listesi --->
			<cfset attributes.price_catid=prj_disc_price_catid>
		<cfelseif GET_CREDIT_LIMIT.RECORDCOUNT and len(GET_CREDIT_LIMIT.PRICE_CAT)>
			<cfset attributes.price_catid = GET_CREDIT_LIMIT.PRICE_CAT>
		<cfelseif isdefined('xml_use_standard_price_cat') and len(xml_use_standard_price_cat)>
			<cfset attributes.price_catid = xml_use_standard_price_cat>
		<cfelseif GET_PRICE_CAT.RECORDCOUNT>
			<cfset attributes.price_catid=-1>
		</cfif>
    <cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)><!--- calisanda tum fiyat listeleri geliyor --->
    	<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
    		SELECT 
            	PRICE_CATID,
                PRICE_CAT 
            FROM 
            	PRICE_CAT 
            WHERE 
            	PRICE_CAT_STATUS = 1 
                <cfif attributes.is_sale_product eq 0>
					AND IS_PURCHASE = 1
				<cfelse>
					AND IS_SALES = 1
				</cfif>
            ORDER BY PRICE_CAT
        </cfquery>
	</cfif>
<!--- form veya urlden geldi ise fiyat listesi o olmalı bu nedenle atanıyor ancak sayfa baındaki cfparam ile -2 atandığından burda attributes ile yapılmadı--->
<cfif isdefined("form.price_catid") and len(form.price_catid)>
	<cfset attributes.price_catid=form.price_catid>
<cfelseif isdefined("url.price_catid") and len(url.price_catid)>
	<cfset attributes.price_catid=url.price_catid>
</cfif>
<cfquery name="GET_PRICE_EXCEPTIONS_ALL" datasource="#DSN3#">
	SELECT
		*
	FROM 
		PRICE_CAT_EXCEPTIONS
	WHERE
		ISNULL(IS_GENERAL,0)=0 AND <!--- urun tanımlarındaki istisnai fiyat listelerinden tanımlananlar burada geçerli olmayacak--->
		ACT_TYPE = 1 AND
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	<cfelse>
		1=0
	</cfif>	
</cfquery>
<cfquery name="GET_PRICE_EXCEPTIONS_PID" dbtype="query">
	SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_ID IS NOT NULL
</cfquery>
<cfquery name="GET_PRICE_EXCEPTIONS_PCATID" dbtype="query">
	SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_CATID IS NOT NULL
</cfquery>
<cfquery name="GET_PRICE_EXCEPTIONS_BRID" dbtype="query">
	SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE BRAND_ID IS NOT NULL
</cfquery>
<cfquery name="GET_PRICE_EXCEPTIONS_SHORTCODE" dbtype="query">
	SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE SHORT_CODE_ID IS NOT NULL
</cfquery>
<cfinclude template="../query/get_moneys.cfm">
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_products_purchase_it.cfm">
<cfelse>
	<cfset products.recordcount = 0>
</cfif>
<cfinclude template="../query/get_default_money.cfm">
<cfif products.recordcount >
	<cfparam name="attributes.totalrecords" default="#products.query_count#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="#products.recordcount#">
</cfif>
<cfset url_str = "">
<cfif isdefined("attributes.update_product_row_id")>
	<cfset url_str = "#url_str#&update_product_row_id=#attributes.update_product_row_id#">
</cfif>
<cfif isdefined("module_name")>
	<cfset url_str = "#url_str#&module_name=#module_name#">
</cfif>
 <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.int_basket_id")>
	<cfset url_str = "#url_str#&int_basket_id=#attributes.int_basket_id#">
</cfif>
<cfif isDefined("attributes.company_id")>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isDefined("attributes.consumer_id")>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif not (isdefined('xml_use_project_filter') and xml_use_project_filter eq 1) and isdefined("attributes.project_id")> <!--- xmlde proje filtresi secilmemis, fakat listeye cagrıldıgı belgedeki proje id gonderilmisse --->
	<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
</cfif>
<cfif isdefined("attributes.is_cost")>
	<cfset url_str = "#url_str#&is_cost=#attributes.is_cost#">
</cfif>
<cfif isdefined("sepet_process_type")>
	<cfset url_str = "#url_str#&sepet_process_type=#sepet_process_type#">
</cfif>
<cfif isdefined("is_lot_no_based")>
		<cfset url_str = "#url_str#&is_lot_no_based=#is_lot_no_based#">
</cfif> 
<cfif isdefined('attributes.department_out') and len(attributes.department_out)>
 	<cfset url_str = "#url_str#&department_out=#attributes.department_out#">
</cfif>
<cfif isdefined('attributes.location_out') and len(attributes.location_out)>
 	<cfset url_str = "#url_str#&location_out=#attributes.location_out#">
</cfif>
<cfif isdefined('attributes.department_in') and len(attributes.department_in)>
 	<cfset url_str = "#url_str#&department_in=#attributes.department_in#">
</cfif>
<cfif isdefined('attributes.location_in') and len(attributes.location_in)>
 	<cfset url_str = "#url_str#&location_in=#attributes.location_in#">
</cfif>
<cfif isdefined("attributes.is_store_module")>
	<cfset url_str = "#url_str#&is_store_module=#attributes.is_store_module#">
</cfif>
<cfif isDefined('attributes.is_condition_sale_or_purchase') and len(attributes.is_condition_sale_or_purchase)>
	<cfset url_str = "#url_str#&is_condition_sale_or_purchase=#attributes.is_condition_sale_or_purchase#">
</cfif>
<cfif isDefined('attributes.search_process_date') and len(attributes.search_process_date)>
	<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isdefined("attributes.paymethod_id")>
	<cfset url_str = "#url_str#&paymethod_id=#attributes.paymethod_id#">
</cfif>
<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
	<cfset url_str = "#url_str#&card_paymethod_id=#attributes.card_paymethod_id#">
</cfif>
<cfif isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)>
	<cfset url_str = "#url_str#&paymethod_vehicle=#attributes.paymethod_vehicle#">
</cfif>
<cfif isdefined("attributes.satir")>
	<cfset url_str = "#url_str#&satir=#attributes.satir#">
</cfif>
<cfloop query="moneys">
	<cfif isdefined("attributes.#money#")>
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfset url_str = '#url_str#&is_submit=1'>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></cfsavecontent>
	<cf_box title="#message#" collapsable="0">
		<cf_wrk_alphabet keyword="url_str" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- Harfler --->
		<cfform name="price_cat" action="#request.self#?fuseaction=objects.popup_products#url_str#&is_sale_product=#is_sale_product#" method="post">
			<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
			<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:100px;" placeholder="#message#">
				</div>
				<div class="form-group" id="item-sort_type">     
					<select name="sort_type" id="sort_type" style="width:110px;">
						<option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang dictionary_id='34282.Ürün Adına Göre'></option>
						<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='32751.Stok Koduna Göre'></option>
						<option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='32764.Özel Koda Göre'></option>
						<option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang dictionary_id='60124.Ürün Açıklamasına Göre'></option>
					</select>
				</div>
				<div class="form-group" id="item-price_catid">
					<select name="price_catid" id="price_catid" onchange="javascript:price_cat.submit();" style="width:155px">
						<cfif xml_use_member_price_cat_purchase eq 0><!--- Eğer sadece müşteri fiyat listeleri gelsin seçilmemişse standart alış gelsin --->
							<option value="-1" <cfif attributes.price_catid is '-1'> selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
						</cfif>
						<cfoutput query="price_cats"> 
							<option value="#price_catid#" <cfif price_cats.price_catid is attributes.price_catid> selected</cfif>>#price_cat#</option>
						</cfoutput> 
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>	
				<div class="form-group">
					<cf_wrk_search_button search_function='input_control()' button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>		
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-pos_code">
					<div class="input-group">  
						<input type="hidden" name="pos_code" id="pos_code"  value="<cfoutput>#attributes.pos_code#</cfoutput>">
						<input type="text" name="employee" id="employee" style="width:90px;" placeholder="<cfoutput>#getLang('main',132)#</cfoutput>" value="<cfoutput>#attributes.employee#</cfoutput>" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','135');" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=price_cat.pos_code&field_name=price_cat.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.employee.value),'medium');"></span>
					</div>
				</div>	
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-get_company">
					<div class="input-group">             
						<input type="hidden" name="get_company_id" id="get_company_id" value="<cfoutput>#attributes.get_company_id#</cfoutput>">
						<input type="text" name="get_company" id="get_company" placeholder="<cfoutput>#getLang('main',1736)#</cfoutput>" value="<cfoutput>#attributes.get_company#</cfoutput>" style="width:90px;" onfocus="AutoComplete_Create('get_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','get_company_id','','3','250');" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=price_cat.get_company&field_comp_id=price_cat.get_company_id&select_list=2,3&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.get_company.value),'medium');"></span>
					</div>
				</div>	
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-product_cat">
					<div class="input-group">
						<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
						<input type="text" name="product_cat" id="product_cat" style="width:90px;" placeholder="<cfoutput>#getLang('main',74)#</cfoutput>" value="<cfoutput>#attributes.product_cat#</cfoutput>" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','product_catid,search_product_catid','','3','200');" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=price_cat.product_catid&field_name=price_cat.product_cat&keyword='+encodeURIComponent(document.price_cat.product_cat.value)</cfoutput>);"></span>
					</div>
				</div>
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-brand_name">
					<div class="input-group">			
						<cfif len(attributes.brand_id) and len(attributes.brand_name)>
							<cfquery name="GET_BRAND_NAME" datasource="#DSN3#">
								SELECT 
									BRAND_NAME	
								FROM
									PRODUCT_BRANDS
								WHERE
									BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
							</cfquery>
						</cfif>
						<input type="hidden" name="brand_id" id="brand_id" value="<cfoutput>#attributes.brand_id#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58847.Marka'></cfsavecontent>
						<input type="text" name="brand_name" id="brand_name" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.brand_name#</cfoutput>"  onfocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','100');" style="width:80px;">
						<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=price_cat.brand_id&brand_name=price_cat.brand_name</cfoutput>','medium');"></span>
					</div>
				</div>
				<cfif isdefined('xml_short_code') and xml_short_code eq 1>	        
					<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-short_code_id">
						<cf_wrkproductmodel
							returninputvalue="short_code_id,short_code_name"
							returnqueryvalue="MODEL_ID,MODEL_NAME"
							width="80"
							fieldname="short_code_name"
							fieldid="short_code_id"
							compenent_name="getProductModel"            
							boxwidth="250"
							boxheight="150"                        
							model_id="#attributes.short_code_id#">
					</div>
				</cfif>
				<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1>
					<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-project_head">	
						<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
						<input type="text" name="project_head"  id="project_head" style="width:90px;" placeholder="<cfoutput>#message#</cfoutput>" readonly value="<cfif isdefined('attributes.project_id') and len (attributes.project_id)><cfoutput>#GET_PROJECT_NAME(attributes.project_id)#</cfoutput></cfif>" autocomplete="off">
					</div>
				</cfif>
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-serial_number">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='29412.Seri'></cfsavecontent>
					<cfinput type="text" name="serial_number" placeholder="#message#" value="#attributes.serial_number#">
				</div>
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-manufact_code">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57634.Üretici Kodu'></cfsavecontent>
					<input type="text" name="manufact_code" id="manufact_code" style="width:60px;" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.manufact_code#</cfoutput>"> 	
				</div>
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-amount_multiplier">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57635.Miktar'></cfsavecontent> 
					<input type="text" name="amount_multiplier" id="amount_multiplier" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#amountformat(attributes.amount_multiplier,3)#</cfoutput>" onkeyup="return FormatCurrency(this,event,3);">
				</div>
				<div id="detail_search" style="display:none;">
					<cfif isdefined('xml_product_features_filter') and xml_product_features_filter eq 1>
						<cfinclude template="detailed_product_search.cfm">
					</cfif>	
				</div>
			</cf_box_search_detail>
		</cfform>
		<cf_grid_list> 
			<thead>
				<tr>
					<cfif isdefined('xml_is_dsp_stock_code') and xml_is_dsp_stock_code eq 1>
						<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					</cfif> 
					<cfif isdefined('xml_use_ozel_code') and xml_use_ozel_code eq 1>
						<th><cf_get_lang dictionary_id ='57789.Özel Kod'></th>
					</cfif>
					<cfif isdefined('xml_use_manufact_code') and xml_use_manufact_code eq 1>
						<th><cf_get_lang dictionary_id ='57634.Üretici Kodu'></th>
					</cfif>
					<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
					<cfif is_lot_no_based eq 1>
						<th><cf_get_lang dictionary_id='32916.Lot No'></th>
					</cfif>
					</cfif>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
						<cfif isdefined('xml_is_list_products') and xml_is_list_products eq 1>
					<th><cf_get_lang dictionary_id='34281.Ürün Açıklaması'></th>
					</cfif>
					<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
						<th><cf_get_lang dictionary_id='57647.Spec'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='58084.Fiyat'></th>
					<th><cf_get_lang dictionary_id='57452.Stok'></th>
					<cfif isdefined('xml_use_other_dept_info') and listlen(xml_use_other_dept_info,'-') eq 2>
						<cfset location_info_ = get_location_info(listfirst(xml_use_other_dept_info,'-'),listlast(xml_use_other_dept_info,'-'),0,0)> 
						<th><cfoutput>#listfirst(location_info_,',')#</cfoutput></th>
					</cfif>  
					<th><cf_get_lang dictionary_id='57636.Birim'></th>
					<th width="20"><a href="javascript://"><i class="icon-detail"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif products.recordcount>
					<cfset spect_id_list = '' >
					<cfset product_id_list=''>
						<cfoutput query="products">
							<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7><!--- stoklu specli urun listesiyse --->
								<cfif len(spect_var_id) and not listfind(spect_id_list,spect_var_id)>
									<cfset spect_id_list = ListAppend(spect_id_list,spect_var_id)>
								</cfif>
							</cfif>
							<cfif not listfind(product_id_list,products.PRODUCT_ID)>
								<cfset product_id_list = listappend(product_id_list,products.PRODUCT_ID)>
							</cfif>
						</cfoutput>
						<cfif len(spect_id_list)>
							<cfset spect_id_list=listsort(spect_id_list,"numeric","ASC",",")>
							<cfquery name="GET_SPECT_NAMES" datasource="#dsn3#">
								SELECT SPECT_MAIN_NAME,SPECT_MAIN_ID FROM SPECT_MAIN WHERE SPECT_MAIN_ID IN (#spect_id_list#) ORDER BY SPECT_MAIN_ID
							</cfquery>
							<cfset spect_id_list = listsort(listdeleteduplicates(valuelist(GET_SPECT_NAMES.SPECT_MAIN_ID,',')),'numeric','ASC',',')>
						</cfif>
					<cfif len(product_id_list)>
						<cfquery name="GET_PRODUCT_UNITS" datasource="#DSN3#">
							SELECT ADD_UNIT,MAIN_UNIT,MULTIPLIER,PRODUCT_UNIT_ID,PRODUCT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID IN (#product_id_list#) AND PRODUCT_UNIT_STATUS = 1
						</cfquery>
					</cfif>
					<cfif isdefined('xml_use_other_dept_info') and listlen(xml_use_other_dept_info,'-') eq 2><!--- xmlde tanımlanan 2.depoya ait stok miktarları --->
						<cfquery name="GET_OTHER_DEPT_STOCK_INFO" datasource="#DSN2#">
							SELECT 
								SUM(STOCK_IN-STOCK_OUT) AS TOTAL_DEPT_STOCK_2,
								PRODUCT_ID,
								STOCK_ID
							FROM
								STOCKS_ROW
							WHERE
								PRODUCT_ID IN (#product_id_list#)
								AND STORE= <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(xml_use_other_dept_info,'-')#">
								AND STORE_LOCATION= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(xml_use_other_dept_info,'-')#">
							GROUP BY
								PRODUCT_ID,
								STOCK_ID
							ORDER BY
								STOCK_ID
						</cfquery>
						<cfset other_dept_stock_id_list=listsort(valuelist(get_other_dept_stock_info.STOCK_ID),'numeric','asc')>
					</cfif>
					<cfif isdefined('attributes.price_catid') and price_cats.recordcount> <!--- fiyat listesine gore baskete dusurulecek satırın vadesi bulunuyor --->
						<cfif len(price_cats.TARGET_DUE_DATE) and isdefined('attributes.search_process_date') and len(attributes.search_process_date)>
							<cfset row_due_day =datediff('d',createodbcdatetime(dateformat(attributes.search_process_date,dateformat_style)),price_cats.TARGET_DUE_DATE)>
						<cfelseif len(price_cats.AVG_DUE_DAY)>
							<cfset row_due_day =price_cats.AVG_DUE_DAY>
						<cfelse>
							<cfset row_due_day =''>
						</cfif>
					<cfelse>
						<cfset row_due_day =''>
					</cfif>
					<cfoutput query="products">
						<cfset name_product_='#product_name# #products.property#'>
						<cfset name_product_=ReplaceNoCase(name_product_,'"','','all')>
						<cfset name_product_=ReplaceNoCase(name_product_,"'","","all")>
						<cfif isDefined("money")>
							<cfset attributes.money = money>
						</cfif>
						<cfif session.ep.period_year lt 2009 and attributes.money is 'TL'>
							<cfset attributes.money=session.ep.money>
						<cfelseif  session.ep.period_year gte 2009 and attributes.money is 'YTL'>
							<cfset attributes.money=session.ep.money>
						</cfif>
						<cfloop query="moneys">
							<cfif moneys.money is attributes.money>
								<cfset row_money = moneys.money>
								<cfset row_money_rate1 = moneys.rate1>
								<cfset row_money_rate2 = moneys.rate2>
							</cfif>
						</cfloop>
						<form name="product#currentrow#" method="post">
						<cfif isdefined("attributes.is_action")><!--- aksiyonlar için satınalma indirimi default alma için erk 20040112 --->
							<input type="hidden" name="is_action" id="is_action" value="1">
						</cfif>
						<cfif row_money is default_money.money>
							<cfset flag_prc_other=0>
							<cfset flt_price = products.price>
							<cfset flt_price_other = products.price>
							<cfset str_money = money>
						<cfelse>
							<cfset flag_prc_other=1>			
							<cfset flt_price = products.price*(row_money_rate2/row_money_rate1)>
							<cfset flt_price_other = products.price>
							<cfset str_money = row_money>
						</cfif>
						<tr>
							<cfif isdefined('xml_is_dsp_stock_code') and xml_is_dsp_stock_code eq 1>
								<td>#stock_code#</td>
							</cfif>
							<cfif isdefined('xml_use_ozel_code') and xml_use_ozel_code eq 1>
								<td width="70">#product_code_2#</td>
							</cfif>
							<cfif isdefined('xml_use_manufact_code') and xml_use_manufact_code eq 1>
								<td>#manufact_code#</td>
							</cfif>
							<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
							<cfif is_lot_no_based eq 1>
								<td>#lot_no#</td>
							</cfif>
							</cfif>
							<td style="cursor:pointer" >
								<a class="tableyazi" onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#name_product_#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#flt_price_other#','#row_money#','','','#IS_INVENTORY#','#MULTIPLIER#','','','',1,'',<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>'#products.spect_var_id#'<cfelse>''</cfif>,'#IS_PRODUCTION#','','',<cfif len(PRICE_CATID)>'#PRICE_CATID#'<cfelse>''</cfif>,'','','','#flt_price_other#','','',<cfif len(CATALOG_ID)>'#CATALOG_ID#'<cfelse>''</cfif>,'#row_due_day#'<cfif is_lot_no_based eq 1 and isdefined("PRODUCTS.LOT_NO")>,'#lot_no#'<cfelse>,''</cfif>,'','','','','','','','','','#oiv#');">
									#product_name#&nbsp;#property#
							</a>
							</td>
							<cfif isdefined('xml_is_list_products') and xml_is_list_products eq 1>
								<td width="550">#product_detail#</td>
							</cfif>
							<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
								<td>
									<cfif len(products.spect_var_id)>
										<a onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_spec&id=#products.SPECT_VAR_ID#','medium');" class="tableyazi"><cfif isdefined("xml_spec_name") and xml_spec_name eq 1>#products.SPECT_VAR_ID#<cfelse>#GET_SPECT_NAMES.SPECT_MAIN_NAME[listfind(spect_id_list,products.spect_var_id,',')]#</cfif></a>
									</cfif>
								</td>
							</cfif>
							<td style="text-align:right;">
								#TLFormat(products.price,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#money# (#products.add_unit#)
							</td>
							<td style="text-align:right;" onclick="open_div_purchase_info('#currentrow#','#stock_id#',#product_id#);">#TLFormat(PRODUCTS.PRODUCT_STOCK)#</td>
							<cfif isdefined('xml_use_other_dept_info') and listlen(xml_use_other_dept_info,'-') eq 2>
								<td  style="text-align:right;"><!--- xmlde tanımlanan 2.depoya ait stok miktarları --->
									<cfif isdefined('get_other_dept_stock_info')>
										#TLFormat(get_other_dept_stock_info.total_dept_stock_2[listfind(other_dept_stock_id_list,STOCK_ID)])#
								</cfif>
								</td>
							</cfif>	
							<cfquery name="GET_UNITS" dbtype="query">
								SELECT DISTINCT ADD_UNIT,PRODUCT_UNIT_ID,MULTIPLIER,MAIN_UNIT FROM get_product_units WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
							</cfquery>
							<td>
								<cfloop from="1" to="#get_units.recordcount#" index="unt_ind">
								<!--- Urun birimleri --->
									<cfif get_units.add_unit[unt_ind] eq products.main_unit>
										<a class="tableyazi" onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#name_product_#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#flt_price_other#','#row_money#','','','#IS_INVENTORY#','#MULTIPLIER#','','','','#get_units.MULTIPLIER[unt_ind]#','',<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>'#products.spect_var_id#'<cfelse>''</cfif>,'#IS_PRODUCTION#','','',<cfif len(PRICE_CATID)>'#PRICE_CATID#'<cfelse>''</cfif>,'','','','#flt_price_other#','','',<cfif len(CATALOG_ID)>'#CATALOG_ID#'<cfelse>''</cfif>,'#row_due_day#'<cfif is_lot_no_based eq 1 and isdefined("PRODUCTS.LOT_NO")>,'#lot_no#'<cfelse>,''</cfif>,'','','','','','','','','','#oiv#');">
											#get_units.add_unit[unt_ind]#
									</a>
									<cfelse>
										<a class="tableyazi" onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#name_product_#','#get_units.product_unit_id[unt_ind]#','#get_units.main_unit[unt_ind]#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#flt_price_other#','#row_money#','','','#IS_INVENTORY#','#get_units.MULTIPLIER[unt_ind]#','','','','#get_units.MULTIPLIER[unt_ind]#','',<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>'#products.spect_var_id#'<cfelse>''</cfif>,'#IS_PRODUCTION#','','#get_units.add_unit[unt_ind]#',<cfif len(PRICE_CATID)>'#PRICE_CATID#'<cfelse>''</cfif>,'','','','#flt_price_other#','','',<cfif len(CATALOG_ID)>'#CATALOG_ID#'<cfelse>''</cfif>,'#row_due_day#'<cfif is_lot_no_based eq 1 and isdefined("PRODUCTS.LOT_NO")>,'#lot_no#'<cfelse>,''</cfif>,'','','','','','','','','','#oiv#');">
											#get_units.add_unit[unt_ind]#
									</a>
									</cfif>
								</cfloop>
							</td>
							<td width="15" align="center">
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCTS.PRODUCT_ID#&sid=#stock_id#','list')"><i class="icon-detail"></i></a> 
							</td>
						</tr>
						</form>
						<!--- stok alış durumları --->
						<tr style="display:none;" id="purchase_info_row#currentrow#" class="color-row">
							<td colspan="12">
								<div id="stock_purchase_info#currentrow#" style="display:none; outset cccccc; width:100%;"></div>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr> 
						<td colspan="10"><cfif not isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres=attributes.fuseaction>
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<!--- <cfif isDefined('attributes.product_cat_code') and len(attributes.product_cat_code)>
				<cfset adres = "#adres#&product_cat_code=#attributes.product_cat_code#">
			</cfif> --->
			<cfif isDefined('attributes.module_name') and len(attributes.module_name)>
				<cfset adres = "#adres#&module_name=#attributes.module_name#">
			</cfif>
			<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1><!---  xmlde proje filtresi secilmisse --->
				<cfif isdefined("attributes.project_id")>
					<cfset adres = "#adres#&project_id=#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.project_head")>
					<cfset adres = "#adres#&project_head=#attributes.project_head#">
				</cfif>
			</cfif>
			<cfif len(attributes.employee) and len(attributes.pos_code)>
				<cfset adres = "#adres#&employee=#attributes.employee#&pos_code=#attributes.pos_code#">
			</cfif>
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				<cfset adres = "#adres#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#">
			</cfif>
			<cfif len(attributes.get_company_id) and len(attributes.get_company)>
				<cfset adres = "#adres#&get_company_id=#attributes.get_company_id#&get_company=#attributes.get_company#">
			</cfif>
			<cfif len(attributes.brand_id) and len(attributes.brand_name)>
				<cfset adres = "#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#">
			</cfif>
			<cfif isdefined("attributes.amount_multiplier")>
				<cfset adres = "#adres#&amount_multiplier=#attributes.amount_multiplier#">
			</cfif>
			<cfif isdefined("attributes.serial_number")>
				<cfset adres = "#adres#&serial_number=#attributes.serial_number#">
			</cfif>
			<cfif isdefined("attributes.sort_type") and len(attributes.sort_type)>
				<cfset adres = "#adres#&sort_type=#attributes.sort_type#">
			</cfif>
			<cfif isDefined('attributes.list_property_id') and len(attributes.list_property_id)>
				<cfset adres = '#adres#&list_property_id=#attributes.list_property_id#'>
			</cfif>	
			<cfif isDefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
				<cfset adres = '#adres#&list_variation_id=#attributes.list_variation_id#'>
			</cfif>	
			<cfif isDefined('attributes.price_catid') and len(attributes.price_catid)>
				<cfset adres = '#adres#&price_catid=#attributes.price_catid#'>
			</cfif>	
            <cfif isDefined('attributes.short_code_id') and len(attributes.short_code_id)>
				<cfset adres = '#adres#&short_code_id=#attributes.short_code_id#'>
            </cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"page_type="1"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#&is_sale_product=#is_sale_product##url_str#&is_submit=1">

		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function input_control()
{

	row_count=<cfoutput>#get_property_var.recordcount#</cfoutput>;
	for(r=1;r<=row_count;r++)
	{  
		deger_variation_id = eval("document.price_cat.variation_id"+r);
		if(deger_variation_id!=undefined && deger_variation_id.value != "")
		{
			deger_property_id = eval("document.price_cat.property_id"+r);
			if(document.price_cat.list_property_id.value.length==0) ayirac=''; else ayirac=',';
			document.price_cat.list_property_id.value=document.price_cat.list_property_id.value+ayirac+deger_property_id.value;
			document.price_cat.list_variation_id.value=document.price_cat.list_variation_id.value+ayirac+deger_variation_id.value;
		}
	}
	return true;
}
document.price_cat.list_property_id.value="";
document.price_cat.list_variation_id.value="";
function open_div_purchase_info(no,stock_id,product_id)
{
	gizle_goster(eval("document.getElementById('purchase_info_row" + no + "')"));
	gizle_goster(eval("document.getElementById('stock_purchase_info" + no + "')"));
	AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_ajax_product_stock_info&purchase=1&pid='+product_id+'&sid='+stock_id,'stock_purchase_info'+no);
}
</script>
