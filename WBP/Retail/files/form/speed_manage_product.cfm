<cfsetting showdebugoutput="no">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.2.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/jquery.dragtable.js"></script>
<script type="text/javascript" src="/js/speed_manage_product.js"></script>
<link rel="stylesheet" href="/css/dragtable-default.css" type="text/css" />
<style>
	#manage_table{margin:10px;}
	
	#manage_table
	{
	border-spacing: 1px;
    border-collapse: separate;		
	}
	
	#manage_table tr td
	{
    padding: 2px;
	}
	
	#manage_table tr td input
	{
	border:0px none #f1f0ff;
	border-width:0px;
	border-bottom-width:0px;
	background-color:transparent;
	color:#000;
	font-size:10px;
	font-family:Verdana, Geneva, sans-serif;
	font-weight:500;
	}
	
	#manage_table tr td select
	{
	border:0px none #f1f0ff;
	border-width:0px;
	border-bottom-width:0px;
	background-color:transparent;
	color:#000;
	font-size:10px;
	font-family:Verdana, Geneva, sans-serif;
	font-weight:500;
	}
	
	<cfif browserdetect() contains 'chrome'>
		#manage_table tr td input[type="checkbox"]
		{
		height:12px !important;
		width:12px !important;
		}
	<cfelse>
		#manage_table tr td input[type="checkbox"]
		{
		height:12px !important;
		width:12px !important;
		}
	</cfif>
	
	#manage_table tr td
	{
	border:0px none #f1f0ff;
	border-width:0px;
	border-bottom-width:0px;
	background-color:transparent;
	color:#060;
	font-size:10px;
	font-family:Verdana, Geneva, sans-serif;
	font-weight:500;
	}

<cfif not isdefined("attributes.print_action")>	
	.color-list{background-color:#EAFBFD;}
	.color-green{background-color:#F7F9A2;}
<cfelse>
	.color-list{background-color:#ffffff;}
	.color-green{background-color:#ffffff;}
</cfif>

	.color-light{background-color:#ADFF2F;}
	
	#manage_table tr td.alis_back{background-color:#F9F0D0;}
	#manage_table tr td.satis_back{background-color:#EAD899;}
	#manage_table tr td.ssatis_back{background-color:#CFF;}
	#manage_table tr td.ssatis_back_active{background-color:#F08080;}
	#manage_table tr td.ealis_back{background-color:#ECEA84;}
	#manage_table tr td.ealis_back_active{background-color:#808000;}
	#manage_table tr td.sinfo_back{background-color:#BFBFBF;}
	#manage_table tr td.sip1_back{background-color:#E6F8BA;}
	#manage_table tr td.sip2_back{background-color:#F8EEB1;}
	#manage_table tr td.magaza_stock_back{background-color:#adff2f;}
	#manage_table tr td.depo_stock_back{background-color:#8FBC8f;}
	#manage_table tr td.genel_stock_back{background-color:#da0520;}
	#manage_table tr td.list_oran_back{background-color:#000000;}
</style>
<cfajaximport tags="cfwindow">
<cfquery name="get_order_date" datasource="#dsn_dev#">
	SELECT ORDER_DAY FROM SEARCH_TABLES_DEFINES
</cfquery>
<cfset order_control_day = -1 * get_order_date.ORDER_DAY>
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cf_xml_page_edit default_value="0" fuseact="product.list_product">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.price_catid" default="#genel_fiyat_listesi#">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.cat_id" default="">
<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.product_stages" default="">
<cfparam name="attributes.list_variation_id" default="">
<cfparam name="attributes.list_property_value" default="">
<cfparam name="attributes.list_property_id" default="">
<cfparam name="attributes.search_list_id" default="">
<cfparam name="attributes.table_code" default="">
<cfparam name="attributes.koli_type" default="2">
<cfparam name="attributes.layout_id" default="">
<cfparam name="attributes.tedarikci_kodu" default="">
<cfparam name="attributes.order_day" default="15">
<cfparam name="attributes.order2_day" default="15">
<cfparam name="attributes.bakiye_day" default="15">
<cfparam name="attributes.calc_type" default="0">
<cfparam name="attributes.add_stock_gun" default="15">

<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfparam name="attributes.table_secret_code" default="#wrk_id#">

<cfif not isdefined("attributes.is_real_form_submitted")>
	<cfset attributes.is_hide_one_stocks = 1>
</cfif>
<cfparam name="attributes.is_form_submitted" default="1">


<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("d",-90,now())>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = dateadd("d",-1,now())>
</cfif>

<cfinclude template="coloum_positions.cfm">


<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>



<cfif isdefined("attributes.table_code") and len(attributes.table_code)>
<cfif len(attributes.table_code) lt 8>
	<cfloop from="1" to="#8 - len(attributes.table_code)#" index="ccm">
    	<cfset attributes.table_code = "0#attributes.table_code#">
    </cfloop>
</cfif>

    <cfquery name="get_table" datasource="#dsn_dev#" result="get_table_result">
    	SELECT
        	TABLE_SECRET_CODE,
        	TABLE_INFO,
            TABLE_ID
        FROM
        	SEARCH_TABLES
        WHERE
        	TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    
	<cfif get_table.recordcount>
    	<cfset attributes.table_info = get_table.TABLE_INFO>
        <cfset attributes.table_id = get_table.TABLE_ID>
        <cfset attributes.table_secret_code = get_table.TABLE_SECRET_CODE>
        <cfquery name="get_table_info_sql" datasource="#dsn_dev#" result="get_table_row_result2">
            SELECT
                *
            FROM
                SEARCH_TABLES_ROWS
            WHERE
                TABLE_ID = #attributes.table_id#
        </cfquery>
        <cfoutput query="get_table_info_sql">
            <cfset 'get_table_info.#att_name#' = "#att_value#">
        </cfoutput>
        
        <cfquery name="get_table_depts" datasource="#dsn_dev#" result="get_table_result3">
            SELECT
                DEPARTMENT_ID
            FROM
                SEARCH_TABLES_DEPARTMENTS
            WHERE
                TABLE_ID = #attributes.table_id#
        </cfquery>
        <cfif get_table_depts.recordcount and not isdefined("attributes.search_department_id")>
            <cfset attributes.search_department_id = merkez_depo_id>
        </cfif>
    <cfelse>
    	<cfset attributes.table_info = ''>
    </cfif>
<cfelse>
	<cfset attributes.table_info = ''>
</cfif>

<cfif not isdefined("attributes.search_department_id")>
	<cfset attributes.search_department_id = merkez_depo_id>
</cfif>

<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
	<cfquery name="get_dept" datasource="#dsn3#">
    	SELECT DELIVER_DEPT_ID FROM ORDERS WHERE ORDER_ID = #attributes.order_id#
    </cfquery>
    <cfset attributes.search_department_id = get_dept.DELIVER_DEPT_ID>
</cfif>
 <cfquery name="get_my_branches" datasource="#dsn#">
        SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
    </cfquery>
    <cfif get_my_branches.recordcount>
        <cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
    <cfelse>
        <cfset my_branch_list = '0'>
    </cfif>
<cfquery name="get_search_layouts" datasource="#dsn_dev#">
SELECT
    LAYOUT_ID,
    LAYOUT_NAME
FROM
    SEARCH_TABLES_LAYOUTS
ORDER BY
   	LAYOUT_NAME
</cfquery>

<cfset get_product.recordcount=0>
<cfset get_product.query_count=0>

<cfparam name="attributes.totalrecords" default='#get_product.query_count#'>

<cfquery name="get_price_types" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        PRICE_TYPES
    ORDER BY
    	IS_STANDART DESC,
    	TYPE_ID ASC
</cfquery>
 
<script>
<cfoutput query="get_price_types">j_price_type_#TYPE_ID# = '#TYPE_code# - #TYPE_NAME#';</cfoutput>
</script>
<cfoutput query="get_price_types">
	<cfset 'j_price_type_#TYPE_ID#' = '#TYPE_code# - #TYPE_NAME#'>
</cfoutput>
<cfsavecontent variable="header_">Ürün ve Fiyat Yönetimi</cfsavecontent>
<table width="100%">
<tr>
<td style="text-align:left; height:50px;">
    <table class="color-header" style="margin-left:10px;">
        <tr>
            <td class="headbold" width="250"><cfoutput>#header_#</cfoutput></td>
            <td>
    <cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
        <input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
        <input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
        <input type="hidden" name="list_property_value" id="list_property_value" value="<cfif isdefined("attributes.list_property_value")><cfoutput>#attributes.list_property_value#</cfoutput></cfif>">
        <input type="hidden" name="page_hide_col_list" id="page_hide_col_list" value="<cfoutput>#hide_col_list_numeric#</cfoutput>">
        <input type="hidden" name="page_col_sort_list" id="page_col_sort_list" value="<cfoutput>#page_col_sort_list#</cfoutput>">
        <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
        <input name="is_real_form_submitted" id="is_real_form_submitted" type="hidden" value="1">
        <input type="hidden" name="order_id" id="order_id" value="<cfif isdefined("attributes.order_id")><cfoutput>#attributes.order_id#</cfoutput></cfif>"/>
        <input name="search_selected_product_list" id="search_selected_product_list" type="hidden" value="">
    <cfparam name="attributes.mode" default="7">
                <table>
                    <tr>
                        <td>Tablo No</td>
                        <td><cfinput type="text" name="table_code" id="table_code" style="width:90px;" value="#attributes.table_code#" maxlength="500"></td>
                        <td>Filtre</td>
                        <td><cfinput type="text" name="keyword" id="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="50"></td>
                        <td>
                            <cf_multiselect_check 
                                query_name="get_departments_search"  
                                name="search_department_id"
                                option_text="Departman" 
                                width="180"
                                option_name="department_head" 
                                option_value="department_id"
                                value="#attributes.search_department_id#">
                        </td>
                        <td>
                            <select name="layout_id" id="layout_id" onchange="get_new_layout();">
                                <option value="">Görünüm</option>
                                <cfoutput query="get_search_layouts">
                                    <option value="#layout_id#" <cfif attributes.layout_id eq layout_id>selected</cfif>>#layout_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td><input type="checkbox" name="is_hide_one_stocks" value="1" <cfif isdefined("attributes.is_hide_one_stocks")>checked</cfif>/> Tekli Stokları Gösterme</td>
                        <td><input type="checkbox" name="is_only_related_areas" value="1" <cfif isdefined("attributes.is_only_related_areas")>checked</cfif>/> Sadece İlgili Kolonlar</td>
                        <td>
                            <select name="calc_type" id="calc_type" onchange="get_calc_type();">
                                <option value="0" <cfif attributes.calc_type eq 0>selected</cfif>>Hesaplama Yapma</option>
                                <option value="1" <cfif attributes.calc_type eq 1>selected</cfif>>Satış Hızına Göre</option>
                                <option value="2" <cfif attributes.calc_type eq 2>selected</cfif>>Max Mine Göre</option>
                                <option value="3" <cfif attributes.calc_type eq 3>selected</cfif>>Seçililerle Çalış</option>
                            </select>
                        </td>
                        <td><cf_wrk_search_button search_function='input_control()' is_excel="0"></td>
                        <cfif isdefined("attributes.is_form_submitted")>
                            <td><a onClick="show_hide('kolon_menu');" href="javascript://"><img src="../images/label.gif" title="Kolon Düzenle"></a></td>
                        </cfif>
                    </tr>
                </table>
                <table style="<cfif attributes.calc_type eq 1>display:block;<cfelse>display:none;</cfif>" id="calc_table_1">
                    <tr>
                        <td class="formbold">Satış Hızına Göre</td>
                        <td>Koli Yuvarlama</td>
                        <td>
                            <select name="koli_type" id="koli_type">
                                <option value="0" <cfif attributes.koli_type eq 0>selected</cfif>>Aşağı</option>
                                <option value="1" <cfif attributes.koli_type eq 1>selected</cfif>>Yukarı</option>
                                <option value="2" <cfif attributes.koli_type eq 2>selected</cfif>>Sabit</option>
                            </select>
                        </td>
                        <td nowrap>
                            <cfinput type="text" name="search_startdate" maxlength="10" value="#dateformat(attributes.search_startdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                            <cf_wrk_date_image date_field="search_startdate">
                        </td>
                        <td nowrap>
                            <cfinput type="text" name="search_finishdate" maxlength="10" value="#dateformat(attributes.search_finishdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                            <cf_wrk_date_image date_field="search_finishdate">
                        </td>
                        <td>Sipariş Günü</td>
                        <td><cfinput type="text" name="order_day" id="order_day" style="width:30px;" value="#attributes.order_day#" maxlength="3"></td>
                        <td>2. Sipariş Günü</td>
                        <td><cfinput type="text" name="order2_day" id="order2_day" style="width:30px;" value="#attributes.order2_day#" maxlength="3"></td>
                        <td>Bakiye Sipariş Hesabı</td>
                        <td><cfinput type="text" name="bakiye_day" id="bakiye_day" style="width:30px;" value="#attributes.bakiye_day#" maxlength="3"></td>
                        <td>
                            <input type="checkbox" value="1" name="real_stock" id="real_stock" <cfif isdefined("attributes.real_stock")>checked</cfif>/> Eldeki Stoğu Hesaba Kat
                            <input type="checkbox" value="1" name="way_stock" id="way_stock" <cfif isdefined("attributes.way_stock")>checked</cfif>/> Yoldaki Stoğu Hesaba Kat
                        </td>
                    </tr>
                </table>
    </cfform>
            </td>
        </tr>
    </table>
</td>
</tr>
</table>
<script>
function input_control()
{
	<cfif isdefined("attributes.table_code") and len(attributes.table_code)>
		if(confirm('Eğer Tablonuzu Kayıt Etmediyseniz Yaptığınız Değişiklikleri Kaybedeceksiniz! Emin misiniz?'))
		{
			//nothing
		}
		else 
		{
			return false;
		}
	</cfif>
	if(document.search_product.calc_type.value == '1' || document.search_product.calc_type.value == '3')
	{
		liste_ = document.getElementById('all_product_list').value;
		eleman_sayisi = list_len(document.getElementById('all_product_list').value);
		selected_ = '';
		for (var ccm=1; ccm <= eleman_sayisi; ccm++)
		{
			c_row_product = list_getat(liste_,ccm);
			if(document.getElementById('is_selected_' + c_row_product).checked == true)
			{
				if(selected_ == '')
					selected_ = c_row_product;
				else
					selected_ += ',' + c_row_product;
			}
		}
		document.getElementById('selected_product_list').value = selected_;
		
		if(document.getElementById('selected_product_list').value == '')
		{
			alert('Sipariş Hesaplamak İstediğiniz Satırları Seçiniz!');
			return false;
		}
		else
			document.getElementById('search_selected_product_list').value = document.getElementById('selected_product_list').value;
	}	
	return true;
}

document.getElementById('keyword').select();
</script>
<cfif isdefined("attributes.is_form_submitted")>
<cfquery name="get_departments" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
        <cfif len(attributes.search_department_id)>
        	AND D.DEPARTMENT_ID IN (#attributes.search_department_id#)
        </cfif>
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfinclude template="../query/get_products.cfm">

<cfquery name="get_stocks_only" dbtype="query">
	SELECT DISTINCT STOCK_ID FROM get_products ORDER BY PRODUCT_NAME
</cfquery>

<table width="99%" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td valign="top" id="kolon_menu" style="display:none; width:150px;">
        <cfinclude template="left_menu.cfm">
    </td>
    <td valign="top">
<cfform name="info_form" method="post" action="">
<cfinput type="hidden" name="department_id_list" id="department_id_list" value="#attributes.search_department_id#"/>
<cfinput type="hidden" name="layout_id" id="layout_id" value="#attributes.layout_id#"/>
<input type="hidden" name="order_id" id="order_id" value="<cfif isdefined("attributes.order_id")><cfoutput>#attributes.order_id#</cfoutput></cfif>"/>
<input type="hidden" name="ilk_kez_fiyat_at" id="ilk_kez_fiyat_at" value="1"/>
<cfset dept_count_ = listlen(listdeleteduplicates(valuelist(get_departments.department_id)))>
<!--- genel kayit alanlari --->
<cf_box style="width:1500px; margin-left:10px;">
<table>
    <tr>
        <td>Tablo Kodu</td>
        <td>
        	<cfif isdefined("get_table_info.is_purchase_type")>
				<cfset is_purchase_type = get_table_info.is_purchase_type>
            <cfelse>
                <cfset is_purchase_type = 0>
            </cfif>
        	<cfinput type="hidden" name="is_purchase_type" id="is_purchase_type" value="#is_purchase_type#" readonly="yes" style="width:60px;"/>
            
            <cfif isdefined("attributes.table_code")>
                <cfif isdefined("attributes.is_copy")>
                    <cfinput type="text" name="table_code" id="table_code" value="" readonly="yes" style="width:60px;"/>
                <cfelse>
                    <cfinput type="text" name="table_code" id="table_code" value="#attributes.table_code#" readonly="yes" style="width:60px;"/>
                </cfif>
            <cfelse>
                <cfinput type="text" name="table_code" id="table_code" value="" readonly="yes" style="width:60px;"/>
            </cfif>
            <cfinput type="hidden" name="table_secret_code" id="table_secret_code" value="#attributes.table_secret_code#" readonly="yes"/>
        </td>
        <td>Açıklama</td>
        <td>
            <cfif isdefined("attributes.table_code")>
                <cfif isdefined("attributes.is_copy")>
                    <cfinput type="text" name="table_info" id="table_info" value="" style="width:60px;"/>
                <cfelse>
                    <cfinput type="text" name="table_info" id="table_info" value="#attributes.table_info#" style="width:60px;"/>
                </cfif>
            <cfelse>
                <cfinput type="text" name="table_info" id="table_info" value="" style="width:60px;"/>
            </cfif>
        </td>
        <td>
            Arama 
            <cfinput type="text" name="table_search" id="table_search" value="" style="width:60px;"/>
            <select name="selected_p_type" id="selected_p_type" onchange="arama_yap();">
                <option value="2">Hepsi</option>
                <option value="1">Seçililer</option>
                <option value="0">Seçili Olmayanlar</option>
            </select>
            <select name="price_type_search" id="price_type_search" onchange="arama_yap();">
                <option value="">Fiyat Tipi</option>
                <cfloop query="get_price_types">
                    <cfoutput><option value="#get_price_types.type_id#">#get_price_types.TYPE_code#</option></cfoutput>
                </cfloop>
            </select>
            <select name="a_type" id="a_type" onchange="arama_yap();">
                <option value="2">Hepsi</option>
                <option value="1">Alıştakiler</option>
                <option value="0">Alışta Olmayanlar</option>
            </select>

            <input type="button" value="Eski Fiyatlar" onclick="get_old_prices();" name="get_old_prices_btn">  
            <input type="button" value="Ürün Ekle" onclick="add_product();"/>
            <input type="button" value="Ürün Yükle" onclick="add_product_excel();"/>
            <input type="button" value="Liste Yap (1) " onclick="save_list();"/>
            <input type="button" value="Görünüm Kaydet (2)" onclick="save_layout();" name="save_layout_button">
            <input type="button" value="Sipariş (3) " onclick="save_list_to_order();"/>
            <!--- <input type="button" value="Fiyat Yaz (4) " onclick="save_list_to_action();" name="kaydet"> --->
            <input type="button" value="Sevk İrsaliyesi (5) " onclick="save_list_to_ship();"/>
            <input type="button" value="Tablo Kaydet (6) " onclick="get_save_list_to_pre_order();" name="kaydet" id="save_table">
            <input type="button" value="Ceza" onclick="show_points();" name="show_points_button">
            <input type="button" value="Yazdır (7)" onclick="print_table_layout();" name="print_layout">
            <input type="button" value="Satıcı Limit" onclick="seller_limit_table();" name="seller_limit_table_">
            <input type="button" value="Uygulama" onclick="make_process_action();" name="make_process_action_btn">
            
            <input type="hidden" name="search_list_id" id="search_list_id" value="<cfoutput>#attributes.search_list_id#</cfoutput>">
            <input type="hidden" name="delete_product_list" id="delete_product_list" value=""/>
            <input type="hidden" name="all_product_list" id="all_product_list" value=""/>
            <input type="hidden" name="all_product_list_row" id="all_product_list_row" value=""/>
            <input type="hidden" name="selected_product_list" id="selected_product_list" value=""/>
            <input type="hidden" name="last_selected_id" id="last_selected_id" value=""/>
            <input type="hidden" name="last_selected_id_value" id="last_selected_id_value" value=""/>
            <input type="hidden" name="last_active_row" id="last_active_row" value=""/>
            <input type="hidden" name="last_active_row_class" id="last_active_row_class" value=""/>
            <input type="hidden" name="last_active_dept" id="last_active_dept" value="" style="width:50px;"/>
            <input type="hidden" name="last_active_stock" id="last_active_stock" value="" style="width:50px;"/>
            
        </td>
        <td>
            <div id="speed_action_div" style="display:none;"></div>
        </td>
    </tr>
</table>
</cf_box>
<!--- genel kayit alanlari --->
<div id="speed_table">
	<!--- <cfoutput>query dönüş süresi : #query_result.EXECUTIONTIME#</cfoutput> --->
	<cfinclude template="speed_manage_product_table.cfm">
</div>

<div id="points_div" style="display:none;">
	<cfif depo_ceza_query.recordcount>
       	<cfquery name="get_" dbtype="query">
        	SELECT
            	DEPT_HEAD,
                SUM(POINT) AS PUAN,
                COUNT(DISTINCT STOCK_ID) AS URUN_SAYISI,
                TOTAL_PRODUCT,
                POINT_MULTIPLIER
            FROM
            	depo_ceza_query
            GROUP BY
            	DEPT_HEAD,
                TOTAL_PRODUCT,
                POINT_MULTIPLIER
        </cfquery>
        <cf_ajax_list>
        	<thead>
            	<tr>
                	<th>Departman</th>
                    <th>Toplam Stok Sayısı</th>

                    <th>Stok Sayısı</th>
                    <th>Ceza Puanı</th>
                </tr>
            </thead>
            <tbody>
            	<cfoutput query="get_">
                <tr>
                	<td>#DEPT_HEAD#</td>
                    <td>#TOTAL_PRODUCT#</td>
                    <td>#URUN_SAYISI#</td>
                    <td>#WRK_ROUND(PUAN * 100 / TOTAL_PRODUCT * POINT_MULTIPLIER)#</td>
                </tr>
                </tbody></cfoutput>
            
        </cf_ajax_list>
    <cfelse>
    	Ceza Uygulaması Yapılmadı!
    </cfif>
</div>

</cfform>
 </td>
    </tr>
</table>
<script>
$(document).ready(function()
{
	document.getElementById('all_product_list').value = '<cfoutput>#product_id_list#</cfoutput>';
	
	$('#manage_table').dragtable();
	//alert(order);

	set_key_up_down();
	
	 <cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1>
	 	document.getElementById('is_selected_all').checked = true;
		select_row_all();
	 </cfif>

	<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
		document.getElementById('table_search').value = '<cfoutput>#attributes.finishdate#</cfoutput>';
		arama_yap();
	</cfif>
	
	<cfif isdefined("selected_product_id_list")>
		document.getElementById('selected_product_list').value = '<cfoutput>#selected_product_id_list#</cfoutput>';
	</cfif>
	
});

search_product_list_ = "";

$('#table_search').keyup(
function(e)
{
	kod_ = e.keyCode;
	if(kod_ == 13)
	{
		arama_yap();
	}
	else if(deger_ == '')
	{
		arama_yap();
	}
});


function get_row_active_dept(pid,sid,did)
{
	document.getElementById('last_active_row').value = pid;
	document.getElementById('last_active_stock').value = sid;
	document.getElementById('last_active_dept').value = did;
}

function arama_yap()
{
	deger_ = document.getElementById('table_search').value;
	
	urun_list_ = document.getElementById('all_product_list').value;
	uzunluk_ = list_len(urun_list_);
	price_deger_ = document.getElementById('price_type_search').value;
	p_type_deger_ = document.getElementById('selected_p_type').value;
	a_deger_ = document.getElementById('a_type').value;
	search_product_list_ = '';
	
	if(price_deger_ != '' || deger_ != '' || p_type_deger_ != '' || a_deger_ != '')
	{
		for (var m=1; m <= uzunluk_; m++)
		{
			urun_ = list_getat(urun_list_,m);
			urun_adi_ = document.getElementById('product_name_' + urun_).value;
			urun_kodu_ = document.getElementById('product_code_' + urun_).innerHTML;
			urun_barkod_ = document.getElementById('barcode_' + urun_).innerHTML;
			urun_price_deger_ = document.getElementById('price_type_' + urun_).value;
			if(document.getElementById('is_purchase_' + urun_).checked == true)
				urun_a_deger_ = 1;
			else
				urun_a_deger_ = 0;
			
			if(document.getElementById('is_selected_' + urun_).checked == true)
				urun_p_type_deger_ = 1;
			else
				urun_p_type_deger_ = 0;
			
			urun_fdate1_ = document.getElementById('finishdate_' + urun_).value;
			
			if(deger_ != '' && (urun_adi_.indexOf(deger_.toUpperCase()) >= 0 || urun_kodu_.indexOf(deger_.toUpperCase()) >= 0 || urun_barkod_.indexOf(deger_.toUpperCase()) >= 0 || urun_fdate1_.indexOf(deger_.toUpperCase()) >= 0))
				name_pass_ = 1;
			else if(deger_ == '')
				name_pass_ = 1;
			else
				name_pass_ = 0;
				
			if(price_deger_ != '' && urun_price_deger_ == price_deger_)
				price_pass_ = 1;
			else if(price_deger_ == '')
				price_pass_ = 1;
			else
				price_pass_ = 0;
				
			if(p_type_deger_ == 2)
				p_type_pass_ = 1;
			else if(p_type_deger_ == 1 && urun_p_type_deger_ == 1)
				p_type_pass_ = 1;
			else if(p_type_deger_ == 0 && urun_p_type_deger_ == 0)
				p_type_pass_ = 1;
			else
				p_type_pass_ = 0;
				
			if(a_deger_ == 2)
				a_price_pass_ = 1;
			else if(a_deger_ == 1 && urun_a_deger_ == 1)
				a_price_pass_ = 1;
			else if(a_deger_ == 0 && urun_a_deger_ == 0)
				a_price_pass_ = 1;
			else
				a_price_pass_ = 0;
			
			if(name_pass_ == 1 && price_pass_ == 1 && p_type_pass_ == 1 && a_price_pass_ == 1)
			{
				//
				if(search_product_list_ == '')
					search_product_list_ = urun_;
				else
					search_product_list_ += ',' + urun_;
					
				rel_ = "row_code='p_row_" + urun_ + "'";
				col1 = $("#manage_table tr[" + rel_ + "]");	
				col1.show();
			}
			else
			{
				rel_ = "p_id='" + urun_ + "'";
				col1 = $("#manage_table tr[" + rel_ + "]");	
				col1.hide();
				
				rel_ = "row_type='total_row'";
				col1 = $("#manage_table tr[" + rel_ + "]");	
				col1.hide();
			}
		}
		if(search_product_list_ != '')
		{
			ilk_urun_ = list_getat(search_product_list_,1);
			document.getElementById('product_name_' + ilk_urun_).select();
			document.getElementById('last_active_row').value = ilk_urun_;
		}
	}
	else
	{
		arama_gerial();	
	}
}

function arama_gerial()
{
	urun_list_ = document.getElementById('all_product_list').value;
	uzunluk_ = list_len(urun_list_);
	
	search_product_list_ = "";
	document.getElementById('last_active_row').value = '';
	
	for (var m=1; m <= uzunluk_; m++)
	{
		urun_ = list_getat(urun_list_,m);
		urun_adi_ = document.getElementById('product_name_' + urun_).value;

		rel_ = "row_code='p_row_" + urun_ + "'";
		col1 = $("#manage_table tr[" + rel_ + "]");	
		col1.show();
		
		rel_ = "row_type='total_row'";
		col1 = $("#manage_table tr[" + rel_ + "]");	
		col1.show();
	}
}

function yuvarla_standart_satis()
{
	deger_ = document.getElementById('std_round_number').value;
	urun_list_ = document.getElementById('all_product_list').value;
	uzunluk_ = list_len(urun_list_);
	
	for (var m=1; m <= uzunluk_; m++)
	{
		urun_ = list_getat(urun_list_,m);
		urun_fiyat_ = parseFloat(filterNum(document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + urun_).value));
		urun_fiyat_ = wrk_round(urun_fiyat_,2);	
		
		urun_fiyat_str_ = '' + urun_fiyat_;
		
		if(list_len(urun_fiyat_str_,'.') == 2)
		{
			ondalik_ = list_getat(urun_fiyat_str_,2,'.');
		
			if(ondalik_.length == 2)
			{
				son_hane = '' + urun_fiyat_str_.substr(urun_fiyat_str_.length-1);
				
				if(deger_ == '10' && son_hane != '0')
					urun_fiyat_ = urun_fiyat_ + ((10 - parseInt(son_hane)) / 100);
					
				if(deger_ == '5' && parseInt(son_hane) > 0 && parseInt(son_hane) < 5)
					urun_fiyat_ = urun_fiyat_ + ((5 - parseInt(son_hane)) / 100);
			
				if(deger_ == '5' && parseInt(son_hane) > 5)
					urun_fiyat_ = urun_fiyat_ + ((10 - parseInt(son_hane)) / 100);
			}
		}
		
		document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + urun_).value = commaSplit(urun_fiyat_);
		hesapla_standart_satis(urun_,'kdvli');
	}
}

function set_key_up_down()
{
	$("input").focus(function() 
	{
		input_ = $(this);
		setTimeout(function ()
		  {
			input_.select();
		  },200);
	}
	);
	
	$("input").keydown(function(e)
	{
	  kod_ = e.keyCode;
	  old_ = document.getElementById('last_active_row').value;
	  if(kod_ == 40)
		{
		   input_ = $(this);
		   td_ = input_.closest('td');
		   tr_ = td_.closest('tr');
		   myRow = tr_.index();
		   myCol = td_.index();
		   myall = $('#manage_table tbody tr').length;
		   
		   myRow_real = myRow + 1;
		   next_row = myRow + 1;
		   islem_row = next_row + 1;
		   		   
			if(myRow_real == myall)
			{
				//alert('Zaten En Alttasınız!');
				return false;
			}
			else
			{
				for(var m=(myRow); m <= myall+2; m++)
				{
					tr_durum_ = $('#manage_table tbody tr:eq(' + (m+1) + ')').attr('id');
					id_uzunluk_ = tr_durum_.length;
					
					if(id_uzunluk_ > 9 && tr_durum_.substring(0,9) == 'total_row')
						bakma_ = 1;
					else
						bakma_ = 0;
						
					if(document.getElementById(tr_durum_).style.display != 'none' && bakma_ == 0)
					{
						next_ = $('#manage_table tbody tr:eq(' + (m+1) + ')').attr('p_id');
						get_row_passive(old_);
						get_row_active(next_);
						$('#manage_table tbody tr:eq(' + (m+1) + ') td:eq(' + myCol + ')').children().focus();
						break;
					}
				}
			}
		   
		}
		else if(kod_ == 38)
		{
		input_ = $(this);
		   td_ = input_.closest('td');
		   tr_ = td_.closest('tr');
		   myRow = tr_.index();
		   myCol = td_.index();
		   myall = 0;
		   
		   myRow_real = myRow;
		   
		   next_row = myRow - 1;
		   islem_row = next_row + 1;
		   
			if(myRow_real == myall)
			{
				//alert('Zaten En Üsttesiniz!');
				return false;
			}
			else
			{
				for(var m=next_row; m >= myall; m--)
				{
					tr_durum_ = $('#manage_table tr:eq(' + (m+1) + ')').attr('id');
					id_uzunluk_ = tr_durum_.length;
					
					if(id_uzunluk_ > 9 && tr_durum_.substring(0,9) == 'total_row')
						bakma_ = 1;
					else
						bakma_ = 0;
					
					if(document.getElementById(tr_durum_).style.display != 'none' && bakma_ == 0)
					{
						next_ = $('#manage_table tbody tr:eq(' + (m+1) + ')').attr('p_id');
						get_row_passive(old_);
						get_row_active(next_);
						$('#manage_table tr:eq(' + (m+1) + ') td:eq(' + myCol + ')').children().focus();
						break;	
					}
				}
			}
		}
	});		
}

function set_startdate(product_id)
{
	if(document.getElementById('startdate_' + product_id).value == '' && document.getElementById('p_startdate_' + product_id).value != '') 
	{
		try
		{
			deger_ = document.getElementById('p_startdate_' + product_id).value;
			document.getElementById('startdate_' + product_id).value = date_add('d',1,deger_);
		}
		catch(e)
		{
			document.getElementById('startdate_' + product_id).value = 'HATA';
		}
	}
}

function set_finishdate(product_id)
{
	if(document.getElementById('finishdate_' + product_id).value == '') 
	{
		document.getElementById('finishdate_' + product_id).value = document.getElementById('p_finishdate_' + product_id).value;
	}
}

function set_new_price(pid,c_type_)
{
	today_ = '<cfoutput>#dateformat(now(),"dd/mm/yyyy")#</cfoutput>';
	gun_ = parseInt(list_getat(today_,1,'/'));
	ay_ = parseInt(list_getat(today_,2,'/'));
	yil_ = parseInt(list_getat(today_,3,'/'));
	bugun_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
		
	alis_bas_ = document.getElementById('p_startdate_' + pid).value.replace(".","/");
	alis_bit_ = document.getElementById('p_finishdate_' + pid).value.replace(".","/");
	
	satis_bas_ = document.getElementById('startdate_' + pid).value.replace(".","/");
	satis_bit_ = document.getElementById('finishdate_' + pid).value.replace(".","/");
	
	if(document.getElementById('is_selected_' + pid).checked == true && (alis_bas_ == '' || satis_bas_ == ''))
	{
		alert('Seçili Ürünler İçin Alış ve Satış Tarihlerini Girmelisiniz!');	
		return false;
	}
	
	if((alis_bas_ != '' && alis_bit_ == '') || (alis_bas_ == '' && alis_bit_ != ''))
	{
		alert('Alış Tarihlerini Tam Girmelisiniz!');
		return false;	
	}
	
	if((satis_bas_ != '' && satis_bit_ == '') || (satis_bas_ == '' && satis_bit_ != ''))
	{
		alert('Satış Tarihlerini Tam Girmelisiniz!');
		return false;	
	}
	
	
	if(alis_bas_ != '' && alis_bas_ == alis_bit_)
	{
		alert('Alış Tarihleri Aynı Olamaz!');
		return false;
	}
	
	if(satis_bas_ != '' && satis_bas_ == satis_bit_)
	{
		alert('Satış Tarihleri Aynı Olamaz!');
		return false;	
	}
	
	if(satis_bas_ != '')
	{
		gun_ = parseInt(list_getat(satis_bas_,1,'/'));
		ay_ = parseInt(list_getat(satis_bas_,2,'/'));
		yil_ = parseInt(list_getat(satis_bas_,3,'/'));
		satis_bas_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
	}
	
	if(satis_bit_ != '')
	{
		gun_ = parseInt(list_getat(satis_bit_,1,'/'));
		ay_ = parseInt(list_getat(satis_bit_,2,'/'));
		yil_ = parseInt(list_getat(satis_bit_,3,'/'));
		satis_bit_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
	}
	
	if(alis_bas_ != '')
	{
		gun_ = parseInt(list_getat(alis_bas_,1,'/'));
		ay_ = parseInt(list_getat(alis_bas_,2,'/'));
		yil_ = parseInt(list_getat(alis_bas_,3,'/'));
		alis_bas_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
	}
	
	if(alis_bit_ != '')
	{
		gun_ = parseInt(list_getat(alis_bit_,1,'/'));
		ay_ = parseInt(list_getat(alis_bit_,2,'/'));
		yil_ = parseInt(list_getat(alis_bit_,3,'/'));
		alis_bit_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
	}
	
		
	if(c_type_ == '0') // fiyatlarin tamami yeniden yazilacak ise
	{
		if(satis_bas_ != '' && satis_bas_deger_ < bugun_deger_)
		{
			alert('Satış Başlangıç Bugünden Önce Olamaz!');
			return false;	
		}
		
		if(satis_bit_ != '' && satis_bit_deger_ < bugun_deger_)
		{
			alert('Satış Bitiş Bugünden Önce Olamaz!');
			return false;	
		}
		
		if(alis_bit_ != '' && alis_bit_deger_ < bugun_deger_)
		{
			alert('Alış Bitiş Bugünden Önce Olamaz!');
			return false;	
		}
	}
	else if(c_type_ == '1')
	{
		if(document.getElementById('product_price_change_lastrowid_' + pid).value == '0')
		{
			if(satis_bas_ != '' && satis_bas_deger_ < bugun_deger_)
			{
				alert('Satış Başlangıç Bugünden Önce Olamaz!');
				return false;	
			}
			
			if(satis_bit_ != '' && satis_bit_deger_ < bugun_deger_)
			{
				alert('Satış Bitiş Bugünden Önce Olamaz!');
				return false;	
			}
			
			if(alis_bit_ != '' && alis_bit_deger_ < bugun_deger_)
			{
				alert('Alış Bitiş Bugünden Önce Olamaz!');
				return false;	
			}
		}	
	}
	
	
	
	if(alis_bas_ != '' && alis_bit_ != '' && alis_bas_deger_ > alis_bit_deger_)
	{
		alert('Alış Bitiş Alış Başlangıçtan Önce Olamaz!');
		return false;
	}
	
	if(satis_bas_ != '' && satis_bit_ != '' && satis_bas_deger_ > satis_bit_deger_)
	{
		alert('Satış Bitiş Satış Başlangıçtan Önce Olamaz!');
		return false;
	}
	
	
	if(document.getElementById('price_type_' + pid).value == '')
	{
		alert('Fiyat Tipi Seçiniz!');
		return false;	
	}
	
	deger_ = '0';
	
	deger_ += ';' + document.getElementById('price_type_' + pid).value;
	deger_ += ';' + document.getElementById('NEW_ALIS_START_' + pid).value;
	deger_ += ';' + document.getElementById('sales_discount_' + pid).value;
	deger_ += ';' + document.getElementById('p_discount_manuel_' + pid).value;
	deger_ += ';' + document.getElementById('NEW_ALIS_' + pid).value;
	deger_ += ';' + document.getElementById('NEW_ALIS_KDVLI_' + pid).value;
	deger_ += ';' + document.getElementById('p_startdate_' + pid).value;
	deger_ += ';' + document.getElementById('p_finishdate_' + pid).value;
	deger_ += ';' + document.getElementById('p_marj_' + pid).value;
	
	if(document.getElementById('is_active_p_' + pid).checked == true)
		deger_ += ';' + '1';
	else
		deger_ += ';' + '0';
	
	deger_ += ';' + document.getElementById('FIRST_SATIS_PRICE_' + pid).value;
	deger_ += ';' + document.getElementById('FIRST_SATIS_PRICE_KDV_' + pid).value;
	deger_ += ';' + document.getElementById('READ_FIRST_SATIS_PRICE_RATE_' + pid).value;
	deger_ += ';' + document.getElementById('p_ss_marj_' + pid).value;
	deger_ += ';' + document.getElementById('startdate_' + pid).value;
	deger_ += ';' + document.getElementById('finishdate_' + pid).value;
	
	if(document.getElementById('is_active_s_' + pid).checked == true)
		deger_ += ';' + '1';
	else
		deger_ += ';' + '0';
		
	deger_ += ';' + document.getElementById('p_dueday_' + pid).value;
	
	//deger_ += ';' + '0'; hep yeni fiyat yazıyorduk artık row fiyat guncelliyoruz
	deger_ += ';' + document.getElementById('product_price_change_lastrowid_' + pid).value;
	
	document.getElementById('product_price_change_lastrowid_' + pid).value = '0'; // satiri yazar yazmak bu degeri 0 yapiyoruz ve baska satirlarla karismasini engelliyoruz
	
	sayi_ = parseInt(document.getElementById('product_price_change_count_' + pid).value);
	yeni_sayi_ = sayi_ + 1;
	if(yeni_sayi_ == 1)
	{
		document.getElementById('product_price_change_count_' + pid).value = yeni_sayi_;
		document.getElementById('product_price_change_detail_' + pid).value = deger_;
		//alert('Fiyat Eklendi!');
		//document.getElementById('product_price_change_detail_' + pid).value += '*' + deger_;
	}
	else
	{
		parcala_ = document.getElementById('product_price_change_detail_' + pid).value;
		yaz_ = 1;
		for (var m=1; m <= sayi_; m++)
		{
			sira_eleman_ = list_getat(parcala_,m,'*');
			if(sira_eleman_ == deger_)
			{
				yaz_ = 0;	
			}
		}
		
		if(yaz_ == 1)
		{
			document.getElementById('product_price_change_count_' + pid).value = yeni_sayi_;
			document.getElementById('product_price_change_detail_' + pid).value += '*' + deger_;
			//alert('Fiyat Eklendi!');
		}
		else
		{
			//alert('Kayıt Tekrarı!');	
		}
	}
	return true;
}

function get_pro_prices(pid)
{
	document.getElementById("message_div_main_header_info").innerHTML = 'Fiyat Yazılmamış Teklifler';
	document.getElementById("message_div_main").style.height = 350 + "px";
	document.getElementById("message_div_main").style.width = 1100 + "px";
	document.getElementById("message_div_main").style.top = (document.body.offsetHeight-350)/2 + "px";
	document.getElementById("message_div_main").style.left = (document.body.offsetWidth-1100)/2 + "px";
	document.getElementById("message_div_main").style.zIndex = 99999;
	document.getElementById('message_div_main_body').style.overflowY = 'auto';
	
	sayi_ = document.getElementById('product_price_change_count_' + pid).value;
	parcala_ = document.getElementById('product_price_change_detail_' + pid).value;
	
	if(sayi_ > 0)
	{
		icerik_ = '<table border="1" cellpadding="2" cellspacing="0">';
		icerik_ += '<thead>';
		icerik_ += '<tr class="color-list" style="height:25px;">';
		icerik_ += '<th class="formbold" style="background-color:#66cdaa;">Fiyat Tipi</th>';
		icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Br. Alş Kdvsiz</th>';
		icerik_ += '<th class="formbold" style="background-color:#ffebcd;">İskonto Yüzde</th>';
		icerik_ += '<th class="formbold" style="background-color:#ffebcd;">İskonto Tutar</th>';
		icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Al. KDVsiz</th>';
		icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Al. KDVli</th>';
		icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Al. Baş.</th>';
		icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Al. Btş.</th>';
		icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Al. Kar</th>';
		icerik_ += '<th class="formbold" style="background-color:#66cdaa;">A. Aktif</th>';
		icerik_ += '<th class="formbold" style="background-color:#deb887;">Stş Fiyat</th>';
		icerik_ += '<th class="formbold" style="background-color:#deb887;">Stş KDVli</th>';
		icerik_ += '<th class="formbold" style="background-color:#deb887;">GF Ort. D.</th>';
		icerik_ += '<th class="formbold" style="background-color:#deb887;">Stş Kar</th>';
		icerik_ += '<th class="formbold" style="background-color:#deb887;">Stş Baş.</th>';
		icerik_ += '<th class="formbold" style="background-color:#deb887;">Stş Btş.</th>';
		icerik_ += '<th class="formbold" style="background-color:#66cdaa;">S. Aktif</th>';
		icerik_ += '<th class="formbold" style="background-color:#deb887;">Vade</th>';
		//icerik_ += '<th class="formbold"></th>';
		icerik_ += '</tr>';
		icerik_ += '</thead>';
		icerik_ += '<tbody>';
		
		
		for (var m=1; m <= sayi_; m++)
		{
			sira_eleman_ = list_getat(parcala_,m,'*');
			if(sira_eleman_ != '')
			{
				icerik_ += '<tr>';		
				try
				{
					for(var k=2; k <= 19; k++)
					{
						if(k == 2 || k == 11 || k == 18)
							icerik_ += '<td style="background-color:#66cdaa;">';
						else if(k < 11)
							icerik_ += '<td style="background-color:#ffebcd;">';
						else
							icerik_ += '<td style="background-color:#deb887;">';
						sira_no_ = k;
						if(sira_no_==2)
						{
							deger_ = parseInt(list_getat(sira_eleman_,k,';'));
							if(deger_ != '')
								icerik_ += '<a href="javascript://" class="tableyazi" onclick="change_pro_prices(' + pid + ',' + m + ')">' + eval("j_price_type_" + deger_) + '</a>';
						}
						else
						{
							if(k == 11 || k == 18)
							{
								if(list_getat(sira_eleman_,11,';') == 0 && list_getat(sira_eleman_,18,';') == 0)
									icerik_ += 'Teklif';
								else
									icerik_ += list_getat(sira_eleman_,k,';');
							}
							else
								icerik_ += list_getat(sira_eleman_,k,';');
						}
						icerik_ += '</td>';
					}
				}
				catch(e)
				{
					alert(sira_eleman_);	
					alert(sira_no_);
				}
			}
			
			icerik_ += '<td><a href="javascript://" onclick="del_pro_prices(' + pid + ',' + m + ')"><img src="/images/delete_list.gif"></a></td>';
			icerik_ += '</tr>';
		}
		
		icerik_ += '</tbody>';
		icerik_ += '</table>';
	}
	else
	{
		icerik_ = 'Bu Ürün İçin Fiyat Tanımı Yapılmamış!';
	}

	document.getElementById('message_div_main_body').innerHTML = icerik_;
	show('message_div_main');
}

function change_pro_prices(product_id,fiyat_sira)
{
	sayi_ = document.getElementById('product_price_change_count_' + product_id).value;
	parcala_ = document.getElementById('product_price_change_detail_' + product_id).value;
	
	if(sayi_ > 0)
	{
		for (var m=1; m <= sayi_; m++)
		{
			if(m == fiyat_sira)
			{
				sira_eleman_ = list_getat(parcala_,m,'*');
				for(var k=2; k <= 20; k++)
				{
					//icerik_ += '<td>';
					sira_no_ = k;				
							
					deger_ = list_getat(sira_eleman_,k,';');
					
					if(sira_no_ == 2)
						document.getElementById('price_type_' + product_id).value = deger_;
						
					if(sira_no_ == 3)
						document.getElementById('NEW_ALIS_START_' + product_id).value = deger_;
					
					if(sira_no_ == 4)
						document.getElementById('sales_discount_' + product_id).value = deger_;
						
					if(sira_no_ == 5)
						document.getElementById('p_discount_manuel_' + product_id).value = deger_;
						
					if(sira_no_ == 6)
						document.getElementById('NEW_ALIS_' + product_id).value = deger_;
						
					if(sira_no_ == 7)
						document.getElementById('NEW_ALIS_KDVLI_' + product_id).value = deger_;
						
					if(sira_no_ == 8)
						document.getElementById('p_startdate_' + product_id).value = deger_;
						
					if(sira_no_ == 9)
						document.getElementById('p_finishdate_' + product_id).value = deger_;
						
					if(sira_no_ == 10)
						document.getElementById('p_marj_' + product_id).value = deger_;
					
					if(sira_no_ == 11)
					{
						if(deger_ == 1)
							document.getElementById('is_active_p_' + product_id).checked = true;
						else
							document.getElementById('is_active_p_' + product_id).checked = false;
					}
					
					if(sira_no_ == 12)
						document.getElementById('FIRST_SATIS_PRICE_' + product_id).value = deger_;
						
					if(sira_no_ == 13)
						document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id).value = deger_;
					
					if(sira_no_ == 14)
						document.getElementById('READ_FIRST_SATIS_PRICE_RATE_' + product_id).value = deger_;
					
					if(sira_no_ == 15)
						document.getElementById('p_ss_marj_' + product_id).value = deger_;

					if(sira_no_ == 16)
						document.getElementById('startdate_' + product_id).value = deger_;
						
					if(sira_no_ == 17)
						document.getElementById('finishdate_' + product_id).value = deger_;
						
					if(sira_no_ == 18)
					{
						if(deger_ == 1)
							document.getElementById('is_active_s_' + product_id).checked = true;
						else
							document.getElementById('is_active_s_' + product_id).checked = false;
					}
					
					if(sira_no_ == 19)
						document.getElementById('p_dueday_' + product_id).value = deger_;
						
					if(sira_no_ == 20)
					{
						document.getElementById('product_price_change_lastrowid_' + product_id).value = deger_;
					}
				}
			}
		}
	}
	del_pro_prices(product_id,fiyat_sira);
	//p_discount_calc(product_id);
}

function del_pro_prices(product_id,fiyat_sira)
{
	document.getElementById('message_div_main_body').innerHTML = 'Bekleyiniz!';
	
	sayi_ = document.getElementById('product_price_change_count_' + product_id).value;
	parcala_ = document.getElementById('product_price_change_detail_' + product_id).value;
	
	new_list_ = '';
	
	
	for (var sm=1; sm <= sayi_; sm++)
	{
		if(sm != fiyat_sira)
		{
			sira_eleman_ = list_getat(parcala_,sm,'*');
			
			if(new_list_ != '')
			{
				new_list_ += '*' + sira_eleman_;	
			}
			else
			{
				new_list_ = sira_eleman_;		
			}	
		}
	}
	
	document.getElementById('product_price_change_count_' + product_id).value = parseInt(sayi_ - 1);
	document.getElementById('product_price_change_detail_' + product_id).value = new_list_;
	
	get_pro_prices(product_id);	
}

function hesapla_standart_alis(pid,type)
{
	alis_kdv = document.getElementById('STANDART_ALIS_KDV_' + pid).innerHTML;
	alis_kdvsiz = filterNum(document.getElementById('STANDART_ALIS_' + pid).value,4);
	alis_kdvli = filterNum(document.getElementById('STANDART_ALIS_KDVLI_' + pid).value,4);
	alis_kdv_rank = 1 + (alis_kdv / 100);
	
	if(type == 'kdv')
	{
		alis_kdvli = alis_kdvsiz * alis_kdv_rank;	
	}
	if(type == 'kdvli')
	{
		alis_kdvsiz = alis_kdvli / alis_kdv_rank;
	}
	if(type == 'kdvsiz')
	{
		alis_kdvli = alis_kdvsiz * alis_kdv_rank;	
	}
	alis_kdvsiz = commaSplit(alis_kdvsiz,4);
	alis_kdvli = commaSplit(alis_kdvli,4);

	document.getElementById('STANDART_ALIS_LISTE_' + pid).value = alis_kdvsiz;
	document.getElementById('STANDART_ALIS_KDVLI_' + pid).value = alis_kdvli;
	
	std_p_discount_calc(pid);
}

function hesapla_standart_satis(pid,type)
{
	satis_kdv = document.getElementById('STANDART_SATIS_KDV_' + pid).innerHTML;
	satis_kdvsiz = filterNum(document.getElementById('READ_FIRST_SATIS_PRICE_' + pid).value,4);
	satis_kdvli = filterNum(document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + pid).value,4);
	satis_kdv_rank = 1 + (satis_kdv / 100);
	
	if(type == 'kdv')
	{
		satis_kdvli = satis_kdvsiz * satis_kdv_rank;	
	}
	if(type == 'kdvli')
	{
		satis_kdvsiz = satis_kdvli / satis_kdv_rank;
	}
	if(type == 'kdvsiz')
	{
		satis_kdvli = satis_kdvsiz * satis_kdv_rank;	
	}
	
	//alis_kdvli = filterNum(document.getElementById('STANDART_ALIS_KDVLI_' + pid).value);
	alis_ilk_ = parseFloat(filterNum(document.getElementById('STANDART_ALIS_LISTE_' + pid).value));
	alis_kdvli = alis_ilk_ * satis_kdv_rank;
	
	kar_ = 100 - (wrk_round(alis_kdvli / satis_kdvli * 100));
	
	satis_kdvsiz = commaSplit(satis_kdvsiz,4);
	satis_kdvli = commaSplit(satis_kdvli,4);
	kar_ = commaSplit(kar_,2);

	document.getElementById('s_profit_' + pid).value = kar_;
	document.getElementById('READ_FIRST_SATIS_PRICE_' + pid).value = satis_kdvsiz;
	document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + pid).value = satis_kdvli;
	
	//alis kar hesabi
	s_kar = filterNum(document.getElementById('s_profit_' + pid).value);
	a_kar = s_kar / (100 - s_kar) * 100;
	document.getElementById('p_profit_' + pid).value = commaSplit(a_kar);
	//alis kar hesabi
}

function hesapla_std_profit_p_to_s(pid)
{
	a_kar = parseFloat(filterNum(document.getElementById('p_profit_' + pid).value));
	s_kar = a_kar / (100 + a_kar) * 100;
	document.getElementById('s_profit_' + pid).value = commaSplit(s_kar);
	hesapla_first_sales_std(pid,'3');	
}

function hesapla_profit_p_to_s(pid)
{
	a_kar = parseFloat(filterNum(document.getElementById('p_marj_' + pid).value));
	s_kar = a_kar / (100 + a_kar) * 100;
	document.getElementById('p_ss_marj_' + pid).value = commaSplit(s_kar);
	hesapla_first_sales(pid,'3');	
}

function hesapla_satis(pid,type)
{
	avantaj = 0;
	satis_kdv = document.getElementById('STANDART_SATIS_KDV_' + pid).innerHTML;
	satis_kdvsiz = filterNum(document.getElementById('FIRST_SATIS_PRICE_' + pid).value,4);
	satis_kdvli = filterNum(document.getElementById('FIRST_SATIS_PRICE_KDV_' + pid).value,4);
	satis_kdv_rank = 1 + (satis_kdv / 100);
	aktif_fiyat = filterNum(document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + pid).value,4);
	fiyat_fark = aktif_fiyat - satis_kdvli;
	
	if(fiyat_fark > 0)
	{
		if(aktif_fiyat > 0)
			{
			avantaj = wrk_round(fiyat_fark / aktif_fiyat*100,1);	
			}
	}
	if(type == 'kdv')
	{
		satis_kdvli = satis_kdvsiz * satis_kdv_rank;	
	}
	if(type == 'kdvli')
	{
		satis_kdvsiz = satis_kdvli / satis_kdv_rank;
	}
	if(type == 'kdvsiz')
	{
		satis_kdvli = satis_kdvsiz * satis_kdv_rank;	
	}
	
	//alis_kdvli = filterNum(document.getElementById('NEW_ALIS_KDVLI_' + pid).value);
	alis_ilk_ = parseFloat(filterNum(document.getElementById('NEW_ALIS_' + pid).value));
	alis_kdvli = alis_ilk_ * satis_kdv_rank;
	
	kar_ = 100 - (wrk_round(alis_kdvli / satis_kdvli * 100));
	
	satis_kdvsiz = commaSplit(satis_kdvsiz,4);
	satis_kdvli = commaSplit(satis_kdvli,4);

	kar_ = commaSplit(kar_,2);

	document.getElementById('p_ss_marj_' + pid).value = kar_;
	document.getElementById('FIRST_SATIS_PRICE_' + pid).value = satis_kdvsiz;
	document.getElementById('FIRST_SATIS_PRICE_KDV_' + pid).value = satis_kdvli;
	if(avantaj > 0)
	{
		document.getElementById('AVANTAJ_ORAN_' + pid).value = avantaj;
	}
	else
	{
		document.getElementById('AVANTAJ_ORAN_' + pid).value = '';	
	}
	
	//alis kar hesabi
	s_kar = filterNum(document.getElementById('p_ss_marj_' + pid).value);
	a_kar = s_kar / (100 - s_kar) * 100;
	document.getElementById('p_marj_' + pid).value = commaSplit(a_kar);
	//alis kar hesabi
}

function oran_hesapla(pid)
{
	avantaj = 0;	
	satis_kdvli = filterNum(document.getElementById('FIRST_SATIS_PRICE_KDV_' + pid).value,4);
	aktif_fiyat = filterNum(document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + pid).value,4);
	fiyat_fark = aktif_fiyat - satis_kdvli;	
	if(fiyat_fark > 0)
	{
		if(aktif_fiyat > 0)
			{
			avantaj = fiyat_fark / aktif_fiyat*100;	
			}
	}		
	if(avantaj > 0)
	{
		document.getElementById('AVANTAJ_ORAN_' + pid).value = avantaj;
	}
	else
	{
		document.getElementById('AVANTAJ_ORAN_' + pid).value = '';	
	}	
}

function open_calc_price_window(product_id)
{
	windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_calc_price_window&product_id=</cfoutput>' + product_id,'medium','fiyat_hesapla');	
}

function sevk_islemi_baslat(s_id,d_id,rkm)
{
	adres_ = '<cfoutput>#request.self#?fuseaction=retail.popup_calc_stock_window&stock_id=</cfoutput>' + s_id + '&department_id=' + d_id + '&stock_count=' + rkm;
	dept_list_ = '';
	<cfoutput query="get_departments">
		<cfif currentrow eq 1>
			dept_list_ = document.getElementById('STOCK_SATIS_AMOUNT_ILK_' + s_id + '_' + '#department_id#').value + '-' + '#department_id#';
		<cfelse>
			dept_list_ += ',' + document.getElementById('STOCK_SATIS_AMOUNT_ILK_' + s_id + '_' + '#department_id#').value + '-' + '#department_id#';
		</cfif>
	</cfoutput>
	adres_ += '&s_dept_list=' + dept_list_;
	windowopen(adres_,'medium');
}

function show_points()
{
	document.getElementById("message_div_main_header_info").innerHTML = 'Ceza İşlemleri';
	document.getElementById("message_div_main").style.height = 220 + "px";
	document.getElementById("message_div_main_body").style.height = 220 + "px";
	document.getElementById("message_div_main").style.width = 500 + "px";
	document.getElementById("message_div_main").style.top = (document.body.offsetHeight-220)/2 + "px";
	document.getElementById("message_div_main").style.left = (document.body.offsetWidth-500)/2 + "px";
	document.getElementById("message_div_main").style.zIndex = 99999;
	document.getElementById('message_div_main_body').innerHTML = document.getElementById('points_div').innerHTML;
	document.getElementById('message_div_main_body').style.overflowY = 'auto';
	show_hide('message_div_main');
}

function get_save_list_to_pre_order()
{
	document.getElementById("message_div_main_header_info").innerHTML = 'Kayıt İşlemi';
	document.getElementById("message_div_main").style.height = 220 + "px";
	document.getElementById("message_div_main_body").style.height = 220 + "px";
	document.getElementById("message_div_main").style.width = 500 + "px";
	document.getElementById("message_div_main").style.top = (document.body.offsetHeight-220)/2 + "px";
	document.getElementById("message_div_main").style.left = (document.body.offsetWidth-500)/2 + "px";
	document.getElementById("message_div_main").style.zIndex = 99999;
	
	icerik_ = '<br><br><input type="button" value="Teklif Olarak Kaydet" onclick="save_list_to_pre_order(2);" name="kaydet_ord" id="save_table_ord"> <br><br>';
	icerik_ += '<input type="button" value="Fiyat Yaz" onclick="save_list_to_pre_order(0);" name="kaydet_add" id="save_table_add"> <br><br>';
	icerik_ += '<input type="button" value="Fiyat Güncelle" onclick="save_list_to_pre_order(1);" name="kaydet_upd" id="save_table_upd"> <br><br>';
	
	document.getElementById('message_div_main_body').innerHTML = icerik_;
	document.getElementById('message_div_main_body').style.overflowY = 'auto';
	show_hide('message_div_main');	
}

function get_old_prices()
{
	adres_ = '<cfoutput>#request.self#?fuseaction=retail.popup_old_prices</cfoutput>';
	adres_ += '&product_id_list=' + document.getElementById('all_product_list').value;
	windowopen(adres_,'wide2');
}


function hesapla_sales_discount_to_price(product_id,alan,base_alan,marj_alan)
{
	try
	{
		base_deger_ = parseFloat(filterNum(document.getElementById(base_alan).value));
		marj_deger_ = parseFloat(filterNum(document.getElementById(marj_alan).value));
		
		
		//base_deger_ = base_deger_ * ((100 + marj_deger_) / 100);
		base_deger_ = base_deger_ / (100 - marj_deger_) * 100;
		
		if(alan == 'FIRST_SATIS_PRICE_' + product_id)
		{
			document.getElementById(alan).value = base_deger_;
			hesapla_first_sales(product_id,'3');
			//duzenle_first_sales(product_id);
		}
		else
		{
			document.getElementById(alan).value = commaSplit(base_deger_);
		}
	}
	catch(e)
	{
		alert('İndirim Alanında Yazım Hatası Var');	
	}
	return true;	
}

function hesapla_first_sales(product_id,type)
{
	ilk_ = parseFloat(filterNum(document.getElementById('READ_FIRST_SATIS_PRICE_' + product_id).value));
	kdv_ = parseFloat(document.getElementById('STANDART_SATIS_KDV_' + product_id).innerHTML);
	alis_ = parseFloat(filterNum(document.getElementById('NEW_ALIS_' + product_id).value));
	
	satis_ = document.getElementById('FIRST_SATIS_PRICE_' + product_id).value;
	satis_kdv_ = document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id).value;

	if(type == '0')
	{
		satis_ = satis_ + '';
		if(satis_.indexOf(",") > 0)
			satis_ = parseFloat(filterNum(satis_,4));

		marj_ = wrk_round(((satis_ * 100) / alis_) - 100,4);
		
		
		kdv_li_deger_ = parseFloat(wrk_round(satis_ * ((100 + kdv_) /100)));
		
		document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id).value = kdv_li_deger_;
		document.getElementById('p_ss_marj_' + product_id).value = commaSplit(marj_);
		
		//alis kar hesabi
		s_kar = filterNum(document.getElementById('p_ss_marj_' + product_id).value);
		a_kar = s_kar / (100 - s_kar) * 100;
		document.getElementById('p_marj_' + product_id).value = commaSplit(a_kar);
		//alis kar hesabi
	}
	if(type == '1')
	{
		satis_kdv_ = satis_kdv_ + '';

		if(satis_kdv_.indexOf(",") > 0)
			satis_kdv_ = parseFloat(filterNum(satis_kdv_));

		kdvsiz_deger_ = parseFloat(wrk_round(satis_kdv_ * ((100 - kdv_) / 100),4));
		satis_ = kdvsiz_deger_;
		
		marj_ = wrk_round(((satis_ * 100) / alis_) - 100,4);
		
		
		document.getElementById('FIRST_SATIS_PRICE_' + product_id).value = kdvsiz_deger_;
		document.getElementById('p_ss_marj_' + product_id).value = commaSplit(marj_);
		
		//alis kar hesabi
		s_kar = marj_;
		a_kar = s_kar / (100 - s_kar) * 100;
		document.getElementById('p_marj_' + product_id).value = commaSplit(a_kar);
		//alis kar hesabi
	}
	if(type == '2')
	{
		satis_ = satis_ + '';

		if(satis_.indexOf(",") > 0)
			satis_ = parseFloat(filterNum(satis_,4));
		
		kdv_li_deger_ = parseFloat(wrk_round(satis_ * ((100 + kdv_) /100)));
		document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id).value = kdv_li_deger_;
		document.getElementById('FIRST_SATIS_PRICE_' + product_id).value = satis_;

		duzenle_first_sales(product_id,'2');
	}
	
	if(type == '3')
	{
		marj_ = filterNum(document.getElementById('p_ss_marj_' + product_id).value);
		if(marj_ == '')
			marj_ = 0;
		
		marj_ = parseFloat(marj_);
		
		//alis_ = parseFloat(filterNum(document.getElementById('NEW_ALIS_KDVLI_' + product_id).value));
		alis_ilk_ = parseFloat(filterNum(document.getElementById('NEW_ALIS_' + product_id).value));
		alis_ = alis_ilk_ * ((100 + kdv_) /100);
		
		kdv_li_deger_ = wrk_round(alis_ / (100 - marj_) * 100);
		
		satis_ = parseFloat(wrk_round(kdv_li_deger_ / ((100 + kdv_) /100),4));
		
		document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id).value = kdv_li_deger_;
		document.getElementById('FIRST_SATIS_PRICE_' + product_id).value = wrk_round(satis_,4);
	
		//alis kar hesabi
		s_kar = marj_;
		a_kar = s_kar / (100 - s_kar) * 100;
		document.getElementById('p_marj_' + product_id).value = commaSplit(a_kar);
		//alis kar hesabi
	
		duzenle_first_sales(product_id,'2');
	}

	if(isNaN(satis_))
	{
		satis_ = filterNum(satis_,4);
		oran_ = wrk_round(((100 * satis_) / ilk_) - 100);
	}
	else
	{
		oran_ = wrk_round(((100 * satis_) / ilk_) - 100);
	}
	
	document.getElementById('READ_FIRST_SATIS_PRICE_RATE_' + product_id).value = '% ' + commaSplit(oran_);
	return true;
}

function isFloat(n) {
    return n === +n && n !== (n|0);
}

function duzenle_first_sales(product_id,type)
{
	document.getElementById('FIRST_SATIS_PRICE_' + product_id).value = commaSplit(document.getElementById('FIRST_SATIS_PRICE_' + product_id).value,4);
	document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id).value = commaSplit(document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id).value,4);
	//document.getElementById('product_price_change_' + product_id).value = '1';

	document.getElementById('fiyat_div_a_' + product_id).style.display = 'inline-block';
	document.getElementById('fiyat_div_p_' + product_id).style.display = 'none';
}

function hesapla_first_sales_std(product_id,type)
{
	ilk_ = parseFloat(filterNum(document.getElementById('INFO_STANDART_SATIS_' + product_id).innerHTML));
	kdv_ = parseFloat(document.getElementById('STANDART_SATIS_KDV_' + product_id).innerHTML);
	alis_ = parseFloat(filterNum(document.getElementById('STANDART_ALIS_' + product_id).value));
	
	
	satis_ = document.getElementById('READ_FIRST_SATIS_PRICE_' + product_id).value;
	satis_kdv_ = document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + product_id).value;
	
	
	if(type == '0')
	{
		satis_ = satis_ + '';

		if(satis_.indexOf(",") > 0)
			satis_ = parseFloat(filterNum(satis_));
		
		marj_ = wrk_round(((satis_ * 100) / alis_) - 100,4);
		
		kdv_li_deger_ = parseFloat(wrk_round(satis_ * ((100 + kdv_) /100)));
		
		document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + product_id).value = kdv_li_deger_;
		document.getElementById('s_profit_' + product_id).value = commaSplit(marj_);
		
		//alis kar hesabi
		s_kar = filterNum(document.getElementById('s_profit_' + product_id).value);
		a_kar = s_kar / (100 - s_kar) * 100;
		document.getElementById('p_profit_' + product_id).value = commaSplit(a_kar);
		//alis kar hesabi
	}
	if(type == '1')
	{
		satis_kdv_ = satis_kdv_ + '';

		if(satis_kdv_.indexOf(",") > 0)
			satis_kdv_ = parseFloat(filterNum(satis_kdv_));

		kdvsiz_deger_ = parseFloat(wrk_round(satis_kdv_ * ((100 - kdv_) / 100)));
		satis_ = kdvsiz_deger_;
		
		marj_ = wrk_round(((satis_ * 100) / alis_) - 100,4);
		
		
		document.getElementById('INFO_STANDART_ALIS_' + product_id).value = kdvsiz_deger_;
		document.getElementById('s_profit_' + product_id).value = marj_;
		
		
		//alis kar hesabi
		s_kar = marj_;
		a_kar = s_kar / (100 - s_kar) * 100;
		document.getElementById('p_profit_' + product_id).value = commaSplit(a_kar);
		//alis kar hesabi
	}
	if(type == '2')
	{
		satis_ = satis_ + '';

		if(satis_.indexOf(",") > 0)
			satis_ = parseFloat(filterNum(satis_));
		
		kdv_li_deger_ = parseFloat(wrk_round(satis_ * ((100 + kdv_) /100)));
		document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + product_id).value = kdv_li_deger_;
		document.getElementById('READ_FIRST_SATIS_PRICE_' + product_id).value = satis_;

		duzenle_first_sales_std(product_id,'2');
	}
	
	if(type == '3')
	{
		marj_ = filterNum(document.getElementById('s_profit_' + product_id).value);
		if(marj_ == '')
			marj_ = 0;
		
		marj_ = parseFloat(marj_);
		
		alis_ilk_ = parseFloat(filterNum(document.getElementById('STANDART_ALIS_LISTE_' + product_id).value));
		alis_ = alis_ilk_ * ((100 + kdv_) /100);;
		
		kdv_li_deger_ = alis_ / (100 - marj_) * 100;
		
		satis_ = parseFloat(wrk_round(kdv_li_deger_ / ((100 + kdv_) /100),4));
		
		document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + product_id).value = kdv_li_deger_;
		document.getElementById('READ_FIRST_SATIS_PRICE_' + product_id).value = wrk_round(satis_,4);
		
		//alis kar hesabi
		s_kar = marj_;
		a_kar = s_kar / (100 - s_kar) * 100;
		document.getElementById('p_profit_' + product_id).value = commaSplit(a_kar);
		//alis kar hesabi
	
		duzenle_first_sales_std(product_id,'2');
	}

	if(isNaN(satis_))
	{
		satis_ = filterNum(satis_);
		oran_ = wrk_round(((100 * satis_) / ilk_) - 100);
	}
	else
	{
		oran_ = wrk_round(((100 * satis_) / ilk_) - 100);
	}
	
	document.getElementById('STANDART_SATIS_PRICE_RATE_' + product_id).value = '% ' + commaSplit(oran_);
	return true;
}

function duzenle_first_sales_std(product_id,type)
{
	document.getElementById('READ_FIRST_SATIS_PRICE_' + product_id).value = commaSplit(document.getElementById('READ_FIRST_SATIS_PRICE_' + product_id).value,4);
	document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + product_id).value = commaSplit(document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + product_id).value,4);
	//document.getElementById('product_price_change_' + product_id).value = '1';

	document.getElementById('fiyat_div_a_' + product_id).style.display = 'inline-block';
	document.getElementById('fiyat_div_p_' + product_id).style.display = 'none';
}

function hesapla_first_sales_stock(product_id,stock_id,type)
{
	kdv_ = parseFloat(document.getElementById('STANDART_SATIS_KDV_' + product_id).innerHTML);
	
	satis_ = document.getElementById('FIRST_SATIS_PRICE_' + product_id + '_' + stock_id).value;
	satis_kdv_ = document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id + '_' + stock_id).value;
	
	if(type == '0')
	{
		satis_ = satis_ + '';

		if(satis_.indexOf(",") > 0)
			satis_ = parseFloat(filterNum(satis_));
		
		kdv_li_deger_ = parseFloat(wrk_round(satis_ * ((100 + kdv_) /100)));
		document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id + '_' + stock_id).value = kdv_li_deger_;
	}
	if(type == '1')
	{
		satis_kdv_ = satis_kdv_ + '';

		if(satis_kdv_.indexOf(",") > 0)
			satis_kdv_ = parseFloat(filterNum(satis_kdv_));

		kdvsiz_deger_ = parseFloat(wrk_round(satis_kdv_ * ((100 - kdv_) / 100)));
		satis_ = kdvsiz_deger_;
		document.getElementById('FIRST_SATIS_PRICE_' + product_id + '_' + stock_id).value = kdvsiz_deger_;
	}
	if(type == '2')
	{
		satis_ = satis_ + '';

		if(satis_.indexOf(",") > 0)
			satis_ = parseFloat(filterNum(satis_));
		
		kdv_li_deger_ = parseFloat(wrk_round(satis_ * ((100 + kdv_) /100)));
		document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id + '_' + stock_id).value = kdv_li_deger_;
		document.getElementById('FIRST_SATIS_PRICE_' + product_id + '_' + stock_id).value = satis_;

		duzenle_first_sales_stock(product_id,stock_id,'2');
	}
	return true;
}



function duzenle_first_sales_stock(product_id,stock_id,type)
{
	document.getElementById('FIRST_SATIS_PRICE_' + product_id + '_' + stock_id).value = commaSplit(document.getElementById('FIRST_SATIS_PRICE_' + product_id + '_' + stock_id).value);
	document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id + '_' + stock_id).value = commaSplit(document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id + '_' + stock_id).value);
}

function hesapla_marj_fiyat(product_id)
{
	deger_ = parseFloat(document.getElementById('p_marj_' + product_id).value);
	son_maliyet = parseFloat(document.getElementById('READ_FIRST_SATIS_PRICE_' + product_id).value);
	
	yeni_deger_ = son_maliyet + (son_maliyet*(deger_/100));
	
	document.getElementById('SATIS_PRICE_' + product_id).value = commaSplit(yeni_deger_);
}

row_count_ = parseInt('<cfoutput>#get_products.recordcount#</cfoutput>');

function set_down_object(grup_ad,grup_info,alan_ad)
{
	alan = document.getElementById(alan_ad).value;
	rel_ = grup_ad + "='" + grup_info + "'";
	col1 = $("input[" + rel_ + "]");
	col1.val(alan);
}

function hesapla_koli(adet_alan,koli_alan,multi_alan)
{
	alan = document.getElementById(adet_alan);
	deger_ilk_ = filterNum(alan.value);
 	try
	{
		m_ = document.getElementById(multi_alan).innerHTML;
		<cfif attributes.koli_type eq 1>
			yeni_deger_ = parseInt(deger_ilk_ / m_);
			yeni_deger_ = yeni_deger_ + 1;
		<cfelseif attributes.koli_type eq 0>
			yeni_deger_ = parseInt(deger_ilk_ / m_);
		<cfelse>
			yeni_deger_ = wrk_round(deger_ilk_ / m_);
		</cfif>
		document.getElementById(koli_alan).value = yeni_deger_;
	}
	catch(e)
	{
	//	
	}
}

function hesapla_adet(adet_alan,koli_alan,multi_alan)
{
	alan = document.getElementById(koli_alan);
	deger_ilk_ = filterNum(alan.value);
	m_ = document.getElementById(multi_alan).innerHTML;
	
	document.getElementById(adet_alan).value = deger_ilk_ * m_;
	document.getElementById(check).checked = true;
	
}
function checked_true(check)
{
	document.getElementById(check).checked = true;	
}

function duzenle_adet_koli(adet_alan,koli_alan,multi_alan,fiyat_alan,fiyat_alan_kdvli,tutar_alan,tutar_alan_kdvli,action_type,action_id)
{
	alan = document.getElementById(adet_alan);
	
	miktar_ = alan.value;
	fiyat_ = document.getElementById(fiyat_alan).innerHTML;
	fiyat_kdvli_ = document.getElementById(fiyat_alan_kdvli).innerHTML;
	
	if(alan.value.indexOf(",") > 0)
	{
		alan.value = parseFloat(filterNum(alan.value));
	}
	else
	{
		alan.value = alan.value;	
	}
	
	
	if(fiyat_.indexOf(",") > 0)
	{
		fiyat_ = parseFloat(filterNum(fiyat_));
	}
	else
	{
		fiyat_ = fiyat_;	
	}
	
	if(fiyat_kdvli_.indexOf(",") > 0)
	{
		fiyat_kdvli_ = parseFloat(filterNum(fiyat_kdvli_));
	}
	else
	{
		fiyat_kdvli_ = fiyat_kdvli_;	
	}


	if(miktar_.indexOf(",") > 0)
	{
		miktar_ = parseFloat(filterNum(alan.value));
	}
	else
	{
		miktar_ = alan.value;
	}
	
	document.getElementById(tutar_alan).innerHTML = commaSplit(miktar_ * fiyat_);
	document.getElementById(tutar_alan_kdvli).innerHTML = commaSplit(miktar_ * fiyat_kdvli_);
	
	alan.value = commaSplit(alan.value);
	
	try
	{
		alan = document.getElementById(koli_alan);
		alan.value = commaSplit(alan.value);
	}
	catch(e)
	{

	//	
	}
	
	if(action_type == '0')
	{
		if(list_len(document.getElementById('product_stock_list_' + action_id).value) == 1 && list_len(document.getElementById('department_id_list').value) == 1)
		{
			set_down_object('product_group_name',adet_alan,adet_alan);
			set_down_object('product_group_name',koli_alan,koli_alan);
			
			set_down_object('product_group_name','STOCK_SATIS_AMOUNT_TUTAR_' + action_id,'STOCK_SATIS_AMOUNT_TUTAR_' + action_id);
			set_down_object('product_group_name','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_' + action_id,'STOCK_SATIS_AMOUNT_TUTAR_KDVLI_' + action_id);
			
			set_down_object('product_group_name','STOCK_SATIS_AMOUNT_TUTAR_2_' + action_id,'STOCK_SATIS_AMOUNT_TUTAR_2_' + action_id);
			set_down_object('product_group_name','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_' + action_id,'STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_' + action_id);
		}
	}	
}


function set_down_startdate()
{
	secililer = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			document.getElementById('startdate_' + product_id_).value = document.getElementById('startdate').value;
		}
	}
}

function set_down_p_ss_marj()
{
	secililer = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			document.getElementById('p_ss_marj_' + product_id_).value = document.getElementById('p_ss_marj_all').value;
			hesapla_first_sales(product_id_,'3');
		}
	}
}

function set_down_s_profit()
{
	secililer = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			document.getElementById('s_profit_' + product_id_).value = document.getElementById('s_profit').value;
			hesapla_first_sales_std(product_id_,'3');
		}
	}
}

function set_down_s_profit_real()
{
	secililer = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			document.getElementById('s_profit_' + product_id_).value = document.getElementById('s_profit_p_' + product_id_).innerHTML;
			hesapla_first_sales_std(product_id_,'3');
		}
	}
}

function set_down_finishdate()
{
	secililer = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			document.getElementById('finishdate_' + product_id_).value = document.getElementById('finishdate').value;
		}
	}
}

function set_down_std_p_startdate()
{
	secililer = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			document.getElementById('std_p_startdate_' + product_id_).value = document.getElementById('std_p_startdate').value;			
		}
	}
}

function set_down_std_s_startdate()
{
	secililer = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			document.getElementById('std_s_startdate_' + product_id_).value = document.getElementById('std_s_startdate').value;
		}
	}
}

function set_down_p_startdate()
{
	secililer = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			document.getElementById('p_startdate_' + product_id_).value = document.getElementById('p_startdate').value;
			if(document.getElementById('is_sdate_all').checked == true)
			{
			document.getElementById('startdate_' + product_id_).value = document.getElementById('p_startdate').value;
			}
		}
	}
}

function set_down_p_finishdate()
{
	secililer = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			document.getElementById('p_finishdate_' + product_id_).value = document.getElementById('p_finishdate').value;
			if(document.getElementById('is_fdate_all').checked == true)
			{
			document.getElementById('finishdate_' + product_id_).value = document.getElementById('p_finishdate').value;
			}
		}
	}
}

function set_down_price_type_upper()
{
	secililer = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			document.getElementById('price_type_' + product_id_).value = document.getElementById('price_type_upper').value;
		}
	}
}

function get_stock_list(id_,type)
{
	if (arguments[0]==null)
	{
		old_ = document.getElementById('last_active_row').value;
		if(old_ == '')
		{
			alert('Aktif Satır Yok!');
			return false;	
		}		
		adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_product_stocks&product_id=' + old_;		
		if(document.getElementById('last_active_stock').value != '')
		{			
			adres_ += '&stock_id=' + document.getElementById('last_active_stock').value;	
			document.getElementById('last_active_stock').value = '';
		}
		if(document.getElementById('last_active_dept').value != '')
		{
			adres_ += '&department_id=' + document.getElementById('last_active_dept').value;
			document.getElementById('last_active_dept').value = '';
		}
				windowopen(adres_,'page_display');		
	}
	else
	{
		if(type=='product')
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_product_stocks&&product_id=' + id_,'page_display');
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_product_stocks&stock_id=' + id_,'page_display');			
	}
}

function get_cost_list()
{
	if (arguments[0]==null)
	{
		old_ = document.getElementById('last_active_row').value;
		old_sid_ = document.getElementById('last_active_stock').value;
		if(old_sid_ == '')
		{
			alert('Aktif Satır Yok!');
			return false;	
		}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_detail_product_cost&product_id=' + old_+'&stock_id='+old_sid_,'list');
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_detail_product_cost&product_id=' + arguments[0]+'&stock_id='+arguments[1],'list');
	}
}


function get_product_detail()
{
	if (arguments[0]==null)
	{
		old_ = document.getElementById('last_active_row').value;
		if(old_ == '')
		{
			alert('Aktif Satır Yok!');
			return false;	
		}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid=' + old_,'list');
	}
	else
	{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid=' + arguments[0],'list');
	}
}


function get_product_kare_bedeli()
{
	old_ = document.getElementById('last_active_row').value;
	if(old_ == '')
	{
		alert('Aktif Satır Yok!');
		return false;	
	}
	table_code_ = document.getElementById('table_code').value;
	table_secret_code_ = document.getElementById('table_secret_code').value;
	company_id_ = document.getElementById('company_id_' + old_).value;
	project_id_ = document.getElementById('project_id_' + old_).value;
	comp_ = document.getElementById('company_name_' + old_).value;
	windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_make_process_action&table_code=</cfoutput>'+table_code_+'&table_secret_code=' + table_secret_code_+'&company_id=' + company_id_+'&project_id=' + project_id_+'&company_name='+comp_,'wwide1');
}

function get_product_detail_send()
{
	if (arguments[0]==null)
	{
		old_ = document.getElementById('last_active_row').value;
		if(old_ == '')
		{
			alert('Aktif Satır Yok!');
			return false;	
		}
		window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=product.form_upd_product&pid=' + old_,'list');
	}
	else
	{
	window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=product.form_upd_product&pid=' + arguments[0],'list');
	}
}

function get_product_price_detail()
{
	if (arguments[0]==null)
	{
		old_ = document.getElementById('last_active_row').value;
		if(old_ == '')
		{
			alert('Aktif Satır Yok!');
			return false;	
		}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_detail_product_price&pid=' + old_,'wide2');
	}
	else
	{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_detail_product_price&pid=' + arguments[0],'wide2');
	}
}

function get_product_relateds()
{
	old_ = document.getElementById('last_active_row').value;
	if(old_ == '')
	{
		alert('Aktif Satır Yok!');
		return false;	
	}
	ajaxwindow('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.emptypopup_detail_product_others&pid=' + old_,'wwide2','product_others','Muadil Ürünler');
}

function get_product_stock_row(p_id)
{
	rel_ = "product='p_" + p_id + "'";
	col1 = $("#manage_table tr[" + rel_ + "]");

	col1.show();
	
	$('#p_image_' + p_id).hide();
	$('#p_image2_' + p_id).show();
}

function open_all_rows()
{
	urun_list_ = document.getElementById('all_product_list').value;
	uzunluk_ = list_len(urun_list_);
	
	for (var m=1; m <= uzunluk_; m++)
	{
		p_id = list_getat(urun_list_,m);
		
		rel_ = "product='p_" + p_id + "'";
		col1 = $("#manage_table tr[" + rel_ + "]");
	
		col1.toggle();
		
		$('#p_image_' + p_id).toggle();
		$('#p_image2_' + p_id).toggle();
	}	
}

function get_out_product_stock_row(p_id)
{
	rel_ = "product='p_" + p_id + "'";
	col1 = $("#manage_table tr[" + rel_ + "]");

	col1.hide();
	
	$('#p_image_' + p_id).show();
	$('#p_image2_' + p_id).hide();
}

function get_rival_price_list()
{
	if (arguments[0]==null)
	{
		old_ = document.getElementById('last_active_row').value;
		if(old_ == '')
		{
			alert('Aktif Satır Yok!');
			return false;	
		}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_detail_rival_prices&pid=' + old_,'list');
	}
	else
	{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_detail_rival_prices&pid=' + arguments[0],'list');
	}
}


function get_row_active(prod_id)
{
	old_ = document.getElementById('last_active_row').value;
	document.getElementById('last_active_row').value = prod_id;
	
	if(old_ != '' && old_ != prod_id)
	{
	get_row_passive(old_);

	document.getElementById('product_row_' + prod_id).style.backgroundColor = '#ADFF2F';
	rel_ = "row_code='p_row_" + prod_id + "'";
	col1 = $("#manage_table tr[" + rel_ + "] td");
	col1.css("background-color","#ADFF2F");
	}
	else if(old_ != '' && old_ == prod_id)
	{
	//document.getElementById('last_active_row').value = '';
	//document.getElementById('product_row_' + old_).className = 'color-list';
	}
	else
	{
	document.getElementById('product_row_' + prod_id).style.backgroundColor = '#ADFF2F';
	rel_ = "row_code='p_row_" + prod_id + "'";
	col1 = $("#manage_table tr[" + rel_ + "] td");
	col1.css("background-color","#ADFF2F");
	}
}

function get_row_passive(prod_id)
{
	document.getElementById('product_row_' + prod_id).style.backgroundColor = '';
	rel_ = "row_code='p_row_" + prod_id + "'";
	col1 = $("#manage_table tr[" + rel_ + "] td");
	col1.css("background-color","");
}

function discount_calc(prod_id,val)
{
	if(document.getElementById('SATIS_PRICE_'+prod_id) != undefined)
	{	
	   my_val = parseFloat(filterNum(document.getElementById('SATIS_LIST_PRICE_'+prod_id).innerHTML)) ;
	   dis1 = document.getElementById('discount1_'+prod_id).value;
	   dis2 = document.getElementById('discount2_'+prod_id).value;
	   dis3 = document.getElementById('discount3_'+prod_id).value;
	   dis4 = document.getElementById('discount4_'+prod_id).value;
	   dis5 = document.getElementById('discount5_'+prod_id).value;
	   if(dis1!=0)
	   		 my_val = my_val - (my_val*dis1/100);	
	   if(dis2!=0)
	         my_val = my_val - (my_val*dis2/100);	
	   if(dis3!=0)
	   		 my_val = my_val - (my_val*dis3/100);	
	   if(dis4!=0)
	   		 my_val = my_val - (my_val*dis4/100);	
	   if(dis5!=0)
	   		 my_val = my_val - (my_val*dis5/100);	
		document.getElementById('SATIS_PRICE_'+prod_id).value = commaSplit(my_val,4);

		alan1 = prod_id;
		alan2 = 'FIRST_SATIS_PRICE_' + prod_id;
		alan3 = 'NEW_ALIS_' + prod_id;
		alan4 = 'p_ss_marj_' + prod_id;
		hesapla_sales_discount_to_price(alan1,alan2,alan3,alan4);
	}
}

function p_discount_calc(product_id,val)
{
	if(document.getElementById('NEW_ALIS_'+product_id) != undefined)
	{
		kdv_ = parseFloat(filterNum(document.getElementById('NEW_ALIS_KDVLI_'+product_id).value));
		alis_kdv = parseInt(document.getElementById('STANDART_ALIS_KDV_'+product_id).innerHTML);
		base_deger_ = parseFloat(filterNum(document.getElementById('NEW_ALIS_START_'+product_id).value));
		indirim_kolon = document.getElementById('sales_discount_' + product_id).value;
		
		indirim_kolon = indirim_kolon + '';
		if(indirim_kolon.indexOf("+") > 0)
		{
			eleman_sayisi = list_len(indirim_kolon,'+');
			for (var m=1; m <= eleman_sayisi; m++)
			{
				dis1 = list_getat(indirim_kolon,m,'+');
				dis1 = filterNum(dis1,4);
				base_deger_ = base_deger_ - (base_deger_*dis1/100);	
			}
		}
		else
		{
			dis1 = indirim_kolon;
			dis1 = filterNum(dis1,4);
			base_deger_ = base_deger_ - (base_deger_*dis1/100);	
		}	
		
		if(document.getElementById('p_discount_manuel_'+product_id).value != '')
		{
			manuel_ = parseFloat(filterNum(document.getElementById('p_discount_manuel_'+product_id).value,4));
			base_deger_ = base_deger_ - manuel_;
		}
		base_deger_ = wrk_round(base_deger_,4);
		
		document.getElementById('NEW_ALIS_'+product_id).value = commaSplit(base_deger_,4);
		document.getElementById('NEW_ALIS_KDVLI_'+product_id).value = commaSplit(base_deger_ * (1 + (alis_kdv / 100)),4);
		
		
		alan1 = product_id;
		alan2 = 'FIRST_SATIS_PRICE_' + product_id;
		alan3 = 'NEW_ALIS_' + product_id;
		alan4 = 'p_ss_marj_' + product_id;
		

		hesapla_satis(product_id,'kdvli');
		//hesapla_sales_discount_to_price(alan1,alan2,alan3,alan4);	
	}
}

function std_discount_calc(prod_id,val)
{
	if(document.getElementById('INFO_STANDART_ALIS_'+prod_id) != undefined)
	{	
	   my_val = parseFloat(filterNum(document.getElementById('INFO_STANDART_ALIS_'+prod_id).value)) ;
	   dis1 = document.getElementById('discount1_'+prod_id).value;
	   dis2 = document.getElementById('discount2_'+prod_id).value;
	   dis3 = document.getElementById('discount3_'+prod_id).value;
	   dis4 = document.getElementById('discount4_'+prod_id).value;
	   dis5 = document.getElementById('discount5_'+prod_id).value;
	   if(dis1!=0)
	   		 my_val = my_val - (my_val*dis1/100);	
	   if(dis2!=0)
	         my_val = my_val - (my_val*dis2/100);	
	   if(dis3!=0)
	   		 my_val = my_val - (my_val*dis3/100);	
	   if(dis4!=0)
	   		 my_val = my_val - (my_val*dis4/100);	
	   if(dis5!=0)
	   		 my_val = my_val - (my_val*dis5/100);	
		document.getElementById('INFO_STANDART_ALIS_'+prod_id).value = commaSplit(my_val,4);

		alan1 = prod_id;
		alan2 = 'READ_FIRST_SATIS_PRICE_' + prod_id;
		alan3 = 'INFO_STANDART_ALIS_' + prod_id;
		alan4 = 's_profit_' + prod_id;
		hesapla_sales_discount_to_price_std(alan1,alan2,alan3,alan4);
	}
}

function std_p_discount_calc(product_id,val)
{
	if(document.getElementById('STANDART_ALIS_'+product_id) != undefined)
	{
		kdv_ = parseFloat(filterNum(document.getElementById('STANDART_ALIS_KDVLI_'+product_id).value));
		alis_kdv = parseInt(document.getElementById('STANDART_ALIS_KDV_'+product_id).innerHTML);
		base_deger_ = parseFloat(filterNum(document.getElementById('STANDART_ALIS_'+product_id).value));
		indirim_kolon = document.getElementById('std_sales_discount_' + product_id).value;
		
		indirim_kolon = indirim_kolon + '';
		if(indirim_kolon.indexOf("+") > 0)
		{
			eleman_sayisi = list_len(indirim_kolon,'+');
			for (var m=1; m <= eleman_sayisi; m++)
			{
				dis1 = list_getat(indirim_kolon,m,'+');
				dis1 = filterNum(dis1,4);
				base_deger_ = base_deger_ - (base_deger_*dis1/100);	
			}
		}
		else
		{
			dis1 = indirim_kolon;
			dis1 = filterNum(dis1,4);
			base_deger_ = base_deger_ - (base_deger_*dis1/100);	
		}
		
		
		if(document.getElementById('std_p_discount_manuel_'+product_id).value != '')
		{
			manuel_ = parseFloat(filterNum(document.getElementById('std_p_discount_manuel_'+product_id).value,4));
			base_deger_ = base_deger_ - manuel_;
		}
		base_deger_ = wrk_round(base_deger_,4);
		
		document.getElementById('STANDART_ALIS_LISTE_'+product_id).value = commaSplit(base_deger_,4);
		document.getElementById('STANDART_ALIS_KDVLI_'+product_id).value = commaSplit(base_deger_ * (1 + (alis_kdv / 100)),4);
		
		alan1 = product_id;
		alan2 = 'READ_FIRST_SATIS_PRICE_' + product_id;
		alan3 = 'STANDART_ALIS_LISTE_' + product_id;
		alan4 = 's_profit_' + product_id;
		
		deger_new = parseFloat(filterNum(document.getElementById('STANDART_ALIS_LISTE_'+product_id).value));
		deger_old = parseFloat(filterNum(document.getElementById('INFO_STANDART_ALIS_'+product_id).value));
		
		deger_ortalama_ = commaSplit(wrk_round(100 * deger_new / deger_old) - 100);
		
		document.getElementById('STANDART_ALIS_PRICE_RATE_'+product_id).value = '% ' + deger_ortalama_;
				
		hesapla_standart_satis(product_id,'kdvli');
		//hesapla_sales_discount_to_price_std(alan1,alan2,alan3,alan4);
	}
}

function hesapla_sales_discount_to_price_std(product_id,alan,base_alan,marj_alan)
{
	try
	{
		base_deger_ = parseFloat(filterNum(document.getElementById(base_alan).value));
		marj_deger_ = parseFloat(filterNum(document.getElementById(marj_alan).value));
		
		//base_deger_ = base_deger_ * ((100 + marj_deger_) / 100);
		base_deger_ = base_deger_ / (100 - marj_deger_) * 100;
		
		if(alan == 'READ_FIRST_SATIS_PRICE_' + product_id)
		{
 			document.getElementById(alan).value = base_deger_;
			hesapla_first_sales_std(product_id,'3');
			//duzenle_first_sales_std(product_id);
		}
		else
		{
			document.getElementById(alan).value = commaSplit(base_deger_);
		}
	}
	catch(e)
	{
		//alert('İndirim Alanında Yazım Hatası Var');	
	}
	//return true;	
}

function add_product_discount()
{
	secililer = document.getElementById('all_product_list').value;
	eleman_sayisi = list_len(secililer);
	if(eleman_sayisi==0)
	{
		alert('Seçili Ürün Yok!');	
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
			{
				product_id_ = list_getat(secililer,m);
				if(document.getElementById('discount5_' + product_id_).style.display == 'none' && document.getElementById('discount4_' + product_id_).style.display == '' && document.getElementById('discount2_' + product_id_).style.display == '' && document.getElementById('discount3_' + product_id_).style.display == '')
					{
					document.getElementById('discount5_' + product_id_).style.display = '';	
					}
				if(document.getElementById('discount4_' + product_id_).style.display == 'none' && document.getElementById('discount2_' + product_id_).style.display == '' && document.getElementById('discount3_' + product_id_).style.display == '')
					{
					document.getElementById('discount4_' + product_id_).style.display = '';	
					}
				if(document.getElementById('discount3_' + product_id_).style.display == 'none' && document.getElementById('discount2_' + product_id_).style.display == '')
					{
					document.getElementById('discount3_' + product_id_).style.display = '';
					}
				if(document.getElementById('discount2_' + product_id_).style.display == 'none')
					{
					document.getElementById('discount2_' + product_id_).style.display = '';
					}	
			}
		
		rel_ = "rel='kolon_10'";
		col1 = $("#manage_table tr td[" + rel_ + "]");	
		col1.attr("nowrap","nowrap");
	}
}
function show_hide_coloum(col,type)
{
	//col1 = $("#manage_table tr th:nth-child("+col+"), #manage_table tr td:nth-child("+col+")");
	if(list_find('2,3',col))
	{
		alert('Bu kolonlarda oynama yapamazsınız!');
		document.getElementById('kolon_' + col).checked = true;
		return false;	
	}
	
	rel_ = "rel='kolon_" + col + "'";
	col1 = $("#manage_table tr th[" + rel_ + "]");
	col2 = $("#manage_table tr td[" + rel_ + "]");

	if(type == '1')
		document.getElementById('kolon_' + col).checked = false;

	if(document.getElementById('kolon_' + col).checked == true)
	{
		col1.show();
		col2.show();
		load_info_ = '1';
		deger_ = ',' + col + ',';
		document.getElementById('page_hide_col_list').value = document.getElementById('page_hide_col_list').value.replace(deger_,"");
	}
	else
	{
		col1.hide();
		col2.hide();
		load_info_ = '0';	
		document.getElementById('page_hide_col_list').value += ',' + col + ',';
	}
	
	box_id = 'kolon_' + col;
	this_fuseact = 'retail.speed_manage_product';
	
	adress_ = 'index.cfm?fuseaction=objects.xml_setting_personality';
	adress_ += '&bid=' + box_id;
	adress_ += '&fuse=' + this_fuseact;
	adress_ += '&action_name=unload_body';
	adress_ += '&action_value=' + load_info_;
	AjaxPageLoad(adress_,'speed_action_div');
}

function add_del_product_name(type)
{
	secililer = document.getElementById('selected_product_list').value;
	if(secililer == '')
	{
		alert('Seçili Ürün Yok!');
		return false;	
	}
	
	ek_kelime_ = document.getElementById('add_del_product_name_text').value;
	if(ek_kelime_ == '')
	{
		alert('Koşul Girmediniz!');
		return false;	
	}
	ek_kelime_uzunluk_ = ek_kelime_.length + 1;
	
	
	eleman_sayisi = list_len(secililer);
	
	//bastan sil
	if(type == 'd1')
	{
		ek_deger_ = ' ' + document.getElementById('add_del_product_name_text').value + ' ';
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			deger_ = document.getElementById('product_name_' + product_id_).value;
			yeni_deger = deger_.replace(ek_deger_," ");
			document.getElementById('product_name_' + product_id_).value = yeni_deger;
			
			stoklar_ = document.getElementById('product_stock_list_' + product_id_).value;
			eleman_sayisi_ic = list_len(stoklar_);
			for (var z=1; z <= eleman_sayisi_ic; z++)
			{
				stock_id_ = list_getat(stoklar_,z);
				deger_ = document.getElementById('stock_name_' + product_id_ + '_' + stock_id_).value;
				yeni_deger = deger_.replace(ek_deger_," ");
				document.getElementById('stock_name_' + product_id_ + '_' + stock_id_).value = yeni_deger;
			}
			
		}
	}
	
	//bastan ekle
	if(type == 'a1')
	{
		ek_deger_ = ' ' + document.getElementById('add_del_product_name_text').value;
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			deger_ = document.getElementById('product_name_' + product_id_).value;
			ilk_ = list_getat(deger_,1,' ');
			son_ = ilk_ + ek_deger_;
			yeni_deger = deger_.replace(ilk_,son_);
			document.getElementById('product_name_' + product_id_).value = yeni_deger;
			
			
			stoklar_ = document.getElementById('product_stock_list_' + product_id_).value;
			eleman_sayisi_ic = list_len(stoklar_);
			
			for (var z=1; z <= eleman_sayisi_ic; z++)
			{
				stock_id_ = list_getat(stoklar_,z);
				deger_ = document.getElementById('stock_name_' + product_id_ + '_' + stock_id_).value;
				ilk_ = list_getat(deger_,1,' ');
				son_ = ilk_ + ek_deger_;
				yeni_deger = deger_.replace(ilk_,son_);
				document.getElementById('stock_name_' + product_id_ + '_' + stock_id_).value = yeni_deger;
			}
		}
	}
	
	//sondan sil
	if(type == 'd2')
	{
		ek_deger_ = ' ' + document.getElementById('add_del_product_name_text').value;
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			deger_ = document.getElementById('product_name_' + product_id_).value;
			deger_uzunluk = deger_.length;
			son_karakterler_ = deger_.substring(deger_uzunluk-ek_kelime_uzunluk_,deger_uzunluk);
			if(son_karakterler_ == ek_deger_)
				yeni_deger_ = deger_.substring(0,deger_uzunluk-ek_kelime_uzunluk_);
			else
				yeni_deger_ = deger_;
				
			document.getElementById('product_name_' + product_id_).value = yeni_deger_;
			
			stoklar_ = document.getElementById('product_stock_list_' + product_id_).value;
			eleman_sayisi_ic = list_len(stoklar_);
			for (var z=1; z <= eleman_sayisi_ic; z++)
			{
				stock_id_ = list_getat(stoklar_,z);
				deger_ = document.getElementById('stock_name_' + product_id_ + '_' + stock_id_).value;
				deger_uzunluk = deger_.length;
				son_karakterler_ = deger_.substring(deger_uzunluk-ek_kelime_uzunluk_,deger_uzunluk);
				if(son_karakterler_ == ek_deger_)
					yeni_deger_ = deger_.substring(0,deger_uzunluk-ek_kelime_uzunluk_);
				else
					yeni_deger_ = deger_;
					
				document.getElementById('stock_name_' + product_id_ + '_' + stock_id_).value = yeni_deger_;				
			}
				
		}
	}
	
	//sondan ekle
	if(type == 'a2')
	{
		ek_deger_ = ' ' + document.getElementById('add_del_product_name_text').value;
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(secililer,m);
			deger_ = document.getElementById('product_name_' + product_id_).value;
			yeni_deger = deger_ + ek_deger_;
			document.getElementById('product_name_' + product_id_).value = yeni_deger;
			
			stoklar_ = document.getElementById('product_stock_list_' + product_id_).value;
			eleman_sayisi_ic = list_len(stoklar_);
			for (var z=1; z <= eleman_sayisi_ic; z++)
			{
				stock_id_ = list_getat(stoklar_,z);
				deger_ = document.getElementById('stock_name_' + product_id_ + '_' + stock_id_).value;
				yeni_deger = deger_ + ek_deger_;
				document.getElementById('stock_name_' + product_id_ + '_' + stock_id_).value = yeni_deger;
			}
		}
	}
}

shortcut.add('ctrl+1', function() {
    save_list();
});

shortcut.add('ctrl+2', function() {
    save_layout();
});

shortcut.add('ctrl+3', function() {
    save_list_to_order();
});

/*
shortcut.add('ctrl+4', function() {
    save_list_to_action();
});
*/

shortcut.add('ctrl+5', function() {
    save_list_to_ship();
});

/*
shortcut.add('ctrl+6', function() {
    save_list_to_pre_order();
});
*/

shortcut.add('ctrl+7', function() {
    print_table_layout(document.info_form.table_code.value);
});

shortcut.add('Shift+1', function() {
   get_product_detail();
});

shortcut.add('Shift+2', function() {
    get_stock_list();
});

shortcut.add('Shift+3', function() {
   get_rival_price_list();
});

shortcut.add('Shift+4', function() {
   get_cost_list();
});

shortcut.add('Shift+5', function() {
   get_product_detail_send();
});

shortcut.add('Shift+6', function() {
   get_product_kare_bedeli();
});

shortcut.add('Shift+7', function() {
   get_product_price_detail();
});

shortcut.add('Shift+8', function() {
   get_product_relateds();
});

shortcut.add('alt+1', function() {
   change_p_type('0');
});

shortcut.add('alt+2', function() {
   change_p_type('1');
});

shortcut.add('alt+3', function() {
   change_p_type('2');
});

function change_p_type(type)
{
	g_rel_ = "rel='is_purchase_div'";
	g_col1 = $("#manage_table tr th div[" + g_rel_ + "]");
	g_col2 = $("#manage_table tr td div[" + g_rel_ + "]");
	
	c_rel_ = "rel='is_purchase_c_div'";
	c_col1 = $("#manage_table tr th div[" + c_rel_ + "]");
	c_col2 = $("#manage_table tr td div[" + c_rel_ + "]");
	
	m_rel_ = "rel='is_purchase_m_div'";
	m_col1 = $("#manage_table tr th div[" + m_rel_ + "]");
	m_col2 = $("#manage_table tr td div[" + m_rel_ + "]");
	
	if(type == '0')
	{
		g_col1.show();
		g_col2.show();
		
		c_col1.hide();
		c_col2.hide();
		
		m_col1.hide();
		m_col2.hide();
	}
	else if(type == '1')
	{
		g_col1.hide();
		g_col2.hide();
		
		c_col1.show();
		c_col2.show();
		
		m_col1.hide();
		m_col2.hide();
	}
	else if(type == '2')
	{
		g_col1.hide();
		g_col2.hide();
		
		c_col1.hide();
		c_col2.hide();
		
		m_col1.show();
		m_col2.show();
	}
	document.getElementById('is_purchase_type').value = type;
}


function make_process_action()
{
	table_code_ = document.getElementById('table_code').value;
	table_secret_code_ = document.getElementById('table_secret_code').value;
	windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_make_process_action&table_code=</cfoutput>'+table_code_+'&table_secret_code=' + table_secret_code_,'wwide1');	
}

function list_save_success()
{
	alert('Liste Başarıyla Kaydedildi.');
	hide('speed_action_div');	
}

function save_layout()
{
	var order = $('#manage_table').dragtable('order');
	hide_cols_ = document.getElementById('page_hide_col_list').value;
	
	document.getElementById("message_div_main_header_info").innerHTML = 'Görünümü Kaydet';
	document.getElementById("message_div_main").style.height = 220 + "px";
	document.getElementById("message_div_main").style.width = 300 + "px";
	document.getElementById("message_div_main").style.top = (document.body.offsetHeight-220)/2 + "px";
	document.getElementById("message_div_main").style.left = (document.body.offsetWidth-300)/2 + "px";
	document.getElementById("message_div_main").style.zIndex = 99999;
	
	document.getElementById('message_div_main_body').style.overflowY = 'auto';
	show_hide('message_div_main');
	
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=retail.emptypopup_save_layout&layout_id=#attributes.layout_id#&hide_col_list</cfoutput>=' + hide_cols_ + '&page_col_sort_list=' + order,'message_div_main_body','1');
}

function print_table_layout()
{
	table_code_ = document.info_form.table_code.value;
	if(table_code_ == '')
	{
		alert('Tabloyu Yazdırmadan Önce Kayıt Etmelisiniz!');	
		return false;
	}
	if(document.getElementById('selected_product_list').value == '')
	{
		alert('Yazdırılacak Satırları Seçiniz!');
		return false;	
	}
	adres_ = '<cfoutput>#request.self#?fuseaction=retail.popup_print_layout&search_department_id=#attributes.search_department_id#</cfoutput>';
	adres_ += '&table_code=' + table_code_;
	adres_ += '&product_list=' + document.getElementById('selected_product_list').value;
	windowopen(adres_,'wide');
}

function seller_limit_table(table_code)
{
	if(document.info_form.table_code.value == '')
	{
		alert('Satıcı Limiti Alabilmek İçin Tabloyu Kayıt Etmelisiniz!');
		return false;	
	}
	
	vade_list = '';
	add_stock_list = '';

	
	adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=retail.emptypopup_seller_limit_table';
	adres_ += '&table_code=' + document.info_form.table_code.value;
	adres_ += '&search_startdate=' + document.getElementById('search_startdate').value;
	adres_ += '&search_finishdate=' + document.getElementById('search_finishdate').value;
	ajaxwindow(adres_,'wwide1','seller_limit','Satıcı Limitleri');	
}

function goster_seller_limit_rows(pcat)
{
	rel_ = "row_code='product_cat_" + pcat + "'";
	col1 = $("#manage_table_seller_limit tr[" + rel_ + "]");
	col1.toggle();	
}

function save_list()
{
	if(document.getElementById('all_product_list').value == '')
	{
		alert('Ürün Seçiniz!');
		return false;	
	}
	
	//set_line_numbers();
	
	document.getElementById("message_div_main_header_info").innerHTML = 'Liste Yap';
	document.getElementById("message_div_main").style.height = 220 + "px";
	document.getElementById("message_div_main").style.width = 300 + "px";
	document.getElementById("message_div_main").style.top = (document.body.offsetHeight-220)/2 + "px";
	document.getElementById("message_div_main").style.left = (document.body.offsetWidth-300)/2 + "px";
	document.getElementById("message_div_main").style.zIndex = 99999;
	
	document.getElementById('message_div_main_body').style.overflowY = 'auto';
	show_hide('message_div_main');
	
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=retail.emptypopup_get_list_save_screen</cfoutput>','message_div_main_body','1');
}

function save_list_to_pre_order(type)
{
	document.info_form.target = '';
	
	if(type == '0')
		document.info_form.action = '<cfoutput>#request.self#?fuseaction=retail.emptypopupflush_add_speed_manage_product&update_price_action=0</cfoutput>';
	else if(type == '2')
		document.info_form.action = '<cfoutput>#request.self#?fuseaction=retail.emptypopupflush_add_speed_manage_product&update_price_action=2</cfoutput>';
	else
		document.info_form.action = '<cfoutput>#request.self#?fuseaction=retail.emptypopupflush_add_speed_manage_product&update_price_action=1</cfoutput>';
	
	if(document.getElementById('all_product_list').value == '')
	{
		alert('Ürün Seçiniz!');
		return false;	
	}
	
	liste_ = document.getElementById('all_product_list').value;
	eleman_sayisi = list_len(document.getElementById('all_product_list').value);
	selected_ = '';
	for (var ccm=1; ccm <= eleman_sayisi; ccm++)
	{
		c_row_product = list_getat(liste_,ccm);
		if(document.getElementById('is_selected_' + c_row_product).checked == true)
		{
			if(selected_ == '')
				selected_ = c_row_product;
			else
				selected_ += ',' + c_row_product;
		}
	}
	document.getElementById('selected_product_list').value = selected_;
	
	liste_ = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(document.getElementById('selected_product_list').value);
	for (var ccm=1; ccm <= eleman_sayisi; ccm++)
	{
		c_row_product = list_getat(liste_,ccm);
		if((document.getElementById('finishdate_' + c_row_product).value != '' || document.getElementById('p_finishdate_' + c_row_product).value != '') && document.getElementById('price_type_' + c_row_product).value == '')
		{
			alert(ccm + '. Satır İçin Fiyat Tipi Seçmelisiniz!');
			return false;	
		}
		
		if(document.getElementById('price_type_' + c_row_product).value != '' && (document.getElementById('p_finishdate_' + c_row_product).value != '' ||  document.getElementById('finishdate_' + c_row_product).value != ''))
		{
			if(type == '0' || type == '2')
				if(!set_new_price(c_row_product,0)) return false;
			else
				if(!set_new_price(c_row_product,1)) return false;
		}
	}
	
	liste_ = document.getElementById('selected_product_list').value;
	eleman_sayisi = list_len(document.getElementById('selected_product_list').value);
	for (var ccm=1; ccm <= eleman_sayisi; ccm++)
	{
		c_row_product = list_getat(liste_,ccm);
		
		today_ = '<cfoutput>#dateformat(now(),"dd/mm/yyyy")#</cfoutput>';
		gun_ = parseInt(list_getat(today_,1,'/'));
		ay_ = parseInt(list_getat(today_,2,'/'));
		yil_ = parseInt(list_getat(today_,3,'/'));
		bugun_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
		
		alis_bas_ = document.getElementById('std_p_startdate_' + c_row_product).value.replace(".","/");
		satis_bas_ = document.getElementById('std_s_startdate_' + c_row_product).value.replace(".","/");
		
		if(satis_bas_ != '')
		{
			gun_ = parseInt(list_getat(satis_bas_,1,'/'));
			ay_ = parseInt(list_getat(satis_bas_,2,'/'));
			yil_ = parseInt(list_getat(satis_bas_,3,'/'));
			satis_bas_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
		}
		
		if(alis_bas_ != '')
		{
			gun_ = parseInt(list_getat(alis_bas_,1,'/'));
			ay_ = parseInt(list_getat(alis_bas_,2,'/'));
			yil_ = parseInt(list_getat(alis_bas_,3,'/'));
			alis_bas_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
		}
		
		deger_al_ = document.getElementById('STANDART_ALIS_KDVLI_' + c_row_product).value;
		deger_al_c_ = document.getElementById('C_STANDART_ALIS_KDVLI_' + c_row_product).value;
		
		deger_sat_ = document.getElementById('READ_FIRST_SATIS_PRICE_KDV_' + c_row_product).value;
		deger_sat_c_ = document.getElementById('C_READ_FIRST_SATIS_PRICE_KDV_' + c_row_product).value;
		
		if(document.getElementById('is_active_ss_' + c_row_product).checked == true)
			deger_al_check_ = 1;
		else
			deger_al_check_ = 0;
		
		deger_al_check_c_ = document.getElementById('c_is_active_ss_' + c_row_product).value;
		
		if(deger_al_ != deger_al_c_) // degisiklik var
		{
			if(alis_bas_ == '')
			{
				alert('Standart Alış Tarihi Girmelisiniz!');
				return false;	
			}
			
			if(alis_bas_ != '' && alis_bas_deger_ < bugun_deger_)
			{
				alert('Standart Alış Başlangıç Bugünden Önce Olamaz!');
				return false;	
			}
		}
		
		
		if(deger_al_check_ == 0 && satis_bas_ == '')
		{
			//nothing	
		}
		else
		{
			if(deger_al_check_ != deger_al_check_c_ || deger_sat_ != deger_sat_c_) // degisiklik var
			{
				if(satis_bas_ == '')
				{
					alert('Standart Satış Tarihi Girmelisiniz!');
					return false;	
				}
				
				if(satis_bas_deger_ < bugun_deger_)
				{
					alert('Standart Satış Başlangıç Bugünden Önce Olamaz!');
					return false;	
				}
			}
		}
		if(type == '0' || type == '1')
		{
			document.getElementById('is_active_ss_' + c_row_product).checked = true;	
		}
	}
	
	
	liste_ = document.getElementById('all_product_list').value;
	eleman_sayisi = list_len(document.getElementById('all_product_list').value);
	for (var ccm=1; ccm <= eleman_sayisi; ccm++)
	{
		urun_ = list_getat(liste_,ccm);
		if(list_find(document.getElementById('selected_product_list').value,urun_))
		{
			//nothing	
		}
		else
		{
		rel_ = "p_id='" + urun_ + "'";
		col1 = $("#manage_table tr[" + rel_ + "] td input");
		col1.attr('disabled','disabled');
		
		col2 = $("#manage_table tr[" + rel_ + "] td select");
		col2.attr('disabled','disabled');
		}
	}
	
	popup_name_ = '<cfoutput>tablo_kaydet_#CreateUUID()#</cfoutput>';
	windowopen('','medium',popup_name_)
	document.info_form.target = popup_name_;
	hide('message_div_main');
	document.info_form.submit();
	
	col1 = $("#manage_table tr td input");
	col1.removeAttr('disabled');
	
	col2 = $("#manage_table tr td select");
	col2.removeAttr('disabled');
}

function save_list_to_order()
{
	liste_ = document.getElementById('all_product_list').value;
	eleman_sayisi = list_len(document.getElementById('all_product_list').value);
	selected_ = '';
	for (var ccm=1; ccm <= eleman_sayisi; ccm++)
	{
		c_row_product = list_getat(liste_,ccm);
		if(document.getElementById('is_selected_' + c_row_product).checked == true)
		{
			if(selected_ == '')
				selected_ = c_row_product;
			else
				selected_ += ',' + c_row_product;
		}
	}
	document.getElementById('selected_product_list').value = selected_;
	
	document.info_form.target = '_blank';
	document.info_form.action = '<cfoutput>#request.self#?fuseaction=retail.form_add_order</cfoutput>';
	document.info_form.submit();
}

function save_list_to_ship()
{
	//set_line_numbers();
	document.info_form.target = 'ship_window';
	document.info_form.action = '<cfoutput>#request.self#?fuseaction=retail.form_add_ship</cfoutput>';
	document.info_form.submit();
}

function save_list_to_action()
{
	if(document.getElementById('all_product_list').value == '')
	{
		alert('Ürün Seçiniz!');
		return false;	
	}
	
	liste_ = document.getElementById('all_product_list').value;
	eleman_sayisi = list_len(document.getElementById('all_product_list').value);
	for (var m=1; m <= eleman_sayisi; m++)
	{
		row_product = list_getat(liste_,m);
		if((document.getElementById('finishdate_' + row_product).value != '' || document.getElementById('p_finishdate_' + row_product).value != '') && document.getElementById('price_type_' + row_product).value == '')
		{
			alert(m + '. Satır İçin Fiyat Tipi Seçmelisiniz!');
			return false;	
		}
		
		if(document.getElementById('price_type_' + row_product).value != '')
		{
			set_new_price(row_product);	
		}
	}
	
	popup_name_ = '<cfoutput>tablo_kaydet_#CreateUUID()#</cfoutput>';
	windowopen('','medium',popup_name_)
	document.info_form.target = popup_name_;
	document.info_form.action = '<cfoutput>#request.self#?fuseaction=retail.emptypopupflush_add_speed_manage_product</cfoutput>';
	document.info_form.submit();
}


function change_names()
{
	if(document.getElementById('selected_product_list').value == '')
	{
		alert('Önce Ürün Seçiniz!');
		return false;	
	}
	else
	{
		alert('İsim Değişecek!');
	}
}

function add_product()
{
	<cfoutput>
		adres_ = '#request.self#?fuseaction=retail.popup_add_row_to_speed_manage_product&layout_id=' + document.getElementById('layout_id').value;
		adres_ += '&search_startdate=' + document.getElementById('search_startdate').value;
		adres_ += '&search_finishdate=' + document.getElementById('search_finishdate').value;
		windowopen(adres_,'page','add_product_wind');
		add_product_wind.focus();
	</cfoutput>
}

function add_product_excel()
{
	<cfoutput>
		adres_ = '#request.self#?fuseaction=retail.popup_add_row_to_speed_manage_product_excel&layout_id=' + document.getElementById('layout_id').value;
		adres_ += '&search_startdate=' + document.getElementById('search_startdate').value;
		adres_ += '&search_finishdate=' + document.getElementById('search_finishdate').value;
		windowopen(adres_,'page');
	</cfoutput>
}

function add_row_pop(product_id_,veri)
{
	$('#manage_table').append(veri);

	uzunluk_ = list_len(product_id_);
	
	for (var ss=1; ss <= uzunluk_; ss++)
	{
		product_id = list_getat(product_id_,ss);
		if(product_id != '0')
		{
			if(list_find(document.getElementById('all_product_list').value,product_id) > 0)
			{
				//alert('Aynı Ürünü Tekrar Ekleyemezsiniz!');
				return false;	
			}
			
			wrk_date_image('p_startdate_' + product_id);
			wrk_date_image('p_finishdate_' + product_id);
			wrk_date_image('order_date_1_' + product_id);
			wrk_date_image('order_date_2_' + product_id);
			wrk_date_image('startdate_' + product_id);
			wrk_date_image('finishdate_' + product_id);
			wrk_date_image('std_p_startdate_' + product_id);
			wrk_date_image('std_s_startdate_' + product_id);
			
			
			stock_list = document.getElementById('product_stock_list_' + product_id).value;
			eleman_sayisi = list_len(stock_list);
			
			for (var m=1; m <= eleman_sayisi; m++)
			{
				deger_ = list_getat(stock_list,m);
				wrk_date_image('p_startdate_' + product_id + '_' + deger_);
				wrk_date_image('p_finishdate_' + product_id + '_' + deger_);
				//wrk_date_image('s_order_date_1_' + product_id + '_' + deger_);
				
			
				//wrk_date_image('s_order_date_2_' + product_id + '_' + deger_);
				wrk_date_image('startdate_' + product_id + '_' + deger_);
				wrk_date_image('finishdate_' + product_id + '_' + deger_);
				
				
					dept_list = document.getElementById('department_id_list').value;
				
					dep_sayisi = list_len(dept_list);
					for (var k=1; k <= dep_sayisi; k++)
					{
						dep_ = list_getat(dept_list,k);
						//wrk_date_image('order_date_1_' + product_id + '_' + deger_ + '_' + dep_);
						//wrk_date_image('order_date_2_' + product_id + '_' + deger_ + '_' + dep_);
					}
			}
			
			if(document.getElementById('all_product_list').value == '')
				{
				document.getElementById('all_product_list').value = product_id;
				document.getElementById('all_product_list_row').value = '1';
				}
			else
				{
				document.getElementById('all_product_list').value += ',' + product_id;
				sira_no_ = parseInt(list_len(document.getElementById('all_product_list_row').value)) + 1;
				document.getElementById('all_product_list_row').value += ',' + sira_no_;
				document.getElementById('line_number_' + product_id).value = sira_no_;
				}
		}
	}
}

function add_manage_row(row_product)
{
	sira_ = document.getElementById('line_number_' + row_product).value;
	yeni_sira_ = parseInt(sira_) + 1;
	
	adres_ = '<cfoutput>#request.self#?fuseaction=retail.popup_add_row_to_speed_manage_product</cfoutput>';
	adres_ += '&sira=' + sira_;
	adres_ += '&yeni_sira=' + yeni_sira_;
	adres_ += '&row_product=' + row_product;
	
	windowopen(adres_,'list');
}

function connect_product(row_product)
{
	adres_ = '<cfoutput>#request.self#?fuseaction=retail.popup_connect_product</cfoutput>';
	adres_ += '&product_id=' + row_product;
	windowopen(adres_,'list');	
}


function add_product_row_last(product_id,yeni_siram,old_product_id)
{
	if(list_find(document.getElementById('all_product_list').value,product_id) > 0)
	{
		alert('Ürün Zaten Listede Kayıtlı!\nTekrar Ekleyemezsiniz!');
		return false;	
	}	
	else
	{
		row_count_ = row_count_ + 1;
		
		eleman_sayisi = list_len(document.getElementById('all_product_list').value);
		ilk_deger_ = document.getElementById('all_product_list').value;
		
		for (var m=1; m <= eleman_sayisi; m++)
		{
			deger_ = list_getat(ilk_deger_,m);
			if(parseInt(document.getElementById('line_number_' + deger_).value) >= yeni_sira_)
				document.getElementById('line_number_' + deger_).value = parseInt(document.getElementById('line_number_' + deger_).value) + 1;
		}
		
		document.getElementById('all_product_list').value = document.getElementById('all_product_list').value + ',' + product_id;
		adres = '<cfoutput>#request.self#?fuseaction=retail.emptypopup_add_product_row_last&price_catid=#attributes.price_catid#&search_startdate=#dateformat(attributes.search_startdate,"dd/mm/yyyy")#&search_finishdate=#dateformat(attributes.search_finishdate,"dd/mm/yyyy")#</cfoutput>';
		adres += '&old_product_id=' + old_product_id;
		adres += '&product_id=' + product_id;
		adres += '&yeni_siram=' + yeni_siram;
		AjaxPageLoad(adres,'speed_action_div','1');
	}
}

function del_manage_row(row_product)
{
	rel_ = "product='p_" + row_product + "'";
	col1 = $("#manage_table tr[" + rel_ + "]");	
	
	alan_ = document.getElementById('product_row_' + row_product);
	$(alan_).remove();
	
	col1.remove();
	
	row_count_ = row_count_ - 1;
	
	eleman_sayisi = list_len(document.getElementById('all_product_list').value);
	ilk_deger_ = document.getElementById('all_product_list').value;
	
	
	yeni_liste = '';
	
	for (var m=1; m <= eleman_sayisi; m++)
	{
		deger_ = list_getat(ilk_deger_,m);
		if(deger_ != row_product)
		{
			if(yeni_liste == '')
				yeni_liste = '' + deger_;
			else
				yeni_liste = yeni_liste + ',' + deger_;
		}
	}
	document.getElementById('all_product_list').value = yeni_liste;
	
	silinenler = document.getElementById('delete_product_list').value;
	if(silinenler == '')
		silinenler = '' + row_product;
	else
		silinenler += ',' + row_product;
	document.getElementById('delete_product_list').value = silinenler;
}

function select_row_all()
{
	document.getElementById("message_div_main_header_info").innerHTML = 'Tümünü Seç';
	document.getElementById("message_div_main").style.height = 220 + "px";
	document.getElementById("message_div_main").style.width = 300 + "px";
	document.getElementById("message_div_main").style.top = (document.body.offsetHeight-220)/2 + "px";
	document.getElementById("message_div_main").style.left = (document.body.offsetWidth-300)/2 + "px";
	document.getElementById("message_div_main").style.zIndex = 99999;
	document.getElementById('message_div_main_body').innerHTML = 'Lütfen Bekleyiniz!';
	document.getElementById('message_div_main_body').style.overflowY = 'auto';
	show('message_div_main');
	
	if(document.getElementById('is_selected_all').checked == true)
	{
		if(search_product_list_ != '')
		{
			liste_ = search_product_list_;
			eleman_sayisi = list_len(liste_);
		}
		else
		{
			liste_ = document.getElementById('all_product_list').value;
			eleman_sayisi = list_len(document.getElementById('all_product_list').value);
		}
		
		for (var m=1; m <= eleman_sayisi; m++)
		{
			row_product = list_getat(liste_,m);
			document.getElementById('product_row_' + row_product).className	= 'color-list';
			document.getElementById('is_selected_' + row_product).checked = true;
		}
		document.getElementById('selected_product_list').value = liste_;
	}
	else
	{
		if(search_product_list_ != '')
		{
		liste_ = search_product_list_;
		eleman_sayisi = list_len(liste_);
		}
		else
		{
		liste_ = document.getElementById('all_product_list').value;
		eleman_sayisi = list_len(document.getElementById('all_product_list').value);
		}
		
		
		for (var m=1; m <= eleman_sayisi; m++)
		{
			row_product = list_getat(liste_,m);
			document.getElementById('product_row_' + row_product).className	= 'color-row';
			document.getElementById('is_selected_' + row_product).checked = false;
		}
		document.getElementById('selected_product_list').value = '';	
	}
	hide('message_div_main');
}

function select_is_order_all()
{
	rel_ = "rel_name='is_order_dept'";
	col1 = $("input[" + rel_ + "]");	
	
	if(document.getElementById('is_order_all').checked == true)
	{
		col1.attr('checked',true);
	}
	else
	{
		col1.attr('checked',false);
	}	
}

function select_is_order2_all()
{
	rel_ = "rel_name='is_order2_dept'";
	col1 = $("input[" + rel_ + "]");	
	
	if(document.getElementById('is_order2_all').checked == true)
	{
		col1.attr('checked',true);
	}
	else
	{
		col1.attr('checked',false);
	}	
}

function select_row(row_product)
{
	if(document.getElementById('is_selected_' + row_product).checked == true)
	{
		document.getElementById('product_row_' + row_product).className	= 'color-list';
		if(document.getElementById('selected_product_list').value == '')
			document.getElementById('selected_product_list').value = '' + row_product;
		else
			document.getElementById('selected_product_list').value = document.getElementById('selected_product_list').value + ',' + row_product;
	}
	else
	{
		document.getElementById('product_row_' + row_product).className	= 'color-row';	
		eleman_sayisi = list_len(document.getElementById('selected_product_list').value);
		ilk_deger_ = document.getElementById('selected_product_list').value;
		yeni_liste = '';
		
		for (var m=1; m <= eleman_sayisi; m++)
		{
			deger_ = list_getat(ilk_deger_,m);
			
			if(deger_ != row_product)
				if(yeni_liste == '')
					yeni_liste = '' + deger_;
				else
					yeni_liste = yeni_liste + ',' + deger_;
		}
		document.getElementById('selected_product_list').value = yeni_liste;
	}
}

function check_all_special(main_check,check_names)
{
	if(document.getElementById(main_check).checked == true)
	{
		liste_ = document.getElementById('all_product_list').value;
		eleman_sayisi = list_len(document.getElementById('all_product_list').value);
		for (var m=1; m <= eleman_sayisi; m++)
		{
			row_product = list_getat(liste_,m);
			document.getElementById(check_names + row_product).checked = true;
		}
	}
	else
	{
		liste_ = document.getElementById('all_product_list').value;
		eleman_sayisi = list_len(document.getElementById('all_product_list').value);
		for (var m=1; m <= eleman_sayisi; m++)
		{
			row_product = list_getat(liste_,m);
			document.getElementById(check_names + row_product).checked = false;
		}
	}
}
</script>
</cfif>