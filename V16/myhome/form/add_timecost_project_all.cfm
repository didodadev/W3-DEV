<cf_xml_page_edit fuseact="myhome.popup_add_timecost_project_all">
<!--- Projeye kayıtlı iş grubu var ise eger defult olarak kayıtlı olan employeeleri getirmek icin FA --->
<cfif isdefined('attributes.id') and len(attributes.id)>
    <cfquery name="GET_PROJECT_WORKGROUP" datasource="#DSN#" maxrows="1">
        SELECT WORKGROUP_ID FROM WORK_GROUP WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
</cfif>
<cfif isdefined("attributes.id") and len(attributes.id) and get_project_workgroup.recordcount>
    <cfquery name="GET_EMPS_PROJECT_GROUP" datasource="#DSN#">
        SELECT 
            EP.EMPLOYEE_NAME,
            EP.EMPLOYEE_SURNAME,
            EP.EMPLOYEE_ID,
            TC.EVENT_DATE,
            TC.EXPENSED_MINUTE,
            TC.COMMENT,
            TC.OVERTIME_TYPE,
            TC.STATE,
            TC.ACTIVITY_ID,
            TC.TIME_COST_CAT_ID,
            TC.TIME_COST_STAGE,
            P.PRODUCT_ID,
            P.PRODUCT_NAME,
            PW.WORK_ID,
            PW.WORK_HEAD,
            TC.IS_RD_SSK
        FROM
            TIME_COST TC
            LEFT JOIN WORKGROUP_EMP_PAR WEP ON WEP.EMPLOYEE_ID = TC.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = TC.EMPLOYEE_ID
            LEFT JOIN #dsn1_alias#.PRODUCT P ON TC.PRODUCT_ID = P.PRODUCT_ID
            LEFT JOIN PRO_WORKS PW ON TC.WORK_ID = PW.WORK_ID
        WHERE 
            WEP.EMPLOYEE_ID IS NOT NULL
            AND WEP.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_project_workgroup.workgroup_id#"> 
            AND TC.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        GROUP BY
            EP.EMPLOYEE_NAME,
            EP.EMPLOYEE_SURNAME,
            EP.EMPLOYEE_ID,
            TC.EVENT_DATE,
            TC.EXPENSED_MINUTE,
            TC.COMMENT,
            TC.IS_RD_SSK,
            TC.OVERTIME_TYPE,
            TC.STATE,
            TC.ACTIVITY_ID,
            TC.TIME_COST_CAT_ID,
            TC.TIME_COST_STAGE,
            P.PRODUCT_ID,
            P.PRODUCT_NAME,
            PW.WORK_ID,
            PW.WORK_HEAD,
            WEP.HIERARCHY       
        ORDER BY 
            WEP.HIERARCHY
    </cfquery>
<cfelse>
    <cfset get_emps_project_group.recordcount = 0>
</cfif>
<!--- Projeye kayıtlı iş grubu var ise eger defult olarak kayıtlı olan employeeleri getirmek icin FA --->
<cfquery name="GET_ACTIVITY" datasource="#DSN#">
    SELECT #dsn#.Get_Dynamic_Language(ACTIVITY_ID,'#session.ep.language#','SETUP_ACTIVITY','ACTIVITY_NAME',NULL,NULL,ACTIVITY_NAME) AS ACTIVITY_NAME,ACTIVITY_ID FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
</cfquery>
<cfquery name="get_time_cost_cats" datasource="#dsn#">
    SELECT TIME_COST_CAT,TIME_COST_CAT_ID FROM TIME_COST_CAT ORDER BY TIME_COST_CAT
</cfquery>
<cfquery name="get_process_stage" datasource="#dsn#">
    SELECT
        PTR.STAGE,
        PTR.PROCESS_ROW_ID
    FROM
        PROCESS_TYPE_ROWS PTR,
        PROCESS_TYPE_OUR_COMPANY PTO,
        PROCESS_TYPE PT
    WHERE
        PT.IS_ACTIVE = 1 AND
        PT.PROCESS_ID = PTR.PROCESS_ID AND
        PT.PROCESS_ID = PTO.PROCESS_ID AND
        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hr.add_timecost_all%">
    ORDER BY
        PTR.LINE_NUMBER
</cfquery>
<cfquery name="ALL_BRANCHES" datasource="#DSN#">
    SELECT 
        BRANCH.BRANCH_NAME,
        BRANCH.BRANCH_ID,
        D.DEPARTMENT_HEAD,
        D.DEPARTMENT_ID
    FROM
        BRANCH,
        DEPARTMENT D
    WHERE
        D.BRANCH_ID = BRANCH.BRANCH_ID AND
        BRANCH.SSK_NO IS NOT NULL AND
        BRANCH.SSK_OFFICE IS NOT NULL AND
        BRANCH.SSK_BRANCH IS NOT NULL AND
        BRANCH.SSK_NO IS NOT NULL AND
        BRANCH.SSK_OFFICE IS NOT NULL AND
        BRANCH.SSK_BRANCH IS NOT NULL
        AND BRANCH.BRANCH_ID IN 
        (
            SELECT
                BRANCH_ID
            FROM
                EMPLOYEE_POSITION_BRANCHES
            WHERE
                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        )
    ORDER BY
        BRANCH.BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.department_id")>
    <cfquery name="GET_DEPARTMENT_POSITIONS" datasource="#DSN#">
        SELECT
            DISTINCT
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            E.EMPLOYEE_ID,
            EIO.IN_OUT_ID,
            D.DEPARTMENT_HEAD,
            B.BRANCH_NAME
        FROM
            EMPLOYEES_IN_OUT EIO,
            EMPLOYEES E,
            DEPARTMENT D,
            BRANCH B,
            EMPLOYEE_POSITIONS EP
        WHERE
            E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
            E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
            D.DEPARTMENT_ID = EIO.DEPARTMENT_ID AND
            D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> AND
            D.BRANCH_ID = B.BRANCH_ID AND
            EIO.FINISH_DATE IS NULL
        ORDER BY
            EMPLOYEE_NAME
    </cfquery>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_worktime" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_timecost_project_all">
            <input type="hidden" name="record_num" id="record_num" value="<cfoutput><cfif isdefined("attributes.id") and Get_Emps_Project_Group.Recordcount>#Get_Emps_Project_Group.Recordcount#<cfelse>1</cfif></cfoutput>">
            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.id")><cfoutput>#attributes.id#</cfoutput></cfif>">
            <input type="hidden" name="x_timecost_limited" id="x_timecost_limited" value="<cfif isdefined('x_timecost_limited') and x_timecost_limited eq 1>1<cfelse>0</cfif>">
            <input type="hidden" name="fusebox_circuit" id= "fusebox_circuit" value="<cfoutput>#fusebox.circuit#</cfoutput>">
            <cf_box_elements>
                <cfloop list="#ListDeleteDuplicates(xml_timecost_rows)#" index="xlr">
                    <cfswitch expression="#xlr#">
                        <cfcase value="1">
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='57572.Departman'></label>
                                <div class="col col-8 col-xs-12">    
                                    <select name="department_id" id="department_id" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="ALL_BRANCHES">
                                            <option value="#request.self#?fuseaction=hr.add_timecost_all&department_id=#department_id#<cfif isdefined('attributes.id') and len(attributes.id)>&id=#attributes.id#</cfif><cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>&finish_date=#attributes.finish_date#</cfif><cfif isdefined('attributes.result_no') and len(attributes.result_no)>&result_no=#attributes.result_no#</cfif><cfif isdefined('attributes.production_order_no') and len(attributes.production_order_no)>&production_order_no=#attributes.production_order_no#</cfif><cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>&comp_id=#attributes.comp_id#</cfif><cfif isdefined('attributes.cons_id') and len(attributes.cons_id)>&cons_id=#attributes.cons_id#</cfif><cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>&partner_id=#attributes.partner_id#</cfif>"<cfif isdefined("attributes.department_id") and (department_id eq attributes.department_id)>selected</cfif>>
                                                #branch_name# - #department_head#
                                            </option>
                                        </cfoutput>
                                    </select>
                                </div> 
                            </div>
                        </cfcase>
                        <cfcase value="2">
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57657.Ürün'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input name="product_id0" id="product_id0" type="hidden"  value="" autocomplete="off">
                                        <input name="product_name0" id="product_name0" type="text" onFocus="hepsi(row_count,'product_name');" value="" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_worktime.product_id0&field_name=add_worktime.product_name0');"></span>
                                    </div>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="3">
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="comment0" id="comment0" value="<cfif isdefined('attributes.result_no') and len(attributes.result_no)><cfoutput>#attributes.result_no#</cfoutput></cfif>" onKeyup="hepsi(row_count,'comment');">
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="4">   
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="row_kontrol_0" id="row_kontrol_0" value="1">						
                                        <input type="text" name="today0" id="today0" value="<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>" maxlength="10" onBlur="hepsi(row_count,'today');">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="today0" call_function="tarih_hepsi"></span>
                                    </div>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="5">    
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57491.Saat'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined('x_timecost_limited') and x_timecost_limited eq 0>
                                        <cfinput type="text" name="total_time_hour0" id="total_time_hour0"  maxlength="2" validate="integer" value="" onKeyup="hepsi(row_count,'total_time_hour');">
                                    <cfelse>
                                        <cfinput type="text" name="total_time_hour0" id="total_time_hour0"  validate="integer" value="" onKeyup="hepsi(row_count,'total_time_hour');">
                                    </cfif>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="6">
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58827.Dk'>.</label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="total_time_minute0" id="total_time_minute0"  maxlength="2" validate="integer" value="" onKeyup="hepsi(row_count,'total_time_minute');">
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="7">    
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58543.Mesai Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="overtime_type0" id="overtime_type0" onChange="hepsi(row_count,'overtime_type');">
                                        <option value="1"><cf_get_lang dictionary_id='32287.Normal'></option>
                                        <option value="2"><cf_get_lang dictionary_id='31547.Fazla Mesai'></option>
                                        <option value="3"><cf_get_lang dictionary_id='31472.Hafta Sonu'></option>
                                        <option value="4"><cf_get_lang dictionary_id='31473.Resmi Tatil'></option>
                                    </select>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="8">
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfoutput>
                                            <input type="hidden" name="project_id0" id="project_id0" value="<cfif isdefined('attributes.id') and Len(attributes.id)>#attributes.id#</cfif>">
                                            <input type="text" name="project0" id="project0" value="<cfif isdefined('attributes.id') and Len(attributes.id)>#get_project_name(attributes.id)#</cfif>" onfocus="hepsi(row_count,'project'); AutoComplete_Create('project0','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID,PARTNER_ID,CONSUMER_ID,COMPANY_ID,MEMBER_NAME','project_id0,partner_id0,consumer_id0,company_id0,member_name0','add_worktime','3','250');" autocomplete="off">
                                            <span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_worktime.project_id0&project_head=add_worktime.project0&company_id=add_worktime.company_id0&consumer_id=add_worktime.consumer_id0&partner_id=add_worktime.partner_id0&company_name=add_worktime.member_name0');"></span>
                                        </cfoutput>
                                    </div>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="9">
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58445.İş'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="row_kontrol_0" id="row_kontrol_0" value="1">
                                        <input type="hidden" name="work_id0" id="work_id0" value="">
                                        <input type="text" name="work_head0" id="work_head0" onFocus="hepsi(row_count,'work_head');" value="" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=add_worktime.work_id0&field_name=add_worktime.work_head0&project_id='+document.getElementById('project_id0').value+'&project_head='+document.getElementById('project0').value+'');"></span>
                                    </div>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="10">    
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32374.Aktiviteler'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="activity_type0" id="activity_type0" onchange="hepsi(row_count,'activity_type');">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_activity">
                                            <option value="#activity_id#">#activity_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="11">
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="company_id0" id="company_id0" value="<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)><cfoutput>#attributes.comp_id#</cfoutput></cfif>">
                                        <input type="hidden" name="consumer_id0" id="consumer_id0" value="<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)><cfoutput>#attributes.cons_id#</cfoutput></cfif>">
                                        <input type="hidden" name="partner_id0" id="partner_id0" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
                                        <cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
                                            <input type="text" name="member_name0" id="member_name0" onFocus="hepsi(row_count,'member_name');" value="<cfoutput>#GET_PAR_INFO(attributes.partner_id,0,1,0)#</cfoutput>" autocomplete="off">
                                        <cfelse>
                                            <input type="text" name="member_name0" id="member_name0" onFocus="hepsi(row_count,'member_name');" value="<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)><cfoutput>#GET_CONS_INFO(attributes.cons_id,0,0)#</cfoutput></cfif>" autocomplete="off">
                                        </cfif>
                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_consumer=add_worktime.consumer_id0&field_comp_id=add_worktime.company_id0&field_member_name=add_worktime.member_name0&field_partner=add_worktime.partner_id0&select_list=7,8');"></span>
                                    </div>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="12">
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif isdefined("attributes.expense_code") and len(attributes.expense_code)>
                                            <cfquery name="GET_EXPENSE" datasource="#dsn2#">
                                                SELECT
                                                    EXPENSE_ID,
                                                    EXPENSE
                                                FROM
                                                    EXPENSE_CENTER
                                                WHERE 
                                                    EXPENSE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_code#">
                                            </cfquery>
                                            <input type="hidden" name="expense_id0" id="expense_id0" onFocus="hepsi(row_count,'expense');" value="<cfoutput>#get_expense.EXPENSE_ID#</cfoutput>" autocomplete="off">
                                            <input type="text" name="expense0" id="expense0" onFocus="hepsi(row_count,'expense');" value="<cfoutput>#get_expense.EXPENSE#</cfoutput>" autocomplete="off">
                                        <cfelse>
                                            <input type="hidden" name="expense_id0" id="expense_id0" onFocus="hepsi(row_count,'expense');" value="" autocomplete="off">
                                            <input type="text" name="expense0" id="expense0" onFocus="hepsi(row_count,'expense');" value="" autocomplete="off">
                                        </cfif>
                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=add_worktime.expense_id0&field_name=add_worktime.expense0','','ui-draggable-box-small');"></span>
                                    </div>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="13">    
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="state0" id="state0" onChange="hepsi(row_count,'state');">
                                        <option value="1"><cf_get_lang dictionary_id='31491.Gerçekleşen'></option>
                                        <option value="0"><cf_get_lang dictionary_id='58869.Planlanan'></option>
                                    </select>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="14">
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="time_cost_cat0" id="time_cost_cat0" onchange="hepsi(row_count,'time_cost_cat');">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_time_cost_cats">
                                            <option value="#time_cost_cat_id#">#time_cost_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </cfcase>
                        <cfcase value="15">
                            <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="time_cost_stage0" id="time_cost_stage0" onchange="hepsi(row_count,'time_cost_stage');">
                                        <cfoutput query="get_process_stage">
                                            <option value="#process_row_id#">#stage#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </cfcase>
                    </cfswitch>
                </cfloop>   
            </cf_box_elements>
            <cf_grid_list sort="0">
                    <thead>
                        <tr style="display:none;"><td><cf_workcube_process is_upd='0' is_detail='0'></td></tr>
                        <tr>
                            <th width="20"><a href="javascript://"  onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                            <!--- Satirlardaki Veriler Degisken Olarak Geliyor --->
                            <cfloop list="#ListDeleteDuplicates(xml_timecost_rows)#" index="xlr">
                                <cfswitch expression="#xlr#">
                                    <cfcase value="1">
                                        <th><cf_get_lang dictionary_id='57576.Çalışan'>*</th>
                                        <th><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='57572.Departman'></th>
                                    </cfcase>
                                    <cfcase value="2"><th><cf_get_lang dictionary_id ='57657.Ürün'></th></cfcase>
                                    <cfcase value="3"><th><cf_get_lang dictionary_id='57629.Açıklama'>*</th></cfcase>
                                    <cfcase value="4"><th><cf_get_lang dictionary_id='57742.Tarih'>*</th></cfcase>
                                    <cfcase value="5"><th width="50"><cf_get_lang dictionary_id='57491.Saat'>*</th></cfcase>
                                    <cfcase value="6"><th width="50"><cf_get_lang dictionary_id='58827.Dk'>.</th></cfcase>
                                    <cfcase value="7"><th><cf_get_lang dictionary_id='58543.Mesai Tipi'></th></cfcase>
                                    <cfcase value="8"><th><cf_get_lang dictionary_id='57416.Proje'></th></cfcase>
                                    <cfcase value="9"><th><cf_get_lang dictionary_id='58445.İş'></th></cfcase>
                                    <cfcase value="10"><th><cf_get_lang dictionary_id='32374.Aktiviteler'></th></cfcase>
                                    <cfcase value="11"><th><cf_get_lang dictionary_id='57519.Cari Hesap'></th></cfcase>
                                    <cfcase value="12"><th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th></cfcase>
                                    <cfcase value="13"><th><cf_get_lang dictionary_id='57756.Durum'></th></cfcase>
                                    <cfcase value="14"><th><cf_get_lang dictionary_id='57486.Kategori'></th></cfcase>
                                    <cfcase value="15"><th><cf_get_lang dictionary_id='58859.Süreç'></th></cfcase>
                                    <cfcase value="16"><th><cf_get_lang dictionary_id="31750.Arge Gününe Dahil"></th></cfcase>
                                </cfswitch>
                            </cfloop>
                        </tr>
                    </thead>
                    <tbody id="link_table">
                        <cfif isdefined("attributes.department_id") and (get_department_positions.recordcount)>
                        <cfoutput query="get_department_positions">
                            <tr id="my_row_#currentrow#">
                                <td><input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1"><a onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                <cfloop list="#ListDeleteDuplicates(xml_timecost_rows)#" index="xlr">
                                    <cfswitch expression="#xlr#">
                                        <cfcase value="1">
                                            <td>
                                                <div class="form-group large">    
                                                    <div class="input-group">
                                                        <input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
                                                        <input type="text" name="employee#currentrow#" id="employee#currentrow#" value="#employee_name# #employee_surname#"  onkeyup="id_to_empty(#currentrow#);" onFocus="AutoComplete_Create('employee#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',0,0','EMPLOYEE_ID,BRANCH_DEPT','employee_id#currentrow#','add_worktime','3','250');" autocomplete="off">
                                                        <span class="input-group-addon icon-ellipsis" href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_name=add_worktime.employee#currentrow#&field_emp_id=add_worktime.employee_id#currentrow#&field_branch_and_dep=add_worktime.department#currentrow#&select_list=1');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group large">
                                                    <input type="text" name="department#currentrow#" id="department#currentrow#" readonly value="#branch_name# / #department_head#">
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="2">
                                            <td>
                                                <div class="form-group large">
                                                    <div class="input-group">
                                                        <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="" >
                                                        <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="" >
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=add_worktime.product_id#currentrow#&field_name=add_worktime.product_name#currentrow#&keyword='+encodeURIComponent(document.add_worktime.product_name#currentrow#.value));"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="3">
                                            <td>
                                                <div class="form-group large">
                                                    <input type="text" name="comment#currentrow#" id="comment#currentrow#" maxlength="300" value="<cfif isdefined('attributes.result_no') and len(attributes.result_no)><cfoutput>#attributes.result_no#</cfoutput></cfif>">
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="4">
                                            <td>
                                                <div class="form-group large">
                                                    <div class="input-group">
                                                        <cfinput type="text" name="today#currentrow#" id="today#currentrow#" value="" maxlength="10" validate="#validate_style#" message="#getLang('','Tarihi Girmelisiniz',31903)#">
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="today#currentrow#"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="5">
                                            <td>
                                            <div class="form-group">
                                                <cfif isdefined('x_timecost_limited') and x_timecost_limited eq 0>
                                                    <cfinput type="text" name="total_time_hour#currentrow#" id="total_time_hour#currentrow#" maxlength="2" validate="integer"  value="">
                                                <cfelse>
                                                    <cfinput type="text" name="total_time_hour#currentrow#" id="total_time_hour#currentrow#" validate="integer"  value="">
                                                </cfif>
                                            </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="6">
                                            <td>
                                                <div class="form-group">
                                                    <cfinput type="text" name="total_time_minute#currentrow#" id="total_time_minute#currentrow#" maxlength="2" validate="integer"  value="">
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="7">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="overtime_type#currentrow#" id="overtime_type#currentrow#">
                                                        <option value="1"><cf_get_lang dictionary_id='32287.Normal'></option>
                                                        <option value="2"><cf_get_lang dictionary_id='31547.Fazla Mesai'></option>
                                                        <option value="3"><cf_get_lang dictionary_id='31472.Hafta Sonu'></option>
                                                        <option value="4"><cf_get_lang dictionary_id='31473.Resmi Tatil'></option>
                                                    </select>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="8">
                                            <td>
                                                <div class="form-group large">
                                                    <div class="input-group">
                                                        <input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="<cfif isdefined('attributes.id') and len(attributes.id)>#attributes.id#</cfif>">
                                                        <input type="text" name="project#currentrow#" id="project#currentrow#" value="<cfif isdefined('attributes.id') and len(attributes.id)>#get_project_name(attributes.id)#</cfif>" onfocus="AutoComplete_Create('project#currentrow#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID,PARTNER_ID,CONSUMER_ID,COMPANY_ID,MEMBER_NAME','project_id#currentrow#,partner_id#currentrow#,consumer_id#currentrow#,company_id#currentrow#,member_name#currentrow#','add_worktime','3','250');" autocomplete="off">
                                                        <span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="pencere_ac_project('#currentrow#');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="9">
                                            <td nowrap>
                                                <div class="form-group large">
                                                    <div class="input-group">
                                                        <input type="hidden" name="work_id#currentrow#" id="work_id#currentrow#" value="">
                                                        <input type="text" name="work_head#currentrow#" id="work_head#currentrow#" value="">
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_work('#currentrow#');"></span>
                                                    </div>                                                   
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="10">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="activity_type#currentrow#" id="activity_type#currentrow#">
                                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfloop query="get_activity">
                                                            <option value="#activity_id#">#activity_name#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="11">
                                            <td nowrap="nowrap">
                                                <div class="form-group large">
                                                    <div class="input-group">
                                                        <input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)>#attributes.cons_id#</cfif>">
                                                        <input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#</cfif>">
                                                        <input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>#attributes.comp_id#</cfif>">
                                                        <cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
                                                            <input type="text" name="member_name#currentrow#" id="member_name#currentrow#" onFocus="hepsi(row_count,'member_name');" value="#GET_PAR_INFO(attributes.partner_id,0,1,0)#" autocomplete="off">
                                                        <cfelse>
                                                            <input type="text" name="member_name#currentrow#" id="member_name#currentrow#" onFocus="hepsi(row_count,'member_name');" value="<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)>#GET_CONS_INFO(attributes.cons_id,0,0)#</cfif>" autocomplete="off">
                                                        </cfif>
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_consumer=add_worktime.consumer_id&field_comp_id=add_worktime.company_id&field_member_name=add_worktime.member_name&field_partner=add_worktime.partner_id');"></span>
                                                    </div>                                                   
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="12">
                                            <td nowrap>
                                            <div class="form-group large">
                                                <div class="input-group">
                                                    <cfif isdefined("attributes.expense_id") and  len(expense_id)>
                                                        <cfquery name="GET_EXPENSE" datasource="#dsn2#">
                                                            SELECT
                                                                EXPENSE_ID,
                                                                EXPENSE
                                                            FROM
                                                                EXPENSE_CENTER
                                                            WHERE 
                                                                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_id#">
                                                        </cfquery>
                                                        <input type="hidden" name="expense_id#currentrow#" id="expense_id#currentrow#" value="#GET_EXPENSE.EXPENSE_ID#">
                                                        <input type="text" name="expense#currentrow#" id="expense#currentrow#" value="#GET_EXPENSE.EXPENSE#">
                                                    <cfelse>
                                                        <input type="hidden" name="expense_id#currentrow#" id="expense_id#currentrow#" value="">
                                                        <input type="text" name="expense#currentrow#" id="expense#currentrow#" value="">
                                                    </cfif>
                                                    <span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="pencere_ac_expense('#currentrow#');"></span>
                                                </div>                                               
                                            </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="13">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="state#currentrow#" id="state#currentrow#">
                                                        <option value="1"><cf_get_lang dictionary_id='31491.Gerçekleşen'></option>
                                                        <option value="0"><cf_get_lang dictionary_id='58869.Planlanan'></option>
                                                    </select>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="14">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="time_cost_cat#currentrow#" id="time_cost_cat#currentrow#">
                                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfloop query="get_time_cost_cats">
                                                            <option value="#time_cost_cat_id#">#time_cost_cat#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="15">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="time_cost_stage#currentrow#" id="time_cost_sage#currentrow#">
                                                        <cfloop query="get_process_stage">
                                                            <option value="#process_row_id#">#stage#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="16">
                                            <td>
                                                <div class="form-group">
                                                    <select name="is_rd_ssk#currentrow#" id="is_rd_ssk#currentrow#" >
                                                        <option value="0"><cf_get_lang dictionary_id = "57496.Hayır" ></option>
                                                        <option value="1"><cf_get_lang dictionary_id = "57495.Evet"></option>
                                                    </select>
                                                </div>
                                            </td>
                                        </cfcase>
                                    </cfswitch>
                                </cfloop>
                            </tr>
                        </cfoutput>
                        <cfelseif not isdefined("attributes.department_id") and get_emps_project_group.recordcount>
                            <cfoutput query="get_emps_project_group">
                                <tr id="my_row_#currentrow#">
                                    <td><input type="hidden" value="#currentrow#" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#"><a onclick="sil(#currentrow#);" ><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                    <cfloop list="#ListDeleteDuplicates(xml_timecost_rows)#" index="xlr">
                                        <cfswitch expression="#xlr#">
                                            <cfcase value="1">
                                                <td nowrap="nowrap">
                                                    <div class="form-group large"> 
                                                        <div class="input-group">
                                                            <input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
                                                            <input type="text" name="employee#currentrow#" id="employee#currentrow#" value="#employee_name# #employee_surname#" onkeyup="id_to_empty(#currentrow#);" onFocus="AutoComplete_Create('employee#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',0,0','EMPLOYEE_ID,BRANCH_DEPT','employee_id#currentrow#,department#currentrow#','add_worktime','3','250');" autocomplete="off">
                                                            <span class="input-group-addon icon-ellipsis" href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_worktime.employee_id#currentrow#&field_name=add_worktime.employee#currentrow#&field_branch_and_dep=add_worktime.department#currentrow#&select_list=1');"></span>
                                                        </div>
                                                    </div>    
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="text" name="department#currentrow#" id="department#currentrow#" readonly value="">
                                                    </div>
                                                </td>  
                                            </cfcase>
                                            <cfcase value="2">
                                            <td nowrap>
                                                <div class="form-group large"> 
                                                    <div class="input-group">
                                                        <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                                                        <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#product_name#">
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=add_worktime.product_id#currentrow#&field_name=add_worktime.product_name#currentrow#&keyword='+encodeURIComponent(document.add_worktime.product_name#currentrow#.value));"></span>
                                                    </div>
                                                </div>     
                                            </td>
                                            </cfcase>
                                            <cfcase value="3">
                                            <td>
                                                <div class="form-group large"> 
                                                    <input type="text" name="comment#currentrow#" id="comment#currentrow#" maxlength="300" value="<cfif isdefined('attributes.result_no') and len(attributes.result_no)>#attributes.result_no#<cfelse>#comment#</cfif>">
                                                </div>        
                                            </td>
                                            </cfcase>
                                            <cfcase value="4">
                                            <td nowrap="nowrap">
                                                <div class="form-group large"> 
                                                    <div class="input-group">    						
                                                        <input type="text" name="today#currentrow#" id="today#currentrow#" value="<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>#dateformat(attributes.finish_date,dateformat_style)#<cfelse>#dateformat(event_date,dateformat_style)#</cfif>" maxlength="10">
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="today#currentrow#"></span>
                                                    </div>
                                                </div>    
                                            </td>
                                            </cfcase>
                                            <cfcase value="5">
                                            <td>
                                                <div class="form-group"> 
                                                    <cfset liste=expensed_minute/60>
                                                    <cfset saat=listfirst(liste,'.')>
                                                    <cfset dak=expensed_minute-saat*60>
                                                    <cfif isdefined('x_timecost_limited') and x_timecost_limited eq 0>
                                                        <cfinput type="text" name="total_time_hour#currentrow#" id="total_time_hour#currentrow#" maxlength="2" validate="integer"  value="#saat#">
                                                    <cfelse>
                                                        <cfinput type="text" name="total_time_hour#currentrow#" id="total_time_hour#currentrow#" validate="integer"  value="#saat#">
                                                    </cfif>
                                                </div>
                                            </td>
                                            </cfcase>
                                            <cfcase value="6">
                                            <td>
                                                <div class="form-group"> 
                                                    <cfinput type="text" name="total_time_minute#currentrow#" id="total_time_minute#currentrow#" maxlength="2" validate="integer"  value="#dak#">
                                                </div>
                                            </td>
                                            </cfcase>
                                            <cfcase value="7">
                                            <td>
                                                <div class="form-group large"> 
                                                    <select name="overtime_type#currentrow#" id="overtime_type#currentrow#">
                                                        <option value="1" <cfif get_emps_project_group.overtime_type eq 1>selected</cfif>><cf_get_lang dictionary_id='32287.Normal'></option>
                                                        <option value="2" <cfif get_emps_project_group.overtime_type eq 2>selected</cfif>><cf_get_lang dictionary_id='31547.Fazla Mesai'></option>
                                                        <option value="3" <cfif get_emps_project_group.overtime_type eq 3>selected</cfif>><cf_get_lang dictionary_id='31472.Hafta Sonu'></option>
                                                        <option value="4" <cfif get_emps_project_group.overtime_type eq 4>selected</cfif>><cf_get_lang dictionary_id='31473.Resmi Tatil'></option>
                                                    </select>
                                                </div>       
                                            </td>
                                            </cfcase>
                                            <cfcase value="8">
                                            <td nowrap="nowrap">
                                                <div class="form-group large"> 
                                                    <div class="input-group">    
                                                        <input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="<cfif isdefined('attributes.id') and len(attributes.id)>#attributes.id#</cfif>">
                                                        <cfif isdefined('attributes.id') and len(attributes.id)>
                                                            <cfquery name="GET_PROJECT" datasource="#dsn#">
                                                                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                                                            </cfquery>
                                                            <input type="text" name="project#currentrow#" id="project#currentrow#" value="#get_project.project_head#" onfocus="AutoComplete_Create('project#currentrow#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID,PARTNER_ID,CONSUMER_ID,COMPANY_ID,MEMBER_NAME','project_id#currentrow#,partner_id#currentrow#,consumer_id#currentrow#,company_id#currentrow#,member_name#currentrow#','add_worktime','3','250');">
                                                        <cfelse>
                                                            <input type="text" name="project#currentrow#" id="project#currentrow#" value="" onfocus="AutoComplete_Create('project#currentrow#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID,PARTNER_ID,CONSUMER_ID,COMPANY_ID,MEMBER_NAME','project_id#currentrow#,partner_id#currentrow#,consumer_id#currentrow#,company_id#currentrow#,member_name#currentrow#','add_worktime','3','250');">
                                                        </cfif>
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_project('#currentrow#');"></span>
                                                        <!---  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_worktime.project_id#currentrow#&project_head=add_worktime.project#currentrow#&company_id=add_worktime.company_id#currentrow#&consumer_id=add_worktime.consumer_id#currentrow#&company_name=add_worktime.member_name#currentrow#','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a> --->
                                                    </div>
                                                </div>    
                                            </td>
                                            </cfcase>
                                            <cfcase value="9">
                                            <td nowrap>
                                                <div class="form-group large"> 
                                                    <div class="input-group">    
                                                        <input type="hidden" name="work_id#currentrow#" id="work_id#currentrow#" value="#work_id#">
                                                        <input type="text" name="work_head#currentrow#" id="work_head#currentrow#" value="#work_head#">
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_work('#currentrow#');"></span>
                                                        <!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_work&field_id=add_worktime.work_id#currentrow#&field_name=add_worktime.work_head#currentrow#&comp_id=add_worktime.company_id#currentrow#&comp_name=add_worktime.member_name#currentrow#&project_id='+eval("document.getElementById('project_id3')").value+'&project_head='+eval("document.getElementById('project_head3')").value+'','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a> --->
                                                    </div>
                                                </div>    
                                            </td>
                                            </cfcase>
                                            <cfcase value="10">
                                            <td>
                                                <div class="form-group large">        
                                                    <select name="activity_type#currentrow#" id="activity_type#currentrow#">
                                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfloop query="get_activity">
                                                            <option value="#activity_id#" <cfif get_emps_project_group.activity_id eq activity_id>selected="selected"</cfif>>#activity_name#</option>
                                                        </cfloop>
                                                    </select>
                                                </div> 
                                            </td>
                                            </cfcase>
                                            <cfcase value="11">
                                            <td nowrap="nowrap">
                                                <div class="form-group large"> 
                                                    <div class="input-group">    
                                                        <input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)>#attributes.cons_id#</cfif>">
                                                        <input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#</cfif>">
                                                        <input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>#attributes.comp_id#</cfif>">
                                                        <cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
                                                            <input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#GET_PAR_INFO(attributes.partner_id,0,1,0)#">
                                                        <cfelse>
                                                            <input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)>#GET_CONS_INFO(attributes.cons_id,0,0)#</cfif>">
                                                        </cfif>
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_consumer=add_worktime.consumer_id1&field_comp_id=add_worktime.company_id1&field_member_name=add_worktime.member_name1&field_partner=add_worktime.partner_id1');"></span>
                                                    </div>
                                                </div>       
                                            </td>
                                            </cfcase>
                                            <cfcase value="12">
                                            <td nowrap>
                                                <div class="form-group large"> 
                                                    <div class="input-group">        
                                                        <cfif isdefined("attributes.expense_code") and len(attributes.expense_code)>
                                                            <input type="hidden" name="expense_id#currentrow#" id="expense_id#currentrow#" value="#GET_EXPENSE.EXPENSE_ID#">
                                                            <input type="text" name="expense#currentrow#" id="expense#currentrow#" value="#GET_EXPENSE.EXPENSE#">
                                                        <cfelse>
                                                            <input type="hidden" name="expense_id#currentrow#" id="expense_id#currentrow#" value="">
                                                            <input type="text" name="expense#currentrow#" id="expense#currentrow#" value="">
                                                        </cfif>
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_expense_center&field_id=add_worktime.expense_id#currentrow#&field_name=add_worktime.expense#currentrow#','','ui-draggable-box-small');"></span>
                                                    </div>
                                                </div>    
                                            </td>
                                            </cfcase>
                                            <cfcase value="13">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="state#currentrow#" id="state#currentrow#">
                                                        <option value="1" <cfif state eq 1>selected</cfif>><cf_get_lang dictionary_id='31491.Gerçekleşen'></option>
                                                        <option value="0" <cfif state eq 2>selected</cfif>><cf_get_lang dictionary_id='58869.Planlanan'></option>
                                                    </select>
                                                </div>
                                            </td>
                                            </cfcase>
                                            <cfcase value="14">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="time_cost_cat#currentrow#" id="time_cost_cat#currentrow#">
                                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfloop query="get_time_cost_cats">
                                                            <option value="#time_cost_cat_id#" <cfif get_emps_project_group.time_cost_cat_id eq time_cost_cat_id>selected="selected"</cfif>>#time_cost_cat#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>    
                                            </td>
                                            </cfcase>
                                            <cfcase value="15">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="time_cost_stage#currentrow#" id="time_cost_stage#currentrow#">
                                                        <cfloop query="get_process_stage">
                                                            <option value="#process_row_id#" <cfif isdefined("get_emps_project_group.time_cost_stage") and get_emps_project_group.time_cost_stage eq process_row_id>selected="selected"</cfif>>#stage#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </td>
                                            </cfcase>
                                            <cfcase value="16">
                                                <td>
                                                    <div class="form-group">
                                                        <select name="is_rd_ssk#currentrow#" id="is_rd_ssk#currentrow#" >
                                                            <option value="0" <cfif get_emps_project_group.is_rd_ssk eq 0>selected</cfif>><cf_get_lang dictionary_id = "57496.Hayır" ></option>
                                                            <option value="1" <cfif get_emps_project_group.is_rd_ssk eq 1>selected</cfif>><cf_get_lang dictionary_id = "57495.Evet"></option>
                                                        </select>
                                                    </div>
                                                </td>
                                            </cfcase>
                                        </cfswitch>
                                    </cfloop>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr id="my_row_1">
                                <td><input type="hidden" name="row_kontrol_1" id="row_kontrol_1"  value="1"><a onclick="sil(1);" ><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                <cfloop list="#ListDeleteDuplicates(xml_timecost_rows)#" index="xlr">
                                    <cfswitch expression="#xlr#">
                                        <cfcase value="1">
                                            <td nowrap>
                                                <div class="form-group large"> 
                                                    <div class="input-group">
                                                        <input type="hidden" name="employee_id1" id="employee_id1" value="">
                                                        <input type="text" name="employee1" id="employee1" onkeyup="id_to_empty(1);" onFocus="AutoComplete_Create('employee1','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',0,0','EMPLOYEE_ID,BRANCH_DEPT','employee_id1,department1','add_worktime','3','250');" autocomplete="off">
                                                            <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_worktime.employee_id1&field_name=add_worktime.employee1&field_branch_and_dep=add_worktime.department1&select_list=1');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group"> 
                                                    <input type="text" name="department1" id="department1" readonly value="">
                                                </div>    
                                            </td>
                                        </cfcase>
                                        <cfcase value="2">
                                            <td nowrap>
                                                <div class="form-group large"> 
                                                    <div class="input-group">
                                                        <input type="hidden" name="product_id1" id="product_id1" value="">
                                                        <input type="text" name="product_name1" id="product_name1" value="">
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_worktime.product_id1&field_name=add_worktime.product_name1&keyword='+encodeURIComponent(document.add_worktime.product_name1.value));"></span>
                                                    </div>
                                                </div>    
                                            </td>
                                        </cfcase>
                                        <cfcase value="3">
                                            <td>
                                                <div class="form-group large"> 
                                                    <input type="text" name="comment1" id="comment1" maxlength="300" value="<cfif isdefined('attributes.result_no') and len(attributes.result_no)><cfoutput>#attributes.result_no#</cfoutput></cfif>">
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="4">
                                            <td nowrap="nowrap">
                                                <div class="form-group large">
                                                    <div class="input-group">
                                                        <input type="text" name="today1" id="today1" value="<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>" maxlength="10">
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="today1"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="5">
                                            <td>
                                                <div class="form-group">
                                                    <cfif isdefined('x_timecost_limited') and x_timecost_limited eq 0>
                                                        <cfinput type="text" name="total_time_hour1" id="total_time_hour1" maxlength="2" validate="integer"  value="">
                                                    <cfelse>
                                                        <cfinput type="text" name="total_time_hour1" id="total_time_hour1" validate="integer"  value="">
                                                    </cfif>
                                                </div>    
                                            </td>
                                        </cfcase>
                                        <cfcase value="6">
                                            <td>
                                                <div class="form-group">
                                                    <cfinput type="text" name="total_time_minute1" id="total_time_minute1" maxlength="2" validate="integer"  value="">
                                                </div>    
                                            </td>
                                        </cfcase>
                                        <cfcase value="7">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="overtime_type1" id="overtime_type1">
                                                        <option value="1"><cf_get_lang dictionary_id='32287.Normal'></option>
                                                        <option value="2"><cf_get_lang dictionary_id='31547.Fazla Mesai'></option>
                                                        <option value="3"><cf_get_lang dictionary_id='31472.Hafta Sonu'></option>
                                                        <option value="4"><cf_get_lang dictionary_id='31473.Resmi Tatil'></option>
                                                    </select> 
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="8">
                                            <td nowrap="nowrap">
                                                <div class="form-group large">
                                                    <div class="input-group">
                                                        <input type="hidden" name="project_id1" id="project_id1" value="<cfif isdefined('attributes.id') and len(attributes.id)><cfoutput>#attributes.id#</cfoutput></cfif>">
                                                        <cfif isdefined('attributes.id') and len(attributes.id)>
                                                            <cfquery name="GET_PROJECT" datasource="#dsn#">
                                                                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                                                            </cfquery>
                                                            <input type="text" name="project1" id="project1" value="<cfoutput>#get_project.project_head#</cfoutput>" onfocus="AutoComplete_Create('project1','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID,PARTNER_ID,CONSUMER_ID,COMPANY_ID,MEMBER_NAME','project_id1,partner_id1,consumer_id1,company_id1,member_name1','add_worktime','3','250');" autocomplete="off">
                                                        <cfelse>
                                                            <input type="text" name="project1" id="project1" value="" onfocus="AutoComplete_Create('project1','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID,PARTNER_ID,CONSUMER_ID,COMPANY_ID,MEMBER_NAME','project_id1,partner_id1,consumer_id1,company_id1,member_name1','add_worktime','3','250');" autocomplete="off">
                                                        </cfif>
                                                        <span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_worktime.project_id1&project_head=add_worktime.project1&company_id=add_worktime.company_id1&consumer_id=add_worktime.consumer_id1&company_name=add_worktime.member_name1&partner_id=add_worktime.partner_id1');"></span>
                                                    </div>
                                                </div>    
                                            </td>
                                        </cfcase>
                                        <cfcase value="9">
                                            <td nowrap> 
                                                <div class="form-group large">
                                                    <div class="input-group">
                                                        <input type="hidden" name="work_id1" id="work_id1" value="">
                                                        <input type="text" name="work_head1" id="work_head1" value="">
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=add_worktime.work_id1&field_name=add_worktime.work_head1&comp_id=add_worktime.company_id1&comp_name=add_worktime.member_name1&project_id='+document.getElementById('project_id1').value+'&project_head='+document.getElementById('project1').value+'');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="10">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="activity_type1" id="activity_type1">
                                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfoutput query="get_activity">
                                                            <option value="#activity_id#">#activity_name#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>    
                                            </td>
                                        </cfcase>
                                        <cfcase value="11">
                                            <td nowrap="nowrap">
                                                <div class="form-group large">
                                                    <div class="input-group">
                                                        <input type="hidden" name="consumer_id1" id="consumer_id1" value="<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)><cfoutput>#attributes.cons_id#</cfoutput></cfif>">
                                                        <input type="hidden" name="partner_id1" id="partner_id1" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
                                                        <input type="hidden" name="company_id1" id="company_id1" value="<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)><cfoutput>#attributes.comp_id#</cfoutput></cfif>">
                                                        <cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
                                                            <input type="text" name="member_name1" id="member_name1" value="<cfoutput>#GET_PAR_INFO(attributes.partner_id,0,1,0)#</cfoutput>">
                                                        <cfelse>
                                                            <input type="text" name="member_name1" id="member_name1" value="<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)><cfoutput>#GET_CONS_INFO(attributes.cons_id,0,0)#</cfoutput></cfif>">
                                                        </cfif>
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_consumer=add_worktime.consumer_id1&field_comp_id=add_worktime.company_id1&field_member_name=add_worktime.member_name1&field_partner=add_worktime.partner_id1');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfcase>
                                        <cfcase value="12">
                                            <td nowrap>
                                                <div class="form-group large">
                                                    <div class="input-group">
                                                        <cfif isdefined("attributes.expense_code") and len(attributes.expense_code)>
                                                            <input type="hidden" name="expense_id1" id="expense_id1" value="<cfoutput>#GET_EXPENSE.EXPENSE_ID#</cfoutput>">
                                                            <input type="text" name="expense1" id="expense1" value="<cfoutput>#GET_EXPENSE.EXPENSE#</cfoutput>">
                                                        <cfelse>
                                                            <input type="hidden" name="expense_id1" id="expense_id1" value="">
                                                            <input type="text" name="expense1" id="expense1" value="">
                                                        </cfif>
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=add_worktime.expense_id1&field_name=add_worktime.expense1','','ui-draggable-box-small');"></span>
                                                    </div>
                                                </div> 
                                            </td>
                                        </cfcase>
                                        <cfcase value="13">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="state1" id="state1">
                                                        <option value="1"><cf_get_lang dictionary_id='31491.Gerçekleşen'></option>
                                                        <option value="0"><cf_get_lang dictionary_id='58869.Planlanan'></option>
                                                    </select>
                                                </div>    
                                            </td>
                                        </cfcase>
                                        <cfcase value="14">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="time_cost_cat1" id="time_cost_cat1">
                                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfoutput query="get_time_cost_cats">
                                                            <option value="#time_cost_cat_id#">#time_cost_cat#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>    
                                            </td>
                                        </cfcase>
                                        <cfcase value="15">
                                            <td>
                                                <div class="form-group large">
                                                    <select name="time_cost_stage1" id="time_cost_stage1">
                                                        <cfoutput query="get_process_stage">
                                                            <option value="#process_row_id#">#stage#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>    
                                            </td>
                                        </cfcase>
                                        <cfcase value="16">
                                            <td>
                                                <div class="form-group">
                                                    <select name="is_rd_ssk1" id="is_rd_ssk1" >
                                                        <option value="0"><cf_get_lang dictionary_id = "57496.Hayır" ></option>
                                                        <option value="1"><cf_get_lang dictionary_id = "57495.Evet"></option>
                                                    </select>
                                                </div>
                                            </td>
                                        </cfcase>
                                    </cfswitch>
                                </cfloop>
                            </tr>
                        </cfif>
                    </tbody>
            </cf_grid_list>
            <cf_box_footer>
                <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    <cfif isdefined("get_department_positions") and get_department_positions.recordcount>
        row_count = <cfoutput>#get_department_positions.recordcount#</cfoutput>;
    <cfelseif not isdefined("attributes.department_id") and get_emps_project_group.recordcount>
        row_count = <cfoutput>#get_emps_project_group.recordcount#</cfoutput>;
    <cfelse>
        row_count=1;
    </cfif>
    function tarih_hepsi()
    {
        hepsi(row_count,'today');	
    }
    function hepsi(satir,nesne)
    {
        deger=eval("document.add_worktime."+nesne+"0");
        for(var i=1;i<=satir;i++)
        { 
            nesne_=eval("document.add_worktime."+nesne+i);
            nesne_.value=deger.value;
        }
        if(nesne=='work_head')
        {
            hepsi(row_count,'work_id');
        }
        
        if(nesne=='project')
        {
            hepsi(row_count,'project_id');
        }
            
        if(nesne=='member_name')
        {
            hepsi(row_count,'company_id');
            hepsi(row_count,'consumer_id');
            hepsi(row_count,'partner_id');
        }
        if(nesne=='expense')
        {
            hepsi(row_count,'expense_id');
        }
        if(nesne=='p_order_result')
        {
            hepsi(row_count,'p_order_result_id');
        }
        if(nesne=='product_name')
        {
            hepsi(row_count,'product_id');
        }
        if(nesne=='overtime_type')
        {
            for(var a=1;a<=satir;a++)
            {eval("document.add_worktime."+nesne+a).value = deger=eval("document.add_worktime."+nesne+"0").value;}
        }
        if(nesne=='activity_type')
        {
            for(var b=1;b<=satir;b++)
            {eval("document.add_worktime."+nesne+b).value = deger=eval("document.add_worktime."+nesne+"0").value;}
        }
        if(nesne=='state')
        {
            for(var c=1;c<=satir;c++)
            {eval("document.add_worktime."+nesne+c).value = deger=eval("document.add_worktime."+nesne+"0").value;}
        }
        if(nesne=='time_cost_cat')
        {
            for(var d=1;d<=satir;d++)
            {eval("document.add_worktime."+nesne+d).value = deger=eval("document.add_worktime."+nesne+"0").value;}
        }
        if(nesne=='time_cost_stage')
        {
            for(var e=1;e<=satir;e++)
            {eval("document.add_worktime."+nesne+e).value = deger=eval("document.add_worktime."+nesne+"0").value;}
        }
    }
    function sil(sy)
    {
        var my_element=eval("add_worktime.row_kontrol_"+sy);
        my_element.value=0;
        var my_element=eval("my_row_"+sy);
        my_element.style.display="none";
    }	
    function add_row()
    { 
        var product_id0_ = '';
        var product_name0_ = '';
        var p_order_result0_ = '';
        var p_order_result_id0_ = '';
        var comment0_ = '';
        var today0_ = '';
        var total_time_hour0_ = '';
        var total_time_minute0_ = '';
        var overtime_type0_ = '';
        var project_id0_ = '';
        var project0_ = '';
        var work_id0_ = '';
        var work_head0_ = '';
        var activity_type0_ = '';
        var company_id0_ = '';
        var consumer_id0_ = '';
        var partner_id0_ = '';
        var member_name0_ = '';
        var expense_id0_ = '';
        var expense0_ = '';
        var state0_ = '';
        var time_cost_cat0_ = '';
        var time_cost_stage0_ = '';
        if(document.add_worktime.product_name0 != undefined && document.add_worktime.product_name0.value != '')
        {
            var product_id0_ = document.add_worktime.product_id0.value;
            var product_name0_ = document.add_worktime.product_name0.value;
        }
        if(document.add_worktime.comment0 != undefined && document.add_worktime.comment0.value != '')
            var comment0_ = document.add_worktime.comment0.value;
        if(document.add_worktime.today0.value != '')
            var today0_ = document.add_worktime.today0.value;
        if(document.add_worktime.total_time_hour0.value != '')
            var total_time_hour0_ = document.add_worktime.total_time_hour0.value;
        if(document.add_worktime.total_time_minute0.value != '')
            var total_time_minute0_ = document.add_worktime.total_time_minute0.value;
        if(document.add_worktime.overtime_type0 != undefined && document.add_worktime.overtime_type0.value != '')//fazla mesai
            var overtime_type0_ = document.add_worktime.overtime_type0.value;
        if(document.add_worktime.project_id0 != undefined && document.add_worktime.project_id0.value != '')
        {
            var project_id0_ = document.add_worktime.project_id0.value;
            var project0_ = document.add_worktime.project0.value;
        }
        if(document.add_worktime.work_id0 != undefined && document.add_worktime.work_id0.value != '')
        {
            var work_id0_ = document.add_worktime.work_id0.value;
            var work_head0_ = document.add_worktime.work_head0.value;
        }
        if(document.add_worktime.activity_type0 != undefined && document.add_worktime.activity_type0.value != '')//aktivite
            var activity_type0_ = document.add_worktime.activity_type0.value;	
        if(document.add_worktime.member_name0 != undefined && document.add_worktime.member_name0.value != '')
        {
            var company_id0_ = document.add_worktime.company_id0.value;
            var consumer_id0_ = document.add_worktime.consumer_id0.value;
            var partner_id0_ = document.add_worktime.partner_id0.value;
            var member_name0_ = document.add_worktime.member_name0.value;
        }
        if(document.add_worktime.expense_id0 != undefined && document.add_worktime.expense_id0.value != '')
        {
            var expense_id0_ = document.add_worktime.expense_id0.value;
            var expense0_ = document.add_worktime.expense0.value;
        }
        if(document.add_worktime.state0 != undefined && document.add_worktime.state0.value != '')//plan-gerceklesen
            var state0_ = document.add_worktime.state0.value;
        if(document.add_worktime.time_cost_cat0 != undefined && document.add_worktime.time_cost_cat0.value != '')//kategori
            var time_cost_cat0_ = document.add_worktime.time_cost_cat0.value;
        if(document.add_worktime.time_cost_stage0 != undefined && document.add_worktime.time_cost_stage0.value != '')//surec
            var time_cost_stage0_ = document.add_worktime.time_cost_stage0.value;	
        
        row_count++;
        var newRow;
        var newCell;
        
        newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
        newRow.setAttribute("name","my_row_" + row_count);
        newRow.setAttribute("id","my_row_" + row_count);		
        newRow.setAttribute("NAME","my_row_" + row_count);
        newRow.setAttribute("ID","my_row_" + row_count);		
                    
        document.add_worktime.record_num.value=row_count;
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';	
        <cfloop list="#ListDeleteDuplicates(xml_timecost_rows)#" index="xlr">
            <cfswitch expression="#xlr#">
                <cfcase value="1">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute("nowrap","nowrap");
                    newCell.innerHTML = '<div class="form-group large"><div class="input-group"><input  type="hidden" value="" name="employee_id' + row_count +'" id="employee_id' + row_count +'"><input type="text" onKeyup="id_to_empty(' + row_count + ');" name="employee' + row_count +'" id="employee' + row_count +'" value="" onFocus="AutoComplete_Create(\'employee'+ row_count +'\',\'MEMBER_NAME\',\'MEMBER_PARTNER_NAME3\',\'get_member_autocomplete\',\'3\',\'EMPLOYEE_ID,BRANCH_DEPT\',\'employee_id' + row_count +',department' + row_count +'\',\'add_worktime\',3,116);"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable(\'<cfoutput>#request.self#?fuseaction=objects.popup_list_positions</cfoutput>&field_name=add_worktime.employee'+ row_count + '&field_emp_id=add_worktime.employee_id'+ row_count + '&field_branch_and_dep=add_worktime.department'+ row_count + '&select_list=1\');"></span></div></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.innerHTML = '<div class="form-group"><input name="department'+row_count+'" id="department'+row_count+'" type="text" readonly value=""></div>';
                </cfcase>
                <cfcase value="2">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group large"><div class="input-group"><input name="product_id'+row_count+'" id="product_id'+row_count+'" type="hidden" readonly value="'+product_id0_+'"><input name="product_name'+row_count+'" id="product_name'+row_count+'" type="text" readonly value="'+product_name0_+'"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable(\'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_worktime.product_id'+ row_count +'&field_name=add_worktime.product_name'+ row_count + '\');"></span></div></div>';
                </cfcase>
                <cfcase value="3">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group large"><input type="text" name="comment' + row_count +'" id="comment' + row_count +'" maxlength="300" value="'+comment0_+'"></div>';
                </cfcase>
                <cfcase value="4">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.setAttribute("id","today" + row_count + "_td");
                    newCell.innerHTML = '<div class="form-group large"><div class="input-group"><input  type="hidden" value="1" name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'"><input type="text" name="today' + row_count +'" id="today' + row_count +'" class="text" maxlength="10" value="'+today0_+'"><span class="input-group-addon" id="edate_'+row_count+'"></span></div></div>';
                    wrk_date_image('today' + row_count);
                    $('#edate_'+row_count).append($('#today'+row_count+'_image'));
                </cfcase>
                <cfcase value="5">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="total_time_hour' + row_count +'" id="total_time_hour' + row_count +'" value="'+total_time_hour0_+'" <cfif isdefined('x_timecost_limited') and x_timecost_limited eq 0>maxlength="2"</cfif> validate="integer"  onKeyup="return(FormatCurrency(this,event,0));">';
                </cfcase>
                <cfcase value="6">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><input type="text" name="total_time_minute' + row_count +'" id="total_time_minute' + row_count +'" value="'+total_time_minute0_+'" maxlength="2" validate="integer"  range="0,59" onKeyup="return(FormatCurrency(this,event,0));"></div>';
                </cfcase>
                <cfcase value="7">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    c = '<div class="form-group large"><select name="overtime_type' + row_count +'" id="overtime_type' + row_count +'">';
                    if(1 == overtime_type0_) c += '<option value="1" selected>Normal</option>'; else c += '<option value="1">Normal</option>';
                    if(2 == overtime_type0_) c += '<option value="2" selected><cf_get_lang dictionary_id="31547.Fazla Mesai"></option>'; else c += '<option value="2"><cf_get_lang dictionary_id="31547.Fazla Mesai"></option>';
                    if(3 == overtime_type0_) c += '<option value="3" selected><cf_get_lang dictionary_id="31472.Hafta Sonu"></option>'; else c += '<option value="3"><cf_get_lang dictionary_id="31472.Hafta Sonu"></option>';
                    if(4 == overtime_type0_) c += '<option value="4" selected><cf_get_lang dictionary_id="31473.Resmi Tatil"></option>'; else c += '<option value="4"><cf_get_lang dictionary_id="31473.Resmi Tatil"></option>';
                    newCell.innerHTML =c+ '</select></div>';
                </cfcase>
                <cfcase value="8">
                    newCell = newRow.insertCell(newRow.cells.length);

                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+project_id0_+'"><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="'+project0_+'" onfocus="AutoComplete_Create(\'project'+row_count+'\',\'PROJECT_HEAD\',\'PROJECT_HEAD\',\'get_project\',\'\',\'PROJECT_ID,PARTNER_ID,CONSUMER_ID,COMPANY_ID,MEMBER_NAME\',\'project_id'+row_count+',partner_id'+row_count+',consumer_id'+row_count+',company_id'+row_count+',member_name'+row_count+'\',\'add_worktime\',\'3\',\'250\');"><span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="pencere_ac_project('+ row_count +');"></span></div></div>';
                </cfcase>
                <cfcase value="9">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="work_id' + row_count +'" id="work_id' + row_count +'" value="'+work_id0_+'"><input type="text" name="work_head' + row_count +'" id="work_head' + row_count +'" value="'+work_head0_+'"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_work('+ row_count +');"></span></div></div>';
                </cfcase>
                <cfcase value="10">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute("nowrap","nowrap");
                    c = '<div class="form-group large"><select name="activity_type' + row_count + '"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
                    <cfoutput query="get_activity">
                    if('#activity_id#' == activity_type0_)
                        c += '<option value="#activity_id#" selected>#activity_name#</option>';
                    else
                        c += '<option value="#activity_id#">#activity_name#</option>';
                    </cfoutput>
                    newCell.innerHTML =c+ '</select></div>';
                </cfcase>
                <cfcase value="11">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="'+consumer_id0_+'"><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="'+partner_id0_+'"><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="'+company_id0_+'"><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="'+member_name0_+'"><span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="pencere_ac_company('+ row_count +');"></span></div></div>';
                </cfcase>
                <cfcase value="12">
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="expense_id' + row_count +'" id="expense_id' + row_count +'" value="'+expense_id0_+'"><input type="text" name="expense' + row_count +'" id="expense' + row_count +'" value="'+expense0_+'"><span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="pencere_ac_expense('+ row_count +');"></span></div></div>';
                </cfcase>
                <cfcase value="13">
                    newCell = newRow.insertCell(newRow.cells.length);
                    c = '<div class="form-group large"><select name="state' + row_count + '">';
                    if(state0_ == 1) c = c + '<option value="1" selected><cf_get_lang dictionary_id='31491.Gerçekleşen'></option>'; else c = c + '<option value="1"><cf_get_lang dictionary_id='31491.Gerçekleşen'></option>';
                    if(state0_ == 0) c = c + '<option value="0" selected><cf_get_lang dictionary_id='58869.Planlanan'></option>'; else c = c + '<option value="0"><cf_get_lang dictionary_id='58869.Planlanan'></option>';
                    newCell.innerHTML = c+ '</select></div>';
                </cfcase>
                <cfcase value="14">
                    newCell = newRow.insertCell(newRow.cells.length);
                    c = '<div class="form-group large"><select name="time_cost_cat' + row_count + '"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
                    <cfoutput query="get_time_cost_cats">
                    if('#time_cost_cat_id#' == time_cost_cat0_)
                        c += '<option value="#time_cost_cat_id#" selected>#time_cost_cat#</option>';
                    else
                        c += '<option value="#time_cost_cat_id#">#time_cost_cat#</option>';
                    </cfoutput>
                    newCell.innerHTML =c+ '</select></div>';
                </cfcase>
                <cfcase value="15">
                    newCell = newRow.insertCell(newRow.cells.length);
                    c = '<div class="form-group large"><select name="time_cost_stage' + row_count + '">';
                    <cfoutput query="get_process_stage">
                    if('#process_row_id#' == time_cost_stage0_)
                        c += '<option value="#process_row_id#" selected>#stage#</option>';
                    else
                        c += '<option value="#process_row_id#">#stage#</option>';
                    </cfoutput>
                    newCell.innerHTML =c+ '</select></div>';
                </cfcase>
                <cfcase value="16">
                    newCell = newRow.insertCell(newRow.cells.length);	
                    c = '<div class="form-group">';				
                    newCell.innerHTML =c+ '<select name="is_rd_ssk' + row_count +'"  id="is_rd_ssk' + row_count +'" ><option value="0"><cf_get_lang dictionary_id='57496.Hayır'></option><option value="1"><cf_get_lang dictionary_id='57495.Evet'></option></select></div>';
                </cfcase>
            </cfswitch>
        </cfloop>
    }
    function id_to_empty(sayac_)	<!--- isme göre kayıt yapılırken employee_id hiddeının boşaltılması amaçlı --->
    {
        if(eval("document.add_worktime.employee"+sayac_).value.length == 0)
        {
            eval("document.add_worktime.employee_id"+sayac_).value = '';
        }
    }

    function pencere_ac_project(no)
    {
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_worktime.project_id' + no +'&project_head=add_worktime.project' + no +'&company_id=add_worktime.company_id' + no +'&consumer_id=add_worktime.consumer_id' + no +'&company_name=add_worktime.member_name' + no +'&partner_id=add_worktime.partner_id' + no);
    }

    function pencere_ac(no)
    {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_worktime.today' + no ,'date');
    }
    
    function pencere_ac_work(no)
    {
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=add_worktime.work_id' + no +'&field_name=add_worktime.work_head' + no +'&comp_id=add_worktime.company_id' + no +'&comp_name=add_worktime.member_name' + no + '&project_id=' + document.getElementById('project_id0').value + '&project_head=' + document.getElementById('project0').value + '');
    }
    
    function pencere_ac_company(no)
    {
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_consumer=add_worktime.consumer_id' + no +'&field_comp_id=add_worktime.company_id' + no +'&field_member_name=add_worktime.member_name' + no +'&field_partner=add_worktime.partner_id' + no+'&select_list=7,8' + no);
    }

    function pencere_ac_expense(no)
    {
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=add_worktime.expense_id' + no +'&field_name=add_worktime.expense' + no,'','ui-draggable-box-small');
    }
    function pencere_ac_p_order_result(no)
    {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_p_order_results&field_id=add_worktime.p_order_result_id' + no +'&field_name=add_worktime.p_order_result' + no,'list');
    }
    function kontrol(satir)
    {	
    
        document.add_worktime.record_num.value=row_count;
        if(row_count == 0)
        {
            alert("<cf_get_lang dictionary_id ='31904.Toplu Zaman Harcaması Girişi Yapmadınız'>!");
            return false;
        }
        for(i=1;i<=row_count;i++)
        {
            deger_row_kontrol = eval("document.add_worktime.row_kontrol_"+i);
            deger_employee = eval("document.add_worktime.employee_id"+i);
            deger_employee_name = eval("document.add_worktime.employee"+i);
            deger_comment = eval("document.add_worktime.comment"+i);
            deger_total_time_hour = eval("document.add_worktime.total_time_hour"+i);
            deger_total_time_minute = eval("document.add_worktime.total_time_minute"+i);
            deger_today = eval("document.add_worktime.today"+i);
            deger_work_id = eval("document.add_worktime.work_id"+i);
            deger_work_head = eval("document.add_worktime.work_head"+i);
            deger_state = eval("document.add_worktime.state"+i);
                
            if(eval("document.add_worktime.row_kontrol_"+i).value >= 1)
            {
                if (deger_employee.value == "" && deger_employee_name.value=="")
                {
                    alert ("<cf_get_lang dictionary_id ='31905.Lütfen Çalışan Seçiniz'> !");
                    return false;
                }
                
                if (deger_comment.value == "")
                {
                    alert ("<cf_get_lang dictionary_id ='31629.Lütfen Açıklama Giriniz'> !");
                    return false;
                }
                if (deger_total_time_hour.value == "" && deger_total_time_minute.value == "" || deger_total_time_hour.value == 0 && deger_total_time_minute.value == 0)
                { 
                    alert ("<cf_get_lang dictionary_id ='31630.Lütfen Süre Giriniz'> !");
                    return false;
                }
                if (deger_today.value == "" && deger_today.value == "")
                { 
                    alert ("<cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'> !");
                    return false;
                }
                if(deger_state.value == 0)
                {
                    if (deger_work_id.value == "" && deger_work_head.value == "")
                    { 
                        alert("<cf_get_lang dictionary_id='59986.Planlanan Zaman Harcaması Girmek İçin İş Kaydı Seçmelisiniz'> !");	
                        return false;
                    }
                }
            }
        }
        
        for(var j=0;j<=row_count;j++)
        {
            tarih_nesne=eval("document.all.today"+j);
            if(!CheckEurodate(tarih_nesne.value,j+'. Tarih'))
            { 
                tarih_nesne.focus();
                return false;
            }
        }
        return process_cat_control();
    }
</script>