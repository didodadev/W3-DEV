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
	field_title_id : unvan id si gelecek
	field_func_id : func id si gelecek
	field_collar_type : collar type gelecek
	field_org_step_id : organization step id gelecek
	
	field_pos_name : Pozisyon İsmi
	field_dep_name : Departman İsmi
	field_dep_id   : Departman ID'si
	field_branch_name : Şube İsmi
	field_branch_id : Şube Id'si
	field_comp : Company ismi
	field_comp_id : Company ID'si
	field_head : grup başkanlıgi
	field_head_id : grup baskanlıgı id
	field_emp_no : sicil no
	
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
<cfif isdefined("attributes.attributes_json")>
    <cfset deserialize_atributes = DeserializeJSON(URLDecode(attributes.ATTRIBUTES_JSON))>
    <cfset StructAppend(attributes,deserialize_atributes,true)>
</cfif>

<cf_xml_page_edit fuseact="objects.popup_list_positions">
	<cf_get_lang_set module_name="objects">
	<cfparam name="attributes.filtre_by_dept_id" default="">
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
			<cfif isDefined("attributes.our_cid")>AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"></cfif>
			<cfif isdefined("attributes.branch_related") or xml_branch_control eq 1>
				AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
		ORDER BY
			BRANCH_NAME
	</cfquery>
	<!--- Branchler session'daki company_id'ye göre getirilebilir...our_cid paramateresi bu yüzden eklendi--->
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.department_id" default="">
	<cfparam name="attributes.filter_by_hierarchy" default="">
	<cfparam name="attributes.satir" default=""><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.modal_id" default="">
	<cfparam name="attributes.from_add_rapid" default="0"><!--- Hızlı çalışan ekranından geliyorsa --->
	<cfparam name="attributes.position_cat_id_name" default="0"><!--- Pozisyon id ve name i beraber kullanılan durumlar için --->
	<cfparam name="attributes.totalrecords" default='#get_positions.recordcount#'>
	<cfif isdefined("attributes.field_id_3")><!--- aynı field id ye sahip başka bir alan var ise karışmaması için eklendi. --->
		<cfset attributes.field_id = attributes.field_id_3>
	</cfif>
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
		else if(window.basketManager !== undefined && satir > -1)
		updateBasketItemFromPopup(satir, { BASKET_EMPLOYEE_ID: emp_id, BASKET_EMPLOYEE: name ,ROW_ACC_CODE :row_acc_code  });
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
	
			<cfif isdefined("attributes.field_emp_id2")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_emp_id2#</cfoutput>.value = emp_id;
			</cfif>
	
			<cfif isdefined("attributes.field_name") and len(attributes.field_name) and attributes.from_add_rapid eq 0>
				if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput> != undefined)
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
				else
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_name#</cfoutput>').value = name;
			</cfif>

			<cfif isdefined("attributes.field_pos_name")>
				if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pos_name#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pos_name#</cfoutput>.value = pos_name;
				else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_pos_name#</cfoutput>').value = pos_name;
			</cfif>

			<cfif isdefined("attributes.field_type")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_type#</cfoutput>.value = "employee";
			</cfif>
			<cfif isdefined("attributes.field_id")>
				if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput> != undefined)
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
				else
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_id#</cfoutput>').value = id;
			</cfif>
			<cfif isdefined("attributes.field_pos_cat_name")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_pos_cat_name#</cfoutput>.value = pos_cat_name;
			</cfif>
			<cfif isdefined("attributes.field_pos_cat_id")>
				if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pos_cat_id#</cfoutput> != undefined)
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pos_cat_id#</cfoutput>.value = pos_cat_id;
				else
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_pos_cat_id#</cfoutput>').value = pos_cat_id;
			</cfif>
			<cfif isdefined("attributes.field_title_id")>
				if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_title_id#</cfoutput> != undefined)
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_title_id#</cfoutput>.value = title_id;
				else
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_title_id#</cfoutput>').value = title_id;
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
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id2#</cfoutput>.value += "," + id + ",";    /*position_id*/
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
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dep_name#</cfoutput>.value = dep_name;
			</cfif>
			<cfif isdefined("attributes.field_dep_id")>
				if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dep_id#</cfoutput> != undefined)
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dep_id#</cfoutput>.value = dep_id;
				else
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_dep_id#</cfoutput>').value = dep_id;
			</cfif>
			<cfif isdefined("attributes.field_branch_name")>
				if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_branch_name#</cfoutput> != undefined)
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_branch_name#</cfoutput>.value = branch_name;
				else
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_branch_name#</cfoutput>').value = branch_name;
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
						try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#listgetat(attributes.call_function,call_i,'-')#</cfoutput>;}
							catch(e){};
					</cfloop>			
				<cfelse>
					try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.call_function#</cfoutput>;}
					catch(e){};
				</cfif>
			</cfif>
			if(typeof(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.set_price_catid_options) != 'undefined')  //basketteki fiyat listelerini dolu getirmek icin eklendi.
				{
					try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.set_price_catid_options();}
						catch(e){};
				}
			<cfif isdefined('attributes.function_name')>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.top.<cfoutput>#function_name#</cfoutput>(emp_id,1);
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
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
	
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
		if (isdefined('attributes.is_period_kontrol')) url_string = '#url_string#&is_period_kontrol=#attributes.is_period_kontrol#';
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
		if (isdefined('attributes.field_id')) url_string = '#url_string#&field_id=#attributes.field_id#';
		if (isdefined('attributes.field_pos_cat_id')) url_string = '#url_string#&field_pos_cat_id=#attributes.field_pos_cat_id#';
		if (isdefined('attributes.field_pos_cat_name')) url_string = '#url_string#&field_pos_cat_name=#field_pos_cat_name#';
		if (isdefined('attributes.field_title_id')) url_string = '#url_string#&field_title_id=#attributes.field_title_id#';
		if (isdefined('attributes.field_func_id')) url_string = '#url_string#&field_func_id=#field_func_id#';
		if (isdefined('attributes.field_collar_type')) url_string = '#url_string#&field_collar_type=#field_collar_type#';
		if (isdefined('attributes.field_org_step_id')) url_string = '#url_string#&field_org_step_id=#field_org_step_id#';
		if (isdefined('attributes.field_pos_name')) url_string = '#url_string#&field_pos_name=#attributes.field_pos_name#';
		if (isdefined('attributes.field_id2')) url_string = '#url_string#&field_id2=#attributes.field_id2#';
		if (isdefined('attributes.field_partner')) url_string = '#url_string#&field_partner=#field_partner#';
		if (isdefined('attributes.field_type')) url_string = '#url_string#&field_type=#field_type#';
		if (isdefined('attributes.field_emp_mail')) url_string = '#url_string#&field_emp_mail=#field_emp_mail#';
		if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#field_emp_id#';
		if (isdefined('attributes.field_pos_table')) url_string = '#url_string#&field_pos_table=#field_pos_table#';
		if (isdefined('attributes.field_code')) url_string = '#url_string#&field_code=#field_code#';
		if (isdefined('attributes.add_emp')) url_string = '#url_string#&add_emp=#add_emp#';
		if (isdefined('attributes.field_branch_name')) url_string = '#url_string#&field_branch_name=#attributes.field_branch_name#';
		if (isdefined('attributes.field_branch_id')) url_string = '#url_string#&field_branch_id=#field_branch_id#';
		if (isdefined('attributes.field_dep_name')) url_string = '#url_string#&field_dep_name=#attributes.field_dep_name#';
		if (isdefined('attributes.field_branch_and_dep')) url_string = '#url_string#&field_branch_and_dep=#field_branch_and_dep#';
		if (isdefined('attributes.field_dep_id')) url_string = '#url_string#&field_dep_id=#attributes.field_dep_id#';
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
		if (isdefined("attributes.from_add_rapid")) url_string = "#url_string#&from_add_rapid=#attributes.from_add_rapid#";
		if (isdefined("attributes.position_cat_id_name")) url_string = "#url_string#&position_cat_id_name=#attributes.position_cat_id_name#";
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
		<div class="ui-form-list flex-list">
			<div class="form-group">
				<cfoutput>
					<select name="categories" id="categories" onChange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>">
						<cfif listcontainsnocase(select_list,1)>
							<option value="#request.self#?fuseaction=objects.popup_list_positions#url_string#"  <cfif fusebox.fuseaction is not "popup_list_all_positions">selected</cfif>><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
						</cfif>
						<cfif listcontainsnocase(select_list,2)>
							<option value="#request.self#?fuseaction=objects.popup_list_pars#url_string#&is_priority_off=1"><cf_get_lang dictionary_id='32995.C Kurumsal Üyeler'></option>
						</cfif>
						<cfif listcontainsnocase(select_list,3)>
							<option value="#request.self#?fuseaction=objects.popup_list_cons#url_string#"><cf_get_lang dictionary_id='32996.C Bireysel Üyeler'></option>
						</cfif>
						<cfif listcontainsnocase(select_list,4)>
							<option value="#request.self#?fuseaction=objects.popup_list_grps#url_string#"><cf_get_lang dictionary_id='32716.Gruplar'></option>
						</cfif>
						<cfif listcontainsnocase(select_list,5)>
							<option value="#request.self#?fuseaction=objects.popup_list_pot_cons#url_string#"><cf_get_lang dictionary_id='32963.P Bireysel Üyeler'></option>
						</cfif>
						<cfif listcontainsnocase(select_list,6)>
							<option value="#request.self#?fuseaction=objects.popup_list_pot_pars#url_string#&is_priority_off=1"><cf_get_lang dictionary_id='32964.P Kurumsal Üyeler'></option>
						</cfif>
						<cfif listcontainsnocase(select_list,7)>
							<option value="#request.self#?fuseaction=objects.popup_list_all_pars#url_string#&is_priority_off=1"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
						</cfif>
						<cfif listcontainsnocase(select_list,8)>
							<option value="#request.self#?fuseaction=objects.popup_list_all_cons#url_string#"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
						</cfif>
						<cfif listcontainsnocase(select_list,9) and xml_branch_control neq 1>
							<option value="#request.self#?fuseaction=objects.popup_list_all_positions#url_string#" <cfif fusebox.fuseaction is "popup_list_all_positions">selected</cfif>><cf_get_lang dictionary_id='32409.Tüm Çalışanlar'></option>
						</cfif>
					</select>
				</cfoutput>
			</div>
		</div>
	</cfsavecontent>
	
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Çalışanlar',30370)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_wrk_alphabet keyword="url_string,url_string2" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cfform name="search" method="post" action="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#">
				<cfinput type="hidden" name="satir" value="#attributes.satir#"><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
				<cf_box_search more="0">      
					<div class="form-group" id="item-keyword">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
					</div>
					<div class="form-group" id="item-is_form_submitted">
						<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
						<input name="department_id" id="department_id" type="hidden" value="<cfoutput>#attributes.department_id#</cfoutput>">
						<select name="branch_id" id="branch_id">
							<option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
							<cfoutput query="get_branches">
								<option value="#branch_id#"<cfif branch_id eq attributes.branch_id> selected</cfif>>#branch_name#</option>
							</cfoutput>
						</select>
					</div>
					<cfif xml_filtre_by_dept_id eq 1 and len(xml_department_id)>
						<!--- modified : MA 20120718 xml den gelen dept idlere gore filtreleme yapilir --->
						<div class="form-group" id="item-filtre_by_dept_id">
							<input type="checkbox" name="filtre_by_dept_id" id="filtre_by_dept_id"  value="1" <cfif attributes.filtre_by_dept_id eq 1>checked</cfif>>
							<cf_get_lang dictionary_id='57449.Satınalma'>
						</div>
					</cfif>
					<cfif xml_filter_by_hierarchy eq 1>
						<div class="form-group" id="item-filter_by_hierarchy">
							<cfinput type="text" name="filter_by_hierarchy" id="filter_by_hierarchy" placeholder="#getLang('main',349)#" value="#attributes.filter_by_hierarchy#">
						</div>
					</cfif>
					<cfif isdefined("attributes.tree_category_id") and len(attributes.tree_category_id)>
						<div class="form-group" id="item-sub_tree_category_id">
							<select name="sub_tree_category_id" id="sub_tree_category_id">
								<option value="0" <cfif isdefined('attributes.sub_tree_category_id') and attributes.sub_tree_category_id eq 0>selected</cfif>><cf_get_lang dictionary_id='34274.Alt Tree Yetkilisine Bakmasın'></option>
								<option value="1" <cfif not isdefined('attributes.sub_tree_category_id') or attributes.sub_tree_category_id eq 1>selected</cfif>><cf_get_lang dictionary_id='34275.Alt Tree Yetkilisine Baksın'></option>
							</select>
						</div>
					</cfif>
					<div class="form-group small" id="item-maxrows">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:30px;">
					</div>
					<div class="form-group">
						<cfoutput>#head_#</cfoutput>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
					</div>
				</cf_box_search>   
			</cfform>
			<cfif not isdefined("attributes.show_empty_pos")>
				<cf_flat_list>	
					<thead>
						<tr>
							<cfset colspan = 3>
							<cfif isdefined('x_is_process_date_control') and x_is_process_date_control eq 1>
								<th width="15"></th>
								<cfset colspan = colspan + 1>
							</cfif>
							<th width="120"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
							<th width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
							<cfif isdefined('is_company_view') and is_company_view eq 1>
								<th width="120"><cf_get_lang dictionary_id='57574.Şirket'></th>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_branch_view') and is_branch_view eq 1>
								<th width="120"><cf_get_lang dictionary_id='57453.Şube'></th>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_department_view') and is_department_view eq 1>
								<th  width="80"><cf_get_lang dictionary_id='57572.Departman'></th>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_group_date') and is_group_date eq 1>
								<th width="80"><cf_get_lang dictionary_id='33341.Gruba G T'></th>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif get_module_user(23) or get_module_user(25) or get_module_user(22) or get_module_user(9) or get_module_user(86)>
							<th width="20"><i class="fa fa-table" title="<cf_get_lang dictionary_id='57809.Hesap Ekstresi'>"></i></th></cfif>
							<th width="20"><i class="icon-detail" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></th>
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
								<tr>
									<cfif isdefined('x_is_process_date_control') and x_is_process_date_control eq 1>
										<cfif len(employee_id)>
										<td align="center" id="order_row#currentrow#" onClick="gizle_goster(emp_info_goster#currentrow#);open_emp_info(#currentrow#,#employee_id#);gizle_goster(emp_info_gizle#currentrow#);">
											<img id="emp_info_goster#currentrow#" src="/images/listele.gif" title="<cf_get_lang dictionary_id='58596.Göster'>">
											<img id="emp_info_gizle#currentrow#" src="/images/listele_down.gif" title="<cf_get_lang dictionary_id='58628.Gizle'>" style="display:none">
										</td>
										<cfelse>
										<td>&nbsp;</td>
										</cfif>
									</cfif>
									<td nowrap>
										<cfif not isdefined("url.trans")>
											<cfif isdefined("acc_type_id") and len(acc_type_id) and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and isdefined("x_add_multi_acc") and x_add_multi_acc eq 1>
												<a href="javascript://" onClick="add_pos('#position_id#','#employee_name# #employee_surname#-#acc_type_name#','#position_code#','#employee_id#_#acc_type_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','#title_id#','#func_id#','#collar_type#','#organization_step_id#',<cfif len(get_positions.headquarters_id)>'#all_head.name[listfind(head_list,get_positions.headquarters_id,',')]#'<cfelse>''</cfif>,<cfif len(get_positions.headquarters_id)>'#get_positions.headquarters_id#'<cfelse>''</cfif>,'#row_acc_code#','#position_cat_id#','#position_cat#','#employee_no#');" class="tableyazi" <cfif isdefined("FINISH_DATE") and len(FINISH_DATE)>style="color:red;"</cfif>>#employee_name# #employee_surname#</a>
											<cfelse>
												<a href="javascript://" onClick="add_pos('#position_id#','#employee_name# #employee_surname#','#position_code#','#employee_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','#title_id#','#func_id#','#collar_type#','#organization_step_id#',<cfif len(get_positions.headquarters_id)>'#all_head.name[listfind(head_list,get_positions.headquarters_id,',')]#'<cfelse>''</cfif>,<cfif len(get_positions.headquarters_id)>'#get_positions.headquarters_id#'<cfelse>''</cfif>,'#row_acc_code#','#position_cat_id#','#position_cat#','#employee_no#');" <cfif isdefined("finish_date") and len(finish_date)>style="color:red"</cfif> class="tableyazi">#employee_name# #employee_surname#</a>
											</cfif>
										<cfelse>
											#employee_name# #employee_surname#
										</cfif>
										<cfif isdefined("acc_type_name") and len(acc_type_name)>-#acc_type_name#</cfif>
									</td>
									<td><cfif isdefined("url.trans")>
											<cfif isdefined("acc_type_id") and len(acc_type_id) and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and isdefined("x_add_multi_acc") and x_add_multi_acc eq 1>
												<a href="javascript://" onClick="add_pos('#position_id#','#employee_name# #employee_surname#','#position_code#','#employee_id#_#acc_type_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','#title_id#','#func_id#','#collar_type#','#organization_step_id#',<cfif len(get_positions.headquarters_id)>'#all_head.name[listfind(head_list,get_positions.headquarters_id,',')]#'<cfelse>''</cfif>,<cfif len(get_positions.headquarters_id)>'#get_positions.headquarters_id#'<cfelse>''</cfif>,'#row_acc_code#','#position_cat_id#','#position_cat#','#employee_no#');" class="tableyazi">#position_name#</a>
											<cfelse>
												<a href="javascript://" onClick="add_pos('#position_id#','#employee_name# #employee_surname#','#position_code#','#employee_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','#title_id#','#func_id#','#collar_type#','#organization_step_id#',<cfif len(get_positions.headquarters_id)>'#all_head.name[listfind(head_list,get_positions.headquarters_id,',')]#'<cfelse>''</cfif>,<cfif len(get_positions.headquarters_id)>'#get_positions.headquarters_id#'<cfelse>''</cfif>,'#row_acc_code#','#position_cat_id#','#position_cat#','#employee_no#');" class="tableyazi">#position_name#</a>
											</cfif>
										<cfelse>
											<cfif is_master eq 1>
												#position_name# 
											<cfelse>
												#position_name# <cf_get_lang dictionary_id='32617.Ek Pozisyon'>
											</cfif>
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
									<td>#dateformat(group_startdate,dateformat_style)#</td>
									</cfif>
									<cfif get_module_user(23) or get_module_user(25) or get_module_user(22) or get_module_user(9) or get_module_user(86)>
										<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&employee_id=#employee_id#&comp_name=#employee_name# #employee_surname#&member_type=employee&date_control=1&form_submit=1','page');"><i class="fa fa-table" title="<cf_get_lang dictionary_id='57809.Hesap Ekstresi'>"></i></a></td>
									</cfif>
									<td>
										<cfif not isdefined("attributes.show_empty_pos")>
											<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&department_id=#department_id#&emp_id=#employee_id#&pos_id=#position_code##url_string#','medium');"><i class="icon-detail" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a>
										</cfif>
									</td>
								</tr>
								<cfif isdefined('x_is_process_date_control') and x_is_process_date_control eq 1>
									<tr style="display:none;" id="row_emp_info_#currentrow#" class="nohover">
										<td colspan="9">
											<div id="div_emp_info_#currentrow#" style="background-color:; display:none; outset cccccc;"></div>
										</td>
									</tr>
								</cfif>
							</cfoutput>
						<cfelse>
							<tr> 
								<td height="20" colspan="8">
									<cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))>
										<cf_get_lang dictionary_id='57484.Kayıt Yok'>!
									<cfelse>
										<cf_get_lang dictionary_id='57701.Filtre Ediniz '>!
									</cfif>
								</td>
							</tr>
						</cfif>
					</tbody>
				</cf_flat_list>	
			<cfelse>
				<cf_flat_list>
					<thead>
						<tr height="22">
						<cfset colspan = 5>
							<cfif isdefined('x_is_process_date_control') and x_is_process_date_control eq 1>
								<th width="15"></th>
								<cfset colspan = colspan + 1>
							</cfif>
							<th width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
							<th width="120"><cf_get_lang dictionary_id='57574.Şirket'></th>
							<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
							<th width="120"><cf_get_lang dictionary_id='57453.Şube'></th>
							<th width="150"><cf_get_lang dictionary_id='57572.Departman'></th>
						</tr>
					</thead>
					<tbody>
						<cfif get_positions.recordcount>
							<cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<tr>
									<cfif isdefined('x_is_process_date_control') and x_is_process_date_control eq 1>
										<cfif len(employee_id)>
										<td align="center" id="order_row#currentrow#" onClick="gizle_goster(emp_info_goster#currentrow#);open_emp_info(#currentrow#,#employee_id#);gizle_goster(emp_info_gizle#currentrow#);">
											<img id="emp_info_goster#currentrow#" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">
											<img id="emp_info_gizle#currentrow#" src="/images/listele_down.gif" title="<cf_get_lang dictionary_id ='58628.Gizle'>" style="display:none">
										</td>
										<cfelse>
										<td>&nbsp;</td>
										</cfif>
									</cfif>
									<td>
										<cfif not isdefined("url.trans")>
											<a href="javascript://" class="tableyazi" onClick="add_pos('#position_id#','#employee_name# #employee_surname#','#position_code#','#employee_id#','#branch_name#','#branch_id#','#department_head#','#department_id#','#employee_email#', '#position_name#','#nick_name#','#comp_id#','#title_id#','#func_id#','#collar_type#','#organization_step_id#',<cfif len(get_positions.headquarters_id)>'#all_head.name[listfind(head_list,get_positions.headquarters_id,',')]#'<cfelse>''</cfif>,<cfif len(get_positions.headquarters_id)>'#get_positions.headquarters_id#'<cfelse>''</cfif>,'','#position_cat_id#<cfif attributes.position_cat_id_name eq 1>;#position_cat#</cfif>','#position_cat#',<cfif not isDefined("attributes.show_empty_pos")>'#employee_no#'<cfelse>''</cfif>)">#position_name#</a>
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
								<cfif isdefined('x_is_process_date_control') and x_is_process_date_control eq 1>
								<tr style="display:none;" id="row_emp_info_#currentrow#" class="nohover">
									<td colspan="6">
										<div id="div_emp_info_#currentrow#" style="background-color: #colorrow#; display:none; outset cccccc;"></div>
									</td>
								</tr>
								</cfif>
							</cfoutput>
						<cfelse>
							<tr> 
								<td height="20" colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayit Yok'>!</cfif><!--- <cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif> ---></td>
							</tr>
						</cfif>
					</tbody>
				</cf_flat_list>
			</cfif>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfif len(attributes.keyword)>
					<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
				</cfif>
				<cfif len(attributes.filter_by_hierarchy)>
					<cfset url_string = '#url_string#&filter_by_hierarchy=#attributes.filter_by_hierarchy#'>
				</cfif>
				<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
					<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
				</cfif>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="objects.#fusebox.fuseaction##url_string##url_string2#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			</cfif>
		</cf_box>
	</div>
	<script type="text/javascript">
	$(document).ready(function(){
		$( "form[name=search] #keyword" ).focus();
	});
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
	
