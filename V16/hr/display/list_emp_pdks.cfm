<cf_xml_page_edit fuseact="hr.list_emp_pdks">
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cf_get_lang_set module_name="hr">
<cfif isdefined("attributes.partner_id") and len(attributes.partner_id) and fusebox.circuit is 'member'>
	<cfquery name="get_partner_info" datasource="#dsn#">
		SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.partner_id#
	</cfquery>
</cfif>
<cfinclude template="../query/get_position_cats2.cfm">
<cfquery name="get_pdks_types" datasource="#dsn#">
	SELECT PDKS_TYPE_ID,PDKS_TYPE FROM SETUP_PDKS_TYPES
</cfquery>
<cfinclude template="../query/get_emp_codes.cfm">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
<cfelse>
	<cfset attributes.startdate = now()>
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate = attributes.startdate>
</cfif>
<cfparam name="attributes.position_cat_id" default="">
<cfif isdefined("attributes.form_submit")> 
	<cfif fusebox.circuit is 'hr'>
		<cfquery name="get_daily_in_out" datasource="#dsn#">
			SELECT
				E.EMPLOYEE_ID,
				EI.IN_OUT_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				EI.BRANCH_ID,
				EI.START_DATE,
				EI.FINISH_DATE,
				B.BRANCH_NAME,
				D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
				CASE 
					WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
				THEN	
					D.HIERARCHY_DEP_ID
				ELSE 
					CASE WHEN 
						D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
					THEN
						(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
					ELSE
						D.HIERARCHY_DEP_ID
					END
				END AS HIERARCHY_DEP_ID
			FROM
				EMPLOYEES_IN_OUT EI
					INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EI.DEPARTMENT_ID,
				EMPLOYEES E,
				BRANCH B
			WHERE
				<cfif len(attributes.position_cat_id)>
					E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID = #attributes.position_cat_id#) AND
				</cfif>
				<cfif isdefined("attributes.pdks_type_id") and len(attributes.pdks_type_id)>
					EI.PDKS_TYPE_ID = #attributes.pdks_type_id# AND
				</cfif>
				EI.EMPLOYEE_ID=E.EMPLOYEE_ID AND
				EI.BRANCH_ID=B.BRANCH_ID 
			<cfif len(attributes.keyword)>
				<cfif database_type is "MSSQL">
					AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR E.EMPLOYEE_NO = '#attributes.keyword#')
				<cfelse>
					AND ((E.EMPLOYEE_NAME || ' ' || E.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR E.EMPLOYEE_NO = '#attributes.keyword#')
				</cfif>
			</cfif>
			<cfif isdefined("attributes.employee_name") and len(attributes.employee_name) and len(attributes.employee_id)>
				AND EI.EMPLOYEE_ID=#attributes.employee_id#
			</cfif>
			<cfif len(emp_code_list)>
				AND 
					(
						<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
							E.OZEL_KOD LIKE '%#code_i#%' OR
							E.OZEL_KOD2 LIKE '%#code_i#%' OR
							E.HIERARCHY LIKE '%#code_i#%' OR
							E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE OZEL_KOD LIKE '%#code_i#%')
							<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>OR</cfif>	 
						</cfloop>
						<cfif fusebox.dynamic_hierarchy>
						OR(
							<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
								<cfif database_type is "MSSQL">
									('.' + E.DYNAMIC_HIERARCHY + '.' + E.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
									<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>
								<cfelseif database_type is "DB2">
									('.' || E.DYNAMIC_HIERARCHY || '.' || E.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
									<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>
								</cfif>
							</cfloop>
						)
						</cfif>
					)
			</cfif>
			<!--- <cfif fusebox.dynamic_hierarchy>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND 
						('.' + E.DYNAMIC_HIERARCHY + '.' + E.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
							
					<cfelseif database_type is "DB2">
						AND 
						('.' || E.DYNAMIC_HIERARCHY || '.' || E.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
							
					</cfif>
				</cfloop>
			<cfelse>
					<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
						<cfif database_type is "MSSQL">
							AND ('.' + E.HIERARCHY + '.') LIKE '%.#code_i#.%'
						<cfelseif database_type is "DB2">
							AND ('.' || E.HIERARCHY || '.') LIKE '%.#code_i#.%'
						</cfif>
					</cfloop>
			</cfif> --->
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND EI.BRANCH_ID=#attributes.branch_id#
			<cfelseif not session.ep.ehesap>
				AND EI.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									POSITION_CODE = #session.ep.position_code#
								)
			</cfif>
			AND 
			(
			(
			EI.START_DATE >= #attributes.startdate#
			AND EI.START_DATE <= #DATEADD("d",1,attributes.finishdate)#
			)
			OR
			EI.FINISH_DATE IS NULL
			OR
			(
			EI.FINISH_DATE IS NOT NULL
			AND EI.FINISH_DATE >= #attributes.startdate#
			AND EI.FINISH_DATE <= #DATEADD("d",1,attributes.finishdate)#		
			)
			)	
			ORDER BY
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
		</cfquery>
	<cfelseif fusebox.circuit is 'member'>
		<cfquery name="get_daily_in_out" datasource="#dsn#">
			SELECT
				C.PARTNER_ID AS EMPLOYEE_ID,
				C.COMPANY_PARTNER_NAME,
				C.COMPANY_PARTNER_SURNAME
			FROM
				COMPANY_PARTNER C
			WHERE
				C.PARTNER_ID IN (SELECT PARTNER_ID FROM EMPLOYEE_DAILY_IN_OUT) AND
				C.PARTNER_ID IS NOT NULL 
			<cfif isdefined("attributes.partner_name") and len(attributes.partner_name) and len(attributes.partner_id)>
				AND C.PARTNER_ID=#attributes.partner_id#
			</cfif>
			<cfif len(attributes.keyword)>
				AND ((C.COMPANY_PARTNER_NAME + ' ' + C.COMPANY_PARTNER_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI )
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				AND C.COMPANY_ID = #attributes.company_id#
			</cfif>
			ORDER BY
				C.COMPANY_PARTNER_NAME,
				C.COMPANY_PARTNER_SURNAME
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_daily_in_out.recordcount=0>
</cfif>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_daily_in_out.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif get_daily_in_out.recordcount>
	<cfset main_employee_list = ''>				
	<cfoutput query="get_daily_in_out" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfset main_employee_list = listappend(main_employee_list,get_daily_in_out.employee_id,',')>
	</cfoutput>	
	<cfset main_employee_list=listsort(main_employee_list,"numeric","ASC",",")>	
	<cfif fusebox.circuit is 'hr'>
		<cfquery name="get_in_outs" datasource="#dsn#">
			SELECT
				E.EMPLOYEE_ID,
				ED.IN_OUT_ID,
				ED.ROW_ID,
				ED.FILE_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				ED.BRANCH_ID,
				ED.IS_WEEK_REST_DAY,
				ED.START_DATE,
				ED.FINISH_DATE,
				B.BRANCH_NAME,
				D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
				CASE 
					WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
				THEN	
					D.HIERARCHY_DEP_ID
				ELSE 
					CASE WHEN 
						D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
					THEN
						(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
					ELSE
						D.HIERARCHY_DEP_ID
					END
				END AS HIERARCHY_DEP_ID
			FROM
				EMPLOYEE_DAILY_IN_OUT ED,
				EMPLOYEES E,
				BRANCH B,
				DEPARTMENT D
			WHERE 
				E.EMPLOYEE_ID IN (#main_employee_list#) AND
				ED.EMPLOYEE_ID=E.EMPLOYEE_ID AND
				ED.BRANCH_ID = B.BRANCH_ID
				AND ISNULL(ED.FROM_HOURLY_ADDFARE,0) = 0
			<cfif len(attributes.startdate)>
				AND ((ED.START_DATE >= #attributes.startdate# AND ED.START_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.START_DATE IS NULL)
				AND ((ED.FINISH_DATE >= #attributes.startdate# AND ED.FINISH_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.FINISH_DATE IS NULL)
			</cfif>		
			ORDER BY
				ED.FILE_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
		</cfquery>
	<cfelseif fusebox.circuit is 'member'>
		<cfquery name="get_in_outs" datasource="#dsn#">
			SELECT
				C.PARTNER_ID,
				ED.IN_OUT_ID,
				ED.ROW_ID,
				ED.FILE_ID,
				C.COMPANY_PARTNER_NAME,
				C.COMPANY_PARTNER_SURNAME,
				ED.BRANCH_ID,
				ED.IS_WEEK_REST_DAY,
				ED.START_DATE,
				ED.FINISH_DATE,
				'' AS BRANCH_NAME
			FROM
				EMPLOYEE_DAILY_IN_OUT ED,
				COMPANY_PARTNER C
			WHERE 
				C.PARTNER_ID IN (#main_employee_list#) AND
				ED.PARTNER_ID=C.PARTNER_ID 
				AND ISNULL(ED.FROM_HOURLY_ADDFARE,0) = 0
			<cfif len(attributes.startdate)>
				AND
				((ED.START_DATE >= #attributes.startdate# AND ED.START_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.START_DATE IS NULL)
				AND
				((ED.FINISH_DATE >= #attributes.startdate# AND ED.FINISH_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.FINISH_DATE IS NULL)
			</cfif>		
			ORDER BY
				ED.FILE_ID,
				C.COMPANY_PARTNER_NAME,
				C.COMPANY_PARTNER_SURNAME
		</cfquery>
	</cfif>
	<cfif fusebox.circuit is 'hr'>
		<cfquery name="GET_TODAY_OFFTIMES" datasource="#DSN#">
			SELECT 
				OFFTIME.VALID, 
				OFFTIME.VALIDDATE,
				OFFTIME.EMPLOYEE_ID, 
				OFFTIME.OFFTIME_ID, 
				OFFTIME.VALID_EMPLOYEE_ID, 
				OFFTIME.STARTDATE, 
				OFFTIME.FINISHDATE, 
				OFFTIME.TOTAL_HOURS, 
				SETUP_OFFTIME.OFFTIMECAT
			FROM 
				OFFTIME,
				EMPLOYEES,
				SETUP_OFFTIME
			WHERE
				OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				OFFTIME.EMPLOYEE_ID IN (#main_employee_list#) AND
				OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
				OFFTIME.EMPLOYEE_ID=EMPLOYEES.EMPLOYEE_ID AND
				OFFTIME.VALID=1
		</cfquery>
		<cfquery name="get_fees" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_SSK_FEE WHERE EMPLOYEE_ID IN (#main_employee_list#)
		</cfquery>
	</cfif>
</cfif>
<cfif fusebox.circuit is 'hr'>
	<cfquery name="GET_BRANCH" datasource="#dsn#">
		SELECT 
			BRANCH_ID,
			BRANCH_NAME
		FROM 
			BRANCH
		WHERE 
			BRANCH_STATUS = 1
			<cfif session.ep.ehesap neq 1>
			AND
			BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								POSITION_CODE = #session.ep.position_code#
							)
			</cfif>
		ORDER BY
			BRANCH_NAME
	</cfquery>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_emp_pdks">
			<cf_box_search>
				<input type="hidden" name="form_submit" id="form_submit" value="1">
				<div class="form-group">
					<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cfoutput>#getLang(48,'Filtre',57460)#</cfoutput>">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></cfsavecontent>
						<cfinput type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" message="#message#" validate="#validate_style#" maxlength="10" style="width:65px;">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" message="#message#" validate="#validate_style#" maxlength="10" style="width:65px;">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="pdks_type_id" id="pdks_type_id">
						<option value=""><cf_get_lang dictionary_id='29489.PDKS Tipi'></option>
						<cfoutput query="get_pdks_types">
							<option value="#PDKS_TYPE_ID#" <cfif isdefined("attributes.pdks_type_id") and attributes.pdks_type_id eq PDKS_TYPE_ID>selected</cfif>>#PDKS_TYPE#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,1000" style="width:25px;">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="date_check(search_form.startdate,search_form.finishdate,'#message_date#')">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-company">
						<label class="col col-12"><cf_get_lang dictionary_id="57585.kurumsal üye"></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
								<input name="member_name" type="text" id="member_name" style="width:120px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete',''1'','COMPANY_ID','company_id','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
								<cfset str_linke_ait="&field_comp_id=search_form.company_id&field_member_name=search_form.member_name">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7&keyword='+encodeURIComponent(document.search_form.member_name.value));"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-position_cat_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
						<div class="col col-12">
							<select name="position_cat_id" id="position_cat_id" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="GET_POSITION_CATS">
									<option value="#POSITION_CAT_ID#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#POSITION_CAT#
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-calisan">
						<label class="col col-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfif fusebox.circuit is 'hr'>
									<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">      
									<input type="text" name="employee_name" id="employee_name" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_name)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>"style="width:100px;">									
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.employee_id&field_name=search_form.employee_name&select_list=1&branch_related')"></span>
								<cfelseif fusebox.circuit is 'member'>
									<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id") and len(attributes.partner_name)><cfoutput>#attributes.partner_id#</cfoutput></cfif>">      
									<input type="text" name="partner_name" id="partner_name" value="<cfif isdefined("attributes.partner_id") and len(attributes.partner_name)><cfoutput>#get_partner_info.company_partner_name# #get_partner_info.company_partner_surname#</cfoutput></cfif>"style="width:100px;">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_name=search_form.partner_name&field_partner=search_form.partner_id');"></span>		
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-hierarchy">
						<label class="col col-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
						<div class="col col-12">
							<input type="text" name="hierarchy" id="hierarchy" value="<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)><cfoutput>#attributes.hierarchy#</cfoutput></cfif>"style="width:100px;">
						</div>
					</div>
				</div>
				<cfif fusebox.circuit is 'hr'>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
					<div class="form-group" id="item-">
						<label class="col col-12"><cf_get_lang dictionary_id="57453.Şube"></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id">
								<option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
								<cfoutput query="get_branch">
									<option value="#get_branch.branch_id#"<cfif attributes.branch_id eq get_branch.branch_id> selected</cfif>>#get_branch.branch_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				</cfif>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
<cfif fusebox.circuit is 'hr'>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id="42720.PDKS Durumları"></cfsavecontent>
<cfelseif fusebox.circuit is 'member'>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='47226.Taşeron PDKS Durumları'></cfsavecontent>
</cfif>
    <cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list>  
			<thead>
				<tr>
					<cfset colspan = "9">
					<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='57490.Gün'></th>
					<cfif isdefined("is_pdks_multirecord") and is_pdks_multirecord eq 1>
						<cfset colspan = colspan + 4>
						<th>K</th>
						<th><cf_get_lang dictionary_id='57554.Giriş'></th>
						<th><cf_get_lang dictionary_id='57431.Çıkış'></th>
						<th><cf_get_lang dictionary_id='57554.Giriş'></th>
						<th><cf_get_lang dictionary_id='57431.Çıkış'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57554.Giriş'></th>
					<th><cf_get_lang dictionary_id='57431.Çıkış'></th>
					<cfif fusebox.circuit is 'hr'>
						<cfset colspan = colspan + 3>
						<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'></th>
						<th><cf_get_lang dictionary_id='58575.İzin'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='29496.Gün Tipi'></th>
					<th><cf_get_lang dictionary_id='58576.Vizite'></th>
					<cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
					<!-- sil -->
						<cfif fusebox.circuit is 'hr'>
							<cfset colspan = colspan + 1>
							<th width="20"><a href="javascript://" onClick="send_all_pdks();"><i class="fa fa-envelope" title="<cf_get_lang dictionary_id='55720.Uyarı Maili Gönder'>"></i></a></th>
						</cfif>
						<th width="20"><input type="hidden" name="aktif_gun" id="aktif_gun" value=""><input type="hidden" name="employee_id_list" id="employee_id_list" value=""><cfif get_daily_in_out.recordcount><input type="checkbox" name="pdks_emp_list_all" id="pdks_emp_list_all" value="1" onClick="check_all_pdks();"></cfif></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_submit") and get_daily_in_out.recordcount> 
					<cfset toplam_gun_ = datediff("d",attributes.startdate,attributes.finishdate)+1>
					<cfif len(pdks_day_value) and toplam_gun_ gt pdks_day_value>
						<cfset toplam_gun_ = pdks_day_value>
						<cfset gecen_ay_ = date_add('d',-pdks_day_value,attributes.finishdate)>
					<cfelse>
						<cfset gecen_ay_ = attributes.startdate>
					</cfif>
					<cfoutput query="get_daily_in_out" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset aktif_employee_id = employee_id>
						<cfset isim_yazdir_ = 1>
						<cfinclude template="../../myhome/display/list_my_pdks_in.cfm">
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#colspan#</cfoutput>"><cfif not isdefined("attributes.form_submit")><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif isdefined("attributes.form_submit")> 	
			<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
				<cfset url_string = ''>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					<cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
				</cfif>
				<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
					<cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
				</cfif>
				<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
					<cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
				</cfif>
				<cfif isdefined("attributes.employee_id") and isdefined('attributes.employee_name') and len(attributes.employee_name)>
					<cfset url_string = '#url_string#&employee_name=#attributes.employee_name#&employee_id=#attributes.employee_id#'>
				</cfif>
				<cfif isdefined("attributes.partner_id") and len(attributes.partner_name)>
					<cfset url_string = '#url_string#&partner_name=#attributes.partner_name#&partner_id=#attributes.partner_id#'>
				</cfif>
				<cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
					<cfset url_string = '#url_string#&form_submit=1'>
				</cfif>
				<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
					<cfset url_string = '#url_string#&hierarchy=#attributes.hierarchy#'>
				</cfif>
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
					<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
				</cfif>
				<cfif isdefined("attributes.pdks_type_id") and len(attributes.pdks_type_id)>
					<cfset url_string = '#url_string#&pdks_type_id=#attributes.pdks_type_id#'>
				</cfif>
				<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
					<cfset url_string = '#url_string#&position_cat_id=#attributes.position_cat_id#'>
				</cfif>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#fusebox.circuit#.list_emp_pdks#url_string#">
			</cfif> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function send_all_pdks()
		{
			if(findObj('pdks_emp_list'))
				{
					if(document.getElementsByName('pdks_emp_list').length != undefined && document.getElementsByName('pdks_emp_list').length != 1) /* n tane*/
						{
							emp_list = '';
							emp_count = 0;
							son_tarih_ = '';
							for (i=0; i < document.getElementsByName('pdks_emp_list').length; i++)
								{
									if(emp_count > 999)
										{
										alert("<cf_get_lang dictionary_id='55668.Aynı Anda En Fazla 1000 Kişiye Uyari Gönderebilirsiniz'>!");
										return false;
										}
									if((document.all.pdks_emp_list[i].checked==true))
									{
										var tarih_ = list_getat(document.all.pdks_emp_list[i].value,2,';');
										var kisi_ = list_getat(document.all.pdks_emp_list[i].value,1,';');
										if(son_tarih_!='' && tarih_ != son_tarih_)
											{
											alert("<cf_get_lang dictionary_id='55669.Farklı Günlere Toplu Uyarı Gönderemezsiniz'>!");
											return false;
											}
										else
											{
											son_tarih_ = tarih_;
											if(emp_count==0)
												{
												emp_list = kisi_;
												}
											else
												{
												emp_list = emp_list + ',' + kisi_;
												}
											}
										var emp_count = emp_count + 1;
									}								
								}
							if(emp_count > 0)
							{
								document.getElementById('employee_id_list').value = emp_list;
								document.getElementById('aktif_gun').value = son_tarih_;
							}
							else
							{
								alert("<cf_get_lang dictionary_id='55671.Mail Listesi Oluşturmalısınız'>!");
								return false;
							}
						}
					else
						{
							if((document.getElementById('pdks_emp_list').checked==true))
								{
									var tarih_ = list_getat(document.getElementById('pdks_emp_list').value,2,';');
									var kisi_ = list_getat(document.getElementById('pdks_emp_list').value,1,';');
									document.getElementById('employee_id_list').value = kisi_;
									document.getElementById('aktif_gun').value = tarih_;
								}
							else
								{
									alert("<cf_get_lang dictionary_id='55671.Mail Listesi Oluşturmalısınız'>!");
									return false;
								}
						}
				}
			else
				{
				alert("<cf_get_lang dictionary_id='55671.Mail Listesi Oluşturmalısınız'>!");
				return false;
				}
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=<cfoutput>#listgetat(attributes.fuseaction,1,".")#</cfoutput>.list_emp_pdks&event=mail&aktif_gun=' + document.getElementById('aktif_gun').value + '&employee_id_list=' + document.getElementById('employee_id_list').value');			
		}
		
		function check_all_pdks()
		{
			if(findObj('pdks_emp_list'))
				{
					if(document.getElementsByName('pdks_emp_list').length != undefined && document.getElementsByName('pdks_emp_list').length != 1) /* n tane*/
						{
							for (i=0; i < document.getElementsByName('pdks_emp_list').length; i++)
								{
									if((document.all.pdks_emp_list[i].checked==true))
										document.all.pdks_emp_list[i].checked=false;
									else
										document.all.pdks_emp_list[i].checked=true;
								}
						}
					else
						{
							if((document.getElementById('pdks_emp_list').checked==true))
								document.getElementById('pdks_emp_list').checked=false;
							else
								document.getElementById('pdks_emp_list').checked=true;
						}
				}
		}
</script>
<cf_get_lang_set module_name="#listgetat(attributes.fuseaction,1,'.')#">
