<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
 

<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
	</cfif>
</cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.finish_date=''>
	<cfelse>
		<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
	</cfif>
</cfif>
<!--- tarih ayarlamaları bitti--->
<cfif isdefined("attributes.is_submit")>
    <cfquery name="GET_WORK_TIMES" datasource="#dsn#" >
        SELECT 
            SUM(EXPENSED_MINUTE) AS TOPLAM_HARCANAN_DK,
            CONVERT(nvarchar(10),EVENT_DATE,105) AS EVENT_DATE,
            EMPLOYEE_ID,
            PRODUCT_ID
        FROM
            TIME_COST
        WHERE
                PRODUCT_ID IS NOT NULL
            <cfif isdefined('attributes.start_date') and len(attributes.start_date)>
                AND EVENT_DATE >= #attributes.start_date# 
            </cfif>
            <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
                AND EVENT_DATE <= #attributes.finish_date#
            </cfif>
            <cfif isdefined('attributes.PROJECT_ID') and len(attributes.PROJECT_ID)>
                AND PROJECT_ID IS NOT NULL
                AND PROJECT_ID = #attributes.project_id#
            </cfif>
        GROUP BY
            EVENT_DATE,
            EMPLOYEE_ID,
            PRODUCT_ID
    </cfquery>
    <cfset attributes.totalrecords = GET_WORK_TIMES.recordcount>

</cfif>    
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT 
        COMP_ID,
        COMPANY_NAME
    FROM
        OUR_COMPANY 
    <cfif not session.ep.ehesap>
        WHERE COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
    </cfif>
    ORDER BY
        COMPANY_NAME
</cfquery>
<cfquery name="get_branches" datasource="#dsn#">
    SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH 
    WHERE
        <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            COMPANY_ID IN(#attributes.comp_id#) 
            <cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
        <cfelse>
            1=0
        </cfif>
    ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_data" datasource="#dsn#">
    SELECT
        OC.COMPANY_NAME,
		OC.COMP_ID,
        B.BRANCH_NAME
    FROM
        BRANCH B,
		OUR_COMPANY OC
    WHERE
        1=1
        <cfif len(attributes.comp_id)>
            AND OC.COMP_ID IN (#attributes.comp_id#)
        </cfif>
        <cfif len(attributes.branch_id)>
            AND B.BRANCH_ID IN (#attributes.branch_id#)
        </cfif>
        <cfif not session.ep.ehesap>
            AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        </cfif>
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_data.recordCount#">

<cfsavecontent variable="head"><cf_get_lang no='1715.İşcilik Puantaj Cetveli' ></cfsavecontent>
<cfform name="worker_puantaj" method="post" action="#request.self#?fuseaction=report.worker_puantaj_report">
    <cf_report_list_search title="#head#">
        <cf_report_list_search_area>
        <div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-4 col-md-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-12 col-md-12"><cf_get_lang_main no='1734.Şirketler'></label>
                                    <div>
                                        <div class="multiselect-z2">
                                            <cf_multiselect_check 
                                            query_name="get_our_company"  
                                            name="comp_id"
                                            option_value="COMP_ID"
                                            option_name="company_name"
                                            option_text="#getLang('main',322)#"
                                            value="#attributes.comp_id#"
                                            onchange="get_branch_list(this.value)">
                                        </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-12 col-md-12"><cf_get_lang_main no='1637.Şubeler'></label>
                                    <div id="BRANCH_PLACE">
                                        <div id="BRANCH_PLACE" class="multiselect-z2">
                                            <cf_multiselect_check 
                                            query_name="get_branches"  
                                            name="branch_id"
                                            option_value="BRANCH_ID"
                                            option_name="BRANCH_NAME"
                                            option_text="#getLang('main',322)#"
                                            value="#attributes.branch_id#">
                                        </div>
                                    </div>                             
                            </div>  
                        </div>
                        <div class="col col-6 col-md-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-3 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>"> 
                                    <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_head') and len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" style="width:135px;">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                                </div>	
                            </div>
                            <div class="form-group">
                                <label class="col col-3 col-xs-12 paddingNone"><cf_get_lang_main no='1278.Tarih Aralığı'></label>				
                                <div class="col col-9 col-md-6 col-xs-12 paddingNone">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang_main no ='370.Tarih Değerini Kontrol Ediniz'>!></cfsavecontent>
                                         <cfinput type="text" name="start_date" id="start_date" value="#DateFormat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;">
                                        <span class="input-group-addon">
                                        <cf_wrk_date_image date_field="start_date">
                                        </span>
                                        <span class="input-group-addon no-bg"></span>
                                        <cfsavecontent variable="message"><cf_get_lang_main no ='370.Tarih Değerini Kontrol Ediniz'>!></cfsavecontent>
                                        <cfinput type="text" name="finish_date" value="#DateFormat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;> ">
                                        <span class="input-group-addon">
                                        <cf_wrk_date_image date_field="finish_date">
                                        </span>
                                    </div>
                                </div>					
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row ReportContentBorder">
					<div class="ReportContentFooter">
                        <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang_main no='446.Excel Getir'></label>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <input type="hidden" name="maxrows" id="maxrows" value="<cfoutput>#session.ep.maxrows#</cfoutput>" />
                        <input type="hidden" name="is_submit" id="is_submit" value="1">
                        <cf_wrk_report_search_button button_type='1' search_function='control()' is_excel='1'>
                    </div>
                </div>
            </div>
        </div>
        </cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
    <cfset type_ = 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
    <cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_submit")>
    <cfif attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = GET_WORK_TIMES.recordcount>
	</cfif>
    <cf_report_list>
        <cfif isdefined('attributes.start_date') and len(attributes.start_date) and isdefined('attributes.finish_date') and len(attributes.finish_date)>
            <cfset day_unit = datediff('d',attributes.start_date,attributes.finish_date)>
        <cfelse>
            <cfset day_unit =0>
        </cfif>
        <thead>
            <tr>
                <th><cf_get_lang_main no='1165.Sıra'></td>
                <th style="width:70px;"><cf_get_lang_main no='164.Çalışan'></td>
                <cfif isdefined('attributes.start_date') and len(attributes.start_date) and isdefined('attributes.finish_date') and len(attributes.finish_date)>
                    <cfloop from="0" to="#day_unit#" index="i">
                        <cfoutput>
                        <th title="#DateFormat(date_add('d',i,attributes.start_date),dateformat_style)#"> 
                            #DateFormat(date_add('d',i,attributes.start_date),'dd')#
                        </th>
                        </cfoutput>
                    </cfloop>
                </cfif>
                <th><cf_get_lang no ='1740.Toplam Gün'></td>
                <th><cf_get_lang no ='1741.Birim Ücret'></td>
                <th><cf_get_lang no ='1742.Mesai Saat'></td>
                <th><cf_get_lang no ='1743.Mesai Ücret'></td>
                <th><cf_get_lang_main no='1737.Toplam Tutar'></td>
            </tr>
        </thead>
        <tbody>
            <cfif GET_WORK_TIMES.recordcount and isdefined('attributes.start_date') and len(attributes.start_date) and isdefined('attributes.finish_date') and len(attributes.finish_date)>
                <cfoutput query="GET_WORK_TIMES">
                    <cfset 'is_full_#EMPLOYEE_ID#_#Replace(EVENT_DATE,'-','','all')#' = 1>
                    <cfif isdefined('toplam#employee_id#')>  <!---Harcanan Toplam Gün Bulur--->
                        <cfset 'toplam#employee_id#' = Evaluate('toplam#employee_id#')+TOPLAM_HARCANAN_DK>
                    <cfelse>
                        <cfset 'toplam#employee_id#' = TOPLAM_HARCANAN_DK>
                    </cfif>
                        <cfquery name="get_product_cost_price" datasource="#dsn1#" >
                                SELECT 
                                    PRICE_KDV
                                FROM
                                    PRICE_STANDART
                                WHERE
                                    PURCHASESALES = 1 AND
                                    PRICESTANDART_STATUS = 1 AND
                                    IS_KDV = 1 AND
                                    PRODUCT_ID = #product_id#
                            </cfquery>
                        <cfif len(get_product_cost_price.PRICE_KDV)>
                                <cfif isdefined('fiyat#employee_id#')>				<!--- birim Ücret --->
                                    <cfset 'fiyat#employee_id#' = Evaluate('fiyat#employee_id#') + get_product_cost_price.PRICE_KDV>
                                <cfelse>
                                    <cfset 'fiyat#employee_id#' = get_product_cost_price.PRICE_KDV>
                                </cfif>
                            <cfelse>
                                <cfset 'fiyat#employee_id#' = 0>
                            </cfif>
                            <!---  len(Evaluate('fiyat#employee_id#')) --->
                </cfoutput>
                <cfset work_emp_list = listdeleteduplicates(ValueList(GET_WORK_TIMES.EMPLOYEE_ID,','))>
                <cfset sayac = 1>
                    <cfloop list="#work_emp_list#" index="emp_id">
                        <cfoutput>
                        <tr>
                        <td><!--- #emp_id#-- --->#sayac#</td>
                        <td>#GET_EMP_INFO(emp_id,0,1)#</td>
                        <cfloop from="0" to="#day_unit#" index="qq">
                            <cfset 'new_day#qq#' = DateFormat(date_add('d',qq,attributes.start_date),'DDMMYYYY')>
                            <td width="20"><cfif isdefined('is_full_#emp_id#_#Evaluate('new_day#qq#')#')><img src="images/c_ok.gif" align="absmiddle" border="0" title="Çalışılan Gün"><cfelse></cfif>&nbsp;</td>
                        </cfloop>
                            <td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLformat(Evaluate('toplam#emp_id#')/480)#"></td><!---bir adam gunu 480 dk dır --->
                            <td><cfif len(Evaluate('fiyat#emp_id#'))><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLformat(Evaluate('fiyat#emp_id#')*8)#"></cfif></td>
                            <td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLformat(Evaluate('toplam#emp_id#')/60)#"></td>
                            <td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLformat(Evaluate('fiyat#emp_id#'))#"></td>
                                <cfset toplam_tutar = (Evaluate('toplam#emp_id#')/480) * (Evaluate('fiyat#emp_id#')*8)>
                            <td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(toplam_tutar)#"></td>
                        </tr>
                        <cfset sayac = sayac + 1></cfoutput>
                    </cfloop>
            <cfelse>
                <tr>
                    <cfset colspan_value = (day_unit + 8)>
                    <td colspan="<cfoutput>#colspan_value#</cfoutput>"><cfif isdefined('is_submit')><cf_get_lang_main no='72.Kayıt yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_report_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
                <cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
            </cfif>

			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
                <cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
            </cfif>

            <cfif isdefined("attributes.BRANCH_PLACE") and len(attributes.BRANCH_PLACE)>
                <cfset url_str = "#url_str#&BRANCH_PLACE=#attributes.BRANCH_PLACE#">
            </cfif>

            <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
                <cfset url_str = "#url_str#&project_id=#attributes.project_id#">
            </cfif>
			<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
                <cfset url_str = '#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
            </cfif>
            <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
                <cfset url_str = '#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
            </cfif>
            <cfif attributes.is_excel eq 0>
                <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#attributes.fuseaction#&#url_str#"> 
            </cfif>
    </cfif>
</cfif>



<script type="text/javascript">
    function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
    function control()
    {
        if(document.getElementById('start_date').value == '' || document.getElementById('finish_date').value == '')
            {
                alert("<cf_get_lang no ='1745.Lütfen Tarih Değerlerini Eksiksiz Doldurunuz'>");
                return false;
            }
        if(datediff(document.getElementById('start_date').value,document.getElementById('finish_date').value) < 0)
            {
                alert("<cf_get_lang no ='1746.Başlangıç Tarihi Bitiş Tarihinden Büyük Olmamalıdır'>");
                return false;
            }
        if(datediff(document.getElementById('start_date').value,document.getElementById('finish_date').value) > 31)
            {
                alert("<cf_get_lang no ='1747.İşçilik Puantaj Cetvelinde Tarih aralığı 30 Günden Fazla Olmamalıdır'>");
                return false;
            }
        if(document.worker_puantaj.is_excel.checked==false)
            {
                document.worker_puantaj.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                return true;
            }
        else
                document.worker_puantaj.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_worker_puantaj_report</cfoutput>"
    }
</script>
