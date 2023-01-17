<cf_xml_page_edit fuseact="ehesap.list_dynamic_bordro">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset titles_cmp = createObject('component','V16.hr.cfc.get_titles')>
<cfset titles_cmp.dsn  = dsn>
<cfset get_titles = titles_cmp.get_title()>
<cfset period_years = periods.get_period_year()>
<cfquery name="GET_EXPENSE_CENTER" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
	SELECT
		*
	FROM
		EXPENSE_CENTER
	WHERE
		EXPENSE_ACTIVE = 1 
	ORDER BY
		EXPENSE_CODE
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_department2" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.position_branch_id") and len(attributes.position_branch_id)>BRANCH_ID IN(#attributes.position_branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_company" datasource="#dsn#">
	SELECT 
		COMP_ID,
		NICK_NAME
	FROM
		OUR_COMPANY
	WHERE
		1 = 1
		<cfif not session.ep.ehesap>
			AND COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
	ORDER BY
		NICK_NAME
</cfquery>
<cfquery name="get_duty_type" datasource="#DSN#">
	SELECT
        DUTY_TYPE, 
        CASE
            WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 0 THEN 'İşveren'
            WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 1 THEN 'İşveren Vekili'
            WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 2 THEN 'Çalışan'
            WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 3 THEN 'Sendikalı'
            WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 4 THEN 'Sözleşmeli'
            WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 5 THEN 'Kapsam Dışı'
            WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 6 THEN 'Kısmi İstihdam'
            WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 7 THEN 'Taşeron'
            WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 8 THEN 'Derece/Kademe'
        END AS DUTY_TYPE_NAME
    FROM
        EMPLOYEES_IN_OUT
   	WHERE
    	DUTY_TYPE IS NOT NULL
    GROUP BY 
    	DUTY_TYPE 
   	ORDER BY DUTY_TYPE ASC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../query/get_ssk_offices.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cfinclude template="view_dynamic_bordro_groups.cfm">
<cfif isdefined("attributes.b_obj_hidden")>
	<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
	<cfscript>
		get_puantaj_ = createObject("component", "V16.hr.ehesap.cfc.get_dynamic_bordro");
		get_puantaj_.dsn = dsn;
		get_puantaj_.dsn_alias = dsn_alias;
		get_puantaj_rows = get_puantaj_.get_dynamic_bordro
		(
			sal_year : attributes.sal_year,
			sal_mon : attributes.sal_mon,
			sal_year_end : attributes.sal_year_end,
			sal_mon_end : attributes.sal_mon_end,
			puantaj_type : attributes.puantaj_type,
			keyword:attributes.keyword,
			sort_type: attributes.sort_type,
			upper_position_code:attributes.upper_position_code,
			upper_position :attributes.upper_position,
			upper_position_code2:attributes.upper_position_code2,
			upper_position2:attributes.upper_position2,
			branch_id: '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#' ,
			comp_id: '#iif(isdefined("attributes.comp_id"),"attributes.comp_id",DE(""))#',
			department:'#iif(isdefined("attributes.department"),"attributes.department",DE(""))#',
			position_branch_id:'#iif(isdefined("attributes.position_branch_id"),"attributes.position_branch_id",DE(""))#',
			position_department:'#iif(isdefined("attributes.position_department"),"attributes.position_department",DE(""))#',
			is_all_dep:'#iif(isdefined("attributes.is_all_dep"),"attributes.is_all_dep",DE(""))#',
			is_dep_level:'#iif(isdefined("attributes.is_dep_level"),"attributes.is_dep_level",DE(""))#',
			ssk_statute:'#iif(isdefined("attributes.ssk_statute"),"attributes.ssk_statute",DE(""))#',
			duty_type:'#iif(isdefined("attributes.duty_type"),"attributes.duty_type",DE(""))#',
			main_payment_control:'#iif(isdefined("attributes.main_payment_control"),"attributes.main_payment_control",DE(""))#',
			department_level:'#iif(isdefined("attributes.is_dep_level"),"1","0")#',
			expense_center:'#iif(isdefined("attributes.expense_center"),"attributes.expense_center",DE(""))#',
			position_cat : '#iif(isdefined("attributes.position_cat"),"attributes.position_cat",DE(""))#',
			titles :'#iif(isdefined("attributes.titles"),"attributes.titles",DE(""))#',
			list_type : isdefined("attributes.list_type") ? attributes.list_type : 1
		);
	</cfscript>
</cfif>


<div class="col col-12">
	<cf_box basket_id="bordro_list_layer_div" scroll="0">
		<cfform name="employee" method="post" action="#request.self#?fuseaction=ehesap.list_dynamic_bordro">
			<input type="hidden" name="b_obj_hidden" id="b_obj_hidden" value="<cfif isdefined("attributes.b_obj_hidden")><cfoutput>#attributes.b_obj_hidden#</cfoutput></cfif>">
			<input type="hidden" name="b_obj_sira_hidden" id="b_obj_sira_hidden" value="<cfif isdefined("attributes.b_obj_sira_hidden")><cfoutput>#attributes.b_obj_sira_hidden#</cfoutput></cfif>">
			<cf_box_search>
				<div class="form-group">
					<input type="text" name="keyword" id="keyword" maxlength="100" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" value="<cfif isdefined("attributes.keyword")><cfoutput>#attributes.keyword#</cfoutput></cfif>">
				</div>
				<div class="form-group">
					<select name="sal_mon" id="sal_mon" onchange="change_mon(this.value);">
						<cfloop from="1" to="12" index="i">
							<cfoutput>
								<option value="#i#" <cfif (isdefined("attributes.sal_mon") and attributes.sal_mon eq i) or (not isdefined("attributes.sal_mon") and month(now()) gt 1 and i eq month(now())-1)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<select name="sal_year" id="sal_year">
						<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
							<cfoutput>
								<option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and ((month(now()) eq 1 and year(now())-1 eq i) or (month(now()) neq 1 and year(now()) eq i)))>selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<select name="sal_mon_end" id="sal_mon_end">
						<cfloop from="1" to="12" index="i">
							<cfoutput>
								<option value="#i#" <cfif (isdefined("attributes.sal_mon_end") and attributes.sal_mon_end eq i) or (not isdefined("attributes.sal_mon_end") and month(now()) gt 1 and i eq month(now())-1)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<select name="sal_year_end" id="sal_year_end">
						<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
							<cfoutput>
								<option value="#i#" <cfif (isdefined("attributes.sal_year_end") and attributes.sal_year_end eq i) or (not isdefined("attributes.sal_year_end") and year(now()) eq i)>selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>	
				<div class="form-group">
					<select name="list_type" id="list_type">
						<cfoutput>
							<option value="1" <cfif (isdefined("attributes.list_type") and attributes.list_type eq 1)>selected</cfif>><cf_get_lang dictionary_id = "46076.Dağılım Göster"></option>
							<option value="2" <cfif (isdefined("attributes.list_type") and attributes.list_type eq 2)>selected</cfif>><cf_get_lang dictionary_id = "46074.Toplam Göster"></option>
						</cfoutput>
					</select>		
				</div>
				<div class="form-group">
					<select name="sort_type" id="sort_type">
						<option value=""><cf_get_lang dictionary_id="53661.Sıralama Şekli"></option>
						<option value="1" <cfif (isdefined("attributes.sort_type") and attributes.sort_type eq 1)>selected</cfif>><cf_get_lang dictionary_id='54242.Departmanlara Göre'></option>
						<option value="2" <cfif (isdefined("attributes.sort_type") and attributes.sort_type eq 2)>selected</cfif>><cf_get_lang dictionary_id="53665.Masraf Merkezine Göre"></option>
						<option value="3" <cfif (isdefined("attributes.sort_type") and attributes.sort_type eq 3)>selected</cfif>><cf_get_lang dictionary_id="53666.İdari Amire Göre"></option>
						<option value="4" <cfif (isdefined("attributes.sort_type") and attributes.sort_type eq 4)>selected</cfif>><cf_get_lang dictionary_id="53667.Fonksiyonel Amire Göre"></option>
						<option value="5" <cfif (isdefined("attributes.sort_type") and attributes.sort_type eq 5)>selected</cfif>><cf_get_lang dictionary_id="53668.Çalışana Göre"></option>
						<option value="6" <cfif (isdefined("attributes.sort_type") and attributes.sort_type eq 6)>selected</cfif>><cf_get_lang dictionary_id="53703.Aya Göre"></option>
					</select>
				</div>
				<div class="form-group">
					<input type="checkbox" name="is_hepsi" id="is_hepsi" value="1" onclick="hepsini_sec();">
					<label>
						<cf_get_lang dictionary_id='58081.Hepsi'>
					</label>
				</div>
				<div class="form-group">
					<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>>
					<label>
						<cf_get_lang dictionary_id='57858.Excel Getir'>
					</label>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<div class="btn-group">
						<a href="javascript://"class="ui-btn ui-btn-gray2 dropdown-hover" onclick="duzenle_bordro();">
							<cf_get_lang dictionary_id="51878.Kolonlar"><i class="icon-angle-down"></i>
						</a>
						<ul class="dropDownMenu">
							<cfset sira_ = 0>
							<cfloop list="#b_coloum_groups#" index="ccc">
								<cfset sira_ = sira_ + 1>
								<cfoutput><li id="link#sira_#"><a href="javascript://" onclick="duzenle_bordro(#sira_#);">#ccc#</a></li></cfoutput>
							</cfloop>
						</ul>
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function="open_form_ajax()" no_show_process="1" button_type="3">
					
				</div>
				<cfif isdefined("attributes.b_obj_hidden") and get_puantaj_rows.recordcount and isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
					<cfinclude template="../query/get_branch.cfm"> 
					<cfquery name="get_comp_id" dbtype="query">
						SELECT COMPANY_ID FROM GET_BRANCH
					</cfquery>
					<cfif listlen(attributes.branch_id) eq 1 or (isdefined("get_comp_id.comp_id") and listlen(valuelist(get_comp_id.comp_id,',')) and listlen(valuelist(get_comp_id.comp_id,',')) eq 1)>
						<div class="form-group">
							<cfinclude template="dynamic_bordro_parameters.cfm">
							<cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_print_view_dynamic_bordro&print=1','page');return false;"><img src="/images/print.gif" border="0" align="absmiddle" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></a></cfoutput>
						</div>
					</cfif>
				</cfif>
			</cf_box_search>
			<cf_box_search_detail search_function="open_form_ajax()">
				<cfsavecontent variable="secmessage"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-get_company">
						<label><cf_get_lang dictionary_id="57574.Şirket"></label>
						<div class="multiselect-z2">
							<cf_multiselect_check 
								query_name="get_company"  
								name="comp_id"
								width="140" 
								option_text="#secmessage#" 
								option_value="COMP_ID"
								option_name="NICK_NAME"
								value="#iif(isdefined("attributes.comp_id"),"attributes.comp_id",DE(""))#"
								onchange="get_branch_list(this.value)">
						</div>
					</div>
					<div class="form-group" id="item-BRANCH_PLACE">
						<label><cf_get_lang dictionary_id="57453.Şube"></label>
						<div id="BRANCH_PLACE" class="multiselect-z2">
							<cf_multiselect_check 
							query_name="get_ssk_offices"  
							name="branch_id"
							width="140" 
							option_text="#secmessage#"
							option_value="BRANCH_ID"
							option_name="BRANCH_NAME-NICK_NAME"
							value="#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#"
							onchange="get_department_list(this.value)">
						</div>
					</div>
					<div class="form-group" id="item-DEPARTMENT_PLACE">
						<label><cf_get_lang dictionary_id="57572.Departman"></label>
						<div class="multiselect-z2" id="DEPARTMENT_PLACE">
							<cf_multiselect_check 
							query_name="get_department"  
							name="department"
							width="140" 
							option_text="#secmessage#"
							option_value="department_id"
							option_name="department_head"
							value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#"
							onchange="show_department_checkbox()"
							>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-position_branch_id">
						<label><cf_get_lang dictionary_id="53729.Pozisyon Şube"></label>
						<div class="multiselect-z2">
							<cf_multiselect_check 
							query_name="get_ssk_offices"  
							name="position_branch_id"
							width="180" 
							option_text="#secmessage#"
							option_value="branch_id"
							option_name="BRANCH_FULLNAME"
							value="#iif(isdefined("attributes.position_branch_id"),"attributes.position_branch_id",DE(""))#"
							onchange="get_department_list2(this.value)">
						</div>
					</div>
					<div class="form-group" id="item-position_department">
						<label><cf_get_lang dictionary_id="53728.Pozisyon Departman"></label>
						<div class="multiselect-z2" id="DEPARTMENT_PLACE2">
							<cf_multiselect_check 
							query_name="get_department2"  
							name="position_department"
							width="180" 
							option_text="#secmessage#"
							option_value="department_id"
							option_name="department_head"
							value="#iif(isdefined("attributes.position_department"),"attributes.position_department",DE(""))#">
						</div>
					</div>						
					<div class="form-group" id="item-puantaj_type">
						<cfif x_select_puantaj_type eq 1><label><cf_get_lang dictionary_id="45125.Puantaj Tipi"></label></cfif>
						<cfif x_select_puantaj_type eq 1>
							<select name="puantaj_type" id="puantaj_type">
								<option value="-1" <cfif (isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -1) or not isdefined("attributes.puantaj_type")>selected</cfif>><cf_get_lang dictionary_id="53548.Gerçek Puantaj"></option>
								<option value="0" <cfif (isdefined("attributes.puantaj_type") and attributes.puantaj_type eq 0)>selected</cfif>><cf_get_lang dictionary_id="54194.Sanal Puantaj"></option>
							</select>
						<cfelse>
							<input type="hidden" name="puantaj_type" id="puantaj_type" value="-1" placeholder="<cf_get_lang dictionary_id='45125.Puantaj Tipi'>">	
						</cfif>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-upper_position">
						<label><cf_get_lang dictionary_id="53705.Birinci Amir"></label>
						<div class="input-group">
							<input type="hidden" name="upper_position_code" id="upper_position_code" value="<cfif isdefined("attributes.upper_position_code")><cfoutput>#attributes.upper_position_code#</cfoutput></cfif>">
							<input type="text" name="upper_position" id="upper_position" onfocus="AutoComplete_Create('upper_position','FULLNAME','POSITION_NAME','get_emp_pos','','POSITION_CODE,POSITION_NAME','upper_position_code,upper_position','add_pos','3','162');" value="<cfif isdefined("attributes.upper_position_code") and len(attributes.upper_position_code)><cfoutput>#attributes.upper_position#</cfoutput></cfif>">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=employee.upper_position_code&position_employee=employee.upper_position&show_empty_pos=1','list');return false"></span>
						</div>
					</div>
					<div class="form-group" id="item-upper_position_code2">
						<label><cf_get_lang dictionary_id="53713.İkinci Amir"></label>
						<div class="input-group">
							<input type="hidden" name="upper_position_code2" id="upper_position_code2" value="<cfif isdefined("attributes.upper_position_code2")><cfoutput>#attributes.upper_position_code2#</cfoutput></cfif>">
							<input type="text" name="upper_position2" id="upper_position2" onfocus="AutoComplete_Create('upper_position2','FULLNAME','POSITION_NAME','get_emp_pos','','POSITION_CODE,POSITION_NAME','upper_position_code2,upper_position2','add_pos','3','162');" value="<cfif isdefined("attributes.upper_position_code2") and len(attributes.upper_position_code2)><cfoutput>#attributes.upper_position2#</cfoutput></cfif>" style="width:140px;">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=employee.upper_position_code2&position_employee=employee.upper_position2&show_empty_pos=1','list');return false"></span>
						</div>
					</div>
					<div class="form-group" id="item-position_type">
						<label><cf_get_lang dictionary_id="59004.Pozisyon tipi"></label>
						<div class="multiselect-z2" id="position_type">
							<cf_multiselect_check 
							query_name="GET_POSITION_CATS"  
							name="position_cat"
							width="180" 
							option_text="#secmessage#"
							option_value="POSITION_CAT_ID"
							option_name="POSITION_CAT"
							value="#iif(isdefined("attributes.position_cat"),"attributes.position_cat",DE(""))#">
						</div>
					</div>		
					<div class="form-group" id="item-department_level_td" style="<cfif not ((isdefined("attributes.is_dep_level") and len(attributes.is_dep_level))  or (isdefined("attributes.is_all_dep") and len(attributes.is_all_dep))  or (isdefined("attributes.department") and len(attributes.department))) > display:none</cfif>">
						<div id="department_level_td" class="col col-12" style=" <cfif not ((not isdefined('attributes.b_obj_hidden') and isdefined('x_b_departman') and isnumeric(evaluate('x_b_departman'))) or (isdefined('attributes.b_obj_hidden') and listfind(attributes.b_obj_hidden,'b_departman')))>display:none;</cfif>">
							<label><cf_get_lang dictionary_id="45419.Kademeli Getir">
							<input type="checkbox" name="is_dep_level" id="is_dep_level" value="1" <cfif isdefined('attributes.is_dep_level')>checked</cfif>>
							</label>
						</div>
						<div id="alt_departman_td" class="col col-12"  style=" <cfif not ((not isdefined('attributes.b_obj_hidden') and isdefined('x_b_departman') and isnumeric(evaluate('x_b_departman'))) or (isdefined('attributes.b_obj_hidden') and listfind(attributes.b_obj_hidden,'b_departman')))>display:none;</cfif>">
							<label><cf_get_lang dictionary_id="45397.Alt Departmanları Getir">
							<input type="checkbox" name="is_all_dep" id="is_all_dep" value="1" <cfif isdefined('attributes.is_all_dep')>checked</cfif>>
							</label>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-EXPENSE_CENTER">
						<label><cf_get_lang dictionary_id="58460.Masraf Merkezi"></label>
						<div class="multiselect-z1">
							<cf_multiselect_check 
							query_name="GET_EXPENSE_CENTER"  
							name="EXPENSE_CENTER"
							option_text="#secmessage#"
							width="140"
							option_name="EXPENSE" 
							option_value="EXPENSE_CODE"
							value="#iif(isdefined("attributes.EXPENSE_CENTER"),"attributes.EXPENSE_CENTER",DE(""))#"> 
						</div>
					</div>
					<div class="form-group" id="item-DUTY_TYPE">
						<label><cfoutput>#getLang('main',1126)#<!---1126.Görev Tipi---></cfoutput></label>
						<div class="multiselect-z3" id="DUTY_TYPE">
							<cf_multiselect_check 
							query_name="get_duty_type"  
							name="duty_type"
							width="140" 
							option_text="#secmessage#"
							option_value="duty_type"
							option_name="duty_type_name"
							value="#iif(isdefined("attributes.duty_type"),"attributes.duty_type",DE(""))#">
						</div>
					</div>
					<div class="form-group" id="item-titles">
						<label><cf_get_lang dictionary_id="57571.Ünvan"></label>
						<div class="multiselect-z2" id="titles_div">
							<cf_multiselect_check 
							query_name="get_titles"  
							name="titles"
							width="180" 
							option_text="#secmessage#"
							option_value="TITLE_ID"
							option_name="TITLE"
							value="#iif(isdefined("attributes.titles"),"attributes.titles",DE(""))#">
						</div>
					</div>		
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
					<div class="form-group" id="item-main_payment_control">
						<label><cf_get_lang dictionary_id="53637.Maaş Tipi"></label>
							<cfscript>
								get_main_payment_control = QueryNew("PAYMENT_CONTROL_ID,PAYMENT_CONTROL","Integer,VarChar");
								row_of_query = 0;
							</cfscript>
							<cfsavecontent variable="assalti"><cf_get_lang dictionary_id='53648.Asgari Ücreti Altı'></cfsavecontent>
							<cfsavecontent variable="assucret"><cf_get_lang dictionary_id='53651.Asgari Ücret'></cfsavecontent>
							<cfsavecontent variable="assust"><cf_get_lang dictionary_id='53648.Asgari Ücreti Altı'></cfsavecontent>
							<cfscript>
								row_of_query = row_of_query + 1;
								QueryAddRow(get_main_payment_control,1);
								QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL_ID","-1",row_of_query);
								QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL","#assalti#",row_of_query);
								row_of_query = row_of_query + 1;
								QueryAddRow(get_main_payment_control,1);
								QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL_ID","0",row_of_query);
								QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL","#assucret#",row_of_query);
								row_of_query = row_of_query + 1;
								QueryAddRow(get_main_payment_control,1);
								QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL_ID","1",row_of_query);
								QuerySetCell(get_main_payment_control,"PAYMENT_CONTROL","#assust#",row_of_query);
							</cfscript>
							<cfquery name="get_main_payment_control" dbtype="query">
								SELECT PAYMENT_CONTROL_ID,PAYMENT_CONTROL FROM get_main_payment_control
							</cfquery>
							<div class="multiselect-z1">
							<cf_multiselect_check 
								query_name="get_main_payment_control"  
								name="main_payment_control"
								option_text="#secmessage#"
								width="140"
								option_name="PAYMENT_CONTROL" 
								option_value="PAYMENT_CONTROL_ID"
								value="#iif(isdefined("attributes.main_payment_control"),"attributes.main_payment_control",DE(""))#"> 
							</div>
					</div>
					<div class="form-group" id="item-ssk_statute">
						<label><cf_get_lang dictionary_id="53645.SSK Statüsü"></label>
						<cfscript>
							get_ssk_statute = QueryNew("SSK_STATUTE_ID,SSK_STATUTE","Integer,VarChar");
							row_of_query = 0;
						</cfscript>
						<cfloop list="#list_ucret()#" index="kk">
							<cfscript>
								row_of_query = row_of_query + 1;
								QueryAddRow(get_ssk_statute,1);
								QuerySetCell(get_ssk_statute,"SSK_STATUTE_ID","#kk#",row_of_query);
								QuerySetCell(get_ssk_statute,"SSK_STATUTE","#listgetat(list_ucret_names(),listfindnocase(list_ucret(),kk,','),'*')#",row_of_query);
							</cfscript>
						</cfloop>
						<cfquery name="get_ssk_statute" dbtype="query">
							SELECT SSK_STATUTE_ID,SSK_STATUTE FROM get_ssk_statute
						</cfquery>
						<div class="multiselect-z1">
						<cf_multiselect_check 
							query_name="get_ssk_statute"  
							name="ssk_statute"
							option_text="#secmessage#" 
							width="140"
							option_name="SSK_STATUTE" 
							option_value="SSK_STATUTE_ID"
							value="#iif(isdefined("attributes.ssk_statute"),"attributes.ssk_statute",DE(""))#"> 
						</div>
					</div>		
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
					<div class="form-group"id="item-hierarchy">
						<label><cf_get_lang dictionary_id="55898.Hierarşi"></label>
						<input type="text" name="hierarchy" id="hierarchy" maxlength="50" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>">
					</div>
					<div class="form-group" id="item-print_row_count">
						<label><cf_get_lang dictionary_id="58508.Satır"></label>
						<select name="print_row_count" id="print_row_count" style="width:70px;">
							<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
							<cfloop from="5" to="100" index="i" step="5">
								<cfoutput>
									<option value="#i#" <cfif (isdefined("attributes.print_row_count") and attributes.print_row_count eq i)>selected</cfif>>#i# <cf_get_lang dictionary_id='58508.Satır'></option>
								</cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
			</cf_box_search_detail>
			<cfset sira_ = 0>
			<cfloop list="#b_coloum_groups#" index="ccc">
				<cfset sira_ = sira_ + 1>
				<cfoutput>
					<div id="SHOW_BORDRO_#sira_#" class="exArea" style="display:none;">
						<cfif isdefined("b_coloum_group_#sira_#")>
							<cf_box_elements>
								<cfset liste_ = evaluate("b_coloum_group_#sira_#")>
								<cfset liste_names = evaluate("b_coloum_group_names_#sira_#")>
								<cfset alt_sira_ = 0>
								<cfloop list="#liste_#" index="mmm">
									<cfset alt_sira_ = alt_sira_ + 1>
									<cfif alt_sira_ eq 1 or alt_sira_ mod 5 eq 1><div class="col col-2 col-md-3 col-sm-6 col-xs-12"></cfif>
										<div class="form-group">
											<label class="col col-8 col-xs-12"><input type="checkbox" id="b_objects" name="b_objects" value="#mmm#" <cfif (not isdefined("attributes.b_obj_hidden") and isdefined("x_#mmm#") and isnumeric(evaluate("x_#mmm#"))) or (isdefined("attributes.b_obj_hidden") and listfind(attributes.b_obj_hidden,mmm))>checked</cfif> <cfif sira_ eq 2 and alt_sira_ eq 3>onChange="department_level_chckbx(this.checked);"</cfif>/>
											<cfif isdefined("attributes.b_obj_sira_hidden") and listfindnocase(attributes.b_obj_hidden,mmm) neq 0 and listlen(b_obj_sira_hidden) gte listfindnocase(attributes.b_obj_hidden,mmm)>
												<cfset value = listgetat(b_obj_sira_hidden,listfindnocase(attributes.b_obj_hidden,mmm))>
											<cfelseif isdefined('x_#mmm#') and isnumeric(evaluate('x_#mmm#'))>
												<cfset value = evaluate('x_#mmm#')>
											<cfelse>
												<cfset value = 0>
											</cfif>
											#listgetat(liste_names,alt_sira_)#</label>
											<div class="col col-4 col-xs-12">
												<input type="text" id="b_objects_sira" style="width:25px;" name="b_objects_sira" maxlength="3" value="#value#" onblur="if(this.value.length == 0) this.value = '0';" onkeyup="return(FormatCurrency(this,event,0));"/>
											</div>
											
										</div>
									<cfif alt_sira_ eq listlen(liste_) or alt_sira_ mod 5 eq 0></div></cfif>
								</cfloop>
							</cf_box_elements>
						</cfif>
					</div>
				</cfoutput>
			</cfloop>
		</cfform>	
	</cf_box>
</div>
<style>
	.branch_tb tr td {border: none !important; padding:0px !important;}
</style>
<cfif isdefined("attributes.b_obj_hidden") and get_puantaj_rows.recordcount>
	<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
		<cfif listlen(attributes.branch_id) eq 1 or (isdefined("get_comp_id.comp_id") and listlen(valuelist(get_comp_id.comp_id,',')) and listlen(valuelist(get_comp_id.comp_id,',')) eq 1)>
	<!---		<cf_big_list style="margin-top:-15px;">
				<thead>
					<tr>
						<td>
				<table id="branch_tb" class="branch_tb">
					<cfoutput>
						<tr>
							<td colspan="2">Ücret Bordrosu</td>
						</tr>
						<tr>
							<td><cf_get_lang no='320.Puantaj Listesi'></td>
							<td>: #listgetat(ay_list(),attributes.sal_mon,',')# - #attributes.sal_year# <cfif isdefined("attributes.sal_year_end") and not (attributes.sal_mon eq attributes.sal_mon_end and attributes.sal_year eq attributes.sal_year_end)>#listgetat(ay_list(),attributes.sal_mon_end,',')# - #attributes.sal_year_end#</cfif></td>
						</tr>
						<cfif isdefined("get_comp_id.COMPANY_ID") and listlen(valuelist(get_comp_id.COMPANY_ID,',')) and listlen(valuelist(get_comp_id.COMPANY_ID,',')) eq 1>
							<tr>
								<td width="125"><cf_get_lang_main no='159.Ünvan'></td>
								<td>: #GET_BRANCH.COMPANY_NAME#</td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='1311.Adres'></td>
								<td>: #GET_BRANCH.ADDRESS#</td>
							</tr>
						</cfif>
						<cfif listlen(attributes.branch_id) eq 1>
							<tr>
								<td><cf_get_lang no='645.SSK Ofis'> / <cf_get_lang_main no='75.No'></td>
								<td>: #GET_BRANCH.SSK_OFFICE# - #GET_BRANCH.SSK_M# #GET_BRANCH.SSK_JOB# #GET_BRANCH.SSK_BRANCH# #GET_BRANCH.SSK_BRANCH_OLD# #GET_BRANCH.SSK_NO# #GET_BRANCH.SSK_CITY# #GET_BRANCH.SSK_COUNTRY# #GET_BRANCH.SSK_CD#</td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='1350.Vergi Dairesi'> / <cf_get_lang_main no='75.No'></td>
								<td> 
									<cfif len(GET_BRANCH.BRANCH_TAX_NO)>
										: #GET_BRANCH.BRANCH_TAX_OFFICE# / #GET_BRANCH.BRANCH_TAX_NO#
									<cfelseif len(GET_BRANCH.TAX_NO)>
										: #GET_BRANCH.TAX_OFFICE# / #GET_BRANCH.TAX_NO#
									</cfif>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfif len(get_branch.mersis_no)>Mersis No: #get_branch.mersis_no#<cfelse><cf_get_lang no='549.Ticaret Sicil No'>: #GET_BRANCH.T_NO#</cfif>
								</td>
							</tr>
						<cfelseif isdefined("get_comp_id.COMPANY_ID") and listlen(valuelist(get_comp_id.COMPANY_ID,',')) and listlen(valuelist(get_comp_id.COMPANY_ID,',')) eq 1>
							<tr>
								<td><cfif len(get_branch.mersis_no)>Mersis No<cfelse><cf_get_lang no='549.Ticaret Sicil No'></cfif></td>
								<td>: <cfif len(get_branch.mersis_no)>#get_branch.mersis_no#<cfelse>#GET_BRANCH.T_NO#</cfif></td>
							</tr>
						</cfif>
					</cfoutput>
				</table>
				</td>
				</tr>
				</thead>
			</cf_big_list> --->
			<!--- iki tane big_list olunca print pdf ve excellerde sorun oluyordu bu yüzden üstteki big list kapatılarak aşağıda prepend ile tek biglistte toparlanması sağlandı. --->
		</cfif>
	</cfif>
	<div class="col col-12">
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="53693.Dinamik Bordro"></cfsavecontent>
		<cf_box title="#message#" closable="0" collapsable="1" uidrop="1">
			<cfinclude template="view_dynamic_bordro.cfm">
		</cf_box>
	</div>
<cfelse>
	<div class="col col-12">
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="53693.Dinamik Bordro"></cfsavecontent>
		<cf_box title="#message#" closable="0" collapsable="1" uidrop="1">
			<cf_grid_list>
				<tbody>
					<tr>
						<td><cfif isdefined("attributes.b_obj_hidden")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</tbody>
			</cf_grid_list>
		</cf_box>
	</div>
	
</cfif>
<script type="text/javascript">	
	$(document).ready(function(){
		//$('#branch_tb').css('width',$('#list_tb').css('width'));
		<cfif isdefined("attributes.b_obj_hidden") and get_puantaj_rows.recordcount>
			<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
				<cfif listlen(attributes.branch_id) eq 1 or (isdefined("get_comp_id.comp_id") and listlen(valuelist(get_comp_id.comp_id,',')) and listlen(valuelist(get_comp_id.comp_id,',')) eq 1)>
			$('table.big_list thead').prepend('<cfoutput><tr><td colspan="2"><cf_get_lang dictionary_id='56033.Ücret Bordrosu'></td></tr>\n'
											+'<tr><td colspan="2"><cf_get_lang dictionary_id='53266.Puantaj Listesi'></td><td colspan="2">: #listgetat(ay_list(),attributes.sal_mon,',')# - #attributes.sal_year# <cfif isdefined("attributes.sal_year_end") and not (attributes.sal_mon eq attributes.sal_mon_end and attributes.sal_year eq attributes.sal_year_end)>#listgetat(ay_list(),attributes.sal_mon_end,',')# - #attributes.sal_year_end#</cfif></td></tr>\n'
											+'<cfif isdefined("get_comp_id.COMPANY_ID") and listlen(valuelist(get_comp_id.COMPANY_ID,',')) and listlen(valuelist(get_comp_id.COMPANY_ID,',')) eq 1><tr><td colspan="2"><cf_get_lang dictionary_id='57571.Ünvan'></td><td colspan="8">: #GET_BRANCH.COMPANY_NAME#</td></tr><tr><td colspan="2"><cf_get_lang dictionary_id='58723.Adres'></td><td colspan="8">: #GET_BRANCH.ADDRESS#</td></tr></cfif>\n'
											+'<cfif listlen(attributes.branch_id) eq 1><tr><td colspan="2"><cf_get_lang dictionary_id='53591.SSK Ofis'> / <cf_get_lang dictionary_id='57487.No'></td><td colspan="8">: #GET_BRANCH.SSK_OFFICE# - #GET_BRANCH.SSK_M# #GET_BRANCH.SSK_JOB# #GET_BRANCH.SSK_BRANCH# #GET_BRANCH.SSK_BRANCH_OLD# #GET_BRANCH.SSK_NO# #GET_BRANCH.SSK_CITY# #GET_BRANCH.SSK_COUNTRY# #GET_BRANCH.SSK_CD#</td></tr>\n'
											+'<tr><td colspan="2"><cf_get_lang dictionary_id='58762.Vergi Dairesi'> / <cf_get_lang dictionary_id='57487.No'></td><td colspan="8"> <cfif len(GET_BRANCH.BRANCH_TAX_NO)>: #GET_BRANCH.BRANCH_TAX_OFFICE# / #GET_BRANCH.BRANCH_TAX_NO#<cfelseif len(GET_BRANCH.TAX_NO)>: #GET_BRANCH.TAX_OFFICE# / #GET_BRANCH.TAX_NO#</cfif>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfif len(get_branch.mersis_no)>Mersis No: #get_branch.mersis_no#<cfelse><cf_get_lang dictionary_id='53495.Ticaret Sicil No'>: #GET_BRANCH.T_NO#</cfif></td></tr>\n'
											+'<cfelseif isdefined("get_comp_id.COMPANY_ID") and listlen(valuelist(get_comp_id.COMPANY_ID,',')) and listlen(valuelist(get_comp_id.COMPANY_ID,',')) eq 1><tr><td><cfif len(get_branch.mersis_no)>Mersis No<cfelse><cf_get_lang dictionary_id='53495.Ticaret Sicil No'></cfif></td><td>: <cfif len(get_branch.mersis_no)>#get_branch.mersis_no#<cfelse>#GET_BRANCH.T_NO#</cfif></td></tr></cfif></cfoutput>');

				</cfif>
			</cfif>
		</cfif>
	});
	document.getElementById('keyword').focus();	
	function open_form_ajax()
	{
		b_obj_ = '';
		b_obj_sira_ = '';
		for(i=0; i<document.employee.b_objects.length; i++)
		{
			if(document.employee.b_objects[i].checked == true)
			{
				if(b_obj_ == '')
					b_obj_ = document.employee.b_objects[i].value;
				else
					b_obj_ = b_obj_ + ',' + document.employee.b_objects[i].value;
				if(b_obj_sira_ == '')
					b_obj_sira_ = document.employee.b_objects_sira[i].value;
				else
					b_obj_sira_ = b_obj_sira_ + ',' + document.employee.b_objects_sira[i].value;
			}
		}
		if(b_obj_ == '')
			{
			alert("<cf_get_lang dictionary_id='45521.En Az Bir Kolon Seçmelisiniz'>!");
			return false;
			}
		if (parseInt($('#sal_year').val()) == parseInt($('#sal_year_end').val()))
		{
			if (parseInt($('#sal_mon').val()) > parseInt($('#sal_mon_end').val()))
			{
				alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır.'>");
				return false;
			}
		}
		else if (parseInt($('#sal_year').val()) > parseInt($('#sal_year_end').val()))
		{
			
			{
				alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır'>.");
				return false;
			}
		}
		
		document.getElementById('b_obj_hidden').value = b_obj_;
		document.getElementById('b_obj_sira_hidden').value = b_obj_sira_;
		if(document.employee.is_excel.checked == false)
		{
			document.employee.action="<cfoutput>#request.self#?fuseaction=ehesap.list_dynamic_bordro</cfoutput>";
			return true;
			
		}			
		else
		{
			document.employee.action="<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_list_dynamic_bordro</cfoutput>";
			document.employee.submit();
			return false;
		}
	}
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
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&dept=2,3&is_ssk_offices=1&comp_id="+comp_id_list;
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
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&dept=2,3&onchange_func=show_department_checkbox()&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	function get_department_list2(gelen)
	{
		checkedValues_c = $("#position_branch_id").multiselect("getChecked");
		var branch_id_list_2='';
		for(kk=0;kk<checkedValues_c.length; kk++)
		{
			if(branch_id_list_2 == '')
				branch_id_list_2 = checkedValues_c[kk].value;
			else
				branch_id_list_2 = branch_id_list_2 + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department2&dept=2,3&branch_id="+branch_id_list_2;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE2',1,'İlişkili Departmanlar');
	}
	function hepsini_sec()
	{
		var theForm = document.employee;
		for(i=0; i<theForm.elements.length; i++)
		{
			if(theForm.elements[i].type == "checkbox" && theForm.elements[i].id != 'is_excel')
			{
				if(document.getElementById('is_hepsi').checked)
				{
					theForm.elements[i].checked = true;
				}
				else
				{
					theForm.elements[i].checked = false;
				}
			}
	   }
	}
	function department_level_chckbx(i)
	{
		if (i == true)
		{
			document.getElementById('department_level_td').style.display = '';
			document.getElementById('alt_departman_td').style.display = '';
		}
		else
		{
			document.getElementById('department_level_td').style.display = 'none';
			document.getElementById('alt_departman_td').style.display = 'none';
			document.getElementById('is_dep_level').checked = false;
			document.getElementById('is_all_dep').checked = false;
		}
	}
	function change_mon(i)
	{
		$('#sal_mon_end').val(i);
	}

	function duzenle_bordro(e)
	{
		var area =$('.exArea#SHOW_BORDRO_'+e);
		if(e == null) $('.exArea').hide();		
		if(area.css('display')=='block'){
			area.hide();
		}else{
			$('.exArea').hide();
			area.show();
		}
	}
	function show_department_checkbox()
	{
		document.getElementById('item-department_level_td').style.display = '';
	}
</script>