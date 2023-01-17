<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.special_code" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_code" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.location_name" default="">
<cfparam name="attributes.is_stock_active" default="1">
<cfparam name="attributes.product_serial_no" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cf_xml_page_edit fuseact="objects.serial_no">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isDefined("attributes.is_form_submitted")>
    <cfquery name = "get_product" datasource="#dsn3#">
        SELECT 
            SGNEW.SERIAL_NO,
            SGNEW.LOT_NO,
            SGNEW.ROW_PURCHASE_1,
            SGNEW.ROW_PURCHASE_2,
            ( SGNEW.ROW_PURCHASE_1 - SGNEW.ROW_PURCHASE_2 ) AS TOTAL,
            SGNEW.TOPLAM_TOP,
            SGNEW.PRODUCT_CODE_2,
            SGNEW.PRODUCT_NAME,
            SGNEW.STOCK_CODE,
            SGNEW.PROPERTY,
            SGNEW.DEPARTMENT_HEAD,
            SGNEW.DEPARTMENT_ID,
            SGNEW.LOCATION_ID,
            SGNEW.STOCK_ID,
            <cfif not len(attributes.product_serial_no)>
            SGNEW.COMMENT,
            </cfif>
            SGNEW.PRODUCT_ID,
            SGNEW.INSPECTION_LEVEL_ID,
            SGNEW.QUALITY_ID,
            SGNEW.GROUP_CODE,
            SGNEW.GUARANTY_ID
        FROM
        (
            SELECT 
                SERIAL_NO,
                LOT_NO,
                COUNT(SERIAL_NO) AS TOPLAM_TOP,
                PRODUCT_CODE_2,
                PRODUCT_NAME,
                STOCK_CODE,
                PROPERTY,
                DEPARTMENT_HEAD,
                D3.DEPARTMENT_ID,
                <cfif not len(attributes.product_serial_no)>
                    SL3.LOCATION_ID,
                    <cfelse>
                    SGN.LOCATION_ID,   
                </cfif>
                S3.STOCK_ID,
                <cfif not len(attributes.product_serial_no)>
                SL3.COMMENT,
                </cfif>
                S3.PRODUCT_ID,
                SGN.INSPECTION_LEVEL_ID,
                SGN.QUALITY_ID,
                SGN.GROUP_CODE,
                SGN.GUARANTY_ID,
                (
                    SELECT ISNULL(SUM(SGN2.UNIT_ROW_QUANTITY),0) AS ROW_1
                    FROM SERVICE_GUARANTY_NEW SGN2 
                    LEFT JOIN STOCKS S ON SGN2.STOCK_ID = S.STOCK_ID
                    LEFT JOIN #dsn_alias#.DEPARTMENT D ON SGN2.DEPARTMENT_ID = D.DEPARTMENT_ID
                    WHERE SGN2.IN_OUT = 1 AND SGN2.SERIAL_NO = SGN.SERIAL_NO  
                    <cfif len(attributes.department_id)>
                        AND SGN2.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                    </cfif>
                    <cfif len(attributes.location_id)>
                        AND SGN2.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> 
                    </cfif>
                    <cfif isDefined("attributes.stock_code") and len(attributes.stock_code)>
                        AND S.STOCK_CODE LIKE '<cfif len(attributes.stock_code) gt 3>%</cfif>#attributes.stock_code#%'
                    </cfif>
                    <cfif isDefined("attributes.product_name") and len(attributes.product_name)>
                        AND S.PRODUCT_NAME LIKE '%#attributes.product_name#%'
                    </cfif>
                    <cfif isDefined("attributes.special_code") and len(attributes.special_code)>
                        AND S.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(attributes.special_code) gt 2,DE("%"),DE(""))##attributes.special_code#%">
                    </cfif>
                ) AS ROW_PURCHASE_1,
                (
                    SELECT ISNULL(SUM(SGN3.UNIT_ROW_QUANTITY),0) AS ROW_2 
                    FROM SERVICE_GUARANTY_NEW SGN3 
                    LEFT JOIN STOCKS S2 ON SGN3.STOCK_ID = S2.STOCK_ID
                    LEFT JOIN #dsn_alias#.DEPARTMENT D2 ON SGN3.DEPARTMENT_ID = D2.DEPARTMENT_ID
                    WHERE SGN3.IN_OUT = 0 AND SGN3.SERIAL_NO = SGN.SERIAL_NO  
                    <cfif len(attributes.department_id)>
                        AND SGN3.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                    </cfif>
                    <cfif len(attributes.location_id)>
                        AND SGN3.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> 
                    </cfif>
                    <cfif isDefined("attributes.stock_code") and len(attributes.stock_code)>
                        AND S2.STOCK_CODE LIKE '<cfif len(attributes.stock_code) gt 3>%</cfif>#attributes.stock_code#%'
                    </cfif>
                    <cfif isDefined("attributes.product_name") and len(attributes.product_name)>
                        AND S2.PRODUCT_NAME LIKE '%#attributes.product_name#%'
                    </cfif>
                    <cfif isDefined("attributes.special_code") and len(attributes.special_code)>
                        AND S2.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(attributes.special_code) gt 2,DE("%"),DE(""))##attributes.special_code#%">
                    </cfif>
                ) AS ROW_PURCHASE_2
            FROM 
                SERVICE_GUARANTY_NEW AS SGN
                LEFT JOIN STOCKS S3 ON SGN.STOCK_ID = S3.STOCK_ID
                LEFT JOIN #dsn_alias#.DEPARTMENT D3 ON SGN.DEPARTMENT_ID = D3.DEPARTMENT_ID
                <cfif not len(attributes.product_serial_no)>
                LEFT JOIN #dsn_alias#.STOCKS_LOCATION SL3 ON SL3.LOCATION_ID = SGN.LOCATION_ID
                </cfif>
            WHERE 
                1 = 1
                <cfif not len(attributes.product_serial_no)>
                AND SL3.DEPARTMENT_ID = D3.DEPARTMENT_ID
                </cfif>
                <cfif len(attributes.department_id)>
                    AND SGN.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                </cfif>
                <cfif len(attributes.location_id) and not len(attributes.product_serial_no)>
                    AND SL3.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
                    <cfelseif len(attributes.location_id)>
                    AND SGN.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
                </cfif>
                <cfif isDefined("attributes.stock_code") and len(attributes.stock_code)>
                    AND S3.STOCK_CODE LIKE '<cfif len(attributes.stock_code) gt 3>%</cfif>#attributes.stock_code#%'
                </cfif>
                <cfif isDefined("attributes.product_name") and len(attributes.product_name)>
                    AND S3.PRODUCT_NAME LIKE '%#attributes.product_name#%'
                </cfif>
                <cfif isDefined("attributes.special_code") and len(attributes.special_code)>
                    AND S3.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(attributes.special_code) gt 2,DE("%"),DE(""))##attributes.special_code#%">
                </cfif>
                <cfif isDefined("attributes.product_serial_no") and len(attributes.product_serial_no)>
                    AND SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
                </cfif>
                AND IN_OUT = 1
            GROUP BY
                SERIAL_NO,
                LOT_NO,
                PRODUCT_CODE_2,
                PRODUCT_NAME,
                STOCK_CODE,
                PROPERTY,
                DEPARTMENT_HEAD,
                D3.DEPARTMENT_ID,
                <cfif not len(attributes.product_serial_no)>
                SL3.LOCATION_ID,
                <cfelse>
                 SGN.LOCATION_ID,
                </cfif>
                S3.STOCK_ID,
                <cfif not len(attributes.product_serial_no)>
                COMMENT,
                </cfif>
                S3.PRODUCT_ID,
                SGN.INSPECTION_LEVEL_ID,
                SGN.QUALITY_ID,
                SGN.GROUP_CODE,
                SGN.GUARANTY_ID
        ) AS SGNEW
        WHERE SGNEW.ROW_PURCHASE_1 - SGNEW.ROW_PURCHASE_2 > 0
    </cfquery>
    <!--- <cfdump var="#get_product#"> --->
<cfelse>
	<cfset get_product.recordcount = 0>
</cfif>
<cfif get_product.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_product.recordCount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="stock_search" method="post">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<cf_box_search more="0">
				<cfoutput>
                    <div class="form-group" id="item-product_serial_no">
                        <input type="text" name="product_serial_no" id="product_serial_no" placeholder="<cfoutput><cf_get_lang dictionary_id='57637.Seri No'></cfoutput>" value="<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no)><cfoutput>#attributes.product_serial_no#</cfoutput></cfif>">
                    </div>
                    <div class="form-group">
                        <cfinput type="text" name="product_name" placeholder="#getlang('','Ürün Adı',58221)#" value="#attributes.product_name#">
                    </div>
                    <div class="form-group">
                        <cfinput type="text" name="special_code" placeholder="#getlang('','Özel Kod',57789)#" value="#attributes.special_code#">
                    </div>
					<div class="form-group">
						<cfinput type="text" name="stock_code" placeholder="#getlang(106,'Stok Kodu',57518)#" value="#attributes.stock_code#" maxlength="50">
					</div>
					<div class="form-group" id="item-department_id">
                        <cf_wrkdepartmentlocation 
                        returninputvalue="location_id,location_name,department_id"
                        returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                        fieldname="location_name"
                        fieldid="location_id"
                        status="1"
                        is_department="1"
                        department_fldid="department_id"
                        department_id="#attributes.department_id#"
                        location_id="#attributes.location_id#"
                        location_name="#attributes.location_name#"
                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                        user_location = "0"
                        width="140">
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" maxlength="3" required="yes" onKeyUp="isNumber(this)" message="#message#">
					</div>
                    <div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</cfoutput>
			</cf_box_search>
		</cfform>
	</cf_box>
    <cf_box title="Seri Listesi">
        <cfform id="serial_list">
        <cf_grid_list>
			<thead>
				<tr>
                    <th width="20"></th>
                    <th><cf_get_lang dictionary_id='57637.Seri No'></th>
                    <th><cf_get_lang dictionary_id='57518.Stok kodu'></th>
                    <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th><cf_get_lang dictionary_id='32916.Lot No'></th>
                    <cfif xml_quality_show eq 1>
                        <th><cf_get_lang dictionary_id='37457.Muayene Seviyesi'></th>
                        <th><cf_get_lang dictionary_id='37000.Kalite Başarımı'></th>
                        <th><cf_get_lang dictionary_id='51499.Grup Kodu'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='58763.Depo'></th>
                    <th width="100"><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th width="70"><cf_get_lang dictionary_id='57636.Birim'></th>
                    <th width="20"><input id="check_serial_All" name="check_serial_All" onclick="change_check();checkControl();" type="checkbox"></th>
                    <cfif xml_quality_show eq 1>
                    <th width="20"><input id="check_serial_All2" name="check_serial_All2" onclick="change_check2();" type="checkbox"></th>
                    </cfif>
                </tr>
            </thead>
            <tbody>
                <cfif isDefined("get_product") and get_product.recordcount gt 0>
                    <cfoutput query="get_product" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <cfif len(attributes.product_serial_no)>
                        <cfquery name = "get_amount" datasource="#dsn3#">
                            SELECT 
                                ( SGNEW.ROW_PURCHASE_1 - SGNEW.ROW_PURCHASE_2 ) AS TOTAL
                            FROM
                            (
                                SELECT 
                                    SERIAL_NO,
                                    LOT_NO,
                                    COUNT(SERIAL_NO) AS TOPLAM_TOP,
                                    PRODUCT_NAME,
                                    STOCK_CODE,
                                    PROPERTY,
                                    DEPARTMENT_HEAD,
                                    S3.STOCK_ID,
                                    BARCOD,
                                    (
                                        SELECT ISNULL(SUM(SGN2.UNIT_ROW_QUANTITY),0) AS ROW_1
                                        FROM SERVICE_GUARANTY_NEW SGN2 
                                        LEFT JOIN STOCKS S ON SGN2.STOCK_ID = S.STOCK_ID
                                        LEFT JOIN #dsn_alias#.DEPARTMENT D ON SGN2.DEPARTMENT_ID = D.DEPARTMENT_ID
                                        WHERE SGN2.IN_OUT = 1 AND SGN2.SERIAL_NO = SGN.SERIAL_NO  
                                        AND SGN2.DEPARTMENT_ID = #DEPARTMENT_ID#
                                        AND SGN2.LOCATION_ID = #LOCATION_ID# 
                                        AND SGN2.SERIAL_NO = '#SERIAL_NO#'
                                        AND S.STOCK_ID = #STOCK_ID#
                                    ) AS ROW_PURCHASE_1,
                                    (
                                        SELECT ISNULL(SUM(SGN3.UNIT_ROW_QUANTITY),0) AS ROW_2 
                                        FROM SERVICE_GUARANTY_NEW SGN3 
                                        LEFT JOIN STOCKS S2 ON SGN3.STOCK_ID = S2.STOCK_ID
                                        LEFT JOIN #dsn_alias#.DEPARTMENT D2 ON SGN3.DEPARTMENT_ID = D2.DEPARTMENT_ID
                                        WHERE SGN3.IN_OUT = 0 AND SGN3.SERIAL_NO = SGN.SERIAL_NO  
                                        AND SGN3.DEPARTMENT_ID = #DEPARTMENT_ID#
                                        AND SGN3.LOCATION_ID = #LOCATION_ID# 
                                        AND SGN3.SERIAL_NO = '#SERIAL_NO#'
                                        AND S2.STOCK_ID = #STOCK_ID#
                                    ) AS ROW_PURCHASE_2
                                FROM 
                                    SERVICE_GUARANTY_NEW AS SGN
                                    LEFT JOIN STOCKS S3 ON SGN.STOCK_ID = S3.STOCK_ID
                                    LEFT JOIN #dsn_alias#.DEPARTMENT D3 ON SGN.DEPARTMENT_ID = D3.DEPARTMENT_ID
                                WHERE 
                                    1 = 1
                                    AND SGN.DEPARTMENT_ID = #DEPARTMENT_ID#
                                    AND SGN.LOCATION_ID = #LOCATION_ID#    
                                    AND SGN.SERIAL_NO = '#SERIAL_NO#'         
                                    AND S3.STOCK_ID = #STOCK_ID#
                                    AND IN_OUT = 1
                                GROUP BY
                                    SERIAL_NO,
                                    LOT_NO,
                                    PRODUCT_NAME,
                                    STOCK_CODE,
                                    PROPERTY,
                                    DEPARTMENT_HEAD,
                                    S3.STOCK_ID,
                                    BARCOD
                            ) AS SGNEW
                            WHERE SGNEW.ROW_PURCHASE_1 - SGNEW.ROW_PURCHASE_2 > 0
                        </cfquery>
                        </cfif>
                        <input type="hidden" id="stock_id#currentrow#" name="stock_id#currentrow#" value="#STOCK_ID#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=objects.serial_no&event=det&product_serial_no=#SERIAL_NO#">#SERIAL_NO#</a></td>
                            <td><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#PRODUCT_ID#">#STOCK_CODE#</td>
                            <td>#PRODUCT_CODE_2#</td>
                            <td>#PRODUCT_NAME# #PROPERTY#</td>
                            <td>#LOT_NO#</td>
                        <cfif xml_quality_show eq 1>
                        <cfif len(INSPECTION_LEVEL_ID)>
                            <cfquery name = "get_level" datasource="#dsn3#">
                                SELECT 
                                    INSPECTION_LEVEL_ID,
                                    INSPECTION_LEVEL_CODE
                                FROM
                                    SETUP_INSPECTION_LEVEL
                                WHERE
                                INSPECTION_LEVEL_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#INSPECTION_LEVEL_ID#">
                            </cfquery>
                            <td> 
                               #get_level.INSPECTION_LEVEL_CODE#
                            </td>
                        <cfelse><td></td>
                        </cfif>    
                        <cfif len(QUALITY_ID)>
                            <cfquery name = "get_quality" datasource="#dsn3#">
                                SELECT 
                                    SUCCESS_ID,
                                    SUCCESS
                                FROM
                                    QUALITY_SUCCESS
                                WHERE
                                    SUCCESS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#QUALITY_ID#">
                            </cfquery>
                            <td>
                                #get_quality.SUCCESS#
                            </td>
                        <cfelse> <td></td>
                        </cfif>
                            <td>#GROUP_CODE#</td>
                        </cfif>
                            <td>#DEPARTMENT_HEAD# <cfif not len(attributes.product_serial_no)> -#COMMENT#</cfif></td>
                            <td style="text-align:right;">
                            <cfif len(attributes.product_serial_no)>#TLFormat(get_amount.TOTAL)#
                            <cfelse>
                             #TLFormat(TOTAL)#
                            </cfif>
                            </td>
                            <td style="text-align:center;">M</td>
                            <td><input class="checkControl" type="checkbox" name="action_list_id#currentrow#" id="action_list_id#currentrow#" value="#STOCK_ID#" data-serial="#URLEncodedFormat(SERIAL_NO)#" data-location="#LOCATION_ID#" data-department="#DEPARTMENT_ID#" /></td>
                        	<cfif xml_quality_show eq 1>
                            <td><input class="checkControl2" type="checkbox" name="action_list#currentrow#" id="action_list#currentrow#" value="#GUARANTY_ID#"/></td>
                            </cfif>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cfform>
        <cfif isDefined("get_product") and get_product.recordcount eq 0>
        <div class="ui-info-bottom">
            <p><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></p>
        </div>
    </cfif>
        <cfset adres = "objects.serial_no">
		<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
			<cfset adres = "#adres#&department_id=#attributes.department_id#">
		</cfif>
		<cfif isDefined("attributes.location_id") and len(attributes.location_id)>
			<cfset adres = "#adres#&location_id=#attributes.location_id#">
		</cfif>
		<cfif isDefined("attributes.is_stock_active") and len(attributes.is_stock_active)>
			<cfset adres = "#adres#&is_stock_active=#attributes.is_stock_active#">
		</cfif>
		<cfif isDefined('attributes.stock_code') and len(attributes.stock_code)>
			<cfset adres = "#adres#&stock_code=#attributes.stock_code#">
		</cfif>
		<cfif isdefined('attributes.is_form_submitted')>
			<cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
		</cfif>
        <cfif isdefined('attributes.product_serial_no')>
			<cfset adres = "#adres#&product_serial_no=#attributes.product_serial_no#">
		</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
            <cfif get_product.recordcount>
                <div class="ui-form-list-btn ui-info-bottom" style="border-top:none;">
                    <div><a href="javascript://" onclick="goPrint()" class="ui-wrk-btn ui-wrk-btn-success"><i class="fa fa-print"></i> <cf_get_lang dictionary_id='33280.Toplu Barkod Yazdır'></a></div>
                </div>
            </cfif>
    </cf_box>

<cfform id="quality2">
    <input type="hidden" id="record_num" name="record_num" value="<cfoutput>#attributes.maxrows#</cfoutput>">
    <cfif xml_quality_show eq 1 and get_product.recordCount>
        <cf_box title="#getlang('','Kalite Ve Muayene','64158')#">
        <cf_box_elements vertical="1">
        <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
            <cfquery name = "get_level" datasource="#dsn3#">
                SELECT 
                    INSPECTION_LEVEL_ID,
                    INSPECTION_LEVEL_CODE
                FROM
                    SETUP_INSPECTION_LEVEL
            </cfquery>
            <cfquery name = "get_quality" datasource="#dsn3#">
                SELECT 
                    SUCCESS_ID,
                    SUCCESS
                FROM
                    QUALITY_SUCCESS
            </cfquery>
                <div class="form-group" id="item-level"> 
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37457.Muayene Seviyesi'></label>
                <div class="col col-8 col-xs-12">
                <select name="level" id="level">
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_level">
                        <option value="#INSPECTION_LEVEL_ID#" >#INSPECTION_LEVEL_CODE#</option>
                    </cfoutput>
                </select>
                </div>
                </div>
                <div class="form-group" id="item-quality"> 
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37000.Kalite Başarımı'></label>
                <div class="col col-8 col-xs-12">
                <select name="quality" id="quality">
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_quality">
                        <option value="#SUCCESS_ID#">#SUCCESS#</option>
                    </cfoutput>
                </select>
                </div>
                </div>
            <div class="form-group" id="item-quality"> 
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64161.Özel Gruplama Kodu'></label>
                <div class="col col-8 col-xs-12">
            <input type="text" name="group_code" id="group_code">
            </div>
            </div>
            <cfset cmp_process = createObject('component','V16.workdata.get_process')>
            <div class="col col-12 col-xs-12" type="column" index="1" sort="true">
                <cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
                faction_list : 'objects.serial_no')>
                <cf_workcube_general_process print_type="192" select_value = '#get_process_f.process_row_id#'>						
            </div>
        </div>
            </cf_box_elements>
            <cf_box_footer>
            <cfoutput>
            <a class=" ui-wrk-btn ui-wrk-btn-extra" onclick="gonder(1);"><cf_get_lang dictionary_id="64154.Seçilenleri Lot Bazında Grupla"></a>
            <a class=" ui-wrk-btn ui-wrk-btn-success" onclick="gonder(0);"><cf_get_lang dictionary_id="64160.Seçilenleri Kaydet"></a>
            </cfoutput>
        </cf_box_footer>
        </cf_box>
        </cfif>
    </cfform>
<script>
function gonder(value) {
    var controlChc = 0;
		$('.checkControl2').each(function(){
			if(this.checked){
				controlChc += 1;
			}
		});
		if(controlChc == 0){
			alert("<cf_get_lang dictionary_id='38067.Lütfen Seri No Seçiniz'> !");
			return false;
		}
        if( $.trim($('#general_paper_no').val()) == '' ){
			alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'> !");
			return false;
		}else{
			paper_no_control = wrk_safe_query('general_paper_control','dsn',0,$('#general_paper_no').val());
			if(paper_no_control.recordcount > 0)
			{
            	alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'>.<cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
				paper_no_val = $('#general_paper_no').val();
				paper_no_split = paper_no_val.split("-");
				if(paper_no_split.length == 1)
					paper_no = paper_no_split[0];
				else
					paper_no = paper_no_split[1];
				paper_no = parseInt(paper_no);
				paper_no++;
				if(paper_no_split.length == 1)
					$('#general_paper_no').val(paper_no);
				else
					$('#general_paper_no').val(paper_no_split[0]+"-"+paper_no);
				return false;
			}
		}
		if( $.trim($('#general_paper_date').val()) == '' ){
			alert("<cf_get_lang dictionary_id='62954.Lütfen Belge Tarihi Giriniz'> !");
			return false;
		}
		if( $.trim($('#general_paper_notice').val()) == '' ){
			alert("<cf_get_lang dictionary_id='62955.Lütfen Ek Açıklama Giriniz'> !");
			return false;
		}
    url_str=''
    for(i=1;i<=record_num.value;i++)
    {
        if($("#action_list"+i).prop("checked"))
      url_str=url_str+"&action_list"+i+"="+$("#action_list"+i).val();
    }
    quality2.action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_lot_group&group="+value+url_str;
    quality2.submit();
}
function change_check(){
    <cfif get_product.recordCount>
    <cfoutput query="get_product" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
    wrk_select_all('check_serial_All','action_list_id#currentrow#');
    </cfoutput>
    </cfif>
}
function change_check2(){
    <cfif get_product.recordCount>
    <cfoutput query="get_product" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
    wrk_select_all('check_serial_All2','action_list#currentrow#');
    </cfoutput>
    </cfif>
}
		$(document).ready(function() {
			$('#product_serial_no').focus();
		});
    let objectItems = [];

    if (typeof(Storage) != undefined) {
        
        let items = localStorage.getItem('serial_number_report');
        if( items != '' && items != null ) objectItems = JSON.parse( items );
        $(" .checkControl ").each( function() {
            objectItems.forEach(el => {
                var serial_no = $(this).attr("data-serial"),
                    stock_id = $(this).attr("value"),
                    department_id = $(this).attr("data-department"),
                    location_id = $(this).attr("data-location");
                    
                if( serial_no == el.serial_no && stock_id == el.stock_id && department_id == el.department_id && location_id == el.location_id )
                    $(this).prop("checked",true);
            });
        } );

    } 

    function checkControl() {
        
        $(" .checkControl ").each(function() {

            var serial_no = $(this).attr("data-serial"),
                stock_id = $(this).attr("value"),
                department_id = $(this).attr("data-department"),
                location_id = $(this).attr("data-location");

            if( objectItems.length > 0 ){
                objectItems.forEach((el, index) => {
                    if( serial_no == el.serial_no && stock_id == el.stock_id && department_id == el.department_id && location_id == el.location_id )
                        objectItems.splice( index, 1 );
                });
            }

            if( $(this).is(':checked') ) objectItems.push({ serial_no: serial_no, stock_id: stock_id, department_id: department_id, location_id: location_id });
            localStorage.setItem("serial_number_report", JSON.stringify( objectItems ));

        });

    }

    $( '.checkControl' ).on('click', function() {
        checkControl();
    });

    function goPrint(){

        var RowControl = objectItems.length;
        var serial_no = new Array(),
            stock_id = new Array(),
            department_id = new Array(),
            location_id = new Array();

		objectItems.forEach(el => {
            serial_no.push(el.serial_no);
            stock_id.push(el.stock_id);
            department_id.push(el.department_id);
            location_id.push(el.location_id);
		});

        if(RowControl == 0){
			alert("<cf_get_lang dictionary_id='61354.İşlem için satır seçiniz.'>");
			return false;
		}else{
            SerialAll = serial_no.join(",");
            StockAll = stock_id.join(",");
            DepartmentAll = department_id.join(",");
            LocationAll = location_id.join(",");
            localStorage.clear("serial_number_report");
            window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&action_type=87&action_id=&action_row_id=&print_type=192&stock_id='+StockAll+'&serial_no='+SerialAll+'&department_id='+DepartmentAll+'&location_id='+LocationAll+'&template_id=1175','WOC');
        }

    }
</script>