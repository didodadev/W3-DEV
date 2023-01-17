<!--- <cfparam name="main_rate1" default="1">
<cfparam name="main_rate2" default="1">
<cfparam name="TREE_SYSTEM_MONEY" default="1"> --->
<!--- <cfquery name="GET_MONEY" datasource="#dsn#">
    SELECT	
        PERIOD_ID,
        MONEY,
        RATE1,
        RATE2 
    FROM
        SETUP_MONEY 
    WHERE 
        PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery> --->
<!--- <cfsavecontent variable="moneys"><cfoutput><cfloop query="get_money"><option value="#rate1#,#rate2#,#money#">#money#</option></cfloop></cfoutput></cfsavecontent>
 ---><!--- <cfset url_str = "">
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
</cfif> --->
<cf_date tarih = 'attributes.search_process_date'>
<link rel='stylesheet' href='/css/ajax_tab.css' type='text/css'>
<cfquery name="get_product_conf" datasource="#dsn3#">
	SELECT CONFIGURATOR_NAME,PRODUCT_CONFIGURATOR_ID FROM SETUP_PRODUCT_CONFIGURATOR WHERE ','+CONFIGURATOR_STOCK_ID+',' LIKE '%,#attributes.stock_id#,%'
</cfquery>
<!--- <cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
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
</cfif> --->
<cfset tree_stock_id_list =attributes.stock_id>
<cfquery name="GET_PRODUCT_TREE" datasource="#DSN3#">
	SELECT 
    	PT.RELATED_ID AS STOCK_ID,
		S.PRODUCT_NAME,
        PT.SPECT_MAIN_ID,
        PT.LINE_NUMBER,
        PT.AMOUNT,
        S.PRODUCT_ID	
	FROM 
    	PRODUCT_TREE PT,
		STOCKS S
	WHERE
		PT.RELATED_ID = S.STOCK_ID AND
		PT.STOCK_ID = #attributes.stock_id#
</cfquery>
<cfif GET_PRODUCT_TREE.recordcount><cfset tree_stock_id_list = ListAppend(tree_stock_id_list,ValueList(GET_PRODUCT_TREE.STOCK_ID,','),',')></cfif>
<!--- <script type="text/javascript">
var row_count = <cfoutput>#GET_PRODUCT_TREE.recordcount#</cfoutput>;
function add_product_basket(object_,is_only_select){
	var secilen_checkbox='';
	this.check_box_value = object_.value;
	this.name = object_.name;
	this.chapter_id = list_getat(name,3,'_');
	this.compenent_id = list_getat(name,4,'_');
	this.ozellik_sayisi = document.getElementsByName(name).length;
	var secili_checkbox = 0;
	this.property_detail_id = list_getat(check_box_value,1,'-');
	this.is_value_1_object =document.getElementById('VARIATON_IS_VALUE_1_'+property_detail_id);
	this.is_value_2_object =document.getElementById('VARIATON_IS_VALUE_2_'+property_detail_id);
	this.tolerance_object =document.getElementById('VARIATON_IS_TOLERANCE_'+property_detail_id);
	this.dimension_object =document.getElementById('VARIATON_IS_DIMENSION_'+property_detail_id);
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
var onchangeFields='0';//onchange'i değiştirğinde basketteki ürünlerdeki oranlarda  değişicek..default olarak 0 atıyorum,daha sonra üzerine satır numaralarını ekliyorum ve sonra 2.ci elemandan 
function add_delete_product(type){ //type 1 ise ekleme 0 ise silme..
	//if(stock_id != 0){
		if(stock_id =="")stock_id='0';
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
            	var listParam = <cfoutput>#attributes.search_process_date#</cfoutput> + "*" + real_stock_id;
				var product_info_query = wrk_safe_query("obj_product_info_query_2",'dsn3',0,listParam);
				if(product_info_query.recordcount || real_stock_id == 0){
					if(!product_info_query.recordcount){
						product_info_query.PRICE = 0;
						product_info_query.PRODUCT_ID = 0;
						product_info_query.PRODUCT_NAME = 'Özellik';
						product_info_query.PRODUCT_COST = 0;
						product_info_query.MONEY ='<cfoutput>#session.ep.money#</cfoutput>'
					}
					row_count++;
					document.getElementById('record_count').value =row_count;
					var _all_inputs_ ='<input type="hidden" name="chapter_id_'+row_count+'" value="'+chapter_id+'">';
					_all_inputs_ +='<input type="hidden" name="compenent_id_'+row_count+'" value="'+compenent_id+'">';
					_all_inputs_ +='<input type="hidden" name="variation_id_'+row_count+'" value="'+variation_id+'">';
					_all_inputs_ +='<input type="hidden" name="property_detail_id_'+row_count+'" value="'+property_detail_id+'">';
					_all_inputs_ +='<input type="hidden" name="sub_variation_id'+row_count+'" value="'+sub_variation_id+'">'; 
					_all_inputs_ +='<input type="hidden" name="total_min'+row_count+'"  value="'+total_min+'">'; 
					_all_inputs_ +='<input type="hidden" name="total_max'+row_count+'" value="'+total_max+'">'; 
					_all_inputs_ +='<input type="hidden" name="tolerance'+row_count+'" value="'+tolerance+'">'; 
					_all_inputs_ +='<input type="hidden" name="dimension_'+row_count+'" value="'+dimension_+'">'; 
					newRow = document.getElementById("_product_basket_").insertRow(document.getElementById("_product_basket_").rows.length);
					newRow.setAttribute("name",tr_row_id+'_'+real_stock_id);
					newRow.setAttribute("id",tr_row_id+'_'+real_stock_id);	
					newRow.className = 'color-row';
					newCell = newRow.insertCell();
					newCell.innerHTML = ''+_all_inputs_+'<input type="hidden" name="stock_id_'+row_count+'" value="'+real_stock_id+'"><input type="hidden" name="product_id_'+row_count+'" value="'+product_info_query.PRODUCT_ID+'"><input type="text" name="product_name_'+row_count+'" value="'+product_info_query.PRODUCT_NAME+'" style="width:180px">';
					newCell = newRow.insertCell();
					newCell.innerHTML = '<input type="text" name="product_price_'+row_count+'" value="'+commaSplit(product_info_query.PRICE,3)+'" class="moneybox" style="width:80px">';
					newCell = newRow.insertCell();
					newCell.innerHTML = '<input type="text" name="product_amount_'+row_count+'" value="'+amount+'" class="moneybox" style="width:80px">';
					newCell = newRow.insertCell();
					newCell.innerHTML = '<input type="text" name="product_total_price_'+row_count+'" value="'+commaSplit(product_info_query.PRICE*amount,3)+'" class="moneybox" style="width:80px">';
					newCell = newRow.insertCell();
					newCell.innerHTML = '<input type="text" name="product_cost_'+row_count+'" value="'+commaSplit(product_info_query.PRODUCT_COST,3)+'" class="moneybox" style="width:80px">';
					newCell = newRow.insertCell();
					newCell.innerHTML = '<select name="product_money_'+row_count+'" id="_product_money_" style="width:65px" onChange="hesapla_product_conf()"><cfoutput>#moneys#</cfoutput></select>';
					var  money_object = document.getElementById('product_money_'+row_count).options;
					for(m_ind=0;m_ind<=list_len(document.getElementById(newInput.name).value,',');ofind++){
						var row_number_ = list_getat(document.getElementById(newInput.id).value,ofind,',');
						if(document.getElementById('total_min'+row_number_))document.getElementById('total_min'+row_number_).value = is_value_1_object.value;
					}
				}
			}
			is_value_2_object.onchange = function (){
				if(document.getElementById(newInput.id)){
					for(ofind=2;ofind<=list_len(document.getElementById(newInput.name).value,',');ofind++){
						var row_number_ = list_getat(document.getElementById(newInput.id).value,ofind,',');
						if(document.getElementById('total_max'+row_number_))document.getElementById('total_max'+row_number_).value = is_value_2_object.value;
					}
				}
			}
			
			
			tolerance_object.onchange = function (){
				if(document.getElementById(newInput.id)){
					for(ofind=2;ofind<=list_len(document.getElementById(newInput.name).value,',');ofind++){
						var row_number_ = list_getat(document.getElementById(newInput.id).value,ofind,',');
						if(document.getElementById('tolerance'+row_number_))document.getElementById('tolerance'+row_number_).value = tolerance_object.value;
					}
				}
			}
			
			
			dimension_object.onchange = function (){
				if(document.getElementById(newInput.id)){
					for(ofind=2;ofind<=list_len(document.getElementById(newInput.name).value,',');ofind++){
						var row_number_ = list_getat(document.getElementById(newInput.id).value,ofind,',');
						if(document.getElementById('dimension_'+row_number_))document.getElementById('dimension_'+row_number_).value = dimension_object.value;
					}
				}
			}
			
			
			
		}	
		hesapla_product_conf();
	//}	
	onchangeFields='0';	
}
</script> --->
<cfscript>
color1="black";color2="red";color3="brown";
color4="orange";color5="pink";color6="purple";
color7="blue";color8="darkblue";color9="gray";
color10="silver";color11="silver";color12="silver";
sayac=0;
deep_level=0;
function get_subs(conf_variation_id){
queryStr = 'SELECT CONFIGURATOR_VARIATION_ID FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE RELATION_CONFIGURATOR_VARIATION_ID=#conf_variation_id#';
queryResult = cfquery(SQLString : queryStr, Datasource : dsn3);
variation_id_list =ValueList(queryResult.CONFIGURATOR_VARIATION_ID,',');
return variation_id_list;
}
function getConfTree(conf_variation_id)
{
	var i = 1;
	var sub_variation = get_subs(conf_variation_id);
	deep_level = deep_level + 1;
	for (i=1; i lte listlen(sub_variation,','); i = i+1){
		new_variation_id = ListGetAt(sub_variation,i,',');
		writeTree(new_variation_id);
		getConfTree(new_variation_id);
	}
	deep_level = deep_level-1;
}
//getConfTree(rel_conf_CONFIGURATOR_VARIATION_ID);//fonksiyon burada çağırılıyor  	
</cfscript>
<cffunction name="writeTree" returntype="any">
<cfargument default="" name="variation_id" type="numeric">
<cfquery name="variationQueryResult" datasource="#dsn3#">
	SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE CONFIGURATOR_VARIATION_ID=#variation_id#
</cfquery>
<cfset product_compenent_id = variationQueryResult.PRODUCT_COMPENENT_ID>
<cfset product_chapter_id = variationQueryResult.PRODUCT_CHAPTER_ID>
<cfset var_property_detail_id =variationQueryResult.VARIATION_PROPERTY_DETAIL_ID>
<cfset rel_var_prod_amount = variationQueryResult.VARIATION_PRODUCTS_AMOUNT>
<cfset leftSpace = RepeatString('&nbsp;', deep_level*5)>
<cfparam name="__REL_STOCK_ID_" default="0"><cfif len(variationQueryResult.VARIATION_PRODUCTS)><cfset __REL_STOCK_ID_ = listdeleteduplicates(variationQueryResult.VARIATION_PRODUCTS)></cfif>
<cfset sayac=sayac+1>
	<cfoutput>
	<tr id="tree_var_#sayac#" class="color-row">
		<td>
			<div style="background:#Evaluate("color#deep_level#")#;position:absolute;width:15;bgcolor:red;margin-left:#(deep_level*15)-15#;color:white;">&nbsp;#deep_level#</div>
			#leftSpace#
			<input type="hidden" name="tree_configurator_variation_id_#sayac#" id="tree_configurator_variation_id_#sayac#" value="#variation_id#">
            <input type="checkbox" 
            onClick="add_product_basket(this,0);" 
            name="rel-property_detail_#product_chapter_id#_#product_compenent_id#" id="rel-property_detail_#product_chapter_id#_#product_compenent_id#"
            value="#var_property_detail_id#-#__REL_STOCK_ID_#-#rel_var_prod_amount#-#variation_id#-#variationQueryResult.RELATION_CONFIGURATOR_VARIATION_ID#"
            <cfif rel_variation_currentrow eq 1></cfif>>
		</td>
		<!---<td nowrap>#getVarCusTag(row_number:sayac,property_detail_id:variationQueryResult.VARIATION_PROPERTY_DETAIL_ID)#</td>
		 <td>
			<select name="tree_var_type_#sayac#" style="width:40px;">
				<option value="1" <cfif variationQueryResult.VARIATION_TYPE eq 1>selected</cfif>>Var</option>
				<option value="0" <cfif variationQueryResult.VARIATION_TYPE eq 0>selected</cfif>>Yok</option>
			</select>
		</td>
		<td>
			<select name="tree_var_is_value_1_#sayac#" style="width:40px;">
				<option value="1"<cfif variationQueryResult.VARIATON_IS_VALUE_1 eq 1>selected</cfif>>Var</option>
				<option value="0"<cfif variationQueryResult.VARIATON_IS_VALUE_1 eq 0>selected</cfif>>Yok</option>
			</select>
		</td>
		<td>
			<select name="tree_var_is_value_2_#sayac#"  style="width:40px;">
				<option value="1"<cfif variationQueryResult.VARIATON_IS_VALUE_2 eq 1>selected</cfif>>Var</option>
				<option value="0"<cfif variationQueryResult.VARIATON_IS_VALUE_2 eq 0>selected</cfif>>Yok</option>
			</select>
		</td>
		<td>
			<select name="tree_var_is_tolerance_#sayac#" style="width:50px;">
				<option value="1"<cfif variationQueryResult.VARIATON_IS_TOLERANCE eq 1>selected</cfif>>Var</option>
				<option value="0"<cfif variationQueryResult.VARIATON_IS_TOLERANCE eq 0>selected</cfif>>Yok</option>
			</select>
		</td>
		<td>
			<select name="tree_var_is_unit_#sayac#"  style="width:50px;">
				<option value="1"<cfif variationQueryResult.VARIATON_IS_UNIT eq 1>selected</cfif>>Var</option>
				<option value="0"<cfif variationQueryResult.VARIATON_IS_UNIT eq 0>selected</cfif>>Yok</option>
			</select>
		</td>
		<td><input type="text" name="tree_var_property_detail_#sayac#"   style="width:100px;" maxlength="200" value="#variationQueryResult.VARIATON_PROPERTY_DETAIL#"></td>
		<td>
			<select name="tree_var_max_amount_#sayac#">
				<option value="0"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 0>selected</cfif>>0</option>
				<option value="1"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 1>selected</cfif>>1</option>
				<option value="2"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 2>selected</cfif>>2</option>
				<option value="3"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 3>selected</cfif>>3</option>
				<option value="4"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 4>selected</cfif>>4</option>
				<option value="5"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 5>selected</cfif>>5</option>
			</select>
	   </td>
	    <td><textarea name="tree_var_product_scrpt_#sayac#" style="width:140;height:20;">#variationQueryResult.VARIATION_SCRIPT#</textarea></td>
	    <td><input type="button" value="Güncelle" onClick="UpdVar(#sayac#);"><img  style="cursor:pointer;" src="images/add_ico.gif" border="0" onClick="gizle_goster(add_var_rel_#sayac#);" align="top"></td> --->
	</tr>
    </cfoutput>
</cffunction>
<div id="main_div" style="display:none;"></div>
<cfform  name="add_spect_product_conf" action="#request.self#?fuseaction=objects.emptypopup_add_spect_product_conf" method="post" enctype="multipart/form-data">
<table cellpadding="2" cellspacing="1" border="0">
<tr>
	<td>
    	<table>
            <!--- <tr height="25" class="headbold">
                <td>
                    <cfoutput>
                    <input type="hidden" name="record_count" value="0">
                    Özellikler/Varyasyonlar/İhtiyaçlar - <font color="red">#left(GET_PRODUCT.PRODUCT_NAME,10)#</font>
                    <input type="hidden" name="product_name" value="#GET_PRODUCT.PRODUCT_NAME#">
                    <input type="hidden" name="PRODUCT_CONFIGURATOR_ID" value="#get_product_conf.PRODUCT_CONFIGURATOR_ID#">
                    </cfoutput>
                </td>
            </tr> --->
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
                    <tr>
                        <td>	
							<cfoutput><input type="hidden" name="chapter_count" id="chapter_count" value="#get_conf_chapters.recordcount#"></cfoutput>
                            <cfset row_count_2 = 0>
                            <cfset row_count_3 = 0>
                            <cfset row_count_4 = 0>
                            <table cellpadding="2" cellspacing="1" width="100%" height="98%" class="color-border">
                                <cfoutput query="get_conf_chapters">
                                    <cfset chapter_currentrow = CURRENTROW>
                                    <cfset _configurator_chapter_id_ = CONFIGURATOR_CHAPTER_ID>
                                    <tr id="compenent_header_frm_row#currentrow#" class="color-list">
                                        <td colspan="6" valign="top">
                                            <table id="table2_#currentrow#" cellpadding="2" cellspacing="1" width="100%" border="0" class="color-border">
                                                <cfquery name="get_conf_compenents_query" dbtype="query">
                                                    SELECT * FROM get_conf_compenents WHERE CONFIGURATOR_CHAPTER_ID = #CONFIGURATOR_CHAPTER_ID# ORDER BY ORDER_NO
                                                </cfquery>
                                                <cfif get_conf_compenents_query.recordcount>
                                                    <cfloop query="get_conf_compenents_query">
                                                        <cfset _input_type_ = TYPE>
                                                        <cfset row_count_2 = row_count_2+1>
                                                        <tr class="color-list" id="compenent_row_frm_row#row_count_2#" onClick="gizle_goster(variations_#row_count_2#)" valign="top">
                                                            <td valign="top" class="txtboldblue">
                                                                <cfif len(property_id)>
                                                                    <cfquery name="get_property_name" datasource="#dsn1#">
                                                                        SELECT PROPERTY FROM PRODUCT_PROPERTY WHERE PROPERTY_ID =#property_id#
                                                                    </cfquery>
                                                                    <cfset property_name =  get_property_name.PROPERTY>  
                                                                <cfelse>
                                                                    <cfset property_name =  ''>    
                                                                </cfif>
                                                                <abbr title="Özellik Adı">#property_name#</abbr>
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
                                                                    <input type="text" title="Ek Bilgi"	name="comp_information" id="comp_information" value="">
                                                                <cfelseif IS_INFORMATION eq 0>
                                                                    <textarea title="Ek Bilgi"	 name="comp_information" id="comp_information" style="width:150;height:20;"></textarea>
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
                                                           </td>
                                                        </tr>
                                                            <cfquery name="get_conf_variations_query" dbtype="query">
                                                                SELECT * FROM get_conf_variations WHERE PRODUCT_CHAPTER_ID = #CONFIGURATOR_CHAPTER_ID# AND PRODUCT_COMPENENT_ID = #PRODUCT_CONFIGURATOR_COMPENENTS_ID# AND RELATION_CONFIGURATOR_VARIATION_ID IS NULL ORDER BY VARIATION_ORDER_NO
                                                            </cfquery>
                                                            <cfquery name="get_conf_variations_query_relation" dbtype="query">
                                                                SELECT * FROM get_conf_variations WHERE PRODUCT_CHAPTER_ID = #CONFIGURATOR_CHAPTER_ID# AND PRODUCT_COMPENENT_ID = #PRODUCT_CONFIGURATOR_COMPENENTS_ID# AND RELATION_CONFIGURATOR_VARIATION_ID IS NOT NULL ORDER BY VARIATION_ORDER_NO
                                                            </cfquery>
                                                        <tr class="color-row" id="variations_#row_count_2#" style="display:none;">
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
                                                                            <tr class="color-row" id="variation_row_frm_row_#row_count_3#">
                                                                                 
                                                                                    <td>
                                                                                      <input type="checkbox" <cfif _input_type_ eq 1 >style="background-color:CCCCCC;border:groove 1px;"</cfif> 
                                                                                        onClick="add_product_basket(this,<cfif _input_type_ eq 1 >1<cfelse>0</cfif>);"
                                                                                        name="property_detail_#_configurator_chapter_id_#_#_confgiuretor_compenent_id_#" id="property_detail_#_configurator_chapter_id_#_#_confgiuretor_compenent_id_#"
                                                                                        value="#VARIATION_PROPERTY_DETAIL_ID#-#_STOCK_ID_#-#VARIATION_PRODUCTS_AMOUNT#-#_configurator_variation_id_#" <cfif variation_currentrow eq 1></cfif>>
                                                                                       #left(PROPERTY_DETAIL,50)#..
                                                                                    &nbsp;&nbsp;
                                                                                    <input type="text" title="Varyasyon Değer 1" onKeyPress="add_to_basket_property(this);" name="VARIATON_IS_VALUE_1_#VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_VALUE_1_#VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_VALUE_1 eq 0>display:none;</cfif>">
                                                                                    &nbsp;&nbsp;
                                                                                    <input type="text" title="Varyasyon Değer 2" name="VARIATON_IS_VALUE_2_#VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_VALUE_2_#VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_VALUE_2 eq 0>display:none;</cfif>">
                                                                                    &nbsp;&nbsp;
                                                                                    <input type="text" title="Varyasyon Tolerans" name="VARIATON_IS_TOLERANCE_#VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_TOLERANCE_#VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_TOLERANCE eq 0>display:none;</cfif>">
                                                                                    &nbsp;&nbsp;
                                                                                    <input type="text" title="Varyasyon Ölçü" name="VARIATON_IS_DIMENSION_#VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_DIMENSION_#VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_UNIT eq 0>display:none;</cfif>">
                                                                                    &nbsp;&nbsp;
                                                                                    #VARIATON_PROPERTY_DETAIL#
                                                                                    <!---  <script type="text/javascript">
                                                                                        function add_to_basket_property(pro_obj){
                                                                                            var property_detail_id___ = list_getat(pro_obj.name,5,'_');
                                                                                            alert(property_detail_id___);
                                                                                            //row_count++;
                                                                                            
                                                                                        }
                                                                                    </script> --->
                                                                                     <cfset product_names_var =''>
                                                                                     <cfif len(VARIATION_PRODUCTS)>
                                                                                        <cfquery name="get_products_name_var" datasource="#dsn3#">
                                                                                            SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#VARIATION_PRODUCTS#)
                                                                                        </cfquery>
                                                                                        <cfif get_products_name_var.recordcount>
                                                                                            <cfset product_names_var = ValueList(get_products_name_var.PRODUCT_NAME,'<br/>')>
                                                                                        </cfif>
                                                                                    </cfif>
                                                                                    &nbsp;&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <tr id="relation_variations_#row_count_3#" class="color-list">
                                                                                <td colspan="13">
                                                                                    <table id="table4_#row_count_3#" cellpadding="2" cellspacing="1" class="color-header" style="margin-left:20;">
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
                                                                                                        
                                                                                                       <input type="checkbox"
                                                                                                        onClick="add_product_basket(this,0);" 
                                                                                                        name="rel-property_detail_#_configurator_chapter_id_#_#_confgiuretor_compenent_id_#" id="rel-property_detail_#_configurator_chapter_id_#_#_confgiuretor_compenent_id_#"
                                                                                                        value="#RELATION_VARIATION_PROPERTY_DETAIL_ID#-#REL_STOCK_ID_#-#RELATION_VARIATION_PRODUCTS_AMOUNT#-#rel_conf_CONFIGURATOR_VARIATION_ID#-#_configurator_variation_id_#"
                                                                                                        <cfif rel_variation_currentrow eq 1></cfif>>
                                                                                                        #left(REL_PROPERTY_DETAIL,50)#..
                                                                                                                        
                                                                                                        &nbsp;&nbsp;
                                                                                                        <input type="text" title="İlişkili Varyasyon Değer 1" name="VARIATON_IS_VALUE_1_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_VALUE_1_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_VALUE_1 eq 0>display:none;</cfif>">
                                                                                                        &nbsp;&nbsp;
                                                                                                        <input type="text" title="İlişkili Varyasyon Değer 2" name="VARIATON_IS_VALUE_2_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_VALUE_2_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_VALUE_2 eq 0>display:none;</cfif>">
                                                                                                        &nbsp;&nbsp;
                                                                                                        <input type="text" title="İlişkili Varyasyon Tolerans" name="VARIATON_IS_TOLERANCE_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_TOLERANCE_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_TOLERANCE eq 0>display:none;</cfif>">
                                                                                                        &nbsp;&nbsp;
                                                                                                        <input type="text" title="İlişkili Varyasyon Ölçü" name="VARIATON_IS_DIMENSION_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" id="VARIATON_IS_DIMENSION_#RELATION_VARIATION_PROPERTY_DETAIL_ID#" value="" style="width:45px;<cfif VARIATON_IS_UNIT eq 0>display:none;</cfif>">
                                                                                                        &nbsp;&nbsp;
                                                                                                        #VARIATON_PROPERTY_DETAIL#
                                                                                                   </td>
                                                                                                </tr>
                                                                                                <cfscript>
                                                                                                getConfTree(rel_conf_CONFIGURATOR_VARIATION_ID);
                                                                                                </cfscript>
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
                                </cfoutput>
                            </table>    
                         </td>
                    </tr>           
                <cfelse>
                    Konfigürasyona Ait Bölüm Bulunamadı!
                </cfif>
            <cfelse>
                Ürüne Ait Konfigürasyon Kaydı Bulunamadı!
            </cfif>
        </table>
    </td>
    <!--- <td valign="top"<cfif x_is_show_product_basket eq 0>style="display:none;"</cfif>>
    	<cfif get_product_conf.recordcount>
            <table id="_product_basket_"  style="margin-top:29px;" name="_product_basket_" cellpadding="2" cellspacing="1" width="%99" class="color-border" style=" overflow:scroll; margin-top:21">
                <tr class="color-header">
                    <td colspan="6" class="form-title">Ürün Ağaç Bileşenleri</td>
                </tr>
                 <tr class="color-list" id="header_tr_row"  name="header_tr_row" >
                    <td class="txtboldblue">Ürün</td>
                    <td class="txtboldblue">Br. Fiyat</td>
                    <td class="txtboldblue">Miktar</td>
                    <td class="txtboldblue">Toplam Fiyat</td>
                    <td class="txtboldblue">Maliyet</td>
                    <td class="txtboldblue">Para Br.</td>
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
                    <input type="hidden" name="main_product_money" value="#main_product_money#">
                    <input type="hidden" name="main_prod_price" value="#main_product_price#">
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
                <input type="hidden" name="rd_money_num" value="#get_money.recordcount#">
                <cfloop query="get_money">
                <tr class="color-list" style="display:none;visibility:hidden;">
                <td>
                    <input type="hidden" name="urun_para_birimi#money#" value="#rate2/rate1#">
                    <input type="hidden" name="rd_money_name_#currentrow#" value="#money#">
                    <input type="hidden" name="txt_rate1_#currentrow#" value="#rate1#">
                    <input type="radio" name="rd_money" value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money2>checked</cfif>>#money#
                    #TLFormat(rate1,4)#/
                    <input type="text" name="txt_rate2_#currentrow#" value="#TLFormat(rate2,4)#" style="width:50px;" class="box" onkeyup="return(FormatCurrency(this,event,4));">
                </td>
                </tr>
                </cfloop>
                </cfoutput>
                <cfset sayac = 0>
                <cfoutput query="GET_PRODUCT_TREE">
                    <tr class="color-row">
                        <td>#PRODUCT_NAME#</td>
                        <td style="text-align:right;">
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
                        <td style="text-align:right;">#tlformat(AMOUNT,3)#</td>
                        <td style="text-align:right;">
                            <cfif isdefined('product_price_#STOCK_ID#')>
                                <cfset tree_system_money = tree_system_money+((Evaluate('product_price_#STOCK_ID#')*AMOUNT)/Evaluate('product_money_rate_#STOCK_ID#'))>
                                <cfset total_price_ = tlformat(Evaluate('product_price_#STOCK_ID#')*AMOUNT,3)>
                            </cfif>
                            #total_price_#  
                        </td>
                        <td style="text-align:right;">
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
                        <input type="hidden" name="stock_id_#currentrow#" value="#STOCK_ID#">
                        <input type="hidden" name="product_id_#currentrow#" value="#PRODUCT_ID#">
                        <input type="hidden" name="product_name_#currentrow#" value="#PRODUCT_NAME#" style="width:180px">
                        <input type="hidden" name="product_price_#currentrow#" value="#price_#" class="moneybox" style="width:80px">
                        <input type="hidden" name="product_amount_#currentrow#" value="#tlformat(AMOUNT,3)#" style="width:80px">
                        <input type="hidden" name="product_total_price_#currentrow#" value="#total_price_#" style="width:80px">
                        <input type="hidden" name="product_cost_#currentrow#" value="#cost_#" style="width:80px">
                        <input type="hidden" name="product_money_#currentrow#" value="#rate1#,#rate2#,#money_#">
                        <cfset sayac = sayac +1>
                    </tr>
                </cfoutput>
                </cfif>
                <tr class="color-header">
                    <td colspan="6" class="form-title">Ürün Basket</td>
                </tr>
               <!---  <tr>
                    <td><input type="text" name="product_name_#compenent_id#_#variation_currentrow#" value="#product_names_var#" style="width:80px"></td>
                    <td><input type="text" name="product_price_#compenent_id#_#variation_currentrow#" value="" style="width:80px"></td>
                    <td><input type="text" name="product_amount_#compenent_id#_#variation_currentrow#" value="#VARIATION_PRODUCTS_AMOUNT#" style="width:80px"></td>
                    <td><input type="text" name="product_total_price_#compenent_id#_#variation_currentrow#" value="" style="width:80px"></td>
                    <td><input type="text" name="product_cost_#compenent_id#_#variation_currentrow#" value="" style="width:80px"></td>
                    <td>
                        <select name="product_money_#compenent_id#_#variation_currentrow#" style="width:65px">
                            <cfloop query="get_money"><option value="#rate1#,#rate2#,#money#">#money#</option></cfloop>
                        </select>
                    </td>
                </tr> --->
            </table>
            <table cellpadding="2" width="100%" cellspacing="1" class="color-border" style="margin-top:2">
                <tr class="color-header">
                    <td colspan="5"  style="text-align:right;">
                    <table>
                        <tr>
                            <cfoutput>
                            <td class="txtbold">Toplam</td>
                            <td><input type="text" name="system_money_total_value" class="box" value="" style="width:80px;"> #session.ep.money#</td>
                            <td><input type="text" name="other_money_total_value" class="box" value="" style="width:80px;"> #main_product_money#</td>
                            </cfoutput>
                        </tr>
                        
                    </table>
                    </td>
                </tr>
            </table>
        </cfif>
    </td> --->
</tr>
</table>
</cfform>
