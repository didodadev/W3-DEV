<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.plan_year" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.sale_scope" default="">
<cfparam name="attributes.is_form_submitted" default="">
<cfparam name="attributes.sales_county" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfif isDefined("attributes.is_form_submitted")>
	<cfquery name="get_sales_quota" datasource="#dsn#">
		SELECT
			*
		FROM
			SALES_QUOTES_GROUP
		WHERE 
			IS_PLAN = 1
			<cfif len(attributes.keyword)>
				AND PAPER_NO LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			</cfif>	
			<cfif len(attributes.process_stage_type)>
				AND PROCESS_STAGE = #attributes.process_stage_type#
			</cfif>
			<cfif len(attributes.plan_year)>
				AND QUOTE_YEAR = #attributes.plan_year#
			</cfif>
			<cfif len(attributes.sale_scope)>
				AND QUOTE_TYPE= #attributes.sale_scope#
			</cfif>
			<cfif isdefined('attributes.sales_county') and len(attributes.sales_county)>
				AND SALES_ZONE_ID = #attributes.sales_county#
			</cfif>
		ORDER BY
			PLAN_DATE
	</cfquery>
<cfelse>
	<cfset get_sales_quota.recordcount = 0>
</cfif>
<cfquery name="get_sz" datasource="#dsn#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_sales_quota.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_quota" action="#request.self#?fuseaction=salesplan.list_sales_plan_quotas" method="post">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="hidden" name="is_form_submitted" value="1">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#place#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="sales_county" id="sales_county" style="width:100px;">
						<option value=""><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>
						<cfoutput query="get_sz">
							<option value="#sz_id#" <cfif isdefined("attributes.sales_county") and sz_id eq attributes.sales_county>selected</cfif>>#sz_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cfquery name="get_stage" datasource="#dsn#">
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
							PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%salesplan.list_sales_plan_quotas%">
						ORDER BY
							PTR.LINE_NUMBER
					</cfquery>
					<select name="process_stage_type" id="process_stage_type" style="width:125px;">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_stage">
							<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>	
				</div>                    
				<div class="form-group">
					<select name="plan_year" id="plan_year" style="width:120px;">
						<option value=""><cf_get_lang dictionary_id='58472.Dönem'></option>
						<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+3#" index="i">
							<cfoutput>
								<option value="#i#" <cfif i eq attributes.plan_year>selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					</select>                     
				</div>                    
				<div class="form-group">
					<select name="sale_scope" id="sale_scope" style="width:120px;">
						<option value=""><cf_get_lang dictionary_id='41602.Kapsam'></option>
						<option value="1" <cfif attributes.sale_scope eq 1>selected</cfif>><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>
						<option value="2" <cfif attributes.sale_scope eq 2>selected</cfif>><cf_get_lang dictionary_id='57453.Şube'></option>
						<option value="3" <cfif attributes.sale_scope eq 3>selected</cfif>><cf_get_lang dictionary_id='41478.Satış Takımı'></option>
						<option value="4" <cfif attributes.sale_scope eq 4>selected</cfif>><cf_get_lang dictionary_id='41603.Mikro Bölge'></option>
						<option value="5" <cfif attributes.sale_scope eq 5>selected</cfif>><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
						<option value="6" <cfif attributes.sale_scope eq 6>selected</cfif>><cf_get_lang dictionary_id='58673.Müşteriler'></option>
						<option value="7" <cfif attributes.sale_scope eq 7>selected</cfif>><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></option>
						<option value="8" <cfif attributes.sale_scope eq 8>selected</cfif>><cf_get_lang dictionary_id='41606.Markalar'></option>
						<option value="9" <cfif attributes.sale_scope eq 9>selected</cfif>><cf_get_lang dictionary_id='41607.Üye Kategorileri'></option>
					</select>                    
				</div> 
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">	
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>                                                     
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='58161.Satış Planları'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='58472.Dönem'></th>
					<th><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th>
					<th><cf_get_lang dictionary_id='41602.Kapsam'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57756.Süreç'></th>
					<th><cf_get_lang dictionary_id='41560.Planlayan'></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=salesplan.list_sales_plan_quotas&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
				</tr>
			</thead>
			<tbody>
				<cfif isDefined("attributes.is_form_submitted") and get_sales_quota.recordcount and form_varmi eq 1>
					<cfset emp_id_list=''>
					<cfset process_list=''>
					<cfset sales_zone_list = ''>
					<cfoutput query="get_sales_quota" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(planner_emp_id) and not listfind(emp_id_list,planner_emp_id)>
							<cfset emp_id_list=listappend(emp_id_list,planner_emp_id)>
						</cfif>
						<cfif len(process_stage) and not listfind(process_list,process_stage)>
							<cfset process_list = listappend(process_list,process_stage)>
						</cfif>
						<cfif len(sales_zone_id) and not listfind(sales_zone_list,sales_zone_id)>
							<cfset sales_zone_list = listappend(sales_zone_list,sales_zone_id)>
						</cfif>
					</cfoutput>
					<cfif listlen(emp_id_list)>
						<cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
						<cfquery name="GET_EMP" datasource="#DSN#">
							SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfif listlen(process_list)>
						<cfset process_list=listsort(process_list,"numeric","ASC",",")>
						<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
							SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#)
						</cfquery>
					</cfif> 
					<cfif len(sales_zone_list)>
						<cfset sales_zone_list=listsort(sales_zone_list,"numeric","ASC",",")>
						<cfquery name="GET_SALES_ZONE" datasource="#DSN#">
							SELECT SZ_NAME,SZ_ID FROM SALES_ZONES WHERE SZ_ID IN (#sales_zone_list#)
						</cfquery>
						<cfset sales_zone_list = listsort(listdeleteduplicates(valuelist(GET_SALES_ZONE.SZ_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="GET_SALES_QUOTA" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><!---<a href="#request.self#?fuseaction=salesplan.form_upd_sales_plan_quota&plan_id=#sales_quote_id#" class="tableyazi">#paper_no#</a>--->
								<a href="#request.self#?fuseaction=salesplan.list_sales_plan_quotas&event=upd&plan_id=#sales_quote_id#" class="tableyazi">#paper_no#</a>
							</td>
							<td>#dateformat(plan_date,dateformat_style)#</td>
							<td>#quote_year#</td>
							<td>
								<cfif len(sales_zone_id)>
									#get_sales_zone.sz_name[listfind(sales_zone_list,sales_zone_id,',')]#
								</cfif>
							</td>
							<td>
								<cfif quote_type eq 1>
									<cf_get_lang dictionary_id='57659.Satış Bölgesi'>
								<cfelseif quote_type eq 2>
									<cf_get_lang dictionary_id='57453.Şube'>
								<cfelseif quote_type eq 3>
									<cf_get_lang dictionary_id='41478.Satış Takımı'>
								<cfelseif quote_type eq 4>
									<cf_get_lang dictionary_id='41603.Mikro Bölge'>
								<cfelseif quote_type eq 5>
									<cf_get_lang dictionary_id='58875.Çalışanlar'>
								<cfelseif quote_type eq 6>
									<cf_get_lang dictionary_id='58673.Müşteriler'>
								<cfelseif quote_type eq 7>
									<cf_get_lang dictionary_id='57567.Ürün Kategorileri'>
								<cfelseif quote_type eq 8>
									<cf_get_lang dictionary_id='41606.Markalar'>
								<cfelseif quote_type eq 9>
									<cf_get_lang dictionary_id='41607.Üye Kategorileri'>
								</cfif>
							</td>
							<td>#quote_detail#</td>
							<td>#get_process_type.stage[listfind(process_list,process_stage,',')]#</td>
							<td>
							<cfif len(planner_emp_id)>
								#get_emp.employee_name[listfind(emp_id_list,planner_emp_id,',')]# #get_emp.employee_surname[listfind(emp_id_list,planner_emp_id,',')]#
							</cfif>
							</td>
							<td>
								<a href="#request.self#?fuseaction=salesplan.list_sales_plan_quotas&event=upd&plan_id=#sales_quote_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
						</tr>
					</cfoutput>          
				<cfelse>
					<tr>
						<td colspan="12"><cfif form_varmi eq 0><cf_get_lang dictionary_id="57701.Filtre Ediniz">!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "salesplan.list_sales_plan_quotas">
		<cfif len(attributes.is_form_submitted) and len (attributes.is_form_submitted)>
			<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
		</cfif> 
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif> 
		<cfif len(attributes.process_stage_type)>
			<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#">
		</cfif>
		<cfif len(attributes.sale_scope)>
			<cfset url_str = "#url_str#&sale_scope=#attributes.sale_scope#">
		</cfif>
		<cfif len(attributes.plan_year)>
			<cfset url_str = "#url_str#&plan_year=#attributes.plan_year#">
		</cfif>
		<cfif len(attributes.sales_county)>
			<cfset url_str = "#url_str#&sales_county=#attributes.sales_county#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.list_quota.keyword.focus();
</script>
