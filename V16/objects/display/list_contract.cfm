<cf_get_lang_set module_name="contract"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.is_status" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.contract_type" default="">
<cfparam name="attributes.contract_calculation" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.url_str" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.contract_cat" default="">
<cfset url_str = "">
<cfif isdefined('attributes.field_id') and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined('attributes.field_name') and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined('attributes.form_submitted')>
	<cfquery name="GET_CONTRACT" datasource="#DSN3#">
		SELECT
			COMPANY_ID,
			CONSUMER_ID,
			COMPANY,
			CONSUMERS,
			EMPLOYEE,
			STARTDATE,
			FINISHDATE,
			PROJECT_ID,
			CONTRACT_ID,
			CONTRACT_HEAD,
			CONTRACT_NO
		FROM 
			RELATED_CONTRACT
		WHERE 
			OUR_COMPANY_ID = #session.ep.company_id#  
			<cfif attributes.is_status eq 1>AND STATUS = 1<cfelseif attributes.is_status eq 0>AND STATUS = 0</cfif>
			<cfif len(attributes.contract_type)>
				AND CONTRACT_TYPE = #attributes.contract_type#
			</cfif>
			<cfif len(attributes.contract_calculation)>
				AND CONTRACT_CALCULATION = #attributes.contract_calculation#
			</cfif>
			<cfif len(attributes.process_stage_type)>
				AND STAGE_ID = #attributes.process_stage_type#
			</cfif>
			<cfif len(attributes.keyword)>
				AND (
					CONTRACT_HEAD LIKE '%#attributes.keyword#%' OR
					CONTRACT_NO LIKE '%#attributes.keyword#%'
					)
			</cfif>
			<cfif len(attributes.company_id) and len(attributes.company)>
				AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
			</cfif>
			<cfif len(attributes.consumer_id) and len(attributes.company)>
				AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
			</cfif>
			<cfif Len(attributes.project_id) and Len(attributes.project_head)>
				AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif Len(attributes.contract_cat)>
				AND CONTRACT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.contract_cat#">
			</cfif>
		ORDER BY
			CONTRACT_NO
	</cfquery>
<cfelse>
	<cfset get_contract.recordCount = 0>
</cfif>	
<cfquery name="get_contract_stage" datasource="#DSN#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%contract.list_related_contracts%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery> 
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_contract.recordCount#">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfparam  name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='29522.Sözleşme'></cfsavecontent>
<div class="col col-12">
	<cf_box title='#message#' scroll="1" collapsable="1" resize="1"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> 
		<cfform name="search_contract" method="post" action="#request.self#?fuseaction=objects.popup_list_contract&#url_str#"> 
			<input name="form_submitted" id="form_submitted" type="hidden" value="">
			<cf_box_search> 
				<div class="form-group" id="keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" style="width:100px;">
				</div>
				<div class="form-group" id="process_stage_type">
					<select name="process_stage_type" id="process_stage_type">
						<option value=""><cf_get_lang dictionary_id='52009.Sürec Asama'></option>
						<cfoutput query="get_contract_stage">
							<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="contract_type">
					<select name="contract_type" id="contract_type">
						<option value=""><cf_get_lang dictionary_id='51040.Sözleşme Tipi'></option>
						<option value="1" <cfif attributes.contract_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58176.Alış'></option>
						<option value="2" <cfif attributes.contract_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
					</select>
				</div>
				<div class="form-group" id="contract_calculation">
					<select name="contract_calculation" id="contract_calculation">
						<option value=""><cf_get_lang dictionary_id='51043.Hesaplama Yöntemi'></option>
						<option value="1" <cfif attributes.contract_calculation eq 1>selected</cfif>>%</option>
						<option value="2" <cfif attributes.contract_calculation eq 2>selected</cfif>><cf_get_lang dictionary_id='29513.Süre'></option>
						<option value="3" <cfif attributes.contract_calculation eq 3>selected</cfif>><cf_get_lang dictionary_id='57635.Miktar'></option>
					</select>
				</div>   
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_contract' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" onclick="addEvent()"><i class="fa fa-plus"></i></a>
				</div>
			</cf_box_search> 
			<cf_box_search_detail search_function="loadPopupBox('search_contract', #attributes.modal_id#)">
					<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12" id="company">
						<div class="input-group">   
							<cfoutput>
								<input type="hidden" name="member_id" id="member_id" value="">
								<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="#attributes.consumer_id#"</cfif>>			
								<input type="hidden" name="company_id" id="company_id"  value="<cfif isdefined("attributes.member_id") and not(isdefined("attributes.employee_id_new") and len(attributes.employee_id_new))><cfoutput>#attributes.member_id#</cfoutput><cfelseif len(attributes.company)>#attributes.company_id#</cfif>">
								<input type="hidden" name="employee_id_new" id="employee_id_new" value="<cfif isdefined("attributes.employee_id_new")><cfoutput>#attributes.employee_id_new#</cfoutput></cfif>">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57519.Cari Hesap'></cfsavecontent>
								<input type="text" name="company" id="company" placeholder="<cfoutput>#message#</cfoutput>" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'1\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','related_contract','3','150');" value="<cfif isdefined("attributes.member_id") and len(attributes.member_id) and not(isdefined("attributes.employee_id_new") and len(attributes.employee_id_new))><cfoutput>#get_par_info(attributes.member_id,1,1,0)#</cfoutput><cfelseif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput><cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput><cfelseif isdefined("attributes.employee_id_new") and len(attributes.employee_id_new)><cfoutput>#get_emp_info(attributes.employee_id_new,0,0,0)#</cfoutput><cfelseif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=search_contract.company&field_comp_id=search_contract.company_id&field_consumer=search_contract.consumer_id&field_member_name=search_contract.company&select_list=2,3&keyword='+encodeURIComponent(document.search_contract.company.value))"></span>
							</div>
						</div>  		
					<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12" id="project_head">
						<div class="input-group"> 
								<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_id)>#attributes.project_id#</cfif>">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
								<input type="text" name="project_head"  id="project_head" placeholder="<cfoutput>#message#</cfoutput>" value="<cfif len(attributes.project_head)>#UrlDecode(attributes.project_head)#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=search_contract.project_id&project_head=search_contract.project_head');"></span>
							</cfoutput>
						</div>
						</div>	
					<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12" id="contract_cat">
						<cfsavecontent variable="text"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
						<cf_wrk_combo
						name="contract_cat"
						query_name="GET_CONTRACT_CAT"
						option_name="contract_cat"
						option_text="#text#"
						value="#attributes.contract_cat#"
						option_value="contract_cat_id"
						width="150">
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12" id="is_status">
						<select name="is_status" id="is_status" style="width:50px;">
							<option value="1" <cfif attributes.is_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							<option value="0" <cfif attributes.is_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
							<option value="" <cfif attributes.is_status eq ''>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						</select>
					</div>
			</cf_box_search_detail>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='30044.Sözleşme No'></th>
					<th><cf_get_lang dictionary_id ='29522.Sözleşme'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_contract.recordcount>
					<cfset contract_company_list = "">
					<cfset contract_consumer_list = "">
					<cfoutput query="get_contract" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif Len(company_id) and not ListFind(contract_company_list,company_id,',')>
							<cfset contract_company_list = ListAppend(contract_company_list,company_id,',')>
						</cfif>
						<cfif Len(consumer_id) and not ListFind(contract_consumer_list,consumer_id,',')>
							<cfset contract_consumer_list = ListAppend(contract_consumer_list,consumer_id,',')>
						</cfif>
					</cfoutput>
					<cfif ListLen(contract_company_list)>
						<cfquery name="get_contract_company" datasource="#dsn#">
							SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#contract_company_list#) ORDER BY COMPANY_ID
						</cfquery>
						<cfset contract_company_list = ListSort(ListDeleteDuplicates(ValueList(get_contract_company.company_id,',')),"numeric","asc",",")>
					</cfif>
					<cfif ListLen(contract_consumer_list)>
						<cfquery name="get_contract_consumer" datasource="#dsn#">
							SELECT CONSUMER_ID, CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#contract_consumer_list#) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset contract_consumer_list = ListSort(ListDeleteDuplicates(ValueList(get_contract_consumer.consumer_id,',')),"numeric","asc",",")>
					</cfif>
					<cfoutput query="get_contract" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" onClick="add_contract('#contract_id#','#contract_head#');" class="tableyazi">#contract_no#</a></td>
						<td><a href="javascript://" onClick="add_contract('#contract_id#','#contract_head#');" class="tableyazi">#contract_head#</a></td>
						<td><cfif Len(company_id)>
								#get_contract_company.fullname[ListFind(contract_company_list,company_id,',')]#
							<cfelseif Len(consumer_id)>
								#get_contract_consumer.fullname[ListFind(contract_consumer_list,consumer_id,',')]#
							</cfif>
						</td>
					</tr>
					</cfoutput>
				<cfelse>
				<tr>
					<td colspan="4"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.call_function") and len(attributes.keyword)>
				<cfset url_str = "#url_str#&call_function=#attributes.call_function#">
			</cfif>
			<cfif len(attributes.company_id) and len(attributes.company)>
				<cfset url_str="#url_str#&company_id=#attributes.company_id#&company=#attributes.company#">
			</cfif>
			<cfif len(attributes.consumer_id) and len(attributes.company)>
				<cfset url_str="#url_str#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
			</cfif>
			<cfif len(attributes.project_id) and len(attributes.project_head)>
				<cfset url_str="#url_str#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
			</cfif>
			<cfif len(attributes.contract_cat)>
				<cfset url_str = "#url_str#&contract_cat=#attributes.contract_cat#">
			</cfif>
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_list_contract#url_str#&form_submitted=1"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>  
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus(); 
	function add_contract(field_id,field_name)
	{
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document.all</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = field_id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document.all</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = field_name;
		</cfif>
		<cfif isdefined("attributes.call_function")>
			try{opener.<cfoutput>#attributes.call_function#</cfoutput>;}
				catch(e){};
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	function addEvent()
	{
		window.open("/index.cfm?fuseaction=contract.list_related_contracts&event=add", '_blank');
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	