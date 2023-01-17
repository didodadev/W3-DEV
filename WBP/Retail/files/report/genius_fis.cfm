<cfparam name="attributes.fis_numarasi" default="">
<cfparam name="attributes.musteri_numarasi" default="">
<cfparam name="attributes.hareket_tipi" default="">
<cfparam name="attributes.search_department_id" default="">
<cfparam name="attributes.kasiyer_ids" default="">
<cfparam name="attributes.kasa_numarasi" default="">
<cfparam name="attributes.iptal_type" default="0">
<cfparam name="attributes.odeme_tip" default="">
<cfset bugun_ = now()>
<cfset base_date_ = bugun_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfquery name="get_tips" datasource="#dsn_dev#">
	SELECT * FROM GENIUS_ACTION_TYPES ORDER BY TYPE_ID ASC
</cfquery>

<cfquery name="get_odeme_tips" datasource="#dsn_dev#">
	SELECT CODE,HEADER FROM SETUP_POS_PAYMETHODS ORDER BY HEADER
</cfquery>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	BRANCH_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#,#merkez_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_kasalar" datasource="#dsn#">
	SELECT 
    	B.BRANCH_NAME + ' - ' + ISNULL(PE.EQUIPMENT_CODE,'') KASA_ADI,
        PE.EQUIPMENT_CODE
    FROM 
    	BRANCH B,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
        B.BRANCH_ID = PE.BRANCH_ID AND
        B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	BRANCH_NAME,
        PE.EQUIPMENT_CODE
</cfquery>

<cfquery name="get_kasa_kullanicilar" datasource="#dsn#">
	SELECT 
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME + ' (' + B.BRANCH_NAME + ')' AS KASIYER,
        E.EMPLOYEE_ID
    FROM 
    	BRANCH B,
        #dsn_dev_alias#.POS_USERS PE,
        EMPLOYEES E
    WHERE
        E.EMPLOYEE_ID = PE.EMPLOYEE_ID AND
        B.BRANCH_ID = PE.BRANCH_ID AND
        B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	BRANCH_NAME,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME
</cfquery>

<cfquery name="get_fis" datasource="#dsn_dev#">
	SELECT
    	B.BRANCH_NAME,
        PE.EQUIPMENT_CODE,
        GAT.TYPE_NAME AS BELGE_TUR_ADI,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS KASIYER,
        GA.*
    FROM 
    	#dsn_alias#.BRANCH B,
        #dsn3_alias#.POS_EQUIPMENT PE,
        GENIUS_ACTIONS GA
        	INNER JOIN GENIUS_ACTION_TYPES GAT ON (GAT.TYPE_ID = GA.BELGE_TURU)
            INNER JOIN #dsn_alias#.EMPLOYEES E ON (E.EMPLOYEE_ID = GA.KASIYER_NO)
    WHERE
    	<cfif isdefined("attributes.search_stock_id") and len(attributes.search_stock_id)>
        	GA.ACTION_ID IN (SELECT GAR.ACTION_ID FROM GENIUS_ACTIONS_ROWS GAR WHERE STOCK_ID IN (#attributes.search_stock_id#)) AND
        </cfif>
		<cfif len(attributes.odeme_tip)>
        	GA.ACTION_ID IN (SELECT ACTION_ID FROM GENIUS_ACTIONS_PAYMENTS WHERE ODEME_TURU = #attributes.odeme_tip#) AND
        </cfif>
		<cfif attributes.iptal_type eq 0>
        	GA.FIS_IPTAL = 0 AND
        </cfif>
        <cfif attributes.iptal_type eq 1>
        	GA.FIS_IPTAL = 1 AND
        </cfif>
		<cfif not session.ep.ehesap>
            B.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        <cfif isdefined("attributes.search_department_id") and len(attributes.search_department_id)>
        	B.BRANCH_ID IN (#attributes.search_department_id#) AND
        </cfif>
        <cfif len(attributes.fis_numarasi)>
        	GA.FIS_NUMARASI = '#attributes.fis_numarasi#' AND
        </cfif>
        <cfif len(attributes.kasa_numarasi)>
        	GA.KASA_NUMARASI IN (#attributes.kasa_numarasi#) AND
        </cfif>
        <cfif len(attributes.musteri_numarasi)>
        	GA.MUSTERI_NO = '#attributes.musteri_numarasi#' AND
        </cfif>
        <cfif len(attributes.hareket_tipi)>
        	GA.BELGE_TURU IN ('#replace(attributes.hareket_tipi,",","','","all")#') AND
        </cfif>
        <cfif len(attributes.kasiyer_ids)>
        	GA.KASIYER_NO IN (#attributes.kasiyer_ids#) AND
        </cfif>
        PE.BRANCH_ID = B.BRANCH_ID AND
        PE.EQUIPMENT_CODE = GA.KASA_NUMARASI AND
    	GA.FIS_TARIHI >= #attributes.startdate# AND GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_fis.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfsavecontent  variable="title"><cf_get_lang dictionary_id='45504.Fişler'></cfsavecontent>
<cf_report_list_search title="#title#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.genius_fis" method="post" name="search_">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='30066.Fiş'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfinput type="text" name="fis_numarasi" value="#attributes.fis_numarasi#" style="width:50px;">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="GET_KASALAR"  
                                        name="kasa_numarasi"
                                        option_text="#getLang('','Kasalar',58657)#" 
                                        width="180"
                                        option_name="KASA_ADI" 
                                        option_value="equipment_code"
                                        filter="1"
                                        value="#attributes.kasa_numarasi#">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_kasa_kullanicilar"  
                                        name="kasiyer_ids"
                                        option_text="#getLang('','Kasiyer',54577)#" 
                                        width="180"
                                        option_name="KASIYER" 
                                        option_value="employee_id"
                                        filter="1"
                                        value="#attributes.kasiyer_ids#">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="musteri_numarasi" value="#attributes.musteri_numarasi#" style="width:110px;">
                                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_list_cons&member_card_no=search_.musteri_numarasi','wide')"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_departments_search"  
                                        name="search_department_id"
                                        option_text="#getLang('','Şube',57453)#" 
                                        width="150"
                                        option_name="department_head" 
                                        option_value="BRANCH_ID"
                                        filter="0"
                                        value="#attributes.search_department_id#">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_tips"  
                                        name="hareket_tipi"
                                        option_text="#getLang('','İşlem Tipi',61806)#" 
                                        width="150"
                                        option_name="TYPE_name" 
                                        option_value="TYPE_ID"
                                        filter="0"
                                        value="#attributes.hareket_tipi#">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58928.Ödeme Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="odeme_tip">
                                            <option value=""><cf_get_lang dictionary_id='48792.Ödeme Tipi Seçiniz'></option>
                                        <cfoutput query="get_odeme_tips">
                                            <option value="#code#" <cfif attributes.odeme_tip eq code>selected</cfif>>#header#</option>
                                        </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='45504.Fişler'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="iptal_type">
                                            <option value="0" <cfif attributes.iptal_type eq 0>selected</cfif>><cf_get_lang dictionary_id='62199.Geçerli Fişler'></option>
                                            <option value="1" <cfif attributes.iptal_type eq 1>selected</cfif>><cf_get_lang dictionary_id='62200.İptal Fişler'></option>
                                            <option value="2" <cfif attributes.iptal_type eq 2>selected</cfif>><cf_get_lang dictionary_id='62201.Tüm Fişler'></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <br>
                                <div class="form-group">
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <div class="col col-8 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                    <div class="col col-8 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"></label>
                                    <div class="col col-12 col-xs-12">
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=10&op_f_name=add_row</cfoutput>','list');"><i class="icn-md icon-plus-square"></i></a>
                                    </div>
                                    <div id="product_div">
                                        <cfif isdefined("attributes.search_stock_id") and len(attributes.search_stock_id)>
                                            <cfquery name="get_stocks" datasource="#dsn1#">
                                                SELECT STOCK_ID,PROPERTY FROM STOCKS WHERE STOCK_ID IN (#attributes.search_stock_id#)
                                            </cfquery>
                                            <cfoutput query="get_stocks">
                                                <div id="selected_product_#STOCK_ID#"><a href="javascript://" onclick="del_row_p('#STOCK_ID#')"><img src="/images/delete_list.gif"></a><input type="hidden" name="search_stock_id" value="#stock_id#">#property#</div>
                                            </cfoutput>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row ReportContentBorder">
                            <div class="ReportContentFooter">
                                <cf_wrk_search_button button_type="1">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>
        
    
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>
                    <th><cf_get_lang dictionary_id='30631.Tarih'></th>
                    <th><cf_get_lang dictionary_id='61506.Mağaza Adı'></th>
                    <th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
                    <th><cf_get_lang dictionary_id='57520.Kasa'></th>
                    <th><cf_get_lang dictionary_id='57946.Fiş No'></th>
                    <th><cf_get_lang dictionary_id='54577.Kasiyer'></th>
                    <th><cf_get_lang dictionary_id='30817.Müşteri No'></th>
                    <th><cf_get_lang dictionary_id='58508.Satır'> S.</th>
                    <th><cf_get_lang dictionary_id='57847.Ödeme'> S.</th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='39129.Satış Tutarı'></th>
                    <th width="15"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_fis.recordcount>
                    <cfoutput query="get_fis" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td><cfif FIS_IPTAL eq 0><cf_get_lang dictionary_id='40906.Geçerlilik'><cfelse><cf_get_lang dictionary_id='58506.İptal'></cfif></td>
                        <td>#dateformat(FIS_TARIHI,'dd/mm/yyyy')#</td>
                        <td>#BRANCH_NAME#</td>
                        <td>#BELGE_TUR_ADI#</td>
                        <td>#KASA_NUMARASI#</td>
                        <td>#FIS_NUMARASI#</td>
                        <td>#KASIYER#</td>
                        <td>#MUSTERI_NO#</td>
                        <td>#HAREKET_SAYISI#</td>
                        <td>#ODEME_SAYISI#</td>
                        <td style="text-align:right;">#TLFORMAT(FIS_TOPLAM)#</td>
                        <td width="15"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.genius_fis&event=upd&action_id=#ACTION_ID#','wide')"><img src="/images/update_list.gif" border="0"/></a></td>
                    </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif len(attributes.fis_numarasi)>
                <cfset url_string = '#url_string#&fis_numarasi=#attributes.fis_numarasi#'>
            </cfif>
            <cfif len(attributes.kasa_numarasi)>
                <cfset url_string = '#url_string#&kasa_numarasi=#attributes.kasa_numarasi#'>
            </cfif>
            <cfif len(attributes.iptal_type)>
                <cfset url_string = '#url_string#&iptal_type=#attributes.iptal_type#'>
            </cfif>
            <cfif len(attributes.startdate)>
                <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#'>
            </cfif>
            <cfif len(attributes.finishdate)>
                <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#'>
            </cfif>
            <cfif isdefined("attributes.musteri_numarasi")>
                <cfset url_string = '#url_string#&musteri_numarasi=#attributes.musteri_numarasi#'>
            </cfif>	
            <cfif isdefined("attributes.search_department_id")>
                <cfset url_string = '#url_string#&search_department_id=#attributes.search_department_id#'>
            </cfif>	
            <cfif isdefined("attributes.hareket_tipi")>
                <cfset url_string = '#url_string#&hareket_tipi=#attributes.hareket_tipi#'>
            </cfif>
            <cfif len(attributes.odeme_tip)>
                <cfset url_string = '#url_string#&odeme_tip=#attributes.odeme_tip#'>
            </cfif>

            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="retail.genius_fis#url_string#">
            
        </cfif>
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
</script>