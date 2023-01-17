<catalystheader>
<cfparam name="attributes.position_cat_id" default=''>
<cfparam name="attributes.emp_status" default=1>
<cfparam name="attributes.eval_date" default="">
<cfparam name="attributes.period_year" default="#session.ep.period_year#">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.is_form_submit" default="0">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.eval_date)>
	<cf_date tarih = "attributes.eval_date">
</cfif>
<cfscript>
	if (not len(attributes.period_year) and attributes.is_form_submit)
		attributes.period_year = session.ep.period_year;
	url_str = "";
	if (attributes.is_form_submit)
	{
		url_str = '#url_str#&is_form_submit=#attributes.is_form_submit#';
		if (len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined('attributes.department') and len(attributes.department))
			url_str = "#url_str#&department=#attributes.department#";
		if (isdefined('attributes.branch_id') and len(attributes.branch_id))
			url_str="#url_str#&branch_id=#attributes.branch_id#";
		if (isdefined("attributes.position_cat_id"))
			url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
		if (isdefined("attributes.title_id"))
			url_str = "#url_str#&title_id=#attributes.title_id#";
		if (len(attributes.eval_date) gt 9)
			url_str = "#url_str#&eval_date=#dateformat(attributes.eval_date,dateformat_style)#";
		if (isdefined("attributes.period_year"))
			url_str = "#url_str#&period_year=#attributes.period_year#";
		if (isdefined("attributes.attenders"))
			url_str = "#url_str#&attenders=#attributes.attenders#";
		if (isdefined('emp_status'))
			url_str = '#url_str#&emp_status=#attributes.emp_status#';
	}
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branch = cmp_branch.get_branch();
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	get_title = cmp_title.get_title();
</cfscript>
<cfinclude template="../query/get_position_cats.cfm">
<cfif attributes.is_form_submit>
	<cfquery name="get_emp_pos" datasource="#dsn#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	</cfquery>
	<cfset position_list=valuelist(get_emp_pos.position_code,',')>
	<cfinclude template="../query/get_emp_codes.cfm">
    <cfquery name="GET_PERF_RESULTS" datasource="#dsn#"><!---  cachedwithin="#fusebox.general_cached_time#" --->
        SELECT 
        DISTINCT
            EPERF.PER_ID,
            EPERF.START_DATE,
            EPERF.FINISH_DATE,
            EPERF.EVAL_DATE,
            EPERF.RECORD_DATE,
            EPERF.RECORD_TYPE,
            EPERF.POSITION_CODE,
            EPERF.IS_CLOSED,
            EPERF.POSITION_CODE AS POS_CODE,
            EP.POSITION_NAME,<!--- Eskiye Döneülmek İstenirse EPRF.EMP_POSITION_NAMENIN QUERYDE GELMESİ VE LİSTEYE EKLENMESİ GEREK --->
            EPT.FIRST_BOSS_CODE,
            E.EMPLOYEE_ID,		
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            ST.TITLE
        FROM 
            EMPLOYEE_PERFORMANCE EPERF 
            INNER JOIN EMPLOYEES E ON EPERF.EMP_ID = E.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_PERFORMANCE_TARGET EPT ON EPERF.PER_ID=EPT.PER_ID
            LEFT JOIN EMPLOYEE_QUIZ_RESULTS EQR ON EPERF.RESULT_ID = EQR.RESULT_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EPERF.EMP_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = EPERF.POSITION_CODE
            LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
            LEFT JOIN EMPLOYEE_POSITIONS_STANDBY EPS ON EP.POSITION_CODE = EPS.POSITION_CODE
            LEFT JOIN EMPLOYEE_PERFORMANCE_DEFINITION EPD ON EPD.YEAR = YEAR(EPERF.START_DATE) AND EPD.IS_ACTIVE = 1
				AND (EPD.TITLE_ID LIKE '%,'+CONVERT(varchar,EP.TITLE_ID) OR EPD.TITLE_ID LIKE +CONVERT(varchar,EP.TITLE_ID)+',%' OR EPD.TITLE_ID LIKE '%,'+CONVERT(varchar,EP.TITLE_ID)+',%' OR EPD.TITLE_ID LIKE CONVERT(varchar,EP.TITLE_ID))
        WHERE
        	1 = 1 
            <cfif not session.ep.ehesap>
            AND( 
           		(EPD.IS_STAGE <> 1 AND (
                    EPT.FIRST_BOSS_CODE IN (#position_list#) OR
                    EPT.SECOND_BOSS_CODE IN (#position_list#) OR
                    EPERF.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
           		)
                OR
                (EPD.IS_STAGE = 1 AND 
                    (
                        EPD.IS_EMPLOYEE = 1 
                        AND EPERF.VALID_1 IS NULL 
                        AND EPERF.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    )
                    OR  EPS.CHIEF3_CODE IN (#position_list#)
                    OR
                    (
                        EPD.IS_UPPER_POSITION = 1 AND
                        EPERF.VALID_3 IS NULL AND 
                        (
                            ((EPD.IS_EMPLOYEE = 1 AND EPERF.VALID_1 = 1) 
                            OR 
                            (EPD.IS_EMPLOYEE = 0 OR EPD.IS_EMPLOYEE IS NULL))
                            AND
                            ((EPD.IS_CONSULTANT = 1 AND EPERF.VALID_2 = 1) 
                            OR 
                            (EPD.IS_CONSULTANT = 0 OR EPD.IS_CONSULTANT IS NULL))
                        )
                        AND EPT.FIRST_BOSS_CODE IN (#position_list#)
                    )
                    OR
                    (
                        EPD.IS_MUTUAL_ASSESSMENT = 1 AND
                        EPERF.VALID_4 IS NULL AND 
                        (
                            ((EPD.IS_EMPLOYEE = 1 AND EPERF.VALID_1 = 1) 
                            OR 
                            (EPD.IS_EMPLOYEE = 0 OR EPD.IS_EMPLOYEE IS NULL))
                            AND
                            ((EPD.IS_CONSULTANT = 1 AND EPERF.VALID_2 = 1) 
                            OR 
                            (EPD.IS_CONSULTANT = 0 OR EPD.IS_CONSULTANT IS NULL))
                            AND
                            ((EPD.IS_UPPER_POSITION = 1 AND EPERF.VALID_3 = 1) 
                            OR 
                            (EPD.IS_UPPER_POSITION = 0 OR EPD.IS_UPPER_POSITION IS NULL))
                        )
                        AND EPT.FIRST_BOSS_CODE IN (#position_list#)
                    )
                    OR EPT.SECOND_BOSS_CODE IN (#position_list#)
                )
            )
            </cfif>
            <cfif len(attributes.eval_date)>
            	AND EPERF.EVAL_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.eval_date#">
            <cfelseif not len(attributes.eval_date) and len(attributes.period_year)>
            	AND YEAR(EPERF.START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_year#">
            <cfelseif len(attributes.eval_date) and len(attributes.period_year)>
            	AND EPERF.EVAL_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.eval_date#">
            <cfelseif not len(attributes.eval_date) and not len(attributes.period_year)>
            	AND YEAR(EPERF.START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
            </cfif>
            <cfif isdefined("attributes.title_id") and len(attributes.title_id)>
            	AND ST.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
			</cfif>
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                AND
                (
                    E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                    E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                    E.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI
                )
            </cfif>
        <cfif fusebox.dynamic_hierarchy>
            <cfloop list="#emp_code_list#" delimiters="+" index="code_i">
                <cfif database_type is "MSSQL">
                    AND ('.' + E.DYNAMIC_HIERARCHY + '.' + E.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
                <cfelseif database_type is "DB2">
                    AND ('.' || E.DYNAMIC_HIERARCHY || '.' || E.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
                </cfif>
            </cfloop>
        <cfelse>
            <cfloop list="#emp_code_list#" delimiters="+" index="code_i">
                <cfif database_type is "MSSQL">
                    AND ('.' + E.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
                <cfelseif database_type is "DB2">
                    AND ('.' || E.HIERARCHY || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
                </cfif>
            </cfloop>
        </cfif>
            AND EPERF.POSITION_CODE IN 
            	(SELECT
                	EPOS.POSITION_CODE
              	FROM 
                    EMPLOYEE_POSITIONS EPOS,
                    DEPARTMENT,
                    BRANCH
                WHERE
                    DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
                    EPOS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                    EPOS.EMPLOYEE_ID > 0
                    <cfif isdefined('attributes.department') and len(attributes.department)>
                        AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
                    </cfif> 
                    <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
                        AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                    </cfif> 
                    <cfif IsDefined("attributes.position_cat_id") and len(attributes.position_cat_id)>AND EPOS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"></cfif>
                )
            ORDER BY 
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                EPERF.EVAL_DATE DESC,
                EPERF.RECORD_DATE DESC
    </cfquery>
<cfelse>
	<cfset get_perf_results.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_perf_results.recordcount#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" method="post" action="#request.self#?fuseaction=hr.list_target_perf">
            <input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
            <!--- #request.self#?fuseaction=hr.list_perform --->
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" placeholder="#place#" maxlength="50">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='55944.Değerlendirme Tarihi'></cfsavecontent>
                    <div class="input-group">
                        <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56240.Değerlendirme Tarihi girilmelidir'></cfsavecontent>
                        <cfif len(attributes.eval_date) gt 9>
                            <cfinput type="text" name="eval_date" maxlength="10" value="#dateformat(attributes.eval_date,dateformat_style)#" validate="#validate_style#" style="width:65px;" placeholder="#place#" message="#alert#">
                        <cfelse>
                            <cfinput type="text" name="eval_date" maxlength="10" value="" validate="#validate_style#" style="width:65px;" placeholder="#place#" message="#alert#">
                        </cfif>
                        <span class="input-group-addon"><cf_wrk_date_image date_field="eval_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='57761.Hiyerarşi'></cfsavecontent>
                    <cfinput type="text" name="hierarchy" style="width:75px;" value="#attributes.hierarchy#" placeholder="#place#" maxlength="50">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function='kontrol()'>
                    <cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <select name="branch_id" id="branch_id" style="width:150px;" onChange="showDepartment(this.value)">
                            <option value=""><cf_get_lang dictionary_id ='57453.Şube'></option>
                            <cfoutput query="get_branch">
                                <option value="#branch_id#"<cfif isdefined('attributes.branch_id') and attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="department" id="department" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='55104.Departman Seciniz'></option>
                            <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
                                <cfoutput query="get_department">
                                    <option value="#department_id#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#department_head#</option>
                                </cfoutput>
                            </cfif>
                        </select>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <select name="position_cat_id" id="position_cat_id" style="width:150px;">
                            <option value="" selected><cf_get_lang dictionary_id='59004.Pozisyon Tipi'>
                            <cfoutput query="get_position_cats">
                                <option value="#position_cat_id#" <cfif attributes.position_cat_id eq position_cat_id>selected</cfif>>#position_cat#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="period_year" id="period_year" style="width:50px;">
                            <cfloop from="#year(now())+1#" to="2002" index="yr" step="-1">
                                <option value="<cfoutput>#yr#</cfoutput>" <cfif isdefined('attributes.period_year') and (yr eq attributes.period_year)>selected</cfif>><cfoutput>#yr#</cfoutput></option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group">
                        <select name="title_id" id="title_id" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='57571.Ünvan'></option>
                            <cfoutput query="get_title">
                                <option value="#title_id#" <cfif attributes.title_id eq title_id>selected</cfif>>#title#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="56567.İK Hedef Yetkinlik"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list>  
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th><cf_get_lang dictionary_id='57571.Ünvan'></th>
                    <th><cf_get_lang dictionary_id='58472.Dönem'></th>
                    <th><cf_get_lang dictionary_id='55944.Değerlendirme Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center">
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_target_perf&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                    </th>
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.target_plan_forms_info_multiemp"><i class="fa fa-plus-circle" title="<cf_get_lang dictionary_id='61321.Toplu Form Oluştur'>" alt="<cf_get_lang dictionary_id='61321.Toplu Form Oluştur'>"></i></a></th>
                    <th width="20" class="header_icn_none text-center"></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_perf_results.recordcount>
                    <cfoutput query="get_perf_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td width="35">#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#employee_name# #employee_surname#</a></td>
                            <td>#position_name#</td>
                            <td>#title#</td>
                            <td>#DateFormat(START_DATE,dateformat_style)# - #DateFormat(FINISH_DATE,dateformat_style)#</td>
                            <td>#DateFormat(EVAL_DATE,dateformat_style)#</td>
                            <td>#DateFormat(RECORD_DATE,dateformat_style)# #TimeFormat(RECORD_DATE,'HH:mm:ss')#</td>	
                            <!-- sil -->					
                            <td align="center">
                            <cfif not listfindnocase(denied_pages,'hr.form_upd_performance')>
                                <a href="#request.self#?fuseaction=hr.list_target_perf&event=upd&per_id=#PER_ID#&pos_code=#pos_code#"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            </cfif>
                            </td>
                            <td width="20"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#PER_ID#&print_type=176','print_page','workcube_print');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
                            <!-- sil -->
                            <td align="center">
                                <cfif is_closed eq 1>
                                    <img src="/images/list_open.gif" alt="<cf_get_lang dictionary_id='61322.Kilitli Değerlendirme'>" title="<cf_get_lang dictionary_id='61322.Kilitli Değerlendirme'>">
                                <cfelse>
                                    <img src="/images/list_lock.gif" alt="<cf_get_lang dictionary_id='61323.Açık (Kilitsiz) Değerlendirme'>" title="<cf_get_lang dictionary_id='61323.Açık (Kilitsiz) Değerlendirme'>">
                                </cfif>
                            </td>  
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                    <td height="20" colspan="10"><cfif attributes.is_form_submit><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="hr.list_target_perf#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
	}
	function kontrol(){
		return true;
	}
</script>