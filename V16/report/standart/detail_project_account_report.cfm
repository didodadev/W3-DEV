<cfparam name="attributes.module_id_control" default="22">
<cfinclude template="report_authority_control.cfm">
<cfprocessingdirective pageencoding="utf-8"> 
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.project" default="">
<cfparam name="attributes.PROJECT_ID" default="">
<cfparam name="attributes.main_process_cat" default="">
<cfparam name="attributes.process_cat_code" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.has_account_code" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.main_project_cat" default="">
<cfparam name="attributes.main_process_cat_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.process_catid" default="">
<cfparam name="attributes.period_year" default="#session.ep.period_year#,#session.ep.period_id#,#session.ep.company_id#">
<cfset new_donem_data_source = "#dsn#_#ListGetAt(attributes.period_year,1,',')#_#ListGetAt(attributes.period_year,3,',')#">
<cfset liste="project_head,account_code,account_code_pur,account_iade,account_pur_iade,account_discount,account_discount_pur,account_price,account_price_pur,production_cost,half_production_cost,konsinye_sale_naz_code,dimm_yans_code,dimm_code,promotion_code,account_yurtdisi,account_yurtdisi_pur,material_code,income_progress_code,expense_progress_code,konsinye_sale_code,konsinye_pur_code,account_loss,account_expenditure,sale_product_cost,over_count,under_count,received_progress_code,provided_progress_code,sale_manufactured_cost,scrap_code,material_code_sale,production_cost_sale,scrap_code_sale">
<cfif isdefined("attributes.get_date") and len(attributes.get_date)>
<cf_date tarih='attributes.get_date'> 
<cfparam name="attributes.get_date" default="#attributes.get_date#">
<cfelse>
<cfparam name="attributes.get_date" default="">
</cfif>
<cfquery name="get_main_process_cat" datasource="#dsn#">
	SELECT
		DISTINCT
		SPC.MAIN_PROCESS_CAT_ID,
		SPC.MAIN_PROCESS_CAT,
		SPC.MAIN_PROCESS_TYPE
	FROM
		SETUP_MAIN_PROCESS_CAT_ROWS AS SPCR,
		SETUP_MAIN_PROCESS_CAT_FUSENAME AS SPCF,
		EMPLOYEE_POSITIONS AS EP,
		SETUP_MAIN_PROCESS_CAT SPC
	WHERE
		SPC.MAIN_PROCESS_CAT_ID = SPCR.MAIN_PROCESS_CAT_ID AND
		SPC.MAIN_PROCESS_CAT_ID = SPCF.MAIN_PROCESS_CAT_ID AND
        <cfif len(attributes.project) and len(attributes.MAIN_PROCESS_CAT)>AND SPC.MAIN_PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.MAIN_PROCESS_CAT#"></cfif>
		SPC.MAIN_PROCESS_MODULE IN (1) AND
		SPCF.FUSE_NAME = 'project.popup_updpro' AND
		EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
		( SPCR.MAIN_POSITION_CODE = EP.POSITION_CODE OR SPCR.MAIN_POSITION_CAT_ID = EP.POSITION_CAT_ID )
	ORDER BY
		SPC.MAIN_PROCESS_CAT
</cfquery>
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_PROJECTS" datasource="#DSN3#">
        SELECT   
            P.PROJECT_ID,
            P.PROJECT_HEAD,
            P.PROCESS_CAT,
            P.PROJECT_EMP_ID,
            P.PROJECT_NUMBER,
            PP.ACCOUNT_CODE,
            PP.ACCOUNT_CODE_PUR,
            PP.ACCOUNT_IADE,
            PP.ACCOUNT_PUR_IADE,
            PP.ACCOUNT_DISCOUNT,
            PP.ACCOUNT_DISCOUNT_PUR,
            PP.ACCOUNT_PRICE,
            PP.ACCOUNT_PRICE_PUR,
            PP.PRODUCTION_COST,
            PP.HALF_PRODUCTION_COST,
            PP.KONSINYE_SALE_NAZ_CODE,
            PP.DIMM_CODE,
            PP.DIMM_YANS_CODE,
            PP.PROMOTION_CODE,
            PP.ACCOUNT_YURTDISI,
            PP.ACCOUNT_YURTDISI_PUR,
            PP.MATERIAL_CODE,
            PP.KONSINYE_SALE_CODE,
            PP.KONSINYE_PUR_CODE,
            PP.ACCOUNT_LOSS,
            PP.ACCOUNT_EXPENDITURE,
            PP.SALE_PRODUCT_COST,
            PP.OVER_COUNT,
            PP.UNDER_COUNT,
            PP.RECEIVED_PROGRESS_CODE,
            PP.PROVIDED_PROGRESS_CODE,
            PP.SALE_MANUFACTURED_COST,
            PP.EXPENSE_PROGRESS_CODE,
            PP.INCOME_PROGRESS_CODE,
            PP.SCRAP_CODE,
            PP.MATERIAL_CODE_SALE,
            PP.PRODUCTION_COST_SALE,
            PP.SCRAP_CODE_SALE,
            (SELECT EXPENSE FROM #DSN2#.EXPENSE_CENTER WHERE EXPENSE_ID = PP.EXPENSE_CENTER_ID) GELIR_MERKEZI,
            (SELECT EXPENSE_ITEM_NAME FROM #DSN2#.EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1 AND EXPENSE_ITEM_ID = PP.INCOME_ITEM_ID) GELIR_KALEMI,
            (SELECT ACTIVITY_NAME FROM #DSN#.SETUP_ACTIVITY WHERE ACTIVITY_ID = PP.INCOME_ACTIVITY_TYPE_ID) GELIR_AKTIVITE_TIPI,
            (SELECT TEMPLATE_NAME FROM #DSN2#.EXPENSE_PLANS_TEMPLATES WHERE TEMPLATE_ID = PP.INCOME_TEMPLATE_ID) GELIR_SABLONU,
            (SELECT EXPENSE FROM #DSN2#.EXPENSE_CENTER WHERE EXPENSE_ID = PP.COST_EXPENSE_CENTER_ID) GIDER_MERKEZI,
            (SELECT EXPENSE_ITEM_NAME FROM #DSN2#.EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND EXPENSE_ITEM_ID = PP.EXPENSE_ITEM_ID) GIDER_KALEMI,
            (SELECT ACTIVITY_NAME FROM #DSN#.SETUP_ACTIVITY WHERE ACTIVITY_ID = PP.ACTIVITY_TYPE_ID) GIDER_AKTIVITE_TIPI,
            (SELECT TEMPLATE_NAME FROM #DSN2#.EXPENSE_PLANS_TEMPLATES WHERE TEMPLATE_ID = PP.EXPENSE_TEMPLATE_ID) GIDER_SABLONU
        FROM 
            #dsn_alias#.PRO_PROJECTS P
            LEFT JOIN 
            PROJECT_PERIOD PP ON
            PP.PROJECT_ID = P.PROJECT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        WHERE
            P.PROJECT_ID IS NOT NULL
        <cfif len(attributes.process_catid)>AND P.PROCESS_CAT = #attributes.process_catid#</cfif>
        <cfif len(attributes.project_head) and len(attributes.PROJECT_ID)>AND P.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PROJECT_ID#"></cfif>
        <cfif len(attributes.employee) and len(attributes.employee_id)>AND P.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
        <cfif len(attributes.is_active) and (attributes.is_active eq 2)>AND P.PROJECT_STATUS = 1
        <cfelseif len(attributes.is_active) and (attributes.is_active eq 3)>AND P.PROJECT_STATUS = 0</cfif>
        <cfif len(attributes.get_date)>AND P.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.get_date#"></cfif>
        <cfif len(attributes.has_account_code)>
            <cfif attributes.has_account_code eq 1>
                AND P.PROJECT_ID IN 
                    (SELECT 
                        PROJECT_ID FROM PROJECT_PERIOD 
                        WHERE 
                        <cfloop list="#liste#" index="liste_">
                            <cfif (attributes.list_account eq liste_) or (attributes.list_account eq '')>
                                 #uCase(liste_)# IS NOT NULL AND
                            </cfif>
                       </cfloop>
                            PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
            <cfelseif attributes.has_account_code eq 0>
                AND P.PROJECT_ID NOT IN 
                    (SELECT
                         PROJECT_ID FROM PROJECT_PERIOD 
                         WHERE 
                        <cfloop list="#liste#" index="liste_">
                            <cfif (attributes.list_account eq liste_) or (attributes.list_account eq '')>
                                 #uCase(liste_)# IS NOT NULL AND
                            </cfif>
                        </cfloop>
                            PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
            </cfif>
        </cfif>
        ORDER BY 
            P.PROJECT_ID
    </cfquery>
<cfelse>
	<cfset GET_PROJECTS.recordcount = 0>    
</cfif>
<cfparam name="attributes.totalrecords" default="#GET_PROJECTS.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>            
<cfform name="search_product" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='40052.Proje Muhasebe Kodları'></cfsavecontent>
    <cf_report_list_search title="#title#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57486.Kategori"></label>	
                                    <div class="col col-12">			
                                        <select name="process_catid" id="process_catid" style="width:150px;">
                                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                            <cfoutput query="get_main_process_cat"> 
                                                <option value="#main_process_cat_id#" <cfif attributes.process_catid is main_process_cat_id>selected</cfif>>#main_process_cat#</option>
                                            </cfoutput> 
                                        </select>
                                    </div>	
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>	
                                    <div class="col col-12">		
                                        <div class="input-group">
                                            <input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                            <input type="text" name="project_head" id="project_head" style="width:180px;" value="<cfif len(attributes.project_id) and len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>"  onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_form.project_id&project_head=search_form.project_head');"></span>
                                        </div>   
                                    </div>									
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">							
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>	
                                    <div class="col col-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="employee" value="#attributes.employee#" onFocus="AutoComplete_Create('employee','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','employee_id','','3','130');" style="width:120px;" maxlength="255">
                                            <input type="hidden" name="employee_id" id="employee_id"  value="<cfoutput>#attributes.employee_id#</cfoutput>">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=search_product.employee_id&field_name=search_product.employee&select_list=1','list');"></span>
                                        </div>    
                                    </div>											
                                </div>	
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>	
                                    <div class="col col-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Degerini Kontrol Ediniz'></cfsavecontent>
                                            <cfinput type="text" name="get_date" value="#dateformat(attributes.get_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px;">
                                            <span class="input-group-addon">
                                                <cf_wrk_date_image date_field="get_date">
                                            </span>
                                        </div>
                                    </div>			
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                    <div class="col col-12">
                                        <select name="is_active" id="is_active">
                                            <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                            <option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                            <option value="3" <cfif attributes.is_active eq 3>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                        </select>
                                    </div>	
                                </div>	
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                                    <div class="col col-12">
                                        <select name="has_account_code" id="has_account_code" onchange="show_select()">
                                            <option value=""><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></option>
                                            <option value="1" <cfif attributes.has_account_code is "1">selected</cfif>><cf_get_lang dictionary_id='39317.Tanimli'></option>
                                            <option value="0" <cfif attributes.has_account_code is "0">selected</cfif>><cf_get_lang dictionary_id='58845.Tanimsiz'></option>
                                        </select>
                                    </div>	
                                </div>	
                                <div class="form-group">
                                    <div class="col col-12">
                                        <div id="tdlist_account" <cfif attributes.has_account_code eq ''> style="display:none" </cfif>>
                                            <select  name="list_account" id="list_account">
                                                <option value=""><cf_get_lang dictionary_id="39664.Muhasebe Kodu Hesabı Seçiniz"></option>
                                                <option value="account_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='57448.Satis'></option>
                                                <option value="account_code_pur" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_code_pur'>selected</cfif></cfif>><cf_get_lang dictionary_id='58176.Alis'></option>
                                                <option value="account_iade" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_iade'>selected</cfif></cfif>><cf_get_lang dictionary_id='39326.Satis Iade'></option>
                                                <option value="account_pur_iade" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_pur_iade'>selected</cfif></cfif>><cf_get_lang dictionary_id='39327.Alis Iade'></option>
                                                <option value="account_discount"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_discount'>selected</cfif></cfif>><cf_get_lang dictionary_id='39328.Satis Iskonto'></option>
                                                <option value="account_discount_pur"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_discount_pur'>selected</cfif></cfif>><cf_get_lang dictionary_id='39329.Alis Iskonto'></option>
                                                <option value="account_price"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_price'>selected</cfif></cfif>><cf_get_lang dictionary_id="57448.Satış"> <cf_get_lang dictionary_id="39331.Fiyat Farkı"></option>
                                                <option value="account_price_pur"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_price_pur'>selected</cfif></cfif>><cf_get_lang dictionary_id="58176.Alış"> <cf_get_lang dictionary_id="39331.Fiyat Farkı"></option>
                                                <option value="production_cost"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'production_cost'>selected</cfif></cfif>><cf_get_lang dictionary_id="57456.Üretim">/ <cf_get_lang dictionary_id="58262.Mamüller"></option>
                                                <option value="half_production_cost"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'half_production_cost'>selected</cfif></cfif>><cf_get_lang dictionary_id="58261.Yarı Mamüller / Üretim"></option>
                                                <option value="konsinye_sale_naz_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'konsinye_sale_naz_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="39676.Diğer Satış Nazım"></option>
                                                <option value="dimm_yans_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'dimm_yans_code'>selected</cfif></cfif>>D.I.M. Malz. Yans.</option>
                                                <option value="dimm_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'dimm_code'>selected</cfif></cfif>>D.I.M. Malz.</option>
                                                <option value="promotion_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'promotion_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="39677.Promosyon"></option>
                                                <option value="account_yurtdisi"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_yurtdisi'>selected</cfif></cfif>><cf_get_lang dictionary_id='39332.Yurtdisi Satis'></option>
                                                <option value="account_yurtdisi_pur"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_yurtdisi_pur'>selected</cfif></cfif>><cf_get_lang dictionary_id='39333.Yurtdisi Alis'></option>
                                                <option value="material_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'material_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='39334.Hammadde'></option>
                                                <option value="income_progress_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'income_progress_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='37298.Gelir Muhasebe Kodları'></option>
                                                <option value="expense_progress_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'expense_progress_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='37297.Gider Muhasebe Kodları'></option>
                                                <option value="konsinye_sale_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'konsinye_sale_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='40567.Diger Satis Hesabi'></option>
                                                <option value="konsinye_pur_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'konsinye_pur_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='40566.Diger Alis Hesabi'></option>
                                                <option value="account_loss"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_loss'>selected</cfif></cfif>><cf_get_lang dictionary_id='39335.Fireler'></option>
                                                <option value="account_expenditure"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_loss'>selected</cfif></cfif>><cf_get_lang dictionary_id='30009.Sarflar'></option>
                                                <option value="sale_product_cost"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'sale_product_cost'>selected</cfif></cfif>><cf_get_lang dictionary_id='58258.Maliyet'></option>
                                                <option value="over_count" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'over_count'>selected</cfif></cfif>><cf_get_lang dictionary_id='57753.Sayim Fazlasi'></option>
                                                <option value="under_count" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'under_count'>selected</cfif></cfif>><cf_get_lang dictionary_id='57754.Sayim Eksigi'></option>
                                                <option value="received_progress_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'received_progress_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="59117.Alınan Hakediş"></option>
                                                <option value="provided_progress_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'provided_progress_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="59118.Verilen Hakediş"></option>
                                                <option value="sale_manufactured_cost" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'sale_manufactured_cost'>selected</cfif></cfif>><cf_get_lang dictionary_id='59119.Satılan Mamülün Maliyeti'></option>
                                                <option value="scrap_code" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'scrap_code'>selected</cfif></cfif>><cf_get_lang dictionary_id="59120.Hurda"></option>
                                                <option value="material_code_sale" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'material_code_sale'>selected</cfif></cfif>><cf_get_lang dictionary_id='59121.Hammadde Satış'></option>
                                                <option value="production_cost_sale" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'production_cost_sale'>selected</cfif></cfif>><cf_get_lang dictionary_id="59122.Mamül Satış"></option>
                                                <option value="scrap_code_sale" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'scrap_code_sale'>selected</cfif></cfif>><cf_get_lang dictionary_id="59123.Hurda Satış"></option>
                                            </select>
                                        </div>
                                    </div>	
                                </div>	                               
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>checked</cfif>></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                        <input type="hidden" name="form_submitted" id="form_submitted" value="1">  
                        <cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
                    </div>
                </div> 
            </div>
       
        </cf_report_list_search_area>		
    </cf_report_list_search> 
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset type_ = 1>
    <cfset attributes.maxrows=GET_PROJECTS.recordcount>
    <cfset attributes.startrow=1>    	
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isDefined("attributes.form_submitted")>
    <cf_report_list>
        <thead>
            <tr>
                <th width="50"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id="40055.Proje Kategorisi"></th>
                <th><cf_get_lang dictionary_id="57095.Proje Adı">></th>
                <th><cf_get_lang dictionary_id="40264.Proje No"></th>
                <th width="50"><cf_get_lang dictionary_id='57448.Satis'></th>
                <th width="50"><cf_get_lang dictionary_id='58176.Alis'></th>
                <th width="50"><cf_get_lang dictionary_id='39328.Satis Iskonto'></th>
                <th width="50"><cf_get_lang dictionary_id='39329.Alis Iskonto'></th>
                <th width="50"><cf_get_lang dictionary_id='39326.Satis Iade'></th>
                <th width="50"><cf_get_lang dictionary_id='39327.Alis Iade'></th> 
                <th width="50"><cf_get_lang dictionary_id="57448.Satış"> <cf_get_lang dictionary_id="39331.Fiyat Farkı"></th>
                <th width="50"><cf_get_lang dictionary_id="58176.Alış"> <cf_get_lang dictionary_id="39331.Fiyat Farkı"></th>
                <th width="50"><cf_get_lang dictionary_id='39332.Yurtdisi Satis'></th>
                <th width="50"><cf_get_lang dictionary_id='39333.Yurtdisi Alis'></th>
                <th width="50"><cf_get_lang dictionary_id='59121.Hammadde Satış'></th>
                <th width="50"><cf_get_lang dictionary_id='39334.Hammadde'></th>
                <th width="50"><cf_get_lang dictionary_id='39335.Fireler'></th>
                <th width="50"><cf_get_lang dictionary_id='30009.Sarflar'></th>
                <th width="50"><cf_get_lang dictionary_id='57753.Sayim Fazlasi'></th>
                <th width="50"><cf_get_lang dictionary_id='57754.Sayim Eksigi'></th>
                <th width="50"><cf_get_lang dictionary_id="59122.Mamül Satış"></th>
                <th><cf_get_lang dictionary_id="57456.Üretim">/ <cf_get_lang dictionary_id="58262.Mamüller"></th>
                <th><cf_get_lang dictionary_id="58261.Yarı Mamüller / Üretim"></th>
                <th width="50"><cf_get_lang dictionary_id='39550.Satılan Malın Maliyeti'></th>
                <th width="50"><cf_get_lang dictionary_id='59119.Satılan Mamülün Maliyeti'></th>
                <th width="50"><cf_get_lang dictionary_id='40566.Diger Alis Hesabi'></th>
                <th width="50"><cf_get_lang dictionary_id='40567.Diger Satis Hesabi'></th>
                <th><cf_get_lang dictionary_id="39692.Satış Nazım"></th>
                <th width="50"><cf_get_lang dictionary_id="59117.Alınan Hakediş"></th>
                <th width="50"><cf_get_lang dictionary_id="59118.Verilen Hakediş"></th>
                <th width="50"><cf_get_lang dictionary_id="59123.Hurda Satış"></th>
                <th width="50"><cf_get_lang dictionary_id="59120.Hurda"></th>
                <th><cf_get_lang dictionary_id='65068.D.I.M. Malz.'></th>
                <th><cf_get_lang dictionary_id='65069.D.I.M. Malz. Yans.'></th>
                <th><cf_get_lang dictionary_id="39677.Promosyon"></th>
                <!---<th>G.U. <cf_get_lang dictionary_id="962.Giderleri Yansıtma"></th>--->
                <!---<th><cf_get_lang dictionary_id="969.Üretim İşcilik Yansıtma"></th>--->
                <th><cf_get_lang dictionary_id ='58460.Masraf Merkezi'></th>
                <th><cf_get_lang dictionary_id ='58551.Gider Kalemi'></th>
                <th><cf_get_lang dictionary_id ='37297.Gider Muhasebe Kodları'></th>
                <th><cf_get_lang dictionary_id ='39173.Aktivite Tipi'></th>
                <th><cf_get_lang dictionary_id ='58822.Masraf Şablonu'></th>
                <th><cf_get_lang dictionary_id ='58172.Gelir Merkezi'></th>
                <th><cf_get_lang dictionary_id ='58173.Gelir Kalemi'></th>
                <th><cf_get_lang dictionary_id ='37298.Gelir Muhasebe Kodları'></th>
                <th><cf_get_lang dictionary_id ='39173.Aktivite Tipi'></th>
                <th><cf_get_lang dictionary_id ='58823.Gelir Şablonu'></th>
                <!---<th width="50"><cf_get_lang dictionary_id='846.Maliyet'></th>--->
            </tr>
        </thead>        
        <tbody>
            <cfif GET_PROJECTS.recordcount>
                <cfset row_count_ = 0>
                <cfset project_cat_list ="">
                <cfif len(project_cat_list)>
                    <cfset project_cat_list = listsort(project_cat_list,'numeric','ASC',',')>
                    <cfquery name="get_pro_cat" datasource="#dsn#">
                        SELECT MAIN_PROCESS_CAT_ID, MAIN_PROCESS_CAT FROM SETUP_MAIN_PROCESS_CAT WHERE MAIN_PROCESS_CAT_ID IN(#project_cat_list#)
                    </cfquery>
                    <cfset project_cat_list = listsort(listdeleteduplicates(valuelist(get_pro_cat.MAIN_PROCESS_CAT_ID,',')),'numeric','ASC',',')>
                </cfif>
                <cfoutput query="GET_PROJECTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfset row_count_ = row_count_+1>
                    <tr>
                        <cfquery name="GET_MAIN_CAT" datasource="#dsn#">
                            SELECT 
                                MAIN_PROCESS_CAT
                            FROM
                                SETUP_MAIN_PROCESS_CAT
                            WHERE
                                MAIN_PROCESS_CAT_ID = #PROCESS_CAT#
                        </cfquery>
                        <td>#currentrow#</td>
                        <td nowrap="nowrap">#GET_MAIN_CAT.MAIN_PROCESS_CAT#</td><!---Proje Kategorisi--->
                        <td nowrap="nowrap">#project_head#</td><!---Proje Adı--->
                        <td>#PROJECT_NUMBER#</td><!---Proje No--->
                        <td nowrap>#account_code#</td><!---Satış--->
                        <td nowrap>#account_code_pur#</td><!---Alış--->
                        <td>#account_discount#</td><!---Satış İskonto--->
                        <td>#account_discount_pur#</td><!---Alış İskonto--->
                        <td>#account_iade#</td><!---Satış İade--->
                        <td>#account_pur_iade#</td> <!---Alış İade--->
                        <td>#account_price#</td><!---Satış Fiyat Farkı--->
                        <td>#account_price_pur#</td><!---Alış Fiyat Farkı--->
                        <td>#account_yurtdisi#</td><!---Yurtiçi satış--->
                        <td>#account_yurtdisi_pur#</td><!---yurtiçi alış--->
                        <td>#material_code_sale#</td><!---hammadde satış--->
                        <td>#material_code#</td><!---hammadde--->
                        <td>#account_loss#</td><!---fireler--->
                        <td>#account_expenditure#</td><!---sarflar--->
                        <td>#over_count#</td><!---sayım fazlalığı--->
                        <td>#under_count#</td><!---sayım eksikliği--->
                        <td>#production_cost_sale#</td><!---mamül satış--->
                        <td>#production_cost#</td><!---Üretim MAmüller--->
                        <td>#half_production_cost#</td><!---Üretim yarı mamüller--->
                        <td>#sale_product_cost#</td><!---satılan Malın maliyeti--->
                        <td>#sale_manufactured_cost#</td><!---satılan mamülün maliyeti--->
                        <td>#konsinye_pur_code#</td><!---diğer alış hesabı--->
                        <td>#konsinye_sale_code#</td><!---diğer satış hesabı--->
                        <td>#konsinye_sale_naz_code#</td><!---Satış Nazım--->
                        <td>#received_progress_code#</td><!---alınan hakediş--->
                        <td>#provided_progress_code#</td><!---verilen hakediş--->
                        <td>#scrap_code_sale#</td><!---hurda satış--->
                        <td>#scrap_code#</td><!---hurda--->
                        <td>#dimm_code#</td><!---D.I.M. Malz.--->
                        <td>#dimm_yans_code#</td><!---D.I.M. Malz. Yans.--->
                        <td>#promotion_code#</td><!---Promosyon--->
                        <!---<td>#prod_general_code#</td>--->
                        <!---<td>#prod_labor_cost_code#</td>--->
                        <td>#gider_merkezi#</td>
                        <td>#gider_kalemi#</td>
                        <td>#expense_progress_code#</td>
                        <td>#gider_aktivite_tipi#</td>
                        <td>#gider_sablonu#</td>
                        <td>#gelir_merkezi#</td><!---sale_product_cost--->
                        <td>#gelir_kalemi#</td>
                        <td>#INCOME_PROGRESS_CODE#</td>
                        <td>#gelir_aktivite_tipi#</td>
                        <td>#gelir_sablonu#</td>
                        <!---<td><!---#gelir_sablonu#---></td>--->
                        
                </tr>
                </cfoutput>
                <input type="hidden" name="row_count_" id="row_count_" value="<cfoutput>#row_count_#</cfoutput>">
            <cfelse>
                <tr>
                    <td colspan="50"><cf_get_lang dictionary_id='57484.Kayit Yok'> !</td>
                </tr>
            </cfif>        
        </tbody>
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfset adres = "#attributes.fuseaction#&form_submitted=#attributes.form_submitted#">
    <cfif len(attributes.employee_id) and len(attributes.employee)>
        <cfset adres = '#adres#&employee=#attributes.employee#'>
        <cfset adres = '#adres#&employee_id=#attributes.employee_id#'>
    </cfif>
    <cfif isdefined('url.pro_met_id') and len(url.pro_met_id)>
        <cfset adres="#adres#&pro_met_id=#attributes.pro_met_id#">
    </cfif>
    <cfif Len(attributes.process_catid)>
        <cfset adres = "#adres#&process_catid=#attributes.process_catid#">
    </cfif>
    <cfif len(attributes.PROJECT_ID) and len(attributes.stock_id) and len(attributes.project)>
        <cfset adres = '#adres#&product=#attributes.project#'>
        <cfset adres = '#adres#&PROJECT_ID=#attributes.PROJECT_ID#'>
        <cfset adres = '#adres#&stock_id=#attributes.stock_id#'>
    </cfif>
    <cfif len(attributes.main_process_cat) and (isDefined('attributes.process_cat_code') and len(attributes.process_cat_code))>
        <cfset adres = "#adres#&process_cat_code=#attributes.process_cat_code#">
    </cfif>
    <cfif len(attributes.main_process_cat)>
        <cfset adres = "#adres#&main_process_cat=#attributes.main_process_cat#">
    </cfif>        
    <cfif len(attributes.has_account_code)>
        <cfset adres = '#adres#&has_account_code=#attributes.has_account_code#'>
    </cfif>
    <cfif isdefined('attributes.list_account')>
        <cfset adres='#adres#&list_account=#attributes.list_account#'>
    </cfif>
    <cfset adres = '#adres#&is_active=#attributes.is_active#'>
    <cf_paging
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#adres#"> 
</cfif>
<script type="text/javascript">
	function show_select()
	{
		if(document.getElementById('has_account_code').value.length > 0)
			document.getElementById('tdlist_account').style.display='';
		else
			document.getElementById('tdlist_account').style.display='none';
    }
    function control(){   
		if(document.search_product.is_excel.checked==false)
			{
				document.search_product.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
				return true;
			}
			else
                document.search_product.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_project_account_report</cfoutput>"
                                                                                       
	}
</script>
