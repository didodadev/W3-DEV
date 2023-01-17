<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_departments_search_all" dbtype="query">
	SELECT 
    	*
    FROM 
    	get_departments_search
    WHERE
    	DEPARTMENT_ID NOT IN (#iade_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
    SELECT 
        PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY, 
        PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
    FROM 
        PRODUCT_CAT,
        PRODUCT_CAT_OUR_COMPANY PCO
    WHERE 
        PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
        PCO.OUR_COMPANY_ID = #session.ep.company_id# 
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="GET_PRODUCT_CAT1" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY NOT LIKE '%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="GET_PRODUCT_CAT2" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY LIKE '%.%' AND
        HIERARCHY NOT LIKE '%.%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="GET_PRODUCT_CAT3" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY LIKE '%.%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="get_uretici" datasource="#DSN_dev#">
	SELECT SUB_TYPE_ID,SUB_TYPE_NAME FROM EXTRA_PRODUCT_TYPES_SUBS WHERE TYPE_ID = #uretici_type_id#
</cfquery>

<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("d",-90,bugun_)>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = dateadd("d",-1,bugun_)>
</cfif>

<cfparam name="attributes.order_day" default="15">
<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.uretici" default="">
<cfparam name="attributes.yeter_limit" default="0">
<cfparam name="attributes.yeter_type" default="1">
<cfparam name="attributes.top_stock_price" default="50000">
<cfparam name="attributes.stock_price" default="0">
<cfparam name="attributes.is_from_list" default="0">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.transfer_type" default="0">

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="" method="post" name="search_cash">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <cfinput name="is_from_list" type="hidden" value="#attributes.is_from_list#">
            <cf_box_elements>
                <div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-real_stock">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='61654.Eldeki Stoğu Hesaba Kat'><input type="checkbox" value="1" name="real_stock" id="real_stock" checked/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-way_stock">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='61655.Yoldaki Stoğu Hesaba Kat'><input type="checkbox" value="1" name="way_stock" id="way_stock" checked/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-ship_internal">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='61656.Sevk Emirlerini Hesaba Kat'><input type="checkbox" value="1" name="ship_internal" id="ship_internal" checked/>
                        </label>    
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-add">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=10&op_f_name=add_row</cfoutput>','list');"><i class="fa fa-plus"></i></a> 
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-PRODUCT_CAT_NEW">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61652.Aktarılacak Şube Seçiniz'></label>
                    </div>
                    <div class="form-group" id="item-PRODUCT_CAT_NEW1">
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                            query_name="GET_PRODUCT_CAT1"
                            selected_text="" 
                            name="hierarchy1"
                            option_text="#getLang('','Ana Grup',61641)#" 
                            width="100"
                            height="250"
                            option_name="PRODUCT_CAT_NEW" 
                            option_value="hierarchy"
                            value="#attributes.hierarchy1#">
                            <br />
                            <input type="checkbox" name="cat_in_out1" value="1" <cfif isdefined("attributes.cat_in_out1") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                            <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                        </div>
                    </div>
                    <div class="form-group" id="item-PRODUCT_CAT_NEW2">
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                            query_name="GET_PRODUCT_CAT2"
                            selected_text="" 
                            name="hierarchy2"
                            option_text="#getLang('','Alt Grup ',61642)# 1" 
                            width="100"
                            height="250"
                            option_name="PRODUCT_CAT_NEW" 
                            option_value="hierarchy"
                            value="#attributes.hierarchy2#">
                            <br />
                            <input type="checkbox" name="cat_in_out2" value="1" <cfif isdefined("attributes.cat_in_out2") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                            <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                        </div>
                    </div>
                    <div class="form-group" id="item-PRODUCT_CAT_NEW3">
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                            query_name="GET_PRODUCT_CAT3"
                            selected_text=""  
                            name="hierarchy3"
                            option_text="#getLang('','Alt Grup ',61642)# 2" 
                            width="100"
                            height="250"
                            option_name="PRODUCT_CAT_NEW" 
                            option_value="hierarchy"
                            value="#attributes.hierarchy3#">
                            <br />
                            <input type="checkbox" name="cat_in_out3" value="1" <cfif isdefined("attributes.cat_in_out3") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                            <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-SUB_TYPE_NAME">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58202.Üretici'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                            query_name="get_uretici"  
                            name="uretici"
                            option_text="#getLang('','Üretici',58202)#" 
                            width="180"
                            option_name="SUB_TYPE_NAME" 
                            option_value="SUB_TYPE_ID"
                            value="#attributes.uretici#">
                        </div>
                    </div>
                    <div class="form-group" id="item-transfer_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='36085.Aktarım Tipi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="transfer_type">
                                <option value="0" <cfif attributes.transfer_type eq 0>selected</cfif>><cf_get_lang dictionary_id='61657.Ortalama Satışa Göre Dağıt'>
                                <option value="1" <cfif attributes.transfer_type eq 1>selected</cfif>><cf_get_lang dictionary_id='61658.Dağılım İsteğine Göre Dağıt'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-department_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61659.Aktarım Şube'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif attributes.is_from_list eq 1>
                                <cfinput type="hidden" value="#attributes.department_id#" name="department_id">
                                <cfquery name="get_name" dbtype="query">
                                    SELECT DEPARTMENT_HEAD FROM get_departments_search WHERE DEPARTMENT_ID = #attributes.department_id#
                                </cfquery>
                                <input type="text" style="width:180px;" value="<cfoutput>#get_name.DEPARTMENT_HEAD#</cfoutput>" readonly>
                            <cfelse>
                                <cfselect name="department_id" style="width:180px;">
                                    <option value=""><cf_get_lang dictionary_id='61861.Aktarım Şube Seçiniz'></option>
                                    <cfoutput query="get_departments_search">
                                        <option value="#department_id#">#department_head#</option>
                                    </cfoutput>
                                </cfselect>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-get_transfer_depts">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61660.Dağılım Yapılacak Şubeler'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif attributes.is_from_list eq 1>
                                <cfquery name="get_transfer_depts" datasource="#dsn_dev#">
                                    SELECT DISTINCT 
                                        SIT.TO_DEPARTMENT_ID
                                    FROM
                                        STOCK_TRANSFER_LIST SIT
                                    WHERE
                                        SIT.DEPARTMENT_ID = #attributes.department_id#
                                </cfquery>
                                <cf_multiselect_check 
                                    query_name="get_departments_search_all"  
                                    name="search_department_id"
                                    option_text="#getLang('','Departman',35449)#" 
                                    width="180"
                                    option_name="department_head" 
                                    option_value="department_id"
                                    value="#valuelist(get_transfer_depts.TO_DEPARTMENT_ID)#">
                            <cfelse>
                                <cf_multiselect_check 
                                    query_name="get_departments_search_all"  
                                    name="search_department_id"
                                    option_text="#getLang('','Departman',35449)#" 
                                    width="180"
                                    option_name="department_head" 
                                    option_value="department_id"
                                    value="#valuelist(get_departments_search.department_id)#">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-top_stock_price">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61663.Tutar Ürün Sayısı'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="top_stock_price" id="top_stock_price" class="moneybox" style="width:50px;" value="#tlformat(attributes.top_stock_price,0)#" onkeyup="return(FormatCurrency(this,event,0));">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-order_day">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61661.Hedef Ş. Hesaplama Günü'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="order_day" id="order_day" style="width:30px;" value="#attributes.order_day#" maxlength="3">
                        </div>
                    </div>
                    <div class="form-group" id="item-yeter_limit">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61664.Kaynak Ş. Yeter Günü'></label>
                        <div class="col col-4 col-sm-12">
                            <cfinput type="text" name="yeter_limit" id="yeter_limit" style="width:30px;" value="#attributes.yeter_limit#" maxlength="3">
                        </div>
                        <div class="col col-4 col-sm-12">
                            <select name="yeter_type">
                                <!--- <option value="0" <cfif attributes.yeter_type eq 0>selected</cfif>>ve Altı --->
                                <option value="1" <cfif attributes.yeter_type eq 1>selected</cfif>><cf_get_lang dictionary_id='61665.ve Üstü'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-search_startdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="search_startdate" maxlength="10" value="#dateformat(attributes.search_startdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="search_startdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-search_finishdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="search_finishdate" maxlength="10" value="#dateformat(attributes.search_finishdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="search_finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-stock_price">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61662.Stok Tutar'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="stock_price" id="stock_price" class="moneybox" style="width:75px;" value="#tlformat(attributes.stock_price,0)#" onkeyup="return(FormatCurrency(this,event,0));">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_wrk_search_button button_type="4" is_excel="0" search_function="input_kontrol()">
            </cf_box_footer>
            <div id="product_div"></div>
        </cfform>
    </cf_box>
</div>
<script>
function add_row(sid_,pname_,psales_)
{
	icerik_ = '<div id="selected_product_' + sid_ + '">';
	icerik_ += '<a href="javascript://" onclick="del_row_p(' + sid_ +')">';
	icerik_ += '<img src="/images/delete_list.gif">';
	icerik_ += '</a>';
	icerik_ += '<input type="hidden" name="search_stock_id" value="' + sid_ + '">';
	icerik_ += pname_;
	icerik_ += '</div>';
	
	$('#product_div').append(icerik_);
}

function del_row_p(sid_)
{
	$("#selected_product_" + sid_).remove();	
}

function input_kontrol()
{
	deger_on = document.getElementById('department_id').value;
	if(deger_on == '')
	{
		alert('Aktarım Yapılacak Şube Seçmelisiniz!');
		return false;
	}
	
	deger_ = $('#search_department_id').val();
	if(deger_ == '' || deger_ == null)
	{
		alert('En Az Bir Adet Dağılım Şube Seçmelisiniz!');
		return false;	
	}
	
	if(deger_on == deger_)
	{
		alert('Aktarım Şube İle Dağılım Şube Aynı Olamaz!');
		return false;
	}
	return true;
}
</script>
<cfif attributes.is_from_list eq 1>
    <cfquery name="get_transfer_products" datasource="#dsn_dev#">
    	SELECT DISTINCT 
        	S.STOCK_ID,
            S.PROPERTY
        FROM 
        	#dsn3_alias#.STOCKS S,
            STOCK_TRANSFER_LIST SIT
        WHERE
        	SIT.DEPARTMENT_ID = #attributes.department_id# AND
            SIT.STOCK_ID = S.STOCK_ID
    </cfquery>
    <CFOUTPUT query="get_transfer_products">
    	<script>
			add_row('#stock_id#','#PROPERTY#',0);
		</script>
    </CFOUTPUT>
</cfif>