<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.table_code" default="">
<cfparam name="attributes.table_secret_code" default="">
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

<style>
	#manage_table tr td input
	{
	border:0px none #f1f0ff;
	border-width:0px;
	border-bottom-width:0px;
	background-color:#FF9;
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
</style>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="info_form" id="info_form" method="post" action="">
            <cfinput type="hidden" name="table_code" value="#attributes.table_code#" readonly/>
            <cfinput type="hidden" name="table_secret_code" value="#attributes.table_secret_code#" readonly/>
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58607.Firma'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="company_name" id="company_name" value="#attributes.company_name#" style="width:400px;" required="yes" message="Firma Seçiniz!" readonly/>
                                <cfinput type="hidden" name="company_id" id="company_id" value="#attributes.company_id#" readonly/>
                                <cfinput type="hidden" name="project_id" id="project_id" value="#attributes.project_id#" readonly/>
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_list_manufact_comps&field_project_id=info_form.project_id&field_comp_name=info_form.company_name&field_comp_id=info_form.company_id');"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_wrk_search_button is_excel="1" button_type="1">
            </cf_box_footer>
        </cfform>
    </cf_box>
    <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
        <div id="special_print_area_div" style="display:none;"></div>
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
        
        <cfquery name="get_types" datasource="#dsn_dev#">
            SELECT * FROM SEARCH_TABLE_PROCESS_TYPES ORDER BY TYPE_NAME
        </cfquery>
        
        <cfquery name="get_sub_types" datasource="#dsn_dev#">
            SELECT * FROM EXTRA_PRODUCT_TYPES_SUBS WHERE TYPE_ID = #uretici_type_id# ORDER BY SUB_TYPE_NAME
        </cfquery>
        
        
        <cfquery name="get_rows" datasource="#dsn_dev#">
            SELECT
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                PR.*,
                ISNULL(COST_PAID,0) AS paid_amount,
                STPT.TYPE_NAME,
                D.DEPARTMENT_HEAD
            FROM
                #dsn_alias#.EMPLOYEES E,
                #dsn_alias#.DEPARTMENT D,
                SEARCH_TABLE_PROCESS_TYPES STPT,
                PROCESS_ROWS PR
            WHERE
                <cfif len(attributes.project_id)>
                    PR.PROJECT_ID = #attributes.project_id# AND
                </cfif>
                PR.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                PR.COMPANY_ID = #attributes.company_id# AND
                PR.RECORD_EMP = E.EMPLOYEE_ID AND
                STPT.TYPE_ID = PR.PROCESS_TYPE
           ORDER BY
                   PR.PROCESS_STARTDATE,
                D.DEPARTMENT_HEAD
        </cfquery>
    <cf_box title="#attributes.company_name#" uidrop="1" hide_table_column="1">
        <cfform name="add_pos" id="add_pos" method="post" action="#request.self#?fuseaction=retail.emptypopup_make_process_action">
            <cfinput type="hidden" name="table_code" value="#attributes.table_code#" readonly/>
            <cfinput type="hidden" name="table_secret_code" value="#attributes.table_secret_code#" readonly/>
            <cfinput type="hidden" name="company_id" id="company_id" value="#attributes.company_id#" readonly/>
            <cfinput type="hidden" name="project_id" id="project_id" value="#attributes.project_id#" readonly/>
            <cfinput type="hidden" name="company_name" id="company_name" value="#attributes.company_name#" readonly/>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="15"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                        <th><cf_get_lang dictionary_id='58763.Depo'></th>
                        <th><cf_get_lang dictionary_id='58202.Üretici'></th>
                        <th><cf_get_lang dictionary_id='58233.Tanım'></th>
                        <th><cf_get_lang dictionary_id='58233.Tanım'> 1</th>
                        <th><cf_get_lang dictionary_id='58233.Tanım'> 2</th>
                        <th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
                        <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                        <th><cf_get_lang dictionary_id='58082.Adet'></th>
                        <th><cf_get_lang dictionary_id='58472.Dönem'></th>
                        <th><cf_get_lang dictionary_id='62518.Uyg. Başlangıç'></th>
                        <th><cf_get_lang dictionary_id='62519.Uyg. Bitiş'></th>
                        <th><cf_get_lang dictionary_id='62520.Yapılış'></th>
                        <th><cf_get_lang dictionary_id='57502.Bitiş'></th>
                        <th><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></th>
                        <th><cf_get_lang dictionary_id='62521.Ödendiği Tarih'></th>
                        <th><cf_get_lang dictionary_id='58084.Fiyat'></th>
                        <th><cf_get_lang dictionary_id='58456.Oran'></th>
                        <th><cf_get_lang dictionary_id='57639.KDV'></th>
                        <th><cf_get_lang dictionary_id='57847.Ödeme'></th>
                        <th><cf_get_lang dictionary_id='57589.Bakiye'></th>
                        <th width="15"><i class="fa fa-pencil"></i></th>
                        <th width="15"></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="get_rows">
                    <tr>
                        <td width="15" style="text-align:center;">#currentrow#</td>
                        <td>#dateformat(dateadd("h",session.ep.time_zone,record_date),'dd/mm/yyyy')#</td>
                        <td>#DEPARTMENT_HEAD#</td>
                        <td>
                        <cfif len(uretici_id)>
                            <cfquery name="get_" dbtype="query">
                                SELECT SUB_TYPE_NAME FROM get_sub_types WHERE SUB_TYPE_ID = #uretici_id#
                            </cfquery>
                            <cfif get_.recordcount>
                                #get_.SUB_TYPE_NAME#
                            </cfif>
                        </cfif>
                        </td>
                        <td colspan="3" height:30px;!important>
                            <cfquery name="get_alts" datasource="#dsn_Dev#">
                                SELECT 
                                    PC.HIERARCHY,
                                    PC.PRODUCT_CAT 
                                FROM 
                                    PROCESS_ROWS_CATS PRC,
                                    #DSN1_ALIAS#.PRODUCT_CAT PC
                                WHERE 
                                    PRC.ROW_ID = #ROW_ID# AND
                                    PRC.HIERARCHY = PC.HIERARCHY
                                ORDER BY
                                    PC.HIERARCHY
                            </cfquery>
                            <cfif get_alts.recordcount>
                                <cfloop query="get_alts">
                                    <b>#HIERARCHY#</b> #PRODUCT_CAT#<br />
                                </cfloop>
                            </cfif>
                        </td>
                        <td>#TYPE_NAME#</td>
                        <td>#PROCESS_DETAIL#</td>
                        <td>#QUANTITY#</td>
                        <td>#period#</td>
                        <td>#dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(ACTION_STARTDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(ACTION_FINISHDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(PAYMENT_DATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(PAID_DATE,'dd/mm/yyyy')#</td>
                        <td style="text-align:right;">#tlformat(COST)#</td>
                        <td style="text-align:right;">#revenue_rate#</td>
                        <td>#tax#</td>
                        <td style="text-align:right;">#tlformat(paid_amount)#</td>
                        <td style="text-align:right;"><cfif len(COST)>#tlformat(COST - paid_amount)#</cfif></td>
                        <td width="15"><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=retail.popup_make_process_action&event=upd&row_id=#row_id#');"><i class="fa fa-pencil"></i></a></td>
                        <td width="15"><input type="checkbox" name="row_id_#currentrow#" id="row_id_#currentrow#" value="#row_id#" onclick="print_process_action();"/></td>
                    </tr>
                    </cfoutput>
                    </tbody>
                    <tfoot>
                    <cfloop from="1" to="5" index="ccc">
                    <cfoutput>
                    <tr>
                        <td style="text-align:center;">#get_rows.recordcount + ccc#</td>
                        <td><input type="text" value="#dateformat(now(),'dd/mm/yyyy')#" readonly/></td>
                        <td>
                            <div class="input-group medium">
                                <cf_multiselect_check 
                                    query_name="get_departments_search"  
                                    name="department_id_#ccc#"
                                    option_text="#getLang('','Depo',58763)#" 
                                    option_name="department_head" 
                                    option_value="department_id"
                                    value="">
                            </div>
                        </td>
                        <td>
                            <select name="uretici_id_#ccc#" id="uretici_id_#ccc#">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfloop query="get_sub_types">
                                    <option value="#sub_type_id#">#sub_type_name#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td nowrap="nowrap">
                            <div class="input-group medium">
                                <cf_multiselect_check 
                                    query_name="GET_PRODUCT_CAT1"
                                    selected_text="" 
                                    name="ana_group_id_#ccc#"
                                    option_text="#getLang('','Ana Grup',61641)#" 
                                    option_name="PRODUCT_CAT_NEW" 
                                    option_value="hierarchy"
                                    value="">
                            </div>
                        </td>
                        <td nowrap="nowrap"> 
                            <div class="input-group medium">       
                                <cf_multiselect_check 
                                    query_name="GET_PRODUCT_CAT2"
                                    selected_text="" 
                                    name="alt_group_id_#ccc#"
                                    option_text="#getLang('','Alt Grup',61642)#" 
                                    option_name="PRODUCT_CAT_NEW" 
                                    option_value="hierarchy"
                                    value="">
                            </div>
                        </td>
                        <td nowrap="nowrap">    
                            <div class="input-group medium">     
                                <cf_multiselect_check 
                                    query_name="GET_PRODUCT_CAT3"
                                    selected_text=""  
                                    name="alt_group_2_id_#ccc#"
                                    option_text="#getLang('','Alt Grup',61642)#" 
                                    option_name="PRODUCT_CAT_NEW" 
                                    option_value="hierarchy"
                                    value="">
                            </div>
                        </td>
                        <td>
                            <select name="process_type_#ccc#" id="process_type_#ccc#">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfloop query="get_types">
                                    <option value="#get_types.type_id#">#get_types.type_name#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td>
                            <cfinput type="text" name="process_detail_#ccc#" value="">
                        </td>
                        <td width="20"><cfinput type="text" name="quantity_#ccc#" value="1" maxlength="2" onkeyup="return(FormatCurrency(this,event,0));"></td>
                        <td>
                            <select name="period_#ccc#" id="period_#ccc#">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="6">6</option>
                                <option value="12">12</option>
                            </select>
                        </td>
                        <td nowrap="nowrap">
                            <div class="input-group">
                                <cfinput type="text" name="process_startdate_#ccc#" maxlength="10" value="" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="process_startdate_#ccc#"></span>
                            </div>
                        </td>
                        <td nowrap="nowrap">
                            <div class="input-group">
                                <cfinput type="text" name="process_finishdate_#ccc#" maxlength="10" value="" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="process_finishdate_#ccc#"></span>
                            </div>
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td nowrap="nowrap">
                            <div class="input-group">
                                <cfinput type="text" name="payment_date_#ccc#" maxlength="10" value="" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="payment_date_#ccc#"></span>
                            </div>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                            <cfinput type="text" name="cost_#ccc#" value="" maxlength="9" onkeyup="return(FormatCurrency(this,event,4));">
                        </td>
                        <td>
                            <cfinput type="text" name="revenue_rate_#ccc#" value="" >
                        </td>
                        <td>
                            <select name="tax_#ccc#" id="tax_#ccc#">
                                <option value="18">18</option>
                                <option value="8">8</option>
                                <option value="1">1</option>
                                <option value="0">0</option>
                            </select>
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    </cfoutput>
                    </cfloop>
                </tfoot>
            </cf_grid_list>
            <cf_box_footer>
                <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                    <input type="button" class=" ui-wrk-btn ui-wrk-btn-red" name="del_note" id="del_note" value="<cf_get_lang dictionary_id='62531.Toplu Satır Sil'>" onclick="delete_process_action();"/>
                </cfif>
                <cf_workcube_buttons add_function="control_process()">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
function print_process_action()
{
	kayit_sayisi_ = <cfoutput>#get_rows.recordcount#</cfoutput>;
	if(kayit_sayisi_ == '0')
	{
		alert('<cf_get_lang dictionary_id='62524.Yazdıralacak Kayıt Bulunamadı'>!');
		return false;	
	}
	
	all_list_ = '<cfoutput>#valuelist(get_rows.row_id)#</cfoutput>';

	
	deger_list_ = '0';
	for(i=1; i<=kayit_sayisi_; i++)
	{
		if(document.getElementById('row_id_' + i).checked == true)
		{
			deger_list_ = 	deger_list_ + ',' + document.getElementById('row_id_' + i).value;
		}		
	}
	
	if(deger_list_ == '0')
	{
		deger_list_ = all_list_;	
	}
	
	note_ = document.getElementById('print_note').value;
		
	AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_print_process_action&row_list=' + deger_list_ + '&note=' + note_,'special_print_area_div','1');
	//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_print_process_action&row_list=' + deger_list_,'page');	
}
function delete_process_action()
{
	kayit_sayisi_ = <cfoutput>#get_rows.recordcount#</cfoutput>;
	if(kayit_sayisi_ == '0')
	{
		alert('<cf_get_lang dictionary_id='62522.Silinecek Kayıt Bulunamadı'>!');
		return false;	
	}
	
	all_list_ = '<cfoutput>#valuelist(get_rows.row_id)#</cfoutput>';

	
	deger_list_ = '0';
	for(i=1; i<=kayit_sayisi_; i++)
	{
		if(document.getElementById('row_id_' + i).checked == true)
		{
			deger_list_ = 	deger_list_ + ',' + document.getElementById('row_id_' + i).value;
		}		
	}
	
	if(deger_list_ == '0')
	{
		alert('<cf_get_lang dictionary_id='62525.Silmek İçin Satır Seçmelisiniz'>!');
		return false;
	}
	
	if(confirm('<cf_get_lang dictionary_id='62526.Satırları Silmek İstediğinize Emin misiniz'>?'))
		{
			windowopen('index.cfm?fuseaction=retail.popup_make_process_action&event=delRow&row_id=' + deger_list_,'medium');
		}
	else
		{
			return false;
		}
}
//print_process_action();
</script>
</cfif>

<script>
function control_process()
{
	row_count_ = 0;
	for(i=1; i<=5; i++)
	{
		if(document.getElementById('process_type_' + i).value != '')
			row_count_ = 1;			
	}
	if(row_count_ == 0)
	{
		alert('<cf_get_lang dictionary_id='62527.Uygulama Girmediniz'>!');
		return false;	
	}
	
	for(i=1; i<=5; i++)
	{
		if(document.getElementById('process_type_' + i).value != '')
		{
			if(document.getElementById('quantity_' + i).value == '')
			{
				alert(i + '. <cf_get_lang dictionary_id='62528.Satır İçin Adet Giriniz'>!');
				return false;	
			}
			
			if(document.getElementById('process_startdate_' + i).value == '')
			{
				alert(i + '. <cf_get_lang dictionary_id='62529.Satır İçin Uygulama Başlangıç Giriniz'>!');
				return false;	
			}
			
			if(document.getElementById('process_finishdate_' + i).value == '')
			{
				alert(i + '. <cf_get_lang dictionary_id='62530.Satır İçin Uygulama Bitiş Giriniz'>!');
				return false;	
			}
			
			/*
			if(document.getElementById('payment_date_' + i).value == '')
			{
				alert(i + '. Satır İçin Ödeme Tarihi Giriniz!');
				return false;	
			}	
			
			if(document.getElementById('cost_' + i).value == '')
			{
				alert(i + '. Satır İçin Maliyet Giriniz!');
				return false;	
			}
			*/
		}		
	}
}
</script>