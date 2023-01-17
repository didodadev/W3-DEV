<cf_xml_page_edit fuseact="ehesap.list_salary">
<cf_get_lang_set module_name="ehesap">
<cfset url_str = "">
<!--- 
<cfset session.ep.DOCKPHONE = 3>
<cf_wrk_crypto_gdpr isenc="1" refcol="SALARY_HISTORY_ID">
 --->
<cfif not isdefined("attributes.keyword")>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.upper_salary_range" default="">
<cfparam name="attributes.lower_salary_range" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.salary_year" default="#year(now())#">
<cfparam name="attributes.salary_month" default="#dateformat(now(),'m')#">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.ssk_statute" default="">
<cfparam name="attributes.duty_type" default="">
<cfparam name="attributes.defection_level" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.salary_type" default="">
<cfparam name="attributes.law_numbers" default="">
<cfparam name="attributes.law_startdate" default="">
<cfparam name="attributes.law_finishdate" default="">
<cfif not isdefined('attributes.status_isactive')>
	<cfset attributes.status_isactive = 1>
</cfif>
<cfif len(attributes.hierarchy)>
	<cfset url_str = "#url_str#&hierarchy=#attributes.hierarchy#">
</cfif>
<cfif len(attributes.collar_type)>
	<cfset url_str = "#url_str#&collar_type=#attributes.collar_type#">
</cfif>
<cfif len(attributes.duty_type)>
	<cfset url_str = "#url_str#&duty_type=#attributes.duty_type#">
</cfif>
<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
<cfset url_str = '#url_str#&status_isactive=#attributes.status_isactive#'>
<cfset url_str = '#url_str#&salary_year=#attributes.salary_year#'>
<cfset url_str = '#url_str#&salary_month=#attributes.salary_month#'>
<cfset url_str = '#url_str#&ssk_statute=#attributes.ssk_statute#'>
<cfset url_str = '#url_str#&salary_type=#attributes.salary_type#'>
<cfset url_str = '#url_str#&duty_type=#attributes.duty_type#'>
<cfset url_str = '#url_str#&defection_level=#attributes.defection_level#'>
<cfset url_str = '#url_str#&upper_salary_range=#attributes.upper_salary_range#'>
<cfset url_str = '#url_str#&lower_salary_range=#attributes.lower_salary_range#'>
<cfif isdefined('attributes.branch_id')>
	<cfset url_str = '#url_str#&branch_id=#attributes.branch_id#'>
</cfif>
<cfif isdefined('attributes.department')>
	<cfset url_str = '#url_str#&department=#attributes.department#'>
</cfif>
<cfif isdefined('attributes.status_sabit_prim')>
	<cfset url_str = '#url_str#&status_sabit_prim=#attributes.status_sabit_prim#'>
</cfif>
<cfif isdefined('attributes.ssk_status')>
	<cfset url_str = '#url_str#&ssk_status=#attributes.ssk_status#'>
</cfif>
<cfif isdefined('attributes.collar_type')>
	<cfset url_str = '#url_str#&collar_type=#attributes.collar_type#'>
</cfif>
<cfif len(attributes.law_numbers)>
	<cfset url_str = '#url_str#&law_numbers=#attributes.law_numbers#'>
</cfif>
<cfif len(attributes.law_startdate)>
	<cfset url_str = '#url_str#&law_startdate=#attributes.law_startdate#'>
</cfif>
<cfif len(attributes.law_finishdate)>
	<cfset url_str = '#url_str#&law_finishdate=#attributes.law_finishdate#'>
</cfif>
<cfif not session.ep.ehesap>
	<cfinclude template="../query/get_branch_deps.cfm">
	<cfif get_branch_dep.recordcount>
		<cfset dep_list=ValueList(get_branch_dep.DEPARTMENT_ID)>
	<cfelse>
		<cfset dep_list=0>
	</cfif>
</cfif>
<cfif arama_yapilmali>
	<cfset get_salary_list.recordcount = 0>
<cfelse>
<cfinclude template="../query/get_salary_list.cfm">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_salary_list.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfinclude template="list_salary_search.cfm">
	<cfset cols_ =10>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='56118.ücret ödenek'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list>   
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<cfif is_get_sgkno eq 1>
						<th><cf_get_lang dictionary_id='53237.SSK No'></th><cfset cols_ = cols_ + 1>
					</cfif>
					<th><cf_get_lang dictionary_id="54265.TC No"></th>
					<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='53127.Ücret'></th>
					<cfif is_get_FMbilgisi eq 1>
						<th><cf_get_lang dictionary_id="53539.FM"></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='53589.Fazla Mesai Ücret'></th>
						<th><cf_get_lang dictionary_id='53590.Toplam Ücret'></th><cfset cols_ = cols_ + 3>
					</cfif>
					<th><cf_get_lang dictionary_id='53131.Brüt'>/<cf_get_lang dictionary_id='58083.Net'></th>
					<th><cf_get_lang dictionary_id='29472.Yöntem'></th>
					<th><cf_get_lang dictionary_id='57501.Başlama'></th>
					<cfif is_get_kidemtrh eq 1>
						<th nowrap="nowrap"><cf_get_lang dictionary_id="53512.Kıdem Tarihi"></th><cfset cols_ = cols_ + 1>
					</cfif>
					<cfif show_average_salary eq 1>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='62729.Aylık Ortalama Net'></th><cfset cols_ = cols_ + 1>
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif get_salary_list.recordcount>
				<cfset employee_id_list = ''>
				<cfset salary_in_out_id_list = ''>
				<cfset new_salary_in_out_id_list = ''>
				<cfset new_employee_id_list = ''>
				<cfoutput query="get_salary_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif duty_type eq 8>
						<cfset employee_id_list = listappend(employee_id_list,EMPLOYEE_ID,',')>
					<cfelse>	
						<cfset salary_in_out_id_list = listappend(salary_in_out_id_list,IN_OUT_ID,',')>
					</cfif>
				</cfoutput>
				<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
				<cfset salary_in_out_id_list=listsort(salary_in_out_id_list,"numeric","ASC",",")>
				<cfif listlen(salary_in_out_id_list)><!--- normal çalışanlar için maaş getiriliyor --->
					<cfquery name="get_maas_all" datasource="#dsn#">
						SELECT
							SALARY_HISTORY_ID,
							M#attributes.salary_month# AS MAAS,
							MONEY AS SALARY_MONEY,
							IN_OUT_ID
						FROM 
							EMPLOYEES_SALARY 
						WHERE
							IN_OUT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#salary_in_out_id_list#">) AND
							PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#">
						ORDER BY
							IN_OUT_ID
					</cfquery>
					<cfset new_salary_in_out_id_list = listsort(valuelist(get_maas_all.IN_OUT_ID,','),'numeric','ASC',',')>
				</cfif>
				<cfif listlen(employee_id_list)><!--- derece kademe tipli olanlarda maaş hesabı yapılıyor --->
					<cfscript>
						parameter_last_month_1 = CreateDateTime(attributes.salary_year,attributes.salary_month,1,0,0,0);
						parameter_last_month_30 = CreateDateTime(attributes.salary_year,attributes.salary_month,daysinmonth(createdate(attributes.salary_year,attributes.salary_month,1)),0,0,0);
					</cfscript>
					<cfquery name="get_factor_definition" datasource="#dsn#" maxrows="1">
						SELECT SALARY_FACTOR,BASE_SALARY_FACTOR,BENEFIT_FACTOR FROM SALARY_FACTOR_DEFINITION WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_1#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> 
					</cfquery>
					<cfif get_factor_definition.recordcount>
						<cfquery name="get_maas_all_new" datasource="#dsn#">
							SELECT
								EMPLOYEE_ID,
								(EXTRA+GRADE_VALUE)*#get_factor_definition.SALARY_FACTOR# MAAS
							FROM
							(
								SELECT
									EMPLOYEE_ID,
									EXTRA,
									CASE 
									WHEN STEP = 1 THEN GRADE1_VALUE
									WHEN STEP = 2 THEN GRADE2_VALUE
									WHEN STEP = 3 THEN GRADE3_VALUE
									WHEN STEP = 4 THEN GRADE4_VALUE
									END AS GRADE_VALUE
								FROM
									SALARY_FACTORS,
									EMPLOYEES_RANK_DETAIL ER
								WHERE
									ER.PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> 
									AND ER.PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> 
									AND ER.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#employee_id_list#">)
									AND SALARY_FACTORS.GRADE = ER.GRADE
							)T1
							ORDER BY
								EMPLOYEE_ID
						</cfquery>
						<cfset new_employee_id_list = listsort(valuelist(get_maas_all_new.EMPLOYEE_ID,','),'numeric','ASC',',')>
					</cfif>
				</cfif>
				<cfsavecontent variable="action_">
					<cfif listgetat(attributes.fuseaction,1,'.') is 'hr'>hr.list_salary&event=det<cfelse>ehesap.list_salary&event=upd</cfif>
				</cfsavecontent>
				<cfoutput query="get_salary_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr<cfif len(FINISH_DATE)>style="color:ff0000;"</cfif>>	
						<cfset maas_ = -1>
						<cfif duty_type neq 8 and listfind(new_salary_in_out_id_list,IN_OUT_ID,',')>
							<cfset maas_ = get_maas_all.MAAS[listfind(new_salary_in_out_id_list,IN_OUT_ID,',')]>
							<cfset maas_money_ = get_maas_all.SALARY_MONEY[listfind(new_salary_in_out_id_list,IN_OUT_ID,',')]>
						<cfelseif duty_type eq 8 and listfind(new_employee_id_list,EMPLOYEE_ID,',')>
							<cfset maas_ = get_maas_all_new.MAAS[listfind(new_employee_id_list,EMPLOYEE_ID,',')]>
							<cfset maas_money_ = session.ep.money>
						</cfif>
						<td>#currentrow#</td>
						<td>#employee_no#</td>
						<cfif is_get_sgkno eq 1>
							<td>#SOCIALSECURITY_NO#</td>
						</cfif>
						<td><cf_duxi name='tc_identity_no' class="tableyazi" type="label" value="#TC_IDENTY_NO#" gdpr="2"></td>
						<td><a class="tableyazi" href="#request.self#?fuseaction=#trim(action_)#&employee_id=#employee_id#&in_out_id=#in_out_id#&empName=#UrlEncodedFormat('#employee_name# #employee_surname#')#"><cfif len (FINISH_DATE)><font color="FF0000">#employee_name# #employee_surname#</font><cfelse>#employee_name# #employee_surname#</cfif></a></td>
						<td>#branch_name#</td>
						<td>#DEPARTMENT_HEAD#</td>
						<td  style="text-align:right;">
							<a class="tableyazi" href="#request.self#?fuseaction=#trim(action_)#&employee_id=#employee_id#&in_out_id=#in_out_id#&empName=#UrlEncodedFormat('#employee_name# #employee_surname#')#">
							<cfif isdefined("maas_") and maas_ neq -1>
								<cf_duxi name='maas_' class="tableyazi" type="label" value="#tlformat(maas_)# #maas_money_#" gdpr="7">
							<cfelse>
								<font color="FF0000"><cf_get_lang dictionary_id='58845.Tanımsız'></font>
							</cfif>
							</a>
						</td>
							<cfif is_get_FMbilgisi eq 1>
						<td><cfif listfind(new_salary_in_out_id_list,IN_OUT_ID,',')>#fazla_mesai_saat#<cfelse>-</cfif></td>
						<td  style="text-align:right;">
							<cfif isnumeric(fazla_mesai_saat) and isdefined("maas_") and maas_ neq -1>
								<cfset ft = (maas_ / 225) * fazla_mesai_saat * 1.5>
								<cfset tm = maas_ + ft>
								<cf_duxi name='fazla_mesai_ucret' class="tableyazi" type="label" value="#tlformat(ft)# #maas_money_#" gdpr="7">
								<cfelse>
								<cf_get_lang dictionary_id='58845.Tanımsız'>
							</cfif>							
						</td>
						<td  style="text-align:right;">
							<cfif isnumeric(fazla_mesai_saat) and isdefined("maas_") and maas_ neq -1>
								<cf_duxi name='toplam_ucret' class="tableyazi" type="label" value="#tlformat(tm)# #maas_money_#" gdpr="7">
							<cfelse>
								<cf_get_lang dictionary_id='58845.Tanımsız'>
							</cfif>							
						</td>
						</cfif>
						<td><cfif get_salary_list.gross_net><cf_get_lang dictionary_id='58083.Net'><cfelse><cf_get_lang dictionary_id='53131.Brüt'></cfif></td>
						<td>
							<cfif salary_type eq 0><cf_get_lang dictionary_id='57491.Saat'>
								<cfelseif salary_type eq 1><cf_get_lang dictionary_id='57490.Gün'>
								<cfelseif salary_type eq 2><cf_get_lang dictionary_id='58724.Ay'>
							</cfif>							</td>
						<td>#dateformat(STARTDATE,dateformat_style)#</td>
						<cfif is_get_kidemtrh eq 1>
						<td>#dateformat(KIDEM_DATE,dateformat_style)#</td>
						</cfif>
						<cfif show_average_salary eq 1>
							<td>
								<cf_duxi name='MONTHLY_AVERAGE_NET_' class="tableyazi" type="label" value="#tlFormat(MONTHLY_AVERAGE_NET)#" gdpr="7">
							</td>
						</cfif>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#cols_#</cfoutput>"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>  
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="ehesap.list_salary#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = document.search.branch_id.value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
	}
	function control_()
	{
		document.search.lower_salary_range.value = filterNum(document.search.lower_salary_range.value);
		document.search.upper_salary_range.value = filterNum(document.search.upper_salary_range.value);
		if ( (document.getElementById('law_startdate').value.length != 0)&&(document.getElementById('law_finishdate').value.length != 0) )
			{return date_check(document.getElementById('law_startdate'),document.getElementById('law_finishdate'),"<cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>");}
	}
	function date_view()
	{
		if(document.getElementById('law_numbers').value == '6111' || document.getElementById('law_numbers').value == '5763')
		{
			date_.style.display = '';
		}
		else
		{
			date_.style.display = 'none';
			document.getElementById('law_startdate').value = "";
			document.getElementById('law_finishdate').value = "";
		}
	}
</script>
<cf_get_lang_set module_name="#listgetat(attributes.fuseaction,1,'.')#">
