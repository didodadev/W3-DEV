<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="company_credit" action="#request.self#?fuseaction=contract.list_contracts" method="post">
			<input name="form_submitted" id="form_submitted" type="hidden" value="">
			<cf_box_search more="0">
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
						<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
						<input name="company" type="text" id="company" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'1\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','company_credit','3','150');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off" placeholder="<cfoutput>#getLang(107,'Cari Hesap',57519)#</cfoutput>">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=company_credit.company&field_comp_id=company_credit.company_id&field_consumer=company_credit.consumer_id&field_member_name=company_credit.company&select_list=2,3</cfoutput>&keyword='+encodeURIComponent(document.company_credit.company.value),'list')" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
						<input name="employee" type="text" id="employee" style="width:125px;" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');" value="<cfoutput>#attributes.employee#</cfoutput>" required="yes" autocomplete="off" placeholder="<cfoutput>#getLang(487,'Kaydeden',57899)#</cfoutput>">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=company_credit.employee_id&field_name=company_credit.employee&is_form_submitted=1&select_list=1','list');"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(25,'Anlaşmalar',57437)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<cfif isdefined("attributes.form_submitted")>
			<cfquery name="get_position_id" datasource="#DSN#">
				SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
			</cfquery>
			<cfquery name="get_setup_period" datasource="#DSN#"><!--- Yetkili olunan şirketler --->
				SELECT DISTINCT
					OUR_COMPANY_ID
				FROM 
					SETUP_PERIOD SP, 
					EMPLOYEE_POSITION_PERIODS EP 
				WHERE 
					EP.PERIOD_ID = SP.PERIOD_ID AND 
					EP.POSITION_ID = #get_position_id.position_id#
			</cfquery>
			<cfset setup_period_comp = ValueList(get_setup_period.our_company_id,',')>
			<cfquery name="get_company_credit" datasource="#DSN#">
				SELECT 
					OUR_COMPANY_ID,
					COMPANY_ID,
					CONSUMER_ID,
					RECORD_EMP
				FROM 
					COMPANY_CREDIT
				WHERE 
					OUR_COMPANY_ID IN (<cfif len(setup_period_comp)>#setup_period_comp#<cfelse>0</cfif>)
					AND (CONSUMER_ID IS NOT NULL OR COMPANY_ID IS NOT NULL)
					<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>
						AND COMPANY_ID=	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
					</cfif>
					<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>
						AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
					</cfif>
					<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.employee)>
						AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
					</cfif>
				ORDER BY
					COMPANY_ID,
					CONSUMER_ID
			</cfquery>
			<cfset company_id_list = ''>
			<cfset consumer_id_list = ''>
			<cfset our_company_id_list = ''>
			<cfset record_emp_list = ''>
			<cfoutput query="get_company_credit" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(company_id) and not listfind(company_id_list,company_id)>
					<cfset company_id_list=listappend(company_id_list,company_id)>
				</cfif>
				<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
					<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
				</cfif>
				<cfif len(our_company_id) and not listfind(our_company_id_list,our_company_id)>
					<cfset our_company_id_list=listappend(our_company_id_list,our_company_id)>
				</cfif>
				<cfif len(record_emp) and not listfind(record_emp_list,record_emp)>
					<cfset record_emp_list=listappend(record_emp_list,record_emp)>
				</cfif>
			</cfoutput>
			<cfif listlen(company_id_list)>
				<cfset company_id_list=listsort(company_id_list,"numeric","ASC",',')>
				<cfquery name="get_company" datasource="#DSN#">
					SELECT
						COMPANY_ID,
						FULLNAME
					FROM 
						COMPANY 
					WHERE
						COMPANY_ID IN (#company_id_list#)
					ORDER BY
						COMPANY_ID
				</cfquery>
				<cfset main_company_id_list = listsort(listdeleteduplicates(valuelist(get_company.company_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(consumer_id_list)>
				<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",',')>
				<cfquery name="get_consumer" datasource="#DSN#">
					SELECT
						CONSUMER_ID,
						CONSUMER_NAME,
						CONSUMER_SURNAME
					FROM 
						CONSUMER 
					WHERE
						CONSUMER_ID IN (#consumer_id_list#)
					ORDER BY
						CONSUMER_ID
				</cfquery>
				<cfset main_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(our_company_id_list)>
				<cfset our_company_id_list=listsort(our_company_id_list,"numeric","ASC",',')>
				<cfquery name="get_our_company" datasource="#DSN#">
					SELECT
						COMP_ID,
						NICK_NAME
					FROM 
						OUR_COMPANY 
					WHERE
						COMP_ID IN (#our_company_id_list#)
					ORDER BY
						COMP_ID
				</cfquery>
				<cfset main_our_company_id_list = listsort(listdeleteduplicates(valuelist(get_our_company.comp_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(record_emp_list)>
				<cfset record_emp_list=listsort(record_emp_list,"numeric","ASC",',')>
				<cfquery name="get_employee" datasource="#DSN#">
					SELECT
						EMPLOYEE_ID,
						EMPLOYEE_NAME,
						EMPLOYEE_SURNAME
					FROM 
						EMPLOYEES 
					WHERE
						EMPLOYEE_ID IN (#record_emp_list#)
					ORDER BY
						EMPLOYEE_ID
				</cfquery>
				<cfset main_record_emp_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfelse>
				<cfset get_company_credit.recordcount = 0>
			</cfif>
			<cfparam name="attributes.totalrecords" default="#get_company_credit.recordcount#">
			<thead>
				<tr> 
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57658.Üye'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_company_credit.recordcount>
					<cfoutput query="get_company_credit" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>
							<cfif len(company_id)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" class="tableyazi">
									#get_company.fullname[listfind(main_company_id_list,company_id,',')]#
								</a>
							<cfelseif len(consumer_id)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">
									#get_consumer.consumer_name[listfind(main_consumer_id_list,consumer_id,',')]#&nbsp; 
									#get_consumer.consumer_surname[listfind(main_consumer_id_list,consumer_id,',')]#
								</a>	
							</cfif>
						</td>
						<td>
							<cfif len(our_company_id)>
								#get_our_company.nick_name[listfind(main_our_company_id_list,our_company_id,',')]#
							</cfif>
						</td>
						<td>
							<cfif len(record_emp)>
								<a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');">
									#get_employee.employee_name[listfind(main_record_emp_list,record_emp,',')]#&nbsp;
									#get_employee.employee_surname[listfind(main_record_emp_list,record_emp,',')]#
								</a>
							</cfif>
						</td>
						<!-- sil -->
						<td width="15">
						<cfif our_company_id eq session.ep.company_id>
							<a href="#request.self#?fuseaction=contract.list_contracts&event=upd<cfif len(company_id)>&company_id=#company_id#<cfelse>&consumer_id=#consumer_id#</cfif>"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
						<cfelse>
							<a href="javascript://" onClick="uyar();"><img src="../images/update_list.gif"></a>
						</cfif>
						</td>
						<!-- sil -->
					</tr>
					</cfoutput>
				<cfelse>
					<tr> 
					<td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str =''>
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = url_str & "&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
			<cfset url_str = url_str & "company_id=#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.company") and len(attributes.company)>
			<cfset url_str = url_str & "&company=#attributes.company#">
		</cfif>
		<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
			<cfset url_str = url_str & "&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
			<cfset url_str = url_str & "&consumer_id=#attributes.consumer_id#">
		</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction##url_str#"> 
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('company').focus();
	function uyar()
	{
		alert("<cf_get_lang dictionary_id ='51012.Anlasmayı Görebilmek İçin Lütfen Şirketinizi Değiştiriniz'>");
	}
</script>
