<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),12,1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.organization_step_id" default="">
<cfparam name="attributes.duty_type" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.unit_id" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.report_basis" default="1">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.report_type_batch" default="">
<cfparam name="attributes.start_date" default="1/1/#session.ep.period_year#">
<cfparam name="attributes.finish_date" default="#bu_ay_sonu#/12/#session.ep.period_year#">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfscript>
    cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps");
    cmp_org_step.dsn = dsn;
    get_organization_steps = cmp_org_step.get_organization_step();
</cfscript>
<cfscript>
	duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
	QueryAddRow(duty_type,8);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang(164,'Çalışan',57576)#",1);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang(1320,'Ürün Eklendi',58732)#",2);//işveren vekili
	QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang(1321,'Alıcı',58733)#",3);//işveren
	QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Sendikalı',4);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Sözleşmeli',5);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Kapsam Dışı',6);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Kısmi İstihdam',7);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Taşeron',8);
</cfscript>
<cfscript>
	report_type = QueryNew("report_type_id, report_type_name");
	QueryAddRow(report_type,5);
	QuerySetCell(report_type,"report_type_id",1,1);
	QuerySetCell(report_type,"report_type_name","Şirket içi gerekçeye göre",1);
	QuerySetCell(report_type,"report_type_id",2,2);
	QuerySetCell(report_type,"report_type_name",'İşten çıkış gerekçesine göre',2);
	QuerySetCell(report_type,"report_type_id",3,3);
	QuerySetCell(report_type,"report_type_name",'Kıdeme göre',3);
	QuerySetCell(report_type,"report_type_id",4,4);
	QuerySetCell(report_type,"report_type_name",'Cinsiyete göre',4);
	QuerySetCell(report_type,"report_type_id",5,5);
	QuerySetCell(report_type,"report_type_name",'İstifa - Fesih durumuna göre',5);
</cfscript>
<cfquery name="get_company" datasource="#dsn#">
	SELECT 
        COMP_ID,
        NICK_NAME 
    FROM 
        OUR_COMPANY 
    <cfif not session.ep.ehesap>
        WHERE COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
    </cfif>
    ORDER BY 
        NICK_NAME
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
        BRANCH_ID,
        BRANCH_NAME 
    FROM 
        BRANCH 
    WHERE 
        <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            COMPANY_ID IN(#attributes.comp_id#)
            <cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
        <cfelse>
            1=0
        </cfif>
    ORDER BY 
        BRANCH_NAME
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_position_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="get_titles" datasource="#dsn#">
	SELECT TITLE, TITLE_ID FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfquery name="get_units" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT ORDER BY UNIT_NAME 
</cfquery>
<cfquery name="get_zones" datasource="#dsn#">
	SELECT ZONE_ID,ZONE_NAME FROM ZONE WHERE ZONE_STATUS = 1 ORDER BY ZONE_NAME 
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></cfsavecontent>
    <cf_report_list_search  title="#title#">
	    <cf_report_list_search_area>
            <cfform name="search_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
                <div class="row">
        		    <div class="col col-12 col-xs-12">
            		    <div class="row formContent">
                		    <div class="row" type="row">
							    <div class="col col-3 col-md-6 col-xs-12">
                                    <div class="form-group">
									    <div class="col col-12 col-xs-12">
                                            <label class="form-label"><cf_get_lang dictionary_id='57574.Şirket'></label>
                                            <div class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="get_company"  
                                                name="comp_id"
                                                option_value="COMP_ID"
                                                option_name="NICK_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.comp_id#"
                                                onchange="get_branch_list(this.value)">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="zone_td">
									    <div class="col col-12 col-xs-12">
                                            <label class="form-label"><cf_get_lang dictionary_id='57992.Bölge'></label>
                                            <div class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="get_zones"  
                                                name="zone_id"
                                                option_value="ZONE_ID"
                                                option_name="ZONE_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.zone_id#">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="branch_td">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <div class="col col-12 col-xs-12" id="BRANCH_PLACE">
                                            <div class="col col-12">
                                                <div id="BRANCH_PLACE" class="multiselect-z2">
                                                    <cf_multiselect_check 
                                                    query_name="get_branchs"  
                                                    name="branch_id"
                                                    option_value="BRANCH_ID"
                                                    option_name="BRANCH_NAME"
                                                    option_text="#getLang('main',322)#"
                                                    value="#attributes.branch_id#"
                                                    onchange="get_department_list(this.value)">
                                                </div>
                                            </div>
                                        </div>									    
                                    </div>
                                    <div class="form-group" id="department_td">
                                        <label class="col col-12"><cf_get_lang dictionary_id="57572.Departman"></label>
									    <div class="col col-12 col-xs-12" id="DEPARTMENT_PLACE">
                                            <div class="multiselect-z2" id="DEPARTMENT_PLACE">
												<cf_multiselect_check 
												query_name="get_department"  
												name="department"
												option_text="#getLang('main',322)#" 
												option_value="department_id"
												option_name="department_head"
												value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
											</div>
                                        </div>
                                    </div>

                                </div>
                                <div class="col col-3 col-md-6 col-xs-12">
                                    <div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39174.Rapor Baz'></label>
									    <div class="col col-9 col-xs-12">
                                            <select name="report_basis" id="report_basis" onchange="rep_type_select();">
                                                <option value="0" <cfif isdefined("attributes.report_basis") and attributes.report_basis eq 0>selected</cfif>><cf_get_lang dictionary_id='58785.Detaylı'></option>
                                                <option value="1" <cfif isdefined("attributes.report_basis") and attributes.report_basis eq 1>selected</cfif>><cf_get_lang dictionary_id='58057.Toplu'></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="rep_type_td" <cfif attributes.report_basis eq 1>style="display:none;"</cfif>>
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='38931.Rapor Tipi Seçiniz'><cfsavecontent variable="option_text"><cf_get_lang dictionary_id='38931.Rapor Tipi Seçiniz'></cfsavecontent></label>
									    <div class="col col-9 col-xs-12" style="position:relative;">
                                            <cf_multiselect_check 
                                                query_name="report_type"  
                                                name="report_type"
                                                width="170" 
                                                option_value="report_type_id"
                                                option_name="report_type_name"
                                                option_text="#option_text#"
                                                value="#attributes.report_type#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="rep_type_batch_td" <cfif attributes.report_basis eq 0>style="display:none;"</cfif>>
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='38931.Rapor Tipi Seçiniz'></label>
									    <div class="col col-9 col-xs-12">
                                            <select name="report_type_batch" id="report_type_batch" onchange="filtreGizleGoster();">
                                                <option value=""><cf_get_lang dictionary_id='38931.Rapor Tipi Seçiniz'></option>
                                                <option value="0" <cfif isdefined("attributes.report_type_batch") and attributes.report_type_batch eq 0>selected</cfif>><cf_get_lang dictionary_id='57574.Şirket'></option>
                                                <option value="5" <cfif isdefined("attributes.report_type_batch") and attributes.report_type_batch eq 5>selected</cfif>><cf_get_lang dictionary_id='57992.Bölge'></option>
                                                <option value="1" <cfif isdefined("attributes.report_type_batch") and attributes.report_type_batch eq 1>selected</cfif>><cf_get_lang dictionary_id='57453.Şube'></option>
                                                <option value="2" <cfif isdefined("attributes.report_type_batch") and attributes.report_type_batch eq 2>selected</cfif>><cf_get_lang dictionary_id='57572.Departman'></option>
                                                <option value="3" <cfif isdefined("attributes.report_type_batch") and attributes.report_type_batch eq 3>selected</cfif>><cf_get_lang dictionary_id='57571.Ünvan'></option>
                                                <option value="4" <cfif isdefined("attributes.report_type_batch") and attributes.report_type_batch eq 4>selected</cfif>><cf_get_lang dictionary_id='58701.Fonksiyon'></option>
                                            </select>
                                        </div>
                                    </div>

                                </div>
                                <div class="col col-3 col-md-6 col-xs-12">
                                    <div class="form-group">
                           		 	    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                                	        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'></cfsavecontent>
									    <div class="col col-9 col-xs-12">
										    <div class="input-group">
                                                <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                                <span class="input-group-addon no-bg"></span>
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz '></cfsavecontent>
                                                <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>  
										    </div>
									    </div>
                        		    </div>
                                    <div class="form-group" id="hierarchy_td">
                                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
                                        <div class="col col-9 col-xs-12">
                                            <input type="text" name="hierarchy" id="hierarchy" value="<cfif len(attributes.hierarchy)><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" />
                                        </div>
                                    </div>
                                
                                </div>
                                <div class="col col-3 col-md-6 col-xs-12">
                                    <div class="form-group" id="title_td">
                                        <label class="col col-12 col-md-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                                        <div class="col col-9 col-xs-12">
                                            <div class="multiselect-z1">
                                                <cf_multiselect_check 
                                                query_name="get_titles"  
                                                name="title_id"
                                                option_value="TITLE_ID"
                                                option_name="TITLE"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.title_id#">
                                            </div>                        
                                        </div>
                                    </div>
                                    <div class="form-group" id="function_td">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
                                        <div class="col col-9 col-xs-12">
                                            <div class="multiselect-z1">
                                                <cf_multiselect_check 
                                                query_name="get_units"  
                                                name="unit_id"
                                                option_value="UNIT_ID"
                                                option_name="UNIT_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.unit_id#">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="hierarchy_td">
                                        <div class="col col-9 col-xs-12">
                                            <label><cf_get_lang dictionary_id='60703.Nakiller hariç'> <input type="checkbox" name="is_removal" id="is_removal" value="1" <cfif isdefined('attributes.is_removal')>checked</cfif>></label>
                                            <label><cf_get_lang dictionary_id='42830.Görev Değişikliklerinden Al'> <input type="checkbox" name="is_duty_changes" id="is_duty_changes" value="1" <cfif isdefined('attributes.is_duty_changes')>checked</cfif>></label>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-collar_type">
                                        <label class="col col-12"><cf_get_lang dictionary_id='56063.Yaka Tipi'></label>
                                        <div class="col col-9">
                                            <select name="collar_type" id="collar_type">
                                                <option value=""><cf_get_lang dictionary_id='56063.Yaka Tipi'></option>
                                                <option value="1"<cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='56065.Mavi Yaka'></option> 
                                                <option value="2"<cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='56066.Beyaz Yaka'></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-organization_step_id">
                                        <label class="col col-12"><cf_get_lang dictionary_id ='58710.Kademe'></label>
                                        <div class="col col-9">
                                            <cf_multiselect_check 
                                            query_name="get_organization_steps"
                                            name="organization_step_id"
                                            width="135"
                                            option_value="ORGANIZATION_STEP_ID"
                                            option_name="ORGANIZATION_STEP_NAME"
                                            value="#attributes.organization_step_id#"
                                            option_text="#getLang('','Kademe',58710)#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-position_cat_id">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                                        <div class="col col-9">
                                            <cf_multiselect_check 
                                            query_name="get_position_cats"
                                            name="position_cat_id"
                                            width="135"
                                            option_value="POSITION_CAT_ID"
                                            option_name="POSITION_CAT"
                                            value="#attributes.position_cat_id#"
                                            option_text="#getLang('','Pozisyon Tipleri',57779)#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-duty_type">
                                        <label class="col col-12"><cfoutput>#getlang(806,'Çalışan Tipi',55891)#</cfoutput></label>
                                        <div class="col col-9">
                                            <cf_multiselect_check 
                                            query_name="duty_type"
                                            name="duty_type"
                                            width="135"
                                            option_value="DUTY_TYPE_ID"
                                            option_name="DUTY_TYPE_NAME"
                                            value="#attributes.duty_type#"
                                            option_text="#getLang(806,'Çalışan Tipi',55891)#">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row ReportContentBorder">
                            <div class="ReportContentFooter">
                                <cf_wrk_report_search_button search_function='control()' button_type='1'>
                            </div>
                        </div>
                    </div>
                </div>
            </cfform>
        </cf_report_list_search_area>
    </cf_report_list_search>
<cfif len(attributes.report_type) or  len(attributes.report_type_batch)>
    <cfquery name="get_stdt_emp_count" datasource="#dsn#">
        SELECT
            E.EMPLOYEE_ID,
            B.COMPANY_ID,
            B.ZONE_ID,
            <cfif isdefined('is_duty_changes')>
            	CASE WHEN EPC.ID IS NULL THEN EP.TITLE_ID ELSE EPC.TITLE_ID END AS TITLE_ID,
                CASE WHEN EPC.ID IS NULL THEN EP.FUNC_ID ELSE EPC.FUNC_ID END AS FUNC_ID,
                CASE WHEN EPC.ID IS NULL THEN EIO.DEPARTMENT_ID ELSE EPC.DEPARTMENT_ID END AS DEPARTMENT_ID,
                CASE WHEN EPC.ID IS NULL THEN EIO.BRANCH_ID ELSE D.BRANCH_ID END AS BRANCH_ID,
            <cfelse>
            	EP.TITLE_ID,
                EP.FUNC_ID,
                EIO.DEPARTMENT_ID,
                EIO.BRANCH_ID,
            </cfif>
            D.HIERARCHY
        FROM 
        	EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
            <cfif isdefined('is_duty_changes')>
                LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPC ON 
                    EPC.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                    AND EPC.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
                    AND EPC.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
                    AND EPC.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">)
            </cfif>
            , DEPARTMENT D,
            BRANCH B LEFT JOIN ZONE Z ON Z.ZONE_ID=B.ZONE_ID
        WHERE
        	<cfif isdefined('is_duty_changes')>
        		((EPC.ID IS NULL AND 
          	</cfif>
            EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND EIO.BRANCH_ID = B.BRANCH_ID
            <cfif len(attributes.department)>
                AND EIO.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
            </cfif>
            <cfif len(attributes.branch_id)>
                AND EIO.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.unit_id)>
                AND EP.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.title_id)>
                AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
            </cfif>
            <cfif isdefined('is_duty_changes')>
            	) OR (EPC.ID IS NOT NULL AND EPC.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID
                <cfif len(attributes.department)>
                    AND EPC.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND D.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.unit_id)>
                    AND EPC.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.title_id)>
                    AND EPC.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
                </cfif>
                ))
        	</cfif>
            <cfif len(attributes.collar_type)>
                AND EP.COLLAR_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#" list=yes>)
            </cfif>
            <cfif len(attributes.organization_step_id)>
                AND EP.ORGANIZATION_STEP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_step_id#" list="yes">)
            </cfif>
            <cfif len(attributes.position_cat_id)>
                AND EP.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#" list="yes">)
            </cfif>
            <cfif len(attributes.duty_type)>
                AND EP.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE DUTY_TYPE IN (#attributes.duty_type#) AND FINISH_DATE IS NULL)
            </cfif>
            AND D.IS_STORE <> 1 AND D.DEPARTMENT_STATUS = 1
			AND (EP.EMPLOYEE_ID IS NULL OR EP.IS_MASTER = 1) 
			AND ((EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">) 
            OR (EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> AND EIO.FINISH_DATE IS NULL ))
            <cfif len(attributes.comp_id)>
                AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
            </cfif>
            <cfif not session.ep.ehesap>
                AND EIO.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif len(attributes.zone_id)>
                AND B.ZONE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.hierarchy)>
                AND D.HIERARCHY = '#attributes.hierarchy#'
            </cfif>
            <cfif isdefined('is_removal')>
            	AND (EIO.EXPLANATION_ID NOT IN (18) OR EX_IN_OUT_ID IS NULL)
            </cfif>
    </cfquery>
    <cfif get_stdt_emp_count.recordcount>
        <cfset startdate_emps_count = get_stdt_emp_count.recordcount>
    <cfelse>
        <cfset startdate_emps_count = 0>
    </cfif>
    <cfquery name="get_fndt_emp_count" datasource="#dsn#">
        SELECT
            E.EMPLOYEE_ID,
            B.COMPANY_ID,
            B.ZONE_ID,
            <cfif isdefined('is_duty_changes')>
            	CASE WHEN EPC.ID IS NULL THEN EP.TITLE_ID ELSE EPC.TITLE_ID END AS TITLE_ID,
                CASE WHEN EPC.ID IS NULL THEN EP.FUNC_ID ELSE EPC.FUNC_ID END AS FUNC_ID,
                CASE WHEN EPC.ID IS NULL THEN EIO.DEPARTMENT_ID ELSE EPC.DEPARTMENT_ID END AS DEPARTMENT_ID,
                CASE WHEN EPC.ID IS NULL THEN EIO.BRANCH_ID ELSE D.BRANCH_ID END AS BRANCH_ID,
            <cfelse>
            	EP.TITLE_ID,
                EP.FUNC_ID,
                EIO.DEPARTMENT_ID,
                EIO.BRANCH_ID,
            </cfif>
            D.HIERARCHY
        FROM 
            EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
            <cfif isdefined('is_duty_changes')>
                LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPC ON 
                    EPC.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                    AND EPC.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
                    AND EPC.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
                    AND EPC.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">)
            </cfif>
            , DEPARTMENT D,
            BRANCH B LEFT JOIN ZONE Z ON B.ZONE_ID = Z.ZONE_ID
        WHERE
        	<cfif isdefined('is_duty_changes')>
        		((EPC.ID IS NULL AND 
          	</cfif>
            EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND EIO.BRANCH_ID = B.BRANCH_ID
            <cfif len(attributes.department)>
                AND EIO.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
            </cfif>
            <cfif len(attributes.branch_id)>
                AND EIO.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.unit_id)>
                AND EP.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.title_id)>
                AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
            </cfif>
            <cfif isdefined('is_duty_changes')>
            	) OR (EPC.ID IS NOT NULL AND EPC.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID
                <cfif len(attributes.department)>
                    AND EPC.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND D.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.unit_id)>
                    AND EPC.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.title_id)>
                    AND EPC.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
                </cfif>
                ))
        	</cfif>
            AND D.IS_STORE <> 1 AND D.DEPARTMENT_STATUS = 1
            AND (EP.EMPLOYEE_ID IS NULL OR EP.IS_MASTER = 1) 
            AND ((EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"> AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">) 
            OR (EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"> AND EIO.FINISH_DATE IS NULL ))
            <cfif len(attributes.comp_id)>
                AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
            </cfif>
            <cfif not session.ep.ehesap>
                AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif len(attributes.zone_id)>
                AND B.ZONE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.hierarchy)>
                AND D.HIERARCHY = '#attributes.hierarchy#'
            </cfif>
            <cfif isdefined('is_removal')>
            	AND( EIO.EXPLANATION_ID NOT IN (18) OR EX_IN_OUT_ID IS NULL)
            </cfif>
    </cfquery>
    <cfif get_fndt_emp_count.recordcount>
        <cfset finishdate_emps_count = get_fndt_emp_count.recordcount>
    <cfelse>
        <cfset finishdate_emps_count = 0>
    </cfif>
    <cfquery name="get_in_emp_count" datasource="#dsn#">
        SELECT
            E.EMPLOYEE_ID,
            B.COMPANY_ID,
            B.ZONE_ID,
            <cfif isdefined('is_duty_changes')>
            	CASE WHEN EPC.ID IS NULL THEN EP.TITLE_ID ELSE EPC.TITLE_ID END AS TITLE_ID,
                CASE WHEN EPC.ID IS NULL THEN EP.FUNC_ID ELSE EPC.FUNC_ID END AS FUNC_ID,
                CASE WHEN EPC.ID IS NULL THEN EIO.DEPARTMENT_ID ELSE EPC.DEPARTMENT_ID END AS DEPARTMENT_ID,
                CASE WHEN EPC.ID IS NULL THEN EIO.BRANCH_ID ELSE D.BRANCH_ID END AS BRANCH_ID,
            <cfelse>
            	EP.TITLE_ID,
                EP.FUNC_ID,
                EIO.DEPARTMENT_ID,
                EIO.BRANCH_ID,
            </cfif>
            D.HIERARCHY
        FROM 
            EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
            <cfif isdefined('is_duty_changes')>
                LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPC ON 
                    EPC.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                    AND EPC.START_DATE <= EIO.START_DATE
                    AND EPC.FINISH_DATE >=EIO.START_DATE
                    AND EPC.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND START_DATE <= EIO.START_DATE AND FINISH_DATE >= EIO.START_DATE)
            </cfif>
            , DEPARTMENT D,
            BRANCH B LEFT JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
        WHERE
        	<cfif isdefined('is_duty_changes')>
        		((EPC.ID IS NULL AND 
          	</cfif>
            EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND EIO.BRANCH_ID = B.BRANCH_ID
            <cfif len(attributes.department)>
                AND EIO.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
            </cfif>
            <cfif len(attributes.branch_id)>
                AND EIO.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.unit_id)>
                AND EP.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.title_id)>
                AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
            </cfif>
            <cfif isdefined('is_duty_changes')>
            	) OR (EPC.ID IS NOT NULL AND EPC.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID
                <cfif len(attributes.department)>
                    AND EPC.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND D.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.unit_id)>
                    AND EPC.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.title_id)>
                    AND EPC.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
                </cfif>
                ))
        	</cfif>
            AND D.IS_STORE <> 1 AND D.DEPARTMENT_STATUS = 1
            AND (EP.EMPLOYEE_ID IS NULL OR EP.IS_MASTER = 1) 
            <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
                AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
            </cfif>
            <cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
                AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
            </cfif>
            <cfif len(attributes.comp_id)>
                AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
            </cfif>
            <cfif not session.ep.ehesap>
                AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif len(attributes.zone_id)>
                AND B.ZONE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.hierarchy)>
                AND D.HIERARCHY = '#attributes.hierarchy#'
            </cfif>
            <cfif isdefined('is_removal')>
            	AND EX_IN_OUT_ID IS NULL
            </cfif>
    </cfquery>
    <cfif get_in_emp_count.recordcount>
        <cfset in_emps_count = get_in_emp_count.recordcount>
    <cfelse>
        <cfset in_emps_count = 0>
    </cfif>
    <cfquery name="get_out_emp_count" datasource="#dsn#">
        SELECT
            E.EMPLOYEE_ID,
            B.COMPANY_ID,
            B.ZONE_ID,
            <cfif isdefined('is_duty_changes')>
            	CASE WHEN EPC.ID IS NULL THEN EP.TITLE_ID ELSE EPC.TITLE_ID END AS TITLE_ID,
                CASE WHEN EPC.ID IS NULL THEN EP.FUNC_ID ELSE EPC.FUNC_ID END AS FUNC_ID,
                CASE WHEN EPC.ID IS NULL THEN EIO.DEPARTMENT_ID ELSE EPC.DEPARTMENT_ID END AS DEPARTMENT_ID,
                CASE WHEN EPC.ID IS NULL THEN EIO.BRANCH_ID ELSE D.BRANCH_ID END AS BRANCH_ID,
            <cfelse>
            	EP.TITLE_ID,
                EP.FUNC_ID,
                EIO.DEPARTMENT_ID,
                EIO.BRANCH_ID,
            </cfif>
            D.HIERARCHY
        FROM 
            EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
            <cfif isdefined('is_duty_changes')>
                LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPC ON 
                    EPC.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                    AND EPC.START_DATE <= EIO.FINISH_DATE
                    AND EPC.FINISH_DATE >= EIO.FINISH_DATE
                    AND EPC.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND START_DATE <= EIO.FINISH_DATE AND FINISH_DATE >= EIO.FINISH_DATE)
            </cfif>
            , DEPARTMENT D,
            BRANCH B LEFT JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
        WHERE 
        	<cfif isdefined('is_duty_changes')>
        		((EPC.ID IS NULL AND 
          	</cfif>
            EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND EIO.BRANCH_ID = B.BRANCH_ID
            <cfif len(attributes.department)>
                AND EIO.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
            </cfif>
            <cfif len(attributes.branch_id)>
                AND EIO.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.unit_id)>
                AND EP.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.title_id)>
                AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
            </cfif>
            <cfif isdefined('is_duty_changes')>
            	) OR (EPC.ID IS NOT NULL AND EPC.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID
                <cfif len(attributes.department)>
                    AND EPC.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND D.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.unit_id)>
                    AND EPC.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.title_id)>
                    AND EPC.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
                </cfif>
                ))
        	</cfif>
            AND D.IS_STORE <> 1 AND D.DEPARTMENT_STATUS = 1
            AND (EP.EMPLOYEE_ID IS NULL OR EP.IS_MASTER = 1) 
            AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
            AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
            AND	EIO.FINISH_DATE IS NOT NULL
            <cfif len(attributes.comp_id)>
                AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
            </cfif>
            <cfif not session.ep.ehesap>
                AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif len(attributes.zone_id)>
                AND B.ZONE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.hierarchy)>
                AND D.HIERARCHY = '#attributes.hierarchy#'
            </cfif>
            <cfif isdefined('is_removal')>
            	AND EIO.EXPLANATION_ID NOT IN (18)
            </cfif>
    </cfquery>
    <cfif get_out_emp_count.recordcount>
        <cfset out_emps_count = get_out_emp_count.recordcount>
    <cfelse>
        <cfset out_emps_count = 0>
    </cfif>
    <cfif isdefined('is_removal')>
        <cfquery name="get_nakil_emp_count" datasource="#dsn#">
            SELECT 
                E.EMPLOYEE_ID,
                B.COMPANY_ID,
                B.ZONE_ID,
                <cfif isdefined('is_duty_changes')>
                    CASE WHEN EPC.ID IS NULL THEN EP.TITLE_ID ELSE EPC.TITLE_ID END AS TITLE_ID,
                    CASE WHEN EPC.ID IS NULL THEN EP.FUNC_ID ELSE EPC.FUNC_ID END AS FUNC_ID,
                    CASE WHEN EPC.ID IS NULL THEN EIO.DEPARTMENT_ID ELSE EPC.DEPARTMENT_ID END AS DEPARTMENT_ID,
                    CASE WHEN EPC.ID IS NULL THEN EIO.BRANCH_ID ELSE D.BRANCH_ID END AS BRANCH_ID,
                <cfelse>
                    EP.TITLE_ID,
                    EP.FUNC_ID,
                    EIO.DEPARTMENT_ID,
                    EIO.BRANCH_ID,
                </cfif>
                D.HIERARCHY
            FROM 
                EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
                <cfif isdefined('is_duty_changes')>
                    LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPC ON 
                        EPC.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                        AND EPC.START_DATE <= EIO.FINISH_DATE
                        AND EPC.FINISH_DATE >= EIO.FINISH_DATE
                        AND EPC.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND START_DATE <= EIO.FINISH_DATE AND FINISH_DATE >= EIO.FINISH_DATE)
                </cfif>
                , DEPARTMENT D,
                BRANCH B LEFT JOIN ZONE Z ON B.ZONE_ID = Z.ZONE_ID
            WHERE
            	<cfif isdefined('is_duty_changes')>
                    ((EPC.ID IS NULL AND 
                </cfif>
                EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND EIO.BRANCH_ID = B.BRANCH_ID
                <cfif len(attributes.department)>
                    AND EIO.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND EIO.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.unit_id)>
                    AND EP.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.title_id)>
                    AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
                </cfif>
                <cfif isdefined('is_duty_changes')>
                    ) OR (EPC.ID IS NOT NULL AND EPC.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID
                    <cfif len(attributes.department)>
                        AND EPC.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
                    </cfif>
                    <cfif len(attributes.branch_id)>
                        AND D.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                    </cfif>
                    <cfif len(attributes.unit_id)>
                        AND EPC.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
                    </cfif>
                    <cfif len(attributes.title_id)>
                        AND EPC.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
                    </cfif>
                    ))
                </cfif>
                AND D.IS_STORE <> 1 AND D.DEPARTMENT_STATUS = 1
                AND (EP.EMPLOYEE_ID IS NULL OR EP.IS_MASTER = 1) 
                AND (EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
                AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
                AND	EIO.FINISH_DATE IS NOT NULL and EIO.EXPLANATION_ID = 18)
                <cfif len(attributes.comp_id)>
                    AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
                </cfif>
                <cfif not session.ep.ehesap>
                    AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                    AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
                <cfif len(attributes.zone_id)>
                    AND B.ZONE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.hierarchy)>
                    AND D.HIERARCHY = '#attributes.hierarchy#'
                </cfif>
        </cfquery>
        <cfset nakil_emps_count = get_nakil_emp_count.recordcount>
    <cfelse>
    	<cfset nakil_emps_count = 0>
    </cfif>
</cfif>
<!-- sil -->
<cfif attributes.report_basis eq 1>
	<cfinclude template="turnover_batch_rep.cfm">
<cfelseif attributes.report_basis eq 0>
	<cfinclude template="turnover_detail_rep.cfm">
</cfif>
<!-- sil -->
<script type="text/javascript">
	$(document).ready(function(){
		filtreGizleGoster();
	})
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
	
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	
	function control(){
		if ((document.search_form.report_basis.value == 0 && document.search_form.report_type.value == '') || (document.search_form.report_basis.value == 1 && document.search_form.report_type_batch.value =='')){
			alert("<cf_get_lang dictionary_id='60704.Rapor tipi seçeneklerinden en az birini seçmelisiniz.'>");
			return false;
		}
		else 
			return true;
	}
	
	function rep_type_select(){
		if (document.getElementById('report_basis').value == 1){
			document.getElementById('rep_type_td').style.display = 'none';
			document.getElementById('report_type').value = '';
			document.getElementById('rep_type_batch_td').style.display = '';
		} else if (document.getElementById('report_basis').value == 0){
			document.getElementById('rep_type_td').style.display = '';
			document.getElementById('rep_type_batch_td').style.display = 'none';
			document.getElementById('report_type_batch').value = '';
		}
		filtreGizleGoster();
	}
	
	function filtreGizleGoster(){
		if (document.getElementById('report_type_batch').value){
			document.getElementById('title_td').style.display = 'none';
			document.getElementById('title_id').value = '';
			switch(document.getElementById('report_type_batch').value){
				case '0': 
					document.getElementById('branch_td').style.display = 'none';
					document.getElementById('department_td').style.display = 'none';
					document.getElementById('function_td').style.display = 'none';
					document.getElementById('hierarchy_td').style.display = 'none';
					document.getElementById('zone_td').style.display = 'none';
					document.getElementById('branch_id').value = '';
					document.getElementById('zone_id').value = '';
					document.getElementById('department').value = '';
					document.getElementById('unit_id').value = '';
					document.getElementById('hierarchy').value = '';
					break;
				case '5': 
					document.getElementById('branch_td').style.display = 'none';
					document.getElementById('department_td').style.display = 'none';
					document.getElementById('function_td').style.display = 'none';
					document.getElementById('hierarchy_td').style.display = 'none';
					document.getElementById('zone_td').style.display = '';
					document.getElementById('branch_id').value = '';
					document.getElementById('department').value = '';
					document.getElementById('unit_id').value = '';
					document.getElementById('hierarchy').value = '';
					break;
				case '1':
					document.getElementById('branch_td').style.display = '';
					document.getElementById('department_td').style.display = 'none';
					document.getElementById('function_td').style.display = 'none';
					document.getElementById('hierarchy_td').style.display = 'none';
					document.getElementById('department').value = '';
					document.getElementById('unit_id').value = '';
					document.getElementById('hierarchy').value = '';
					break;
				case '2':
					document.getElementById('branch_td').style.display = '';
					document.getElementById('department_td').style.display = '';
					document.getElementById('hierarchy_td').style.display = '';
					document.getElementById('function_td').style.display = 'none';
					document.getElementById('unit_id').value = '';
					break;
				default: 
					document.getElementById('branch_td').style.display = '';
					document.getElementById('department_td').style.display = '';
					document.getElementById('function_td').style.display = '';
					document.getElementById('title_td').style.display = '';
					document.getElementById('hierarchy_td').style.display = '';
					break;
			}
		} else {
			document.getElementById('title_td').style.display = '';
			document.getElementById('branch_td').style.display = '';
			document.getElementById('department_td').style.display = '';
			document.getElementById('function_td').style.display = '';
		}
	}
</script>
