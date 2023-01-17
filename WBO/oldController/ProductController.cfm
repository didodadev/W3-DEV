<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan	
Analys Date : 26/05/2016			Dev Date	: 26/05/2016		
Description :
	* Bu controller Ürün objesine ait kontrolleri yapar.
	
	* add,upd,det ve list eventlerini içerisinde barındırır.
	* objede kullanılan utilityler tanımlanır.
----------------------------------------------------------------------->

<!--- action sayfalarda bulunan kontroller burada kontrol ediliyor --->
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event') and listFind('add,upd,det',attributes.event)>
	<!--- Subeye Ait Fiyat Listesinin kontrolu --->
    <cfif IsDefined("attributes.event") and attributes.event is 'add'>
		<cfif session.ep.isBranchAuthorization>
			<cfscript>
				GET_PRICE_CAT = getPriceCategory.get();
            </cfscript>
            <cfif not get_price_cat.recordcount>
                <script type="text/javascript">
                    alertObject({message: "<cf_get_lang no ='879.Şube Fiyat Kategorisi eksik '>!"});
                </script>
                <cfabort>            
            </cfif>
        </cfif>
        <cfscript>
			CHECK_SAME = getProduct.get
			(
				product_code : form.product_code
			);
		</cfscript>
        <cfif check_same.recordcount>
            <script type="text/javascript">
                alertObject({message: "<cf_get_lang no ='883.Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz'> !"});
            </script>
            <cfabort>
        </cfif>	
	<cfelseif IsDefined("attributes.event") and listFind('upd,det',attributes.event)>
    	<cfif not (form.old_product_catid is form.product_catid)>
			<cfscript>
                CHECK_CODE = getProduct.get
                (
                    product_code : form.product_code,
					product_id : attributes.pid
                );
            </cfscript>
            <cfif check_code.recordcount>
                <script type="text/javascript">
                    alertObject({message:"<cf_get_lang no ='883.Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz'> !"});
                </script>
                <cfabort>
            </cfif>
        <cfelse>
        	<cfif not (form.old_product_code is form.product_code)>
                <cfscript>
					CHECK_CODE = getProduct.get
					(
						product_code : form.product_code,
						product_id : attributes.pid
					);
				</cfscript>
                <cfif check_code.recordcount>
                    <script type="text/javascript">
                        alertObject({message:"<cf_get_lang no ='883.Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz'>!"});
                    </script>
                    <cfabort>
                </cfif>
            </cfif>
        </cfif>
    </cfif>
</cfif>
	
<cf_get_lang_set module_name="product">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event is 'list')>
	<cf_get_lang_set module_name="product">
    <cf_xml_page_edit default_value="0" fuseact="product.list_product">
    <cfparam name="attributes.price_catid" default="-2">
    <cfparam name="attributes.category_name" default="">
    <cfparam name="attributes.cat" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.cat_id" default="">
    <cfparam name="attributes.short_code_id" default="">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.product_stages" default="">
    <cfparam name="attributes.sort_type" default="0">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.list_variation_id" default="">
    <cfparam name="attributes.list_property_value" default="">
    <cfparam name="attributes.list_property_id" default="">
    <cfparam name="attributes.pcat_id" default="">
    <cfparam name="attributes.page" default=1>
    <cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
      <cfset attributes.maxrows = session.ep.maxrows>
    </cfif>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset get_product.recordcount=0>
	<cfset get_product.query_count=0>
    
    <cfscript>
            get_process_type = getProcessStage.get(
                fuseaction: 'product.list_product'
            );
            
            get_price_cat = getPriceCategory.get(
                pcat_id : iif(isdefined('attributes.pcat_id') and len(attributes.pcat_id),attributes.pcat_id ,0),
                xml_related_position_cat : iif ( xml_related_position_cat eq 1,1,0) 
            );
    </cfscript>    
    
	<cfif isdefined("attributes.is_form_submitted")>            
        <cfscript>
			GET_PRODUCT = ProductModel.List
			(
				price_catid : '#iif(isdefined("attributes.price_catid"),"attributes.price_catid",DE(""))#',
				product_status : '#iif(isdefined("attributes.product_status"),"attributes.product_status",DE(""))#',
				product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
				product_types : iif(isdefined('attributes.product_types') and len(attributes.product_types), attributes.product_types,0),
				product_code : '#iif(isdefined("attributes.product_code"),"attributes.product_code",DE(""))#',
				product_detail : '#iif(isdefined("attributes.product_detail"),"attributes.product_detail",DE(""))#',
				pos_code : '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#',
				user_friendly_url : '#iif(isdefined("attributes.user_friendly_url"),"attributes.user_friendly_url",DE(""))#',
				company_stock_code : '#iif(isdefined("attributes.company_stock_code"),"attributes.company_stock_code",DE(""))#',
				company_product_name : '#iif(isdefined("attributes.company_product_name"),"attributes.company_product_name",DE(""))#',
				barcode : '#iif(isdefined("attributes.barcode"),"attributes.barcode",DE(""))#',
				manufact_code : '#iif(isdefined("attributes.manufact_code"),"attributes.manufact_code",DE(""))#',
				product_stages : iif(isdefined('attributes.product_stages') and len(attributes.product_stages), attributes.product_stages,0),
				record_emp_id : iif(isdefined('attributes.record_emp_id') and len(attributes.record_emp_id), attributes.record_emp_id,0),
				company_id : iif(isdefined('attributes.company_id') and len(attributes.company_id), attributes.company_id,0),
				brand_id : iif(isdefined('attributes.brand_id') and len(attributes.brand_id), attributes.brand_id,0),
				keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
				brand_name : '#iif(isdefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
				short_code_id :  iif(isdefined('attributes.short_code_id') and len(attributes.short_code_id), attributes.short_code_id,0),
				short_code_name : '#iif(isdefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
				cat : iif(isdefined('attributes.cat') and len(attributes.cat), attributes.cat,0),
				category_name : '#iif(isdefined("attributes.category_name"),"attributes.category_name",DE(""))#',
				special_code : '#iif(isdefined("attributes.special_code"),"attributes.special_code",DE(""))#',
				list_property_id : iif(isdefined('attributes.list_property_id') and len(attributes.list_property_id), attributes.list_property_id,0),
				list_variation_id : iif(isdefined('attributes.list_variation_id') and len(attributes.list_variation_id), attributes.list_variation_id,0),
				sort_type : iif(isdefined('attributes.sort_type') and len(attributes.sort_type), attributes.sort_type,0),
				startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
				BARCODE1 : '#IIf(IsDefined("attributes.BARCODE1"),"attributes.BARCODE1",1)#',
				PRODUCT_NAME1 : '#IIf(IsDefined("attributes.PRODUCT_NAME1"),"attributes.PRODUCT_NAME1",1)#',
				SPECIAL_CODE1 : '#iif(isdefined("attributes.SPECIAL_CODE1"),"attributes.SPECIAL_CODE1",1)#',
				MANUFACT_CODE1 : '#iif(isdefined("attributes.MANUFACT_CODE1"),"attributes.MANUFACT_CODE1",1)#',
				USER_FRIENDLY_URL1 : '#iif(isdefined("attributes.USER_FRIENDLY_URL1"),"attributes.USER_FRIENDLY_URL1",1)#',
				PRODUCT_CODE1 : '#iif(isdefined("attributes.PRODUCT_CODE1"),"attributes.PRODUCT_CODE1",1)#',
				PRODUCT_DETAIL1 : '#iif(isdefined("attributes.PRODUCT_DETAIL1"),"attributes.PRODUCT_DETAIL1",1)#',
				COMPANY_STOCK_CODE1 : '#iif(isdefined("attributes.COMPANY_STOCK_CODE1"),"attributes.COMPANY_STOCK_CODE1",1)#',
				COMPANY_PRODUCT_NAME1 : '#iif(isdefined("attributes.COMPANY_PRODUCT_NAME1"),"attributes.COMPANY_PRODUCT_NAME1",1)#',					
				x_filter_add_info : '#iif(isdefined("x_filter_add_info"),"x_filter_add_info",DE(""))#',
				maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
			);
            </cfscript>
    <cfelse>
        <cfset get_product.recordcount=0>
        <cfset get_product.query_count=0>
    </cfif>
    
    <cfparam name="attributes.totalrecords" default='#get_product.query_count#'>    	
	<cfif get_product.recordcount>
        <cfif listgetat(attributes.fuseaction,1,'.') is 'sales' or listgetat(attributes.fuseaction,1,'.') is 'purchase'>
            <cfset fuseaction_info = 'product'>
        <cfelse>
            <cfset fuseaction_info = listgetat(attributes.fuseaction,1,'.')>
        </cfif>
    </cfif>
<cfelseif IsDefined("attributes.event") and ListFindNoCase("add,det,upd",attributes.event)>
	<cfscript>
		GET_KDV = getKdv.get();
		GET_OTV = getOtv.get();
		GET_SEGMENTS = getProductSegments.get();
		GET_PRODUCT_COMP = getProductCompetitive.get();
		GET_OUR_COMPANY_INFO = getOurCompanyInfo.get();
		GET_MONEY = getMoneyInfo.get(
			type : 1
		);
	</cfscript>
	<cf_xml_page_edit fuseact="product.form_add_product"> 
    <cfif IsDefined("attributes.event") and ListFindNoCase("det,upd",attributes.event)>
		<cfif isnumeric(attributes.pid)>
            <cfscript>
                GET_PRODUCT = ProductModel.get
                (
                    product_id : attributes.pid
                );
				get_product_images = ProductModel.get_product_images
				(
					product_id : iif(isdefined("attributes.pid"),attributes.pid,0)
				);
				GET_PRODUCT_TREE = getProductTree.get
				(
					pid : attributes.pid					
				);
				get_general_parameters = ProductModel.get_product_general_parameters
                (
                    product_id : attributes.pid					
                );
				GET_STOCK = getStocks.get
				(
					product_id : attributes.pid,
					barcod	: get_product.barcod
				);
				GET_PRICE = getPrice.get
				(
					product_id : attributes.pid	,
					type= 0
				);
				GET_PRICE_SATIS = getPrice.get
				(
					product_id : attributes.pid	,
					type= 1
				);
				if (len(get_product.company_id)){			
					GET_COMP = getCompany.get
					(
						company_id : get_product.company_id			
					);
				}
            </cfscript>
        <cfelse>
            <cfset get_product.recordcount = 0>
        </cfif>
        <cfset attributes.ID = get_product.product_catid>
        <cfscript>
			GET_PRODUCT_CAT = getProductCat.get
				(
				product_catid : iif(isdefined("attributes.id"),attributes.id,0),
				hierarachy : iif(isdefined("attributes.hier"),'attributes.hier','')	
			);
			GET_WORK_STOCK = getOurCompanyInfo.get(
				type=1
			);
		</cfscript>        
		<cfif not get_product.recordcount>
         	<cfset hata  = 11>
            <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1230.Urun Kaydı Bulunamadı'> !</cfsavecontent>
            <cfset hata_mesaj  = message>
            <cfinclude template="../dsp_hata.cfm">
            <cfabort>
        </cfif> 
        
		<cfif GET_OUR_COMPANY_INFO.IS_PRODUCT_COMPANY EQ 1>
        <!--- Sirket Akis Parametrelerinde Ürün parametre bilgisi şirkete bağlı olarak gelsin mi secenegi evet ise buradan ceker, degilse eski yapi devam eder --->
            <cfif get_general_parameters.recordcount>
                <cfset get_product.product_status =get_general_parameters.product_status>
                <cfset get_product.is_inventory = get_general_parameters.is_inventory>
                <cfset get_product.is_production = get_general_parameters.is_production>
                <cfset get_product.is_sales = get_general_parameters.is_sales>
                <cfset get_product.is_purchase = get_general_parameters.is_purchase>
                <cfset get_product.is_prototype = get_general_parameters.is_prototype>
                <cfset get_product.is_internet = get_general_parameters.is_internet>
                <cfset get_product.is_extranet = get_general_parameters.is_extranet>
                <cfset get_product.is_terazi = get_general_parameters.is_terazi>
                <cfset get_product.is_karma = get_general_parameters.is_karma>
                <cfset get_product.is_zero_stock = get_general_parameters.is_zero_stock>
                <cfset get_product.is_limited_stock = get_general_parameters.is_limited_stock>
                <cfset get_product.is_serial_no = get_general_parameters.is_serial_no>
                <cfset get_product.is_lot_no = get_general_parameters.is_lot_no>
                <cfset get_product.is_cost = get_general_parameters.is_cost>
                <cfset get_product.is_quality = get_general_parameters.is_quality>
                <cfset get_product.is_commission = get_general_parameters.is_commission>
                <cfset get_product.is_add_xml = get_general_parameters.is_add_xml>
                <cfset get_product.is_gift_card = get_general_parameters.is_gift_card>
                <cfset get_product.company_id = get_general_parameters.company_id>
                <cfset get_product.quality_start_date = get_general_parameters.quality_start_date>
                <cfset get_product.gift_valid_day = get_general_parameters.gift_valid_day>
                <cfset get_product.product_manager = get_general_parameters.product_manager>
            </cfif>
            <cfscript>
                otv = get_product.OTV;
                product_id = get_product.product_id;
                barcod =  get_product.barcod;
                product_code = get_product.product_code;
                user_friendly_url = get_product.user_friendly_url;
                work_stock_id = GET_PRODUCT.WORK_STOCK_ID;
                work_stock_amount=GET_PRODUCT.work_stock_amount;
                quality_start_date = GET_PRODUCT.quality_start_date;
                OTV_AMOUNT =get_product.OTV_AMOUNT;
                dimention = get_product.DIMENTION;
                weight = get_product.WEIGHT;
                main_unit_id = get_product.MAIN_UNIT_ID;
                is_ship_unit = get_product.IS_SHIP_UNIT;
                tax_s=get_product.TAX;
                customs_recipe_code = get_product.customs_recipe_code;
                tax_purchase=  get_product.TAX_PURCHASE;
                min_margin = get_product.MIN_MARGIN;
                max_margin = get_product.MAX_MARGIN;
                product_detail =get_product.PRODUCT_DETAIL;
                product_detail2 =get_product.PRODUCT_DETAIL2;
                if(is_mpc_code != 1)
                    product_code_2 = get_product.PRODUCT_CODE_2;
                if(len(product_manager))
                    product_manager_name = get_emp_info(product_manager,1,0);
                prod_comp =get_product.PROD_COMPETITIVE;
                segment_id = get_product.SEGMENT_ID;
                shelf_life=get_product.SHELF_LIFE;
                product_name = get_product.PRODUCT_NAME;
                product_catid = get_product.PRODUCT_CATID;
                product_cat = get_product.PRODUCT_CAT;
                hierarchy = get_product.hierarchy;
                brand_name = get_product.BRAND_NAME;
                brand_id = get_product.BRAND_ID;
                brand_code = get_product.BRAND_CODE;
                short_code = get_product.SHORT_CODE;
                short_code_name = get_product.model_name;
                short_code_id = get_product.SHORT_CODE_ID;
                manufact_code = get_product.MANUFACT_CODE;				
                package_control_type = get_product.PACKAGE_CONTROL_TYPE;
                company_id = get_product.COMPANY_ID;
                company = get_product.COMPANY;
            </cfscript>
        <cfelse>
            <cfscript>
                otv =get_product.OTV;
                product_status = get_product.product_status;
                product_id = get_product.product_id;
                barcod =  get_product.barcod;
                product_code = get_product.product_code;
                user_friendly_url = get_product.user_friendly_url;
                work_stock_id = GET_PRODUCT.WORK_STOCK_ID;
                work_stock_amount=GET_PRODUCT.work_stock_amount;
                quality_start_date = GET_PRODUCT.quality_start_date;
                OTV_AMOUNT =get_product.OTV_AMOUNT;
                dimention = 0;
                weight = 0;
                main_unit_id = 0;
                is_ship_unit =0;
                tax_s=get_product.TAX;
                customs_recipe_code = get_product.customs_recipe_code;
                tax_purchase=  get_product.TAX_PURCHASE;
                min_margin = get_product.MIN_MARGIN;
                max_margin = get_product.MAX_MARGIN;
                product_detail =get_product.PRODUCT_DETAIL;
                product_detail2 =get_product.PRODUCT_DETAIL2;
                if(is_mpc_code != 1)
                    product_code_2 = get_product.PRODUCT_CODE_2;
                else
                product_code_2 = get_product.PRODUCT_CODE_2;
                product_manager = get_product.PRODUCT_MANAGER;
                if(len(product_manager))
                    product_manager_name = get_emp_info(product_manager,1,0);
                prod_comp =get_product.PROD_COMPETITIVE;
                segment_id = get_product.SEGMENT_ID;
                shelf_life=get_product.SHELF_LIFE;
                product_name = get_product.PRODUCT_NAME;
                product_catid = get_product.PRODUCT_CATID;
                brand_id = get_product.BRAND_ID;
                short_code = get_product.SHORT_CODE;
                short_code_id = get_product.SHORT_CODE_ID;
                manufact_code = get_product.MANUFACT_CODE;
                is_prototype = get_product.IS_PROTOTYPE;
                is_inventory = get_product.IS_INVENTORY;
                is_production = get_product.IS_PRODUCTION;
                is_sales = get_product.IS_SALES;
                is_purchase = get_product.IS_PURCHASE;
                is_commission = get_product.is_commission;
                IS_ADD_XML =get_product.IS_ADD_XML ;
                is_internet = get_product.IS_INTERNET;
                is_extranet = get_product.IS_EXTRANET;
                is_zero_stock = get_product.IS_ZERO_STOCK;
                is_serial_no = get_product.IS_SERIAL_NO;
                is_lot_no = get_product.IS_LOT_NO;
                is_karma = get_product.IS_KARMA;
                is_limited_stock = get_product.IS_LIMITED_STOCK;
                is_cost = get_product.IS_COST;
                is_terazi = get_product.IS_TERAZI;
                is_gift_card = get_product.IS_GIFT_CARD;
                is_quality = get_product.IS_QUALITY;
                gift_valid_day = get_product.GIFT_VALID_DAY;
                package_control_type = get_product.PACKAGE_CONTROL_TYPE;
                company_id = get_product.COMPANY_ID;
                position_code = get_product.position_code;
            </cfscript>
        </cfif> 
        <cfif (session.ep.period_year lt 2009 and get_price.money is 'TL') or (session.ep.period_year gte 2009 and get_price.money is 'YTL')>
            <cfset temp_sale_price_money=session.ep.money>
        <cfelse>
            <cfset temp_sale_price_money=get_price.money>
        </cfif>
        
	<cfelseif IsDefined("attributes.event") and attributes.event is 'add'>	    
        <cfparam name="MAXIMUM_STOCK" default="">
        <cfparam name="PROVISION_TIME" default="">
        <cfparam name="REPEAT_STOCK_VALUE" default="">
        <cfparam name="block_stock_value" default="">
        <cfparam name="saleable_stock_action_id" default="">
        <cfparam name="MINIMUM_STOCK" default="">
        <cfparam name="MINIMUM_ORDER_STOCK_VALUE" default="">
        <cfparam name="MINIMUM_ORDER_UNIT_ID" default="">
        <cfparam name="IS_LIVE_ORDER" default="">
        <cfparam name="STRATEGY_TYPE" default="">
        <cfparam name="STRATEGY_ORDER_TYPE" default="">
        <cfparam name="otv" default="0">
        <cfparam name="dimention" default="">
        <cfparam name="weight" default="">
        <cfparam name="main_unit_id" default="0">
        <cfparam name="is_ship_unit" default="0">
        <cfparam name="tax_purchase" default="0">
        <cfparam name="tax_s" default="0">
        <cfparam name="max_margin" default="0">
        <cfparam name="min_margin" default="0">
        <cfparam name="product_detail" default="">
        <cfparam name="barcod" default="">
        <cfparam name="product_code_2" default="">
        <cfparam name="product_manager" default="">
        <cfparam name="product_manager_name" default="">
        <cfparam name="prod_comp" default="0">
        <cfparam name="segment_id" default="0">
        <cfparam name="product_name" default="">
        <cfparam name="product_cat_id" default="">
        <cfparam name="product_cat" default="">
        <cfparam name="hierarchy" default="">
        <cfparam name="brand_name" default="">
        <cfparam name="brand_id" default="">
        <cfparam name="brand_code" default="">
        <cfparam name="short_code" default="">
        <cfparam name="short_code_name" default="">
        <cfparam name="short_code_id" default="">
        <cfparam name="MANUFACT_CODE" default="">
        <cfparam name="is_prototype" default="0">
        <cfparam name="is_inventory" default="1">
        <cfparam name="is_production" default="0">
        <cfparam name="is_sales" default="1">
        <cfparam name="is_purchase" default="1">
        <cfparam name="is_internet" default="0">
        <cfparam name="is_extranet" default="0">
        <cfparam name="is_zero_stock" default="0">
        <cfparam name="is_serial_no" default="0">
        <cfparam name="is_lot_no" default="0">
        <cfparam name="is_karma" default="0">
        <cfparam name="is_limited_stock" default="0">
        <cfparam name="is_cost" default="1">
        <cfparam name="is_terazi" default="0">
        <cfparam name="gift_valid_day" default="0">
        <cfparam name="is_commission" default="0">
        <cfparam name="is_gift_card" default="0">
        <cfparam name="is_quality" default="0">
        <cfparam name="PACKAGE_CONTROL_TYPE" default="0">
        <cfparam name="company_id" default="">
        <cfparam name="company" default="">
        <cfparam name="shelf_life" default="">
        <cfparam name="PRODUCT_CATID" default="">
        <cfparam name="PRODUCT_CAT" default="">
        <cfparam name="customs_recipe_code" default="">

        <cfif isdefined('attributes.pid') and len(attributes.pid)>
        	<cfscript>
                get_product_info = ProductModel.get
                (
                    product_id : attributes.pid
                );
				get_product_strategy = getStockStrategy.get
				(
					product_id : iif(isdefined("attributes.pid"),attributes.pid,0)						
				);
				get_product_period = getProductPeriod.get
				(
					product_id : iif(isdefined("attributes.pid"),attributes.pid,0)						
				);
            </cfscript>
            <cfif get_product_period.recordcount>
                <cfset product_period_cat_id = get_product_period.PRODUCT_PERIOD_CAT_ID>
            </cfif>
            <cfif get_product_info.recordcount>
                <cfscript>
                    otv =get_product_info.OTV;
					user_friendly_url = get_product_info.user_friendly_url;
                    dimention = get_product_info.DIMENTION;
                    weight = get_product_info.WEIGHT;
                    main_unit_id = get_product_info.MAIN_UNIT_ID;
                    is_ship_unit = get_product_info.IS_SHIP_UNIT;
                    tax_s=get_product_info.TAX;
                    tax_purchase=  get_product_info.TAX_PURCHASE;
                    min_margin = get_product_info.MIN_MARGIN;
                    max_margin = get_product_info.MAX_MARGIN;
                    product_detail =get_product_info.PRODUCT_DETAIL;
                    if(is_mpc_code != 1)
                        product_code_2 = get_product_info.PRODUCT_CODE_2;
                    product_manager = get_product_info.PRODUCT_MANAGER;
                    if(len(product_manager))
                        product_manager_name = get_emp_info(product_manager,1,0);
                    prod_comp =get_product_info.PROD_COMPETITIVE;
                    segment_id = get_product_info.SEGMENT_ID;
                    shelf_life=get_product_info.SHELF_LIFE;
                    product_name = get_product_info.PRODUCT_NAME;
                    product_cat_id = get_product_info.PRODUCT_CATID;
                    product_cat = get_product_info.PRODUCT_CAT;
                    hierarchy = get_product_info.hierarchy;
                    brand_name = get_product_info.BRAND_NAME;
                    brand_id = get_product_info.BRAND_ID;
                    brand_code = get_product_info.BRAND_CODE;
                    short_code = get_product_info.SHORT_CODE;
                    short_code_name = get_product_info.model_name;
                    short_code_id = get_product_info.SHORT_CODE_ID;
                    manufact_code = get_product_info.MANUFACT_CODE;
                    is_prototype = get_product_info.IS_PROTOTYPE;
                    is_inventory = get_product_info.IS_INVENTORY;
                    is_production = get_product_info.IS_PRODUCTION;
                    is_sales = get_product_info.IS_SALES;
                    is_purchase = get_product_info.IS_PURCHASE;
                    is_internet = get_product_info.IS_INTERNET;
                    is_extranet = get_product_info.IS_EXTRANET;
                    is_zero_stock = get_product_info.IS_ZERO_STOCK;
                    is_serial_no = get_product_info.IS_SERIAL_NO;
                    is_lot_no = get_product_info.IS_LOT_NO;
                    is_karma = get_product_info.IS_KARMA;
                    is_limited_stock = get_product_info.IS_LIMITED_STOCK;
                    is_cost = get_product_info.IS_COST;
                    is_terazi = get_product_info.IS_TERAZI;
                    is_gift_card = get_product_info.IS_GIFT_CARD;
                    is_quality = get_product_info.IS_QUALITY;
                    gift_valid_day = get_product_info.GIFT_VALID_DAY;
                    package_control_type = get_product_info.PACKAGE_CONTROL_TYPE;
                    company_id = get_product_info.COMPANY_ID;
                    company = get_product_info.COMPANY;
                </cfscript>
            <cfelse>
            	<cfscript>
                    otv ='';
                    dimention = '';
					user_friendly_url = '';
                    weight = '';
                    main_unit_id = '';
                    is_ship_unit = '';
                    tax_s='';
                    tax_purchase=  '';
                    min_margin ='';
                    max_margin = '';
                    product_detail ='';
                    if(is_mpc_code != 1)
                        product_code_2 = '';
                    product_manager = '';
                    if(len(product_manager))
                        product_manager_name = get_emp_info(product_manager,1,0);
                    prod_comp ='';
                    segment_id = '';
                    shelf_life='';
                    product_name = '';
                    product_cat_id = '';
                    product_cat = '';
                    hierarchy = '';
                    brand_name = '';
                    brand_id = '';
                    brand_code = '';
                    short_code = '';
                    short_code_name = '';
                    short_code_id = '';
                    manufact_code = '';
                    is_prototype = '';
                    is_inventory = '';
                    is_production = '';
                    is_sales = '';
                    is_purchase ='';
                    is_internet = '';
                    is_extranet = '';
                    is_zero_stock = '';
                    is_serial_no = '';
                    is_lot_no = '';
                    is_karma = '';
                    is_limited_stock = '';
                    is_cost = '';
                    is_terazi ='';
                    is_gift_card = '';
                    is_quality = '';
                    gift_valid_day = '';
                    package_control_type = '';
                    company_id = '';
                    company = '';
                </cfscript>
            </cfif>
            <cfif get_product_strategy.recordcount>
                <cfscript>
                    MAXIMUM_STOCK = get_product_strategy.MAXIMUM_STOCK;
                    PROVISION_TIME= get_product_strategy.PROVISION_TIME;
                    REPEAT_STOCK_VALUE= get_product_strategy.REPEAT_STOCK_VALUE;
                    MINIMUM_STOCK= get_product_strategy.MINIMUM_STOCK;
                    MINIMUM_ORDER_STOCK_VALUE= get_product_strategy.MINIMUM_ORDER_STOCK_VALUE;
                    MINIMUM_ORDER_UNIT_ID= get_product_strategy.MINIMUM_ORDER_UNIT_ID;
                    IS_LIVE_ORDER= get_product_strategy.IS_LIVE_ORDER;
                    STRATEGY_TYPE= get_product_strategy.STRATEGY_TYPE;
                    STRATEGY_ORDER_TYPE= get_product_strategy.STRATEGY_ORDER_TYPE;
                    block_stock_value=get_product_strategy.BLOCK_STOCK_VALUE;
                    saleable_stock_action_id=get_product_strategy.STOCK_ACTION_ID;
                </cfscript>
            </cfif>
        </cfif>
		<cfset attributes.active_cat = 1>
        <cfscript>
			GET_UNIT = getUnit.get();
			GET_CODE_CAT = getProductAccountingCode.get
			(
				active_cat : iif(isdefined("attributes.active_cat"),attributes.active_cat,0)						
			);
			GET_SALEABLE_STOCK_ACTION = getSalebleStockAction.get();
			GET_WORK_STOCK = getOurCompanyInfo.get
			(
				type : 2					
			);
		</cfscript>
	</cfif>        
</cfif>
<script type="text/javascript">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event is 'list')>
	$( document ).ready(function() 
		{			
			$('#keyword').focus();
			search_product.list_property_id.value="";
			search_product.list_property_value.value="";
			search_product.list_variation_id.value="";
		});			
		function test()
		{		
			if(document.getElementById("pos_manager").value=='')
			{
				$('#pos_code').val('');		
			}
			if(document.getElementById("record_emp_name").value=='')
			{
				$('#record_emp_id').val('');		
			}
			
		}
		
			function showInformation(row)
			{
				if(document.getElementById("variation_id"+row).value=='')
					document.getElementById("information_row"+row).style.display='none';
				else
					document.getElementById("information_row"+row).style.display='';
			}
		function input_control()
		{	
			if(search_product.company.value.length == 0) search_product.company_id.value = '';
			return true;	
			
		}

<cfelseif IsDefined("attributes.event") and ListFindNoCase("add,det,upd",attributes.event)>
	$(function(){
		validate().set();
		is_special_code_for_one = <cfoutput>#is_special_code_for_one#</cfoutput>;
		});
	function kontrol_day()
	{
		if($("form #is_gift_card").prop('checked')){
		<cfif IsDefined("attributes.event") and (attributes.event is 'det' or attributes.event is 'upd')>
			$("#item-gift_valid_day").css("display","");
		</cfif>
		<cfif IsDefined("attributes.event") and attributes.event is 'add'>
			$("#gift_day").css("display","");
		</cfif>	
		}
		else{
		<cfif IsDefined("attributes.event") and attributes.event is 'add'>
			$("#gift_day").css("display","none");
		</cfif>	
		<cfif IsDefined("attributes.event") and (attributes.event is 'det' or attributes.event is 'upd')>	
			$("#item-gift_valid_day").css("display","none");
		</cfif>	
		}
	}
	function barcod_control()
		{
			var prohibited_asci='32,33,34,35,36,37,38,39,40,41,42,43,44,59,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171,187,163,126';
			barcode = document.getElementById('barcod');
			toplam_ = barcode.value.length;
			deger_ = barcode.value;
			if(toplam_>0)
			{
				for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
				{
					tus_ = deger_.charAt(this_tus_);
					cont_ = list_find(prohibited_asci,tus_.charCodeAt());
					if(cont_>0)
					{
                    	alertObject({message: "[space],!,\"\,#,$,%,&,',(,),*,+,,;,<,=,>,?,@,[,\,],],`,{,|,},£,~ Karakterlerinden Oluşan Barcod Girilemez!"});
						barcode.value = '';
						break;
					}
				}
			}
		}	
	<cfif IsDefined("attributes.event") and (attributes.event is 'det' or attributes.event is 'upd')>
	$(document).ready(function()
		{
			product.product_name.focus();		
		});

		function unformat_fields()
		{ 
			document.getElementById('STANDART_ALIS').value = filterNum(document.getElementById('STANDART_ALIS').value,"<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>");
			document.getElementById('STANDART_SATIS').value = filterNum(document.getElementById('STANDART_SATIS').value,"<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>");
			document.getElementById('MIN_MARGIN').value = filterNum(document.getElementById('MIN_MARGIN').value);
			document.getElementById('MAX_MARGIN').value = filterNum(document.getElementById('MAX_MARGIN').value); 
			if(document.product.otv_amount != undefined)product.otv_amount.value = filterNum(product.otv_amount.value,4);
			return true;
		}
		function yeni_yukle()
		{
			<cfoutput>
				refresh_box('_dsp_product_alternatives_','#request.self#?fuseaction=product.emptypopup_dsp_product_alternatives_ajax&pid=#attributes.pid#','0');
			</cfoutput>
		}
		function kontrol()
		{
			var formName = 'product',
			form = $('form[name="'+ formName +'"]');
			
			<cfif GET_PRODUCT_TREE.recordcount>
				<cfif get_product.is_prototype eq 1>
					if(product.is_prototype.checked==false){
						if (!confirm("Ürüne Ait Kayıtlar Var.Özelleştirilebilir Seçeneğini Kaldırmak İstediğinizden Emin Misiniz?") )
						{
						  return false;
						}
					}
				</cfif>
			</cfif>	
			
			<cfif is_special_code_for_one eq 1>
				if (form.find('input#product_code_2').val().length != 0 ){
					var check_code = wrk_safe_query("prd_check_code", "dsn3", 0,$('#product_code_2').val());
					if(check_code.recordcount > 0 && $('#old_product_code_2').val() != $('#product_code_2').val())
					{
						validateMessage('notValid',form.find('input#product_code_2'),0 );
						return false;
					}else{
							validateMessage('valid',form.find('input#product_code_2') );
		
						}
				}
			</cfif>	
			
			if ( $("form #is_gift_card").prop('checked') && (form.find('input#item-gift_valid_day').val() == '' || form.find('input#item-gift_valid_day').val() == 0)){
				validateMessage('notValid',form.find('input#item-gift_valid_day'),0 );
				return false;
			}
			else{
				validateMessage('valid',form.find('input#item-gift_valid_day') );
				}
				
			change_prod_msg();
			
			if ( $("form #is_terazi").prop('checked') && trim( form.find('input#barcod').val() ).length !=7){
				validateMessage('notValid',form.find('input#barcod'),0);
				return false;
			}
			else{
				validateMessage('valid',form.find('input#barcod'));
				}
				
			if ($("form #is_inventory").prop('checked') && form.find('input#barcode_require').val() == 1 && trim(form.find('input#barcod').val()).length < 7){
				validateMessage('notValid',form.find('input#barcod'),1);
				return false;
			}
			else{
				validateMessage('valid',form.find('input#barcod') );
				}
				
			if (form.find('input#product_cat').val() == '' || form.find('input#product_catid').val() == ''){
				validateMessage('notValid',form.find('input#product_cat'),0 );
				return false;
			}
			else{
				validateMessage('valid',form.find('input#product_cat') );
				}
			
			if (form.find('input#product_cat').val() == '' && form.find('input#product_catid').val() == ''){
				validateMessage('notValid',form.find('input#product_cat'),0 );
				return false;
			}
			else{
				validateMessage('valid',form.find('input#product_cat'));
				}
				
			if($('#tax').children('option').length <1)
			{
				validateMessage('notValid',form.find('input#tax'),0 );
				return false;
			}
			else{
					validateMessage('valid',form.find('input#tax') );
				}	
			
			if ( (form.find('input#old_product_catid').val() != form.find('input#product_catid').val()) || (form.find('input#old_product_code').val()!=form.find('input#product_code').val()) )
			{
				if (!confirm("<cf_get_lang no='706.Bu Değişiklik Stok Hiyerarşisinin Bozulmasına, Kaydedilmiş Ek Bilgilerin Silinmesine ve Veri Kaybına Neden Olabilir! Devam Etmek İstiyor musunuz'>?") )
				{
				  return false;
				}
			}
			
			temp_profit_margin_min = parseFloat(form.find('input#MIN_MARGIN').val());
			temp_profit_margin_max = parseFloat(form.find('input#MAX_MARGIN').val()); 
			if(temp_profit_margin_min!="" && temp_profit_margin_max!="" && (temp_profit_margin_min>temp_profit_margin_max))
			{
				validateMessage('notValid',form.find('input#MIN_MARGIN'),0 );
				return false;
			}
			else{
					validateMessage('valid',form.find('input#MIN_MARGIN') );
				}	
			<cfif get_work_stock.recordcount>
				if (form.find('input#work_product_name').val() != '' && form.find('input#work_stock_id').val() != '' && form.find('input#work_stock_amount').val() == ''){
					validateMessage('notValid',form.find('input#work_product_name'),0 );
					return false;
				}
				else{
						validateMessage('valid',form.find('input#work_product_name'));
					}
			
			if(product.work_stock_amount != undefined)
				product.work_stock_amount.value = filterNum(product.work_stock_amount.value);
			</cfif>
			var urun_adi_ = form.find('input#product_name').val();
			var urun_adi_ = ReplaceAll(urun_adi_,"'"," ");
			var listParam = urun_adi_+"*" + "<cfoutput>#attributes.pid#</cfoutput>";
			var get_prod_info = wrk_safe_query("get_product_info", "dsn1", 0, listParam);
			if(get_prod_info.recordcount)
			{
				<cfif isdefined('x_use_same_product_name') and x_use_same_product_name eq 1>
                    validateMessage('notValid',form.find('input#product_name'),1 );
				<cfelse>
					validateMessage('notValid',form.find('input#product_name'),2 );
					return false;
				</cfif>
			}
			else
			{
				validateMessage('valid',form.find('input#product_name') );
			}
			if(product.product_status.disabled == true)
				product.product_status.disabled = false;
			if(document.getElementById('is_quality').checked == false)
				product.quality_startdate.value = '';
			return process_cat_control();
			}
		function change_prod_msg()
		{
			var msg_txt='';	
			<cfif get_product.is_production eq 1>
			if(product.is_production.checked==false)
				msg_txt="<cf_get_lang no='700.Üretiliyor Seçeneğini Kaldırdınız Ürünün Ağacını Düzenlemeniz Gerekebilir'> !";
			</cfif>
			<cfif get_product.is_inventory eq 1>
				if(product.is_inventory.checked==false)
					msg_txt = msg_txt + '\n<cf_get_lang no="898.Envantere Dahil Seçeneğini Kaldırdınız"> !';
			</cfif>
			<cfif get_product.is_serial_no eq 1>
				if(product.is_serial_no.checked==false)
					msg_txt=msg_txt + '\n <cf_get_lang no="701.Seri No Takip Seçeneğini Kaldırdınız">!';
			</cfif>
			<cfif get_product.is_lot_no eq 1>
				if(product.is_lot_no.checked==false)
					msg_txt=msg_txt + '\n <cf_get_lang no="989.Lot No Takip Seçeneğini Kaldırdınız">!';
			</cfif>
			<cfif get_product.is_zero_stock eq 0>
				if(product.is_zero_stock.checked==true)
					msg_txt=msg_txt + '\n <cf_get_lang no="702.Sıfır Stok Seçeneği Seçili Ürün Artık Sıfır Stokla Çalışacaktır">!';
			</cfif>
			<cfif get_product.is_karma eq 1>
				if(product.is_karma.checked==false)
					msg_txt=msg_txt + '\n<cf_get_lang no="703.Karma Koli Seçeneğini Kaldırdınız">';
			</cfif>
			if(msg_txt!='')
			{
				alertObject({message: msg_txt+'\n\n<cf_get_lang no="704.Yaptığınız Düzenlemelerden Emin Olunuz">!'});
			}
			unformat_fields();
			return true;
		}
	</cfif>	
	<cfif IsDefined("attributes.event") and attributes.event is 'add'>
	$( document ).ready(function() 
	{    
		$('#product_name').focus();
		
	});
	function kontrolProduct()
	{


		var formName = 'product',
		form = $('form[name="'+ formName +'"]');
		<cfif is_special_code_for_one eq 1>
			if (form.find('input#product_code_2').val().length != 0 ){
				var check_code = wrk_safe_query("prd_check_code", "dsn3", 0,$('#product_code_2').val());
				if(check_code.recordcount > 0)
				{
					validateMessage('notValid',form.find('input#product_code_2'),0 );
					return false;
				}else{
						validateMessage('valid',form.find('input#product_code_2'));
	
					}
			}
		</cfif>
		
		
		<cfif is_mpc_code eq 1 and is_show_detail_variation eq 1>
			var mpc_code="";
			
			for (var r=1;r<=$('#property_row_count').val();r++)
			{
				if($('#chk_product_property_'+r).checked)
				{
					var mpc_code_temp = list_getat($('#property_detail_'+r).value,2,';');
					
					if(mpc_code_temp == "")
					{ 
						alertObject({message: r + ". <cf_get_lang no='229.Özellik İçin Varyasyon Kodu Tanımlamalısınız'> ! "});
						return false;
					}				
					if(mpc_code!='')
						mpc_code = mpc_code  + '.' + mpc_code_temp;
					else
						mpc_code = mpc_code_temp;
				}
			}
			if(mpc_code.lenght!=0)			
			document.getElementById('product_code_2').value=mpc_code;
		</cfif>	

		if ( $("form #is_terazi").prop('checked') && trim( form.find('input#barcod').val() ).length !=7){
				validateMessage('notValid',form.find('input#barcod'),0 );
				return false;
			}
		else{
			validateMessage('valid',form.find('input#barcod') );
			}
			
		if ($("form #is_inventory").prop('checked') && form.find('input#barcode_require').val() == 1 && trim(form.find('input#barcod').val()).length < 7){
			validateMessage('notValid',form.find('input#barcod'),1 );
			return false;
		}
		else if(form.find('input#barcode_require').val() == 0 && form.find('input#barcod').val() != '' && form.find('input#is_barcode_control') == 0) {
			var get_barcod_info = wrk_safe_query('prod_control_barcode','dsn1',0,product.barcod.value);
			if(get_barcod_info.recordcount)
			{
				validateMessage('notValid',form.find('input#barcod'),2 );
				return false;
			}	
		}
		else{
			validateMessage('valid',form.find('input#barcod') );
			}
				
		if (form.find('input#product_cat').val() == '' ){
			validateMessage('notValid',form.find('input#product_cat'),0 );
			return false;
		}
		else{
				validateMessage('valid',form.find('input#product_cat'));
			}
		
		if($('#tax').children('option').length <1)
			{
			validateMessage('notValid',form.find('input#tax'),0 );
			return false;
		}
		else{
				validateMessage('valid',form.find('input#tax'));
			}
		
		if (form.find('input#unit_id').val() == '' ){
			validateMessage('notValid',form.find('input#unit_id'),0 );
			return false;
		}
		else{
				validateMessage('valid',form.find('input#unit_id') );
			}
			
		if ( $("form #is_gift_card").prop('checked') && (form.find('input#item-gift_valid_day').val() == '' || form.find('input#item-gift_valid_day').val() == 0)){
			validateMessage('notValid',form.find('input#item-gift_valid_day'),0 );
			return false;
		}
		else{
			validateMessage('valid',form.find('input#item-gift_valid_day'));
			}
			
		temp_profit_margin_min = parseFloat(form.find('input#MIN_MARGIN').val());
		temp_profit_margin_max = parseFloat(form.find('input#MAX_MARGIN').val()); 
		if(temp_profit_margin_min!="" && temp_profit_margin_max!="" && (temp_profit_margin_min>temp_profit_margin_max))
		{
			validateMessage('notValid',form.find('input#MIN_MARGIN'),0 );
			return false;
		}
		else{
				validateMessage('valid',form.find('input#MIN_MARGIN'));
			}	
			
		<cfif GET_WORK_STOCK.RECORDCOUNT>
			if (form.find('input#work_product_name').val() == '' ){
				validateMessage('notValid',form.find('input#work_product_name'),0 );
				return false;
			}
			else{
					validateMessage('valid',form.find('input#work_product_name'));
				}
			
			product.work_stock_amount.value = filterNum(product.work_stock_amount.value);
		</cfif>
		
		var urun_adi_ = form.find('input#product_name').val();
		var urun_adi_ = ReplaceAll(urun_adi_,"'"," ");
		
		var get_prod_info = wrk_safe_query('prd_get_prod_info','dsn1',0,urun_adi_);
		if(get_prod_info.recordcount)
		{
			<cfif isdefined('x_use_same_product_name') and x_use_same_product_name eq 1>
				validateMessage('notValid',form.find('input#product_name'),1);
			<cfelse>
				validateMessage('notValid',form.find('input#product_name'),2 );
				return false;
			</cfif>
		}
		else
		{
			validateMessage('valid',form.find('input#product_name') );
		}
		unformat_fields();
		return process_cat_control();
	}	
	
	function kontrol_day2()
	{
		if($("form #is_gift_card").prop('checked'))
			$("#item-gift_valid_day").css("display","");
		else
			$("#item-gift_valid_day").css("display","none");
	}
	
	function unformat_fields()
	{
		allFilterNum('purchase','price','weight','maximum_stock','repeat_stock_value','minimum_stock','minimum_order_stock_value','provision_time','block_stock_value','otv_amount');
		document.getElementById('MIN_MARGIN').value = filterNum(document.getElementById('MIN_MARGIN').value);
		document.getElementById('MAX_MARGIN').value = filterNum(document.getElementById('MAX_MARGIN').value); 
		var pname_ = product.product_name.value;
		
		
	}
		<cfif is_show_detail_variation eq 1>
			function add_property()
			{
				var property = wrk_safe_query("get_product_property", "dsn1", 0, $('#product_catid').val());
				var row_count=0;  
				for(kk=1;kk<=$('#property_row_count').val();kk++)
				{
					hide('product_property_row'+kk);
				}
				
				for(i=1;i<=$('#property_row_count').val();i++)
				{
					document.getElementById('chk_product_property_'+i).checked = false;
					document.getElementById("product_property").deleteRow(1);
				}
				
				for(i=0;i<property.recordcount;++i)
				{
					row_count++;
					$('#property_row_count').val() = row_count;
					var newRow;
					var newCell;
					newRow = document.getElementById("product_property").insertRow(document.getElementById("product_property").rows.length);
					newRow.setAttribute("name","product_property_row" + row_count);
					newRow.setAttribute("id","product_property_row" + row_count);
					var property_detail = wrk_safe_query("get_product_property_detail", "dsn1", 0, property.PROPERTY_ID[i]);
			
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("width","60px;");
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("width","10px;");
					newCell.innerHTML = '<input type="checkbox" name="chk_product_property_'+row_count+'" id="chk_product_property_'+row_count+'" value="'+property.PROPERTY_ID[i]+'" checked>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("width","50px;");
					newCell.innerHTML = '<input type="hidden" name="product_property_id'+row_count+'" id="product_property_id'+row_count+'" value="'+property.PROPERTY_ID[i]+'"><input type="text" name="product_property_value'+row_count+'" id="product_property_value'+row_count+'" value="'+property.PROPERTY[i]+'" style="width:210px;">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("width","200px;");
					newCell.innerHTML = '<select name="property_detail_'+row_count+'" id="property_detail_'+row_count+'" style="width:210px;"><option value=""><cf_get_lang_main no="322.Seçiniz"></option></select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("colspan","2");
					for(var k=0;k < property_detail.recordcount;k++)
						document.getElementById('property_detail_'+row_count).options[k+1]=new Option(property_detail.PROPERTY_DETAIL[k],property_detail.PROPERTY_DETAIL_ID[k]+';'+property_detail.PROPERTY_DETAIL_CODE[k]);
				}
			}
		</cfif>	
	</cfif>			
</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_product.cfm';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	
	if(attributes.event contains 'upd' or attributes.event contains 'det')
	WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = get_product.product_stage;
	else
	WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.form_add_product';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/FormProduct.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product&event=det&pid=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'product';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrolProduct() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.form_upd_product';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/FormProduct.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product&event=det&pid=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'pid=##attributes.pid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.pid##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_product';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryRecordEmp'] = 'record_member';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryIsConsumer'] = '1';
	
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'product';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '9-3';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'product/query/upd_product.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'product.list_product&event=det&pid=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.pid##';
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'product.form_upd_product';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'product/display/detail_product.cfm';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
		
		if(isdefined("attributes.event") and not(attributes.event is 'add' or attributes.event is 'list'))
		{
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'ProductController.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = "<cf_meta_descriptions action_id = '#attributes.pid#' action_type ='PRODUCT_ID'>";
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['type'] = 2; 
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['file'] = '#request.self#?fuseaction=product.ajax_product_images&image_id=#attributes.pid#&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['addFile'] = '#request.self#?fuseaction=product.form_add_popup_image&id=#attributes.pid#&type=product&detail=#URLEncodedFormat(get_product.product_name)#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['infoFile'] = '#request.self#?fuseaction=objects.popup_get_archive&id=#attributes.pid#&module=product&module_id=5&action_id=#attributes.pid#&type=product';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['copyFile'] = '#request.self#?fuseaction=product.add_popup_multi_image&id=#attributes.pid#&type=product&detail=#URLEncodedFormat(get_product.product_name)#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['id'] = 'imgs_get';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['title'] = '#lang_array.item[78]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['file'] = "<cf_get_workcube_asset asset_cat_id='-3' module_id='5' action_section='PRODUCT_ID' action_id='#attributes.pid#'>";
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['type'] = 2; 
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['file'] = '#request.self#?fuseaction=product.emptypopup_dsp_showed_vision_ajax&product_id=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['addFile'] = '#request.self#?fuseaction=product.list_product_vision&event=add&product_id=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['id'] = '_dsp_showed_vision_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['title'] = '#lang_array.item[537]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['type'] = 2; 
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['file'] = '#request.self#?fuseaction=product.emptypopup_dsp_product_detail_units_ajax&pid=#attributes.pid#&is_show_unit_amount=#is_show_unit_amount#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['addFile'] = '#request.self#?fuseaction=product.form_add_popup_unit&pid=#attributes.pid#&product_code=#get_product.product_code#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['id'] = 'product_unit_detail';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['title'] = '#lang_array.item[20]#';		
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][5]['type'] = 2; 
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][5]['file'] = '#request.self#?fuseaction=product.emptypopup_dsp_product_relations_ajax&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][5]['addFile'] = '#request.self#?fuseaction=product.popup_add_related_product&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][5]['id'] = '_dsp_product_relations_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][5]['title'] = '#lang_array.item[90]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][6]['type'] = 2; 
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][6]['file'] = '#request.self#?fuseaction=product.emptypopup_dsp_related_product_cat_ajax&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][6]['addFile'] = '#request.self#?fuseaction=product.popup_add_related_product_cat&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][6]['id'] = '_dsp_product_cat_relations_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][6]['title'] = '#lang_array.item[45]#';	
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][7]['type'] = 2; 
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][7]['file'] = '#request.self#?fuseaction=product.emptypopup_dsp_product_alternatives_ajax&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][7]['addFile'] = '#request.self#?fuseaction=product.popup_add_anative_product&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][7]['id'] = '_dsp_product_alternatives_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][7]['title'] = '#lang_array.item[91]#';

			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][8]['type'] = 2; 
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][8]['file'] = '#request.self#?fuseaction=product.emptypopup_product_team_ajax&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][8]['addFile'] = '#request.self#?fuseaction=product.popup_form_add_upd_worker&pid=#url.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][8]['id'] = '_product_team_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][8]['title'] = '#lang_array.item[68]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][9]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][9]['file'] = "<cf_get_workcube_content action_type ='PRODUCT_ID' action_type_id ='#attributes.pid#' style='0' design='0'>";
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][10]['type'] = 2; 
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][10]['file'] = '#request.self#?fuseaction=product.emptypopup_product_mixed_ajax&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][10]['addFile'] = '#request.self#?fuseaction=product.popup_dsp_karma_contents&pid=#url.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][10]['id'] = '_mixed_product_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][10]['title'] = '#lang_array.item[533]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][11]['type'] = 2; 
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][11]['file'] = '#request.self#?fuseaction=product.emptypopup_dsp_product_anti_alternatives_ajax&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][11]['addFile'] = '#request.self#?fuseaction=product.popup_add_anative_product_except&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][11]['id'] = '_dsp_product_anti_alternatives_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][11]['title'] = '#lang_array.item[496]#';
			
			if(is_mpc_code eq 2){
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][12]['type'] = 2; 
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][12]['file'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_mpc_create&type=2&product_id=#get_product.product_id#&product_code_2=#get_product.product_code_2#&is_ajax=1"';
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][12]['id'] = '_dsp_product_mpc_code_';
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][12]['title'] = '#lang_array.item[60]#';
			}
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['type'] = 2; 
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['file'] = '#request.self#?fuseaction=product.emptypopup_ajax_dsp_product_stocks&is_production=#get_product.is_production#&pid=#attributes.pid#&product_code=#get_product.product_code#&is_terazi=#get_product.is_terazi#&is_inventory=#get_product.is_inventory#&is_auto_barcode=#is_auto_barcode#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['addFile'] = '#request.self#?fuseaction=product.form_add_popup_stock_code&pid=#get_product.product_id#&pcode=#get_product.product_code#&is_terazi=#get_product.is_terazi#&is_inventory=#get_product.is_inventory#&is_auto_barcode=#is_auto_barcode#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['infoFile'] = '#request.self#?fuseaction=product.form_add_popup_sub_stock_code&pid=#get_product.product_id#&pcode=#get_product.product_code#&is_auto_barcode=#is_auto_barcode#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['infoFile2'] = '#request.self#?fuseaction=objects.popup_product_stocks&pid=#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['id'] = '_dsp_product_stocks_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['title'] = '#lang_array_main.item[754]#';
			
		}
		
		// Tab Menus //
		tabMenuStruct = StructNew();

		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		// Upd //
		if(isdefined("attributes.event") and not(attributes.event is 'add' or attributes.event is 'list'))
		{
				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = "#lang_array.item[212]#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=product.list_product_actions&id=#attributes.pid#&&is_from_product=1";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = "#lang_array_main.item[345]#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=product.product&action_name=pid&action_id=#attributes.pid#','list')";
				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array_main.item[61]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_product_history&product_id=#attributes.pid#','medium','popup_member_history')";
				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['text'] = '#lang_array.item[527]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_form_add_product_companies&pid=#attributes.pid#','list')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['text'] = '#lang_array_main.item[535]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_list_product_surveys&product_id=#attributes.pid#','list')";
				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][5]['text'] = '#lang_array.item[283]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][5]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_view_product_comment&product_id=#attributes.pid#','medium')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][6]['text'] = '#lang_array.item[245]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][6]['href'] = "#request.self#?fuseaction=report.product_action_search&pid=#attributes.pid#";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][7]['text'] = '#lang_array_main.item[1399]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][7]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_list_period&pid=#attributes.pid#','list');";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][8]['text'] = '#lang_array.item[397]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][8]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_form_add_product_dt_property&pid=#attributes.pid#&product_catid=#get_product.product_catid#','longpage')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][9]['text'] = '#lang_array.item[435]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][9]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_product_guaranty&pid=#attributes.pid#','longpage')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][10]['text'] = '#lang_array.item[655]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][10]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_product_quality&pid=#attributes.pid#','longpage')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][11]['text'] = '#lang_array.item[95]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][11]['href'] = "#request.self#?fuseaction=product.detail_product_place&pid=#get_product.product_id#";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][12]['text'] = '#lang_array.item[266]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][12]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_product_contract&pid=#attributes.pid#','wide')";
			
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][13]['text'] = '#lang_array.item[121]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][13]['href'] = "#request.self#?fuseaction=stock.list_stock&event=upd&pid=#attributes.pid#";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][14]['text'] = '#lang_array.item[105]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][14]['href'] = "#request.self#?fuseaction=product.detail_product_price&pid=#attributes.pid#";
			
			
			i = 15;
			if(session.ep.our_company_info.workcube_sector is 'tersane')
			{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[47]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&product_catid=#get_product.product_catid#&info_id=#attributes.pid#&type_id=-5','list')";
			i = i + 1;
			}
			if(get_product.is_production and get_stock.recordcount)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[93]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#get_stock.stock_id#";		
				i = i + 1;
			}
			
			 if(get_stock.recordcount)
			 {
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[1003]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_related_trees&stock_id=#get_stock.stock_id#','project')";		
				i = i + 1;
			 } 
			if(get_stock.recordcount and (get_product.is_production or get_product.is_prototype))
			 {
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[235]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_spect_main&stock_id=#get_stock.stock_id#','page'))";		
				i = i + 1;
			}        
			if(fusebox.circuit is 'product' or session.ep.isBranchAuthorization)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[846]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=#fusebox.circuit#.form_add_product_cost&pid=#attributes.pid#";
				i = i + 1;
			}
			if (get_product.is_karma)
			   {
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[696]#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_dsp_karma_contents&pid=#attributes.pid#','longpage')";
			   }
			   
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=add";		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=add&pid=#attributes.pid#";		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['target'] = "_blank";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.pid#&print_type=371','page')";		
									  
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,det';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRODUCT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-product_name','item-product_cat','item-unit_id','item-product_code']";

</cfscript>
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif isdefined('attributes.event') and attributes.event is 'add'>
        <!--- add --->
        <cfif (get_work_stock.recordcount)>
        		<cfset attributes.OTV = attributes.OTV>
                <cfset attributes.OTV_AMOUNT = attributes.OTV_AMOUNT>
        		<cfset attributes.work_product_name = attributes.work_product_name>
				<cfset attributes.work_stock_id	= attributes.work_stock_id>
				<cfset attributes.work_stock_amount = attributes.work_stock_amount>
        <cfelse>
        		<cfset attributes.OTV = 0>
                <cfset attributes.OTV_AMOUNT = 0>
        		<cfset attributes.work_product_name = ''>
				<cfset attributes.work_stock_id	= ''>
				<cfset attributes.work_stock_amount = 0>
        </cfif>
        <cfscript>
            add = ProductModel.add (
                product_catid	: attributes.product_catid,
                acc_code_cat	: iif(isdefined('attributes.acc_code_cat') and len(attributes.acc_code_cat), attributes.acc_code_cat,0),
                segment_id		: iif(isdefined('attributes.segment_id') and len(attributes.segment_id), attributes.segment_id,0),
                product_manager	: iif(isdefined('attributes.product_manager') and len(attributes.product_manager), attributes.product_manager,0),
                is_quality		: iif(isdefined('attributes.is_quality'),1,0),
                is_cost 		: iif(isdefined('attributes.is_cost'), 1,0),
				is_inventory	: iif(isdefined('attributes.is_inventory'),1,0),
				is_production	: iif(isdefined('attributes.is_production'),1,0),
				is_sales 		: iif(isdefined('attributes.is_sales'), 1,0),
				is_purchase		: iif(isdefined('attributes.is_purchase'),1,0),
				is_prototype	: iif(isdefined('attributes.is_prototype'),1,0),
				is_terazi 		: iif(isdefined('attributes.is_terazi'),1,0),
				is_serial_no	: iif(isdefined('attributes.is_serial_no'),1,0),
				is_zero_stock	: iif(isdefined('attributes.is_zero_stock'),1,0),
				is_karma 		: iif(isdefined('attributes.is_karma'),1,0),
				is_limited_stock: iif(isdefined('attributes.is_limited_stock'),1,0),
				is_lot_no		: iif(isdefined('attributes.is_lot_no'),1,0),
                product_name	: iif(isdefined('attributes.product_name') and len(attributes.product_name), 'attributes.product_name',''),
				tax				: iif(len(attributes.tax), attributes.tax,0),
                tax_purchase	: iif(len(attributes.tax_purchase), attributes.tax_purchase,0),
                barcod			: iif(isdefined('attributes.barcod') and len(attributes.barcod), attributes.barcod,''),
                product_detail	: iif(isdefined('attributes.product_detail') and len(attributes.product_detail), 'attributes.product_detail',''),
                company_id		: iif(isdefined('attributes.company_id') and len(attributes.company_id), attributes.company_id,0),
                brand_name		: iif(len(attributes.brand_name), attributes.brand_name,''),
                brand_id		: iif(isdefined('attributes.brand_id') and len(attributes.brand_id), attributes.brand_id,0),
				brand_code		: iif(isdefined('attributes.brand_code') and len(attributes.brand_code), attributes.brand_code,''),
				product_code 	: iif(isdefined('attributes.product_code') and len(attributes.product_code), attributes.product_code,''),
                manufact_code	: iif(len(attributes.manufact_code), 'attributes.manufact_code',''),
				shelf_life 		: iif(isdefined('attributes.shelf_life') and len(attributes.shelf_life), attributes.shelf_life,0),
				is_internet 	: iif(isdefined('attributes.is_internet'), 1,0),
				prod_comp	 	: iif(isdefined('attributes.prod_comp') and len(attributes.prod_comp), attributes.prod_comp,0),
				process_stage 	: iif(isdefined('attributes.process_stage') and len(attributes.process_stage), attributes.process_stage,0),
				min_margin	 	: iif(isdefined('attributes.min_margin') and len(attributes.min_margin), attributes.min_margin,0),
				max_margin	 	: iif(isdefined('attributes.max_margin') and len(attributes.max_margin), attributes.max_margin,0),
				product_status	: iif(isdefined('attributes.product_status'), 1,0),
				OTV				: iif(isdefined('attributes.OTV') and len(attributes.OTV), attributes.OTV,0),
                OTV_AMOUNT		: iif(isdefined('attributes.OTV_AMOUNT') and len(attributes.OTV_AMOUNT), attributes.OTV_AMOUNT,0),
				product_code_2 	: iif(isdefined('attributes.product_code_2') and len(attributes.product_code_2), 'attributes.product_code_2',''),
				short_code	 	: iif(isdefined('attributes.short_code') and len(attributes.short_code), attributes.short_code,''),
				short_code_id 	: iif(isdefined('attributes.short_code_id') and len(attributes.short_code_id), attributes.short_code_id,0),
				MONEY_ID_SS		: iif(isdefined('attributes.MONEY_ID_SS') and len(attributes.MONEY_ID_SS), 'attributes.MONEY_ID_SS',0),
				MONEY_ID_SS_OLD	: iif(isdefined('attributes.MONEY_ID_SS_OLD') and len(attributes.MONEY_ID_SS_OLD), 'attributes.MONEY_ID_SS_OLD',0),
				package_control_type	: iif(isdefined('attributes.package_control_type') and len(attributes.package_control_type), attributes.package_control_type,0),
				is_commission 	: iif(isdefined('attributes.is_commission') , 1,0),
				is_gift_card 	: iif(isdefined('attributes.is_gift_card'), 1,0),
				gift_valid_day 	: iif(isdefined('attributes.gift_valid_day') and len(attributes.gift_valid_day), attributes.gift_valid_day,0),
				customs_recipe_code	: iif(isdefined('attributes.customs_recipe_code') and len(attributes.customs_recipe_code), 'attributes.customs_recipe_code',''),
				weight		 	: iif(isdefined('attributes.weight') and len(attributes.weight), attributes.weight,0),
				dimention	 	: iif(isdefined('attributes.dimention') and len(attributes.dimention), attributes.dimention,0),
				volume		 	: iif(isdefined('attributes.volume') and len(attributes.volume), attributes.volume,0),
				money_id_sa 	: iif(isdefined('attributes.money_id_sa') and len(attributes.money_id_sa), 'attributes.money_id_sa',0),
				maximum_stock 	: iif(isdefined('attributes.maximum_stock') and len(attributes.maximum_stock), attributes.maximum_stock,0),
				provision_time 	: iif(isdefined('attributes.provision_time') and len(attributes.provision_time), attributes.provision_time,0),
				repeat_stock_value 	: iif(isdefined('attributes.repeat_stock_value') and len(attributes.repeat_stock_value), attributes.repeat_stock_value,0),
				minimum_stock 	: iif(isdefined('attributes.minimum_stock') and len(attributes.minimum_stock), attributes.minimum_stock,0),
				minimum_order_stock_value 	: iif(isdefined('attributes.minimum_order_stock_value') and len(attributes.minimum_order_stock_value), attributes.minimum_order_stock_value,0),
				is_live_order 	: iif(isdefined('attributes.is_live_order'), 1,0),
				strategy_type 	: iif(isdefined('attributes.strategy_type') and len(attributes.strategy_type), attributes.strategy_type,0),
				strategy_order_type 	: iif(isdefined('attributes.strategy_order_type') and len(attributes.strategy_order_type), attributes.strategy_order_type,0),
				block_stock_value 	: iif(isdefined('attributes.block_stock_value') and len(attributes.block_stock_value), attributes.block_stock_value,0),
				saleable_stock_action_id 	: iif(isdefined('attributes.saleable_stock_action_id') and len(attributes.saleable_stock_action_id), attributes.saleable_stock_action_id,0),
				user_friendly_url 	: iif(isdefined('attributes.user_friendly_url') and len(attributes.user_friendly_url), 'attributes.user_friendly_url',''),
				purchase 		: iif(isdefined('attributes.purchase') and len(attributes.purchase), attributes.purchase,0),
				price 			: iif(isdefined('attributes.price') and len(attributes.price), attributes.price,0),
				is_tax_included_sales 	: iif(isdefined('attributes.is_tax_included_sales') and len(attributes.is_tax_included_sales), attributes.is_tax_included_sales,0),
				property_row_count 	: iif(isdefined('attributes.property_row_count') and len(attributes.property_row_count), attributes.property_row_count,0),
				is_tax_included_purchase 	: iif(isdefined('attributes.is_tax_included_purchase') and len(attributes.is_tax_included_purchase), attributes.is_tax_included_purchase,0)
            );
            attributes.actionId = add;
		</cfscript>
    <cfelseif isdefined('attributes.event') and listFind('upd,det',attributes.event)>
    	<cfif (get_work_stock.recordcount)>
        		<cfset attributes.OTV = attributes.OTV>
                <cfset attributes.OTV_AMOUNT = attributes.OTV_AMOUNT>
        		<cfset attributes.work_product_name = attributes.work_product_name>
				<cfset attributes.work_stock_id	= attributes.work_stock_id>
				<cfset attributes.work_stock_amount = attributes.work_stock_amount>
        <cfelse>
        		<cfset attributes.OTV = 0>
                <cfset attributes.OTV_AMOUNT = 0>
        		<cfset attributes.work_product_name = ''>
				<cfset attributes.work_stock_id	= ''>
				<cfset attributes.work_stock_amount = 0>
        </cfif>
    	<cfscript>
            upd = ProductModel.upd (
				product_name		: iif(isdefined('attributes.product_name') and len(attributes.product_name), 'attributes.product_name',''),
				barcod				: iif(isdefined('attributes.barcod') and len(attributes.barcod), FORM.barcod,''),
				pid					: iif(isdefined('attributes.pid') and len(attributes.barcod), FORM.pid,0),
				old_product_catid	: iif(isdefined('attributes.old_product_catid') and len(attributes.old_product_catid), FORM.old_product_catid,0),
            	product_catid		: iif(isdefined('attributes.product_catid') and len(attributes.product_catid), FORM.product_catid,0),
				product_code		: iif(isdefined('attributes.product_code') and len(attributes.product_code), 'FORM.product_code',''),
				old_product_code	: iif(isdefined('attributes.old_product_code') and len(attributes.old_product_code), 'FORM.old_product_code',''),
				user_friendly_url 	: iif(isdefined('attributes.user_friendly_url') and len(attributes.user_friendly_url), 'attributes.user_friendly_url',''),
				quality_startdate	: iif(isdefined('attributes.quality_startdate') and len(attributes.quality_startdate), 'attributes.quality_startdate',''),
				product_status		: iif(isdefined('attributes.product_status'), 1,0),
				is_quality			: iif(isdefined('attributes.is_quality'),1,0),
                is_cost 			: iif(isdefined('attributes.is_cost'), 1,0),
				is_inventory		: iif(isdefined('form.is_inventory'),1,0),
				is_production		: iif(isdefined('form.is_production'),1,0),
				is_sales 			: iif(isdefined('form.is_sales'), 1,0),
				is_purchase			: iif(isdefined('form.is_purchase'),1,0),
				is_prototype		: iif(isdefined('form.is_prototype'),1,0),
				is_terazi 			: iif(isdefined('form.is_terazi'),1,0),
				is_serial_no		: iif(isdefined('form.is_serial_no'),1,0),
				is_zero_stock		: iif(isdefined('form.is_zero_stock'),1,0),
				is_karma 			: iif(isdefined('form.is_karma'),1,0),
				is_limited_stock	: iif(isdefined('attributes.is_limited_stock'),1,0),
				is_commission 		: iif(isdefined('attributes.is_commission') , 1,0),
				is_add_xml			: iif(isdefined('attributes.is_add_xml') , 1,0),
				is_lot_no			: iif(isdefined('form.is_lot_no'),1,0),
				company_id			: iif(isdefined('attributes.company_id') and len(attributes.company_id), attributes.company_id,0),
				product_manager		: iif(isdefined('attributes.product_manager') and len(attributes.product_manager), attributes.product_manager,0),
				is_internet 		: iif(isdefined('attributes.is_internet'), 1,0),
				is_extranet 		: iif(isdefined('attributes.is_extranet'), 1,0),
				is_gift_card 		: iif(isdefined('attributes.is_gift_card'), 1,0),
				gift_valid_day 		: iif(isdefined('attributes.gift_valid_day') and len(attributes.gift_valid_day), attributes.gift_valid_day,0),
				tax					: iif(len(FORM.tax), FORM.tax,0),
                tax_purchase		: iif(len(FORM.tax_purchase), FORM.tax_purchase,0),
				OTV					: iif(isdefined('attributes.OTV') and len(attributes.OTV), attributes.OTV,0),
                OTV_AMOUNT			: iif(isdefined('attributes.OTV_AMOUNT') and len(attributes.OTV_AMOUNT), attributes.OTV_AMOUNT,0),
				product_detail		: iif(isdefined('FORM.product_detail') and len(FORM.product_detail), 'FORM.product_detail',''),
				product_detail2		: iif(isdefined('FORM.product_detail2') and len(FORM.product_detail2), 'FORM.product_detail2',''),
				brand_name			: iif(len(attributes.brand_name), attributes.brand_name,''),
                brand_id			: iif(isdefined('attributes.brand_id') and len(attributes.brand_id), attributes.brand_id,0),
				manufact_code		: iif(len(FORM.manufact_code), 'FORM.manufact_code',''),
				old_manufact_code	: iif(len(FORM.old_manufact_code), 'FORM.old_manufact_code',''),
				shelf_life 			: iif(isdefined('attributes.shelf_life') and len(attributes.shelf_life), attributes.shelf_life,0),
				segment_id			: iif(isdefined('attributes.segment_id') and len(attributes.segment_id), attributes.segment_id,0),
				prod_comp	 		: iif(isdefined('attributes.prod_comp') and len(attributes.prod_comp), attributes.prod_comp,0),
				process_stage 		: iif(isdefined('attributes.process_stage') and len(attributes.process_stage), attributes.process_stage,0),
				min_margin	 		: iif(isdefined('attributes.min_margin') and len(attributes.min_margin), attributes.min_margin,0),
				max_margin	 		: iif(isdefined('attributes.max_margin') and len(attributes.max_margin), attributes.max_margin,0),
				product_code_2		: iif(len(FORM.product_code_2), 'FORM.product_code_2',''),
				old_product_code_2	: iif(len(FORM.old_product_code_2), 'FORM.old_product_code_2',''),
				short_code	 		: iif(isdefined('attributes.short_code') and len(attributes.short_code), attributes.short_code,''),
				short_code_id 		: iif(isdefined('attributes.short_code_id') and len(attributes.short_code_id), attributes.short_code_id,''),
				work_product_name	: iif(isdefined('attributes.work_product_name') and len(attributes.work_product_name), 'attributes.work_product_name',''),
				work_stock_id		: iif(isdefined('attributes.work_stock_id') and len(attributes.work_stock_id), attributes.work_stock_id,0),
				work_stock_amount	: iif(isdefined('attributes.work_stock_amount') and len(attributes.work_stock_amount), attributes.work_stock_amount,0),
				package_control_type: iif(isdefined('attributes.package_control_type') and len(attributes.package_control_type), attributes.package_control_type,0),
				customs_recipe_code : iif(isdefined('attributes.customs_recipe_code') and len(attributes.customs_recipe_code), 'attributes.customs_recipe_code',''),
				comp				: iif(isdefined('attributes.comp') and len(attributes.comp), 'attributes.comp',''),
				OLD_BARCOD			: iif(isdefined('attributes.OLD_BARCOD') and len(attributes.OLD_BARCOD), attributes.OLD_BARCOD,''),
				STANDART_ALIS		: iif(isdefined('attributes.STANDART_ALIS') and len(attributes.STANDART_ALIS), attributes.STANDART_ALIS,0),
				STANDART_SATIS		: iif(isdefined('attributes.STANDART_SATIS') and len(attributes.STANDART_SATIS), attributes.STANDART_SATIS,0),
				OLD_STANDART_ALIS	: iif(isdefined('attributes.OLD_STANDART_ALIS') and len(attributes.OLD_STANDART_ALIS), attributes.OLD_STANDART_ALIS,0),
				OLD_STANDART_SATIS	: iif(isdefined('attributes.OLD_STANDART_SATIS') and len(attributes.OLD_STANDART_SATIS), attributes.OLD_STANDART_SATIS,0),
				money_id_sa 		: iif(isdefined('FORM.money_id_sa') and len(FORM.money_id_sa), 'FORM.money_id_sa',0),
				money_id_sa_old 	: iif(isdefined('FORM.money_id_sa_old') and len(FORM.money_id_sa_old), 'FORM.money_id_sa_old',0),
				is_tax_included_purchase : iif(isdefined('attributes.is_tax_included_purchase') and len(attributes.is_tax_included_purchase), attributes.is_tax_included_purchase,0),
				tax_purchase		: iif(len(FORM.tax_purchase), FORM.tax_purchase,0),
				old_tax_purchase	: iif(len(FORM.old_tax_purchase), FORM.old_tax_purchase,0),
				old_tax_sell		: iif(len(FORM.old_tax_sell), FORM.old_tax_sell,0),
				old_is_tax_included_purchase : iif(isdefined('attributes.old_is_tax_included_purchase') and len(attributes.old_is_tax_included_purchase), attributes.old_is_tax_included_purchase,0),
				is_spect_name_upd	: iif(isdefined('FORM.is_spect_name_upd') and len(FORM.is_spect_name_upd), 'FORM.is_spect_name_upd',0)
            );
            attributes.actionId = upd;
		</cfscript>
	</cfif>
</cfif>