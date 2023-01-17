<!--- 
İki tip kullanımı vardır.
-------------------------
1.
Açan penceredeki istenen alana seçilenleri kaydeder !
	is_branch_control: sube yetkilerine bakilsin
	to_title: hangi baslik atilacak custom tag icin kullanilir bu
	field_pos_name :	pozisyon adı
	field_id : 			pozisyon id
	field_code: 		pozisyon kodu
	field_emp_id: 		employee_id
	field_name:			çalışan adı ve soyadı
	field_emp_mail:		çalışan emaili
	field_branch_name:	Şube adı
	field_dep_name:		Departman adı
	field_type:			"employee"
örnek kullanım :
	<a href="//" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions_multiuser&field_code=form_name.field_code&field_pos_name=form_name.text_input_name</cfoutput>','list')"> Gidecekler </a>

2.
Açan penceredeki ilgili listeye yeni kişi eklemek için kullanılır ! Url_direction da belirtilen fuseaction'a başta emp_id ler olmak üzere hidden inputları gönderir.
	url_direction: 		Submit edilecek yer.. bu adrese url_params eklenecek ve bunun içinde fuseaction hariç diğer url parametrelerinin ismi yazacak virgülle ayrılmış vaziyette
						(Örnek: campaign.emptypopup_add_list&cmp_id=111&asd_id=222&url_params=cmp_id,asd_id)
örnek kullanım :
	<cfset url_direction = 'campaign.emptypopup_add_list&cmp_id=111&asd_id=222&url_params=cmp_id,asd_id'>
	<a href="//" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions_multiuser&url_direction=#url_direction#</cfoutput>','list')"> <img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='170.Ekle'>" align="center" border="0"> </a>
	
	Submit edilen emp_id input'unun ismi attributes.EMP_IDS dir ve içinde virgülle ayrılmış bir liste olarak kişileri tutmaktadır.
	Ayrıca eğer select_list içinde birden fazla numara varsa o zaman submit edilen değerlerin hangisine ait olduğu hidden input "record_type" ile belirlenir.
	Submit edilen input'lar:
		<input type="checkbox" value="#EMPLOYEE_ID#" name="EMP_IDS">
		<input type="hidden" name="EMPLOYEE_NAME" value="#EMPLOYEE_NAME#">
		<input type="hidden" name="EMPLOYEE_SURNAME" value="#EMPLOYEE_SURNAME#">
		<input type="hidden" name="EMPLOYEE_EMAIL" value="#EMPLOYEE_EMAIL#">
		<input type="hidden" name="position_id" value="#position_id#">
		<input type="hidden" name="position_name" value="#position_name#">
		<input type="hidden" name="position_code" value="#position_code#">
		<input type="hidden" name="BRANCH_NAME" value="#BRANCH_NAME#">
		<input type="hidden" name="DEPARTMENT_HEAD" value="#DEPARTMENT_HEAD#">

		<input type="hidden" name="record_type" value="employee">
	Revizyon:09012003 Arzu BT
		id bilgilerini forma gonderirken asagidaki yapida gonderecektir.orn:employee icin emp-employee_id ile birlestirerek.
		EMP-id  employeer icin
		PAR-id partner id icin 
		POS-id position_id icin(employeer position)
		CON-id consumer id icin
		GRP-id group id icin 
		WRK-id	bu yok sanirsam	 
--->
<cf_xml_page_edit fuseact="objects.popup_list_positions_multiuser">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.department" default="">
<cfinclude template="../query/get_departments.cfm">
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT_ID, POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfif isdefined("attributes.form_submit")>
	<cfinclude template="../query/get_positions.cfm">
<cfelse>
	<cfset get_positions.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_positions.recordcount#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.filter_by_hierarchy" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submit")>
	<script type="text/javascript">
		<cfif isdefined("attributes.to_title") and len(attributes.to_title)>
			to_title = <cfoutput>#attributes.to_title#</cfoutput>;
		<cfelse>
			to_title=1;
		</cfif>
		<cfif isdefined("attributes.row_count")>
			rowCount = parseInt(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.row_count#</cfoutput>").value);
		</cfif>
		function cancel(){
			var retVal = confirm("<cfoutput><cf_get_lang dictionary_id="60633.Vazgeçmek istediğinize emin misiniz?"></cfoutput>");
               if( retVal == true ) {
					$("input:checked").prop("checked", false);
					window.close();
			   }
			
		}
		function add_checked()
		{
			var counter = 0;
			<cfif get_positions.recordcount gt 1  and attributes.maxrows neq 1>	
				for(i=0;i<document.form_name.emp_ids.length;i++) 
					if (document.form_name.emp_ids[i].checked == true) 
					{
						counter = counter + 1;
					}
					if (counter == 0)
					{
						alert("<cf_get_lang dictionary_id='33181.Kişi Seçmelisiniz'> !");
						return false;
					}
			<cfelseif get_positions.recordcount eq 1 or  attributes.maxrows eq 1>
				if (document.form_name.emp_ids.checked == true) 
				{
					counter = counter + 1;
				}
				if (counter == 0)
				{
					alert("<cf_get_lang dictionary_id='33181.Kişi Seçmelisiniz'> !");
					return false;
				}
			</cfif>
	
			<cfif isdefined("attributes.order_employee") and isdefined("attributes.multi")>
				<cfif get_positions.recordcount gt 1 and attributes.maxrows neq 1>	
					for(i=0;i<document.form_name.emp_ids.length;i++) 
						if (document.form_name.emp_ids[i].checked == true) 
						{
							x = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.length;
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.length = parseInt(x + 1);
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.options[x].value = document.form_name.emp_ids[i].value;
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.options[x].text = document.form_name.employee_name[i].value+' '+document.form_name.employee_surname[i].value;
						}
				<cfelseif get_positions.recordcount eq 1 or  attributes.maxrows eq 1>
					if (document.form_name.emp_ids.checked == true) 
					{
						x = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.length;
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.length = parseInt(x + 1);
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.options[x].value = document.form_name.emp_ids.value;
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.options[x].text = document.form_name.employee_name.value+' '+document.form_name.employee_surname.value;
					}			
				</cfif>
			</cfif>
			
			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_emp_id")  and attributes.maxrows neq 1>	
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++)
				{
					if (document.form_name.emp_ids[i].checked == true) 
					{
						counter = counter + 1;
						var emp_ids = document.form_name.emp_ids[i].value;
						var pos_id = document.form_name.position_id[i].value;
						if (to_title ==1 )
							var name = document.form_name.employee_name[i].value+' '+document.form_name.employee_surname[i].value;
						else
							var name = document.form_name.position_name[i].value;
						var pos_code =document.form_name.position_code[i].value;
						rowCount = rowCount + 1;					
						var ss_int = ekle_str(name,emp_ids,pos_id,pos_code);
					}
				}
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.row_count#</cfoutput>").value = rowCount;
				<!--- <cfif not (browserDetect() contains 'MSIE')>
					id_ekle();
				</cfif> --->
			<cfelseif (get_positions.recordcount eq 1 or  attributes.maxrows eq 1 )and isdefined("attributes.field_emp_id")>
				var emp_ids = document.form_name.emp_ids.value;
				var pos_id = document.form_name.position_id.value;
				if (to_title ==1 )
					var name = document.form_name.employee_name.value + ' ' + document.form_name.employee_surname.value;
				else
					var name = document.form_name.position_name.value;
				rowCount = rowCount + 1;
				var pos_code = document.form_name.position_code.value;
				var ss_int = ekle_str(name,emp_ids,pos_id,pos_code);			
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.row_count#</cfoutput>").value = rowCount;
				<!--- <cfif not (browserDetect() contains 'MSIE')>
					id_ekle();
				</cfif> --->
			</cfif>
			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_employee_id")  and attributes.maxrows neq 1>
				counter = 0;
				emp_ids='';
				for(i=0;i<document.form_name.emp_ids.length;i++)
				{
					if (document.form_name.emp_ids[i].checked == true) 
					{
						counter = counter + 1;
						var emp_ids = emp_ids + ',' + document.form_name.emp_ids[i].value;
					}
				}
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_employee_id#</cfoutput>").value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_employee_id#</cfoutput>").value + ',' + emp_ids;
			<cfelseif (get_positions.recordcount eq 1 or  attributes.maxrows eq 1) and isdefined("attributes.field_employee_id")>
				var emp_ids = document.form_name.emp_ids.value;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_employee_id#</cfoutput>").value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_employee_id#</cfoutput>").value + ',' + emp_ids;
			</cfif>
			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_name")  and attributes.maxrows neq 1>
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++) 
				{
					if (document.form_name.emp_ids[i].checked == true) 
					{
						counter = counter + 1;
						var name = document.form_name.employee_name[i].value+' '+document.form_name.employee_surname[i].value;
						if (counter == 1){
							var names = name;
						}
						else{
							var names = names + ',' + name;
						}
					}
				}
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_name#</cfoutput>").value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_name#</cfoutput>").value  + ',' + names ;
			<cfelseif (get_positions.recordcount eq 1 or  attributes.maxrows eq 1) and isdefined("attributes.field_name") >
				var names = document.form_name.employee_name.value+' '+document.form_name.employee_surname.value;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_name#</cfoutput>").value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_name#</cfoutput>").value + ',' + names;
			</cfif>
			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_position_id")  and attributes.maxrows neq 1>
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++) 
					if (document.form_name.emp_ids[i].checked == true)
					{
						counter = counter + 1;
						var pos_id = document.form_name.position_id[i].value;
						if (counter == 1)
						{
							var pos_ids = "POS-" + pos_id;
						}
						else
						{
							var pos_ids = pos_ids + ',' + pos_id;
						}
					}
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_position_id#</cfoutput>").value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_position_id#</cfoutput>").value + ',' + pos_ids;
			<cfelseif (get_positions.recordcount eq 1 or  attributes.maxrows eq 1) and isdefined("attributes.field_position_id")>
				var pos_ids = document.form_name.position_id.value;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_position_id#</cfoutput>").value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_position_id#</cfoutput>").value + ',' +  pos_ids;
			</cfif>
			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_emp_mail")  and attributes.maxrows neq 1>	
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++) 
					if (document.form_name.emp_ids[i].checked == true)
					{
						counter = counter + 1;
						if (document.form_name.employee_email[i].value.length)
						{
							var email = document.form_name.employee_email[i].value;
						}
						else
						{
							var email = '-';
						}
						if (counter == 1)
						{
							var emails = email;
						}
						else
						{
							var emails = emails + ',' + email;
						}
					}
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_emp_mail#</cfoutput>").value = emails;
			<cfelseif (get_positions.recordcount eq 1 or  attributes.maxrows eq 1) and isdefined("attributes.field_emp_mail")>
				if (document.form_name.employee_email.value.length)
				{
					var emails = document.form_name.employee_email.value;
				}
				else
				{
					var emails = '-';
				}
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_emp_mail#</cfoutput>").value = emails;
			</cfif>
			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_id")  and attributes.maxrows neq 1>	
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++) 
					if (document.form_name.emp_ids[i].checked == true)
					{
						counter = counter + 1;
						var pos_id = document.form_name.position_id[i].value;
						if (counter == 1)
						{
							var pos_ids =  pos_id;
						}
						else
						{
							var pos_ids = pos_ids + ',' + pos_id;
						}
					}
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_id#</cfoutput>").value = pos_ids;			
			<cfelseif (get_positions.recordcount eq 1 or  attributes.maxrows eq 1 ) and isdefined("attributes.field_id")>
				var pos_ids = form_name.position_id.value;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_id#</cfoutput>").value =  pos_ids;
			</cfif>
			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_pos_name")  and attributes.maxrows neq 1>	
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++) 
					if (document.form_name.emp_ids[i].checked == true)
					{
						counter = counter + 1;
						var pos_name = document.form_name.position_name[i].value;
						if (counter == 1)
						{
							var pos_names = pos_name;
						}
						else
						{
							var pos_names = pos_names + ',' + pos_name;
						}
					}
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_pos_name#</cfoutput>").value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_pos_name#</cfoutput>").value + '' +pos_names;
			<cfelseif (get_positions.recordcount eq 1 or  attributes.maxrows eq 1) and isdefined("attributes.field_pos_name")>
				var pos_names = document.form_name.position_name.value;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_pos_name#</cfoutput>").value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_pos_name#</cfoutput>").value + ' ' + pos_names;
			</cfif>
			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_code")  and attributes.maxrows neq 1>	
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++) 
					if (document.form_name.emp_ids[i].checked == true)
					{
						counter = counter + 1;
						var field_code = document.form_name.position_code[i].value;
						if (counter == 1)
						{
							var field_codes = field_code;
						}
						else
						{
							var field_codes = field_codes + ',' + field_code;
						}
					}
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_code#</cfoutput>").value = field_codes;
			<cfelseif (get_positions.recordcount eq 1 or  attributes.maxrows eq 1) and isdefined("attributes.field_code")>
				var field_codes = document.form_name.position_code.value;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_code#</cfoutput>").value = field_codes;
			</cfif>
			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_branch_name")  and attributes.maxrows neq 1>	
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++) 
					if (document.form_name.emp_ids[i].checked == true)
					{
						counter = counter + 1;
						var branch_name = document.form_name.branch_name[i].value;
						if (counter == 1)
						{
							var branch_names = branch_name;
						}
						else
						{
							var branch_names = branch_names + ',' + branch_name;
						}
					}
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_branch_name#</cfoutput>").value = branch_names;
			<cfelseif (get_positions.recordcount eq 1 or  attributes.maxrows eq 1) and isdefined("attributes.field_branch_name")>
				var branch_names = document.form_name.branch_name.value;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_branch_name#</cfoutput>").value = branch_names;
			</cfif>
			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_dep_name")  and attributes.maxrows neq 1>	
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++) 
					if (document.form_name.emp_ids[i].checked == true)
					{
						counter = counter + 1;
						var dep_name = document.form_name.department_head[i].value;
						if (counter == 1)
						{
							var dep_names = dep_name;
						}
						else
						{
							var dep_names = dep_names + ',' + dep_name;
						}
					}
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_dep_name#</cfoutput>").value = dep_names;
			<cfelseif (get_positions.recordcount eq 1 or  attributes.maxrows eq 1) and isdefined("attributes.field_dep_name") >
				var dep_names = document.form_name.department_head.value;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#attributes.field_dep_name#</cfoutput>").value = dep_names;
			</cfif>
			<cfif isdefined("attributes.field_type")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("<cfoutput>#field_type#</cfoutput>").value = "employee";
			</cfif>

			<cfif isDefined("attributes.url_direction")>
				<cfoutput>
					document.form_name.action='#request.self#?fuseaction=#attributes.url_direction#&'+document.form_name.url_string.value;
					<cfif isdefined("attributes.url_params") and listFind(attributes.url_params,'organization_id')>
						loadPopupBox('form_name',#attributes.modal_id#);
						return false;
					<cfelse>
                        <cfif isDefined("attributes.modal_id")>
                            loadPopupBox('form_name',#attributes.modal_id#);
                            return false;
                        <cfelse>
						    document.form_name.submit();
                        </cfif>
					</cfif>
				</cfoutput>
			<cfelse>
				/*window.close();*/
			</cfif>
		}
		function reloadopener()
		{
			wrk_opener_reload();
			window.close();
		}
		<cfif isdefined("attributes.table_name")>
			function ekle_str(str_ekle,int_id,int_id2,int_id3)
			{
				var newRow;
				var newCell;
				<cfoutput>
					newRow =<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.table_name#").insertRow(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.table_name#").rows.length);	
					newRow.setAttribute("name","#attributes.table_row_name#" + rowCount);
					newRow.setAttribute("id","#attributes.table_row_name#" + rowCount);		
					newRow.setAttribute("style","display:''");	
					newCell = newRow.insertCell(newRow.cells.length);
					str_html = '';
					<cfif isdefined("attributes.field_emp_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_emp_id#" id="#attributes.field_emp_id#" value="' + int_id + '"><input type="hidden" name="#attributes.field_pos_id#" value="' + int_id2 + '">';	
						str_html = str_html + '<input type="hidden" name="#attributes.field_pos_code#" id="#attributes.field_pos_code#" value="' + int_id3 + '">';	
					</cfif>
					<cfif isdefined("attributes.field_comp_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_comp_id#" id="#attributes.field_comp_id#" value=""><input type="hidden" name="#attributes.field_par_id#" value="">';
					</cfif>
					<cfif isdefined("attributes.field_cons_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_cons_id#" id="#attributes.field_cons_id#" value="">';
					</cfif>
					str_html = str_html +'<input type="hidden" name="#attributes.field_grp_id#" id="#attributes.field_grp_id#" value=""><input type="hidden" name="#attributes.field_wgrp_id#" value="">';
					str_del = '<a href="javascript://"  onClick="#attributes.function_row_name#(' + rowCount +','+int_id+');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Delete'>" alt="<cf_get_lang dictionary_id='57463.Delete'>"></i></a>&nbsp;';
					newCell.innerHTML = str_del  ;
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = str_html + str_ekle  ;
					newRow.insertCell(newRow.cells.length);
					newRow.insertCell(newRow.cells.length);
					newRow.insertCell(newRow.cells.length);
				</cfoutput>
				return 1;
			 }
			 //sadece safari için kullanılır...
			 function id_ekle()
			 {
				<cfoutput>
					 if('#attributes.function_row_name#'=='workcube_cc_delRow')
					 {
						if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc_emp_ids.length==undefined)
						{
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("cc_emp_ids"));
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("cc_pos_codes"));
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("cc_pos_ids"));
						}
						else
						{
							for(var i=0;i<<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc_emp_ids.length;i++)
							{
								<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc_emp_ids[i]);
								<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc_pos_codes[i]);
								<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc_pos_ids[i]);
							}
						}
					}
					else if('#attributes.function_row_name#'=='workcube_cc2_delRow')
					{
						if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc2_emp_ids.length==undefined)
						{
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("cc2_emp_ids"));
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("cc2_pos_codes"));
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("cc2_pos_ids"));
						}
						else
						{
							for(var i=0;i<window.opener.document.all.cc2_emp_ids.length;i++)
							{
								<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc2_emp_ids[i]);
								<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc2_pos_codes[i]);
								<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc2_pos_ids[i]);
							}
						}
					}
					else
					{
						if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.to_emp_ids.length==undefined)
						{
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("to_emp_ids"));
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("to_pos_codes"));
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("to_pos_ids"));
						}
						else
						{
							for(var i=0;i<<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.to_emp_ids.length;i++)
								{
									<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.to_emp_ids[i]);
									<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.to_pos_codes[i]);
									<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.body.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.to_pos_ids[i]);
								}
							}
					}
				</cfoutput>
			}
		</cfif>
	</script>
</cfif>
<cfparam name="select_list" default="1,2,3,4,5,6">
<cfscript>
	url_string = '';
	if (isdefined("attributes.function_row_name")) url_string = "#url_string#&function_row_name=#function_row_name#";	
	if (isdefined('attributes.field_name')) url_string = '#url_string#&field_name=#field_name#';
	if (isdefined('attributes.to_title')) url_string = '#url_string#&to_title=#to_title#';
	if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#field_emp_id#';
	if (isdefined('attributes.field_pos_id')) url_string = '#url_string#&field_pos_id=#field_pos_id#';
	if (isdefined('attributes.field_pos_code')) url_string = '#url_string#&field_pos_code=#field_pos_code#';	
	if (isdefined('attributes.field_par_id')) url_string = '#url_string#&field_par_id=#field_par_id#';
	if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#field_comp_id#';
	if (isdefined('attributes.field_partner_id')) url_string = '#url_string#&field_partner_id=#field_partner_id#';
	if (isdefined('attributes.field_company_id')) url_string = '#url_string#&field_company_id=#field_company_id#';
	if (isdefined('attributes.field_consumer_id')) url_string = '#url_string#&field_consumer_id=#field_consumer_id#';	
	if (isdefined('attributes.field_position_id')) url_string = '#url_string#&field_position_id=#field_position_id#';	
	if (isdefined('attributes.field_employee_id')) url_string = '#url_string#&field_employee_id=#field_employee_id#';			
	if (isdefined('attributes.field_cons_id')) url_string = '#url_string#&field_cons_id=#field_cons_id#';
	if (isdefined('attributes.field_grp_id')) url_string = '#url_string#&field_grp_id=#field_grp_id#';	
	if (isdefined("attributes.field_wgrp_id")) url_string = "#url_string#&field_wgrp_id=#field_wgrp_id#";
	if (isdefined("attributes.table_name")) url_string = "#url_string#&table_name=#table_name#";
	if (isdefined("attributes.table_id")) url_string = "#url_string#&table_id=#table_id#";
	if (isdefined("attributes.table_row_name")) url_string = "#url_string#&table_row_name=#table_row_name#";
	if (isdefined("attributes.row_count")) url_string = "#url_string#&row_count=#row_count#";	
	if (isdefined('attributes.action_name')) url_string = '#url_string#&action_name=#action_name#';
	if (isdefined('attributes.action_id')) url_string = '#url_string#&action_id=#action_id#';
	if (isdefined('attributes.sub_url')) url_string = '#url_string#&sub_url=#sub_url#';
	if (isdefined('attributes.sub_url_id')) url_string = '#url_string#&sub_url_id=#sub_url_id#';
	if (isdefined('attributes.field_type')) url_string = '#url_string#&field_type=#field_type#';
	if (isdefined('attributes.field_emp_mail')) url_string = '#url_string#&field_emp_mail=#field_emp_mail#';
	if (isdefined('attributes.field_pos_name')) url_string = '#url_string#&field_pos_name=#field_pos_name#';
	if (isdefined('attributes.field_code')) url_string = '#url_string#&field_code=#field_code#';
	if (isdefined('attributes.field_branch_name')) url_string = '#url_string#&field_branch_name=#field_branch_name#';
	if (isdefined('attributes.field_dep_name')) url_string = '#url_string#&field_dep_name=#field_dep_name#';
	if (isdefined('attributes.select_list')) url_string = '#url_string#&select_list=#select_list#';
	if (isdefined("attributes.url_direction")) url_string = "#url_string#&url_direction=#url_direction#";
	if (isdefined("attributes.is_branch_control")) url_string = "#url_string#&is_branch_control=1";
	if (isdefined("attributes.order_employee")) url_string = "#url_string#&order_employee=#order_employee#";
	if (isdefined("attributes.multi")) url_string = "#url_string#&multi=#multi#";
	if (isdefined("attributes.url_params")) url_string = "#url_string#&url_params=#attributes.url_params#";
	if (isdefined("attributes.form_submit")) url_string = "#url_string#&form_submit=#attributes.form_submit#";

</cfscript>
<cfif IsDefined("attributes.url_params") and Len(attributes.url_params)>
	<cfloop list="#attributes.url_params#" index="urlparam">
		<cfset url_string = "#url_string#&#urlparam#=#evaluate('attributes.'&urlparam)#">
	</cfloop>
</cfif>
<cfsavecontent variable="head_">
	<cfoutput>
		<div class="ui-form-list flex-list">
			<div class="form-group">
				<select name="categories" id="categories" onchange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>">
					<cfif ListFind(select_list,1)>
						<cfif isdefined('session.ep.userid')>
							<option value="#request.self#?fuseaction=objects.popup_list_positions_multiuser#url_string#" selected><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
						<cfelse>
							<option value="#request.self#?fuseaction=objects2.popup_list_positions_multiuser#url_string#" selected><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
						</cfif>
					</cfif>
					<cfif ListFind(select_list,2)>
						<option value="#request.self#?fuseaction=objects.popup_list_pars_multiuser#url_string#"><cf_get_lang dictionary_id='32995.C Kurumsal Üyeler'></option>
						</cfif>
						<cfif ListFind(select_list,3)>
						<option value="#request.self#?fuseaction=objects.popup_list_cons_multiuser#url_string#"><cf_get_lang dictionary_id='32996.C Bireysel Üyeler'></option>
					</cfif>
					<cfif ListFind(select_list,4)>
						<option value="#request.self#?fuseaction=objects.popup_list_grps_multiuser#url_string#"><cf_get_lang dictionary_id='32716.Gruplar'></option>
					</cfif>
					<cfif ListFind(select_list,5)>
						<cfif isdefined('session.ep.userid')>
							<option value="#request.self#?fuseaction=objects.popup_list_pot_cons_multiuser#url_string#">P <cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
						<cfelse>
							<option value="#request.self#?fuseaction=objects2.popup_list_pot_cons_multiuser#url_string#">P <cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
						</cfif>
					</cfif>
					<cfif ListFind(select_list,6)>
						<cfif isdefined('session.ep.userid')>
							<option value="#request.self#?fuseaction=objects.popup_list_pot_pars_multiuser#url_string#">P <cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
						<cfelse>
							<option value="#request.self#?fuseaction=objects2.popup_list_pot_pars_multiuser#url_string#">P <cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
						</cfif>
					</cfif>
					<cfif ListFind(select_list,7)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_pars_multiuser#url_string#"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
					</cfif>
					<cfif ListFind(select_list,8)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_cons_multiuser#url_string#"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
					</cfif>
				</select>
			</div>
		</div>
	</cfoutput>
</cfsavecontent>
<!-- sil -->

<cf_box title="#getLang('','Çalışanlar',30370)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_wrk_alphabet keyword ="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search" id="search" action="#request.self#?fuseaction=objects.popup_list_positions_multiuser#url_string#" method="post">
		<input type="hidden" name="form_submit" id="form_submit" value="1">
		<cf_box_search>
			<div class="form-group" id="item-keyword">
				<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
			</div>
			<div class="form-group" id="item-position_cat_id">
				<select name="position_cat_id" id="position_cat_id">
					<option value=""><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></option>
					<cfoutput query="get_position_cats">
						<option value="#position_cat_id#" <cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#
					</cfoutput>
				</select>
			</div>
			<cfif isDefined('xml_filter_by_hierarchy') and xml_filter_by_hierarchy eq 1>
				<div class="form-group" id="item-filter_by_hierarchy">
					<cfinput type="text" name="filter_by_hierarchy" id="filter_by_hierarchy" placeholder="#getLang('','Hiyerarşi',57761)#" value="#attributes.filter_by_hierarchy#">
				</div>
			</cfif>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
		<cfif len(attributes.keyword)>
			<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
		</cfif> 
		<cfif len(attributes.filter_by_hierarchy)>
			<cfset url_string = '#url_string#&filter_by_hierarchy=#attributes.filter_by_hierarchy#'>
		</cfif> 
		<cfif len(attributes.company_id)>
			<cfset url_string = '#url_string#&company_id=#attributes.company_id#'>
		</cfif> 
		<cfif len(attributes.branch_id)>
			<cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
		</cfif>
		<cfif len(attributes.department)>
			<cfset url_string = '#url_string#&department=#attributes.department#'>
		</cfif>
		<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
			<!-- sil -->
			<div class="form-group col col-3 col-md-4 col-sm-4 col-xs-12" id="item-company_id">
				<select name="company_id" id="company_id" onchange="showBranch(this.value)">
					<option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>
					<cfoutput query="get_company">
						<option value="#comp_id#"<cfif isdefined("attributes.company_id") and (attributes.company_id eq comp_id)>selected</cfif>>#company_name#</option>
					</cfoutput>
				</select>
			</div>
			<cfif isDefined('x_show_title') and x_show_title>
				<cfquery name="TITLES" datasource="#DSN#">
					SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
				</cfquery>
				<div class="form-group col col-3 col-md-4 col-sm-4 col-xs-12" id="item-title_id">
					<select name="title_id" id="title_id">
						<option value=""><cf_get_lang dictionary_id='57571.Ünvan'></option>
						<cfoutput query="titles"> 
							<option value="#title_id#" <cfif attributes.title_id eq title_id>selected</cfif>>#title#</option> 
						</cfoutput>
					</select>
				</div>   
			</cfif>
			<div class="form-group col col-3 col-md-4 col-sm-4 col-xs-12" id="item-branch_id">
				<div id="branch_place">
					<select name="branch_id" id="branch_id" onchange="showDepartment(this.value)">
						<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
						<cfoutput query="get_branches" group="NICK_NAME">
							<optgroup label="#nick_name#"></optgroup>
							<cfoutput>
								<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#branch_name#</option>
							</cfoutput>
						</cfoutput>
					</select>
				</div>
			</div>   
			<div class="form-group col col-3 col-md-4 col-sm-4 col-xs-12" id="item-department_place">
				<div id="department_place">
					<select name="department" id="department">
						<option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
						<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
							<cfoutput query="get_departments">
								<option value="#department_id#" <cfif isdefined('attributes.department') and (attributes.department eq get_departments.department_id)>selected</cfif>>#department_head#</option>
							</cfoutput>
						</cfif>
					</select>
				</div>
			</div>			
		</cf_box_search_detail>
	</cfform>
	<tbody><cfoutput>#head_#</cfoutput></tbody>
	<form action="" method="post" name="form_name">
		<cf_grid_list>
			<thead>
				<tr>
					<cfif get_positions.recordcount><th width="15"><input type="Checkbox" name="all_" id="all_" value="1" onclick="javascript: hepsi();"></th></cfif>
					<th width="20"></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='32983.Yetki Grubu'></th>
					<cfif isDefined('x_show_title') and x_show_title><th><cf_get_lang dictionary_id='57571.Ünvan'></th></cfif>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<th><cf_get_lang dictionary_id='57992.Bölge'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>	
				</tr>
			</thead>
				<cfif get_positions.recordcount>
					<tbody>
						<cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td>
									<input type="checkbox" name="emp_ids" id="emp_ids" value="#employee_id#">
									<input type="hidden" name="employee_name" id="employee_name" value="#employee_name#">
									<input type="hidden" name="employee_surname" id="employee_surname" value="#employee_surname#">
									<input type="hidden" name="employee_email" id="employee_email" value="#employee_email#">
									<input type="hidden" name="position_id" id="position_id" value="#position_id#">
									<input type="hidden" name="position_name" id="position_name" value="#position_name#">
									<input type="hidden" name="position_code" id="position_code" value="#position_code#">
									<input type="hidden" name="branch_name" id="branch_name" value="#branch_name#">
									<input type="hidden" name="department_head" id="department_head" value="#department_head#">
								</td>
								<td width="25"><cf_online id="#employee_id#" zone="ep"></td>
								<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&department_id=#department_id#&emp_id=#employee_id#&pos_id=#position_code##url_string#','medium')">#employee_name# #employee_surname#</a></td>
								<td>#position_name#</td>
								<td>#user_group_name#</td>
								<cfif isDefined('x_show_title') and x_show_title><td>#title#</td></cfif>
								<td>#ozel_kod#</td>
								<td>#zone_name#</td>
								<td>#branch_name#</td>
								<td>#department_head#</td>
							</tr>
						</cfoutput>
					</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="9" align="left"><cfif isdefined("attributes.form_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
						</tr>
					</tbody>
				</cfif>
				<input type="hidden" name="record_type" id="record_type" value="employee">
				<input type="hidden" name="modal_id" id="modal_id" value=<cfif isdefined('attributes.draggable')>"#attributes.modal_id#"</cfif>>
				<input type="hidden" name="url_string" id="url_string" value="<cfoutput>#url_string#</cfoutput>">
		</cf_grid_list>
	</form>
	<cfif get_positions.recordcount>
		<div class="ui-info-bottom  flex-end">
			<div class="margin-right-5"><a class="ui-btn ui-btn-delete" href="javascript://" onclick="cancel();"><cf_get_lang dictionary_id='57462.Vazgeç'></a></div>
			<div><a class="ui-btn ui-btn-success" href="javascript://" onclick="add_checked();"><cf_get_lang dictionary_id='57461.Kaydet'></a></div>
		</div>
	</cfif> 
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="objects.popup_list_positions_multiuser#url_string#&form_submit=1" isAjax="#iif(isdefined("attributes.draggable"),1,0)#">		
	</cfif>
</cf_box>

<cfif isdefined("attributes.form_submit")>
	<script type="text/javascript">
		function hepsi()
		{
			if (document.getElementById('all_').checked)
			{
				<cfif get_positions.recordcount gt 1  and attributes.maxrows neq 1>	
					for(i=0;i<document.form_name.emp_ids.length;i++) document.form_name.emp_ids[i].checked = true;
				<cfelseif get_positions.recordcount eq 1 or  attributes.maxrows eq 1>
					document.form_name.emp_ids.checked = true;
				</cfif>
			}
			else
			{
				<cfif get_positions.recordcount gt 1  and attributes.maxrows neq 1>	
					for(i=0;i<document.form_name.emp_ids.length;i++) document.form_name.emp_ids[i].checked = false;
				<cfelseif get_positions.recordcount eq 1 or  attributes.maxrows eq 1>
					document.form_name.emp_ids.checked = false;
				</cfif>
			}
		}
	</script>
</cfif>
<script type="text/javascript">
$(document).ready(function(){
    $( "#keyword" ).focus();
});
	function showBranch(company_id)	
	{ 
		if (company_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popupajax_list_branches&company_id="+company_id;
			AjaxPageLoad(send_address,'branch_place',1,'İlişkili Şubeler');
		}
		else
		{
			var myList = document.getElementById("branch_id");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="41.Şube">'));
			myList.appendChild(txtFld);
			var myList = document.getElementById("department");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
			myList.appendChild(txtFld);
			
		}		
	}
	
	function showDepartment(branch_id)	
	{
	
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address_ = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popupajax_list_departments&branch_id="+branch_id;
			AjaxPageLoad(send_address_,'department_place',1,'İlişkili Departmanlar');
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
</script>
