<cf_get_lang_set module_name="ehesap">
<cf_xml_page_edit>
<cfparam name="attributes.yil" default="#year(now())#">
<cfparam name="attributes.aylar" default="#Month(now())#">
<cfparam name="attributes.end_mon" default="#Month(now())#">
<cfparam name="attributes.param" default="">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.inout_statue" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<script defer type="text/javascript" src="../JS/temp/multiselect/jquery.multiselect.filter.js"></script>
<script defer type="text/javascript" src="../JS/temp/multiselect/jquery.multiselect.js"></script>
<cfscript>
	url_str = "";
	url_str = "#url_str#&keyword=#attributes.keyword#";
	if (isdefined("attributes.branch_id") and len(attributes.branch_id))
		url_str = "#url_str#&branch_id=#attributes.branch_id#";
	if (len(attributes.yil))
		url_str = "#url_str#&yil=#attributes.yil#";
	if (len(attributes.aylar))
		url_str = "#url_str#&aylar=#attributes.aylar#";
	if (len(attributes.collar_type))
		url_str = "#url_str#&collar_type=#attributes.collar_type#";
	if (len(attributes.position_cat_id))
		url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
	if (len(attributes.end_mon))
		url_str = "#url_str#&end_mon=#attributes.end_mon#";
	if (isdefined('attributes.form_submit'))
		url_str = "#url_str#&form_submit=#attributes.form_submit#";
	if (isdefined("attributes.department_id"))
		url_str = "#url_str#&department_id=#attributes.department_id#";
	if (isdefined("attributes.hierarchy"))
		url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
</cfscript>
<cfif len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>

<cfinclude template="../query/get_ssk_offices.cfm">
<cfquery name="get_branches" datasource="#DSN#">
	SELECT DISTINCT
		RELATED_COMPANY
	FROM 
		BRANCH
	WHERE 
		BRANCH_ID IS NOT NULL AND
		RELATED_COMPANY IS NOT NULL
	<cfif not session.ep.ehesap>
		AND
		BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
					)
	</cfif>
	ORDER BY
		RELATED_COMPANY
</cfquery>
<cfif isdefined('attributes.form_submit')>
    <cfinclude template="../../query/get_emp_codes.cfm">
    <cfquery name="get_emp_bes" datasource="#DSN#">
          SELECT
            SG.*,
            SOCIETY_TYPES=(SELECT SETUP_SOCIAL_SOCIETY.SOCIETY FROM SETUP_SOCIAL_SOCIETY WHERE SETUP_SOCIAL_SOCIETY.SOCIETY_ID= SG.SOCIETY_TYPE ),
            E.EMPLOYEE_NAME,
            EI.TC_IDENTY_NO,
            B.BRANCH_NAME,
            E.EMPLOYEE_SURNAME,
            EIO.DEPARTMENT_ID,
            EIO.IN_OUT_ID,
            EIO.START_DATE,
            EIO.FINISH_DATE,
            EP.POSITION_CAT_ID,
            EP.COLLAR_TYPE,
            EP.POSITION_NAME,
            D.DEPARTMENT_HEAD,
            SPC.POSITION_CAT
          FROM 
            SALARYPARAM_BES SG,
            EMPLOYEES_IN_OUT EIO
            LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EIO.DEPARTMENT_ID,
            EMPLOYEES_IDENTY EI,
            BRANCH B,
            EMPLOYEES E
            LEFT JOIN EMPLOYEE_POSITIONS EP ON (E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.IS_MASTER = 1)
            LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
          WHERE
            <cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
                EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#"> AND
            </cfif>
            <cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
                EP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"> AND
            </cfif>
            (
                <cfif attributes.aylar lte attributes.end_mon>
                    (START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aylar#"> AND END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aylar#">)
                    OR
                    (END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aylar#"> AND END_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_mon#">)
                    OR
                    (	
                        END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aylar#"> OR 
                        END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_mon#"> OR 
                        START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aylar#"> OR 
                        START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_mon#">
                    )
                <cfelse>
                    START_SAL_MON IS NULL
                </cfif>
            )
            AND
            EIO.BRANCH_ID = B.BRANCH_ID AND
            E.EMPLOYEE_ID = SG.EMPLOYEE_ID AND
            E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
            EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
            EIO.IN_OUT_ID = SG.IN_OUT_ID AND
            SG.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.yil#">
        <cfif len(attributes.keyword)>
            AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
            OR EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR E.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">)
        </cfif>
        <cfif isdefined("attributes.related_company") and len(attributes.related_company)>
            AND B.RELATED_COMPANY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_company#">
        </cfif>
        <cfif isdefined("attributes.BRANCH_ID") and attributes.BRANCH_ID is not "all">
            AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
        <cfelseif not session.ep.ehesap>
            AND
            (
            EIO.BRANCH_ID IN (
                            SELECT
                                BRANCH_ID
                            FROM
                                EMPLOYEE_POSITION_BRANCHES
                            WHERE
                                EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                            )
            )
        </cfif>
        <cfif fusebox.dynamic_hierarchy>
            <cfloop list="#emp_code_list#" delimiters="+" index="code_i">
                    AND ('.' + E.DYNAMIC_HIERARCHY + '.' + E.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">                        
            </cfloop>
        <cfelse>
            <cfloop list="#emp_code_list#" delimiters="+" index="code_i">
                    AND ('.' + E.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
            </cfloop>
        </cfif>
        <cfif isdefined("attributes.DEPARTMENT_ID") and len(attributes.DEPARTMENT_ID) and attributes.DEPARTMENT_ID gt 0>
            AND EIO.DEPARTMENT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
        </cfif>
        <cfif isdefined('attributes.inout_statue') and attributes.inout_statue eq 1><!--- Girişler --->
            <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
            </cfif>
            <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
            </cfif>
        <cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 0><!--- Çıkışlar --->
            <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
            </cfif>
            <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
            </cfif>
            AND	EIO.FINISH_DATE IS NOT NULL
        <cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 2><!--- aktif calisanlar --->
            AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
            (
                <cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
                    <cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
                    (
                        (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                        )
                        OR
                        (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE IS NULL
                        )
                    )
                    <cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
                    (
                        (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                        )
                        OR
                        (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                            EIO.FINISH_DATE IS NULL
                        )
                    )
                    <cfelse>
                    (
                        (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                        )
                        OR
                        (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE IS NULL
                        )
                        OR
                        (
                            EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                        )
                        OR
                        (
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                        )
                    )
                    </cfif>
                <cfelse>
                    EIO.FINISH_DATE IS NULL
                </cfif>
            ) )
        <cfelse><!--- giriş ve çıkışlar Seçili ise --->
            AND 
            (
                (
                    EIO.START_DATE IS NOT NULL
                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                        AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                    </cfif>
                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                        AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                    </cfif>
                )
                OR
                (
                    EIO.START_DATE IS NOT NULL
                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                        AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                    </cfif>
                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                        AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                    </cfif>
                )
            )
        </cfif>
    </cfquery>
<cfelse>
	<cfset get_emp_bes.recordcount = 0>
</cfif>

<cfquery name="GET_POSITION_CATS_" datasource="#dsn#">
	SELECT 
    	POSITION_CAT_ID, 
        POSITION_CAT, 
        HIERARCHY, 
        POSITION_CAT_STATUS
    FROM 
	    SETUP_POSITION_CAT 
    ORDER BY 
    	POSITION_CAT
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=#fusebox.circuit#.list_emp_bes" name="myform" method="post">
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" style="width:100px;" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57761.Hiyerarşi"></cfsavecontent>
                    <cfinput name="hierarchy" id="hierarchy" value="#attributes.hierarchy#" placeholder="#message#" style="width:100px;" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="aylar" id="aylar" onchange="change_mon(this.value);">
                        <cfloop from="1" to="12" index="i">
                            <cfset ay_bu=ListGetAt(ay_list(),i)>
                            <cfoutput><option value="#i#" <cfif attributes.aylar eq i>Selected</cfif> >#ay_bu#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="end_mon" id="end_mon">
                        <cfloop from="1" to="12" index="i">
                            <cfset ay_bu=ListGetAt(ay_list(),i)>
                            <cfoutput><option value="#i#" <cfif attributes.end_mon eq i>Selected</cfif> >#ay_bu#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="yil" id="yil">
                        <cfloop from="#year(now())-1#" to="#year(now())+2#" index="i">
                        <cfoutput>
                            <option value="#i#"<cfif attributes.yil eq i> selected</cfif>>#i#</option>
                        </cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
                <!--- <div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_emp_bes&event=add','','ui-draggable-box-large');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
				</div> --->
                <div class="form-group">
					<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_add_bes_all','','ui-draggable-box-large');"><i class="fa fa-clone" title="<cf_get_lang dictionary_id='58032.Çoklu'><cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
				</div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-inout_statue">
                        <label class="col col-12"><cf_get_lang dictionary_id='55904.Giriş ve Çıkışlar'></label>
                        <div class="col col-12">
                            <select name="inout_statue" id="inout_statue">
                                <option value=""><cf_get_lang dictionary_id='55904.Giriş ve Çıkışlar'></option>
                                <option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
                                <option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
                                <option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id="39083.Aktif Çalışanlar"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-startdate">
                        <label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                <cfinput type="text" name="startdate" id="startdate" style="width:65px;" placeholder="#place#" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="place"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" placeholder="#place#" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-related_company">
                        <label class="col col-12"><cf_get_lang dictionary_id='53701.İlgili Şirket'></label>
                        <div class="col col-12">
                            <select name="related_company" id="related_company">
                                <option value=""><cf_get_lang dictionary_id='53701.İlgili Şirket'></option>
                                <cfoutput query="get_branches">
                                    <option value="#related_company#" <cfif isdefined("attributes.related_company") and attributes.related_company is related_company>selected</cfif>>#related_company#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">
                            <select name="BRANCH_ID" id="branch_id" onChange="showDepartment(this.value)">
                                <option value="all"><cf_get_lang dictionary_id='57453.Şube'></option>
                                <cfoutput query="GET_SSK_OFFICES">
                                    <cfif len(SSK_OFFICE) and len(SSK_NO)>
                                        <option value="#BRANCH_ID#"<cfif isdefined("attributes.BRANCH_ID") and (attributes.BRANCH_ID is BRANCH_ID)> selected</cfif>>#BRANCH_NAME#</option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-department_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-12">
                            <select name="department_id" id="department_id">
                                <option value="0"><cf_get_lang dictionary_id='57572.Departman'></option>
                                <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                    <cfquery name="get_departmant" datasource="#dsn#">
                                        SELECT 
                                            DEPARTMENT_STATUS, 
                                            IS_STORE, 
                                            BRANCH_ID, 
                                            DEPARTMENT_ID, 
                                            DEPARTMENT_HEAD, 
                                            HIERARCHY
                                        FROM 
                                            DEPARTMENT 
                                        WHERE 
                                            DEPARTMENT_STATUS = 1 
                                        AND 
                                            BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> 
                                        AND 
                                            IS_STORE <> 1 
                                        ORDER BY 
                                            DEPARTMENT_HEAD
                                    </cfquery>
                                    <cfoutput query="get_departmant">
                                        <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department_id') and (attributes.department_id eq get_departmant.DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-collar_type">
                        <label class="col col-12"><cf_get_lang dictionary_id='54054.Yaka Tipi'></label>
                        <div class="col col-12">
                            <select name="collar_type" id="collar_type">
                                <option value=""><cf_get_lang dictionary_id='54054.Yaka Tipi'></option>
                                <option value="1"<cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='54055.Mavi Yaka'></option> 
                                <option value="2"<cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='54056.Beyaz Yaka'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-position_cat_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                        <div class="col col-12">
                            <select name="position_cat_id" id="position_cat_id" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'>
                                <cfoutput query="GET_POSITION_CATS_">
                                    <option value="#POSITION_CAT_ID#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#POSITION_CAT#
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','BES','63079')#-#getLang('','Bireysel Emeklilik','63080')#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr> 
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon tipi'></th>
                    <th><cf_get_lang dictionary_id='54054.Yaka tipi'></th>
                    <th><cf_get_lang dictionary_id="53132.başlangıç ay"></th>
                    <th><cf_get_lang dictionary_id="53133.bitiş ay"></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id="45126.BES Oranı"></th>
                    <th><cf_get_lang dictionary_id='62968.Sigorta Kurumu'></th>
                    <cfif fusebox.circuit is 'ehesap'>
                        <!-- sil --><th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_emp_bes&event=add');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
                    </cfif>
                </tr>
            </thead>
                <cfparam name="attributes.totalrecords" default="#get_emp_bes.recordcount#">
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <cfif get_emp_bes.recordcount>
                    <tbody>
                        <cfoutput query="get_emp_bes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                            <tr>
                                <td>#currentrow#</td>
                                <td><cf_duxi type="label" name="TC_IDENTY_NO" id="TC_IDENTY_NO" value="#tc_identy_no#" hint="TC Kimlik No" gdpr="2"></td>
                                <cfif fusebox.circuit is 'ehesap'>
                                    <td><a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&employee_id=#employee_id#&in_out_id=#in_out_id#" class="tableyazi">#employee_name# #employee_surname#</a></td>
                                <cfelse>
                                    <td>#employee_name# #employee_surname#</td>
                                </cfif>
                                <td>#BRANCH_NAME#</td>
                                <td>#department_head#</td>
                                <td>#position_cat#</td>
                                <td><cfif collar_type eq 1><cf_get_lang dictionary_id='54055.Mavi Yaka'><cfelseif collar_type eq 2><cf_get_lang dictionary_id='54056.Beyaz Yaka'></cfif></td>
                                <td>#listgetat(ay_list(),START_SAL_MON)#</td>
                                <td>#listgetat(ay_list(),END_SAL_MON)#</td>
                                <td style="text-align:right;">%#TLFormat(rate_bes)#</td>
                                <td>#get_emp_bes.society_types#</td>
                                <cfif fusebox.circuit is 'ehesap'>
                                    <!-- sil --><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_upd_payments&id=#spb_id#&is_bes=1');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                                </cfif>
                            </tr>
                        </cfoutput> 
                    </tbody>
                <cfelse>	
                    <tbody>
                        <tr> 
                            <td colspan="16"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                        </tr>
                </tbody>    
                </cfif>
        </cf_grid_list> 
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="ehesap.list_emp_bes&#url_str#">
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
	function change_mon(i)
	{
		$('#end_mon').val(i);
	}	
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">