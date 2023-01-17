<!--- 
açan penceredeki istenen alana seçilenleri kaydeder
	field_name : pozisyon adı gelecek
	field_id : pozisyon id si gelecek
	field_code: pozisyon kodu gelecek
	field_emp_id:employee_id
örnek kullanım :
	<a href="#" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_name.field_code&field_name=form_name.text_input_name</cfoutput>','list')"> Gidecekler </a>

Not : show_empty_pos=1 parametresi ile sadece pozisyonlar görüntülenir (boş ve dolular)
	Eğer Bir Kısıt Varsa Lütfen Bunu Employee_list değişkeni içerisinde gönderin
Sayfa Üzerinden şube ve departmanlar ile company bilgileri çekileilir hale getirildi
	
	field_name : pozisyon adı gelecek
	field_id : pozisyon id si gelecek
	field_pos_cat_id : pozisyon tip id si gelecek
	field_pos_cat_name : pozisyon tipi gelecek
	field_code: pozisyon kodu gelecek
	field_emp_id:employee_id
	
	field_pos_name : Pozisyon İsmi
	field_dep_name : Departman İsmi
	field_dep_id   : Departman ID'si
	field_branch_name : Şube İsmi
	field_branch_id : Şube Id'si
	field_comp : Company ismi
	field_comp_id : Company ID'si
	field_head : grup başkanlıgi
	field_head_id : grup baskanlıgı id
	
Örnek Kullanım	:
<a href="javascript://" 
onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions
&field_code=form_name.position_id
&field_pos_name=form_name.app_position
&field_dep_name=form_name.department
&field_dep_id=form_name.department_id
&field_branch_name=form_name.branch
&field_branch_id=form_name.branch_id
&field_branch_and_dep=form_name.department ve branch ismini atıyor
&field_comp=form_name.our_company
&field_comp_id=form_name.our_company_id
&field_name=form_name.text_input_name
&show_empty_pos=1&select_list=1','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
--->
<cf_xml_page_edit fuseact="objects.popup_list_positions">
<cf_get_lang_set module_name="objects">
<cfparam name="attributes.filtre_by_dept_id" default="">
<cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfquery name="GET_POSITIONS" datasource="#DSN#">
        SELECT
			BRANCH.BRANCH_ID,
            BRANCH.BRANCH_NAME,
            DEPARTMENT.DEPARTMENT_ID,
            DEPARTMENT.DEPARTMENT_HEAD,
            OUR_COMPANY.NICK_NAME,
            OUR_COMPANY.COMP_ID,
            SETUP_POSITION_CAT.POSITION_CAT,
            EMPLOYEE_POSITIONS.POSITION_CAT_ID,
            EMPLOYEE_POSITIONS.DEPARTMENT_ID,
            EMPLOYEE_POSITIONS.POSITION_ID,
            EMPLOYEE_POSITIONS.POSITION_CODE,
            EMPLOYEE_POSITIONS.POSITION_NAME,
            EMPLOYEE_POSITIONS.EMPLOYEE_ID,
            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
            EMPLOYEES.EMPLOYEE_EMAIL,
			EMPLOYEES.GROUP_STARTDATE
        FROM
            EMPLOYEE_POSITIONS,
            EMPLOYEES,
            OUR_COMPANY,
            SETUP_POSITION_CAT,
			BRANCH,
            DEPARTMENT
        WHERE
			EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
        	OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
        	DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			EMPLOYEE_POSITIONS.DEPARTMENT_ID  = DEPARTMENT.DEPARTMENT_ID AND
            EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
            EMPLOYEE_POSITIONS.POSITION_STATUS = 1
            <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
            	AND EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            </cfif>
            <cfif isDefined('attributes.branch_id') and len(attributes.branch_id)>
            	AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
            </cfif>
            <cfif isDefined('attributes.department_id') and len(attributes.department_id)>
            	AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
            </cfif>
            <cfif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                AND EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
            </cfif>
            <cfif isDefined("attributes.position_code") and len(attributes.position_code)>
                AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
            </cfif>
    </cfquery>
<cfelse>
	<cfset GET_POSITIONS.recordcount = 0>
</cfif>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_NAME,
		BRANCH_ID	
	FROM 
		BRANCH
	WHERE 
		BRANCH_ID IS NOT NULL
		<cfif isDefined("attributes.our_cid")>AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"></cfif>
		<!---<cfif isdefined("attributes.branch_related")>AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)</cfif>--->
	ORDER BY
		BRANCH_NAME
</cfquery>
<!--- Branchler session'daki company_id'ye göre getirilebilir...our_cid paramateresi bu yüzden eklendi--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.page" default=1>
<cfif not isNumeric(attributes.maxrows)>
	<cfset attributes.maxrows = session.pp.maxrows>
</cfif>
<cfparam name="attributes.totalrecords" default='#GET_POSITIONS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function add_pos(id,name,code,emp_id,branch_name,branch_id,dep_name,dep_id,mail,pos_name,company,company_id,head,head_id,row_acc_code,pos_cat_id,pos_cat_name)
{	
	<cfif isdefined("attributes.field_partner")>
		window.opener.document.<cfoutput>#field_partner#</cfoutput>.value = "";
	</cfif>
	<cfif isdefined("attributes.field_consumer")>
		if(window.opener.document.getElementById('<cfoutput>#listlast(field_consumer,'.')#</cfoutput>') != undefined)
			window.opener.document.getElementById('<cfoutput>#listlast(field_consumer,'.')#</cfoutput>').value = "";
		else
			window.opener.document.<cfoutput>#field_consumer#</cfoutput>.value = "";
	</cfif>
	<cfif isdefined("attributes.field_comp_name")> 
		window.opener.document.<cfoutput>#attributes.field_comp_name#</cfoutput>.value = ""; 
	</cfif>
	<cfif isdefined("attributes.field_pos_name")>
		window.opener.document.<cfoutput>#attributes.field_pos_name#</cfoutput>.value = pos_name;
	</cfif>
	<cfif isdefined("attributes.field_emp_id2")>
		window.opener.document.<cfoutput>#attributes.field_emp_id2#</cfoutput>.value = emp_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		if(window.opener.document.<cfoutput>#attributes.field_name#</cfoutput> != undefined)
			window.opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
		else
			window.opener.document.getElementById('<cfoutput>#field_name#</cfoutput>').value = name;
	</cfif>
	<cfif isdefined("attributes.field_type")>
		window.opener.document.<cfoutput>#field_type#</cfoutput>.value = "employee";
	</cfif>
	<cfif isdefined("attributes.field_id")>
		window.opener.document.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_pos_cat_name")>
		window.opener.document.<cfoutput>#field_pos_cat_name#</cfoutput>.value = pos_cat_name;
	</cfif>
	<cfif isdefined("attributes.field_pos_cat_id")>
		window.opener.document.<cfoutput>#field_pos_cat_id#</cfoutput>.value = pos_cat_id;
	</cfif>
	 <cfif isdefined("attributes.field_id2")>
		window.opener.document.<cfoutput>#field_id2#</cfoutput>.value += "," + id + ",";    /*position_id*/
	</cfif>
	<cfif isdefined("attributes.field_emp_mail")>
		if (mail.length)    
			 window.opener.document.<cfoutput>#field_emp_mail#</cfoutput>.value = mail;			 
		else
		{
			 alert("<cf_get_lang no='187.Maili olmayan birisini seçtiniz Lütfen başka birisini seçiniz'> !");
			 return false;
		}		
	</cfif>
	<cfif isdefined("attributes.field_code")>
		window.opener.document.<cfoutput>#field_code#</cfoutput>.value = code;
	</cfif>
	<cfif isdefined("attributes.field_comp")>
		window.opener.document.<cfoutput>#field_comp#</cfoutput>.value =  company; 
	</cfif>
	<cfif isdefined("attributes.field_comp_id")>
		window.opener.document.<cfoutput>#field_comp_id#</cfoutput>.value = ''; 
	</cfif>
	<cfif isdefined("attributes.field_emp_id")>
		if(window.opener.document.<cfoutput>#field_emp_id#</cfoutput> != undefined)
			window.opener.document.<cfoutput>#field_emp_id#</cfoutput>.value = emp_id;
		else
			window.opener.document.getElementById('<cfoutput>#field_emp_id#</cfoutput>').value = emp_id;
	</cfif>
	<cfif isdefined("attributes.field_dep_name")>
		window.opener.document.<cfoutput>#field_dep_name#</cfoutput>.value = dep_name;
	</cfif>
	<cfif isdefined("attributes.field_dep_id")>
		window.opener.document.<cfoutput>#field_dep_id#</cfoutput>.value = dep_id;
	</cfif>
	<cfif isdefined("attributes.field_branch_name")>
		window.opener.document.<cfoutput>#field_branch_name#</cfoutput>.value = branch_name;
	</cfif>
	<cfif isdefined("attributes.field_branch_id")>
		window.opener.document.<cfoutput>#field_branch_id#</cfoutput>.value = branch_id;
	</cfif>
	<cfif isdefined("attributes.field_branch_and_dep")>
		window.opener.document.<cfoutput>#field_branch_and_dep#</cfoutput>.value = branch_name+'/'+dep_name;
	</cfif>
	<cfif isdefined("attributes.field_member_account_code")>
		window.opener.document.<cfoutput>#field_member_account_code#</cfoutput>.value = row_acc_code;
	</cfif>
	<cfif isdefined("attributes.field_member_account_id")>
		window.opener.document.<cfoutput>#field_member_account_id#</cfoutput>.value = row_acc_code;
	</cfif>
	<cfif isdefined("attributes.basket_cheque")>
		window.opener.document.reload_basket();
	</cfif>
	<cfif isdefined("attributes.islem")>
		window.opener.document.time_cost.work_head.value = "";
		window.opener.document.time_cost.event_head.value = "";
		window.opener.document.time_cost.emp_name.value = "";
		window.opener.document.time_cost.expense.value = "";
		window.opener.document.time_cost.islem.value = "emp";
	</cfif>
	
	<cfif isdefined("attributes.cash_control_upd")>
		window.opener.document.upd_cash_payment.cash_action_to_company_id.value="";
		window.opener.document.upd_cash_payment.comp_name.value="";
	</cfif>
	
	<cfif isdefined("attributes.cash_control_add")>
		window.opener.document.add_cash_payment.cash_action_to_company_id.value="";
		window.opener.document.add_cash_payment.comp_name.value="";
	</cfif>
	
	<cfif isDefined("attributes.field_table")>
		window.opener.document.<cfoutput>#attributes.field_table#</cfoutput>.innerHTML += "<table class='label'><tr><td>"+name+"</td></tr></table>";
	</cfif>
	<cfif isDefined("attributes.field_pos_table")>
		window.opener.document.getElementById('<cfoutput>#attributes.field_pos_table#</cfoutput>').innerHTML += "<table class='label'><tr><td>("+pos_name+")</td></tr></table>";
	</cfif>
	<cfif isDefined("attributes.field_pos")>
		window.opener.document.<cfoutput>#attributes.field_pos#</cfoutput>.value += "," + code + ",";
	</cfif>
	<cfif isdefined("attributes.ssk_healty")>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.employee_relative_ssk&event=add&field_name=popup_ssk_healty_print.ill_name&field_surname=popup_ssk_healty_print.ill_surname&field_relative=popup_ssk_healty_print.ill_relative&field_birth_date=popup_ssk_healty_print.ill_bdate&field_birth_place=popup_ssk_healty_print.ill_bplace&employee_id=emp_id','medium');
	</cfif>
	<cfif isdefined("attributes.run_function")>
		window.opener.document.<cfoutput>#attributes.run_function#</cfoutput>();
	</cfif>
	<cfif isdefined("attributes.field_head")>
		window.opener.document.<cfoutput>#field_head#</cfoutput>.value = head;
	</cfif>
	<cfif isdefined("attributes.field_head_id")>
		window.opener.document.<cfoutput>#field_head_id#</cfoutput>.value = head_id;
	</cfif>
	
	<cfif isdefined("attributes.call_function")>
		<cfif listlen(attributes.call_function,'-') gt 1>
			<cfloop from="1" to="#listlen(attributes.call_function,'-')#" index="call_i">
				try{opener.<cfoutput>#listgetat(attributes.call_function,call_i,'-')#</cfoutput>;}
					catch(e){};
			</cfloop>			
		<cfelse>
			try{opener.<cfoutput>#attributes.call_function#</cfoutput>;}
			catch(e){};
		</cfif>
	</cfif>
	if(typeof(opener.set_price_catid_options) != 'undefined')  //basketteki fiyat listelerini dolu getirmek icin eklendi.
		{
			try{opener.set_price_catid_options();}
				catch(e){};
		}
	<cfif isdefined('attributes.function_name')>
		window.opener.top.<cfoutput>#function_name#</cfoutput>(emp_id,1);
	</cfif>
	<cfif isdefined("attributes.field_name")>
		if(window.opener.document.<cfoutput>#field_name#</cfoutput> != undefined)
			window.opener.document.<cfoutput>#field_name#</cfoutput>.focus();
		else
			window.opener.document.getElementById('<cfoutput>#field_name#</cfoutput>').focus();
	</cfif>
	<cfif isDefined("attributes.url_direction") and isDefined("attributes.url_param")>
		<cfoutput>
		window.location='#request.self#?fuseaction=#attributes.url_direction#&#attributes.url_param#=#evaluate("attributes."&attributes.url_param)#&POS_ID=' + code;		
		</cfoutput>
	<cfelseif not isdefined("attributes.window_close")>
		window.close();
	</cfif>
}
function reloadopener()
{
	wrk_opener_reload();
	window.close();
}
</script>
<cfparam name="select_list" default="1,2,3,4,5,6">
<cfif not listcontainsnocase(select_list,9) and isdefined("attributes.field_emp_id")>
	<cfset select_list = listappend(select_list,'9')>
</cfif>
<cfscript>
	url_string = '';
	if (isdefined('attributes.is_buyer_seller')) url_string = '#url_string#&is_buyer_seller=#attributes.is_buyer_seller#';
	if (isdefined('attributes.is_cari_action')) url_string = '#url_string#&is_cari_action=#attributes.is_cari_action#';
	if (isdefined('attributes.field_basket_due_value')) url_string = '#url_string#&field_basket_due_value=#field_basket_due_value#';
	if (isdefined('attributes.field_paymethod_id')) url_string = '#url_string#&field_paymethod_id=#field_paymethod_id#';
	if (isdefined('attributes.field_paymethod')) url_string = '#url_string#&field_paymethod=#field_paymethod#';
	if (isdefined('attributes.basket_cheque')) url_string = '#url_string#&basket_cheque=1';
	if (isdefined('attributes.islem')) url_string = '#url_string#&islem=#islem#';
	if (isdefined('attributes.field_comp')) url_string = '#url_string#&field_comp=#field_comp#';
	if (isdefined('attributes.field_comp_name')) url_string = '#url_string#&field_comp_name=#field_comp_name#';
	if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#field_comp_id#';
	if (isdefined('attributes.field_name')) url_string = '#url_string#&field_name=#field_name#';
	if (isdefined('attributes.field_id')) url_string = '#url_string#&field_id=#field_id#';
	if (isdefined('attributes.field_pos_cat_id')) url_string = '#url_string#&field_pos_cat_id=#field_pos_cat_id#';
	if (isdefined('attributes.field_pos_cat_name')) url_string = '#url_string#&field_pos_cat_name=#field_pos_cat_name#';
	if (isdefined('attributes.field_pos_name')) url_string = '#url_string#&field_pos_name=#field_pos_name#';
	if (isdefined('attributes.field_id2')) url_string = '#url_string#&field_id2=#field_id2#';
	if (isdefined('attributes.field_partner')) url_string = '#url_string#&field_partner=#field_partner#';
	if (isdefined('attributes.field_type')) url_string = '#url_string#&field_type=#field_type#';
	if (isdefined('attributes.field_emp_mail')) url_string = '#url_string#&field_emp_mail=#field_emp_mail#';
	if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#field_emp_id#';
	if (isdefined('attributes.field_pos_table')) url_string = '#url_string#&field_pos_table=#field_pos_table#';
	if (isdefined('attributes.field_code')) url_string = '#url_string#&field_code=#field_code#';
	if (isdefined('attributes.add_emp')) url_string = '#url_string#&add_emp=#add_emp#';
	if (isdefined('attributes.field_branch_name')) url_string = '#url_string#&field_branch_name=#field_branch_name#';
	if (isdefined('attributes.field_branch_id')) url_string = '#url_string#&field_branch_id=#field_branch_id#';
	if (isdefined('attributes.field_dep_name')) url_string = '#url_string#&field_dep_name=#field_dep_name#';
	if (isdefined('attributes.field_branch_and_dep')) url_string = '#url_string#&field_branch_and_dep=#field_branch_and_dep#';
	if (isdefined('attributes.field_dep_id')) url_string = '#url_string#&field_dep_id=#field_dep_id#';
	if (isdefined('attributes.field_consumer')) url_string = '#url_string#&field_consumer=#field_consumer#';
	if (isdefined('attributes.camp_id')) url_string = '#url_string#&camp_id=#camp_id#';
	if (isdefined('attributes.show_empty_pos')) url_string = '#url_string#&show_empty_pos=#show_empty_pos#';
	if (isdefined('attributes.field_table')) url_string = '#url_string#&field_table=#field_table#';
	if (isdefined('attributes.function_name')) url_string = '#url_string#&function_name=#function_name#';
	if (isdefined('attributes.field_cons_table')) url_string = '#url_string#&field_cons_table=#field_cons_table#';
	if (isdefined('attributes.field_pars')) url_string = '#url_string#&field_pars=#field_pars#';
	if (isdefined('attributes.field_cons')) url_string = '#url_string#&field_cons=#field_cons#';
	if (isdefined('attributes.field_pos')) url_string = '#url_string#&field_pos=#field_pos#';
	if (isdefined('attributes.field_member_account_code')) url_string = '#url_string#&field_member_account_code=#field_member_account_code#';
	if (isdefined('attributes.field_member_account_id')) url_string = '#url_string#&field_member_account_id=#field_member_account_id#';
	if (isdefined('attributes.select_list')) url_string = '#url_string#&select_list=#select_list#';
	if (isdefined("attributes.url_direction")) url_string = "#url_string#&url_direction=#url_direction#";
	if (isdefined("attributes.url_param")) url_string = "#url_string#&url_param=#url_param#";
	if (isdefined("attributes.field_emp_id2")) url_string = "#url_string#&field_emp_id2=#attributes.field_emp_id2#";
	if (isdefined("attributes.run_function")) url_string = "#url_string#&run_function=#attributes.run_function#";
	if (isdefined("attributes.is_store_module")) url_string = "#url_string#&is_store_module=#attributes.is_store_module#";
	if (isdefined("attributes.is_account_code")) url_string = "#url_string#&is_account_code=#attributes.is_account_code#";
	if (isdefined("attributes.branch_related")) url_string = "#url_string#&branch_related=#attributes.branch_related#"; // yetkili şubelere göre... Onur P.
	if (isdefined("attributes.our_cid")) url_string = "#url_string#&our_cid=#attributes.our_cid#"; // session.ep.company_id' ye göre branchler getirilmek istenirse...
	if (isdefined('attributes.field_head_id')) url_string = '#url_string#&field_head_id=#attributes.field_head_id#';
	if (isdefined('attributes.field_head')) url_string = '#url_string#&field_head=#attributes.field_head#';
	if (isdefined("attributes.field_mail")) url_string = "#url_string#&field_mail=#attributes.field_mail#";
	if (isdefined('attributes.control_pos')) url_string = '#url_string#&control_pos=#control_pos#';
	if (isdefined("attributes.pos_code")) url_string = "#url_string#&pos_code=#attributes.pos_code#";
	if (isdefined("attributes.pos_code_text")) url_string = "#url_string#&pos_code_text=#attributes.pos_code_text#";
	if (isdefined("attributes.field_mobile_tel")) url_string = "#url_string#&field_mobile_tel=#attributes.field_mobile_tel#";
	if (isdefined("attributes.field_mobile_tel_code")) url_string = "#url_string#&field_mobile_tel_code=#attributes.field_mobile_tel_code#";
	if (isdefined("attributes.field_tel")) url_string = "#url_string#&field_tel=#attributes.field_tel#";
	if (isdefined("attributes.field_tel_number")) url_string = "#url_string#&field_tel_number=#attributes.field_tel_number#";
	if (isdefined("attributes.field_tel_code")) url_string = "#url_string#&field_tel_code=#attributes.field_tel_code#";
	if (isdefined("attributes.process_row_id")) url_string = "#url_string#&process_row_id=#attributes.process_row_id#";
	if (isdefined("attributes.tree_category_id")) url_string = "#url_string#&tree_category_id=#attributes.tree_category_id#";
	if (isdefined("attributes.process_date")) url_string = "#url_string#&process_date=#attributes.process_date#";
	if (isdefined("attributes.call_function")) url_string = "#url_string#&call_function=#attributes.call_function#";
	if (isdefined("attributes.window_close")) url_string = "#url_string#&window_close=#attributes.window_close#";
	if (isdefined("attributes.upper_pos_code")) url_string = "#url_string#&upper_pos_code=#attributes.upper_pos_code#";
	if (isdefined("attributes.is_rate_select")) url_string = "#url_string#&is_rate_select=#attributes.is_rate_select#";
	if (isdefined("attributes.url_param"))
	{
		if (isdefined(attributes.url_param)) url_string = "#url_string#&#attributes.url_param#=#evaluate('attributes.'&attributes.url_param)#";
	}
	url_string2 = '&is_form_submitted=1';
	if (isdefined('attributes.branch_id')) url_string2 = '#url_string2#&branch_id=#attributes.branch_id#';
	if (isdefined('attributes.department_id')) url_string2 = '#url_string2#&department_id=#attributes.department_id#';
	if (isdefined('attributes.emp_process_row_id')) url_string2 = '#url_string2#&emp_process_row_id=#attributes.emp_process_row_id#';
	if (isdefined("attributes.tree_category_id") and len(attributes.tree_category_id) and isdefined("attributes.sub_tree_category_id"))  url_string2 = '#url_string2#&sub_tree_category_id=#attributes.sub_tree_category_id#';
</cfscript>
<!---<cfsavecontent variable="head_">
	<cfoutput>
		<select name="categories" id="categories" onChange="location.href=this.value;">
			<cfif listcontainsnocase(select_list,1)>
				<option value="#request.self#?fuseaction=objects.popup_list_positions#url_string#"  <cfif fusebox.fuseaction is not "popup_list_all_positions">selected</cfif>><cf_get_lang_main no='1463.Çalışanlar'></option>
			</cfif>
			<cfif listcontainsnocase(select_list,2)>
				<option value="#request.self#?fuseaction=objects.popup_list_pars#url_string#&is_priority_off=1"><cf_get_lang no='605.C Kurumsal Üyeler'></option>
			</cfif>
			<cfif listcontainsnocase(select_list,3)>
				<option value="#request.self#?fuseaction=objects.popup_list_cons#url_string#"><cf_get_lang no='606.C Bireysel Üyeler'></option>
			</cfif>
			<cfif listcontainsnocase(select_list,4)>
				<option value="#request.self#?fuseaction=objects.popup_list_grps#url_string#"><cf_get_lang no='326.Gruplar'></option>
			</cfif>
			<cfif listcontainsnocase(select_list,5)>
				<option value="#request.self#?fuseaction=objects.popup_list_pot_cons#url_string#"><cf_get_lang no='573.P Bireysel Üyeler'></option>
			</cfif>
			<cfif listcontainsnocase(select_list,6)>
				<option value="#request.self#?fuseaction=objects.popup_list_pot_pars#url_string#&is_priority_off=1"><cf_get_lang no='574.P Kurumsal Üyeler'></option>
			</cfif>
			<cfif listcontainsnocase(select_list,7)>
				<option value="#request.self#?fuseaction=objects.popup_list_all_pars#url_string#&is_priority_off=1"><cf_get_lang_main no='1611.Kurumsal Üyeler'></option>
			</cfif>
			<cfif listcontainsnocase(select_list,8)>
				<option value="#request.self#?fuseaction=objects.popup_list_all_cons#url_string#"><cf_get_lang_main no='1609.Bireysel Üyeler'></option>
			</cfif>
			<cfif listcontainsnocase(select_list,9)>
				<option value="#request.self#?fuseaction=objects.popup_list_all_positions#url_string#" <cfif fusebox.fuseaction is "popup_list_all_positions">selected</cfif>><cf_get_lang no='19.Tüm Çalışanlar'></option>
			</cfif>
		</select>
	</cfoutput>
</cfsavecontent>--->
<table cellspacing="1" cellpadding="2" class="color-border" align="center" style="width:100%;">
    <tr class="color-row">
        <td>
            <cfoutput>
                <td>&nbsp;</td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=A">A</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=B">B</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=C">C</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=Ç">Ç</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=D">D</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=E">E</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=F">F</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=G">G</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=Ğ">Ğ</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=H">H</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=I">I</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=İ">İ</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=J">J</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=K">K</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=L">L</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=M">M</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=N">N</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=O">O</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=Ö">Ö</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=P">P</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=Q">Q</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=R">R</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=S">S</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=Ş">Ş</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=T">T</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=U">U</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=Ü">Ü</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=V">V</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=W">W</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=Y">Y</a></td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&keyword=Z">Z</a></td>
                <td>&nbsp;</td>
            </cfoutput>
        </td>
    </tr>
</table>
<cfform name="search" method="post" action="#request.self#?fuseaction=#attributes.fuseaction##url_string#">    
    <table cellpadding="0" cellspacing="0" align="center" style="width:98%; height:35px;">
        <tr>
      		<td class="headbold">Çalışanlar</td>
            <td>
                <table style="text-align:right;">
                    <tr>
                        <td><cf_get_lang_main no='48.Filtre'></td>
                        <td><input type="text" name="keyword" id="keyword" maxlength="50" value="<cfoutput>#attributes.keyword#</cfoutput>" style="width:100px;"></td>
                        <td><input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
                            <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
                            <select name="branch_id" id="branch_id" style="width:200px;">
                                <option value=""><cf_get_lang_main no='1637.Şubeler'></option>
                                <cfoutput query="get_branches">
                                    <option value="#branch_id#"<cfif branch_id eq attributes.branch_id> selected</cfif>>#branch_name#</option>
                                </cfoutput>
                            </select>
                            <cfif xml_filtre_by_dept_id eq 1 and len(xml_department_id)>
                                <!--- modified : MA 20120718 xml den gelen dept idlere gore filtreleme yapilir --->
                                <cf_get_lang_main no='37.Satınalma'><input type="checkbox" name="filtre_by_dept_id" id="filtre_by_dept_id" value="1" <cfif attributes.filtre_by_dept_id eq 1>checked</cfif>>
                            </cfif>
                        </td>
                        <cfif isdefined("attributes.tree_category_id") and len(attributes.tree_category_id)>
                            <td><select name="sub_tree_category_id" id="sub_tree_category_id" style="width:160px;">
                                    <option value="0" <cfif isdefined('attributes.sub_tree_category_id') and attributes.sub_tree_category_id eq 0>selected</cfif>><cf_get_lang no='1884.Alt Tree Yetkilisine Bakmasın'></option>
                                    <option value="1" <cfif not isdefined('attributes.sub_tree_category_id') or attributes.sub_tree_category_id eq 1>selected</cfif>><cf_get_lang no='1885.Alt Tree Yetkilisine Baksın'></option>
                                </select>
                            </td>
                        </cfif>
                        <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" required="yes" onKeyUp="isNumber(this)" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button></td>
                    </tr>
                </table>
            </td>
        </tr>		
	</table>
</cfform>
<cfif not isdefined("attributes.show_empty_pos")>
	<table cellspacing="1" cellpadding="2" class="color-border" align="center" style="width:98%;">	
    	<thead>
            <tr class="color-header" style="height:22px;">
                <cfset colspan = 3>
                <th class="form-title"><cf_get_lang_main no='158.Ad Soyad'></th>
                <th class="form-title"><cf_get_lang_main no='1085.Pozisyon'></th>
                <cfif isdefined('is_company_view') and is_company_view eq 1>
                    <th class="form-title"><cf_get_lang_main no='162.Şirket'></th>
                    <cfset colspan = colspan + 1>
                </cfif>
                <cfif isdefined('is_branch_view') and is_branch_view eq 1>
                    <th class="form-title"><cf_get_lang_main no='41.Şube'></th>
                    <cfset colspan = colspan + 1>
                </cfif>
                <cfif isdefined('is_department_view') and is_department_view eq 1>
                    <th class="form-title"><cf_get_lang_main no='160.Departman'></th>
                    <cfset colspan = colspan + 1>
                </cfif>
                <cfif isdefined('is_group_date') and is_group_date eq 1>
                    <th class="form-title" style="width:13%;"><cf_get_lang no='951.Gruba G T'></th>
                    <cfset colspan = colspan + 1>
                </cfif>
                <th></th>
            </tr>
        </thead>
        <tbody>
		<cfif get_positions.recordcount>
            <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif isdefined("attributes.field_member_account_code")>
                    <cfset row_acc_code = '#ACCOUNT_CODE#'>
                <cfelse>
                    <cfset row_acc_code = ''>
                </cfif>
                <tr class="color-row" style="height:20px;">
                    <td nowrap>
                        <cfif not isdefined("url.trans")>
                            <cfif isdefined("acc_type_id") and len(acc_type_id) and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and isdefined("x_add_multi_acc") and x_add_multi_acc eq 1>
                                <a href="javascript:add_pos('#position_id#','#employee_name# #employee_surname#-#acc_type_name#','#position_code#','#employee_id#_#acc_type_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','',<cfif len(get_positions.headquarters_id)>'#get_positions.headquarters_id#'<cfelse>''</cfif>,'#row_acc_code#','#position_cat_id#','#position_cat#');" class="tableyazi">#employee_name# #employee_surname#</a>
                            <cfelse>
                                <a href="javascript:add_pos('#position_id#','#employee_name# #employee_surname#','#position_code#','#employee_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','','','#row_acc_code#','#position_cat_id#','#position_cat#');" class="tableyazi">#employee_name# #employee_surname#</a>
                            </cfif>
                        <cfelse>
                            #employee_name# #employee_surname#
                        </cfif>
                        <cfif isdefined("acc_type_name") and len(acc_type_name)>-#acc_type_name#</cfif>
                    </td>
                    <td><cfif isdefined("url.trans")>
                            <cfif isdefined("acc_type_id") and len(acc_type_id) and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and isdefined("x_add_multi_acc") and x_add_multi_acc eq 1>
                                <a href="javascript:add_pos('#position_id#','#employee_name# #employee_surname#','#position_code#','#employee_id#_#acc_type_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','',<cfif len(get_positions.headquarters_id)>'#get_positions.headquarters_id#'<cfelse>''</cfif>,'#row_acc_code#','#position_cat_id#','#position_cat#');" class="tableyazi">#position_name#</a>
                            <cfelse>
                                <a href="javascript:add_pos('#position_id#','#employee_name# #employee_surname#','#position_code#','#employee_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','',<cfif len(get_positions.headquarters_id)>'#get_positions.headquarters_id#'<cfelse>''</cfif>,'#row_acc_code#','#position_cat_id#','#position_cat#');" class="tableyazi">#position_name#</a>
                            </cfif>
                        <cfelse>
                            <!---<cfif is_master eq 1>
                                #position_name# 
                            <cfelse>--->
                                #position_name# <cf_get_lang no='227.Ek Pozisyon'>
                            <!---</cfif>--->
                        </cfif>
                    </td>
                    <cfif isdefined('is_company_view') and is_company_view eq 1>
                    	<td>#nick_name#</td>
                    </cfif>
                    <cfif isdefined('is_branch_view') and is_branch_view eq 1>
                    	<td>#branch_name#</td>
                    </cfif>
                    <cfif isdefined('is_department_view') and is_department_view eq 1>
                    	<td>#department_head#</td>
                    </cfif>
                    <cfif isdefined('is_group_date') and is_group_date eq 1>
                    	<td>#dateformat(group_startdate,'dd/mm/yyyy')#</td>
                    </cfif>
                    <td style="text-align:center;">
                        <cfif not isdefined("attributes.show_empty_pos")>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_emp_det&department_id=#department_id#&emp_id=#employee_id#&pos_id=#position_code##url_string#','medium');"><img src="/images/report_square2.gif"></a>
                        </cfif>
                    </td>
                </tr>
                <cfif isdefined('x_is_process_date_control') and x_is_process_date_control eq 1>
                    <tr style="display:none;height:20px;" id="row_emp_info_#currentrow#" class="nohover">
                        <td colspan="9">
                            <div id="div_emp_info_#currentrow#" style="background-color: #colorrow#; display:none; outset cccccc;"></div>
                        </td>
                    </tr>
                </cfif>
            </cfoutput>
        <cfelse>
            <tr style="height:20px;" class="color-row"> 
                <td colspan="<cfoutput>#colspan#</cfoutput>">
                    <cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))>
                        <cf_get_lang_main no='72.Kayıt Yok'>!
                    <cfelse>
                        <cf_get_lang_main no='289.Filtre Ediniz '>!
                    </cfif>
                </td>
            </tr>
        </cfif>
        </tbody>
    </table>
<cfelse>
	<table cellspacing="1" cellpadding="2" class="color-border" align="center" style="width:98%;">	
    	<thead>
            <tr style="height:22px;">
            	<cfset colspan = 5>
                <th><cf_get_lang_main no='1085.Pozisyon'></th>
                <th><cf_get_lang_main no='162.Şirket'></th>
                <th><cf_get_lang_main no='158.Ad Soyad'></th>
                <th><cf_get_lang_main no='41.Şube'></th>
                <th><cf_get_lang_main no='160.Departman'></th>
            </tr>
     	</thead>
     	<tbody>
			<cfif get_positions.recordcount>
                <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr style="height:20px;">
                        <td>
                            <cfif not isdefined("url.trans")>
                                <a href="javascript://" class="tableyazi"  onClick="add_pos('#position_id#','#employee_name# #employee_surname#','#position_code#','#employee_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','','')">#position_name#</a>
                            <cfelse>
                                <!---<cfif is_master eq 1>
                                    #position_name# 
                                <cfelse>--->
                                    #position_name# <cf_get_lang no='199.Ek'>
                                <!---</cfif>--->
                            </cfif>
                        </td>
                        <td>#nick_name#</td>
                        <td><cfif employee_id eq 0><font color="##FF0000"><cf_get_lang no='455.Boş'></font><cfelse>#employee_name# #employee_surname#</cfif></td>
                        <td>#branch_name#</td>
                        <td>#department_head#</td>
                    </tr>
                    <cfif isdefined('x_is_process_date_control') and x_is_process_date_control eq 1>
                        <tr id="row_emp_info_#currentrow#" class="nohover" style="display:none;height:20px;">
                            <td colspan="6">
                                <div id="div_emp_info_#currentrow#" style="background-color: #colorrow#; display:none; outset cccccc;"></div>
                            </td>
                        </tr>
                    </cfif>
                </cfoutput>
            <cfelse>
                <tr style="height:20px;">  
                    <td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayit Yok'>!</cfif><!--- <cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif> ---></td>
                </tr>
            </cfif>
      	</tbody>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfif len(attributes.keyword)>
		<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
	</cfif>
	<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:99%; height:35px;">
		<tr>
			<td><cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#attributes.fuseaction##url_string##url_string2#">
			</td>
			<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	<cfif isdefined('x_is_process_date_control') and x_is_process_date_control eq 1>
		function open_emp_info(row,employee_id)
		{	
			gizle_goster(eval("document.getElementById('row_emp_info_" + row + "')"));
			gizle_goster(eval("document.getElementById('div_emp_info_" + row + "')"));
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_emp_events&emp_id='+employee_id+'&startdate=<cfif isdefined("attributes.process_date")>#attributes.process_date#</cfif><cfif isdefined("attributes.process_row_id") and len(attributes.process_row_id)>&process_row_id=#attributes.process_row_id#</cfif></cfoutput>','div_emp_info_'+row,1);
		}
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
