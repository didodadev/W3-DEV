<cfif isdefined('attributes.id')>
	<cfquery name="GET_SPEC_ROW" datasource="#DSN3#">
	    SELECT * FROM SPECTS_ROW,SPECTS WHERE SPECTS_ROW.SPECT_ID =SPECTS.SPECT_VAR_ID AND SPECTS_ROW.SPECT_ID = #attributes.id# ORDER BY SPECT_ROW_ID
    </cfquery>
</cfif>
<cfset tree_stock_id_list =attributes.stock_id>
<cfset variation_stock_id_list = ''>
<cfif GET_SPEC_ROW.recordcount>
	<cfquery name="GET_PRODUCT_TREE" dbtype="query"><!--- SPEC E KAYDEDİLMİŞ OLAN ÜRÜN AĞACINDAKİ ÜRÜNLER.. --->
    	SELECT 
            STOCK_ID ,
            PRODUCT_NAME,
            SPECT_MAIN_ID,
            LINE_NUMBER,
            AMOUNT_VALUE AS AMOUNT,
            PRODUCT_ID	
		FROM
            GET_SPEC_ROW 
		WHERE 
            CHAPTER_ID IS NULL<!--- CHAPTER_ID IS NULL İSE SPEC SATIRI ÜRÜN AĞACINDNA GELMİŞTİR.. --->
    </cfquery>
	<cfif GET_PRODUCT_TREE.recordcount><cfset tree_stock_id_list = ListAppend(tree_stock_id_list,ValueList(GET_PRODUCT_TREE.STOCK_ID,','),',')></cfif>
    <!--- Şimdi seçilen ürünleri çekicez.. --->
    <cfquery name="get_variation_products_all" dbtype="query">
    	SELECT * FROM GET_SPEC_ROW WHERE CHAPTER_ID IS NOT NULL
    </cfquery>
    <cfscript>
    	for(vi_=1;vi_ lte get_variation_products_all.recordcount;vi_=vi_+1){
			if(not isdefined('is_checked_variation_#get_variation_products_all.PROPERTY_DETAIL_ID[vi_]#')){
				'is_checked_variation_#get_variation_products_all.PROPERTY_DETAIL_ID[vi_]#' = 1;
				'selected_object_#get_variation_products_all.PROPERTY_DETAIL_ID[vi_]#' = StructNew();
				new_obj= Evaluate('selected_object_#get_variation_products_all.PROPERTY_DETAIL_ID[vi_]#');
				new_obj.DIMENSION = get_variation_products_all.DIMENSION[vi_];
				new_obj.TOTAL_MIN = get_variation_products_all.TOTAL_MIN[vi_];
				new_obj.TOTAL_MAX = get_variation_products_all.TOTAL_MAX[vi_];
				new_obj.TOLERANCE = get_variation_products_all.TOLERANCE[vi_];
			}	
		}
    </cfscript>
     <!--- <cfset property_detail_id_list = listdeleteduplicates(ValueList(get_variation_products_all.PROPERTY_DETAIL_ID,','))><!--- seçilen varyasyonları belirliyoruz. --->
   <cfloop list="#property_detail_id_list#" index="v_ind"><!--- Seçili varyasyonları döndürerek seçilmiş olanları belrliyoruz. --->
		<cfset 'is_checked_variation_#v_ind#' = 1>
    </cfloop> --->
    <cfset variation_stock_id_list = listdeleteduplicates(ValueList(get_variation_products_all.STOCK_ID,','))>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='60319.Spec Satırı Yok'>!");
		this.close();
    </script>
</cfif>
<cfquery name="get_product_conf" datasource="#dsn3#">
	SELECT CONFIGURATOR_NAME,PRODUCT_CONFIGURATOR_ID FROM SETUP_PRODUCT_CONFIGURATOR WHERE ','+CONFIGURATOR_STOCK_ID+',' LIKE '%,#attributes.stock_id#,%'
</cfquery>
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfquery name="GET_PRODUCT" datasource="#dsn3#">
		SELECT 
			IS_PROTOTYPE,
			PRODUCT_NAME,
			PRODUCT_ID,
			STOCK_ID,
			PROPERTY,
			STOCK_CODE
		FROM 
			STOCKS
		WHERE 
			STOCKS.STOCK_ID =  #attributes.stock_id#
	</cfquery>
</cfif>
<!--- <cfoutput query="GET_SPEC_ROW">
    <cfset 'is_value_1_#PROPERTY_ID#' = TOTAL_MIN>
    <cfset 'is_value_2_#PROPERTY_ID#' = TOTAL_MAX>
    <cfset 'is_tolerance_#PROPERTY_ID#' = TOLERANCE>
    <cfset 'is_unit_#PROPERTY_ID#' = 'unit i ekle..'>
    <cfset 'information_#PROPERTY_ID#' ='information ekle..'>
</cfoutput> --->
<cfparam name="main_rate1" default="1">
<cfparam name="main_rate2" default="1">
<cfparam name="TREE_SYSTEM_MONEY" default="1">
<cfif not isdefined('attributes.id')>
	<cfquery name="GET_MONEY_MAX" datasource="#dsn3#"><!--- elimizde bir spect olmadığı için sayfa içindeki görünmeyen hesapları yapmak içinde olsa,bir spect money'e ihtiyaç var,o sebeble spec_money'den en son kaydı çekiyoruz ki eksik para birimi olmasın diye --->
		SELECT MAX(ACTION_ID) ID FROM SPECT_MONEY
	</cfquery>	
</cfif>
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
</cfquery>
<cfsavecontent variable="moneys"><cfoutput><cfloop query="get_money"><option value="#rate1#,#rate2#,#money#">#money#</option></cfloop></cfoutput></cfsavecontent>
<cfset url_str = "">
<cfif isdefined("attributes.row_id")>
	<cfset url_str = "#url_str#&row_id=#attributes.row_id#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_main_id")>
	<cfset url_str = "#url_str#&field_main_id=#attributes.field_main_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.main_stock_amount")>
	<cfset url_str = "#url_str#&main_stock_amount=#attributes.main_stock_amount#">
</cfif>
<cfif isdefined("attributes.basket_id")>
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
<cfif isdefined("is_spect_name_to_property")>
	<cfset url_str = "#url_str#&is_spect_name_to_property=#is_spect_name_to_property#">
</cfif>
<cfif isdefined("attributes.stock_id")>
	<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
</cfif>
<cf_date tarih = 'attributes.search_process_date'>
<link rel='stylesheet' href='/css/ajax_tab.css' type='text/css'>
<cfquery name="get_product_conf" datasource="#dsn3#">
	SELECT CONFIGURATOR_NAME,PRODUCT_CONFIGURATOR_ID FROM SETUP_PRODUCT_CONFIGURATOR WHERE ','+CONFIGURATOR_STOCK_ID+',' LIKE '%,#attributes.stock_id#,%'
</cfquery>
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfquery name="GET_PRODUCT" datasource="#dsn3#">
		SELECT 
			IS_PROTOTYPE,
			PRODUCT_NAME,
			PRODUCT_ID,
			STOCK_ID,
			PROPERTY,
			STOCK_CODE
		FROM 
			STOCKS
		WHERE 
			STOCKS.STOCK_ID =  #attributes.stock_id#
	</cfquery>
	<cfif isdefined("GET_PRODUCT.product_id")>
        <cfset url_str = "#url_str#&product_id=#GET_PRODUCT.product_id#">
    </cfif>
</cfif>

<!---  --->
<script type="text/javascript">
var row_count = <cfoutput>'#GET_SPEC_ROW.recordcount#'</cfoutput>;
function add_product_basket(object_,is_only_select){
	var secilen_checkbox='';
	this.check_box_value = object_.value;
	this.name = object_.name;
	this.chapter_id = list_getat(name,3,'_');
	this.compenent_id = list_getat(name,4,'_');
	this.ozellik_sayisi = document.getElementsByName(name).length;
	var secili_checkbox = 0;
	this.property_detail_id = list_getat(check_box_value,1,'-');
	this.total_min = document.getElementById('VARIATON_IS_VALUE_1_'+property_detail_id).value;
	this.total_max = document.getElementById('VARIATON_IS_VALUE_2_'+property_detail_id).value;
	this.tolerance = document.getElementById('VARIATON_IS_TOLERANCE_'+property_detail_id).value;
	this.dimension_ = document.getElementById('VARIATON_IS_DIMENSION_'+property_detail_id).value;
	this.stock_id = list_getat(check_box_value,2,'-');
	this.amount = list_getat(check_box_value,3,'-');
	this.variation_id = list_getat(check_box_value,4,'-');
	this.sub_variation_id = list_getat(check_box_value,5,'-');//sadece ilişkili varyasyon tıklanmış ise dolu gelir...
	this.tr_row_id = 'product_basket_row_'+chapter_id+'_'+compenent_id+'_'+variation_id;
	if(is_only_select){//önce eskisini siliyoruz.sonra tekrar ekliyoruz..
		add_delete_product(0); add_delete_product(1);
	}
	for (oz=0;oz<ozellik_sayisi;oz++){
		if(document.getElementsByName(name)[oz] != object_ && is_only_select){//seçim yapılan obje değilse ve radio ise...
			document.getElementsByName(name)[oz].checked =false;
			this.stock_id = list_getat(document.getElementsByName(name)[oz].value,2,'-');
			this.tr_row_id = 'product_basket_row_'+list_getat(document.getElementsByName(name)[oz].name,3,'_')+'_'+list_getat(document.getElementsByName(name)[oz].name,4,'_')+'_'+list_getat(document.getElementsByName(name)[oz].value,4,'-');
			add_delete_product(0);
		}	
		else
			if(document.getElementsByName(name)[oz].checked)
				secili_checkbox++;
	}
	if(!secili_checkbox){
		object_.checked=true; 
		}//checkbox'lardan hiç seçili yoksa seçimi kaldırılmak istenen checkbox'u işaretle....
	if(!is_only_select){
	if(object_.checked == true && secili_checkbox){
		add_delete_product(1);
	}
	else if (ozellik_sayisi != 1 && secili_checkbox){
		add_delete_product(0);				
	}
	}
}
function add_delete_product(type){ //type 1 ise ekleme 0 ise silme..
	if(stock_id != 0){
		var all_products_count = list_len(stock_id,',');
		for(pind=1;pind<=all_products_count;pind++){
			var product_info_sql = '';
			var real_stock_id = list_getat(stock_id,pind,',');
			var tr = document.getElementById(tr_row_id+'_'+real_stock_id);
			if(type==0){ //silme.
				if(tr)//tanımlı ise..
					tr.parentNode.removeChild(tr);
			}
			else{
				var listParam = "<cfoutput>#attributes.search_process_date#</cfoutput>" + "*" + real_stock_id;
				var product_info_query = wrk_safe_query("obj_product_info_query",'dsn3',0,listParam);
				if(product_info_query.recordcount){
					row_count++;
					document.getElementById('record_count').value =row_count;
					var _all_inputs_ ='<input type="hidden" name="chapter_id_'+row_count+'" value="'+chapter_id+'">';
					_all_inputs_ +='<input type="hidden" name="compenent_id_'+row_count+'" value="'+compenent_id+'">';
					_all_inputs_ +='<input type="hidden" name="variation_id_'+row_count+'" value="'+variation_id+'">';
					_all_inputs_ +='<input type="hidden" name="property_detail_id_'+row_count+'" value="'+property_detail_id+'">';
					_all_inputs_ +='<input type="hidden" name="sub_variation_id'+row_count+'" value="'+sub_variation_id+'">'; 
					_all_inputs_ +='<input type="hidden" name="total_min'+row_count+'" value="'+total_min+'">'; 
					_all_inputs_ +='<input type="hidden" name="total_max'+row_count+'" value="'+total_max+'">'; 
					_all_inputs_ +='<input type="hidden" name="tolerance'+row_count+'" value="'+tolerance+'">'; 
					_all_inputs_ +='<input type="hidden" name="dimension_'+row_count+'" value="'+dimension_+'">'; 
					newRow = document.getElementById("_product_basket_").insertRow(document.getElementById("_product_basket_").rows.length);
					newRow.setAttribute("name",tr_row_id+'_'+real_stock_id);
					newRow.setAttribute("id",tr_row_id+'_'+real_stock_id);	
					newRow.className = 'color-row';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = ''+_all_inputs_+'<input type="hidden" name="stock_id_'+row_count+'" value="'+real_stock_id+'"><input type="hidden" name="product_id_'+row_count+'" value="'+product_info_query.PRODUCT_ID+'"><input type="text" name="product_name_'+row_count+'" value="'+product_info_query.PRODUCT_NAME+'" style="width:180px">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="text" name="product_price_'+row_count+'" value="'+commaSplit(product_info_query.PRICE,3)+'" class="moneybox" style="width:80px">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="text" name="product_amount_'+row_count+'" value="'+amount+'" class="moneybox" style="width:80px">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="text" name="product_total_price_'+row_count+'" value="'+commaSplit(product_info_query.PRICE*amount,3)+'" class="moneybox" style="width:80px">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="text" name="product_cost_'+row_count+'" value="'+commaSplit(product_info_query.PRODUCT_COST,3)+'" class="moneybox" style="width:80px">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<select name="product_money_'+row_count+'" id="_product_money_" style="width:65px" onChange="hesapla_product_conf()"><cfoutput>#moneys#</cfoutput></select>';
					var  money_object = document.getElementById('product_money_'+row_count).options;
					for(m_ind=0;m_ind<money_object.length;m_ind++){//para birimlerinden istediğimi seçili hale getiriyoruz...
						if(money_object[m_ind].text == product_info_query.MONEY){
						 money_object[m_ind].selected=true;
						} 
					}
				}	
			}
		}
		hesapla_product_conf();
	}		
}
</script>
<cfform  name="add_spect_product_conf" action="#request.self#?fuseaction=objects.emptypopup_add_spect_product_conf#url_str#" method="post" enctype="multipart/form-data">
<table cellpadding="2" cellspacing="1" border="0">
	<tr>
    	<td width="70%">
            <table cellpadding="2" cellspacing="1">
                <tr height="25">
                    <td class="headbold">
                        <cfoutput>
                        <input type="hidden" name="record_count" id="record_count" value="0">
                        <cf_get_lang dictionary_id='60320.Özellikler'>/<cf_get_lang dictionary_id='37258.Varyasyonlar'>/<cf_get_lang dictionary_id='36437.İhtiyaçlar'> - <font color="red">#GET_PRODUCT.PRODUCT_NAME#</font>
                        <input type="hidden" name="product_name" id="product_name" value="#GET_PRODUCT.PRODUCT_NAME#">
                        <input type="hidden" name="PRODUCT_CONFIGURATOR_ID" id="PRODUCT_CONFIGURATOR_ID" value="#get_product_conf.PRODUCT_CONFIGURATOR_ID#">
                        </cfoutput>
                    </td>
                </tr>
                <cfif get_product_conf.recordcount>
                    <cfset attributes.PRODUCT_CONFIGURATOR_ID = get_product_conf.PRODUCT_CONFIGURATOR_ID>
                    <cfquery name="get_conf_chapters" datasource="#dsn3#">
                        SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_CHAPTER WHERE PRODUCT_CONFIGURATOR_ID = #attributes.PRODUCT_CONFIGURATOR_ID# ORDER BY ORDER_ROW_NO
                    </cfquery>
                    <cfif get_conf_chapters.recordcount>
                        <cfset conf_chapter_id_list = listdeleteduplicates(ValueList(get_conf_chapters.CONFIGURATOR_CHAPTER_ID,','))><!--- Tüm compenentler gelmesin sadece ilgili chapterlara eklenen compenentlerin gelmesi için performans amaçlı yazıldı bu değişken. --->
                        <cfif not len(conf_chapter_id_list)><cfset conf_chapter_id_list = 0></cfif>
                        <cfquery name="get_conf_compenents" datasource="#dsn3#">
                            SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_COMPONENTS WHERE CONFIGURATOR_CHAPTER_ID IN (#conf_chapter_id_list#)
                        </cfquery>
                        <!--- Propert Queryler --->
                        <cfset attributes.variations_id =0><!--- property_id listesini tutacak,bu ismi vermemin sebebi aşağıdaki include dosyasında bu isim ile bakıyor... --->
                        <cfquery name="get_conf_variations" datasource="#dsn3#">
                            SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE PRODUCT_CONFIGURATOR_ID = #attributes.PRODUCT_CONFIGURATOR_ID# ORDER BY VARIATION_ORDER_NO
                        </cfquery>
                        <cfif get_conf_variations.recordcount><cfset attributes.variations_id = listdeleteduplicates(ValueList(get_conf_variations.VARIATION_PROPERTY_DETAIL_ID,','))></cfif>
                        <cfif not len(attributes.variations_id)> <cfset attributes.variations_id =0></cfif>
                        <cfinclude template="../../product/query/get_property_detail.cfm"><!--- GET_PROPERTY_DETAIL query'si bu include içinde... --->
                        <!--- //Propert Queryler--->
                        <!--- VARYASYONLAR --->
                        <cfquery name="get_conf_variations" datasource="#dsn3#">
                            SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE PRODUCT_CONFIGURATOR_ID = #attributes.PRODUCT_CONFIGURATOR_ID# ORDER BY VARIATION_ORDER_NO
                        </cfquery>
                        <!--- VARYASYONLAR// --->
                        <tr>
                            <td>	
                                <ul id="menu1" class="ajax_tab_menu">
                                    <cfoutput query="get_conf_chapters">   
                                        <input type="hidden" name="CONFIGURATOR_CHAPTER_DETAIL#CONFIGURATOR_CHAPTER_ID#" id="CONFIGURATOR_CHAPTER_DETAIL#CONFIGURATOR_CHAPTER_ID#" value="#CONFIGURATOR_CHAPTER_DETAIL#">
                                       <li style="height:20px;" <cfif currentrow eq 1>class="selected"</cfif> title="#CONFIGURATOR_CHAPTER_DETAIL#" id="link_#CURRENTROW#"><a onClick="change_tabbed('link_#CURRENTROW#');">#CONFIGURATOR_CHAPTER_NAME#</a></li>
                                    </cfoutput>
                                </ul>
                                <div  id="conf_content" class="icerik" style="width:100%;height:800;">
                                    <cfoutput>
                                    <input type="hidden" name="chapter_count" id="chapter_count" value="#get_conf_chapters.recordcount#">
                                    </cfoutput>
                                    <cfset row_count_2 = 0>
                                    <cfset row_count_3 = 0>
                                    <cfset row_count_4 = 0>
                                    <cfoutput query="get_conf_chapters">
                                        <cfset chapter_currentrow = CURRENTROW>
                                        <cfset _configurator_chapter_id_ = CONFIGURATOR_CHAPTER_ID>
                                        <!--- <input type="hidden" name="chapter_id#chapter_currentrow#" value="#_configurator_chapter_id_#"> --->
                                        <table cellpadding="2" cellspacing="1" id="product_conf_content_#chapter_currentrow#"<cfif chapter_currentrow neq 1>style="display:none;"</cfif> width="100%" height="98%" class="color-border">
                                            <tr id="compenent_header_frm_row#currentrow#" class="color-list">
                                                <td colspan="6" valign="top">
                                                    <table id="table2_#currentrow#" cellpadding="2" cellspacing="1" border="0" class="color-border">
                                                        <cfquery name="get_conf_compenents_query" dbtype="query">
                                                            SELECT * FROM get_conf_compenents WHERE CONFIGURATOR_CHAPTER_ID = #CONFIGURATOR_CHAPTER_ID# ORDER BY ORDER_NO
                                                        </cfquery>
                                                        <cfif get_conf_compenents_query.recordcount>
                                                            <cfloop query="get_conf_compenents_query">
                                                                <cfset _input_type_ = TYPE><!--- 1 Radio Button --->
                                                                <cfset row_count_2 = row_count_2+1>
                                                                <tr class="color-list" id="compenent_row_frm_row#row_count_2#" valign="top">
                                                                    <!--- IS_KEY_COMPONENT --->
                                                                    <!--- <input type="hidden" name="product_configurator_compenents_id#row_count_2#" value="#PRODUCT_CONFIGURATOR_COMPENENTS_ID#"> --->
                                                                    <!--- <input type="hidden" name="chapter_id#row_count_2#" value="#CONFIGURATOR_CHAPTER_ID#"> --->
                                                                    <td valign="top">
                                                                        <!--- <input type="hidden" name="property_id#row_count_2#" value="#property_id#"> --->
                                                                        <cfif len(property_id)>
                                                                            <cfquery name="get_property_name" datasource="#dsn1#">
                                                                                SELECT PROPERTY FROM PRODUCT_PROPERTY WHERE PROPERTY_ID =#property_id#
                                                                            </cfquery>
                                                                            <cfset property_name =  get_property_name.PROPERTY>  
                                                                        <cfelse>
                                                                            <cfset property_name =  ''>    
                                                                        </cfif>
                                                                        <!--- <abbr title="Özellik Adı">#property_name#</abbr> --->
                                                                        &nbsp;&nbsp;
                                                                        <input type="text" title="Değer 1" name="IS_VALUE_1_#PRODUCT_CONFIGURATOR_COMPENENTS_ID#" id="IS_VALUE_1_#PRODUCT_CONFIGURATOR_COMPENENTS_ID#" value="" style="width:45px;<cfif IS_VALUE_1 eq 0>display:none;</cfif>">
                                                                        &nbsp;&nbsp;
                                                                        <input type="text" title="Değer 2" name="IS_VALUE_2_#PRODUCT_CONFIGURATOR_COMPENENTS_ID#" id="IS_VALUE_2_#PRODUCT_CONFIGURATOR_COMPENENTS_ID#" value=""  style="width:45px;<cfif IS_VALUE_2 eq 0>display:none;</cfif>">
                                                                        &nbsp;&nbsp;
                                                                        <input type="text" title="Tolerans" name="IS_TOLERANCE_#PRODUCT_CONFIGURATOR_COMPENENTS_ID#" id="IS_TOLERANCE_#PRODUCT_CONFIGURATOR_COMPENENTS_ID#" value=""  style="width:45px;<cfif IS_TOLERANCE eq 0>display:none;</cfif>">
                                                                        &nbsp;&nbsp;
                                                                        <input type="text" title="Ölçü" name="IS_dimension_#PRODUCT_CONFIGURATOR_COMPENENTS_ID#" id="IS_dimension_#PRODUCT_CONFIGURATOR_COMPENENTS_ID#" value=""  style="width:45px;<cfif IS_UNIT eq 0>display:none;</cfif>">
                                                                        &nbsp;&nbsp;
                                                                        #PROPERTY_DETAIL#
                                                                        &nbsp;&nbsp;
																		<cfif IS_INFORMATION eq 1>
                                                                            <input type="text" title="<cf_get_lang dictionary_id='57810.Ek Bilgi'>"	name="comp_information" id="comp_information" value="">
                                                                        <cfelseif IS_INFORMATION eq 0>
                                                                            <textarea title="<cf_get_lang dictionary_id='57810.Ek Bilgi'>" name="comp_information" id="comp_information" style="width:150;height:20;"></textarea>
                                                                        </cfif>
                                                                        &nbsp;&nbsp;
                                                                         <cfset _RELATION_PRODUCTS_ = listdeleteduplicates(RELATION_PRODUCTS)>
                                                                        <cfset product_names = ''>
																		<cfif len(_RELATION_PRODUCTS_)>
                                                                            <cfquery name="get_products_name" datasource="#dsn3#">
                                                                                SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#_RELATION_PRODUCTS_#)
                                                                            </cfquery>
                                                                            <cfif get_products_name.recordcount>
                                                                                <cfset product_names = ValueList(get_products_name.PRODUCT_NAME,',')>
                                                                            </cfif>
                                                                        </cfif>
                                                                        #product_names#
                                                                        &nbsp;&nbsp;
                                                                       <!---  #MAX_AMOUNT# --->
                                                                   </td>
                                                                </tr>
                                                                <cfquery name="get_conf_variations_query" dbtype="query">
                                                                    SELECT * FROM get_conf_variations WHERE PRODUCT_CHAPTER_ID = #CONFIGURATOR_CHAPTER_ID# AND PRODUCT_COMPENENT_ID = #PRODUCT_CONFIGURATOR_COMPENENTS_ID# AND RELATION_CONFIGURATOR_VARIATION_ID IS NULL ORDER BY VARIATION_ORDER_NO
                                                                </cfquery>
                                                                <cfquery name="get_conf_variations_query_relation" dbtype="query">
                                                                    SELECT * FROM get_conf_variations WHERE PRODUCT_CHAPTER_ID = #CONFIGURATOR_CHAPTER_ID# AND PRODUCT_COMPENENT_ID = #PRODUCT_CONFIGURATOR_COMPENENTS_ID# AND RELATION_CONFIGURATOR_VARIATION_ID IS NOT NULL ORDER BY VARIATION_ORDER_NO
                                                                </cfquery>
                                                                <tr class="color-row" id="variations_#row_count_2#">
                                                                    <td colspan="15" id="variations_td_#row_count_2#">
                                                                        <table  id="table3_#row_count_2#" cellpadding="2" cellspacing="1" class="color-header" style="margin-left:20px;">
                                                                            <cfif get_conf_variations_query.recordcount><!---Kayıtlı Varyasyon Varsa! --->
                                                                                <cfparam name="_STOCK_ID_" default="0">
                                                                                <cfloop query="get_conf_variations_query">
                                                                                	<cfif len(VARIATION_PRODUCTS)><cfset _STOCK_ID_ = listdeleteduplicates(VARIATION_PRODUCTS)></cfif>
                                                                                    <cfif isdefined('get_products_name_var')><cfset _STOCK_ID_ = VARIATION_PRODUCTS ></cfif>
                                                                                    <cfset variation_currentrow = currentrow>
                                                                                    <cfset _confgiuretor_compenent_id_ = PRODUCT_COMPENENT_ID>
                                                                                    <cfset _configurator_variation_id_ = CONFIGURATOR_VARIATION_ID>
                                                                                    <cfif isdefined('GET_PROPERTY_DETAIL') and len(VARIATION_PROPERTY_DETAIL_ID)>
                                                                                        <cfquery name="get_variation_names_detail_id" dbtype="query">
                                                                                            SELECT PROPERTY_DETAIL FROM GET_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = #VARIATION_PROPERTY_DETAIL_ID#
                                                                                        </cfquery>
                                                                                        <cfif get_variation_names_detail_id.recordcount>
                                                                                            <cfset PROPERTY_DETAIL = get_variation_names_detail_id.PROPERTY_DETAIL>
                                                                                        <cfelse>
                                                                                            <cfset PROPERTY_DETAIL = ''>
                                                                                        </cfif>
                                                                                    </cfif>
                                                                                    <cfset row_count_3 = row_count_3+1>
                                                                                    <tr class="color-row" id="variation_row_frm_row_#row_count_3#" onClick="gizle_goster(relation_variations_#row_count_3#);">
                                                                                          <!---   <input type="hidden" name="compenent_row_id#row_count_3#" value="#row_count_2#"><!--- Satır numarası --->
                                                                                            <input type="hidden" name="variation_chapter_id#row_count_3#" value="#PRODUCT_CHAPTER_ID#"><!--- chapter --->
                                                                                            <input type="hidden" name="variation_compenent_id#row_count_3#" value="#PRODUCT_COMPENENT_ID#"><!--- özellik --->
                                                                                            <input type="hidden" name="product_configurator_variation_id#row_count_3#" value="#CONFIGURATOR_VARIATION_ID#"><!--- varyasyon --->
                                                                                             --->
                                                                                            <td>
                                                                                            <cfif VARIATION_TYPE eq 1>
                                                                                              <input type="checkbox" <cfif _input_type_ eq 1 >style="background-color:CCCCCC;border:groove 1px;"</cfif> 
                                                                                              	onClick="add_product_basket(this,<cfif _input_type_ eq 1 >1<cfelse>0</cfif>);"
                                                                                                name="property_detail_#_configurator_chapter_id_#_#_confgiuretor_compenent_id_#" id="property_detail_#_configurator_chapter_id_#_#_confgiuretor_compenent_id_#"
                                                                                                <cfif isdefined('is_checked_variation_#VARIATION_PROPERTY_DETAIL_ID#')>checked</cfif>
                                                                                                value="#VARIATION_PROPERTY_DETAIL_ID#-#_STOCK_ID_#-#VARIATION_PRODUCTS_AMOUNT#-#_configurator_variation_id_#" <cfif variation_currentrow eq 1></cfif>>
                                                                                            </cfif>#left(PROPERTY_DETAIL,50)#..
                                                                                            <!--- <cfif isdefined('selected_object_#VARIATION_PROPERTY_DETAIL_ID#')>
																								<cfdump var="#Evaluate('selected_object_#VARIATION_PROPERTY_DETAIL_ID#')#">
																							</cfif> --->
                                                                                            <!--- <td><select name="variation_type_#row_count_3#" id="_variation_type_#row_count_2#" style="width:40px;"><option value="1"<cfif VARIATION_TYPE eq 1>selected</cfif>>Var</option><option value="0"<cfif VARIATION_TYPE eq 0>selected</cfif>>Yok</option></select></td> --->
                                                                                            &nbsp;&nbsp;
                                                                                            <input type="text" title="Varyasyon Değer 1" name="VARIATON_IS_VALUE_1_#VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_VALUE_1_#VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_VALUE_1 eq 0>display:none;</cfif>">
                                                                                            &nbsp;&nbsp;
                                                                                            <input type="text" title="Varyasyon Değer 2" name="VARIATON_IS_VALUE_2_#VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_VALUE_2_#VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_VALUE_2 eq 0>display:none;</cfif>">
                                                                                            &nbsp;&nbsp;
                                                                                            <input type="text" title="Varyasyon Tolerans" name="VARIATON_IS_TOLERANCE_#VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_TOLERANCE_#VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_TOLERANCE eq 0>display:none;</cfif>">
                                                                                            &nbsp;&nbsp;
                                                                                            <input type="text" title="Varyasyon Ölçü" name="VARIATON_IS_DIMENSION_#VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_DIMENSION_#VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_UNIT eq 0>display:none;</cfif>">
                                                                                            &nbsp;&nbsp;
                                                                                            #VARIATON_PROPERTY_DETAIL#
                                                                                            <!--- <input type="text" name="var_property_detail#row_count_3#"  id="_variation_property_detail#row_count_2#" style="width:100px;" maxlength="200" value=""> --->
                                                                                             <cfset product_names_var =''>
                                                                                             <cfif len(VARIATION_PRODUCTS)>
                                                                                                <cfquery name="get_products_name_var" datasource="#dsn3#">
                                                                                                    SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#VARIATION_PRODUCTS#)
                                                                                                </cfquery>
                                                                                                <cfif get_products_name_var.recordcount>
                                                                                                    <cfset product_names_var = ValueList(get_products_name_var.PRODUCT_NAME,'<br/>')>
                                                                                                </cfif>
                                                                                            </cfif>
                                                                                            <!---  <input type="hidden" name="VARIATION_STOCKS_ID_#row_count_3#">
                                                                                                <input type="text" readonly="yes" name="VARIATION_PRODUCTS_#row_count_3#" value="#product_names_var#" style="width:150px;"> --->
                                                                                            &nbsp;&nbsp;
                                                                                            <!--- <abbr title="Ürün Adı">#product_names_var#</abbr> --->
                                                                                            <!--- &nbsp;&nbsp;
                                                                                            <abbr title="Miktar">#VARIATION_PRODUCTS_AMOUNT#</abbr> --->
                                                                                            <!--- <textarea name="variation_product_scrpt_#row_count_3#" id="_variation_product_scrpt_#row_count_2#" style="width:140;height:20;">#VARIATION_SCRIPT#</textarea> --->
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr id="relation_variations_#row_count_3#" class="color-list" style="display:none;">
                                                                                        <td colspan="13">
                                                                                            <table id="table4_#row_count_3#" cellpadding="2" cellspacing="1" class="color-header" style="margin-left:20;">
                                                                                                <!--- İlişkili Varyasyon! --->
                                                                                                <cfquery name="get_conf_variations_query_relation_query" dbtype="query">
                                                                                                    SELECT * FROM get_conf_variations_query_relation WHERE RELATION_CONFIGURATOR_VARIATION_ID = #_configurator_variation_id_#
                                                                                                </cfquery>
                                                                                                <cfparam name="REL_STOCK_ID_" default="0">
                                                                                                <cfif get_conf_variations_query_relation_query.recordcount>
                                                                                                    <cfloop query="get_conf_variations_query_relation_query">
                                                                                                        <cfset rel_variation_currentrow = currentrow>
                                                                                                        <cfset rel_conf_CONFIGURATOR_VARIATION_ID = CONFIGURATOR_VARIATION_ID>
                                                                                                        <cfset row_count_4 = row_count_4+1>
                                                                                                        <cfset RELATION_VARITION_PRODUCTS = VARIATION_PRODUCTS>
                                                                                                        <cfset RELATION_VARIATION_PRODUCTS_AMOUNT = VARIATION_PRODUCTS_AMOUNT>
                                                                                                        <cfset RELATION_VARIATION_PROPERTY_DETAIL_ID = VARIATION_PROPERTY_DETAIL_ID>
                                                                                                        <cfset REL_VARIATION_ORDER_NO = VARIATION_ORDER_NO>
                                                                                                        <cfset REL_VARIATION_SCRIPT = VARIATION_SCRIPT>
                                                                                                        <cfset rel_product_names_var =''>
                                                                                                        <cfif len(RELATION_VARITION_PRODUCTS)><cfset REL_STOCK_ID_ = listdeleteduplicates(RELATION_VARITION_PRODUCTS)></cfif>
                                                                                                        <cfif len(RELATION_VARITION_PRODUCTS)>
                                                                                                            <cfquery name="rel_get_products_name_var" datasource="#dsn3#">
                                                                                                                SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#RELATION_VARITION_PRODUCTS#)
                                                                                                            </cfquery>
                                                                                                            <cfif rel_get_products_name_var.recordcount>
                                                                                                                <cfset rel_product_names_var = ValueList(rel_get_products_name_var.PRODUCT_NAME,'<br/>')>
                                                                                                            </cfif>
                                                                                                        </cfif>
                                                                                                        <cfif isdefined('GET_PROPERTY_DETAIL') and len(RELATION_VARIATION_PROPERTY_DETAIL_ID)>
                                                                                                            <cfquery name="get_variation_names_detail_id" dbtype="query">
                                                                                                                SELECT PROPERTY_DETAIL FROM GET_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = #RELATION_VARIATION_PROPERTY_DETAIL_ID#
                                                                                                            </cfquery>
                                                                                                            <cfif get_variation_names_detail_id.recordcount>
                                                                                                                <cfset REL_PROPERTY_DETAIL = get_variation_names_detail_id.PROPERTY_DETAIL>
                                                                                                            <cfelse>
                                                                                                                <cfset REL_PROPERTY_DETAIL = ''>
                                                                                                            </cfif>
                                                                                                        </cfif>
                                                                                                        <tr class="color-list" id="variation_row_frm_row_relation#row_count_4#">
                                                                                                            <td>
                                                                                                                <cfif VARIATION_TYPE eq 1>
                                                                                                                <input type="checkbox" <cfif _input_type_ eq 1 > style="background-color:FFCC99; border:groove 1px;"</cfif> 
                                                                                                               onClick="add_product_basket(this,<cfif _input_type_ eq 1 >1<cfelse>0</cfif>);" 
                                                                                                                name="rel-property_detail_#_configurator_chapter_id_#_#_confgiuretor_compenent_id_#" id="rel-property_detail_#_configurator_chapter_id_#_#_confgiuretor_compenent_id_#"
                                                                                                                <cfif isdefined('is_checked_variation_#RELATION_VARIATION_PROPERTY_DETAIL_ID#')>checked</cfif>
                                                                                                                value="#RELATION_VARIATION_PROPERTY_DETAIL_ID#-#REL_STOCK_ID_#-#RELATION_VARIATION_PRODUCTS_AMOUNT#-#rel_conf_CONFIGURATOR_VARIATION_ID#-#_configurator_variation_id_#"
																												<cfif rel_variation_currentrow eq 1></cfif>>
                                                                                                                </cfif>#left(REL_PROPERTY_DETAIL,50)#..
                                                                                                                                
                                                                                                                &nbsp;&nbsp;
                                                                                                                <input type="text" title="<cf_get_lang dictionary_id='60321.İlişkili Varyasyon'> <cf_get_lang dictionary_id='36493.Değer'> 1" name="VARIATON_IS_VALUE_1_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_VALUE_1_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_VALUE_1 eq 0>display:none;</cfif>">
                                                                                                                &nbsp;&nbsp;
                                                                                                                <input type="text" title="<cf_get_lang dictionary_id='60321.İlişkili Varyasyon'> <cf_get_lang dictionary_id='36493.Değer'> 2" name="VARIATON_IS_VALUE_2_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_VALUE_2_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_VALUE_2 eq 0>display:none;</cfif>">
                                                                                                                &nbsp;&nbsp;
                                                                                                                <input type="text" title="<cf_get_lang dictionary_id='60321.İlişkili Varyasyon'> <cf_get_lang dictionary_id='59349.Tolerans'>" name="VARIATON_IS_TOLERANCE_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_TOLERANCE_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_TOLERANCE eq 0>display:none;</cfif>">
                                                                                                                &nbsp;&nbsp;
                                                                                                                <input type="text" title="<cf_get_lang dictionary_id='60321.İlişkili Varyasyon'> <cf_get_lang dictionary_id='57686.Ölçü'>" name="VARIATON_IS_DIMENSION_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_DIMENSION_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_UNIT eq 0>display:none;</cfif>">
                                                                                                                &nbsp;&nbsp;
                                                                                                                #VARIATON_PROPERTY_DETAIL#
                                                                                                               <!---  <abbr title="Ürün Adı">#rel_product_names_var#</abbr> --->
                                                                                                           </td>
                                                                                                        </tr>
                                                                                                    </cfloop>
                                                                                                </cfif>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </cfloop>
                                                                            </cfif>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </cfloop>
                                                        </cfif>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr height="25" class="color-header">
                                                <td class="form-title"><cf_workcube_buttons is_upd='0' add_function='control()'></td>
                                            </tr>
                                    </cfoutput>
                                </div>
                             </td>
                        </tr>           
                       <!---  <cfdump var="#get_conf_chapters#"> --->
                    <cfelse>
                        <cf_get_lang dictionary_id='60322.Konfigürasyona Ait Bölüm Bulunamadı'>!
                    </cfif>
                <cfelse>
                   <cf_get_lang dictionary_id='60233.Ürüne Ait Konfigürasyon Kaydı Bulunamadı'>!
                </cfif>
            </table>
        </td>
        <cfif get_product_conf.recordcount>
        <td valign="top" width="30%">
        	<table id="_product_basket_" name="_product_basket_" cellpadding="2" cellspacing="1" width="%99" class="color-border" style=" overflow:scroll; margin-top:21">
                <tr class="color-header">
                	<td colspan="6" class="form-title"><cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='33930.Ağaç Bileşenleri'></td>
                </tr>
                 <tr class="color-list" id="header_tr_row"  name="header_tr_row" >
                    <td class="txtboldblue"><cf_get_lang dictionary_id='57657.Ürün'></td>
                    <td class="txtboldblue"><cf_get_lang dictionary_id='57638.Birim Fiyat'></td>
                    <td class="txtboldblue"><cf_get_lang dictionary_id='57635.Miktar'></td>
                    <td class="txtboldblue"><cf_get_lang dictionary_id='33932.Toplam Fiyat'></td>
                    <td class="txtboldblue"><cf_get_lang dictionary_id='58258.Maliyet'></td>
                    <td class="txtboldblue"><cf_get_lang dictionary_id='57489.Para Birimi'></td>
                </tr>
                <cfif GET_PRODUCT_TREE.recordcount>
                    <cfquery name="get_product_tree_info" datasource="#dsn3#">
                        SELECT 
                            S.PRODUCT_NAME,S.PRODUCT_ID,
                            PS.PRICE,
                            (PS.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
                            (PS.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
                            PS.PRICE_KDV,
                            PS.IS_KDV,
                            S.STOCK_ID,
                            PS.MONEY,
                            ISNULL((SELECT TOP 1  PC.PRODUCT_COST FROM PRODUCT_COST AS PC WHERE START_DATE < #attributes.search_process_date# AND PC.PRODUCT_ID = S.PRODUCT_ID AND PC.MONEY = PS.MONEY ORDER BY PC.START_DATE DESC),0) AS PRODUCT_COST,
                            SM.RATE2,
                            SM.RATE1
                        FROM 
                            STOCKS S,
                            PRICE_STANDART PS,
                            #dsn_alias#.SETUP_MONEY AS SM
                        WHERE
							<cfif session.ep.period_year lt 2009>
                            ((SM.MONEY = PS.MONEY) OR (SM.MONEY = 'YTL') AND PS.MONEY = 'TL') AND
                            <cfelse>
                            SM.MONEY = PS.MONEY AND
                            </cfif>
                            SM.PERIOD_ID = #session.ep.period_id# 
                            AND PRODUCT_STATUS = 1 
                            AND PS.PURCHASESALES = 1 
                            AND PS.PRICESTANDART_STATUS = 1 
                            AND S.PRODUCT_ID = PS.PRODUCT_ID 
                            AND STOCK_ID IN(#tree_stock_id_list#)
                    </cfquery>
                    <cfquery name="get_main_produc_info" dbtype="query">
                    	SELECT * FROM get_product_tree_info WHERE STOCK_ID = #attributes.stock_id#
                    </cfquery>
                    <cfset main_rate1 = get_main_produc_info.RATE1>
                    <cfset main_rate2 = get_main_produc_info.RATE2>
                    <cfset main_product_money= get_main_produc_info.MONEY>
                    <cfset main_product_price= get_main_produc_info.PRICE>
                    <cfoutput>
                    <input type="hidden" name="main_product_money" id="main_product_money" value="#main_product_money#">
                    <input type="hidden" name="main_prod_price" id="main_prod_price" value="#main_product_price#">
					</cfoutput>

				<cfif get_product_tree_info.recordcount>
					<cfscript>
						tree_system_money = 0;
						for(ptin=1;ptin lte get_product_tree_info.recordcount;ptin=ptin+1){
                    	  'product_price_#get_product_tree_info.STOCK_ID[ptin]#' = get_product_tree_info.PRICE[ptin];
						  'product_cost_#get_product_tree_info.STOCK_ID[ptin]#' = get_product_tree_info.PRODUCT_COST[ptin];
						  'product_money_#get_product_tree_info.STOCK_ID[ptin]#' = '#get_product_tree_info.MONEY[ptin]#';
						  'product_money_rate_#get_product_tree_info.STOCK_ID[ptin]#' = get_product_tree_info.RATE1[ptin]/get_product_tree_info.RATE2[ptin];
						  'product_money_rate1#get_product_tree_info.STOCK_ID[ptin]#' =get_product_tree_info.RATE1[ptin];
						  'product_money_rate2#get_product_tree_info.STOCK_ID[ptin]#' =get_product_tree_info.RATE2[ptin];
						}
                    </cfscript>
				</cfif>
				<cfoutput>
                <input type="hidden" name="rd_money_num" id="rd_money_num" value="#get_money.recordcount#">
                <cfloop query="get_money">
                <tr class="color-list" style="display:none;visibility:hidden;">
                <td>
                    <input type="hidden" name="urun_para_birimi#money#" id="urun_para_birimi#money#" value="#rate2/rate1#">
                    <input type="hidden" name="rd_money_name_#currentrow#" id="rd_money_name_#currentrow#" value="#money#">
                    <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                    <input type="radio" name="rd_money" id="rd_money" value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money2>checked</cfif>>#money#
                    #TLFormat(rate1,4)#/
                    <input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,4)#" style="width:50px;" class="box" onkeyup="return(FormatCurrency(this,event,4));">
				</td>
                </tr>
                </cfloop>
                </cfoutput>
                <cfset sayac = 0>
				<cfoutput query="GET_PRODUCT_TREE">
                    <tr class="color-row">
                        <td>#PRODUCT_NAME#</td>
                        <td  style="text-align:right;">
                        	<cfset rate1= 1>
                            <cfset rate2=1>
                        	<cfset money_ = '#session.ep.money#'>
							<cfset cost_ = tlformat(0,3)>
							<cfset price_ = tlformat(0,3)>
                            <cfset total_price_ = tlformat(0,3)>
                            <cfif isdefined('product_price_#STOCK_ID#')>
                            	<cfset price_=tlformat(Evaluate('product_price_#STOCK_ID#'),3)>
                            </cfif>
                            #price_#
                        </td>
                        <td  style="text-align:right;">#tlformat(AMOUNT,3)#</td>
                        <td  style="text-align:right;">
							<cfif isdefined('product_price_#STOCK_ID#')>
								<cfset tree_system_money = tree_system_money+((Evaluate('product_price_#STOCK_ID#')*AMOUNT)/Evaluate('product_money_rate_#STOCK_ID#'))>
                                <cfset total_price_ = tlformat(Evaluate('product_price_#STOCK_ID#')*AMOUNT,3)>
                            </cfif>
                            #total_price_#  
                        </td>
                        <td  style="text-align:right;">
							<cfif isdefined('product_cost_#STOCK_ID#')>
                            	<cfset cost_ = tlformat(Evaluate('product_cost_#STOCK_ID#'),3)>
							</cfif>
                            #cost_#
                        </td>
                        <td>
							<cfif isdefined('product_money_#STOCK_ID#')><cfset money_ = Evaluate('product_money_#STOCK_ID#')></cfif>
                            #money_#
                        </td>
                        <cfif isdefined('product_money_rate1#STOCK_ID#')><cfset rate1 = Evaluate('product_money_rate1#STOCK_ID#')></cfif>
                        <cfif isdefined('product_money_rate2#STOCK_ID#')><cfset rate2 = Evaluate('product_money_rate1#STOCK_ID#')></cfif>
                        <!--- Ürün ağacından gelen ürünleri query sayfasında alabilmek için öncelikle buraya hidde olarak yazıyoruz ve
						sayac değerimizi 1 arttırarak  --->
                        <input type="hidden" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="#STOCK_ID#">
                        <input type="hidden" name="product_id_#currentrow#" id="product_id_#currentrow#" value="#PRODUCT_ID#">
                        <input type="hidden" name="product_name_#currentrow#" id="product_name_#currentrow#" value="#PRODUCT_NAME#" style="width:180px">
                        <input type="hidden" name="product_price_#currentrow#" id="product_price_#currentrow#" value="#price_#" class="moneybox" style="width:80px">
                        <input type="hidden" name="product_amount_#currentrow#" id="product_amount_#currentrow#" value="#AMOUNT#" style="width:80px">
                        <input type="hidden" name="product_total_price_#currentrow#" id="product_total_price_#currentrow#" value="#total_price_#" style="width:80px">
                        <input type="hidden" name="product_cost_#currentrow#" id="product_cost_#currentrow#" value="#cost_#" style="width:80px">
                        <input type="hidden" name="product_money_#currentrow#" id="product_money_#currentrow#" value="#rate1#,#rate2#,#money_#">
                        <cfset sayac = sayac +1>
                    </tr>
                </cfoutput>
				</cfif>
                <tr class="color-header">
                	<td colspan="6" class="form-title"><cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='29807.Basket'></td>
                </tr>
                <cfif len(variation_stock_id_list)>
                <cfquery name="get_product_variation_info" datasource="#dsn3#">
                    SELECT 
                        S.PRODUCT_NAME,S.PRODUCT_ID,
                        PS.PRICE,
                        (PS.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
                        (PS.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
                        PS.PRICE_KDV,
                        PS.IS_KDV,
                        S.STOCK_ID,
                        PS.MONEY,
                        ISNULL((SELECT TOP 1  PC.PRODUCT_COST FROM PRODUCT_COST AS PC WHERE START_DATE < #attributes.search_process_date# AND PC.PRODUCT_ID = S.PRODUCT_ID AND PC.MONEY = PS.MONEY ORDER BY PC.START_DATE DESC),0) AS PRODUCT_COST,
                        SM.RATE2,
                        SM.RATE1
                    FROM 
                        STOCKS S,
                        PRICE_STANDART PS,
                        #dsn_alias#.SETUP_MONEY AS SM
                    WHERE
                        <cfif session.ep.period_year lt 2009>
                        ((SM.MONEY = PS.MONEY) OR (SM.MONEY = 'YTL') AND PS.MONEY = 'TL') AND
                        <cfelse>
                        SM.MONEY = PS.MONEY AND
                        </cfif>
                        SM.PERIOD_ID = #session.ep.period_id# 
                        AND PRODUCT_STATUS = 1 
                        AND PS.PURCHASESALES = 1 
                        AND PS.PRICESTANDART_STATUS = 1 
                        AND S.PRODUCT_ID = PS.PRODUCT_ID 
                        AND STOCK_ID IN(#variation_stock_id_list#)
                </cfquery>
				<cfscript>
						for(pvin=1;pvin lte get_product_variation_info.recordcount;pvin=pvin+1){
                    	  'product_price_#get_product_variation_info.STOCK_ID[pvin]#' = get_product_variation_info.PRICE[pvin];
						  'product_cost_#get_product_variation_info.STOCK_ID[pvin]#' = get_product_variation_info.PRODUCT_COST[pvin];
						  'product_money_#get_product_variation_info.STOCK_ID[pvin]#' = '#get_product_variation_info.MONEY[pvin]#';
						  'product_money_rate_#get_product_variation_info.STOCK_ID[pvin]#' = get_product_variation_info.RATE1[pvin]/get_product_variation_info.RATE2[pvin];
						  'product_money_rate1#get_product_variation_info.STOCK_ID[pvin]#' =get_product_variation_info.RATE1[pvin];
						  'product_money_rate2#get_product_variation_info.STOCK_ID[pvin]#' =get_product_variation_info.RATE2[pvin];
						}
                </cfscript>
                </cfif>
                <cfoutput query="get_variation_products_all"><!--- Özelliklerden seçilmiş olan ürünleri listeliyoruz.. --->
				<cfset sayac = sayac +1>
				<cfif isdefined('product_price_#STOCK_ID#') and len(Evaluate('product_price_#STOCK_ID#'))><cfset v_product_price = Evaluate('product_price_#STOCK_ID#')><cfelse><cfset v_product_price = 0></cfif>
				<cfif isdefined('product_cost_#STOCK_ID#') and len(Evaluate('product_cost_#STOCK_ID#'))><cfset v_product_cost = tlformat(Evaluate('product_price_#STOCK_ID#'),3)><cfelse><cfset v_product_cost = tlformat(0,3)></cfif>
                <tr class="color-row" id="product_basket_row_#CHAPTER_ID#_#PROPERTY_ID#_#VARIATION_ID#_#STOCK_ID#">
                    <input type="hidden" name="chapter_id_#sayac#" id="chapter_id_#sayac#" value="#CHAPTER_ID#">
                    <input type="hidden" name="compenent_id_#sayac#" id="compenent_id_#sayac#" value="#PROPERTY_ID#">
                    <input type="hidden" name="variation_id_#sayac#" id="variation_id_#sayac#" value="#VARIATION_ID#">
                    <input type="hidden" name="property_detail_id_#sayac#" id="property_detail_id_#sayac#" value="#PROPERTY_DETAIL_ID#">
                    <input type="hidden" name="sub_variation_id#sayac#" id="sub_variation_id#sayac#" value="#REL_VARIATION_ID#">
                    <input type="hidden" name="total_min#sayac#" id="total_min#sayac#" value="#TOTAL_MIN#">
                    <input type="hidden" name="total_max#sayac#" id="total_max#sayac#" value="#TOTAL_MAX#">
                    <input type="hidden" name="tolerance#sayac#" id="tolerance#sayac#" value="#TOLERANCE#">
                    <input type="hidden" name="dimension_#sayac#" id="dimension_#sayac#" value="#DIMENSION#">
                    <td>
                    	<input type="hidden" name="stock_id_#sayac#" id="stock_id_#sayac#" value="#STOCK_ID#">
                    	<input type="hidden" name="product_id_#sayac#" id="product_id_#sayac#" value="#PRODUCT_ID#">
                        <input type="text" name="product_name_#sayac#" id="product_name_#sayac#" value="#PRODUCT_NAME#" style="width:180px">
                    </td>
                    <td><input type="text" name="product_price_#sayac#" id="product_price_#sayac#" value="#tlformat(v_product_price,3)#" class="moneybox" style="width:80px"></td>
                    <td><input type="text" name="product_amount_#sayac#" id="product_amount_#sayac#" value="#tlformat(AMOUNT_VALUE,3)#" class="moneybox" style="width:80px"></td>
                    <td><input type="text" name="product_total_price_#sayac#" id="product_total_price_#sayac#" value="#tlformat(v_product_price*AMOUNT_VALUE,3)#" class="moneybox" style="width:80px"></td>
                    <td><input type="text" name="product_cost_#sayac#" id="product_cost_#sayac#" value="#v_product_cost#" style="width:80px"></td>
                    <td>
                    	<select name="product_money_#sayac#" id="_product_money_" style="width:65px" onChange="hesapla_product_conf()">
	                        <cfloop query="get_money">
                            	<option value="#rate1#,#rate2#,#money#" <cfif get_variation_products_all.MONEY_CURRENCY is MONEY>selected</cfif>>#money#</option>
							</cfloop>
                    	</select>
                     </td>
                </tr>
				</cfoutput>
            </table>
            <table cellpadding="2" width="100%" cellspacing="1" class="color-border" style="margin-top:2">
            	<tr class="color-header">
                	<td colspan="5"  style="text-align:right;">
                    <table>
                    	<tr>
                        	<cfoutput>
                        	<td class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <td><input type="text" name="system_money_total_value" id="system_money_total_value" class="box" value="" style="width:80px;"> #session.ep.money#</td>
                            <td><input type="text" name="other_money_total_value" id="other_money_total_value" class="box" value="" style="width:80px;"> #main_product_money#</td>
                            </cfoutput>
                        </tr>
                    	
                    </table>
					</td>
                </tr>
            </table>
        </td>
        </cfif>
    </tr>
</table>
</cfform>
<script type="text/javascript">
<cfoutput>
var product_rate2=#main_rate1/main_rate2#;
/*ilk başta sadece ağacın bileşenlerin toplam fiyatı yansıtılıyor..*/
document.getElementById('system_money_total_value').value  =  commaSplit(#tree_system_money#,3);
document.getElementById('other_money_total_value').value  =  commaSplit(#tree_system_money#*product_rate2,3);
/*ilk başta sadece ağacın bileşenlerin toplam fiyatı yansıtıldııııııııı..*/
</cfoutput>
hesapla_product_conf();
function hesapla_product_conf()
	{
	var product_count = document.getElementsByName('_product_money_').length;
	var _system_money_sum_ = 0;
	for(p_i_n=0;p_i_n<product_count;p_i_n++){
		var object_ = document.getElementsByName('_product_money_')[p_i_n];
		var rate = list_getat(object_.value,1,',')/list_getat(object_.value,2,',');// = rate1/rate2 den oran bulunuyor..
		var money = list_getat(object_.value,3,',');
		var row_number = list_getat(object_.name,3,'_');
		var row_sum_price = filterNum(document.getElementById('product_total_price_'+row_number).value,3);//satır toplam fiyat...
		var _system_money_ = row_sum_price / rate; //sistem fiyatının bulmak iin bölüyoruz..
		_system_money_sum_+=_system_money_;
	}
	_system_money_sum_ = _system_money_sum_+<cfoutput>#tree_system_money#</cfoutput>;//ürün ağacının içindeki ürünlerin fiyatlarınıda dahil ediyoruz...
	document.getElementById('system_money_total_value').value = commaSplit(_system_money_sum_,3)
	document.getElementById('other_money_total_value').value = commaSplit(_system_money_sum_*product_rate2,3)//ürünün para birimine çevirmek için çarpıyoruz..
}
var selected_li_id='link_1';//Tab menüde ilk sıradaki seçili olduğu için burdada el ile default olarak link_1'i seçili yapıyoruz..
var selected_row = 1;
function change_tabbed(li_id){
	document.getElementById(selected_li_id).className='';
	document.getElementById('product_conf_content_'+selected_row).style.display='none';
	document.getElementById(li_id).className='selected'
	selected_li_id = li_id;
	selected_row = list_getat(li_id,2,'_');
	document.getElementById('product_conf_content_'+selected_row).style.display='';	
}
function control(){
	alert('a');
}	
</script>

