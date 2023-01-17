<cf_get_lang_set module_name="ehesap">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.accounting_code_cat" default="">
<cfset url_str = "">
<cfif isdefined("attributes.form_submit")>
	<cfset url_str = "#url_str#&form_submit=1">
</cfif>
<cfif len(attributes.sal_year)>
	<cfset url_str = "#url_str#&sal_year=#attributes.sal_year#">
</cfif>
<cfif isdefined('attributes.form_submit')>
	<cfquery name="get_rates" datasource="#dsn#">
		SELECT 
			PA.*,
			SS.DEFINITION
		FROM 
			PROJECT_ACCOUNT_RATES PA,
			SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF SS
		WHERE
			PA.ACCOUNT_BILL_TYPE = SS.PAYROLL_ID
			<cfif len(attributes.sal_year)>
				AND PA.YEAR = #attributes.sal_year#
			</cfif> 			
			<cfif isdefined('attributes.accounting_code_cat') and len(attributes.accounting_code_cat)>
				AND SS.PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.accounting_code_cat#">
			</cfif>
			<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
				AND PA.PROJECT_RATE_ID IN (SELECT PROJECT_RATE_ID FROM PROJECT_ACCOUNT_RATES_ROW WHERE PROJECT_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">)
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_rates.recordcount = 0>
</cfif>
<cfinclude template="../query/get_code_cat.cfm">
<cfset getComponent = createObject('component','V16.hr.cfc.get_functions')>
<cfset get_code_cat = getComponent.get_accounting_code_cat()>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_project_rates" name="myform" method="post">
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<cf_box_search>
				<div class="form-group" id="item-project">
					<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
						<cfset project_id_ = attributes.project_id>
					<cfelse>
						<cfset project_id_ = ''>
					</cfif>
					<cf_wrkProject
						project_Id="#project_id_#"
						width="100"
						AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5">
				</div>
				<div class="form-group" id="item-accounting_code_cat">
					<select name="accounting_code_cat" id="accounting_code_cat" style="width:145px;">
						<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<cfoutput query="get_code_cat">
							<option value="#payroll_id#" <cfif attributes.accounting_code_cat eq get_code_cat.payroll_id>selected</cfif>>#definition#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="sal_year" id="sal_year">
						<cfloop from="-5" to="5" index="ccc">
							<cfset this_ = session.ep.period_year + ccc>
							<cfoutput>
								<option value="#this_#" <cfif attributes.sal_year eq this_>selected</cfif>>#this_#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='change_action()'>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Proje Muhasebe Oranları',47184)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr> 
					<th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id="58455.Yıl"></th>
					<th><cf_get_lang dictionary_id="58724.Ay"></th>
					<th><cf_get_lang dictionary_id="54117.Muhasebe Kod Grubu"></th>
					<th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.list_project_rates&event=add</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<cfparam name="attributes.totalrecords" default="#get_rates.recordcount#">
			<tbody>
				<cfif IsDefined('form_submit')>
					<cfif get_rates.recordcount>
						<cfoutput query="get_rates" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
							<tr>
								<td>#currentrow#</td>
								<td>#year#</td>
								<td>#month#</td>
								<td>#definition#</td>
								<td class="text-center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_project_rates&event=upd&project_rate_id=#project_rate_id#')"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							</tr>
						</cfoutput>
					<cfelse>	
						<tr> 
							<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
						</tr>
					</cfif>        
				<cfelse>
					<tr>
						<td colspan="5"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="ehesap.list_project_rates&#url_str#">
		<cf_get_lang_set module_name="#fusebox.circuit#">
	</cf_box>
</div>

<script type="text/javascript">
function change_action()
	{
		myform.action='<cfoutput>#request.self#?fuseaction=ehesap.list_project_rates</cfoutput>';
		myform.target='';
		return true;
	}
</script>
