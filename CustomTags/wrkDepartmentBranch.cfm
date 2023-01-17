<!--- wrkDepartmentBranch Departman veya şubeleri select box olarak getirir SM 20090820--->
<cfparam name="attributes.line_info" default=""><!--- Eğer birden fazla banka hesabı varsa sayfada aynı isimde değişken olmasın diye --->
<cfparam name="attributes.fieldId" default="department_id"><!--- alan adı --->
<cfparam name="attributes.width" default="120"><!--- genişlik --->
<cfparam name="attributes.height" default="60"><!--- yükseklik (çoklu için) --->
<cfparam name="attributes.selected_value" default=""><!--- Liste sayfaları için form değeri --->
<cfparam name="attributes.is_multiple" default="0"><!--- Çoklu seçim seçeneği--->
<cfparam name="attributes.is_branch" default="0"><!--- 1 olursa şube select box ı gelir --->
<cfparam name="attributes.is_department" default="1"><!--- 1 olursa departman select box ı gelir --->
<cfparam name="attributes.is_deny_control" default="0"><!--- yetkiye bakacak --->
<cfparam name="attributes.is_default" default="0"><!--- Default olarak kişinin şubesi gelsin mi --->
<cfparam name="attributes.option_value" default="#caller.getLang('main',322)#">
<cfif caller.fusebox.circuit is 'store'>
	<cfset is_store_module=1>
<cfelse>
	<cfset is_store_module = 0>
</cfif>
<cfparam name="attributes.is_store_module" default="#is_store_module#">
<cfif session.ep.isBranchAuthorization><!--- Şube modülüyse her durumda yetkiye baksın --->
	<cfset attributes.is_deny_control = 1>
</cfif>
<cfscript>
	CreateComponent = CreateObject("component","/../workdata/get_department");
	queryResult = CreateComponent.getComponentFunction(is_deny_control:attributes.is_deny_control,is_store_module:attributes.is_store_module);	
	CreateComponent = CreateObject("component","/../workdata/get_department");
	queryResult1 = CreateComponent.getComponentFunction1(is_deny_control:attributes.is_deny_control);
</cfscript>
<cfset x = 0>
<cfoutput>
    <input type="hidden" id="branch_id_info#attributes.line_info#" name="branch_id_info#attributes.line_info#" value="">
	<select id="#attributes.fieldId##attributes.line_info#" name="#attributes.fieldId##attributes.line_info#" <cfif attributes.is_multiple eq 1>multiple</cfif> style="width:#attributes.width#px;<cfif attributes.is_multiple eq 1>height:#attributes.height#px;</cfif>" <cfif not (attributes.is_multiple and attributes.is_branch)>onChange="get_branch_info_dept_#attributes.line_info#();"</cfif>>
    	<cfif attributes.is_multiple eq 0 and attributes.is_default eq 0>
		<option value="">
			#attributes.option_value#
		</option>
		</cfif>
        <cfif attributes.is_branch eq 1>
			<cfloop query="queryResult1">
				<option value="#branch_id#" <cfif (len(attributes.selected_value) and (branch_id eq attributes.selected_value or listfind(attributes.selected_value,branch_id))) or (attributes.is_default eq 1 and not len(attributes.selected_value) and listlen(session.ep.user_location,"-") gte 2 and branch_id eq listgetat(session.ep.user_location,2,'-'))>selected</cfif>>#branch_name#</option>
			</cfloop>
		<cfelse>
			<cfloop query="queryResult1">
				<cfloop query="queryResult">
					<cfif queryResult.branch_id eq queryResult1.branch_id>
						<optgroup label="#queryResult1.branch_name#">
						<cfset x=1>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfloop query="queryResult">
					<cfif queryResult.branch_id eq queryResult1.branch_id>
						<option value="#department_id#" <cfif (len(attributes.selected_value) and (department_id eq attributes.selected_value or listfind(attributes.selected_value,department_id))) or (attributes.is_default eq 1 and not len(attributes.selected_value) and department_id eq listgetat(session.ep.user_location,1,'-'))>selected</cfif>>#department_head#</option>
					</cfif>
				</cfloop>
				<cfif x eq 1>
					</optgroup>
					<cfset x=2>
				</cfif>
			</cfloop>
		</cfif>
    </select>
	<script type="text/javascript">
		function get_branch_info_dept_#attributes.line_info#()
		{
			department_info = document.getElementById('#attributes.fieldId#').value;
			
			if(department_info != '')
			{
				url_= '/V16/settings/cfc/departmentInfo.cfc?method=getDepartmentInfo';
				$.ajax({                                                                                             
					url: url_,
					dataType: "text",
					data: {department_info: department_info},
					cache: false,
					async: false,
					success: function(read_data) {
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
							$.each(data_.DATA,function(i){
								document.getElementById('branch_id_info#attributes.line_info#').value = data_.DATA[i][0];		//BRANCH_ID
							});
						}
					}
				});
			}
			else
			{
				document.getElementById('branch_id_info#attributes.line_info#').value = '';
			}
			return false;
		}
		get_branch_info_dept_#attributes.line_info#();
	</script>
</cfoutput>