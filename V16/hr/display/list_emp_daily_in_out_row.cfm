<cf_get_lang_set module_name="hr">
<cfinclude template="../query/get_emp_codes.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.order_type" default="1">
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
<cfif isdefined("attributes.form_submit")> 
	<cfif fusebox.circuit is 'hr'>
		<cfquery name="get_daily_in_out" datasource="#dsn#">
			SELECT
				E.EMPLOYEE_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				EIO.PDKS_NUMBER,
				ED.IN_OUT_ID,
				ED.DETAIL,
				ED.ROW_ID,
				ED.FILE_ID,
				ED.IS_WEEK_REST_DAY,
				ED.BRANCH_ID,
				ED.START_DATE,
				ED.FINISH_DATE,
				B.BRANCH_NAME
			FROM
				EMPLOYEE_DAILY_IN_OUT ED,
				EMPLOYEES E,
				EMPLOYEES_IN_OUT EIO,
				BRANCH B
			WHERE
				ED.IN_OUT_ID = EIO.IN_OUT_ID AND
				ED.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				ED.BRANCH_ID = B.BRANCH_ID
				AND ISNULL(ED.FROM_HOURLY_ADDFARE,0) = 0
			<cfif len(attributes.keyword)>
				<cfif database_type is "MSSQL">
					AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EIO.PDKS_NUMBER LIKE '#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR E.EMPLOYEE_NO = '#attributes.keyword#')
				<cfelse>
					AND ((E.EMPLOYEE_NAME || ' ' || E.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EIO.PDKS_NUMBER LIKE '#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR E.EMPLOYEE_NO = '#attributes.keyword#')
				</cfif>
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
				AND ED.BRANCH_ID=#attributes.branch_id#
			<cfelseif not session.ep.ehesap>
			AND
			ED.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								POSITION_CODE = #session.ep.position_code#
							)
			</cfif>
			<cfif len(attributes.startdate)>
				AND
				((ED.START_DATE >= #attributes.startdate# AND ED.START_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.START_DATE IS NULL)
				AND
				((ED.FINISH_DATE >= #attributes.startdate# AND ED.FINISH_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.FINISH_DATE IS NULL)
			</cfif>		
			ORDER BY
				<cfif attributes.order_type eq 1>
					ED.ROW_ID,
					ED.FILE_ID,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME
				<cfelseif attributes.order_type eq 2>
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME,
					ED.ROW_ID,
					ED.FILE_ID
				<cfelseif attributes.order_type eq 3>
					ED.START_DATE DESC,
					E.EMPLOYEE_ID
				</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="get_daily_in_out" datasource="#dsn#">
			SELECT
				C.PARTNER_ID,
				C.COMPANY_PARTNER_NAME,
				C.COMPANY_PARTNER_SURNAME,
				C.PDKS_NUMBER,
				ED.IN_OUT_ID,
				ED.DETAIL,
				ED.ROW_ID,
				ED.FILE_ID,
				ED.IS_WEEK_REST_DAY,
				ED.BRANCH_ID,
				ED.START_DATE,
				ED.FINISH_DATE
			FROM
				EMPLOYEE_DAILY_IN_OUT ED,
				COMPANY_PARTNER C
			WHERE
				ED.PARTNER_ID = C.PARTNER_ID 
				AND ISNULL(ED.FROM_HOURLY_ADDFARE,0) = 0
				<cfif len(attributes.keyword)>
					<cfif database_type is "MSSQL">
						AND ((C.COMPANY_PARTNER_NAME + ' ' + C.COMPANY_PARTNER_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR C.PDKS_NUMBER LIKE '#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
					<cfelse>
						AND ((C.COMPANY_PARTNER_NAME || ' ' || C.COMPANY_PARTNER_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR C.PDKS_NUMBER LIKE '#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
					</cfif>
				</cfif>
				<cfif len(attributes.startdate)>
					AND
					((ED.START_DATE >= #attributes.startdate# AND ED.START_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.START_DATE IS NULL)
					AND
					((ED.FINISH_DATE >= #attributes.startdate# AND ED.FINISH_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.FINISH_DATE IS NULL)
				</cfif>		
			ORDER BY
				<cfif attributes.order_type eq 1>
					ED.FILE_ID,
					C.COMPANY_PARTNER_NAME,
					C.COMPANY_PARTNER_SURNAME
				<cfelseif attributes.order_type eq 2>
					C.COMPANY_PARTNER_NAME,
					C.COMPANY_PARTNER_SURNAME,
					ED.FILE_ID
				</cfif>
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_daily_in_out.recordcount=0>
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
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_daily_in_out.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_emp_daily_in_out_row">
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<input type="text" name="keyword" id="keyword" placeholder="<cfoutput>#getLang(48,'Filtre',57460)#</cfoutput>" maxlength="50" value="<cfoutput>#attributes.keyword#</cfoutput>">
				</div>
				<div class="form-group">
					<input type="text" name="hierarchy" id="hierarchy" placeholder="<cfoutput>#getLang(377,'Özel Kod',57789)#</cfoutput>" maxlength="50" value="<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)><cfoutput>#attributes.hierarchy#</cfoutput></cfif>"style="width:100px;">
				</div>
				<div class="form-group">
					<cfif fusebox.circuit is 'hr'>
						<select name="branch_id" id="branch_id">
							<option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
							<cfoutput query="get_branch">
								<option value="#get_branch.branch_id#"<cfif attributes.branch_id eq get_branch.branch_id> selected</cfif>>#get_branch.branch_name#</option>
							</cfoutput>
						</select>
					</cfif>
				</div>
				<div class="form-group">
					<select name="order_type" id="order_type">
						<option value="1"<cfif attributes.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id="34702.ID'ye göre"></option>
						<option value="2"<cfif attributes.order_type eq 2>selected</cfif>><cf_get_lang dictionary_id="34755.Çalışan Adına göre"></option>
						<option value="3"<cfif attributes.order_type eq 3>selected</cfif>><cf_get_lang dictionary_id="58925.Tarihe göre"></option>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" message="#getLang('','başlama girmelisiniz',57655)#" validate="#validate_style#" maxlength="10" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" message="#getLang('','Bitis Tarihi Girmelisiniz',57739)#" validate="#validate_style#" maxlength="10" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfinput type="text" maxlength="3" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" onKeyUp="isNumber(this)" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" range="1,250" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="date_check(search_form.startdate,search_form.finishdate,'#getLang('','Tarih Değerini Kontrol Ediniz',57782)#')">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','PDKS Listesi',29494)#" uidrop="1" hide_table_column="1">
		<cf_grid_list> 
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id="56887.PDKS No"></th>
					<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
				<cfif fusebox.circuit is 'hr'>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
				</cfif>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='29496.Gün Tipi'></th>
					<th><cf_get_lang dictionary_id='57628.Giriş Tarihi'></th>
					<th><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></th>
					<th class="header_icn_none text-center" width="20"><a href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.list_emp_daily_in_out_row&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfset toplam_dk_ = 0>
				<cfif isdefined("attributes.form_submit")>
					<cfoutput query="get_daily_in_out" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#PDKS_NUMBER#</td>
							<td><cfif fusebox.circuit is 'hr'>#employee_name# #employee_surname#<cfelse>#company_partner_name# #company_partner_surname#</cfif></td>
								<cfif fusebox.circuit is 'hr'><td>#branch_name#</td></cfif>
							<td title="#get_daily_in_out.detail#">#left(detail,75)#</td>
							<td><cfif not Len(IS_WEEK_REST_DAY)>
									<cf_get_lang dictionary_id="55753.Çalışma Günü">
									<cfelseif IS_WEEK_REST_DAY eq 0>
										<cf_get_lang dictionary_id="58867.Hafta Tatili">
									<cfelseif IS_WEEK_REST_DAY eq 1>
										<cf_get_lang dictionary_id="29482.Genel Tatil">
									<cfelseif IS_WEEK_REST_DAY eq 2>
										<cf_get_lang dictionary_id="55837.Genel Tatil Hafta Tatili">
									<cfelseif IS_WEEK_REST_DAY eq 3>
										<cf_get_lang dictionary_id="55840.Ücretli İzin Hafta Tatili">
									<cfelseif IS_WEEK_REST_DAY eq 4>
										<cf_get_lang dictionary_id="55844.Ücretsiz İzin Hafta Tatili">
								</cfif>
							</td>
							<td><cfif len(get_daily_in_out.start_date)>#dateformat(get_daily_in_out.start_date,dateformat_style)# (#timeformat(get_daily_in_out.start_date,timeformat_style)#)<cfelse>-</cfif></td>
							<td><cfif len(get_daily_in_out.finish_date)>#dateformat(get_daily_in_out.finish_date,dateformat_style)# (#timeformat(get_daily_in_out.finish_date,timeformat_style)#)<cfelse>-</cfif></td>
							<!-- sil -->
							<td width="20">
								<cfif not len(file_id) or SESSION.EP.EHESAP or SESSION.EP.USERID eq 0>
									<a href="#request.self#?fuseaction=#fusebox.circuit#.list_emp_daily_in_out_row&event=upd&row_id=#row_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								</cfif>
							</td>
							<!-- sil -->
							<cfif len(start_date) and len(finish_date)>
								<cfset fark_ = datediff('n',start_date,finish_date)>
								<cfset toplam_dk_ = toplam_dk_ + fark_>
							</cfif>
						</tr>
					</cfoutput>
					<cfif not get_daily_in_out.recordcount>
						<tr>
							<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
						</tr>
					</cfif>	
				<cfelse>
					<tr><td colspan="9"><cf_get_lang dictionary_id='57701.filtre ediniz'> !</td></tr>
				</cfif>
			</tbody>
		</cf_grid_list>
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
		<cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
			<cfset url_string = '#url_string#&form_submit=1'>
		</cfif>
		<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
			<cfset url_string = '#url_string#&hierarchy=#attributes.hierarchy#'>
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isdefined("attributes.order_type") and len(attributes.order_type)>
			<cfset url_string = '#url_string#&order_type=#attributes.order_type#'>
		</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#fusebox.circuit#.list_emp_daily_in_out_row#url_string#">
	</cf_box>
	<cf_box>
		<div class="ui-info-bottom flex-end">
			<cf_box_elements>
				<div class="form-group">
					<cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="29513.Süre">
					<cfoutput>
						<cfset saat_ = int(toplam_dk_/60)> #saat_# <cf_get_lang dictionary_id="57491.saat">
						<cfif (saat_ * 60) lt toplam_dk_>
							<cfset dakika_ = toplam_dk_ - (saat_ * 60)>
							#dakika_# <cf_get_lang dictionary_id="58827.dk">.
						</cfif>
					</cfoutput>
				</div>
			</cf_box_elements>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
<cf_get_lang_set module_name="#listgetat(attributes.fuseaction,1,'.')#">