<!---Select ifadeleri düzenlendi.e.a 31.07.2012--->
<cfquery name="get_hist" datasource="#dsn#">
	SELECT 
		DEPARTMENT_STATUS,
		BRANCH_ID,
		DEPARTMENT_ID,
		DEPARTMENT_HEAD,
		DEPARTMENT_DETAIL,
        DEPARTMENT_EMAIL,
		ADMIN1_POSITION_CODE,
		ADMIN2_POSITION_CODE,
		HIERARCHY_DEP_ID,
		HIERARCHY,
		ISNULL(UPDATE_DATE,RECORD_DATE) UPDATE_DATE,
		ISNULL(UPDATE_EMP,RECORD_EMP) UPDATE_EMP,
		IS_ORGANIZATION,
        IS_STORE,
        LEVEL_NO,
        EMP_COUNT,
        CHANGE_DATE,
        IN_COMPANY_REASON_ID
	FROM
		 DEPARTMENT_HISTORY
	WHERE 
		DEPARTMENT_ID = #attributes.dept_id# 
	ORDER BY 
		UPDATE_DATE DESC
</cfquery>
<cfquery name="get_reason" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="hr.form_upd_department"> AND
		(
            PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_in_company_reason_id">
		)	
</cfquery>
<cf_get_lang dictionary_id='65409.Departman Geçmiş Bilgileri'>
<cf_box title="#getLang('','Departman Geçmiş Bilgileri',65409)# : #get_hist.DEPARTMENT_HEAD#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfif get_hist.recordcount>            
        <cfset temp_ = 0>
        <cfoutput query="get_hist">
            <cfset temp_ = temp_ +1>
            <cf_seperator id="history_#temp_#" header="#dateformat(UPDATE_DATE,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,UPDATE_DATE),timeformat_style)#) - #get_emp_info(UPDATE_EMP,0,0)#" is_closed="1">
            <div class="row" id="history_#temp_#" style="display:none;">
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang_main no='219.Ad'></label>
                        <div class="col col-6"> 
                            #DEPARTMENT_HEAD#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang_main no='344.Durum'></label>
                        <div class="col col-6"> 
                            <cfif DEPARTMENT_STATUS eq 1><cf_get_lang_main no='81.Aktif'><cfelse><cf_get_lang_main no='82.Pasif'></cfif>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang_main no='218.Tip'></label>
                        <div class="col col-6"> 
                            <cfif is_store eq 1><cf_get_lang_main no='1351.Depo'><cfelseif is_store eq 2><cf_get_lang_main no='160.Departman'><cfelseif is_store eq 3><cf_get_lang_main no='1351.Depo'> ve <cf_get_lang_main no='160.Departman'></cfif>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang no='1648.Org Şema'></label>
                        <div class="col col-6"> 
                            <cfif IS_ORGANIZATION eq 1><cf_get_lang_main no='81.Aktif'><cfelse><cf_get_lang_main no='82.Pasif'></cfif>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang no='630.Çalışan Sayısı'></label>
                        <div class="col col-6"> 
                            #emp_count#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang_main no='41.Şube'></label>
                        <div class="col col-6"> 
                            <cfif len(BRANCH_ID)>
                                <cfquery name="get_branch_name" datasource="#dsn#">
                                    SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #BRANCH_ID#
                                </cfquery>
                                <cfif get_branch_name.recordcount>
                                    #get_branch_name.BRANCH_NAME#
                                </cfif>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang no='352.Üst Departman'></label>
                        <div class="col col-6"> 
                            <cfif find(".",get_hist.HIERARCHY_DEP_ID)>
                                <cfset up_dep=ListGetAt(get_hist.HIERARCHY_DEP_ID,evaluate("#listlen(get_hist.HIERARCHY_DEP_ID,".")#-1"),".") >	
                                <cfquery name="DEPARTMANS" datasource="#dsn#">
                                    SELECT 
                                        DEPARTMENT_HEAD 
                                    FROM
                                        DEPARTMENT
                                    WHERE 
                                        DEPARTMENT_ID = #up_dep#
                                </cfquery>
                                <cfset up_dep_name="#DEPARTMANS.DEPARTMENT_HEAD#">
                            <cfelse>
                                <cfset up_dep="">
                                <cfset up_dep_name="">	
                            </cfif>
                            #up_dep_name#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang_main no='1714.Yön'> 1</label>
                        <div class="col col-6"> 
                            #get_emp_info(ADMIN1_POSITION_CODE,1,0)#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang_main no='1714.Yön'> 2</label>
                        <div class="col col-6"> 
                            #get_emp_info(ADMIN2_POSITION_CODE,1,0)#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang_main no='349.Hiyerarşi'></label>
                        <div class="col col-6"> 
                            #HIERARCHY#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang_main no="16.Email"></label>
                        <div class="col col-6"> 
                            #department_email#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang no='26.Ayrıntı'></label>
                        <div class="col col-6"> 
                            #department_detail#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang no='1108.Kademe Numarası'></label>
                        <div class="col col-6"> 
                            #level_no#
                        </div>
                    </div>
                    <cfif x_change_date eq 1>
                        <div class="form-group">
                            <label class="col col-6 bold">Değişiklik Tarihi</label>
                            <div class="col col-6"> 
                                #dateformat(CHANGE_DATE,dateformat_style)#
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang_main no='479.Güncelleyen'></label>
                        <div class="col col-6"> 
                            #get_emp_info(UPDATE_EMP,0,0)#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6 bold"><cf_get_lang no='1180.Güncelleme Tarihi'></label>
                        <div class="col col-6">
                            #dateformat(UPDATE_DATE,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,UPDATE_DATE),timeformat_style)#
                        </div>
                    </div>
                    <cfif get_reason.recordcount><!---20191205ERU departman için şirket içi gerekçeler xml --->
                        <cfif get_reason.PROPERTY_VALUE eq 1>
                            <div class="form-group">
                                <label class="col col-6 bold"><cf_get_lang dictionary_id='30937.Gerekçe'></label>
                                <div class="col col-6">
                                    <cfquery name="fire_reasons" datasource="#dsn#">
                                        SELECT REASON_ID,REASON FROM SETUP_EMPLOYEE_FIRE_REASONS WHERE IS_DEPARTMENT = 1 and REASON_ID =  '#IN_COMPANY_REASON_ID#'
                                    </cfquery>
                                    #fire_reasons.REASON#
                                </div>
                            </div>
                        </cfif>
                    </cfif>
                </div>
            </div>
        </cfoutput>
    <cfelse>
        <cf_get_lang_main no='72.Kayıt yok'> !
    </cfif>
</cf_box>