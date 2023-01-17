<cfparam name="attributes.department_in" default="">
<cfparam name="attributes.txt_department_in" default="">
<cfparam name="attributes.tarih" default="">
<cfparam name="attributes.emp_id" default="">

<cfif isDefined("attributes.aktar")>
    <cfquery name="query_barcodes" datasource="#dsn2#">
        SELECT DYZ_STOCK_DATA.* FROM DYZ_STOCK_DATA WHERE IMPID IN (#attributes.aktarilacak#)
    </cfquery>
    

    <cfset fis_date = dateFormat( query_barcodes.RECORD_DATE, dateformat_style )>
    <cfset seperator_type = ";">
    <cfset stock_identity_type = "1">
    <cfset department_id = query_barcodes.DEPARTMENT_ID>
    <cfset location_id = query_barcodes.LOCATION_ID>
    <cfset upload_folder = "#upload_folder#store#dir_seperator#">
    <cfset file_name = "#createUUID()#.csv">

    <cfset CRLF = Chr(13) & Chr(10)>

    <cfset qi = 1>
    <cfset file_content = "">
    <cfloop query="query_barcodes">
        <cfset file_content = file_content & query_barcodes.BARCODE & seperator_type & query_barcodes.AMOUNT & CRLF>
        <cfset qi = qi + 1>
    </cfloop>

    <cffile action="write" file="#upload_folder##file_name#" charset="utf-8" output="#file_content#">
    <form method="POST" action="/index.cfm?fuseaction=objects.popup_add_import_stock_count_display" target="_blank" id="frm_uploadfile">
        <cfoutput>
            <input type="hidden" name="nofilerequired" value="1">
            <input type="hidden" name="process_date" value="#fis_date#">
            <input type="hidden" name="seperator_type" value="#asc(seperator_type)#">
            <input type="hidden" name="stock_identity_type" value="#stock_identity_type#">
            <input type="hidden" name="department_id" value="#department_id#">
            <input type="hidden" name="location_id" value="#location_id#">
            <input type="hidden" name="file_name" value="#file_name#">
            <input type="hidden" name="store" vlaue="Depo">
        </cfoutput>
    </form>
    <script>
        document.getElementById("frm_uploadfile").submit();
        document.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
    </script>
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
    <cfset odate = "#attributes.tarih#">
    <cf_date tarih="odate">
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
            AND dateDiff("DAY", sd.RECORD_DATE, <cfqueryparam cfsqltype='CF_SQL_DATE' value='#odate#'>) = 0
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