<cfparam name="attributes.is_form_submitted" default="1">
<cfparam name="attributes.filtre_by_dept_id" default="">
<cfif isdefined("session.pp")>
    <cfset session_base = evaluate('session.pp')>
    <cfset session_our_company_id = session.pp.our_company_id>
    <cfset session_company_id = session.pp.company_id>
    <cfset session_period_year = session.pp.period_year>
    <cfset session_language = session.pp.language>
    <cfset session_user_id = session.pp.userid>
<cfelseif isdefined("session.ep")>
    <cfset session_base = evaluate('session.ep')>
    <cfset session_our_company_id = session.ep.our_company_id>
    <cfset session_company_id = session.ep.company_id>
    <cfset session_period_year = session.ep.period_year>
    <cfset session_language = session.ep.language>
    <cfset session_user_id = session.ep.user_id>
<cfelseif isdefined("session.ww")>
    <cfset session_base = evaluate('session.ww')>
    <cfset session_our_company_id = session.ww.our_company_id>
    <cfset session_company_id = session.ww.company_id>
    <cfset session_period_year = session.ww.period_year>
    <cfset session_language = session.ww.language>
</cfif>
<cfset attributes.isbox=1>

<cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfinclude template="../query/get_positions2.cfm">
	<cfset head_list=listdeleteduplicates(valuelist(get_positions.headquarters_id,','))>	
    <cfset head_list=listsort(head_list,"numeric","ASC",",")>
	<cfif listlen(head_list,',')>
		<cfquery name="ALL_HEAD" datasource="#DSN#">
			SELECT HEADQUARTERS_ID, NAME FROM SETUP_HEADQUARTERS WHERE HEADQUARTERS_ID IN(#head_list#) ORDER BY HEADQUARTERS_ID
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_positions.recordcount = 0>
</cfif>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT 
		BRANCH_NAME,
		BRANCH_ID	
	FROM 
		BRANCH
	WHERE 
		BRANCH_ID IS NOT NULL
		<cfif isDefined("attributes.our_cid")>AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_company_id#"></cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
<!--- Branchler session'daki company_id'ye göre getirilebilir...our_cid paramateresi bu yüzden eklendi--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.filter_by_hierarchy" default="">
<cfparam name="attributes.satir" default=""><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
<cfparam name="attributes.maxrows" default='20'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default='#get_positions.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function add_pos(id,name,code,emp_id,branch_name,branch_id,dep_name,dep_id,mail,pos_name,company,company_id,title_id,func_id,collar_type,organization_step_id,head,head_id,row_acc_code,pos_cat_id,pos_cat_name,employee_no)
{	
	<cfif isdefined("attributes.satir") and len(attributes.satir)>
		var satir = <cfoutput>#attributes.satir#</cfoutput>;
	<cfelse>
		var satir = -1;
	</cfif>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket && satir > -1) 
		 <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.updateBasketItemFromPopup(satir, { BASKET_EMPLOYEE_ID: emp_id, BASKET_EMPLOYEE: name ,ROW_ACC_CODE :row_acc_code  }); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
	else
	{
		
		<cfif isdefined("attributes.field_partner")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_partner#</cfoutput>.value = "";
		</cfif>
		<cfif isdefined("attributes.field_consumer")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#listlast(field_consumer,'.')#</cfoutput>') != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#listlast(field_consumer,'.')#</cfoutput>').value = "";
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_consumer#</cfoutput>.value = "";
		</cfif>
		<cfif isdefined("attributes.field_comp_name")> 
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_comp_name#</cfoutput>.value = ""; 
		</cfif>
		<cfif isdefined("attributes.field_pos_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pos_name#</cfoutput>.value = pos_name;
		</cfif>
		<cfif isdefined("attributes.field_emp_id2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_emp_id2#</cfoutput>.value = emp_id;
		</cfif>
		<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_name#</cfoutput>').value = name;
		</cfif>
		<cfif isdefined("attributes.field_type")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_type#</cfoutput>.value = "employee";
		</cfif>
		<cfif isdefined("attributes.field_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_id#</cfoutput>').value = id;
		</cfif>
		<cfif isdefined("attributes.field_pos_cat_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_pos_cat_name#</cfoutput>.value = pos_cat_name;
		</cfif>
		<cfif isdefined("attributes.field_pos_cat_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pos_cat_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pos_cat_id#</cfoutput>.value = pos_cat_id;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_pos_cat_id#</cfoutput>').value = pos_cat_id;
		</cfif>
		<cfif isdefined("attributes.field_title_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_title_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_title_id#</cfoutput>.value = title_id;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_title_id#</cfoutput>').value = title_id;
		</cfif>
		<cfif isdefined("attributes.field_func_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_func_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_func_id#</cfoutput>.value = func_id;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_func_id#</cfoutput>').value = func_id;
		</cfif>
		<cfif isdefined("attributes.field_collar_type")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_collar_type#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_collar_type#</cfoutput>.value = collar_type;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_collar_type#</cfoutput>').value = collar_type;
		</cfif>
		<cfif isdefined("attributes.field_org_step_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_org_step_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_org_step_id#</cfoutput>.value = organization_step_id;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_org_step_id#</cfoutput>').value = organization_step_id;
		</cfif>
		<cfif isdefined("attributes.field_id2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_id2#</cfoutput>.value += "," + id + ",";    /*position_id*/
		</cfif>
		<cfif isdefined("attributes.field_emp_mail")>
			if (mail.length)    
				 <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_emp_mail#</cfoutput>.value = mail;			 
			else
			{
				 alert("<cf_get_lang dictionary_id='55268.Maili olmayan birisini seçtiniz'> <cf_get_lang dictionary_id='55269.Başka birisini seçiniz'> !");
				 return false;
			}		
		</cfif>
		<cfif isdefined("attributes.field_mail")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_mail#</cfoutput>.value = mail;
		</cfif>
		<cfif isdefined("attributes.field_code")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_code#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_code#</cfoutput>.value = code;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_code#</cfoutput>').value = code;
		</cfif>
		<cfif isdefined("attributes.field_comp")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp#</cfoutput>.value =  company; 
		</cfif>
		<cfif isdefined("attributes.field_comp_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_id#</cfoutput>.value = ''; 
		</cfif>
		<cfif isdefined("attributes.field_emp_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_emp_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_emp_id#</cfoutput>.value = emp_id;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_emp_id#</cfoutput>').value = emp_id;
		</cfif>
		<cfif isdefined("attributes.field_dep_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_dep_name#</cfoutput>.value = dep_name;
		</cfif>
		<cfif isdefined("attributes.field_dep_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dep_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dep_id#</cfoutput>.value = dep_id;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_dep_id#</cfoutput>').value = dep_id;
		</cfif>
		<cfif isdefined("attributes.field_branch_name")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_branch_name#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_branch_name#</cfoutput>.value = branch_name;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_branch_name#</cfoutput>').value = branch_name;
		</cfif>
		<cfif isdefined("attributes.field_branch_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_branch_id#</cfoutput>.value = branch_id;
		</cfif>
		<cfif isdefined("attributes.field_branch_and_dep")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_branch_and_dep#</cfoutput>.value = branch_name+'/'+dep_name;
		</cfif>
		<cfif isdefined("attributes.field_member_account_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_member_account_code#</cfoutput>.value = row_acc_code;
		</cfif>
		<cfif isdefined("attributes.field_member_account_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_member_account_id#</cfoutput>.value = row_acc_code;
		</cfif>
		<cfif isdefined("attributes.basket_cheque")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.reload_basket();
		</cfif>
		<cfif isdefined("attributes.islem")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.time_cost.work_head.value = "";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.time_cost.event_head.value = "";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.time_cost.emp_name.value = "";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.time_cost.expense.value = "";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.time_cost.islem.value = "emp";
		</cfif>
		
		<cfif isdefined("attributes.cash_control_upd")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_cash_payment.cash_action_to_company_id.value="";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_cash_payment.comp_name.value="";
		</cfif>
		
		<cfif isdefined("attributes.cash_control_add")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.add_cash_payment.cash_action_to_company_id.value="";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.add_cash_payment.comp_name.value="";
		</cfif>
		
		<cfif isDefined("attributes.field_table")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_table#</cfoutput>.innerHTML += "<table class='label'><tr><td>"+name+"</td></tr></table>";
		</cfif>
		<cfif isDefined("attributes.field_pos_table")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_pos_table#</cfoutput>').innerHTML += "<table class='label'><tr><td>("+pos_name+")</td></tr></table>";
		</cfif>
		<cfif isDefined("attributes.field_pos")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pos#</cfoutput>.value += "," + code + ",";
		</cfif>
		<cfif isdefined("attributes.ssk_healty")>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.employee_relative_ssk&event=add&field_name=popup_ssk_healty_print.ill_name&field_surname=popup_ssk_healty_print.ill_surname&field_relative=popup_ssk_healty_print.ill_relative&field_birth_date=popup_ssk_healty_print.ill_bdate&field_birth_place=popup_ssk_healty_print.ill_bplace&employee_id=emp_id','medium');
		</cfif>
		<cfif isdefined("attributes.run_function")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.run_function#</cfoutput>();
		</cfif>
		<cfif isdefined("attributes.field_head")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_head#</cfoutput>.value = head;
		</cfif>
		<cfif isdefined("attributes.field_head_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_head_id#</cfoutput>.value = head_id;
		</cfif>
		<cfif isdefined("attributes.field_emp_no")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_emp_no#</cfoutput>.value = employee_no;
		</cfif>
		<cfif isdefined("attributes.pos_function")>
			//window.opener.get_pos_code(code);		
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
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
		if(typeof(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.set_price_catid_options) != 'undefined')  //basketteki fiyat listelerini dolu getirmek icin eklendi.
			{
				try{opener.set_price_catid_options();}
					catch(e){};
			}
		<cfif isdefined('attributes.function_name')>
			window.opener.top.<cfoutput>#function_name#</cfoutput>(emp_id,1);
		</cfif>
		<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.focus();
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_name#</cfoutput>').focus();
		</cfif>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.location.href.indexOf('hr.') >0 || <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.location.href.indexOf('ehesap.')>0)//ik veya ehesaptan açılırsa uyarı versin
		{
			var listParam = list_getat(emp_id,1,"_");
			get_note = wrk_safe_query('obj_get_note_emp','dsn',0,listParam);
			if(get_note.recordcount)
				window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_company_note&emp_id='+emp_id+'','','scrollbars=0, resizable=0,width=500,height=500,left='+(screen.width-500)/2+',top='+(screen.height-500)/2+"'");
		}
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>

	}
	<cfif isDefined("attributes.url_direction") and isDefined("attributes.url_param")>
		<cfoutput>
		window.location='#request.self#?fuseaction=#attributes.url_direction#&#attributes.url_param#=#evaluate("attributes."&attributes.url_param)#&POS_ID=' + code;		
		</cfoutput>
	<cfelseif not isdefined("attributes.window_close")>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</cfif>
}
function reloadopener()
{
	wrk_opener_reload();
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
<cfparam name="select_list" default="1,2,3,4,5,6">
<cfif not listcontainsnocase(select_list,9) and isdefined("attributes.field_emp_id")>
	<cfset select_list = listappend(select_list,'9')>
</cfif>
<cfscript>
	url_string = '';
	if (isdefined('attributes.is_display_self')) url_string = '#url_string#&is_display_self=#attributes.is_display_self#'; //yetkisi olmasa dahi popup'ta kendisini görüntüleyebilmesi için eklendi DT 20140620
	if (isdefined('attributes.is_buyer_seller')) url_string = '#url_string#&is_buyer_seller=#attributes.is_buyer_seller#';
	if (isdefined('attributes.is_cari_action')) url_string = '#url_string#&is_cari_action=#attributes.is_cari_action#';
	if (isdefined('attributes.is_deny_control')) url_string = '#url_string#&is_deny_control=#attributes.is_deny_control#';
	if (isdefined('attributes.field_basket_due_value')) url_string = '#url_string#&field_basket_due_value=#field_basket_due_value#';
	if (isdefined('attributes.field_paymethod_id')) url_string = '#url_string#&field_paymethod_id=#field_paymethod_id#';
	if (isdefined('attributes.field_paymethod')) url_string = '#url_string#&field_paymethod=#field_paymethod#';
	if (isdefined('attributes.basket_cheque')) url_string = '#url_string#&basket_cheque=1';
	if (isdefined('attributes.islem')) url_string = '#url_string#&islem=#islem#';
	if (isdefined('attributes.field_comp')) url_string = '#url_string#&field_comp=#field_comp#';
	if (isdefined('attributes.field_comp_name')) url_string = '#url_string#&field_comp_name=#field_comp_name#';
	if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#field_comp_id#';
	if (isdefined('attributes.field_name') and len(attributes.field_name)) url_string = '#url_string#&field_name=#attributes.field_name#';
	if (isdefined('attributes.field_id')) url_string = '#url_string#&field_id=#field_id#';
	if (isdefined('attributes.field_pos_cat_id')) url_string = '#url_string#&field_pos_cat_id=#field_pos_cat_id#';
	if (isdefined('attributes.field_pos_cat_name')) url_string = '#url_string#&field_pos_cat_name=#field_pos_cat_name#';
	if (isdefined('attributes.field_title_id')) url_string = '#url_string#&field_title_id=#field_title_id#';
	if (isdefined('attributes.field_func_id')) url_string = '#url_string#&field_func_id=#field_func_id#';
	if (isdefined('attributes.field_collar_type')) url_string = '#url_string#&field_collar_type=#field_collar_type#';
	if (isdefined('attributes.field_org_step_id')) url_string = '#url_string#&field_org_step_id=#field_org_step_id#';
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
	if (isdefined('attributes.show_rel_pos')) url_string = '#url_string#&show_rel_pos=#attributes.show_rel_pos#';
	if (isdefined('attributes.field_emp_no')) url_string = '#url_string#&field_emp_no=#field_emp_no#';
	if (isdefined("attributes.is_position_assistant")) url_string = "#url_string#&is_position_assistant=#attributes.is_position_assistant#";
	if (isdefined("attributes.module_id")) url_string = "#url_string#&module_id=#attributes.module_id#";

	if (isdefined("attributes.url_param"))
	{
		if (isdefined(attributes.url_param)) url_string = "#url_string#&#attributes.url_param#=#evaluate('attributes.'&attributes.url_param)#";
	}
	url_string2 = '&is_form_submitted=1';
	if (isdefined('attributes.branch_id')) url_string2 = '#url_string2#&branch_id=#attributes.branch_id#';
	if (isdefined('attributes.department_id')) url_string2 = '#url_string2#&department_id=#attributes.department_id#';
	if (isdefined('attributes.emp_process_row_id')) url_string2 = '#url_string2#&emp_process_row_id=#attributes.emp_process_row_id#';
	if (isdefined("attributes.tree_category_id") and len(attributes.tree_category_id) and isdefined("attributes.sub_tree_category_id"))  url_string2 = '#url_string2#&sub_tree_category_id=#attributes.sub_tree_category_id#';
	if (isdefined("attributes.is_my_extre_page")) url_string = "#url_string#&is_my_extre_page=#attributes.is_my_extre_page#";
	if (isdefined("attributes.satir") and len(attributes.satir))// Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826
		url_string= "#url_string#&satir=#attributes.satir#";
</cfscript>
<cfsavecontent variable="head_">
    <cfoutput>
        <div class="form-row">
            <div class="form-group col-lg-2">
                <select class="form-control" name="categories" id="categories">
                    <cfif listcontainsnocase(select_list,1)>
                        <option value="widgetloader?widget_load=listPos&isbox=1&draggable=1&modal_id=#attributes.modal_id#&#url_string#" ><cf_get_lang dictionary_id='58875.Calisanlar'></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,7)>
                        <option value="widgetloader?widget_load=listPars&isbox=1&draggable=1&modal_id=#attributes.modal_id#&#url_string#" <cfif attributes.widget_load is "listPars"> selected</cfif>><cfif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 0)><!---<cf_ge t_lang_main no='1261.Musteriler'>---><cf_get_lang dictionary_id='29408.Kurumsal Uyeler'><cfelseif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 1)><cf_get_lang dictionary_id='29528.Tedarikciler'><cfelse><cf_get_lang dictionary_id='29408.Kurumsal Uyeler'></cfif></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,8)>
                        <option value="widgetloader?widget_load=listCons&isbox=1&draggable=1&modal_id=#attributes.modal_id#&#url_string#" <cfif attributes.widget_load is "listCons"> selected</cfif>><cf_get_lang dictionary_id='29406.Bireysel Uyeler'></option>
                    </cfif>
                </select>
            </div>
        </div>
    </cfoutput>
</cfsavecontent>
<cfform id="search_pos" name="search_pos" method="post" action="widgetloader?widget_load=listPos&isbox=1&#url_string#">
	<cfinput type="hidden" name="satir" value="#attributes.satir#"><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
	<div class="form-row">      
		<div class="form-group col-lg-2 m-auto">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='32828.Keyword'></label>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='32828.Filtre'></cfsavecontent>
			<cfinput class="form-control" type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
		</div>
		<div class="form-group col-lg-2 m-auto">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='29434.Şubeler'></label>
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<input name="department_id" id="department_id" type="hidden" value="<cfoutput>#attributes.department_id#</cfoutput>">
			<select class="form-control" name="branch_id" id="branch_id">
				<option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
				<cfoutput query="get_branches">
					<option value="#branch_id#"<cfif branch_id eq attributes.branch_id> selected</cfif>>#branch_name#</option>
				</cfoutput>
			</select>
		</div>
		<div class="form-group col-lg-1 mt-5 py-2">             
			<button type="button" class="btn font-weight-bold text-uppercase btn-color-7" onclick="loadPopupBox('search_pos','<cfoutput>#attributes.modal_id#</cfoutput>')"><i class="fa fa-search"></i>  <cf_get_lang dictionary_id='57565.Ara'></button>
		</div>
	</div>   
</cfform>
<cfoutput>#head_#</cfoutput>
<div class="table-responsive ui-scroll">
	<table class="table">
		<thead class="main-bg-color">
			<tr>
				<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
				<th><cf_get_lang dictionary_id='57574.Şirket'></th>
				<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th><cf_get_lang dictionary_id='57572.Departman'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_positions.recordcount>
				<cfoutput query="get_positions">
					<tr>
						<td>
							<cfif not isdefined("url.trans")>
								<a href="javascript://" onClick="add_pos('#position_id#','#employee_name# #employee_surname#','#position_code#','#employee_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','#title_id#','#func_id#','#collar_type#','#organization_step_id#',<cfif len(get_positions.headquarters_id)>'#all_head.name[listfind(head_list,get_positions.headquarters_id,',')]#'<cfelse>''</cfif>,<cfif len(get_positions.headquarters_id)>'#get_positions.headquarters_id#'<cfelse>''</cfif>,'#employee_no#')">#position_name#</a>
							<cfelse>
								<cfif is_master eq 1>
									#position_name# 
								<cfelse>
									#position_name# <cf_get_lang dictionary_id='32589.Ek'>
								</cfif>
							</cfif>
						</td>
						<td>#nick_name#</td>
						<td><cfif employee_id eq 0><font color="##FF0000"><cf_get_lang dictionary_id='32845.Boş'></font><cfelse>#employee_name# #employee_surname#</cfif></td>
						<td>#branch_name#</td>
						<td>#department_head#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr> 
					<td colspan="5"><cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayit Yok'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</table>
</div>
<script type="text/javascript">
	$("#categories").change(function(){
		openBoxDraggable(this.value,<cfoutput>#attributes.modal_id#</cfoutput>);  		
	});
</script>