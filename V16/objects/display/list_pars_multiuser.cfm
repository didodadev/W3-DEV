<!--- 
İki tip kullanımı vardır.
-------------------------
1. Açan penceredeki istenen alana seçilenleri kaydeder !
	is_branch_control : pozisyon tarafi icin 
	to_title: hangi baslik atilacak custom tag icin kullanilir bu
	field_id: 			partner_id
	field_name:			Partner adı ve soyadı
	field_comp_id:		Partner 'ın şirket id si
	field_comp_name:	Partner 'ın şirket full adı
	field_address:		Partner 'ın şirketinin adresi
	field_type:			"partner"
örnek kullanım : 	
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars_multiuser&field_id=form1.aaa&field_name=form1.bbb&field_comp_id=form1.aaa&field_comp_name=form1.aaa&field_name=form1.aaa&camp_id=2&select_list=2,1,3,4,5,6','list');"> Gidecekler </a>

2. Açan penceredeki ilgili listeye yeni kişi eklemek için kullanılır ! Url_direction da belirtilen fuseaction'a başta par_id ler olmak üzere hidden inputları gönderir.
	url_direction: 		Submit edilecek yer.. bu adrese url_params eklenecek ve bunun içinde fuseaction hariç diğer url parametrelerinin ismi yazacak virgülle ayrılmış vaziyette
						(Örnek: campaign.emptypopup_add_list&cmp_id=111&asd_id=222&url_params=cmp_id,asd_id)
örnek kullanım :
	<cfset url_direction = 'campaign.emptypopup_add_list&cmp_id=111&asd_id=222&url_params=cmp_id,asd_id'>
	<a href="//" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars_multiuser&url_direction=#url_direction#</cfoutput>','list')"> <img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='170.Ekle'>" align="center" border="0"> </a>
	Submit edilen par_id input'unun ismi attributes.par_ids dir ve içinde virgülle ayrılmış bir liste olarak kişileri tutmaktadır. 
	Ayrıca eğer select_list içinde birden fazla numara varsa o zaman submit edilen değerlerin hangisine ait olduğu hidden input "member_type" ile belirlenir.
	Submit edilen input'lar:
		<input type="checkbox" value="#partner_id#" name="par_ids">
		<input type="hidden" name="company_partner_name" value="#company_partner_name#">
		<input type="hidden" name="company_partner_surname" value="#company_partner_surname#">
		<input type="hidden" name="company_id" value="#company_id#">
		<input type="hidden" name="fullname" value="#fullname#">
		<input type="hidden" name="cont" value="#cont#">
		<input type="hidden" name="member_type" value="partner">
		Revizyon:09012003 Arzu BT
		id bilgilerini forma gonderirken asagidaki yapida gonderecektir.orn:employee icin emp-employee_id ile birlestirerek.
		EMP-id  employeer icin
		PAR-id partner id icin 
		POS-id position_id icin(employeer position)
		CON-id consumer id icin
		GRP-id group id icin 
		WRK-id	bu yok sanirsam	
--->
<cf_xml_page_edit fuseact="objects.popup_list_pars_multiuser">
<cfif fusebox.fuseaction contains "popup_list_all_pars" or fusebox.fuseaction contains "popup_list_pars_multiuser">
	<cfparam name="attributes.type" default="">
<cfelseif fusebox.fuseaction contains "popup_list_pot_pars">
	<cfparam name="attributes.type" default="1">
<cfelse>
	<cfparam name="attributes.type" default="0">
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword_partner" default="">
<cfparam name="attributes.related_comp_id" default="">
<cfparam name="attributes.companycat" default="">
<cfparam name="attributes.company_sector" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.sales_county" default="">
<cfif isdefined("attributes.form_submit")>
	<cfinclude template="../query/get_partners_multiuser.cfm">
<cfelse>
	<cfset get_partners.recordcount = "0">
</cfif>
<cfparam name="attributes.totalrecords" default="#get_partners.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="SZ" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES
</cfquery>
<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE  FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="GET_COMPANY_SECTOR" datasource="#DSN#">
	SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT ASC
</cfquery>

<cfif isdefined("attributes.form_submit")>
	<script type="text/javascript">
	function add_checked()
	{
	
		<cfif isdefined("attributes.to_title") and len(attributes.to_title)>to_title = <cfoutput>#attributes.to_title#</cfoutput>;<cfelse>to_title=1;</cfif>
		<cfif isdefined("attributes.row_count")>
			rowCount = parseInt(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.<cfoutput>#attributes.row_count#</cfoutput>.value);
		</cfif>
		var counter = 0;
		<cfif get_partners.recordcount gt 1 and attributes.maxrows gt 1>
			for (i = 0 ; i < form_name_.par_ids.length ; i++) 
			if (form_name_.par_ids[i].checked == true)
			{
				counter = counter + 1;
			}
			if (counter == 0)
			{
				alert("<cf_get_lang dictionary_id ='33181.Kişi seçmelisiniz'> !");
				return false;
			}
		<cfelseif get_partners.recordcount eq 1 or attributes.maxrows eq 1>
			if (form_name_.par_ids.checked == true) 
			{
				counter = counter + 1;
			}
			if (counter == 0)
			{
				alert("<cf_get_lang dictionary_id ='33181.Kişi seçmelisiniz'> !");
				return false;
			}
		</cfif>

		<cfif isdefined("attributes.order_employee") and isdefined("attributes.multi")>
			if(document.form_name_.par_ids.length != undefined)
			{
				for(i=0;i< document.form_name_.par_ids.length;i++) 
				{
					if (document.form_name_.par_ids[i].checked == true) 
					{
						x = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.length;
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.length = parseInt(x + 1);
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.options[x].value = 'p - ' + document.form_name_.par_ids[i].value;
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.options[x].text = document.form_name_.fullname[i].value + ' - ' + document.form_name_.company_partner_name[i].value+' '+ document.form_name_.company_partner_surname[i].value;
					}
				}
			}
			else
			{
				if (document.form_name_.par_ids.checked == true) 
				{
					x = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.length;
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.length = parseInt(x + 1);
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.options[x].value = 'p - ' + form_name_.par_ids.value;
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.options[x].text = form_name_.fullname.value + ' - ' + form_name_.company_partner_name.value+' '+form_name_.company_partner_surname.value;
				}
			}
		</cfif>
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_par_id") and attributes.maxrows gt 1>	
			counter = 0;
			for(i=0;i<form_name_.par_ids.length;i++)
			{
				if (form_name_.par_ids[i].checked == true) 
				{
					counter = counter + 1;
					var par_ids = form_name_.par_ids[i].value;
					var comp_id = form_name_.company_id[i].value;
					if ( to_title == 1 )
						var par_name = form_name_.fullname[i].value+'||'+form_name_.company_partner_name[i].value+' '+form_name_.company_partner_surname[i].value;
					else
						var par_name = form_name_.fullname[i].value;
					rowCount = rowCount + 1;					
					var ss_int = ekle_str(par_name,comp_id,par_ids);
					
				}
			}
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.<cfoutput>#attributes.row_count#</cfoutput>.value = rowCount;
			<cfif not (browserDetect() contains 'MSIE')>
				id_ekle();
			</cfif>
		<cfelseif (get_partners.recordcount eq 1 or attributes.maxrows eq 1 ) and isdefined("attributes.field_par_id")>
			var par_ids = form_name_.par_ids.value;
			var comp_id = form_name_.company_id.value;
			if ( to_title == 1 )
				var par_name = form_name_.fullname.value+'||'+form_name_.company_partner_name.value+' '+form_name_.company_partner_surname.value;
			else
				var par_name = form_name_.fullname.value;
			rowCount = rowCount + 1;
			var ss_int = ekle_str(par_name,comp_id,par_ids);
			opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value = rowCount;
			<cfif not (browserDetect() contains 'MSIE')>
				id_ekle();
			</cfif>		
		</cfif>
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_id") and attributes.maxrows gt 1>	
			counter = 0;
			for(i=0;i<form_name_.par_ids.length;i++) 
				if (form_name_.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var par_id = form_name_.par_ids[i].value;
					if (counter == 1)
					{
						var par_ids =  par_id;
					}
					else
					{
						var par_ids = par_ids + ',' +  par_id;
					}
				}
				opener.<cfoutput>#attributes.field_id#</cfoutput>.value =  par_ids;
		<cfelseif (get_partners.recordcount eq 1 or attributes.maxrows eq 1) and isdefined("attributes.field_id") >
			var par_ids = form_name_.par_ids.value;
			opener.<cfoutput>#attributes.field_id#</cfoutput>.value =  par_ids;
		</cfif>	
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_partner_id") and attributes.maxrows gt 1>
			counter = 0;
			for(i=0;i<form_name_.par_ids.length;i++) 
				if (form_name_.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var par_id = form_name_.par_ids[i].value;
					if (counter == 1)
					{
						var par_ids =  par_id;
					}
					else
					{
						var par_ids = par_ids + ',' + par_id;
					}
				}
				opener.<cfoutput>#attributes.field_partner_id#</cfoutput>.value = opener.<cfoutput>#attributes.field_partner_id#</cfoutput>.value + ',' + par_ids;
		<cfelseif (get_partners.recordcount eq 1 or attributes.maxrows eq 1) and isdefined("attributes.field_partner_id")>
			var par_ids = form_name_.par_ids.value;
			opener.<cfoutput>#attributes.field_partner_id#</cfoutput>.value = opener.<cfoutput>#attributes.field_partner_id#</cfoutput>.value + ',' +  par_ids;
		</cfif>
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_name") and attributes.maxrows gt 1>	
			counter = 0;
			for(i=0;i<form_name_.par_ids.length;i++) 
				if (form_name_.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var par_name = form_name_.fullname[i].value+'||'+form_name_.company_partner_name[i].value+' '+form_name_.company_partner_surname[i].value;
					if (counter == 1)
					{
						var par_names = par_name;
					}
					else
					{
						var par_names = par_names + ',' + par_name;
					}
				}
				opener.document.all.<cfoutput>#attributes.field_name#</cfoutput>.value = opener.document.all.<cfoutput>#attributes.field_name#</cfoutput>.value + ',' + par_names;
		<cfelseif (get_partners.recordcount eq 1 or attributes.maxrows eq 1) and isdefined("attributes.field_name")>
			var par_names = form_name_.company_partner_name.value+' '+form_name_.company_partner_surname.value;
			opener.document.all.<cfoutput>#attributes.field_name#</cfoutput>.value = opener.document.all.<cfoutput>#attributes.field_name#</cfoutput>.value +  ',' + par_names;
		</cfif>
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_comp_id") and attributes.maxrows gt 1>	
			counter = 0;
			for(i=0;i<form_name_.par_ids.length;i++) 
				if (form_name_.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var comp_id = form_name_.company_id[i].value;
					if (counter == 1)
					{
						var comp_ids = comp_id;
					}
					else
					{
						var comp_ids = comp_ids + ',' + comp_id;
					}
				}
				<cfif isdefined("attributes.is_supplier")>
					var data = new FormData();
					data.append('company_id', comp_ids);
					data.append('pid', "<cfoutput>#attributes.pid#</cfoutput>");
					AjaxControlPostDataJson('V16/worknet/cfc/product.cfc?method=insertRelationSupplier', data, function(response) {
						if(response.STATUS){
							<cfif not isdefined("attributes.draggable")>window.opener.</cfif>jQuery( '#product_relation_supplier .catalyst-refresh' ).click();
						}
						else alert(response.MESSAGE);
						window.close();
					});
				</cfif>
				opener.<cfoutput>#attributes.field_comp_id#</cfoutput>.value = comp_ids;
		<cfelseif (get_partners.recordcount eq 1 or attributes.maxrows eq 1) and isdefined("attributes.field_comp_id")>
			var comp_ids = form_name_.company_id.value;
			opener.<cfoutput>#attributes.field_comp_id#</cfoutput>.value = comp_ids;
		</cfif>
		
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_comp_name") and attributes.maxrows gt 1>
			counter = 0;
			for(i=0;i<form_name_.par_ids.length;i++) 
				if (form_name_.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var comp_name = form_name_.fullname[i].value;
					if (counter == 1)
					{
						var comp_names = comp_name;
					}
					else
					{
						var comp_names = comp_names + ',' + comp_name;
					}
				}
				opener.<cfoutput>#attributes.field_comp_name#</cfoutput>.value = comp_names;
		<cfelseif (get_partners.recordcount eq 1 or attributes.maxrows eq 1 ) and isdefined("attributes.field_comp_name") >
			var comp_names = form_name_.fullname.value;
			opener.<cfoutput>#attributes.field_comp_name#</cfoutput>.value = comp_names;
		</cfif>
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_address") and attributes.maxrows gt 1>	
			counter = 0;
			for(i=0;i<form_name_.par_ids.length;i++) 
				if (form_name_.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var comp_addr = form_name_.cont[i].value;
					if (counter == 1)
					{
						var comp_addrs = comp_addr;
					}
					else
					{
						var comp_addrs = comp_addrs + ',' + comp_addr;
					}
				}
				opener.<cfoutput>#attributes.field_address#</cfoutput>.value = comp_addrs;
			<cfelseif (get_partners.recordcount eq 1 or attributes.maxrows eq 1) and isdefined("attributes.field_address")>
				var comp_addrs = form_name_.cont.value;
				opener.<cfoutput>#attributes.field_address#</cfoutput>.value = comp_addrs;
			</cfif>
	
			<cfif isdefined("attributes.field_type")>
				opener.<cfoutput>#attributes.field_type#</cfoutput>.value = "partner";
			</cfif>
		
			<cfif isDefined("attributes.url_direction")>
				<cfoutput>
                    document.form_name_.action='#request.self#?fuseaction=#attributes.url_direction#&'+form_name_.url_string.value;
                    <cfif isdefined("attributes.url_params") and listFind(attributes.url_params,'organization_id')>
                        loadPopupBox('form_name_',#attributes.modal_id#);
                        return false;
                    <cfelse>
                        <cfif isDefined("attributes.modal_id")>
                            loadPopupBox('form_name_',#attributes.modal_id#);
                            return false;
                        <cfelse>
                            document.form_name_.submit();
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
		function ekle_str(str_ekle,int_id,int_id2)
		{
			var newRow;
			var cell1, cell2;
			<cfoutput>
			newRow = <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.#attributes.table_name#.insertRow();
			newRow.setAttribute("name","#attributes.table_row_name#" + rowCount);
			newRow.setAttribute("id","#attributes.table_row_name#" + rowCount);		
			newRow.setAttribute("style","display:''");
			cell1 = newRow.insertCell(0);
    		cell2 = newRow.insertCell(1);
			newRow.insertCell(2);
			newRow.insertCell(3);
			newRow.insertCell(4);
			str_html = '';
			<cfif isdefined("attributes.field_emp_id")>
				str_html = str_html + '<input type="hidden" name="#attributes.field_emp_id#" id="#attributes.field_emp_id#" value=""><input type="hidden" name="#attributes.field_pos_id#" id="#attributes.field_pos_id#" value="">';	
				str_html = str_html + '<input type="hidden" name="#attributes.field_pos_code#" id="#attributes.field_pos_code#" value="">';	
			</cfif>
			<cfif isdefined("attributes.field_company_id")>		
				str_html = str_html + '<input type="hidden" name="#attributes.field_company_id#" id="#attributes.field_company_id#" value="' + int_id + '"><input type="hidden" name="#attributes.field_par_id#" id="#attributes.field_par_id#" value="' + int_id2 + '">';
			</cfif>
			str_html = str_html +'<input type="hidden" name="#attributes.field_grp_id#" id="#attributes.field_grp_id#" value=""><input type="hidden" name="#attributes.field_wgrp_id#" id="#attributes.field_wgrp_id#" value="">';
			str_del='<a href="javascript://" onClick="#attributes.function_row_name#(' + rowCount +','+int_id+');"><i class="fa fa-minus"></i></a>';
			cell1.innerHTML = str_del + str_html;
			cell2.innerHTML = str_ekle;
			</cfoutput>
			return 1;
			
		}
		 //sadece safari için kullanılır...
		 function id_ekle()
		 {
			<cfoutput>
				 if('#attributes.function_row_name#'=='workcube_cc_delRow')
				 {
					 if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc_par_ids.length==undefined)
					 {
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("cc_comp_ids"));
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("cc_par_ids"));
					 }
					 else
					 {
						for(var i=0;i<<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc_par_ids.length;i++)
						{
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc_comp_ids[i]);
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc_par_ids[i]);
						}
					 }
				}
				else if('#attributes.function_row_name#'=='workcube_cc2_delRow')
				{
					if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc2_par_ids.length==undefined)
					 {
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("cc2_comp_ids"));
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("cc2_par_ids"));
					 }
					 else
					 {
						for(var i=0;i<<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc2_par_ids.length;i++)
						{
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc2_comp_ids[i]);
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.cc2_par_ids[i]);
						}
					}
				}
				else
				{
					if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.to_par_ids.length==undefined)
					 {
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("to_comp_ids"));
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("to_par_ids"));
					 }
					 else
					 {
						for(var i=0;i<<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.to_par_ids.length;i++)
						{
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.to_comp_ids[i]);
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_work.appendChild(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.to_par_ids[i]);
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
	if (isdefined('attributes.field_basket_due_value')) url_string = '#url_string#&field_basket_due_value=#field_basket_due_value#';	
	if (isdefined('attributes.field_paymethod_id')) url_string = '#url_string#&field_paymethod_id=#field_paymethod_id#';
	if (isdefined('attributes.field_paymethod')) url_string = '#url_string#&field_paymethod=#field_paymethod#';	
	if (isdefined("attributes.function_row_name")) url_string = "#url_string#&function_row_name=#function_row_name#";	
	if (isdefined('attributes.field_type')) url_string = '#url_string#&field_type=#field_type#';
	if (isdefined('attributes.action_name')) url_string = '#url_string#&action_name=#action_name#';
	if (isdefined('attributes.action_id')) url_string = '#url_string#&action_id=#action_id#';
	if (isdefined('attributes.sub_url')) url_string = '#url_string#&sub_url=#sub_url#';
	if (isdefined('attributes.sub_url_id')) url_string = '#url_string#&sub_url_id=#sub_url_id#';
	if (isdefined('attributes.to_title')) url_string = '#url_string#&to_title=#to_title#';	
	if (isdefined('attributes.field_id')) url_string = '#url_string#&field_id=#field_id#';
	if (isdefined('attributes.field_partner_id')) url_string = '#url_string#&field_partner_id=#field_partner_id#';
	if (isdefined('attributes.field_pos_code')) url_string = '#url_string#&field_pos_code=#field_pos_code#';
	if (isdefined('attributes.field_company_id')) url_string = '#url_string#&field_company_id=#field_company_id#';
	if (isdefined('attributes.field_consumer_id')) url_string = '#url_string#&field_consumer_id=#field_consumer_id#';	
	if (isdefined('attributes.field_position_id')) url_string = '#url_string#&field_position_id=#field_position_id#';	
	if (isdefined('attributes.field_employee_id')) url_string = '#url_string#&field_employee_id=#field_employee_id#';			
	if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#field_emp_id#';
	if (isdefined('attributes.field_pos_id')) url_string = '#url_string#&field_pos_id=#field_pos_id#';
	if (isdefined('attributes.field_par_id')) url_string = '#url_string#&field_par_id=#field_par_id#';
	if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#field_comp_id#';
	if (isdefined('attributes.field_cons_id')) url_string = '#url_string#&field_cons_id=#field_cons_id#';
	if (isdefined('attributes.field_grp_id')) url_string = '#url_string#&field_grp_id=#field_grp_id#';	
	if (isdefined("attributes.field_wgrp_id")) url_string = "#url_string#&field_wgrp_id=#field_wgrp_id#";
	if (isdefined("attributes.table_name")) url_string = "#url_string#&table_name=#table_name#";
	if (isdefined("attributes.table_row_name")) url_string = "#url_string#&table_row_name=#table_row_name#";
	if (isdefined("attributes.row_count")) url_string = "#url_string#&row_count=#row_count#";	
	if (isdefined('attributes.field_name')) url_string = '#url_string#&field_name=#field_name#';
	if (isdefined('attributes.field_comp_name')) url_string = '#url_string#&field_comp_name=#field_comp_name#';
	if (isdefined('attributes.select_list')) url_string = '#url_string#&select_list=#select_list#';
	if (isdefined('attributes.comp_id_list')) url_string = '#url_string#&comp_id_list=#comp_id_list#';
	if (isdefined("attributes.url_direction")) url_string = "#url_string#&url_direction=#url_direction#";
	if (isdefined("attributes.field_address")) url_string = "#url_string#&field_address=#attributes.field_address#";
	if (isdefined("attributes.url_params")) url_string = "#url_string#&url_params=#attributes.url_params#";
	if (isdefined("attributes.is_branch_control")) url_string = "#url_string#&is_branch_control=1";
	if (isdefined("attributes.order_employee")) url_string = "#url_string#&order_employee=#order_employee#";
	if (isdefined("attributes.multi")) url_string = "#url_string#&multi=#multi#";
	if (isdefined('attributes.is_supplier')) url_string = '#url_string#&is_supplier=#is_supplier#';
	if (isdefined('attributes.pid')) url_string = '#url_string#&pid=#pid#';

	//if (isdefined("attributes.show_all_companies")) url_string = "#url_string#&show_all_companies=1";
	//if (isdefined("attributes.companycat")) url_string = "#url_string#&companycat=#attributes.companycat#";
	//if (isdefined("attributes.company_sector")) url_string = "#url_string#&company_sector=#attributes.company_sector#";
	//if (isdefined("attributes.customer_value")) url_string = "#url_string#&customer_value=#attributes.customer_value#";
	//if (isdefined("attributes.sales_county")) url_string = "#url_string#&sales_county=#attributes.sales_county#";
</cfscript>
<cfif isdefined("attributes.url_params") and Len(attributes.url_params)>
	<cfloop list="#attributes.url_params#" index="urlparam">
		<cfset url_string = "#url_string#&#urlparam#=#evaluate('attributes.'&urlparam)#">
	</cfloop>
</cfif>
<cfif isdefined("attributes.form_submit") and attributes.form_submit eq 1>
	<cfset url_string = "#url_string#&form_submit=1">
</cfif>
<cfsavecontent variable="head_">
	<cfoutput>
		<div class="ui-form-list flex-list">
			<div class="form-group">
				<cfif not isdefined("url.hide")>
					<select name="categories" id="categories" onchange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>">
						<cfif ListFind(select_list,1)>
							<cfif isdefined('session.ep.userid')>
								<option value="#request.self#?fuseaction=objects.popup_list_positions_multiuser#url_string#"><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
							<cfelse>
								<option value="#request.self#?fuseaction=objects2.popup_list_positions_multiuser#url_string#"><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
							</cfif>
						</cfif>
						<cfif ListFind(select_list,2)>
							<option value="#request.self#?fuseaction=objects.popup_list_pars_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_pars_multiuser"> selected</cfif>>C.<cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
						</cfif>
						<cfif ListFind(select_list,3)>
							<option value="#request.self#?fuseaction=objects.popup_list_cons_multiuser#url_string#">C.<cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
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
								<option value="#request.self#?fuseaction=objects.popup_list_pot_pars_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_pot_pars_multiuser"> selected</cfif>>P <cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
							<cfelse>
								<option value="#request.self#?fuseaction=objects.popup_list_pot_pars_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_pot_pars_multiuser"> selected</cfif>>P <cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
							</cfif>
						</cfif>
						<cfif ListFind(select_list,7)>
							<option value="#request.self#?fuseaction=objects.popup_list_all_pars_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_all_pars_multiuser"> selected</cfif>><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
						</cfif>
						<cfif ListFind(select_list,8)>
							<option value="#request.self#?fuseaction=objects.popup_list_all_cons_multiuser#url_string#"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
						</cfif>
					</select>
				</cfif>
			</div>
		</div>
	</cfoutput>
</cfsavecontent>

<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','Kurumsal Üyeler',29408)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_par" action="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#" method="post"> 
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<cf_box_search>
				<div class="form-group" id="keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58585.Kod'>-<cf_get_lang dictionary_id='57574.Şirket'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group" id="item-keyword_partner">
						<cfinput type="text" name="keyword_partner" placeholder="#getLang('','Çalışan',57576)#" value="#attributes.keyword_partner#" maxlength="255">
				</div>
				<div class="form-group small">
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_par' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<div class="form-group">
                	<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#?fuseaction=member.form_list_company&event=add&isModule=objects#url_string#</cfoutput>" target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='29409.Kurumsal Üye Ekle'>"></i></a>
            	</div>
				<div class="form-group">
                	<a class="ui-btn ui-btn-gray2" href="javascript:history.go(-1);"><i class="fa fa-arrow-left" title="<cf_get_lang dictionary_id='57432.Geri'>"></i></a>
            	</div>
			</cf_box_search>					
			<cfif isdefined("attributes.keyword")>
				<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.keyword_partner")>
				<cfset url_string = "#url_string#&keyword_partner=#attributes.keyword_partner#">
			</cfif>
			<cfif isdefined("attributes.companycat") and Len(attributes.companycat)>
				<cfset url_string = "#url_string#&companycat=#attributes.companycat#">
			</cfif>
			<cfif isdefined("attributes.company_sector") and Len(attributes.company_sector)>
				<cfset url_string = "#url_string#&company_sector=#attributes.company_sector#">
			</cfif>
			<cfif isdefined("attributes.customer_value") and Len(attributes.customer_value)>
				<cfset url_string = "#url_string#&customer_value=#attributes.customer_value#">
			</cfif>
			<cfif isdefined("attributes.sales_county") and Len(attributes.sales_county)>
				<cfset url_string = "#url_string#&sales_county=#attributes.sales_county#">
			</cfif>
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_par' , #attributes.modal_id#)"),DE(""))#">
				<div class="form-group col col-4 col-sm-4 col-md-6 col-xs-12" id="item-companycat">
					<select name="companycat" id="companycat"tabindex="23">
						<option value=""><cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'></option>
						<cfoutput query="get_companycat">
							<option value="#companycat_id#" <cfif attributes.companycat eq companycat_id>selected</cfif>>#companycat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group col col-4 col-sm-4 col-md-6 col-xs-12" id="item-customer_value">
					<select name="customer_value" id="customer_value">
						<option value=""><cf_get_lang dictionary_id='58552.Müşteri Değeri'></option>
						<cfoutput query="get_customer_value">
							<option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value>selected</cfif>>#customer_value#</option>
						</cfoutput>
					</select>
					<cfif xml_related_comp_id eq 1>
						<cf_get_lang dictionary_id='32448.İlişkili Üyeler'><input type="checkbox" name="related_comp_id" id="related_comp_id" value="1" <cfif attributes.related_comp_id eq 1>checked</cfif>>
					</cfif>
				</div>
				<div class="form-group col col-4 col-sm-4 col-md-6 col-xs-12" id="item-company_sector">
					<select name="company_sector" id="company_sector" tabindex="25">
						<option value=""><cf_get_lang dictionary_id='57579.Sektör'>               
						<cfoutput query="get_company_sector">
							<option value="#sector_cat_id#" <cfif attributes.company_sector eq sector_cat_id>selected</cfif>>#sector_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group col col-4 col-sm-4 col-md-6 col-xs-12" id="item-sales_county">
					<select name="sales_county" id="sales_county" tabindex="27">
						<option value=""><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>
						<cfoutput query="sz">
							<option value="#sz_id#" <cfif sz_id eq attributes.sales_county>selected</cfif>>#sz_name#</option>
						</cfoutput>
					</select>
				</div>
			</cf_box_search_detail>
		</cfform>
		<tbody><cfoutput>#head_#</cfoutput></tbody>
		<form action="" method="post" name="form_name_">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="20"><cfif get_partners.recordcount><input type="Checkbox" name="all" id="all" value="1" onclick="javascript: hepsi();"></cfif></th>
						<th width="20"><cfif get_partners.recordcount><i class="fa fa-plus" title="<cf_get_lang dictionary_id='32938.Şirkete Çalışan Ekle'>"></i></cfif></th>
						<th width="20"></th>
						<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='57574.Şirket'></th>
						<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<th><cf_get_lang dictionary_id='57486.kategori'></th>
						<th><cf_get_lang dictionary_id='57571.ünvan'></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
				<!--- <cfif isdefined("attributes.form_submit")> --->
				<cfif get_partners.recordcount>
				<cfoutput query="get_partners" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<tr>
					<td width="15">
						<input type="checkbox" name="par_ids" id="par_ids" value="#partner_id#">
					</td>
						<td width="20"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_partner&compid=#company_id##url_string#','medium')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='32938.Şirkete Çalışan Ekle'>"></i></a></td>
						<td width="20"><cf_online id="#partner_id#" zone="pp"></td>
						<td width="20">#member_code#</td>
						<td>
							<cfset cont="#company_address# #company_postcode# #county# #city#">
							<cfset rm = '#chr(13)#'>
							<cfset cont = ReplaceList(cont,rm,'')>
							<cfset rm = '#chr(10)#'>
							<cfset cont = ReplaceList(cont,rm,'')>			  
							#fullname#
						</td>
						<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id##url_string#','medium')">#company_partner_name# #company_partner_surname#</a></td>
						<td>#companycat#</td>
						<td>#title#</td>
						<td>
							<input type="hidden" name="company_partner_name" id="company_partner_name" value="#company_partner_name#">
							<input type="hidden" name="company_partner_surname" id="company_partner_surname" value="#company_partner_surname#">
							<input type="hidden" name="company_id" id="company_id" value="#company_id#">
							<input type="hidden" name="fullname" id="fullname" value="#fullname#">
							<input type="hidden" name="cont" id="cont" value="#cont#">
						</td>
					</tr>
				</tbody>
				</cfoutput>			
					<cfelse>
						<tbody>
							<tr>
								<td colspan="9"><cfif isdefined("attributes.form_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
							</tr>
						</tbody>
					</cfif>		
					<input type="hidden" name="member_type" id="member_type" value="partner">
					<input type="hidden" name="url_string" id="url_string" value="<cfoutput>#url_string#</cfoutput>">					
			</cf_grid_list>	
		</form>
		<cfif get_partners.recordcount>
			<div class="ui-info-bottom  flex-end">
				<div><a class="ui-btn ui-btn-success" href="javascript://" onclick="add_checked()"><cf_get_lang dictionary_id='57461.Kaydet'></a></div>
			</div>	
		</cfif>		
		<cfif isdefined("attributes.form_submit") and attributes.totalrecords gt attributes.maxrows>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="objects.#fusebox.fuseaction##url_string#&form_submit=1"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</div>
</cf_box>
<cfif isdefined("attributes.form_submit")>
	<script type="text/javascript">
	function hepsi()
	{
		if (document.getElementById('all').checked)
		{
		
		<cfif get_partners.recordcount gt 1 and attributes.maxrows gt 1>	
			for(i=0;i<form_name_.par_ids.length;i++) form_name_.par_ids[i].checked = true;
		<cfelseif get_partners.recordcount eq 1 or attributes.maxrows eq 1>
			form_name_.par_ids.checked = true;
		</cfif>
		}
		else
		{
		<cfif get_partners.recordcount gt 1 and attributes.maxrows gt 1>	
			for(i=0;i<form_name_.par_ids.length;i++) form_name_.par_ids[i].checked = false;
		<cfelseif get_partners.recordcount eq 1>
			form_name_.par_ids.checked = false;
		</cfif>
		}
	}
	</script>
</cfif>
<script type="text/javascript">
	document.search_par.keyword.focus();
</script>
