<cfparam name="attributes.department_in" default="">
<cfparam name="attributes.txt_department_in" default="">
<cfparam name="attributes.tarih" default="">
<cfparam name="attributes.emp_id" default="">

<cfif isDefined("attributes.aktar")>
    <cfquery name="query_barcodes" datasource="#dsn2#">
        SELECT DYZ_STOCK_DATA.*, STOCKS.STOCK_ID, STOCKS.PRODUCT_UNIT_ID AS UNIT_ID, STOCKS.PRODUCT_UNIT_ID AS MAIN_UNIT, STOCKS.PRODUCT_ID FROM DYZ_STOCK_DATA INNER JOIN #dsn1#.STOCKS ON DYZ_STOCK_DATA.BARCODE = STOCKS.BARCOD WHERE IMPID IN (#attributes.aktarilacak#)
    </cfquery>
    <cfset attributes.department_in = query_barcodes.DEPARTMENT_ID>
    <cfset attributes.fis_date = dateFormat( query_barcodes.RECORD_DATE, dateformat_style )>
    <cfset attributes.fis_date_h = hour(query_barcodes.RECORD_DATE)>
    <cfset attributes.fis_date_m = minute(query_barcodes.RECORD_DATE)>
    <cfset attributes.prod_order_number = "">
    <cfset attributes.location_in = query_barcodes.LOCATION_ID>
    <cfset attributes.fis_no = "0">
    <cfset attributes.fis_no_ = "0">
    <cfset attributes.rows_ = query_barcodes.recordCount>
    <cfset attributes.fis_type = 1>
    <cfset attributes.PROCESS_CAT = 91>
    <cfset attributes.department_out = "">
    <cfset attributes.location_out = "">
    <cfset attributes.member_type = 'employee'>
    <cfset attributes.member_name = 'employee'>
    <cfset attributes.employee_id = query_barcodes.RECORD_EMP>
    <cfset attributes.active_period = session.ep.PERIOD_ID>
    <cfset attributes.XML_MULTIPLE_COUNTING_FIS = 0>
    <cfset attributes.kur_say = 0>
    <cfset qi = 1>
    <cfloop query="query_barcodes">
        <cfset attributes["amount"&qi] = query_barcodes.AMOUNT>
        <cfset attributes["stock_id"&qi] = query_barcodes.STOCK_ID>
        <cfset attributes["unit_id"&qi] = query_barcodes.UNIT_ID>
        <cfset attributes["unit"&qi] = query_barcodes.MAIN_UNIT>
        <cfset attributes["product_id"&qi] = query_barcodes.PRODUCT_ID>
        <cfset attributes["tax"&qi] = 0>
        <cfset attributes["wrk_row_id"&qi] = createUUID()>
        <cfset qi = qi + 1>
    </cfloop>
    <cfinclude template="../../../../V16/stock/query/add_ship_fis.cfm">
    <cfabort>
</cfif>

<cfif isDefined("attributes.sil")>
    <cfquery name="query_sil" datasource="#dsn2#">
        DELETE FROM DYZ_STOCK_DATA WHERE IMPID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.sil#'>
    </cfquery>
    <script>
        document.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
    </script>
    <cfabort>
</cfif>

<cfform name="form_search" method="post">
    <input type="hidden" name="is_search" value="1">
    <cf_big_list_search title="Satışlar">
        <cf_big_list_search_area>
            <div class="row">
                <div class="col col-12 form-inline">
                    <div class="form-group">
                        <div class="input-group x-10">
                            <cf_wrkdepartmentlocation
                                returnInputValue="location_in,txt_department_in,department_in,branch_in_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="txt_department_in"
                                fieldid="location_in"
                                department_fldId="department_in"
                                branch_fldId="branch_id"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                line_info = 2
                                width="100%">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group x-10">
                            <cfinput type="text" name="tarih" maxlength="10" validate="#validate_style#" value="#attributes.tarih#" required="yes" message="Tarih hatalı" style="width:65px;">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="tarih"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button>
                    </div>
                </div>
            </div>
        </cf_big_list_search_area>
    <cf_big_list_search>
</cfform>

<cfif len(attributes.tarih)>
    <cf_date tarih="attributes.tarih">
</cfif>

<cfif isDefined("attributes.is_search")>
    <cfquery name="query_stock_data" datasource="#dsn2#">
        SELECT sd.IMPID
        ,sd.DEPARTMENT_ID
        ,sd.LOCATION_ID
        ,sd.BARCODE
        ,sd.AMOUNT
        ,sd.RECORD_DATE
        ,sd.RECORD_EMP
        ,sd.RECORD_IP
        ,br.DEPARTMENT_HEAD
        ,em.EMPLOYEE_NAME
        ,em.EMPLOYEE_SURNAME
        FROM DYZ_STOCK_DATA sd, #dsn#.DEPARTMENT br, #dsn#.EMPLOYEES em, #dsn#.STOCKS_LOCATION sl
        WHERE sd.DEPARTMENT_ID = br.DEPARTMENT_ID AND sd.RECORD_EMP = em.EMPLOYEE_ID AND sl.DEPARTMENT_ID = br.DEPARTMENT_ID AND sl.LOCATION_ID = sd.LOCATION_ID
        <cfif len(attributes.department_in)>
            AND sd.DEPARTMENT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.department_in#'>
        </cfif>
        <cfif len(attributes.tarih)>
            AND dateDiff("DAY", sd.RECORD_DATE, <cfqueryparam cfsqltype='CF_SQL_DATE' value='#attributes.tarih#'>) = 0
        </cfif>

    </cfquery>
<cfelse>
    <cfset query_stock_data = { recordcount: 0 }>
</cfif>
<form method="POST">
    <input type="hidden" name="aktar" value="1">
    <input type="hidden" name="rcount" value="<cfoutput>#query_stock_data.recordCount#</cfoutput>">
    <input type="hidden" name="PROCESS_CAT" value="1">
    <input type="hidden" name="tarih" value="<cfoutput>#attributes.tarih#</cfoutput>">
    <input type="hidden" name="emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">
<cfset rowindex = 1>
<cf_big_list>
    <thead>
        <tr>
            <th>#</th>
            <th>DEPO</th>
            <th>BARKOD</th>
            <th>MİKTAR</th>
            <th>GÖREVLİ</th>
            <th><a href="javascript:void(0)" onclick="checkall()">Tümünü Seç</a></th>
            <th>#</th>
        </tr>
    </thead>
    <tbody>
        <cfif query_stock_data.recordCount gt 0>
        <cfoutput query="query_stock_data">
        <tr>
            <td>#IMPID#</td>
            <td>#DEPARTMENT_HEAD#</td>
            <td>#BARCODE#</td>
            <td>#AMOUNT#</td>
            <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
            <td class="checkitem">
                <input type="checkbox" name="aktarilacak" value="#IMPID#"> Seç
            </td>
            <td>
                <a href="#request.self#?fuseaction=#attributes.fuseaction#&sil=#IMPID#" onclick="return confirm('Emin misiniz?')"><i class="fa fa-trash"></i> Sil</a>
            </td>
        </tr>
        <cfset rowindex = rowindex + 1>
        </cfoutput>
        </cfif>
    </tbody>
</cf_big_list>
<cfif query_stock_data.recordCount gt 0>
<button type="submit" class="btn green-haze">AKTAR</button>
</cfif>
</form>
<script type="text/javascript">
    function checkall(elm) {
        $('.checkitem input[type="checkbox"]').prop("checked", true);
    }
</script>