<cfquery name="GET_ALL_LOCATION" datasource="#dsn#">
	SELECT 
    	D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
        (
            (
            D.IS_STORE IN (1,3) AND
            ISNULL(D.IS_PRODUCTION,0) = 0
            )
            OR
            D.DEPARTMENT_ID = #firin_depo_id#
        ) AND
        D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
    SELECT 
        PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY, 
        PRODUCT_CAT.PRODUCT_CAT,
        PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
    FROM 
        PRODUCT_CAT
    ORDER BY 
        HIERARCHY ASC
</cfquery>
<cfset hierarchy_list = valuelist(GET_PRODUCT_CAT.HIERARCHY)>
<cfset hierarchy_name_list = valuelist(GET_PRODUCT_CAT.PRODUCT_CAT,'╗')>

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

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_form" action="" enctype="multipart/form-data">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-order_date">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" name="order_date" id="order_date" value="#dateformat(now(),'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="order_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-order_detail">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="order_detail" value="" required="yes" message="Sayım Açıklaması Giriniz!" style="width:200px;" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-order_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58770.İşlem Tipi Seçiniz'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="order_type" id="order_type">
                                <option value="0"><cf_get_lang dictionary_id='58430.Kademesiz'></option>
                                <option value="1"><cf_get_lang dictionary_id='58432.Kademeli'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-department_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='35449.Departman'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                                query_name="GET_ALL_LOCATION"  
                                name="department_id"
                                option_text="Departman" 
                                width="200"
                                option_name="department_head" 
                                option_value="department_id"
                                value="#merkez_depo_id#">
                        </div>
                    </div>
                    <div class="form-group" id="item-hierarchy1">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61641.Ana Grup'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                                query_name="GET_PRODUCT_CAT1"
                                selected_text="" 
                                name="hierarchy1"
                                option_text="Ana Grup" 
                                width="200"
                                height="250"
                                option_name="PRODUCT_CAT_NEW" 
                                option_value="hierarchy"
                                value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-hierarchy2">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61642.Alt Grup'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                                query_name="GET_PRODUCT_CAT2"
                                selected_text="" 
                                name="hierarchy2"
                                option_text="Alt Grup" 
                                width="200"
                                height="250"
                                option_name="PRODUCT_CAT_NEW" 
                                option_value="hierarchy"
                                value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-hierarchy3">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61642.Alt Grup'>2</label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                                query_name="GET_PRODUCT_CAT3"
                                selected_text="" 
                                name="hierarchy3"
                                option_text="Alt Grup 2" 
                                width="200"
                                height="250"
                                option_name="PRODUCT_CAT_NEW" 
                                option_value="hierarchy"
                                value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-excel_file">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57691.Dosya'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="file" name="excel_file">
                        </div>
                    </div>
                    <div class="form-group" id="item-stock">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57452.Stok'></label>
                        <div class="col col-8 col-sm-12">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=1</cfoutput>','list');"><img src="/images/plus.gif" /></a>
                            <div id="product_div"></div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons>
            </cf_box_footer>     
        </cfform>
    </cf_box>
</div>


<script>
function add_row(pid_,pname_,psales_)
{
	icerik_ = '<div id="selected_product_' + pid_ + '">';
	icerik_ += '<a href="javascript://" onclick="del_row_p(' + pid_ +')">';
	icerik_ += '<img src="/images/delete_list.gif">';
	icerik_ += '</a>';
	icerik_ += '<input type="hidden" name="search_product_id" value="' + pid_ + '">';
	icerik_ += pname_;
	icerik_ += '</div>';
	
	$('#product_div').append(icerik_);
}
function del_row_p(pid_)
{
	$("#selected_product_" + pid_).remove();	
}

</script>