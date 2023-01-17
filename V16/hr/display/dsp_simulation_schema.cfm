<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
<cfquery name="GET_SIMULATION" datasource="#dsn#">
	SELECT 
		ORGANIZATION_SIMULATION.SIMULATION_ID,
		ORGANIZATION_SIMULATION.SIMULATION_HEAD,
		ORGANIZATION_SIMULATION.RECORD_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME AS POS_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS POS_SURNAME,
		EMPLOYEE_POSITIONS.POSITION_NAME
	FROM 
		ORGANIZATION_SIMULATION,
		EMPLOYEES,
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEES.EMPLOYEE_ID = ORGANIZATION_SIMULATION.EMPLOYEE_ID AND 
		EMPLOYEE_POSITIONS.POSITION_CODE = ORGANIZATION_SIMULATION.POSITION_CODE
		<cfif len(attributes.keyword)>AND ORGANIZATION_SIMULATION.SIMULATION_HEAD LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI </cfif>
	ORDER BY 
		ORGANIZATION_SIMULATION.SIMULATION_ID 
	DESC
</cfquery>
<cfelse>
	<cfset get_simulation.recordcount=0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_simulation.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_app" action="#request.self#?fuseaction=hr.dsp_simulation_schema" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent  variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#?fuseaction=hr.dsp_simulation_schema&event=add</cfoutput>"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(1294,'Organizasyon Simulatör',56379)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='56397.Simülasyon'></th>
					<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='57576.Calisan'></th>
					<th width="180"><cf_get_lang dictionary_id ='57483.Kayit'></th>
					<!-- sil --><th width="20"><a href="<cfoutput>#request.self#?fuseaction=hr.dsp_simulation_schema&event=add</cfoutput>"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_simulation.recordcount>
					<cfoutput query="get_simulation" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">	
					<tr>
						<td>#currentrow#</td>
						<td>#simulation_head#</td>
						<td>#position_name#</td>
						<td>#pos_name# #pos_surname#</td>
						<td>#employee_name# #employee_surname# - #dateformat(record_date,dateformat_style)#</td>
						<!-- sil -->
						<td><a href="#request.self#?fuseaction=hr.dsp_simulation_schema&event=upd&simulation_id=#simulation_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Guncelle'>" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a></td>
						<!-- sil -->
					</tr>
					</cfoutput>
				<cfelse>
					<tr class="color-row" height="20">
						<td colspan="11"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayit Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.maxrows lt attributes.totalrecords>
			
			<cfset url_str = "">
			<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
				<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
			</cfif>
			<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
				<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
			</cfif>
			<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cf_paging page="#attributes.page#"
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="hr.dsp_simulation_schema#url_str#">
		
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
