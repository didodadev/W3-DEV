<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_dates" default="">
<cfparam name="attributes.finish_dates" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.is_filter" default="">
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_departmens" datasource="#dsn#">
	SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 <cfif len(attributes.BRANCH_ID)> AND BRANCH_ID = #attributes.BRANCH_ID#</cfif>
</cfquery>
<cfif isdefined("attributes.start_dates") and isdate(attributes.start_dates)>
	<cf_date tarih = "attributes.start_dates">
</cfif>
<cfif isdefined("attributes.finish_dates") and isdate(attributes.finish_dates)>
	<cf_date tarih = "attributes.finish_dates">
</cfif>
<cfif isdefined('attributes.is_filter') and attributes.is_filter eq 1>
	<cfquery name="get_shifts" datasource="#dsn#">
		SELECT
			*
		FROM
			SETUP_SHIFTS
		WHERE
			 IS_PRODUCTION = 1
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				AND SHIFT_NAME LIKE  '%#attributes.keyword#%'
			</cfif>
			<cfif isdefined('attributes.start_dates') and len(attributes.start_dates)>AND #attributes.start_dates# >= STARTDATE</cfif>
			<cfif isdefined('attributes.finish_dates') and len(attributes.finish_dates)>AND #attributes.finish_dates# <= FINISHDATE</cfif>
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>AND BRANCH_ID = #attributes.branch_id# </cfif>
			<cfif isdefined('attributes.DEPARTMENT_ID') and len(attributes.DEPARTMENT_ID)>AND DEPARTMENT_ID = #attributes.DEPARTMENT_ID# </cfif>
	</cfquery>
<cfelse>
	<cfset get_shifts.recordcount = 0>
</cfif>
<cfset url_str = "&is_filter=1">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.start_dates)>
	<cfset url_str="#url_str#&start_dates=#dateformat(attributes.start_dates,dateformat_style)#">
</cfif>
<cfif len(attributes.finish_dates)>
	<cfset url_str="#url_str#&finish_dates=#dateformat(attributes.finish_dates,dateformat_style)#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_shifts.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="searc_stations" method="post" action="#request.self#?fuseaction=prod.list_ws_time">
			<input type="hidden" name="is_filter" id="is_filter" value="1">
			<cf_box_search>
				<div class ="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#message#">
				</div>
				<div class ="form-group">
					<select name="branch_id" id="branch_id" style="width:90px;" onChange="get_departments(this.value);">
						<option value=""><cf_get_lang dictionary_id ='57453.Şube'></option>
						<cfoutput query="get_branch">
							<option value="#branch_id#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class ="form-group">
					<select name="department_id" id="department_id" style="width:100px;">
						<option value=""><cf_get_lang dictionary_id ='57572.Departman'></option>
						<cfif len(attributes.branch_id)>
							<cfoutput query="get_departmens">
								<option value="#DEPARTMENT_ID#" <cfif isdefined('attributes.department_id') and len(attributes.department_id) and attributes.department_id eq DEPARTMENT_ID>selected</cfif>>#DEPARTMENT_HEAD#</option>
							</cfoutput>
						</cfif>
					</select>
				</div>
				<div class ="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput name="start_dates" validate="#validate_style#" maxlength="10" placeholder="#place#" value="#dateformat(attributes.start_dates,dateformat_style)#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_dates"></span>
					</div>
				</div>
				<div class ="form-group">
					<div class="input-group">
						<cfsavecontent variable="place2"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput name="finish_dates" validate="#validate_style#" maxlength="10" placeholder="#place2#" value="#dateformat(attributes.finish_dates,dateformat_style)#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_dates"></span>
					</div>
				</div>
				<div class ="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
				</div>
				<div class ="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='36795.Çalışma'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list> 
			<thead>
				<tr> 
					<th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id ='36905.Vardiya'></th>
					<th><cf_get_lang dictionary_id ='57453.Şube'></th>
					<th><cf_get_lang dictionary_id ='57572.Departman'></th>
					<th><cf_get_lang dictionary_id ='58624.Geçerlilik Tarihi'></th>
					<th><cf_get_lang dictionary_id ='58467.Başlama'></th>
					<th><cf_get_lang dictionary_id ='57502.Bitiş'></th>
					<th><cf_get_lang dictionary_id ='57609.Cumartesi'></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=prod.list_ws_time&event=add&is_production=1</cfoutput>" ><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"/></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_shifts.recordcount>
					<cfoutput query="get_shifts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset _BRANCHID_ = BRANCH_ID >
						<cfset _DEPARTMENTID_ = DEPARTMENT_ID>
						<tr> 
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=prod.list_ws_time&event=upd&shift_id=#shift_id#&is_production=1" class="tableyazi" >#shift_name#</a></td>
							<td><cfloop query="get_branch">
									<cfif  get_branch.BRANCH_ID eq _BRANCHID_>#BRANCH_NAME#</cfif>
								</cfloop>
							</td>
							<td><cfloop query="get_departmens">
									<cfif  get_departmens.DEPARTMENT_ID eq _DEPARTMENTID_>#DEPARTMENT_HEAD#</cfif>
								</cfloop>
							</td>
							<td>#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#</td>
							<td><cfset time_ ="#numberformat(start_hour,'00')#:#numberformat(start_min,'00')#"><cfif time_ eq '24:00'><cfset time_="00:00"></cfif> #timeformat(time_,timeformat_style)#</td>
							<td><cfset time_end ="#numberformat(end_hour,'00')#:#numberformat(end_min,'00')#"><cfif time_end eq '24:00'><cfset time_end="00:00"></cfif> #timeformat(time_end,timeformat_style)#</td>
							<td><cfif std_start_hour neq 0><cfset std_start ="#numberformat(std_start_hour,'00')#:#numberformat(std_start_min,'00')#"><cfset std_finish ="#numberformat(std_end_hour,'00')#:#numberformat(std_end_hour,'00')#">#timeformat(std_start,timeformat_style)# - #timeformat(std_finish,timeformat_style)#</cfif></td>
							<!-- sil --><td><a href="#request.self#?fuseaction=prod.list_ws_time&event=upd&shift_id=#shift_id#&is_production=1" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"/></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="11"><cfif attributes.is_filter eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>								
			</tbody>
		</cf_grid_list>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="prod.list_ws_time#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
	{
		if(document.getElementById('finish_dates').value != '' && document.getElementById('start_dates').value != '')
		{
			if( !date_check(document.getElementById('start_dates'),document.getElementById('finish_dates'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
		else
			return true;
	}
	function get_departments(branch_id)
	{
		var get_dep = wrk_safe_query('prdp_get_dep','dsn',0,branch_id)
		document.searc_stations.department_id.options.length=0;
		document.searc_stations.department_id.options[0] = new Option('Departman','');
		if (get_dep.recordcount)
		{
			for(var jj=0;jj<get_dep.recordcount;jj++)
			document.searc_stations.department_id.options[jj+1] = new Option(get_dep.DEPARTMENT_HEAD[jj],get_dep.DEPARTMENT_ID[jj]);
		}
	}
</script>
