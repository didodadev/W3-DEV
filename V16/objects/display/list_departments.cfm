<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfif form_varmi eq 1>
	<cfset get_departments.recordCount=0>
</cfif>
<!--- is_function parametresi acilan sayfada bir takim degisiklikler yapilması istenitorsa kullanilir. --->
<cfset url_string = "">
<cfinclude template="../../hr/query/get_our_comp_name.cfm">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_store_id") and len(attributes.is_store_id)>
	<cfset url_string = "#url_string#&is_store_id=1">
</cfif>
<!--- is_store_module : şube modülünden geldiyse yetkili olduğu depoları listelemek için --->
<cfif isdefined("attributes.is_store_module") and len(attributes.is_store_module)>
	<cfset url_string = "#url_string#&is_store_module=1">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.branch_id")>
	<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.branch_name")>
	<cfset url_string = "#url_string#&branch_name=#attributes.branch_name#">
</cfif>
<cfif isdefined("attributes.field_dep_branch_name")>
	<cfset url_string = "#url_string#&field_dep_branch_name=#attributes.field_dep_branch_name#">
</cfif>
<cfif isdefined("attributes.is_function")>
	<cfset url_string = "#url_string#&is_function=#attributes.is_function#">
</cfif>
<cfif isdefined("attributes.number")>
	<cfset url_string = "#url_string#&number=#attributes.number#">
</cfif>
<cfif isdefined("attributes.is_all_departments")>
	<cfset url_string = "#url_string#&is_all_departments=1">
</cfif>
<cfquery name="GET_DEPARTMENTS" datasource="#dsn#">
	SELECT 
		D.DEPARTMENT_STATUS,
		D.DEPARTMENT_HEAD,
		O.NICK_NAME,
		B.BRANCH_NAME,
		D.DEPARTMENT_ID,
		D.BRANCH_ID
	FROM 
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY O 
	WHERE 
		D.BRANCH_ID = B.BRANCH_ID AND 
		B.COMPANY_ID = O.COMP_ID
	  <cfif isdefined("attributes.par_id") and len(attributes.par_id)>
		AND D.IS_STORE <> 2
	  </cfif>
	  <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND (
				D.DEPARTMENT_HEAD LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
				B.BRANCH_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
			)
	  </cfif>
	  <cfif isdefined("attributes.search_our_company_id") and len(attributes.search_our_company_id)>
		AND O.COMP_ID = #attributes.search_our_company_id#
	  </cfif>
	  <cfif isdefined("attributes.search_branch_id") and len(attributes.search_branch_id)>
		AND D.BRANCH_ID = #attributes.search_branch_id#
	  </cfif>
	  <cfif (not session.ep.ehesap and not isdefined("attributes.is_all_departments")) or isdefined("attributes.is_store_module")>
		AND D.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									POSITION_CODE = #session.ep.position_code#
							)
	  </cfif>
		AND D.DEPARTMENT_STATUS = 1
	ORDER BY
		NICK_NAME,
		BRANCH_NAME,
		DEPARTMENT_HEAD
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_departments.recordCount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Tüm Departmanlar',32934)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="search_asset_departments" action="#request.self#?fuseaction=objects.popup_list_departments#url_string#" method="post">
			<cf_box_search more="0">
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" maxlength="50" value="#attributes.keyword#">
				</div>
				<div class="form-group">
					<select name="search_our_company_id" id="search_our_company_id">
						<option value=""><cf_get_lang dictionary_id='54096.Şirket Seçiniz'></option>
						<cfoutput query="get_company_name">
							<option value="#comp_id#" <cfif isdefined("attributes.search_our_company_id") and attributes.search_our_company_id eq comp_id>selected</cfif>>#nick_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_asset_departments' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='58763.Depo'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_departments.recordcount and form_varmi eq 1>
					<cfoutput query="get_departments" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#nick_name#</td>
							<td>#branch_name#</td>
							<td><a href="javascript://" onClick="add_store('#department_id#','#department_head#','<cfif isdefined('branch_id') and len(branch_id)>#branch_id#</cfif>','<cfif isdefined('branch_name') and len(branch_name)>#branch_name#</cfif>','<cfif isdefined('branch_id') and len(branch_id)>#branch_name# - </cfif>#department_head#')">#department_head#</a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="3"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif form_varmi eq 1>
				<cfset url_string = "#url_string#&is_form_submitted=1">
				<cfif len(attributes.keyword)>
					<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
				</cfif>
				<cfif isdefined("attributes.search_branch_id")>
					<cfset url_string = "#url_string#&search_branch_id=#attributes.search_branch_id#">
				</cfif>
				<cfif isdefined("attributes.search_our_company_id")>
					<cfset url_string = "#url_string#&search_our_company_id=#attributes.search_our_company_id#">
				</cfif>
				<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="objects.popup_list_departments#url_string#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			</cfif>
		</cfif>		
	</cf_box>
</div>
<script type="text/javascript">
	function add_store(in_coming_id,in_coming_name,branch_id,branch_name,dep_branch_name)
	{
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = in_coming_id;
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = in_coming_name;
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.branch_id#</cfoutput>.value = branch_id;
		</cfif>
		<cfif isdefined("attributes.branch_name") and len(attributes.branch_name)>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.branch_name#</cfoutput>.value = branch_name;
		</cfif>
		<cfif isDefined("attributes.field_dep_branch_name") and len(attributes.field_dep_branch_name)>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_dep_branch_name#</cfoutput>.value = dep_branch_name;
		</cfif>
		<!--- 221004 BK Kayıtlı Depo ile Kullanıcı Depo aynı olması için --->
		<cfif isdefined("attributes.is_function")>
			<cfif isdefined("attributes.number")>
				<cfif not isdefined("attributes.draggable")>opener.</cfif>add_department(<cfoutput>#attributes.number#</cfoutput>);
			<cfelse>
				<cfif not isdefined("attributes.draggable")>opener.</cfif>add_department();
			</cfif>
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>