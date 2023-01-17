<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_year" default="#year(now())#">
<cfparam name="attributes.search_company" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfquery name="get_our_company" datasource="#dsn#"><!--- yetkili olunan sirketler --->
	SELECT DISTINCT
		OC.COMP_ID,
		OC.COMPANY_NAME
	FROM 
		SETUP_PERIOD SP,
		OUR_COMPANY OC
	WHERE
		SP.OUR_COMPANY_ID = OC.COMP_ID AND
		SP.PERIOD_ID IN (SELECT 
							EPP.PERIOD_ID
						FROM
							EMPLOYEE_POSITIONS EP,
							EMPLOYEE_POSITION_PERIODS EPP
						WHERE
							EP.POSITION_ID = EPP.POSITION_ID AND
							EP.POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	ORDER BY
		OC.COMPANY_NAME
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_ALL_BUDGETS" datasource="#dsn#">
		SELECT 
			B.BUDGET_ID,
            B.BUDGET_NAME,
            B.RECORD_DATE,
            PTR.STAGE,
            C.COMPANY_NAME
		FROM 
			BUDGET B, 
            PROCESS_TYPE_ROWS PTR,
            OUR_COMPANY C
		WHERE
			B.BUDGET_ID IS NOT NULL AND
            PTR.PROCESS_ROW_ID = B.BUDGET_STAGE
            AND C.COMP_ID=B.OUR_COMPANY_ID
		<cfif len(attributes.keyword)>
			AND B.BUDGET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>	
		<cfif len(attributes.search_year)>
			AND B.PERIOD_YEAR =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_year#">
		</cfif>
		<cfif len(attributes.search_company)>
			AND B.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_company#">
		<cfelse>
			AND B.OUR_COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#valuelist(get_our_company.comp_id,',')#">)
		</cfif>
		<cfif len(attributes.process_stage_type)>
			AND B.BUDGET_STAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_stage_type#"> 
		</cfif>
	</cfquery>
<cfelse> 
	<cfset GET_ALL_BUDGETS.recordcount = 0>
</cfif>

<cfquery name="get_service_stage" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%budget.list_budget%"> 
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_all_budgets.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_budget"  method="post" action="#request.self#?fuseaction=budget.list_budgets">
			<input name="form_submitted" id="form_submitted" type="hidden" value="1">
			<cf_box_search more="0">
				<cfoutput>
					<div class="form-group" id="form_ul_keyword">
						<cfsavecontent variable="placeholder"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<div class="input-group"><input type="text" name="keyword" maxlength="50" placeholder="#placeholder#" value="#attributes.keyword#"></div>
					</div>
					<div class="form-group" id="form_ul_keyword">
						<div class="input-group">
							<select name="search_company" id="search_company">
								<option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>						
								<cfloop query="get_our_company">
									<option value="#comp_id#" <cfif attributes.search_company eq comp_id>selected</cfif>>#company_name#</option>
								</cfloop>
							</select>
						</div>
					</div> 
					<div class="form-group" id="form_ul_keyword">
						<div class="input-group">
							<select name="search_year" id="search_year">
								<option value=""><cf_get_lang dictionary_id='58472.Dönem'></option>						
								<cfloop from="#evaluate(SESSION.EP.PERIOD_YEAR-1)#" to="#evaluate(SESSION.EP.PERIOD_YEAR+4)#" index="k">
									<option value="#k#" <cfif attributes.search_year eq k>selected</cfif>>#k#</option>
								</cfloop>
							</select>
						</div>
					</div>    
					<div class="form-group" id="form_ul_keyword">
						<div class="input-group">
							<select name="process_stage_type" id="process_stage_type" style="width:125px;">
								<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
								<cfloop query="get_service_stage">
									<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group">
						<div class="input-group small">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
						</div>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					</div>
				</cfoutput>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='57524.Bütçeler'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57559.Bütçe'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_budgets&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_all_budgets.recordcount>
					<cfoutput query="get_all_budgets" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=budget.list_budgets&event=det&budget_id=#BUDGET_ID#" class="tableyazi">#BUDGET_NAME#</a></td>
							<td>#COMPANY_NAME#</td>
							<td>#STAGE#</td>
							<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
							<!-- sil -->
							<td><a href="#request.self#?fuseaction=budget.list_budgets&event=det&budget_id=#BUDGET_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>  
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "">
		<cfif isdefined ("attributes.form_submitted") and len (attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif> 
		<cfif len(attributes.search_year)>
			<cfset url_str = "#url_str#&search_year=#attributes.search_year#">
		</cfif>
		<cfif len(attributes.search_company)>
			<cfset url_str = "#url_str#&search_company=#attributes.search_company#">
		</cfif>
		<cfif len(attributes.process_stage_type)>
			<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="budget.list_budgets#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
