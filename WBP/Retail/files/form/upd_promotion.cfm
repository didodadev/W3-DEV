<cfquery name="get_promotion" datasource="#dsn_Dev#">
	SELECT * FROM MARKET_PROMOTIONS WHERE PROMOTION_ID = #attributes.promotion_id#
</cfquery>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#merkez_depo_id#,#iade_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_card_types" datasource="#dsn_dev#">
    	SELECT 
            1 AS ROW_NUMBER,
            -1 AS TYPE_ID,
            'Tüm Müşteriler' AS TYPE_NAME
    UNION
        SELECT 
            2 AS ROW_NUMBER,
            -2 AS TYPE_ID,
            'Kart Müşterileri' AS TYPE_NAME
    UNION
        SELECT 
            3 AS ROW_NUMBER,
            -3 AS TYPE_ID,
            'Kartsız Müşteriler' AS TYPE_NAME
	UNION
        SELECT 
            4 AS ROW_NUMBER,
            TYPE_ID,
            TYPE_NAME
        FROM 
            CARD_TYPES
        WHERE
            TYPE_STATUS = 1
        ORDER BY 
            ROW_NUMBER,
            TYPE_NAME
</cfquery>

<cfquery name="get_product_types" datasource="#dsn_dev#">
	SELECT * FROM EXTRA_PRODUCT_TYPES WHERE TYPE_STATUS = 1 AND TYPE_ID IN (3,4,11) ORDER BY TYPE_NAME
</cfquery>

<cfset dept_list = "">
<cfset type_list = "">

<cfquery name="get_depts" datasource="#dsn_dev#">
	SELECT * FROM MARKET_PROMOTIONS_DEPARTMENTS WHERE PROMOTION_ID = #attributes.promotion_id#
</cfquery>
<cfif get_depts.recordcount>
	<cfset dept_list = valuelist(get_depts.department_id)>
</cfif>

<cfquery name="get_types" datasource="#dsn_dev#">
	SELECT * FROM MARKET_PROMOTIONS_MEMBER_TYPES WHERE PROMOTION_ID = #attributes.promotion_id#
</cfquery>
<cfif get_types.recordcount>
	<cfset type_list = valuelist(get_types.MEMBER_TYPE_ID)>
</cfif>


<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_promotion" action="#request.self#?fuseaction=retail.emptypopup_upd_promotion" method="post">
            <cfinput type="hidden" value="#attributes.promotion_id#" name="promotion_id">
            <cf_box_elements>
                <div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_status">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" value="1" name="promotion_status" <cfif get_promotion.promotion_status eq 1>checked="checked"</cfif>/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_m">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57604.Pazartesi'><input type="checkbox" value="1" <cfif get_promotion.PROMOTION_DAYS contains '1'>checked="checked"</cfif> name="promotion_days"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_t">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57605.Salı'><input type="checkbox" value="2" <cfif get_promotion.PROMOTION_DAYS contains '2'>checked="checked"</cfif> name="promotion_days"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_w">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57606.Çarşamba'><input type="checkbox" value="3" <cfif get_promotion.PROMOTION_DAYS contains '3'>checked="checked"</cfif> name="promotion_days"/> 
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_th">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57607.Perşembe'><input type="checkbox" value="4" <cfif get_promotion.PROMOTION_DAYS contains '4'>checked="checked"</cfif> name="promotion_days"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_f">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57608.Cuma'><input type="checkbox" value="5" <cfif get_promotion.PROMOTION_DAYS contains '5'>checked="checked"</cfif> name="promotion_days"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_s">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57609.Cumartesi'><input type="checkbox" value="6" <cfif get_promotion.PROMOTION_DAYS contains '6'>checked="checked"</cfif> name="promotion_days"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_sun">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57610.Pazar'> <input type="checkbox" value="7" <cfif get_promotion.PROMOTION_DAYS contains '7'>checked="checked"</cfif> name="promotion_days"/>
                        </label>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58233.Tanım">*</label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="promotion_head" value="#get_promotion.promotion_head#" required="yes" message="#getLang('','',61637)#">
                        </div>
                    </div>
                    <div class="form-group" id="item-department_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='35449.Departman'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                            query_name="get_departments_search"  
                            name="department_id"
                            option_text="#getLang('','',35449)#" 
                            width="200"
                            height="200"
                            option_name="department_head" 
                            option_value="department_id"
                            value="#dept_list#">
                        </div>
                    </div>
                    <div class="form-group" id="item-type_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31097.Üye Tipi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                            query_name="get_card_types"  
                            name="card_type"
                            option_text="#getLang('','',61782)#" 
                            width="200"
                            option_name="TYPE_NAME" 
                            option_value="type_id"
                            value="#type_list#">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-promotion_status">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="startdate" maxlength="10" value="#dateformat(get_promotion.startdate,'dd/mm/yyyy')#" required="yes" validate="eurodate" message="#getLang('','Tarih Hatalı',47474)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="start_clock" id="start_clock">
                                <cfloop from="7" to="30" index="i">
                                    <cfset saat=i mod 24>
                                    <option value="<cfoutput>#NumberFormat(saat,00)#</cfoutput>" <cfif len(get_promotion.startdate) and timeformat(get_promotion.startdate,'HH') eq saat>selected</cfif>><cfoutput>#NumberFormat(saat,00)#</cfoutput></option>
                                </cfloop>
                            </select>
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="start_minute" id="start_minute">
                                <cfloop from="0" to="59" index="a">
                                    <cfoutput><option value="#Numberformat(a,00)#" <cfif len(get_promotion.startdate) and timeformat(get_promotion.startdate,'MM') eq a>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="finishdate" maxlength="10" value="#dateformat(get_promotion.finishdate,'dd/mm/yyyy')#" required="yes" validate="eurodate" message="#getLang('','Tarih Hatalı',47474)#!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="finish_clock" id="finish_clock">
                                <cfloop from="7" to="30" index="i">
                                    <cfset saat=i mod 24>
                                    <option value="<cfoutput>#NumberFormat(saat,00)#</cfoutput>" <cfif len(get_promotion.finishdate) and timeformat(get_promotion.finishdate,'HH') eq saat>selected</cfif>><cfoutput>#NumberFormat(saat,00)#</cfoutput></option>
                                </cfloop>
                            </select>
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="finish_minute" id="finish_minute">
                                <cfloop from="0" to="59" index="a">
                                    <cfoutput><option value="#Numberformat(a,00)#" <cfif len(get_promotion.finishdate) and timeformat(get_promotion.finishdate,'MM') eq a>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-promotion_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37488.Promosyon Tipi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="promotion_type">
                                <option value="1" <cfif get_promotion.promotion_type eq 1>selected</cfif>>PICK - MIX</option>
                                <option value="2" <cfif get_promotion.promotion_type eq 2>selected</cfif>><cf_get_lang dictionary_id='61488.Ürüne Yüzde veya Tutar İndirimi'></option>
                                <option value="3" <cfif get_promotion.promotion_type eq 3>selected</cfif>><cf_get_lang dictionary_id='61489.Ürüne İki Tarih veya Saat Arasında Yüzde veya Tutar İndirimi'></option>
                                <option value="4" <cfif get_promotion.promotion_type eq 4>selected</cfif>><cf_get_lang dictionary_id='61490.Müşteri Kartına Göre Fiyat Çeşidi Atama'></option>
                                <option value="5" <cfif get_promotion.promotion_type eq 5>selected</cfif>><cf_get_lang dictionary_id='61491.PICK - MIX Hediye Verme'></option>
                            </select>
                        </div>
                    </div>
                </div>
                <cfinput type="hidden" name="rowcount" value="0">
                <cfinput type="hidden" name="rowcount_alt" value="0">
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-promotion_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62948.İndirim Yöntemi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="indirim_type">
                                <option value="1"><cf_get_lang dictionary_id='34453.Yüzde İndirim'></option>
                                <option value="2"><cf_get_lang dictionary_id='34454.Tutar İndirimi'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-promotion_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62947.İndirim Değeri'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="text" name="indirim_deger" id="indirim_deger" class="moneybox" value="0" onkeyup="return(formatcurrency(this,event,2));"/>
                        </div>
                    </div>
                    <div class="form-group" id="item-promotion_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62945.Hediye Verme Yöntemi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="hediye_type">
                                <option value="1"><cf_get_lang dictionary_id='62944.Tüm Hediyeler Verilecek'></option>
                                <option value="2"><cf_get_lang dictionary_id='62943.Gruptan Sadece 1 Tane verilecek'></option>
                                <option value="3"><cf_get_lang dictionary_id='62942.Kazanılan Ürünlerden En Az Bir Tanesi Verilecek'></option>
                                <option value="4"><cf_get_lang dictionary_id='62941.Başka Gruptan Kazanılan Hediyeler Verilecek'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-promotion_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62946.Hediye Ürün'> </label>
                        <div class="col col-8 col-sm-12">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=10&op_f_name=add_row_hediye</cfoutput>','list');"><i class="icn-md fa fa-plus-square"></i></a>
                        </div>
                    </div>
                    <div id="hediye_div"></div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_promotion">
                <cf_workcube_buttons is_upd="1" is_delete="0">
            </cf_box_footer>
        </cfform>
    </cf_box>
    <cf_box>
        <cf_grid_list id="manage_table">
            <thead>
                <th width="20"><a href="javascript://" onclick="satir_ekle();"><i class="fa fa-plus"></i></a></th>
                <th><cf_get_lang dictionary_id='58585.Kod'></th>
                <th><cf_get_lang dictionary_id='57630.Tip'></th>
                <th><cf_get_lang dictionary_id='58233.Tanım'></th>
                <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
            </thead>
        </cf_grid_list>
    </cf_box>
    <cf_box>
        <cf_grid_list id="manage_table_alts">
            <thead>
                <th width="20"><a href="javascript://" onclick="satir_ekle_alt();"><i class="fa fa-plus"></i></a></th>
                <th><cf_get_lang dictionary_id='58585.Kod'></th>
                <th><cf_get_lang dictionary_id='62949.Ürün Havuz İşlem Yöntemi'></th>
                <th><cf_get_lang dictionary_id='62950.Değer Tipi'></th>
                <th><cf_get_lang dictionary_id='62951.Karşılaştırma Yöntemi'></th>
                <th><cf_get_lang dictionary_id='33616.Değer'></th>
                <th><cf_get_lang dictionary_id='62952.Grup No'></th>
            </thead>
        </cf_grid_list>
    </cf_box>
</div>
        	
<script>
function add_row_hediye(pid_,pname_,psales_)
{
	icerik_ = '<div id="hediye_selected_product_' + pid_ + '">';
	icerik_ += '<a href="javascript://" onclick="del_row_p_hediye(' + pid_ +')">';
	icerik_ += '<i class="fa fa-minus"></i>';
	icerik_ += '</a>';
	icerik_ += '<input type="hidden" name="hediye_search_product_id" value="' + pid_ + '">';
	icerik_ += pname_;
	icerik_ += '</div>';
	$("#hediye_div").append(icerik_);
}

function del_row_p_hediye(pid_)
{
	$("#hediye_selected_product_" + pid_).remove();	
}

function satir_ekle()
{
	sira_ = parseInt(document.getElementById('rowcount').value) + 1;
	veri = '<tr id="td_' + sira_ + '">';
	veri += '<td width="20"><a href="javascript://" onclick="satir_sil(' + sira_ + ')"><i class="fa fa-minus"></i></a></td>';
	veri += '<td><div class="form-group"><input type="hidden" name="row_control_' + sira_ + '" id="row_control_' + sira_ + '" value="1"><input type="text" name="row_code_' + sira_ + '" id="row_code_' + sira_ + '" value="' + sira_ + '"></div></td>';
	veri += '<td><div class="form-group"><select name="row_type_' + sira_ + '" id="row_type_' + sira_ + '" onchange="run_row_action(' + sira_ + ');"><option value="-1">Stok</option><option value="-8">Barkod</option><option value="-2">Ana Grup</option><option value="-6">Alt Grup 1</option><option value="-7">Alt Grup 2</option><option value="-3">KDV</option><cfoutput query="get_product_types"><option value="#type_id#">#type_name#</option></cfoutput></select></div></td>';
	veri += '<td><div class="form-group"><div name="row_action_' + sira_ + '" id="row_action_' + sira_ + '"></div></div></td>';
	veri += '<td><div class="form-group"><div name="row_action_detail_' + sira_ + '" id="row_action_detail_' + sira_ + '"></div></div></td>';
	veri += '</td>';
	veri += '</tr>';
	
	document.getElementById('rowcount').value = sira_;
	$('#manage_table').append(veri);
	run_row_action(sira_);
}

function satir_ekle_alt()
{
	if(parseInt(document.getElementById('rowcount').value) == 0)
	{
		alert('Önce Tanım Girmelisiniz!');
		return false;	
	}
	sira_alt_ = parseInt(document.getElementById('rowcount_alt').value) + 1;
	veri = '<tr id="alt_td_' + sira_alt_ + '">';
	veri += '<td width="20"><a href="javascript://" onclick="satir_sil_alt(' + sira_alt_ + ')"><i class="fa fa-minus"></i></a></td>';
	veri += '<td><div class="form-group"><input type="hidden" name="alt_row_control_' + sira_alt_ + '" id="alt_row_control_' + sira_alt_ + '" value="1"><input type="text" name="alt_row_code_' + sira_alt_ + '" id="alt_row_code_' + sira_alt_ + '" value="' + sira_alt_ + '"></div></td>';
	veri += '<td><div class="form-group"><select name="alt_row_type_' + sira_alt_ + '" id="alt_row_type_' + sira_alt_ + '" ><option value="1">Ürün Havuzdan Düşülür Promosyona Dahil Edilir</option><option value="2">Ürün Havuzdan Düşülür Promosyona Dahil Edilmez</option><option value="3">Havuzdan Düşülmez Promosyona Dahil Edilmez</option><option value="4">Ürün Paralel Havuzdan Düşülür Promosyona Dahil Edilmez</option></select></div></td>';
	veri += '<td><div class="form-group"><select name="alt_row_action_type_' + sira_alt_ + '" id="alt_row_action_type_' + sira_alt_ + '"><option value="1">Değer Miktardır</option><option value="2">Değer Tutardır</option></select></div></td>';
	veri += '<td><div class="form-group"><select name="alt_row_compare_type_' + sira_alt_ + '" id="alt_row_compare_type_' + sira_alt_ + '" ><option value="1">Her yada Eşit</option><option value="2">Gruptaki Tüm Ürünler</option></select></div></td>';
	veri += '<td><div class="form-group"><input type="text" name="row_indirim_deger_' + sira_alt_ + ' id="row_indirim_deger_' + sira_alt_ + ' class="moneybox" value="0" onkeyup="return(formatcurrency(this,event,2));"/></td>';
	veri += '<td><div class="form-group"><input type="text" name="row_group_' + sira_alt_ + ' id="row_group_' + sira_alt_ + ' value=""/></div></td>';
	veri += '</td>';
	veri += '</tr>';
	
	document.getElementById('rowcount_alt').value = sira_alt_;
	$('#manage_table_alts').append(veri);	
}
function satir_sil(row_no)
{
	document.getElementById('row_control_' + row_no).value = 0;
	hide('td_' + row_no);
}
function run_row_action(sira_)
{
	div_name_ = 'row_action_' + sira_;
	action = document.getElementById('row_type_' + sira_).value;
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=retail.emptypopup_select_promotion_inner&action_type=' + action + '&row_no=</cfoutput>' + sira_,div_name_,1);
	
	/*div_name_ = 'row_action_detail_' + sira_;
	action = document.getElementById('row_type_' + sira_).value;
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=retail.emptypopup_select_promotion_inner2&action_type=' + action + '&row_no=</cfoutput>' + sira_,div_name_,1);*/
}	
</script>