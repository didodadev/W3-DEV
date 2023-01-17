<cf_get_lang_set module_name="account">
<cf_xml_page_edit fuseact="account.list_kebir">
<cfparam name="attributes.acc_code1_1" default="">
<cfparam name="attributes.acc_code2_1" default="">
<cfparam name="attributes.acc_code1_2" default="">
<cfparam name="attributes.acc_code2_2" default="">
<cfparam name="attributes.acc_code1_3" default="">
<cfparam name="attributes.acc_code2_3" default="">
<cfparam name="attributes.acc_code1_4" default="">
<cfparam name="attributes.acc_code2_4" default="">
<cfparam name="attributes.acc_code1_5" default="">
<cfparam name="attributes.acc_code2_5" default="">
<cfparam name="attributes.name1" default="">
<cfparam name="attributes.name2" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.form_is_submitted" default=0>
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_quantity" default="0">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_sub_project" default="">
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih="attributes.date1">
	<cfset attributes.date1 = dateformat(attributes.date1,'dd/mm/yyyy') >
<cfelse>
	<cfset attributes.date1 = "1/#month(now())#/#session.ep.period_year#">
</cfif>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih="attributes.date2">
	<cfset attributes.date2 = dateformat(attributes.date2,'dd/mm/yyyy')>
<cfelse>
	<cfset attributes.date2 = "#day(now())#/#month(now())#/#session.ep.period_year#">
</cfif>
<cfif (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
	<cfset attributes.form_is_submitted = 1>
<cfelse>
	<cfset attributes.form_is_submitted = 0>
</cfif>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		AND BRANCH.BRANCH_STATUS = 1
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfquery name="get_acc_card_type" datasource="#dsn3#">
    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
</cfquery>
<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
    <cfquery name="GET_DEPARTMANT" datasource="#DSN#">
        SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> ORDER BY DEPARTMENT_HEAD
    </cfquery>
</cfif>
<cfif attributes.form_is_submitted eq 1>
	<cfquery name="GET_ACCOUNT_NAME" datasource="#dsn2#">
		SELECT
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
			IFRS_CODE AS ACCOUNT_CODE,
			IFRS_NAME AS ACCOUNT_NAME
		<cfelse>
			ACCOUNT_CODE, 
			ACCOUNT_NAME 
		</cfif>
		FROM 
			ACCOUNT_PLAN 
		WHERE
			<cfif len(evaluate("attributes.acc_code1_1")) or len(evaluate("attributes.acc_code1_2")) or len(evaluate("attributes.acc_code1_3")) or len(evaluate("attributes.acc_code1_4")) or len(evaluate("attributes.acc_code1_5"))>
				(
					<cfloop from="1" to="5" index="kk">
						<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
							<cfif kk neq 1>OR</cfif>
							(
								1 = 1
								<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
									AND (<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>IFRS_CODE<cfelse>ACCOUNT_CODE</cfif> >= '#evaluate("attributes.acc_code1_#kk#")#' OR <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>IFRS_CODE<cfelse>ACCOUNT_CODE</cfif> = '#left(evaluate("attributes.acc_code1_#kk#"),3)#')
								</cfif>
								<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
									AND (<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>IFRS_CODE<cfelse>ACCOUNT_CODE</cfif> <= '#evaluate("attributes.acc_code2_#kk#")#' OR <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>IFRS_CODE<cfelse>ACCOUNT_CODE</cfif> = '#left(evaluate("attributes.acc_code2_#kk#"),3)#')
								</cfif>
							)
						</cfif>
					</cfloop>
				)
			</cfif>
		ORDER BY 
			<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
				IFRS_CODE
			<cfelse>
				ACCOUNT_CODE
			</cfif>
	</cfquery>
    <cfquery name="get_account_id" dbtype="query">
		  SELECT
			  ACCOUNT_CODE, 
			  ACCOUNT_NAME 
		  FROM 
			  GET_ACCOUNT_NAME 
		  WHERE 
			  ACCOUNT_CODE NOT LIKE '%.%'
		  ORDER BY
			  ACCOUNT_CODE
	</cfquery>
    <cfset attributes.totalrecords=get_account_id.recordcount>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset endrow=attributes.maxrows+attributes.startrow-1>
	<cfif attributes.totalrecords lt endrow><cfset endrow=attributes.totalrecords></cfif>
	<cfif isdefined('get_account_id.recordcount')>
		<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
			<cfset endrow=get_account_id.recordcount>
		</cfif>
	</cfif>
    
    
</cfif>
<script type="text/javascript">

	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById("branch_id").value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popupajax_list_departments&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
		else
		{
			var myList = document.getElementById("department");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
			myList.appendChild(txtFld);
		}
	}
	function search_kontrol()
	{
		if(list_kebir.date1.value.length){
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_kebir.date1.value, 'Başlangıç Tarihi'))
				return false;
		}
		if(list_kebir.date2.value.length){
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_kebir.date2.value, 'Bitiş Tarihi'))
				return false;
		}
		if((document.list_kebir.acc_code1_1.value=='') || (document.list_kebir.acc_code2_1.value==''))
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no ='1399.Muhasebe Kodu'>");
			return false;
		}
		if(document.list_kebir.is_excel.checked==false)
		{
			document.list_kebir.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.list_kebir</cfoutput>";
			return true;
		}
		else
		{
			document.list_kebir.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_list_kebir</cfoutput>";
			document.list_kebir.submit();
		}
	}
	function pencere_ac_kebir(str_alan_1,str_alan_2,str_alan){
		var txt_keyword = eval(str_alan + ".value" );
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_2+'&keyword='+txt_keyword,'list');
	}
	
	function pencere_ac()
	{
		if((document.list_kebir.acc_code1_1.value=='') || (document.list_kebir.acc_code2_1.value==''))
		{
			alert("<cf_get_lang no ='196.Önce Hesap Kodlarını Seçiniz'>!");
			return false;
		}
		if((document.list_kebir.date1.value=='') || (document.list_kebir.date2.value==''))
		{
			alert("<cf_get_lang no ='197.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		if (!search_kontrol())
			return false;
		code1=document.list_kebir.acc_code1_1.value;
		code2=document.list_kebir.acc_code2_1.value;
		date1=document.list_kebir.date1.value;
		date2=document.list_kebir.date2.value;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=report.popup_rapor_kebir&date1='+date1+'&date2='+date2+'&code1='+code1+'&code2='+code2,'wide');
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.list_kebir';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/display/list_kebir.cfm';
</cfscript>

