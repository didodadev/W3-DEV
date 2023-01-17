
<cfquery name="get_periods" datasource="#dsn#">
    SELECT * FROM SETUP_PERIOD ORDER BY PERIOD_YEAR ASC
</cfquery>
<cfparam name="attributes.table_code" default="">
<cfparam name="attributes.is_submit" default="">
<cfparam name="attributes.company_cats" default="">
<cfparam name="attributes.payment_groups" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_ids" default="">
<cfparam name="attributes.limit_ust" default="#tlformat(30000)#">
<cfparam name="attributes.limit_alt" default="#tlformat(1000)#">
<cfparam name="attributes.vade_uzatma" default="1">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.donem" default="">
<cfparam name="attributes.kontrol" default="0">
<cfparam name="attributes.startdate" default="#createodbcdatetime(createdate(session.ep.period_year,1,1))#">
<cfparam name="attributes.finishdate" default="#now()#">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.islem_tarihi" default="#now()#">



<script>
function get_detail_rows(row)
{
	adress_ = 'index.cfm?fuseaction=retail.popup_get_payment_details';
	adress_ += '&company_id=' + document.getElementById('company_id' + row).value;
	adress_ += '&startdate=' + document.add_.action_startdate.value;
	adress_ += '&finishdate=' + document.add_.action_finishdate.value;
	windowopen(adress_,'list','detail_pay');	
}
function get_detail_rows2(row)
{
	adress_ = 'index.cfm?fuseaction=retail.popup_get_payment_details2';
	adress_ += '&company_id=' + document.getElementById('company_id' + row).value;
	windowopen(adress_,'list','detail_pay2');	
}
function add_kk(row)
{
	adress_ = 'index.cfm?fuseaction=bank.popup_add_creditcard_bank_expense';
	adress_ += '&company_id=' + document.getElementById('company_id' + row).value;
	adress_ += '&act_value=' + filterNum(document.getElementById('bakiye' + row).value);
	windowopen(adress_,'medium','kk_pay');	
}

function add_cheque(row)
{
	adress_ = 'index.cfm?fuseaction=cheque.form_add_payroll_endorsement';
	adress_ += '&company_id=' + document.getElementById('company_id' + row).value;
	window.open(adress_,'cheque_pay');	
}

function add_payroll(row)
{
	adress_ = 'index.cfm?fuseaction=cheque.form_add_voucher_payroll_endorsement';
	adress_ += '&company_id=' + document.getElementById('company_id' + row).value;
	window.open(adress_,'payroll_pay');	
}
</script>


<cfif not len(attributes.is_submit)>
    <cfquery name="del_old_rows" datasource="#dsn_dev#">
    DELETE FROM CARI_ROW_RELATIONS WHERE 
        (
        IN_CARI_ACTION_ID NOT IN (SELECT CA.CARI_ACTION_ID FROM #DSN2_ALIAS#.CARI_ROWS CA) AND
        PERIOD_ID = #session.ep.period_id#
        )
    </cfquery>
    <cfquery name="del_old_rows2" datasource="#dsn_dev#">
    DELETE FROM CARI_ROW_RELATIONS WHERE 
        (
        OUT_CARI_ACTION_ID NOT IN (SELECT CA.CARI_ACTION_ID FROM #DSN2_ALIAS#.CARI_ROWS CA) AND
        PERIOD_ID = #session.ep.period_id#
        )
    </cfquery>
    
    <cfquery name="get_comps" datasource="#dsn2#" result="s_donen">
        SELECT FROM_CMP_ID AS COMPANY_ID FROM CARI_ROWS WHERE FROM_CMP_ID IS NOT NULL
        UNION
        SELECT TO_CMP_ID AS COMPANY_ID FROM CARI_ROWS WHERE TO_CMP_ID IS NOT NULL
    </cfquery>
    
    <cfset comp_list = valuelist(get_comps.COMPANY_ID)>
    <cfquery name="get_bakiyes_all" datasource="#dsn2#" result="q_donen_1">
        SELECT
            *
        FROM
            (
            <cfoutput query="get_periods">
        <cfif currentrow neq 1>
        UNION ALL
        </cfif>
        SELECT 
                ISNULL((SELECT SUM(ROUND(CRR.RELATED_VALUE,2)) FROM #dsn_dev_alias#.CARI_ROW_RELATIONS CRR WHERE CRR.IN_CARI_ACTION_ID = CR#PERIOD_ID#.CARI_ACTION_ID AND CRR.PERIOD_ID = #period_id#),0) AS KAPATILAN,
                ACTION_VALUE,
                DUE_DATE,
                ACTION_DATE,
                FROM_CMP_ID,
                ACTION_TYPE_ID,
                CARI_ACTION_ID,
                ACTION_ID,
                #PERIOD_ID# AS PERIOD_ID
            FROM
                #dsn#_#period_year#_#our_company_id#.CARI_ROWS CR#PERIOD_ID#
            WHERE 
                FROM_CMP_ID IS NOT NULL
            <cfif period_year neq 2014>
            	AND ACTION_TYPE_ID <> 40
            </cfif>
            	AND ACTION_TYPE_ID NOT IN (24,240) 
        </cfoutput>
            ) T1
        WHERE
        	FROM_CMP_ID IN (#comp_list#)
        ORDER BY
            DUE_DATE ASC,
            PERIOD_ID ASC
    </cfquery>
    
    <cfquery name="get_bakiyes_dus_all" datasource="#dsn2#">
        SELECT
            *
        FROM
            (
        <cfoutput query="get_periods">
        <cfif currentrow neq 1>
        UNION ALL
        </cfif>
            SELECT
                ISNULL((
                    SELECT 
                        SUM(ROUND(CRR.RELATED_VALUE,2)) 
                    FROM 
                        #dsn_dev_alias#.CARI_ROW_RELATIONS CRR 
                    WHERE 
                        CRR.OUT_CARI_ACTION_ID = CR#PERIOD_ID#.CARI_ACTION_ID  AND 
                        CRR.PERIOD_ID_OUT = #period_id#
                      ),0) AS KAPATTIGI,
                ACTION_VALUE,
                DUE_DATE,
                CASE WHEN ACTION_TABLE = 'PAYROLL' THEN RECORD_DATE ELSE ACTION_DATE END AS ACTION_DATE,
                TO_CMP_ID,
                ACTION_TYPE_ID,
                CARI_ACTION_ID,
                ACTION_ID,
                PAPER_NO,
            #PERIOD_ID# AS PERIOD_ID_OUT
            FROM 
                #dsn#_#period_year#_#our_company_id#.CARI_ROWS CR#PERIOD_ID#
            WHERE 
                TO_CMP_ID IS NOT NULL
            <cfif period_year neq 2014>
            AND ACTION_TYPE_ID <> 40
            </cfif>
            AND ACTION_TYPE_ID NOT IN (24,240)
        </cfoutput>
            ) T2
        WHERE
            ROUND(KAPATTIGI,2) < ROUND(ACTION_VALUE,2) AND
            TO_CMP_ID IN (#comp_list#) 
        ORDER BY
            ACTION_DATE ASC,
            CARI_ACTION_ID ASC,
            PERIOD_ID_OUT ASC
   	</cfquery>
    
    <cfloop list="#comp_list#" index="cmp_id">
        <cfquery name="get_bakiyes" dbtype="query" result="q_donen">
        SELECT
            *
        FROM
            get_bakiyes_all
        WHERE
        	FROM_CMP_ID = #cmp_id#
        ORDER BY
            DUE_DATE ASC,
            PERIOD_ID ASC
        </cfquery>
            
        <cfif get_bakiyes.recordcount>
            <cfquery name="get_bakiyes_dus" dbtype="query">
            SELECT
                *
            FROM
                get_bakiyes_dus_all
            WHERE
                TO_CMP_ID = #cmp_id#
            ORDER BY
                ACTION_DATE ASC,
                CARI_ACTION_ID ASC,
                PERIOD_ID_OUT ASC
            </cfquery>
                    
            <cfoutput query="get_bakiyes_dus">
                <cfset deger_ = ACTION_VALUE>
                <cfset deger_son_ = wrk_round(ACTION_VALUE - KAPATTIGI)>
                <cfset row_id_ = CARI_ACTION_ID>
                <cfset a_date_ = ACTION_DATE>
                <cfset period_id_out_ = period_id_out>
                <cfset row_no_ = 0>
                    <cfloop query="get_bakiyes">
                        <cfset row_no_ = row_no_ + 1>
                        <cfset period_id_ = get_bakiyes.period_id[row_no_]>               
                        <cfset alt_a_date_ = get_bakiyes.ACTION_DATE[row_no_]>
                        <cfif datediff('d',alt_a_date_,a_date_) gte 0>
                            <cfset alt_action_id_ = get_bakiyes.CARI_ACTION_ID[row_no_]>
                            <cfset alt_deger_total_ = get_bakiyes.action_value[row_no_]>
                            <cfset alt_deger_ = wrk_round(get_bakiyes.action_value[row_no_] - get_bakiyes.KAPATILAN[row_no_])>
                            <cfset onceki_kapatilan_ = wrk_round(get_bakiyes.KAPATILAN[row_no_])>                   
                            
                            <cfif deger_son_ gt 0 and deger_son_ gte alt_deger_ and alt_deger_ gt 0>
                                <!--- 1 nolu işlem   row: #row_id_# düşülecek deger:#deger_# düsebileceği: #deger_son_# kapatılacak satır:#alt_deger_total_# once kapatilan : #onceki_kapatilan_# kapatacağımız:#alt_deger_# alt action_id #alt_action_id_#<BR /> --->
                                <cfset querysetcell(get_bakiyes,'KAPATILAN',wrk_round(alt_deger_+onceki_kapatilan_),row_no_)>
                                <cfquery name="add_" datasource="#dsn_dev#">
                                    INSERT INTO
                                        CARI_ROW_RELATIONS
                                        (
                                        IN_CARI_ACTION_ID,
                                        IN_ACTION_VALUE,
                                        OUT_CARI_ACTION_VALUE,
                                        OUT_CARI_ACTION_ID,
                                        PERIOD_ID,
                                        PERIOD_ID_OUT,
                                        RELATED_VALUE
                                        )
                                        VALUES
                                        (
                                        #alt_action_id_#,
                                        #alt_deger_total_#,
                                        #deger_#,
                                        #row_id_#,
                                        #period_id_#,
                                        #period_id_out_#,                                
                                        #alt_deger_#
                                        )
                                </cfquery>
                                <cfset deger_son_ = wrk_round(deger_son_ - alt_deger_)>
                            <cfelseif deger_son_ gt 0 and deger_son_ lt alt_deger_ and alt_deger_ gt 0>
                             <!--- 2 nolu işlem   row: #row_id_# düşülecek deger:#deger_# düsebileceği: #deger_son_# kapatılacak satır:#alt_deger_total_# once kapatilan : #onceki_kapatilan_# kapatacağımız:#alt_deger_# alt action_id #alt_action_id_#<BR /> --->
                                <cfset querysetcell(get_bakiyes,'KAPATILAN',wrk_round(deger_son_+onceki_kapatilan_),row_no_)>
                                <cfquery name="add_" datasource="#dsn_dev#">
                                    INSERT INTO
                                        CARI_ROW_RELATIONS
                                        (
                                        IN_CARI_ACTION_ID,
                                        IN_ACTION_VALUE,
                                        OUT_CARI_ACTION_VALUE,
                                        OUT_CARI_ACTION_ID,
                                        PERIOD_ID,
                                        PERIOD_ID_OUT,
                                        RELATED_VALUE
                                        )
                                        VALUES
                                        (
                                        #alt_action_id_#,
                                        #alt_deger_total_#,
                                        #deger_#,
                                        #row_id_#,
                                        #period_id_#,
                                        #period_id_out_#,
                                        #deger_son_#
                                        )
                                </cfquery>
                                <cfset deger_son_ = 0>
                            </cfif>
                        </cfif>
                    </cfloop>  
            </cfoutput>
        </cfif>
    </cfloop>
    <!--- acik islem baglama --->
</cfif>
<cfinclude template="../../../../V16/member/query/get_company_cat.cfm">
<cfquery name="get_payment_groups" datasource="#dsn_dev#">
	SELECT * FROM PAYMENT_GROUP ORDER BY PAYMENT_GROUP_NAME
</cfquery>
<cfif attributes.is_submit eq 1>
	<cf_date tarih = "attributes.islem_tarihi">
</cfif>
<script>
function add_c_row_new()
{
	cid_ = document.getElementById('company_id').value;	
	cname_ = document.getElementById('company').value;
	
	if(cid_ == '' || cname_ == '')
	{
		alert('<cf_get_lang dictionary_id='38002.Tedarikçi Seçmelisiniz'>!');
		return false;	
	}
	add_c_row(cid_,cname_);
}
function add_c_row(cid_,cname_)
{
	icerik_ = '<div id="selected_product_' + cid_ + '">';
	icerik_ += '<a href="javascript://" onclick="del_row_p(' + cid_ +')">';
	icerik_ += '<i class="fa fa-minus"></i>';
	icerik_ += '</a>';
	icerik_ += '<input type="hidden" name="company_ids" value="' + cid_ + '">';
	icerik_ += cname_;
	icerik_ += '</div>';
	
	$('#product_div').append(icerik_);
}

function del_row_p(cid_)
{
	$("#selected_product_" + cid_).remove();	
}
</script>

<cfif isdefined("attributes.table_code") and len(attributes.table_code)>
	
    <cfquery name="get_table_" datasource="#dsn_dev#">
    	SELECT * FROM PAYMENT_TABLE WHERE TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    

    <cfif get_table_.recordcount>
    	<cfset table_code_ = get_table_.TABLE_CODE>
        <cfset aciklama_ = get_table_.TABLE_DETAIL>
        <cfset uzatma_ = get_table_.uzatma_ekle>
        <cfset attributes.startdate = createodbcdatetime(get_table_.ACTION_STARDATE)>
        <cfset attributes.finishdate = createodbcdatetime(get_table_.ACTION_FINISHDATE)>
        <cfset attributes.islem_tarihi = createodbcdatetime(get_table_.ACTION_DATE)>
        
        <cfset attributes.company_ids = get_table_.action_company_id>

        <cfset attributes.limit_ust = get_table_.action_limit_ust>
        <cfset attributes.limit_alt = get_table_.action_limit_alt>
        
        <cfset attributes.order_type = get_table_.action_order_type>
        
        <cfset attributes.company_cats = get_table_.action_company_cats>
        
        <cfquery name="get_payment_rows" datasource="#dsn_dev#">
        	SELECT DISTINCT PAYMENT_GROUP_ID FROM PAYMENT_TABLE_GROUPS WHERE TABLE_CODE = '#table_code_#' 
        </cfquery>
        <cfif get_payment_rows.recordcount>
        	<cfset attributes.payment_groups = valuelist(get_payment_rows.PAYMENT_GROUP_ID)>
        </cfif>
    <cfelse>
    	<cfset table_code_ = "">
        <cfset aciklama_ = "">
        <cfset uzatma_ = "0">
    </cfif>
<cfelse>
	<cfset table_code_ = "">
    <cfset aciklama_ = "">
    <cfset uzatma_ = "0">
</cfif>

<cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="rapor" method="post" action="#request.self#?fuseaction=retail.list_cheque_management&event=upd">
        <input type="hidden" name="is_submit" value="1"/>
            <cf_box_elements>
                <div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-is_bank">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="checkbox" id="is_bank" name="is_bank" value="1" <cfif isdefined("attributes.is_bank")>checked</cfif>/><cf_get_lang dictionary_id='61980.Banka Bilgilerini Göster'>
                        </label>
                    </div>
                    <div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-is_payment_group">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="checkbox" id="is_payment_group" name="is_payment_group" value="1" <cfif isdefined("attributes.is_payment_group") or not isdefined("attributes.is_submit")>checked</cfif>/><cf_get_lang dictionary_id='61981.Ödeme Grubuna Hesapla'>
                        </label>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-table_code">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61478.Tablo Kodu'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="table_code" value="#attributes.table_code#">
                        </div>
                    </div>
                    <div class="form-group" id="item-islem_tarihi">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="islem_tarihi" value="#dateformat(attributes.islem_tarihi,'dd/mm/yyyy')#" validate="eurodate" message="İşlem Tarihi!" maxlength="10" required="yes">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="islem_tarihi"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-company">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                <input type="text" name="company" id="company" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=rapor.company&field_comp_id=rapor.company_id&select_list=2');"></span>
                        	    
                            </div>
                        </div>
                    </div>
                    <div id="product_div"></div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-date">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                        <div class="col col-4 col-sm-12">
                           <div class="input-group">
                                <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" validate="eurodate" message="Başlangıç Tarihi !" maxlength="10" required="yes">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                 <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" validate="eurodate" message="Bitiş Tarihi!" maxlength="10" required="yes">
                                 <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                             </div>
                         </div>                    
                    </div>
                    <div class="form-group" id="item-limit_alt">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61982.Bakiye Limit Tutarı'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="limit_alt" value="#attributes.limit_alt#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));">
                        </div>
                    </div>
                    <div class="form-group" id="item-limit_ust">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61983.Ödeme Limit Tutarı'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="limit_ust" value="#attributes.limit_ust#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-order_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58924.Sıralama'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="order_type">
                            	<option value="1" <cfif attributes.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id='61984.Firma Artan'></option>
                                <option value="2" <cfif attributes.order_type eq 2>selected</cfif>><cf_get_lang dictionary_id='61985.Firma Azalan'></option>
                                <option value="3" <cfif attributes.order_type eq 3>selected</cfif>><cf_get_lang dictionary_id='61986.Bakiye Artan'></option>
                                <option value="4" <cfif attributes.order_type eq 4>selected</cfif>><cf_get_lang dictionary_id='61987.Bakiye Azalan'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-get_payment_groups">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61784.Ödeme Grupları'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                            query_name="get_payment_groups"  
                            name="payment_groups"
                            option_text="#getLang('','Ödeme Grupları',61784)#" 
                            width="180"
                            option_name="PAYMENT_GROUP_NAME" 
                            option_value="PAYMENT_GROUP_ID"
                            value="#attributes.payment_groups#">
                        </div>
                    </div>
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                            query_name="GET_COMPANYCAT"  
                            name="company_cats"
                            option_text="#getLang('','Üye Kategorileri',32463)#" 
                            width="180"
                            option_name="COMPANYCAT" 
                            option_value="COMPANYCAT_ID"
                            value="#attributes.company_cats#">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cfquery name="get_rows" datasource="#dsn_dev#">
                SELECT
                    PG.PAYMENT_GROUP_NAME,
                    PGR.*
                FROM
                    PAYMENT_GROUP_ROW PGR,
                    PAYMENT_GROUP PG
                WHERE
                    PGR.PAYMENT_GROUP_ID = PG.PAYMENT_GROUP_ID
                ORDER BY
                    PAYMENT_GROUP_NAME ASC,
                    PAYMENT_GROUP_ROW_ID ASC
            </cfquery>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th nowrap="nowrap">&nbsp;</th>
                        <th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='61787.Alım Günü'></th>
                        <th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='54821.Ödeme Günü'></th>
                        <th nowrap="nowrap"><cf_get_lang dictionary_id='61788.Ödeme Ayı'></th>
                    </tr>
                </thead>
                <tbody>
                <cfoutput query="get_rows">
                    <tr>
                        <td><b>#PAYMENT_GROUP_NAME#</b></td>
                        <td style="text-align:right;">#alim_start# - #alim_finish#</td>
                        <td style="text-align:right;">#odeme_start#</td>
                        <td>
                            <cfif odeme_month eq 0><cf_get_lang dictionary_id='61789.Bu Ay'></cfif>
                            <cfif odeme_month eq 1><cf_get_lang dictionary_id='61790.Takip Eden Ay'></cfif> 
                        </td>
                    </tr>
                </cfoutput>
                </tbody>
            </cf_grid_list>
            <cf_box_footer>
                <cf_wrk_search_button button_type="1" search_function="add_c_row_new()">
            </cf_box_footer>
        </cfform>
    </cf_box>
    <cf_box title="Tablo Bilgisi" uidrop="1" hide_table_column="1">
        <cfif attributes.is_submit eq 1>
            <cf_date tarih = "attributes.startdate">
            <cf_date tarih = "attributes.finishdate">
            
            <cfif isdefined("attributes.table_code") and len(attributes.table_code) and get_table_.recordcount>
                <!--- nothing --->
            <cfelse>
                <cfquery name="get_bakiye_all" datasource="#dsn2#">
                SELECT
                    SUM(T1.ALACAK) - SUM(T1.BORC) AS BAKIYE,
                    T1.COMPANY_ID,
                    C.PAYMENT_GROUP_ID,
                    (SELECT PG.PAYMENT_GROUP_NAME FROM #DSN_DEV_ALIAS#.PAYMENT_GROUP PG WHERE PG.PAYMENT_GROUP_ID = C.PAYMENT_GROUP_ID) AS PAYMENT_GROUP_NAME,
                    NULL AS PAYMENT_GROUP_ROW_ID,
                    C.FULLNAME,
                    C.NICKNAME,
                    CB.COMPANY_BANK BANK_NAME,
                    CB.COMPANY_IBAN_CODE AS BANK_IBAN
                 FROM
                    (
                <cfoutput query="get_periods">
                <cfif currentrow neq 1>
                UNION ALL
                </cfif>
                    SELECT 
                            CR.FROM_CMP_ID AS COMPANY_ID,
                            0 AS BORC,
                            SUM(CR.ACTION_VALUE) AS ALACAK
                        FROM 
                            #dsn#_#period_year#_#our_company_id#.CARI_ROWS CR
                        WHERE
                            CR.ACTION_DATE <= #attributes.finishdate# AND
                            CR.FROM_CMP_ID IS NOT NULL
                            <cfif period_year neq 2014>
                                AND CR.ACTION_TYPE_ID <> 40
                            </cfif>
                        GROUP BY
                            CR.FROM_CMP_ID
                    UNION ALL
                        SELECT 
                            CR.TO_CMP_ID AS COMPANY_ID,
                            SUM(CR.ACTION_VALUE) AS BORC,
                            0 AS ALACAK
                        FROM 
                            #dsn#_#period_year#_#our_company_id#.CARI_ROWS CR
                        WHERE
                            CR.ACTION_DATE <= #attributes.finishdate# AND
                            CR.TO_CMP_ID IS NOT NULL
                            <cfif period_year neq 2014>
                                AND CR.ACTION_TYPE_ID <> 40
                            </cfif>
                        GROUP BY
                            CR.TO_CMP_ID
                    UNION ALL
                        SELECT 
                            CR.TO_CMP_ID AS COMPANY_ID,
                            SUM(CR.ACTION_VALUE) AS BORC,
                            0 AS ALACAK
                        FROM 
                            #dsn#_#period_year#_#our_company_id#.CARI_ROWS CR
                        WHERE
                            CR.ACTION_DATE > #attributes.finishdate# AND
                            CR.TO_CMP_ID IS NOT NULL
                            <cfif period_year neq 2014>
                                AND CR.ACTION_TYPE_ID <> 40
                            </cfif>
                        GROUP BY
                            CR.TO_CMP_ID
                </cfoutput>
                    ) 
                    T1,
                    #DSN_ALIAS#.COMPANY C
                        LEFT JOIN #DSN_ALIAS#.COMPANY_BANK CB ON (CB.COMPANY_ID = C.COMPANY_ID AND CB.COMPANY_ACCOUNT_DEFAULT = 1)
                WHERE
                    <cfif len(attributes.payment_groups)>
                        C.PAYMENT_GROUP_ID IN (#attributes.payment_groups#) AND
                    </cfif>
                    T1.COMPANY_ID = C.COMPANY_ID AND
                    T1.COMPANY_ID IS NOT NULL
                    <cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
                        AND T1.COMPANY_ID IN (#attributes.company_ids#)
                    </cfif>
                    <cfif isdefined("attributes.company_cats") and len(attributes.company_cats)>
                        AND C.COMPANYCAT_ID IN (#attributes.company_cats#)
                    </cfif>
                GROUP BY
                    C.FULLNAME,
                    C.NICKNAME,
                    T1.COMPANY_ID,
                    PAYMENT_GROUP_ID,
                    CB.COMPANY_BANK,
                    CB.COMPANY_IBAN_CODE
                </cfquery>
                <cfquery name="get_bakiye" dbtype="query">
                SELECT
                    *
                FROM
                    get_bakiye_all
                WHERE
                    <cfif len(attributes.limit_alt)>
                        BAKIYE >= #filternum(attributes.limit_alt)# AND
                    </cfif>
                    BAKIYE <> 0
                ORDER BY
                    <cfif isdefined("attributes.is_payment_group")>
                        PAYMENT_GROUP_NAME ASC,
                    </cfif>
                    <cfif attributes.order_type eq 1>
                        FULLNAME ASC
                    <cfelseif attributes.order_type eq 2>
                        FULLNAME DESC
                    <cfelseif attributes.order_type eq 3>
                        BAKIYE ASC
                    <cfelseif attributes.order_type eq 4>
                        BAKIYE DESC
                    </cfif>
                </cfquery>
            </cfif>
            
            
            <cfform name="add_" action="" method="post">
                <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                    <cf_box_elements>
                        <div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
                            <cfif isdefined("attributes.table_code") and len(attributes.table_code)>
                                <div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-is_paid">
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                        <input type="checkbox" id="is_paid" name="is_paid" value="1" <cfif get_table_.is_paid eq 1>checked</cfif>/>
                                        <cf_get_lang dictionary_id='61988.Ödemeye Dönüştürüldü mü'>?
                                    </label>
                                </div>
                            </cfif>
                            <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_paid">
                                <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <cfif isdefined("attributes.table_code") and len(attributes.table_code)>
                                        <input type="checkbox" id="is_bank1" name="is_paid" value="1" <cfif get_table_.is_bank eq 1>checked</cfif>/>
                                    <cfelse>
                                        <input type="checkbox" id="is_bank2" name="is_bank" value="1" <cfif isdefined("attributes.is_bank")>checked</cfif>/>
                                    </cfif>  
                                    <cf_get_lang dictionary_id='38986.Banka Bilgileri'>
                                </label>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-table_code">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61478.Tablo Kodu'></label>
                                <div class="col col-8 col-sm-12">
                                    <cfinput type="text" name="table_code" value="#table_code_#" readonly="yes">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-detail">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                                <div class="col col-8 col-sm-12">
                                    <cfinput type="text" name="detail" value="#aciklama_#" required="yes" message="#getLang('','Açıklama Girmelisiniz',33337)#!">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-payment_groups">
                                <label class="col col-4 col-sm-12"></label>
                                <div class="col col-8 col-sm-12">
                                    <input type="hidden" name="payment_groups" value="<cfoutput>#attributes.payment_groups#</cfoutput>"/>
                                    <cfif len(attributes.payment_groups)>
                                        <cfquery name="get_names" datasource="#dsn_dev#">
                                            SELECT * FROM PAYMENT_GROUP WHERE PAYMENT_GROUP_ID IN (#attributes.payment_groups#)
                                        </cfquery>
                                        <cfoutput><b>#valuelist(get_names.payment_group_name)#</b></cfoutput>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true" style="display:none;">
                            <div class="form-group" id="item-action_company_cats">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                                <div class="col col-8 col-sm-12">
                                    <cfinput type="hidden" name="action_islem_tarihi" value="#dateformat(attributes.islem_tarihi,'dd/mm/yyyy')#">
                                    <cfinput type="hidden" name="action_startdate" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#">
                                    <cfinput type="hidden" name="action_finishdate" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
                                    <input type="hidden" name="action_company_id" id="company_id" value="<cfif len(attributes.company_ids)><cfoutput>#attributes.company_ids#</cfoutput></cfif>">
                                    <cfinput type="hidden" name="action_limit_alt" value="#attributes.limit_alt#">
                                    <cfinput type="hidden" name="action_limit_ust" value="#attributes.limit_ust#">
                                    <cfinput type="hidden" name="action_order_type" value="#attributes.order_type#">
                                    <cfif isdefined("attributes.company_cats")>
                                        <cfinput type="hidden" name="action_company_cats" value="#attributes.company_cats#">
                                    <cfelse>
                                        <cfinput type="hidden" name="action_company_cats" value="">
                                    </cfif>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <cfif isdefined("attributes.table_code") and len(attributes.table_code) and get_table_.recordcount>
                            <cf_workcube_buttons is_upd="1" is_del="1" insert_info="Kaydet" insert_alert="<cf_get_lang dictionary_id='45686.Kaydetmek istediğinize emin misiniz?'>?">
                        <cfelse>
                            <cf_workcube_buttons>
                        </cfif>
                        <cf_workcube_file_action pdf='0' print='0' doc='1' mail='0' flash_paper='0' tag_module="later_payments">
                    </cf_box_footer>
                </cfif>
                <cfif len(attributes.limit_ust)>
                    <cfset attributes.limit_ust = filterNum(attributes.limit_ust)>
                </cfif>
                <cfset currentrow_ = 0>
                <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                    <div id="payment_list">
                </cfif>
                <!-- sil -->
                <cf_grid_list>   
                    <thead>   
                        <tr>                             
                            <th><cf_get_lang dictionary_id='57487.No'></th>
                            <th></th>
                            <th><cf_get_lang dictionary_id='58607.Firma'></th> 
                            <th><cf_get_lang dictionary_id='61990.Ödeme Grubu'></th>
                            <th><cf_get_lang dictionary_id='61991.Evrak Tarihi'></th>
                            <th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>	
                            <th><cf_get_lang dictionary_id='57640.Vade'></th>				              
                            <th><cf_get_lang dictionary_id='57692.İşlem'> <br /> <cf_get_lang dictionary_id='57640.Vade'></th>
                            <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                            <th><cf_get_lang dictionary_id='63423.Uzatma'><br /> 
                                <cfinput name="uzatma_ekle" type="text" value="#uzatma_#" class="moneybox" onBlur="uzatmaekle();">
                            </th>
                            <th><cf_get_lang dictionary_id='61993.Uzatma Tarihi'></th>
                            <th><cf_get_lang dictionary_id='54821.Ödeme Günü'></th>
                            <th><cf_get_lang dictionary_id='61994.Son Vade Günü'></th>
                            <th><cf_get_lang dictionary_id='61995.Vade Aşımı'></th>
                            <cfif isdefined("attributes.is_bank")>
                            <th><cf_get_lang dictionary_id='57521.Banka'></th>
                            <th><cf_get_lang dictionary_id='40596.IBAN'></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='58658.Ödemeler'></th>
                        </tr>
                    </thead>
                    <cfset total_bakiye = 0>
                    <cfif isdefined("attributes.table_code") and len(attributes.table_code) and get_table_.recordcount>
                            <cfquery name="get_bakiye" datasource="#dsn_dev#">
                                SELECT 
                                    PTR.*,
                                    (SELECT PG.PAYMENT_GROUP_NAME FROM PAYMENT_GROUP PG WHERE PG.PAYMENT_GROUP_ID = PTR.PAYMENT_GROUP_ID) AS PAYMENT_GROUP_NAME,
                                    CASE 
                                        WHEN (PTR.BANK_NAME IS NULL OR PTR.BANK_NAME = '') THEN CB.COMPANY_BANK
                                        ELSE PTR.BANK_NAME END AS BANK_NAME,
                                    CASE 
                                        WHEN (PTR.BANK_NAME IS NULL OR PTR.BANK_NAME = '') THEN CB.COMPANY_IBAN_CODE
                                        ELSE PTR.BANK_IBAN END AS BANK_IBAN  
                                FROM 
                                    PAYMENT_TABLE_ROWS PTR
                                        LEFT JOIN #DSN_ALIAS#.COMPANY_BANK CB ON (CB.COMPANY_ID = PTR.COMPANY_ID AND CB.COMPANY_ACCOUNT_DEFAULT = 1)
                                WHERE 
                                    PTR.TABLE_ID = #get_table_.TABLE_ID#
                            </cfquery>
                            
                            <cfset grand_e_total = 0>
                            <cfset grand_e_base_total = 0>
                            
                            <cfset grand_v_total = 0>
                            <cfset grand_v_base_total = 0>
                            
                            <cfset grand_o_total = 0>
                            <cfset grand_o_base_total = 0>
                            
                            <cfoutput query="get_bakiye">
                                <cfset fark_ = Ceiling(datediff('d',attributes.startdate,evrak_tarihi))>
                                <cfset grand_e_total = grand_e_total + bakiye>
                                <cfset grand_e_base_total = grand_e_base_total + (bakiye * fark_)>
                                
                                <cfset fark_ = Ceiling(datediff('d',attributes.startdate,vade_tarihi))>
                                <cfset grand_v_total = grand_e_total + bakiye>
                                <cfset grand_v_base_total = grand_v_base_total + (bakiye * fark_)>
                                
                                <cfset fark_ = Ceiling(datediff('d',attributes.startdate,odeme_gunu_tarih))>
                                <cfset grand_o_total = grand_o_total + bakiye>
                                <cfset grand_o_base_total = grand_o_base_total + (bakiye * fark_)>
                                
                                <cfset currentrow_ = currentrow_ + 1>
                                <tbody>
                                    <tr rel="table_rows" id="row_#currentrow_#">         
                                        <td>#currentrow_#</td>             	
                                        <td>
                                        <!-- sil -->
                                        <input type="hidden" name="company_id#currentrow_#" id="company_id#currentrow_#" value="#COMPANY_ID#"/>
                                        <input type="hidden" name="payment_group_id#currentrow_#" id="payment_group_id#currentrow_#" value="#payment_group_id#"/>
                                        <input type="hidden" name="payment_group_row_id#currentrow_#" id="payment_group_row_id#currentrow_#" value="#payment_group_row_id#"/>
                                        <input type="checkbox" name="row_active#currentrow_#" id="row_active#currentrow_#" value="1" checked="checked"/>
                                        <!-- sil -->
                                        </td>
                                        <td>
                                            <!---<a href="#request.self#?fuseaction=cheque.list_cheques&status=6&is_form_submitted=1&company_id=#company_id#&member_type=partner&company=#get_par_info(COMPANY_ID,1,1,0)#" target="c_window"><img src="/images/senet.gif" align="absmiddle"/></a>--->
                                            <cfif fusebox.fuseaction contains 'autoexcel'>
                                                #get_par_info(COMPANY_ID,1,1,0)#
                                            <cfelse>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#COMPANY_ID#','page');" class="tableyazi">#left(get_par_info(COMPANY_ID,1,1,0),25)#</a>
                                            </cfif>
                                        </td>
                                        <td>#PAYMENT_GROUP_NAME#</td>
                                        <td nowrap>
                                        <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                            <cfinput type="text" name="evrak_tarihi#currentrow_#" value="#dateformat(evrak_tarihi,'dd/mm/yyyy')#" rel="evrak" readonly="yes"  validate="eurodate">
                                        <cfelse>
                                            #dateformat(evrak_tarihi,'dd/mm/yyyy')#
                                        </cfif>
                                        </td>
                                        <td>
                                        <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                            <cfinput type="text" name="vade_tarihi#currentrow_#" value="#dateformat(vade_tarihi,'dd/mm/yyyy')#" rel="vadesi" readonly="yes" validate="eurodate">
                                        <cfelse>
                                            #dateformat(vade_tarihi,'dd/mm/yyyy')#
                                        </cfif>
                                        </td>
                                        <td>
                                        <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                            <cfinput type="text" name="vade_gun#currentrow_#" rel="vade_gun"  value="#vade_gun#" readonly="yes" class="moneybox">
                                        <cfelse>
                                            #vade_gun#
                                        </cfif>
                                        </td>                    
                                        <td>
                                        <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                            <cfinput type="text" name="islem_tar_vade#currentrow_#" value="#islem_tar_vade#" readonly="yes" class="moneybox" rel="islem_tar_vade">
                                        <cfelse>
                                            #islem_tar_vade#
                                        </cfif>
                                        </td>                
                                        <td >
                                        <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                            <cfinput type="text" name="bakiye#currentrow_#" comp_rel="bakiye#COMPANY_ID#" value="#tlformat(bakiye,2)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event,2));" onBlur="uzatmatarhesapla('#currentrow_#','1');">
                                        <cfelse>
                                            #tlformat(bakiye,2)#
                                        </cfif>
                                        </td> 
                                        <td>
                                        <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                            <cfinput type="text" name="uzatma_gun#currentrow_#" value="#uzatma_gun#" class="moneybox" rel="uzatma_gun" onChange="uzatmatarhesapla('#currentrow_#','1');">
                                        <cfelse>
                                            #uzatma_gun#
                                        </cfif>
                                        </td>
                                        <td>
                                        <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                            <cfinput type="text" name="uzatma_tarih#currentrow_#" comp_rel="uzatma_tarih#COMPANY_ID#" value="#dateformat(uzatma_tarih,'dd/mm/yyyy')#" rel="uzatma_tarih" validate="eurodate">
                                        <cfelse>
                                            #dateformat(uzatma_tarih,'dd/mm/yyyy')#
                                        </cfif>
                                        </td>
                                        <td>
                                        <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                            <cfinput type="text" name="odeme_gunu_tarih#currentrow_#" comp_rel="odeme_gunu_tarih#COMPANY_ID#" value="#dateformat(odeme_gunu_tarih,'dd/mm/yyyy')#" rel="odeme_gunu_tarih" >
                                        <cfelse>
                                            #dateformat(odeme_gunu_tarih,'dd/mm/yyyy')#
                                        </cfif>
                                        </td>                    
                                        <td>
                                        <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                            <cfinput type="text" name="son_vade_gun#currentrow_#" value="#son_vade_gun#" class="moneybox" rel="son_vade_gun" >
                                        <cfelse>
                                            #son_vade_gun#
                                        </cfif>
                                        </td>
                                        <td>
                                        <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                            <cfinput type="text" name="vade_asimi#currentrow_#" value="#vade_asimi#" class="moneybox" rel="vade_asimi">
                                        <cfelse>
                                            #vade_asimi#
                                        </cfif>
                                        </td>
                                        <cfif isdefined("attributes.is_bank")>
                                        <td><cfinput type="hidden" name="bank_name#currentrow_#" value="#bank_name#" rel="bank_name" >#bank_name#</td>
                                        <td><cfinput type="hidden" name="bank_iban#currentrow_#" value="#bank_iban#" rel="bank_iban" >#bank_iban#</td>
                                        </cfif>
                                        <td nowrap="nowrap">
                                            <div id="action_div_#currentrow_#" style="display:none;"></div>
                                            <input type="button" value="D" onclick="get_detail_rows('#currentrow_#');"/>
                                            <input type="button" value="D2" onclick="get_detail_rows2('#currentrow_#');"/>
                                            <input type="button" value="<cf_get_lang dictionary_id='58007.Çek'>" onclick="add_cheque('#currentrow_#');"/>
                                            <input type="button" value="<cf_get_lang dictionary_id='58008.Senet'>" onclick="add_payroll('#currentrow_#');"/>
                                            <input type="button" value="<cf_get_lang dictionary_id='58199.Kredi Kartı'>" onclick="add_kk('#currentrow_#');"/>
                                        </td>
                                    </tr>
                                </tbody>
                                <cfset total_bakiye = total_bakiye + bakiye>
                                <cfif currentrow neq 1 and COMPANY_ID eq COMPANY_ID[currentrow-1] and (currentrow eq get_bakiye.recordcount or COMPANY_ID neq COMPANY_ID[currentrow+1])>
                                    <tbody>
                                        <tr class="color-header" rel="table_rows">
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td class="txtbold">#get_par_info(COMPANY_ID,1,1,0)#</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td ><cfinput type="text" name="t_bakiye#company_id#" value="" class="moneybox"  readonly="yes"></td>
                                            <td>
                                                <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                                    <cfinput type="text" name="t_uzatma_gun#currentrow_#" value=""  class="moneybox" readonly="readonly">
                                                <cfelse>
                                                    &nbsp;
                                                </cfif>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td><cfinput type="text" name="t_odeme_gunu_tarih#company_id#" value="" readonly="yes"></td>                    
                                            <td><cfinput type="text" name="t_son_vade_gun#company_id#" value=""  class="moneybox" readonly="yes"></td>
                                            <td><cfinput type="text" name="t_vade_asimi#company_id#" value=""  class="moneybox" readonly="yes"></td>
                                            <cfif isdefined("attributes.is_bank")>
                                            <td>#bank_name#</td>
                                            <td>#bank_iban#</td>
                                            </cfif>
                                            <td>
                                                <script>
                                                    $(document).ready(function () 
                                                    {
                                                    uzatmatarhesapla('#currentrow_#','1');
                                                    });
                                                </script>
                                            </td>
                                        </tr>
                                    </tbody>
                                </cfif>
                            </cfoutput>
                        <cfelse>
                            <cfset grand_e_total = 0>
                            <cfset grand_e_base_total = 0>
                            
                            <cfset grand_v_total = 0>
                            <cfset grand_v_base_total = 0>
                            
                            <cfset grand_o_total = 0>
                            <cfset grand_o_base_total = 0>
                            
                            <cfoutput query="get_bakiye">
                                <cfset comp_id_ = company_id>
                                <cfquery name="get_alislar" datasource="#dsn2#">
                                SELECT
                                    *,
                                    (ACTION_VALUE - KAPATILAN) AS BASE_VALUE
                                FROM
                                    (
                                    <cfset c_ = 0>
                                    <cfloop query="get_periods">
                                    <cfset c_ = c_ + 1>
                                    <cfif c_ neq 1>
                                    UNION ALL
                                    </cfif>
                                        SELECT
                                                ISNULL((SELECT SUM(CRR.RELATED_VALUE) FROM #dsn_dev_alias#.CARI_ROW_RELATIONS CRR WHERE CRR.IN_CARI_ACTION_ID = CARI_ROWS.CARI_ACTION_ID AND CRR.PERIOD_ID = #get_periods.PERIOD_ID[c_]#),0) AS KAPATILAN,
                                                ACTION_VALUE,
                                                DUE_DATE,
                                                ACTION_DATE
                                            FROM
                                                #dsn#_#get_periods.PERIOD_year[c_]#_#get_periods.our_company_id[c_]#.CARI_ROWS
                                            WHERE
                                                FROM_CMP_ID = #comp_id_# AND
                                                ACTION_DATE <= #attributes.finishdate#
                                                <cfif get_periods.PERIOD_year[c_] neq 2014>
                                                    AND ACTION_TYPE_ID <> 40
                                                </cfif>
                                    </cfloop>
                                    ) T1
                                WHERE
                                    (ACTION_VALUE - KAPATILAN) > 0
                                ORDER BY
                                    <cfif isdefined("attributes.is_payment_group")>
                                    ACTION_DATE ASC
                                    <cfelse>
                                    DUE_DATE ASC
                                    </cfif>
                                </cfquery>
                                
                                <cfset e_grand_total = 0>
                                <cfset e_f_total = 0>
                                <cfloop query="get_alislar">
                                    <cfset e_f_total = e_f_total + BASE_VALUE>
                                    <cfset action_date_ = get_alislar.ACTION_DATE>
                                    <cfset fark_ = Ceiling(datediff('d',attributes.startdate,action_date_))>
                                    <cfset e_grand_total = e_grand_total + (BASE_VALUE * fark_)>
                                    
                                    <cfset grand_e_total = grand_e_total + BASE_VALUE>
                                    <cfset grand_e_base_total = grand_e_base_total + (BASE_VALUE * fark_)>
                                </cfloop>
                                <cfif e_f_total gt 0>
                                    <cfset ortalama_evrak_gunu_ = Ceiling(e_grand_total / e_f_total)>
                                <cfelse>
                                    <cfset ortalama_evrak_gunu_ = 0>
                                </cfif>	
                                <cfset ortalama_evrak_tarihi_ = dateadd('d',ortalama_evrak_gunu_,attributes.startdate)>
                                
                                <cfset e_grand_total = 0>
                                <cfset e_f_total = 0>
                                <cfloop query="get_alislar">
                                    <cfset e_f_total = e_f_total + BASE_VALUE>
                                    <cfset action_date_ = get_alislar.DUE_DATE>
                                    <cfset fark_ = Ceiling(datediff('d',attributes.startdate,action_date_))>
                                    <cfset e_grand_total = e_grand_total + (BASE_VALUE * fark_)>
                                    
                                    <cfset grand_v_total = grand_v_total + BASE_VALUE>
                                    <cfset grand_v_base_total = grand_v_base_total + (BASE_VALUE * fark_)>
                                </cfloop>
                                <cfif e_f_total gt 0>
                                    <cfset ortalama_vade_gunu_ = Ceiling(e_grand_total / e_f_total)>
                                <cfelse>
                                    <cfset ortalama_vade_gunu_ = 0>
                                </cfif>				
                                <cfset ortalama_vade_tarihi_ = dateadd('d',ortalama_vade_gunu_,attributes.startdate)>
                                
                                <!--- yeni odeme gunu hesaplama blogu --->
                                <cfif isdefined("attributes.is_payment_group")>
                                    <cfif len(payment_group_id)>
                                        <cfquery name="get_last_alim" dbtype="query" maxrows="1">
                                            SELECT ACTION_DATE FROM get_alislar ORDER BY ACTION_DATE DESC
                                        </cfquery>
                                        <cfif get_last_alim.recordcount and len(get_last_alim.ACTION_DATE)>
                                            <cfset son_alim_gunu_ = day(get_last_alim.ACTION_DATE)>
                                            <cfset son_alim_ay_ = month(get_last_alim.ACTION_DATE)>
                                            <cfset son_alim_yil_ = year(get_last_alim.ACTION_DATE)>
                                        <cfelse>
                                            <cfset son_alim_gunu_ = 1>
                                            <cfset son_alim_ay_ = 1>
                                            <cfset son_alim_yil_ = 2017>
                                        </cfif>
                                        
                                        <!---
                                        <cfif month(get_last_alim.ACTION_DATE) lt month(attributes.finishdate) or year(get_last_alim.ACTION_DATE) lt year(attributes.finishdate)>
                                            <cfset son_alim_gunu_ = 1>
                                            <cfset son_alim_ay_ = month(dateadd('m',1,get_last_alim.ACTION_DATE))>
                                            <cfset son_alim_yil_ = year(dateadd('m',1,get_last_alim.ACTION_DATE))>
                                        </cfif>
                                        --->
                                        
                                        <cfquery name="get_row" dbtype="query">
                                            SELECT
                                                ODEME_START,
                                                ODEME_MONTH
                                            FROM
                                                get_rows
                                            WHERE
                                                PAYMENT_GROUP_ID = #payment_group_id# AND
                                                ALIM_START <= #son_alim_gunu_# AND
                                                ALIM_FINISH >= #son_alim_gunu_#
                                            ORDER BY
                                                PAYMENT_GROUP_NAME ASC,
                                                PAYMENT_GROUP_ROW_ID ASC
                                        </cfquery>
                                        <cfif get_row.recordcount>
                                            <cfif get_row.ODEME_MONTH eq 0>
                                                <cfif son_alim_ay_ eq 2 and get_row.ODEME_START eq 30>
                                                    <cfset aydaki_gun_sayisi = daysinmonth(createodbcdatetime(createdate(son_alim_yil_,son_alim_ay_,1)))>
                                                    <cfset ortalama_vade_tarihi_ = createodbcdatetime(createdate(son_alim_yil_,2,aydaki_gun_sayisi))>
                                                <cfelse>
                                                    <cfset ortalama_vade_tarihi_ = createodbcdatetime(createdate(son_alim_yil_,son_alim_ay_,get_row.ODEME_START))>
                                                </cfif>
                                            <cfelse>
                                                <cfif son_alim_ay_ eq 2 and get_row.ODEME_START eq 30>
                                                    <cfset aydaki_gun_sayisi = daysinmonth(createodbcdatetime(createdate(son_alim_yil_,son_alim_ay_,1)))>
                                                    <cfset ortalama_vade_tarihi_ = createodbcdatetime(createdate(son_alim_yil_,son_alim_ay_,aydaki_gun_sayisi))>
                                                    <cfset ortalama_vade_tarihi_ = dateadd('m',1,ortalama_vade_tarihi_)>
                                                <cfelse>
                                                    <cfset ortalama_vade_tarihi_ = createodbcdatetime(createdate(son_alim_yil_,son_alim_ay_,get_row.ODEME_START))>
                                                    <cfset ortalama_vade_tarihi_ = dateadd('m',1,ortalama_vade_tarihi_)>
                                                </cfif>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </cfif>
                                <!--- yeni odeme gunu hesaplama blogu --->              
                                <cfif isdefined("attributes.is_payment_group")>
                                    <cfset odeme_tarihi_ = ortalama_vade_tarihi_>
                                    <cfif dayofweek(odeme_tarihi_) eq 7>
                                        <cfset odeme_tarihi_ = dateadd('d',2,ortalama_vade_tarihi_)>
                                    </cfif>
                                    <cfif dayofweek(odeme_tarihi_) eq 1>
                                        <cfset odeme_tarihi_ = dateadd('d',1,ortalama_vade_tarihi_)>
                                    </cfif>
                                <cfelse>
                                    <cfset odeme_tarihi_ = ortalama_vade_tarihi_>
                                    <cfif dayofweek(odeme_tarihi_) neq 7>
                                        <cfset odeme_tarihi_ = dateadd('d',(7 - dayofweek(odeme_tarihi_)),ortalama_vade_tarihi_)>
                                    </cfif>
                                </cfif>
                                
                                <cfset all_bakiye_ = bakiye>
                                <cfif len(attributes.limit_ust) and bakiye gt attributes.limit_ust>
                                    <cfset dongu_ = Ceiling(bakiye / attributes.limit_ust)>
                                <cfelse>
                                    <cfset dongu_ = 1>
                                </cfif>
                                <cfloop from="1" to="#dongu_#" index="aaa">
                                    <cfset currentrow_ = currentrow_ + 1>
                                    <cfif aaa neq dongu_>
                                        <cfset row_bakiye_ = attributes.limit_ust>
                                        <cfset all_bakiye_ = all_bakiye_ - row_bakiye_>
                                    <cfelse>
                                        <cfset row_bakiye_ = all_bakiye_>
                                    </cfif>
                                
                                <cfset fark_ = Ceiling(datediff('d',attributes.startdate,odeme_tarihi_))>
                                <cfset grand_o_total = grand_o_total + row_bakiye_>
                                <cfset grand_o_base_total = grand_o_base_total + (row_bakiye_ * fark_)>
                                <tbody>
                                    <tr rel="table_rows" id="row_#currentrow_#">         
                                        <td>#currentrow_#</td>                   	
                                        <td>
                                        <!-- sil -->
                                        <input type="hidden" name="company_id#currentrow_#" id="company_id#currentrow_#" value="#COMPANY_ID#"/>
                                        <input type="hidden" name="payment_group_id#currentrow_#" id="payment_group_id#currentrow_#" value="#payment_group_id#"/>
                                        <input type="hidden" name="payment_group_row_id#currentrow_#" id="payment_group_row_id#currentrow_#" value="#payment_group_row_id#"/>
                                        <input type="checkbox" name="row_active#currentrow_#" id="row_active#currentrow_#" value="1" checked="checked"/>
                                        <!-- sil -->
                                        </td>
                                        <td>
                                        <cfif fusebox.fuseaction contains 'autoexcel'>
                                            #FULLNAME#
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=cheque.list_cheques&status=6&is_form_submitted=1&company_id=#company_id#&member_type=partner&company=#get_par_info(COMPANY_ID,1,1,0)#" target="c_window"><i class="fa fa-money"></i></a>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#COMPANY_ID#','page');" class="tableyazi">#left(NICKNAME,25)#</a>
                                        </cfif>
                                        </td>
                                        <td>#PAYMENT_GROUP_NAME#</td>
                                        <td nowrap>
                                            <cfinput type="text" name="evrak_tarihi#currentrow_#" value="#dateformat(ortalama_evrak_tarihi_,'dd/mm/yyyy')#" rel="evrak" readonly="yes"  validate="eurodate">
                                        </td>
                                        <td>
                                            <cfinput type="text" name="vade_tarihi#currentrow_#" value="#dateformat(ortalama_vade_tarihi_,'dd/mm/yyyy')#" rel="vadesi" readonly="yes" validate="eurodate">
                                        </td>
                                        <td>
                                            <cfinput type="text" name="vade_gun#currentrow_#" rel="vade_gun"  value="#datediff('d',ortalama_evrak_tarihi_,ortalama_vade_tarihi_)#"  readonly="yes" class="moneybox"></td>
                                        <td>
                                            <cfinput type="text" name="islem_tar_vade#currentrow_#" value="#datediff('d',attributes.islem_tarihi,odeme_tarihi_)#"  readonly="yes" class="moneybox" rel="islem_tar_vade">
                                        </td>                
                                        <td ><cfinput type="text" comp_rel="bakiye#comp_id_#" name="bakiye#currentrow_#" value="#tlformat(row_bakiye_,2)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event,2));" onBlur="uzatmatarhesapla('#currentrow_#','1');"></td> 
                                        <td><cfinput type="text" name="uzatma_gun#currentrow_#" value="0"  class="moneybox" rel="uzatma_gun" onChange="uzatmatarhesapla('#currentrow_#','1');"></td>
                                        <td><cfinput type="text" name="uzatma_tarih#currentrow_#" comp_rel="uzatma_tarih#comp_id_#" value="#dateformat(ortalama_vade_tarihi_,'dd/mm/yyyy')#" rel="uzatma_tarih" validate="eurodate"></td>
                                        <td><cfinput type="text" comp_rel="odeme_gunu_tarih#comp_id_#" name="odeme_gunu_tarih#currentrow_#" value="#dateformat(odeme_tarihi_,'dd/mm/yyyy')#" rel="odeme_gunu_tarih" ></td>                    
                                        <td><cfinput type="text" name="son_vade_gun#currentrow_#" value="#datediff('d',ortalama_evrak_tarihi_,odeme_tarihi_)#"  class="moneybox" rel="son_vade_gun" ></td>
                                        <td><cfinput type="text" name="vade_asimi#currentrow_#" value="#datediff('d',ortalama_vade_tarihi_,odeme_tarihi_)#"  class="moneybox" rel="vade_asimi"></td>
                                        <cfif isdefined("attributes.is_bank")>
                                        <td><cfinput type="hidden" name="bank_name#currentrow_#" value="#bank_name#" rel="bank_name" >#bank_name#</td>
                                        <td><cfinput type="hidden" name="bank_iban#currentrow_#" value="#bank_iban#" rel="bank_iban" >#bank_iban#</td>
                                        </cfif>
                                        <td>
                                            <div id="action_div_#currentrow_#" style="display:none;"></div>
                                            <ul class="ui-icon-list">
                                                <li><input type="button" value="D" onclick="get_detail_rows('#currentrow_#');"/></li>
                                                <li><input type="button" value="D2" onclick="get_detail_rows2('#currentrow_#');"/></li>
                                            </ul>
                                        </td>
                                    </tr>
                                </tbody>
                                <cfset total_bakiye = total_bakiye + row_bakiye_>
                                    <cfif dongu_ gt 1 and aaa eq dongu_>
                                        <tbody>
                                            <tr class="color-header" rel="table_rows">
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td class="txtbold">#left(NICKNAME,25)#</td>
                                                <td colspan="5">&nbsp;</td>
                                                <td ><cfinput type="text" name="t_bakiye#company_id#" value="#tlformat(bakiye,2)#" class="moneybox"  readonly="yes"></td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td><cfinput type="text" name="t_odeme_gunu_tarih#company_id#" value="#dateformat(odeme_tarihi_,'dd/mm/yyyy')#" readonly="yes"></td>                    
                                                <td><cfinput type="text" name="t_son_vade_gun#company_id#" value="#datediff('d',ortalama_evrak_tarihi_,odeme_tarihi_)#"  class="moneybox" readonly="yes"></td>
                                                <td><cfinput type="text" name="t_vade_asimi#company_id#" value="#datediff('d',ortalama_vade_tarihi_,odeme_tarihi_)#"  class="moneybox" readonly="yes"></td>
                                                <cfif isdefined("attributes.is_bank")>
                                                <td>#bank_name#</td>
                                                <td>#bank_iban#</td>
                                                </cfif>
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </cfif>
                                </cfloop>  
                            </cfoutput>
                        </cfif>
                    <cfoutput>
                        <cfif grand_e_total gt 0>
                            <tfoot>
                                <tr class="formbold" rel="table_rows">
                                    <td colspan="4"><cf_get_lang dictionary_id='40302.Toplamlar'></td>
                                    <td>
                                        <cfset ortalama_evrak_gunu_ = Ceiling(grand_e_base_total / grand_e_total)>
                                        <cfset ortalama_evrak_tarihi_ = dateadd('d',ortalama_evrak_gunu_,attributes.startdate)>
                                        #dateformat(ortalama_evrak_tarihi_,'dd/mm/yyyy')#
                                    </td>
                                    <td>
                                        <cfset ortalama_vade_gunu_ = Ceiling(grand_v_base_total / grand_v_total)>
                                        <cfset ortalama_vade_tarihi_ = dateadd('d',ortalama_vade_gunu_,attributes.startdate)>
                                        #dateformat(ortalama_vade_tarihi_,'dd/mm/yyyy')#
                                    </td>
                                    <td style="text-align:right">#datediff('d',ortalama_evrak_tarihi_,ortalama_vade_tarihi_)#</td>
                                    <td style="text-align:right">#datediff('d',attributes.islem_tarihi,ortalama_vade_tarihi_)#</td>
                                    <td style="text-align:right">#tlformat(total_bakiye)#</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>
                                        <cfset ortalama_odeme_gunu_ = Ceiling(grand_o_base_total / grand_o_total)>
                                        <cfset ortalama_odeme_tarihi_ = dateadd('d',ortalama_odeme_gunu_,attributes.startdate)>
                                        #dateformat(ortalama_odeme_tarihi_,'dd/mm/yyyy')#
                                    </td>
                                    <td style="text-align:right">#datediff('d',ortalama_evrak_tarihi_,ortalama_odeme_tarihi_)#</td>
                                    <td style="text-align:right">#datediff('d',ortalama_vade_tarihi_,ortalama_odeme_tarihi_)#</td>
                                    <cfif isdefined("attributes.is_bank")>
                                    <td></td>
                                    <td></td>
                                    </cfif>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </cfif>
                    </cfoutput>
                </cf_grid_list>
                   
                <cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
                    </div>
                    <div id="later_payments"><cf_get_lang dictionary_id='61996.İleri Tarihli Ödemeler'></div>
                </cfif>
                    <cfinput type="hidden" name="row_count" value="#currentrow_#">
                <!-- sil -->
            </cfform>
        </cfif>
    </cf_box>
</div>
             
      
     
<script>
	<cfif listlen(attributes.company_ids)>
		<cfloop list="#attributes.company_ids#" index="ccc">
			<cfoutput>add_c_row('#ccc#','#get_par_info(ccc,1,1,0)#');</cfoutput>
		</cfloop>
	</cfif>
</script>
</cfif>


<cfif not fusebox.fuseaction contains 'autoexcelpopuppage_'>
    <cfif isdefined("get_bakiye") and get_bakiye.recordcount>
        <script language="javascript">
            $(document).ready(function()
            {
                adress_ = '<cfoutput>#request.self#?fuseaction=retail.calc_cheque_management</cfoutput>';
                adress_ += '&row_count=' + document.getElementById('row_count').value;
                AjaxPageLoad(adress_,'later_payments',1);
            }
            );
                function uzatmaekle()
                {
                    ana_deger1 = document.getElementById('uzatma_ekle').value;
                    for (var i=1; i <= <cfoutput>#currentrow_#</cfoutput>; i++) //ul içindeki lileri döndürüyoruz
                    {
                        document.getElementById('uzatma_gun' + i).value	= ana_deger1;
                        if(i == <cfoutput>#currentrow_#</cfoutput>)
                        {
                            uzatmatarhesapla(i,'1');
                        }
                        else
                        {
                            uzatmatarhesapla(i,'0');
                        }
                    }
                    return false;
                }
                function uzatmatarhesapla(row,type)
                {
                    row_uzatma_gunu_ = document.getElementById('uzatma_gun' + row).value;
                    if(row_uzatma_gunu_ == '' || isNaN(row_uzatma_gunu_))
                    {
                        row_uzatma_gunu_ = 0;
                    }
                    else
                    {
                        row_uzatma_gunu_ = parseInt(row_uzatma_gunu_);	
                    }
                    adress_ = '<cfoutput>#request.self#?fuseaction=retail.emptypopup_calc_date</cfoutput>';
                    adress_ += '&uzatma_gun=' + row_uzatma_gunu_;
                    adress_ += '&vade_tarihi=' + document.getElementById('vade_tarihi'+row).value;
                    adress_ += '&evrak_tarihi=' + document.getElementById('evrak_tarihi'+row).value;
                    adress_ += '&islem_tarihi=<cfoutput>#dateformat(attributes.islem_tarihi,"dd/mm/yyyy")#</cfoutput>';
                    adress_ += '&startdate=<cfoutput>#dateformat(attributes.startdate,"dd/mm/yyyy")#</cfoutput>';
                    adress_ += '&row_id=' + row;
                    adress_ += '&type=' + type;
                    AjaxPageLoad(adress_,'action_div_' + row,1);
                }
                
                function control_miktar()
                {
                    var keycode;
                    if(window.event) 
                        keycode = window.event.keyCode;
                    else if(e) 
                        keycode = e.which;
                        
                    if(keycode == 13)
                    {
                        return uzatmaekle();
                    }
                }
        </script>
    </cfif>
</cfif>