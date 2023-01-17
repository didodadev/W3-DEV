<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.POSITION_CODE#">
</cfquery>
<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>
<cfquery name="GET_PASSWORD_STYLE" datasource="#DSN#">
	SELECT * FROM PASSWORD_CONTROL WHERE PASSWORD_STATUS = 1
</cfquery>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT * FROM BRANCH <cfif not session.ep.ehesap>WHERE BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_branch_list#" list="yes">)</cfif> ORDER BY BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfparam name="attributes.keyword" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="puantaj_" method="post" action="">
			<!-- sil -->
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
                </div>
				<div class="form-group">
					<div class="input-group">
						<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
							<cfinput type="text" validate="#validate_style#" message="#getLang('','Geçerli Tarih Girmelisiniz',55100)#!" maxlength="10" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#">
						<cfelse>
							<cfinput type="text" validate="#validate_style#" message="#getLang('','Geçerli Tarih Girmelisiniz',55100)#!" maxlength="10" name="start_date">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
                </div>
				<div class="form-group">
					<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
						<option value="0"><cf_get_lang dictionary_id='57453.Şube'></option>
						<cfoutput query="get_branches">
							<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
						</cfoutput>	
					</select>
				</div>
				<div class="form-group">
					<div width="125" id="DEPARTMENT_PLACE">
						<select name="department" id="department">
							<option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
							<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
								<cfquery name="get_departmant" datasource="#dsn#">
									SELECT * FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = #attributes.branch_id# AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
								</cfquery>
								<cfoutput query="get_departmant">
									<option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
				<div class="form-group">
					<select name="emp_status" id="emp_status">
						<option value="1" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="-1" <cfif isDefined("attributes.emp_status")and(attributes.emp_status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="0" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 0)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<!-- sil -->
		</cfform>
	</cf_box>
	<cfif isdefined("attributes.is_submit")>
		<cfquery name="get_all" datasource="#dsn#">
			SELECT 
				EP.EMPLOYEE_ID
			FROM 
				EMPLOYEE_POSITIONS EP INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
			WHERE
				EP.EMPLOYEE_ID > 0 AND
				EP.IS_MASTER = 1 
				<cfif (attributes.branch_id is not '0') and len(trim(attributes.branch_id))>
					AND D.BRANCH_ID = #attributes.branch_id#
				<cfelseif not session.ep.ehesap>
					AND D.BRANCH_ID IN (#emp_branch_list#) 
				</cfif>
				<cfif len(attributes.keyword)>
					AND
						(
						EP.EMPLOYEE_NAME+' '+EP.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
						)
				</cfif>
				<cfif len(attributes.department)>
					AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
				</cfif>
		</cfquery>
		<cfquery name="get_mails" datasource="#dsn#">
			SELECT DISTINCT
				E.EMPLOYEE_ID,
				E.EMPLOYEE_EMAIL,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_USERNAME,
				E.EMPLOYEE_STATUS
			FROM
				EMPLOYEES E INNER JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID,
				EMPLOYEE_POSITIONS  EP,
				DEPARTMENT D
			WHERE 
				E.EMPLOYEE_ID > 0 AND
				<cfif len(attributes.start_date)>
					E.RECORD_DATE >= #attributes.start_date# AND
				</cfif>
				<cfif len(attributes.emp_status)>
					<cfif attributes.emp_status eq 1>
						E.EMPLOYEE_STATUS = 1 AND
					<cfelseif attributes.emp_status eq -1>
						E.EMPLOYEE_STATUS = 0 AND
					<cfelseif attributes.emp_status eq 0>
						E.EMPLOYEE_STATUS IS NOT NULL AND 
					</cfif>
				<cfelse>
					E.EMPLOYEE_STATUS=1 AND 
				</cfif>
				EIO.START_DATE <= #NOW()# AND (EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE >= #NOW()#) AND
				E.EMPLOYEE_EMAIL IS NOT NULL AND
				E.EMPLOYEE_EMAIL <> '' AND
				EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				IS_MASTER = 1
				<cfif (attributes.branch_id is not '0') and len(trim(attributes.branch_id))>
					AND D.BRANCH_ID = #attributes.branch_id#
				<cfelseif not session.ep.ehesap>
					AND D.BRANCH_ID IN (#emp_branch_list#) 
				</cfif>
				<cfif len(attributes.keyword)>
					AND
						(
							E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
							OR
							E.EMPLOYEE_EMAIL LIKE '%#attributes.keyword#%'
							OR
							E.EMPLOYEE_USERNAME LIKE '%#attributes.keyword#%'
						)
				</cfif>
				<cfif len(attributes.department)>
					AND D.DEPARTMENT_ID = #attributes.department#
				</cfif>
			UNION ALL
			
			SELECT 
				E.EMPLOYEE_ID,
				E.EMPLOYEE_EMAIL,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_USERNAME,
				E.EMPLOYEE_STATUS
			FROM
				EMPLOYEES E,
				EMPLOYEE_POSITIONS  EP,
				DEPARTMENT D
			WHERE 
				E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT) AND
				E.EMPLOYEE_ID > 0 AND
				<cfif len(attributes.start_date)>
					E.RECORD_DATE >= #attributes.start_date# AND
				</cfif>
				<cfif len(attributes.emp_status)>
					<cfif attributes.emp_status eq 1>
						E.EMPLOYEE_STATUS = 1 AND
					<cfelseif attributes.emp_status eq -1>
						E.EMPLOYEE_STATUS = 0 AND
					<cfelseif attributes.emp_status eq 0>
						E.EMPLOYEE_STATUS IS NOT NULL AND 
					</cfif>
				<cfelse>
					E.EMPLOYEE_STATUS=1 AND 
				</cfif>
				E.EMPLOYEE_EMAIL IS NOT NULL AND
				E.EMPLOYEE_EMAIL <> '' AND
				EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				IS_MASTER = 1
				<cfif (attributes.branch_id is not '0') and len(trim(attributes.branch_id))>
					AND D.BRANCH_ID = #attributes.branch_id#
				<cfelseif not session.ep.ehesap>
					AND D.BRANCH_ID IN (#emp_branch_list#) 
				</cfif>
				<cfif len(attributes.keyword)>
					AND
						(
						E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
						OR
						E.EMPLOYEE_EMAIL LIKE '%#attributes.keyword#%'
						OR
						E.EMPLOYEE_USERNAME LIKE '%#attributes.keyword#%'
						)
				</cfif>
				<cfif len(attributes.department)>
					AND D.DEPARTMENT_ID = #attributes.department#
				</cfif>
			ORDER BY 
				--E.EMPLOYEE_USERNAME DESC,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
		</cfquery>
		<cfset letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,y,z,1,2,3,4,5,6,7,8,9,0">
	<cfelse>
		<cfset get_mails.recordcount = 0>
		<cfset get_all.recordcount = 0>
	</cfif> 
	<cf_box title="#getLang('settings','Çalışan Şifre Düzenle',43526)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th width="300"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th width="300"><cf_get_lang dictionary_id='29463.Mail'></th>
					<th width="300"><cf_get_lang dictionary_id='43640.Eski Kullanıcı'></th>
					<!--- <td class="form-title" width="215"><cf_get_lang dictionary_id='2627.Eski Şifre'></td> --->
					<th width="300"><cf_get_lang dictionary_id='43641.Yeni Kullanıcı'></th>
					<th width="300"><cf_get_lang dictionary_id='43642.Yeni Şifre'></th>
					<!--- <td class="form-title" width="215"><cf_get_lang dictionary_id='2628.Yeni Kriptolu Şifre'></td> --->
					<th width="20" class="header_icn_none text-center"><input type="checkbox" name="check_all" id="check_all" value="1" onClick="change_selects();"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_mails.recordcount>
				<cfform action="#request.self#?fuseaction=settings.emptypopup_setup_employee_passwords" method="post" name="send_passwords">
					<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
					<input type="hidden" name="department" id="department" value="<cfoutput>#attributes.department#</cfoutput>">
					<input type="hidden" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
					<cfoutput query="get_mails">
						<cfif len(EMPLOYEE_EMAIL)>
							<cfset password = ''>
							<cfif get_password_style.recordcount>
								<cfset number_ = "0,1,2,3,4,5,6,7,8,9">
								<cfset lowercase_ = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z">
								<cfset uppercase_ = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z">
								<cfset ozel_ = "! ] ' ^ % & ( [ = ? _ < £ ) $ { \ | . : ; / * - + } > ,">
								<cfif get_password_style.password_number_length gt 0>
									<cfloop from="1" to="#get_password_style.password_number_length#" index="ind">
										<cfset random = RandRange(1,10)>
										<cfset password = "#password##ListGetAt(number_,random,',')#">
									</cfloop>
								</cfif>
								<cfif get_password_style.password_lowercase_length gt 0>
									<cfloop from="1" to="#get_password_style.password_lowercase_length#" index="ind">
										<cfset random = RandRange(1,26)>
										<cfset password = "#password##ListGetAt(lowercase_,random,',')#">
									</cfloop>
								</cfif>
								<cfif get_password_style.password_uppercase_length gt 0>
									<cfloop from="1" to="#get_password_style.password_uppercase_length#" index="ind">
										<cfset random = RandRange(1,26)>
										<cfset password = "#password##ListGetAt(uppercase_,random,',')#">
									</cfloop>
								</cfif>
								<cfif get_password_style.password_special_length gt 0>
									<cfloop from="1" to="#get_password_style.password_special_length#" index="ind">
										<cfset random = RandRange(1,28)>
										<cfset password = "#password##ListGetAt(ozel_,random,' ')#">
									</cfloop>
								</cfif>
								<cfset tmp_cnt = get_password_style.password_length - len(password)>
								<cfloop from="1" to="#tmp_cnt#" index="ind">
									<cfset random = RandRange(1,33)>
									<cfset password = "#password##ListGetAt(letters,random,',')#">
								</cfloop>
							<cfelse>
								<cfloop from="1" to="8" index="ind">				     
									<cfset random = RandRange(1,33)>
									<cfset password = "#password##ListGetAt(letters,random,',')#">
								</cfloop>
							</cfif>
							<cf_CryptedPassword password="#password#" output="crp_password">
							<cfset username = listfirst(EMPLOYEE_EMAIL,'@')>
							<tr class="color-row" height="22" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';">
								<td>#currentrow#</td>
								<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
								<td>#EMPLOYEE_EMAIL#</td>
								<td>#EMPLOYEE_USERNAME#&nbsp;</td>
								<!--- <td>#EMPLOYEE_PASSWORD#&nbsp;</td> --->
								<td>#username#</td>
								<td>#password#</td>
								<!--- <td>#crp_password#</td> --->
								<td style="text-align:center;"><input type="checkbox" name="control_#employee_id#" id="control_#employee_id#" value="1"></td>
							</tr>
							<input type="hidden" name="new_crp_password_#employee_id#" id="new_crp_password_#employee_id#" value="#crp_password#">
							<input type="hidden" name="new_password_#employee_id#" id="new_password_#employee_id#" value="#password#">
							<input type="hidden" name="new_username_#employee_id#" id="new_username_#employee_id#" value="#username#">
							<input type="hidden" name="username_#employee_id#" id="username_#employee_id#" value="#EMPLOYEE_USERNAME#">
						</cfif>
					</cfoutput>
				</cfform>
			</tbody>
			<cfelse>
				<tbody>
					<tr>
						<td colspan="7"><cfif isdefined('attributes.is_submit')><cf_get_lang dictionary_id='58486.Kayit Bulunamadi'><cfelse><cf_get_lang dictionary_id='57701.Filtre ediniz'></cfif>!</td>
					</tr>
				</tbody>
			</cfif> 
		</cf_grid_list>
	</cf_box>
	<cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
		<cf_box>
			<cf_box_elements vertical="1">
				<div class="form-group col col-3">
					<cfoutput><cf_get_lang dictionary_id='43638.Kayıtlı Tüm Çalışanlar'> : #get_all.recordcount#</cfoutput> - <cf_get_lang dictionary_id='43639.E-Maili Olan Çalışanlar'> : <cfoutput>#get_mails.recordcount#</cfoutput>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cfif get_mails.recordcount><input type="button" value="<cf_get_lang dictionary_id='44567.Değişiklikleri Kaydet ve Gönder'>" class="ui-wrk-btn ui-wrk-btn-success" onClick="gonder_this();"></cfif>
			</cf_box_footer>
		</cf_box>
	</cfif>
</div>
<script type="text/javascript">
	control_ = 0;
	function gonder_this()
	{
		send_passwords.submit();
	}
	function change_selects()
	{
		if(control_==0)
		{
		<cfif isdefined('attributes.is_submit')>
		<cfoutput query="get_mails">
			<cfif len(EMPLOYEE_EMAIL)>
				document.send_passwords.control_#employee_id#.checked = true;
			</cfif>
		</cfoutput>
		control_ = 1;
		</cfif>
		}
		else
		{
		<cfif isdefined('attributes.is_submit')>
		<cfoutput query="get_mails">
			<cfif len(EMPLOYEE_EMAIL)>
				document.send_passwords.control_#employee_id#.checked = false;
			</cfif>
		</cfoutput>
		control_ = 0;
		</cfif>
		}
	}
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
	}
</script>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

