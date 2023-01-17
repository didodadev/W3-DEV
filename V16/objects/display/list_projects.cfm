<cf_xml_page_edit fuseact="objects.popup_list_projects">
<cfparam name="attributes.satir" default=""><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
<cfparam name="attributes.moreProject" default="0"><!---inputa birden fazla proje düşürülecekse 1 gelir --->

<script type="text/javascript">
function add_pro(project_id,company_id,project_head,sdate,fdate,p_sdate,p_fdate,consumer_id,company_name,partner_id,partner_name,workgroup_id,pro_employee_id,pro_employee,paymethod,paymethod_id,card_paymethod_id,dueday,commission_rate,paymethod_vehicle,expense,expense_id)
{  
	<cfif isdefined("attributes.satir") and len(attributes.satir)>
		var satir = <cfoutput>#attributes.satir#</cfoutput>;
	<cfelse>
		var satir = -1;
	</cfif>
	if(typeof(window.opener) != "undefined" && window.opener != null && window.opener.basket && satir > -1) 
		window.opener.updateBasketItemFromPopup(satir, { ROW_PROJECT_ID: project_id, ROW_PROJECT_NAME: project_head }); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
	else if(typeof(updateBasketItemFromPopup) != undefined && satir > -1)
		updateBasketItemFromPopup(satir, { ROW_PROJECT_ID: project_id, ROW_PROJECT_NAME: project_head });
	else
	{
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
			<cfset _project_id_ = ListGetAt(attributes.project_id,2,'.')><!--- Formu olmayan Sayfalara Değer Taşımak İçin Konuldu M.ER 01052008 --->
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_project_id_#'</cfoutput>) != undefined)
				<cfif attributes.moreProject eq 0>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_project_id_#'</cfoutput>).value = project_id;
				<cfelse>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_project_id_#'</cfoutput>).value += ',' + project_id ;
				</cfif>
			else	
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#project_id#</cfoutput>.value = project_id;
		</cfif>
		<cfif isdefined("attributes.expense")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#expense#</cfoutput>.value = expense;
		</cfif>
		<cfif isdefined("attributes.expense_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#expense_id#</cfoutput>.value = expense_id;
		</cfif>
		<cfif isdefined("attributes.company_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#company_id#</cfoutput>.value = company_id;
		</cfif>
		<cfif isdefined("attributes.pro_employee_id")><!--- addoptions icin eklendi --->
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#pro_employee_id#</cfoutput>.value = pro_employee_id;
		</cfif>
		<cfif isdefined("attributes.pro_employee")><!--- addoptions icin eklendi --->
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#pro_employee#</cfoutput>.value = pro_employee;
		</cfif>
		<cfif isdefined("attributes.sdate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#sdate#</cfoutput>.value = sdate;
		</cfif>
		<cfif isdefined("attributes.fdate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#fdate#</cfoutput>.value = fdate;
		</cfif>
		<cfif isdefined("attributes.p_sdate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#p_sdate#</cfoutput>.value = p_sdate;
		</cfif>
		<cfif isdefined("attributes.p_fdate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#p_fdate#</cfoutput>.value = p_fdate;
		</cfif>
		<cfif isdefined("attributes.consumer_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#consumer_id#</cfoutput>.value = consumer_id;
		</cfif>
		
		<cfif isdefined("attributes.company_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#company_name#</cfoutput>.value = company_name;
		</cfif>
		<cfif isdefined("attributes.company_name2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#company_name2#</cfoutput>.value = company_name +' - '+ partner_name;
		</cfif>
		<cfif isdefined("attributes.partner_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#partner_id#</cfoutput>.value = partner_id;
		</cfif>
		<cfif isdefined("attributes.partner_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#partner_name#</cfoutput>.value = partner_name;
		</cfif>
		<cfif isdefined("attributes.workgroup_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#workgroup_id#</cfoutput>.value = workgroup_id;
		</cfif>
		
		// Proje bağlantıları ile ilişkili odeme yontemi bilgileri
		if(paymethod != '')
		{
			<cfif isdefined("attributes.paymethod")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#paymethod#</cfoutput>.value = paymethod;
			</cfif>
			<cfif isdefined("attributes.paymethod_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#paymethod_id#</cfoutput>.value = paymethod_id;
			</cfif>
			<cfif isdefined("attributes.card_paymethod_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#card_paymethod_id#</cfoutput>.value = card_paymethod_id;
			</cfif>
			<cfif isdefined("attributes.dueday")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#dueday#</cfoutput>.value = dueday;
			</cfif>
			<cfif isdefined("attributes.commission_rate")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#commission_rate#</cfoutput>.value = commission_rate;
			</cfif>
			<cfif isdefined("attributes.paymethod_vehicle")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#paymethod_vehicle#</cfoutput>.value = paymethod_vehicle;
			</cfif>
		}
		
		<cfif isdefined("attributes.project_head") and isDefined("attributes.project_id") and not isdefined("attributes.multi")>
			<cfset _project_head_ = ListGetAt(attributes.project_head,2,'.')><!--- Formu olmayan Sayfalara Değer Taşımak İçin Konuldu M.ER 01052008 --->
			<cfset _project_id_ = ListGetAt(attributes.project_id,2,'.')>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_project_head_#'</cfoutput>) != undefined)
			{	
				<cfif attributes.moreProject eq 0>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_project_head_#'</cfoutput>).value  =  project_head;
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_project_head_#'</cfoutput>).focus();
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_project_id_#'</cfoutput>).value = project_id;
				<cfelse>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_project_head_#'</cfoutput>).value  += ',' +  project_head ;
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_project_head_#'</cfoutput>).focus();
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_project_id_#'</cfoutput>).value += ',' +  project_id;
				</cfif>
			}	
			else
			{
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#project_head#</cfoutput>.value = project_head;
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#project_head#</cfoutput>.focus();
			}
		<cfelseif isdefined("attributes.project_head") and isdefined("attributes.multi")>
			x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.project_head#</cfoutput>.length;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.project_head#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>. <cfoutput>#attributes.project_head#</cfoutput>.options[x].value = project_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.project_head#</cfoutput>.options[x].text = project_head;
		</cfif>
		<cfif isdefined('attributes.function_name')>
			<cfif isdefined('attributes.function_param')>			
				<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.function_name#(#attributes.function_param#);</cfoutput>
			<cfelse>
				<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.function_name#();</cfoutput>
			</cfif>
		</cfif>
		
		if(typeof(window.opener) != "undefined" && window.opener != null && typeof(window.opener.set_project_risk_limit) != 'undefined')  //basketteki toplamdaki  baglantı bakiye bilgisi icin eklendi
		{
			try{window.opener.set_project_risk_limit();}
				catch(e){};
		}
		
	}
	<cfif isdefined("attributes.call_function")>
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.call_function#</cfoutput>;
	</cfif>
	<cfif isdefined("attributes.project_head") and not isdefined("attributes.multi") and  attributes.moreProject eq 0>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
}
</script>
<cfset url_string = "">
<cfif isdefined("attributes.project_head")>
	<cfset url_string = "#url_string#&project_head=#attributes.project_head#">
</cfif>
<cfif isdefined("attributes.pro_employee_id")>
	<cfset url_string = "#url_string#&pro_employee_id=#attributes.pro_employee_id#">
</cfif>
<cfif isdefined("attributes.pro_employee")>
	<cfset url_string = "#url_string#&pro_employee=#attributes.pro_employee#">
</cfif>
<cfif isdefined("attributes.function_name")>
	<cfset url_string = "#url_string#&function_name=#attributes.function_name#">
</cfif>
<cfif isdefined("attributes.function_param")>
	<cfset url_string = "#url_string#&function_param=#attributes.function_param#">
</cfif>
<cfif isdefined("attributes.project_id")>
	<cfset url_string = "#url_string#&project_id=#project_id#">
</cfif>
<cfif isdefined("attributes.sdate")>
	<cfset url_string = "#url_string#&sdate=#sdate#">
</cfif>
<cfif isdefined("attributes.fdate")>
	<cfset url_string = "#url_string#&fdate=#fdate#">
</cfif>
<cfif isdefined("attributes.p_sdate")>
	<cfset url_string = "#url_string#&p_sdate=#p_sdate#">
</cfif>
<cfif isdefined("attributes.p_fdate")>
	<cfset url_string = "#url_string#&p_fdate=#p_fdate#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_string = "#url_string#&company_id=#company_id#">
</cfif>
<cfif isdefined("attributes.expense")>
	<cfset url_string = "#url_string#&expense=#expense#">
</cfif>
<cfif isdefined("attributes.expense_id")>
	<cfset url_string = "#url_string#&expense_id=#expense_id#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
	<cfset url_string = "#url_string#&consumer_id=#consumer_id#">
</cfif>
<cfif isdefined("attributes.call_function")>
	<cfset url_string = "#url_string#&call_function=#call_function#">
</cfif>
<cfif isdefined("attributes.company_name")>
	<cfset url_string = "#url_string#&company_name=#company_name#">
</cfif>
<cfif isdefined("attributes.company_name2")>
	<cfset url_string = "#url_string#&company_name2=#company_name2#">
</cfif>
<cfif isdefined("attributes.partner_id")>
	<cfset url_string = "#url_string#&partner_id=#partner_id#">
</cfif>
<cfif isdefined("attributes.partner_name")>
	<cfset url_string = "#url_string#&partner_name=#partner_name#">
</cfif>
<cfif isdefined("attributes.workgroup_id")>
	<cfset url_string = "#url_string#&workgroup_id=#workgroup_id#">
</cfif>

<!--- proje baglanti odeme yontemi bilgileri --->
<cfif isdefined("attributes.paymethod")>
	<cfset url_string = "#url_string#&paymethod=#attributes.paymethod#">
</cfif>
<cfif isdefined("attributes.paymethod_id")>
	<cfset url_string = "#url_string#&paymethod_id=#attributes.paymethod_id#">
</cfif>
<cfif isdefined("attributes.card_paymethod_id")>
	<cfset url_string = "#url_string#&card_paymethod_id=#attributes.card_paymethod_id#">
</cfif>
<cfif isdefined("attributes.dueday")>
	<cfset url_string = "#url_string#&dueday=#attributes.dueday#">
</cfif>
<cfif isdefined("attributes.commission_rate")>
    <cfset url_string = "#url_string#&commission_rate=#attributes.commission_rate#">
</cfif>
<cfif isdefined("attributes.project_cat_gln")>
    <cfset url_string = "#url_string#&project_cat_gln=#attributes.project_cat_gln#">
</cfif>
<cfif isdefined("attributes.paymethod_vehicle")>
   <cfset url_string = "#url_string#&paymethod_vehicle=#attributes.paymethod_vehicle#">
</cfif>

<cfif isdefined("attributes.is_empty_project")>
	<cfset url_string = "#url_string#&is_empty_project=#is_empty_project#">
</cfif>
<cfif isdefined("session.joins_old")>
	<cfscript>
		structdelete(session,"joins_old");
	</cfscript>
</cfif>
<cfif isdefined("session.specs_old")>
	<cfscript>
		structdelete(session,"specs_old");
	</cfscript>
</cfif>
<cfif isdefined("attributes.multi")>
	<cfset url_string = "#url_string#&multi=1">
</cfif>
<cfif isdefined("attributes.allproject") and attributes.allproject eq 1>
	<cfset url_string = "#url_string#&allproject=1">
</cfif>
<cfif isdefined("attributes.satir") and len(attributes.satir)><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
	<cfset url_string= "#url_string#&satir=#attributes.satir#">
</cfif>

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.priority_cat" default="">
<cfparam name="attributes.project_cat" default="">
<cfquery name="get_project_cat" datasource="#dsn#">
	SELECT
	   DISTINCT 
	   SMC.MAIN_PROCESS_CAT_ID,
	   SMC.MAIN_PROCESS_CAT
	FROM 
	   SETUP_MAIN_PROCESS_CAT SMC,
	   SETUP_MAIN_PROCESS_CAT_ROWS SMR,
	   EMPLOYEE_POSITIONS
	WHERE
	   SMC.MAIN_PROCESS_CAT_ID=SMR.MAIN_PROCESS_CAT_ID AND
       <cfif isDefined('session.ep.userid')>
	  	 EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND      
       </cfif>
       (EMPLOYEE_POSITIONS.POSITION_CAT_ID=SMR.MAIN_POSITION_CAT_ID OR 
	   	EMPLOYEE_POSITIONS.POSITION_CODE=SMR.MAIN_POSITION_CODE)
</cfquery>
<cfif not isDefined("attributes.project_status") and xml_project_status eq 1>
	<cfparam name="attributes.project_status" default="1"><!--- Aktif projeler --->
</cfif>
<cfif isdefined("attributes.project_cat_gln") and len(attributes.project_cat_gln)>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
	<cfset GET_XMLPRO_CAT = get_fuseaction_property.get_fuseaction_property(
        company_id : session.ep.company_id,
        fuseaction_name : 'budget.budget_transfer_demand',
        property_name : 'xml_proje_cat_id'
		)>
		<cfif len(GET_XMLPRO_CAT.recordcount)>
			<cfset attributes.project_cat = valueList(GET_XMLPRO_CAT.PROPERTY_VALUE)>
		</cfif>
</cfif>
<cfif isdefined("attributes.form_varmi") or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfinclude template="../query/get_projects_list.cfm">
	<cfparam name="attributes.totalrecords" default="#get_projects.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif xml_islem_cari and isdefined("attributes.comp_id")><!--- xmlde islem carisi secili gelsin evet ise --->
	<cfset attributes.company_id_ = attributes.comp_id>
	<cfset attributes.consumer_id_ = attributes.cons_id>
	<cfset attributes.member_name_ = attributes.comp_name>
	<cfif isdefined("attributes.mem_type")>
		<cfset attributes.member_type_ = attributes.mem_type>
	<cfelse>
		<cfif len(attributes.comp_id)>
			<cfset attributes.member_type_ = "PARTNER">
		<cfelse>
			<cfset attributes.member_type_ = "CONSUMER">
		</cfif>
	</cfif>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Projeler',58015)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="project_search" action="#request.self#?fuseaction=objects.popup_list_projects#url_string#" method="post">
				<input type="hidden" name="moreProject" value="<cfoutput>#attributes.moreProject#</cfoutput>">
				<input type="hidden" name="form_varmi" id="form_varmi" value="1">
			<cf_box_search>
				<cfquery name="get_procurrency" datasource="#dsn#">
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
							<cfif isDefined('session.ep.userid')>
						PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
							</cfif>
						PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects.popup_list_projects%">
						ORDER BY
							PTR.LINE_NUMBER
					</cfquery>
					<cfinclude template="../query/get_priority.cfm">
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="project_cat">
					<select name="project_cat" id="project_cat">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori Seçiniz'></option>
						<cfoutput query="get_project_cat">
							<option value="#main_process_cat_id#"<cfif isdefined("attributes.project_cat") and (attributes.project_cat is main_process_cat_id)>selected</cfif>>#main_process_cat#
						</cfoutput>
					</select>
				</div>
				<cfif xml_project_status eq 1>
					<div class="form-group" id="project_status">
						<select name="project_status" id="project_status" class="formthin">
							<option value="0" <cfif isDefined("attributes.project_status") and (attributes.project_status eq 0)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
							<option value="1" <cfif isDefined("attributes.project_status") and (attributes.project_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							<option value="-1" <cfif isDefined("attributes.project_status") and (attributes.project_status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						</select>
					</div>
				</cfif>
				<div class="form-group small" id="item-maxrows">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="control() && loadPopupBox('project_search', #attributes.modal_id#)">
				</div>
			</cf_box_search>
			<cf_box_search_detail search_function="loadPopupBox('project_search', #attributes.modal_id#)">
				<cfif xml_member>
					<div class="form-group col col-3 col-md-4 col-sm-6 col xs-12">
						<div class="input-group">
							<input type="hidden" name="consumer_id_" id="consumer_id_" value="<cfif isdefined("attributes.consumer_id_")><cfoutput>#attributes.consumer_id_#</cfoutput></cfif>">
							<input type="hidden" name="company_id_" id="company_id_" value="<cfif isdefined("attributes.company_id_")><cfoutput>#attributes.company_id_#</cfoutput></cfif>">
							<input type="hidden" name="member_type_" id="member_type_" value="<cfif isdefined("attributes.member_type_")><cfoutput>#attributes.member_type_#</cfoutput></cfif>">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57658.Üye'></cfsavecontent>
							<input type="text" name="member_name_" placeholder="<cfoutput>#message#</cfoutput>" id="member_name_" value="<cfif isdefined("attributes.member_name_") and len(attributes.member_name_)><cfoutput>#attributes.member_name_#</cfoutput></cfif>">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=project_search.consumer_id_&field_comp_id=project_search.company_id_&field_member_name=project_search.member_name_&field_type=project_search.member_type_&select_list=7,8&keyword='+encodeURIComponent(document.project_search.member_name_.value));"></span>
						</div>
					</div>
				</cfif>
				<div class="form-group col col-3 col-md-4 col-sm-6 col xs-12" id="priority_cat">
					<select name="priority_cat" id="priority_cat">
						<option value=""><cf_get_lang dictionary_id='57485.Öncelik'></option>
						<cfoutput query="get_cats">
							<option value="#priority_id#"<cfif isDefined("attributes.priority_cat") and (attributes.priority_cat is priority_id)>selected</cfif>>#priority#
						</cfoutput>
					</select>
				</div>
				<div class="form-group col col-3 col-md-4 col-sm-6 col xs-12" id="currency">
					<select name="currency" id="currency" class="formthin">
						<option value="" selected><cf_get_lang dictionary_id='57482.Aşama'>
						<cfoutput query="get_procurrency">
							<option value="#process_row_id#"<cfif isDefined("attributes.currency") and (attributes.currency eq process_row_id)>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
			</cf_box_search_detail>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57569.Görevli'></th>
					<th><cf_get_lang dictionary_id='57485.Öncelik'></th>
					<th><cf_get_lang dictionary_id='57501.Başlama'> </th>
					<th><cf_get_lang dictionary_id='57502.Bitiş'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
				</tr>
			</thead>
			<tbody>
				<cfif xml_show_without_project_choice>
					<tr class="color-row">
						<td height="20">&nbsp;</td>
						<!--- 20140623 fbs & mt: Projesiz secildiginde her yerde projesi olmayanlar gelsin diye eklendi, sorun olmazsa kaldirin
						<td colspan="7"><a href="javascript://" onClick="add_pro(<cfif isdefined("attributes.is_empty_project")>'-1'<cfelse>''</cfif>,'','Projesiz','','','','','','','');"><cf_get_lang_main no='1047.Projesiz'></a> (<cf_get_lang no='363.Herhangi bir projeye dahil edilmeyen işler için'>)</td>--->
						<td colspan="7"><a href="javascript://" onClick="add_pro('-1','','Projesiz','','','','','','','','','','','','','','','','','','','');"><cf_get_lang dictionary_id='58459.Projesiz'></a> (<cf_get_lang dictionary_id='32753.Herhangi bir projeye dahil edilmeyen işler için'>)</td>
					</tr>
				</cfif>
				<cfif (isdefined("attributes.form_varmi") or (isdefined("attributes.keyword") and len(attributes.keyword))) and get_projects.recordcount>
					<cfif isdefined("attributes.allproject") and attributes.allproject eq 1> 
						<tr class="color-row">
							<td height="20">&nbsp;</td>
							<td colspan="7"><a href="javascript://" onClick="add_pro('-2','','Tum Projeler','','','','','','','','','','','','','','','','','','','');"><cf_get_lang dictionary_id='31140.Tüm'> <cf_get_lang dictionary_id='58015.Projeler'></a></td>
						</tr>
					</cfif>
					<cfset partner_list = "">
					<cfset company_list = "">
					<cfset consumer_list = "">
					<cfset outsrc_partner_list = "">
					<cfset project_emp_list = "">
					<cfset priority_list = "">
					<cfset project_stage_list = "">
					<cfset project_category_list = "">
					<cfoutput query="get_projects" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(partner_id) and not listfind(partner_list,partner_id)>
							<cfset partner_list=listappend(partner_list,partner_id)>
						</cfif>
						<cfif len(company_id) and not listfind(company_list,company_id)>
							<cfset company_list=listappend(company_list,company_id)>
						</cfif>
						<cfif len(consumer_id) and not listfind(consumer_list,consumer_id)>
							<cfset consumer_list=listappend(consumer_list,consumer_id)>
						</cfif>
						<cfif len(outsrc_partner_id) and not listfind(outsrc_partner_list,outsrc_partner_id)>
							<cfset outsrc_partner_list=listappend(outsrc_partner_list,outsrc_partner_id)>
						</cfif>
						<cfif len(project_emp_id) and not listfind(project_emp_list,project_emp_id)>
							<cfset project_emp_list=listappend(project_emp_list,project_emp_id)>
						</cfif>
						<cfif len(pro_priority_id) and not listfind(priority_list,pro_priority_id)>
							<cfset priority_list=listappend(priority_list,pro_priority_id)>
						</cfif>
						<cfif len(pro_currency_id) and not listfind(project_stage_list,pro_currency_id)>
							<cfset project_stage_list=listappend(project_stage_list,pro_currency_id)>
						</cfif>
						<cfif len(process_cat) and not listfind(project_category_list,process_cat)>
							<cfset project_category_list=listappend(project_category_list,process_cat)>
						</cfif>
					</cfoutput>
					<cfif len(partner_list)>
						<cfset partner_list=listsort(partner_list,"numeric","ASC",",")>
						<cfquery name="get_part" datasource="#dsn#">
							SELECT
								PARTNER_ID,
								<cfif (database_type is 'MSSQL')>
									COMPANY_PARTNER_NAME +' '+ COMPANY_PARTNER_SURNAME AS PARTNER_NAME
								<cfelseif (database_type is 'DB2')>
									COMPANY_PARTNER_NAME ||' '|| COMPANY_PARTNER_SURNAME AS PARTNER_NAME
								</cfif>
							FROM
								COMPANY_PARTNER
							WHERE
								PARTNER_ID IN (#partner_list#)
							ORDER BY
								PARTNER_ID
						</cfquery>
						<cfset partner_list = listsort(listdeleteduplicates(valuelist(get_part.partner_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(company_list)>
						<cfset company_list=listsort(company_list,"numeric","ASC",",")>
						<cfquery name="get_comp" datasource="#dsn#">
							SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
						</cfquery>
						<cfset company_list = listsort(listdeleteduplicates(valuelist(get_comp.company_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(consumer_list)>
						<cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
						<cfquery name="get_cons" datasource="#dsn#">
							SELECT
								CONSUMER_ID,
								<cfif (database_type is 'MSSQL')>
									(CONSUMER_NAME +' '+ CONSUMER_SURNAME) AS COMPANY_NAME
								<cfelseif (database_type is 'DB2')>
									(CONSUMER_NAME ||' '|| CONSUMER_SURNAME) AS COMPANY_NAME
								</cfif>
							FROM
								CONSUMER
							WHERE
								CONSUMER_ID IN (#consumer_list#)
							ORDER BY
								CONSUMER_ID
						</cfquery>
						<cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_cons.consumer_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(outsrc_partner_list)>
						<cfset outsrc_partner_list=listsort(outsrc_partner_list,"numeric","ASC",",")>
						<cfquery name="get_company_partners" datasource="#dsn#">
							SELECT
								PARTNER_ID,
								COMPANY_PARTNER_NAME AS PARTNER_NAME,
								COMPANY_PARTNER_SURNAME AS PARTNER_SURNAME,
								COMPANY_PARTNER_EMAIL PARTNER_EMAIL
							FROM
								COMPANY_PARTNER
							WHERE
								PARTNER_ID  IN (#outsrc_partner_list#) 
							ORDER BY 
								PARTNER_ID
						</cfquery>
						<cfset outsrc_partner_list = listsort(listdeleteduplicates(valuelist(get_company_partners.partner_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(project_emp_list)>
						<cfset project_emp_list=listsort(project_emp_list,"numeric","ASC",",")>
						<cfquery name="get_emp" datasource="#dsn#">
							SELECT
								EMPLOYEE_ID,
								EMPLOYEE_NAME,
								EMPLOYEE_SURNAME,
								EMPLOYEE_EMAIL
							FROM
								EMPLOYEES
							WHERE
								EMPLOYEE_ID IN (#project_emp_list#)
							ORDER BY
								EMPLOYEE_ID
						</cfquery>
						<cfset project_emp_list = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(priority_list)>
						<cfset priority_list=listsort(priority_list,"numeric","ASC",",")>
						<cfquery name="get_prio" datasource="#dsn#">
							SELECT PRIORITY_ID,PRIORITY FROM SETUP_PRIORITY WHERE PRIORITY_ID IN (#priority_list#) ORDER BY PRIORITY_ID
						</cfquery>
						<cfset priority_list = listsort(listdeleteduplicates(valuelist(get_prio.priority_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(project_stage_list)>
						<cfset project_stage_list = listsort(project_stage_list,'numeric','ASC',',')>
						<cfquery name="get_currency_name" datasource="#dsn#">
							SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#project_stage_list#) ORDER BY PROCESS_ROW_ID
						</cfquery>
						<cfset project_stage_list = listsort(listdeleteduplicates(valuelist(get_currency_name.process_row_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(project_category_list)>
						<cfset project_category_list = listsort(project_category_list,'numeric','ASC',',')>
						<cfquery name="get_category_name" datasource="#dsn#">
							SELECT MAIN_PROCESS_CAT_ID, MAIN_PROCESS_CAT FROM SETUP_MAIN_PROCESS_CAT WHERE MAIN_PROCESS_CAT_ID IN (#project_category_list#) ORDER BY MAIN_PROCESS_CAT_ID
						</cfquery>
						<cfset project_category_list = listsort(listdeleteduplicates(valuelist(get_category_name.main_process_cat_id,',')),'numeric','ASC',',')>
					</cfif>
				</cfif>
				<cfif (isdefined("attributes.form_varmi") or (isdefined("attributes.keyword") and len(attributes.keyword))) and get_projects.recordcount>
					<cfoutput query="get_projects" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(company_list) and len(company_id)>
							<cfset company_name = get_comp.fullname[listfind(company_list,company_id,',')]>
						<cfelseif len(consumer_list) and len(consumer_id)>
							<cfset company_name = get_cons.company_name[listfind(consumer_list,consumer_id,',')]>
						<cfelse>
							<cfset company_name = ''>
						</cfif>
						<cfif len(partner_list)>
							<cfset partner_name = get_part.partner_name[listfind(partner_list,partner_id,',')]>
						<cfelse>
							<cfset partner_name = ''>
						</cfif>
						<cfset sdate=dateformat(target_start,dateformat_style)>
						<cfset fdate=dateformat(target_finish,dateformat_style)>
						<cfset p_sdate=dateformat(target_start,dateformat_style)>
						<cfset p_fdate=dateformat(target_finish,dateformat_style)>
						<cfset project_head_ = replace(project_head,"'"," ","all")>
						<cfset project_head_ = replace(project_head_,'"','','all')>
						<cfset company_name_ = Replace(company_name,"'","","all")>
						<cfset partner_name_ = Replace(partner_name,"'","","all")>
						<tr>
							<td>#project_number#</td>
							<td><a href="javascript://" onClick="add_pro('#project_id#','#company_id#','#project_head_#','#sdate#','#fdate#','#p_sdate#','#p_fdate#','#consumer_id#','#company_name_#','#partner_id#','#partner_name_#','#workgroup_id#','#project_emp_id#','#pro_employee#','#PAYMETHOD_NAME#','#PAYMETHOD_ID#','#CARD_PAYMETHOD_ID#','#PAYMENT_DUEDAY#','#commission_rate#','#PAYMENT_VEHICLE#','#expense#','#expense_id#')"><font color="#color#">#project_head#</font></a></td>
							<td><cfif len(project_category_list)>#get_category_name.main_process_cat[listfind(project_category_list,process_cat,',')]#</cfif></td>
							<td><cfif len(project_emp_list)>
									<a href="mailto:#get_emp.employee_email[listfind(project_emp_list,project_emp_id,',')]#"><font color="#color#">#get_emp.employee_name[listfind(project_emp_list,project_emp_id,',')]# #get_emp.employee_surname[listfind(project_emp_list,project_emp_id,',')]#</font></a>
								<cfelseif len(outsrc_partner_list)>
									<a href="mailto:#get_company_partners.partner_email[listfind(outsrc_partner_list,outsrc_partner_id,',')]#"><font color="#color#">#get_company_partners.partner_name[listfind(outsrc_partner_list,outsrc_partner_id,',')]# #get_company_partners.partner_surname[listfind(outsrc_partner_list,outsrc_partner_id,',')]#</font></a>
								</cfif>
							</td>
							<td><cfif len(priority_list)>
									<font color="#color#">#get_prio.priority[listfind(priority_list,pro_priority_id,',')]#</font>
								</cfif>
							</td>
							<td>#sdate#</td>
							<td>#fdate#</td>
							<td><font color="#color#">#get_currency_name.stage[listfind(project_stage_list,pro_currency_id,',')]#</font></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8">
							<cfif isdefined("attributes.form_varmi") or (isdefined("attributes.keyword") and len(attributes.keyword))><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.priority_cat)>
				<cfset url_string = "#url_string#&priority_cat=#priority_cat#">
			</cfif>
			<cfif len(attributes.project_cat)>
				<cfset url_string = "#url_string#&project_cat=#project_cat#">
			</cfif>
			<cfif isdefined("attributes.form_varmi")>
				<cfset url_string = "#url_string#&form_varmi=#attributes.form_varmi#" >
			</cfif>
			<cfif isdefined("attributes.project_status")>
				<cfset url_string = "#url_string#&project_status=#attributes.project_status#">
			</cfif>
			<cfif isdefined("attributes.member_type_")>
				<cfset url_string = "#url_string#&member_type_=#attributes.member_type_#">
			</cfif>
			<cfif isdefined("attributes.member_name_")>
				<cfset url_string = "#url_string#&member_name_=#attributes.member_name_#">
			</cfif>
			<cfif isdefined("attributes.company_id_")>
				<cfset url_string = "#url_string#&company_id_=#attributes.company_id_#">
			</cfif>
			<cfif isdefined("attributes.consumer_id_")>
				<cfset url_string = "#url_string#&consumer_id_=#attributes.consumer_id_#">
			</cfif>
			<cfif isdefined("attributes.draggable")>
				<cfset url_string = "#url_string#&draggable=#attributes.draggable#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_list_projects&keyword=#attributes.keyword#&currency=#attributes.currency#&PRIORITY_CAT=#attributes.PRIORITY_CAT##url_string#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$( "form[name=project_search] #keyword" ).focus();
	});
	function control()
	{
		if($('#function_param').val())
		{
			var action = $('form[name =project_search]').attr('action');
			action += $('#function_param').val() + '&project_id=' + $('#project_id').val() + '&project_cat_gln=' + $('#project_cat_gln').val();
			$('form[name =project_search]').attr('action', action);
		}
		return true;
	}
	<cfif not isdefined('attributes.form_varmi') and not (isdefined("attributes.keyword") and len(attributes.keyword))>
		var str_prod_control=0;
		if(document.basket && document.basket.hidden_values.basket_id && document.$("#basket_main_div #project_id").val().length && $("#basket_main_div #project_id").val() && $("#basket_main_div #project_head").val().length && $("#basket_main_div #project_head").val())
		{
			for(i=0;i<document.basket.items.length;i++)
			{
				if(document.basket.items[i].PRODUCT_ID)
				{
					str_prod_control = 1;
					break;
				}
			}
			if(str_prod_control == 1)
			{
				var get_basket_member_info = wrk_safe_query('obj_get_basket_project_info', 'dsn3', 0, document.basket.hidden_values.basket_id);
				if(get_basket_member_info.recordcount)
				{
					alert("<cf_get_lang dictionary_id='32683.Belgede Satırlar Seçilmiş Proje Değiştiremezsiniz'>");
					window.close();
				}
			}
		}	
	</cfif>
</script>
