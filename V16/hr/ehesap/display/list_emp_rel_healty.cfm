<cf_get_lang_set module_name="ehesap">
<cfif not isdefined('attributes.keyword')>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.startdate" default="#dateformat(date_add('m',-1,CreateDate(year(now()),month(now()),1)),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#dateformat(CreateDate(year(now()),month(now()),DaysInMonth(now())),dateformat_style)#"> 
<cfinclude template="../query/get_branch_name.cfm">
<cfif arama_yapilmali eq 1>
	<cfset get_emp_healty.recordcount = 0>
<cfelse>
	<cfif len(attributes.startdate)>
		<cf_date tarih = "attributes.startdate">
	</cfif>
	<cfif len(attributes.finishdate)>
		<cf_date tarih = "attributes.finishdate">
	</cfif>
	<cfquery name="get_emp_healty" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
		SELECT 
			EMPLOYEES_RELATIVE_HEALTY.ARRANGEMENT_DATE,
			EMPLOYEES_RELATIVE_HEALTY.BRANCH_ID,
			EMPLOYEES_RELATIVE_HEALTY.ILL_NAME,
			EMPLOYEES_RELATIVE_HEALTY.ILL_SURNAME,
			EMPLOYEES_RELATIVE_HEALTY.DOC_ID,
			EMPLOYEES_RELATIVE_HEALTY.IN_OUT_ID,
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME	
		FROM 
			EMPLOYEES_RELATIVE_HEALTY,
			EMPLOYEES
		WHERE
			EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_RELATIVE_HEALTY.EMP_ID
		<cfif len(attributes.keyword)>
			AND 
			(
				EMPLOYEES_RELATIVE_HEALTY.ILL_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR 
				EMPLOYEES_RELATIVE_HEALTY.ILL_SURNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
                EMPLOYEES.EMPLOYEE_NO = '#attributes.keyword#' OR
				<cfif database_type is "MSSQL">
					EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI 		
				<cfelseif database_type is "DB2">
					EMPLOYEES.EMPLOYEE_NAME||' '||EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				</cfif>
			)
		</cfif>
		<cfif isdate(attributes.startdate) and isdate(attributes.finishdate)>
			AND EMPLOYEES_RELATIVE_HEALTY.ARRANGEMENT_DATE BETWEEN #attributes.startdate# and  #attributes.finishdate#
		</cfif>
		<cfif len(attributes.branch_id)>
			AND EMPLOYEES_RELATIVE_HEALTY.BRANCH_ID = #attributes.branch_id#
		</cfif>
		<cfif not session.ep.ehesap>
			AND EMPLOYEES_RELATIVE_HEALTY.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
		</cfif>
		ORDER BY
			EMPLOYEES_RELATIVE_HEALTY.ARRANGEMENT_DATE DESC
	</cfquery>
	<cfif len(attributes.finishdate)>
		<cfset attributes.finishdate = dateformat(attributes.finishdate, dateformat_style)>
	</cfif>
	<cfif len(attributes.startdate)>
		<cfset attributes.startdate = dateformat(attributes.startdate, dateformat_style)>
	</cfif>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_emp_healty.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=#fusebox.circuit#.list_emp_rel_healty" method="post" name="filter_list_emp_rel_healty">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="placemessage"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#placemessage#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">                    
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="kontrol()">                    
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-branch_id">
						<label class="col col-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id">
								<option value=""><cf_get_lang dictionary_id ='30126.Şube Seçiniz'></option>
								<cfoutput query="GET_BRANCH_NAMES">
									<option value="#BRANCH_ID#"<cfif attributes.branch_id eq BRANCH_ID > selected</cfif>>#BRANCH_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-startdate">
						<label class="col col-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi '></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>!</cfsavecontent>
								<cfinput type="text" name="startdate" id="startdate" style="width:65px;" value="#attributes.startdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>                    
							</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-finishdate">
						<label class="col col-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi '></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>!</cfsavecontent>
								<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" value="#attributes.finishdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>                    
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="53100.Sağlık Belgesi"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_flat_list>    
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id ='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
					<th><cf_get_lang dictionary_id ='57453.Şube'></th>
					<th><cf_get_lang dictionary_id ='56031.Hasta'></th>
					<th><cf_get_lang dictionary_id ='53947.Düzenleme Tarihi'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=hr.list_emp_rel_healty&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.ekle'>" alt="<cf_get_lang dictionary_id='57582.ekle'>"></i></a></th>
					<!-- sil -->
					<th width="20" class="text-center"><a><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_emp_healty.recordcount>
					<cfset branch_id_list = ''>
					<cfoutput query="get_emp_healty"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(BRANCH_ID) and not listfind(branch_id_list,BRANCH_ID)>
							<cfset branch_id_list=listappend(branch_id_list,BRANCH_ID)>
						</cfif>
					</cfoutput>
					<cfif len(branch_id_list)>
						<cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
						<cfquery name="get_branch_name" dbtype="query">
							SELECT BRANCH_NAME FROM get_branch_names WHERE BRANCH_ID IN (#branch_id_list#) ORDER BY BRANCH_ID
						</cfquery>
					</cfif>
					<cfoutput query="get_emp_healty"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
							<td><cfif len(branch_id)>#get_branch_name.BRANCH_NAME[listfind(branch_id_list,BRANCH_ID,',')]#</cfif></td>
							<td>#ILL_NAME# #ILL_SURNAME#</td>
							<td>#dateformat(ARRANGEMENT_DATE,dateformat_style)#</td>
							<!-- sil -->
							<td class="text-center" nowrap="nowrap">
								<a href="#request.self#?fuseaction=hr.list_emp_rel_healty&event=upd&doc_id=#doc_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td><!-- sil -->
							<td class="text-center">
								<a href="javascript://" onclick="window.open('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&employee_id=#employee_id#&doc_id=#doc_id#</cfoutput>')"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
							</td>
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="6"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_flat_list> 
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "&keyword=#attributes.keyword#&branch_id=#attributes.branch_id#&startdate=#attributes.startdate#&finishdate=#attributes.finishdate#">
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"    
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="ehesap.list_emp_rel_healty#url_str#">
		</cfif>
	</cf_box>
</div>
<script>
	document.getElementById('keyword').focus();
	function kontrol()
		{
			if( !date_check(document.getElementById('startdate'),document.getElementById('finishdate'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
