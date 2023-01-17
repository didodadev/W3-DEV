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
<cfif fusebox.fuseaction contains "popup_list_all_pars">
	<cfparam name="attributes.type" default="">
<cfelseif fusebox.fuseaction contains "popup_list_pot_pars">
	<cfparam name="attributes.type" default="1">
<cfelseif fusebox.fuseaction contains "popup_list_my_pars">
	<cfparam name="attributes.type" default="2">
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
<cfparam name="attributes.select_list" default="1,2,3,4,5,6">

<cfif isdefined("attributes.form_submit")>
	<cfinclude template="../../objects/query/get_partners_multiuser.cfm">
<cfelse>
	<cfset get_partners.recordcount = "0">
</cfif>
<cfparam name="attributes.totalrecords" default="#get_partners.recordcount#">
<cfparam name="attributes.page" default=1>
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
			rowCount = parseInt(opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value);
		</cfif>
		var counter = 0;
		<cfif get_partners.recordcount gt 1 and attributes.maxrows gt 1>
			for (i = 0 ; i < document.form_name.par_ids.length ; i++) 
				if (document.form_name.par_ids[i].checked == true)
				{
					counter = counter + 1;
				}
			if (counter == 0)
			{
				alert("<cf_get_lang no ='221.Kişi seçmelisiniz'>!");
				return false;
			}
		<cfelseif get_partners.recordcount eq 1 or attributes.maxrows eq 1>
			if (document.getElementById('par_ids').checked == true) 
			{
				counter = counter + 1;
			}
			if (counter == 0)
			{
				alert("<cf_get_lang no ='221.Kişi seçmelisiniz'>!");
				return false;
			}
		</cfif>
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_par_id") and attributes.maxrows gt 1>	
			counter = 0;
			for(i=0; i<document.form_name.par_ids.length; i++)
			{

				if (document.form_name.par_ids[i].checked == true) 
				{
					counter = counter + 1;
					var par_ids = document.form_name.par_ids[i].value;
					var comp_id = document.form_name.company_id[i].value;
					if ( to_title == 1 )
						var par_name = document.form_name.fullname[i].value+'||'+document.form_name.company_partner_name[i].value+' '+document.form_name.company_partner_surname[i].value;
					else
						var par_name = document.form_name.fullname[i].value;
					rowCount = rowCount + 1;					
					var ss_int = ekle_str(par_name,comp_id,par_ids);
					
				}

			}
			opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value = rowCount;
			<cfif not (browserDetect() contains 'MSIE')>
				id_ekle();
			</cfif>
		<cfelseif (get_partners.recordcount eq 1 or attributes.maxrows eq 1 ) and isdefined("attributes.field_par_id")>
			var par_ids = document.getElementById('par_ids').value;
			var comp_id = document.getElementById('company_id').value;
			if ( to_title == 1 )
				var par_name = document.getElementById('fullname').value+'||'+document.getElementById('company_partner_name').value+' '+document.getElementById('company_partner_surname').value;
			else
				var par_name = document.getElementById('fullname').value;
			rowCount = rowCount + 1;
			var ss_int = ekle_str(par_name,comp_id,par_ids);
			opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value = rowCount;
			<cfif not (browserDetect() contains 'MSIE')>
				id_ekle();
			</cfif>		
		</cfif>
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_id") and attributes.maxrows gt 1>	
			counter = 0;
			for(i=0;i<document.form_name.par_ids.length;i++) 
				if (document.form_name.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var par_id = document.form_name.par_ids[i].value;
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
			var par_ids = document.getElementById('par_ids').value;
			opener.<cfoutput>#attributes.field_id#</cfoutput>.value =  par_ids;
		</cfif>	
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_partner_id") and attributes.maxrows gt 1>
			counter = 0;
			for(i=0;i<document.form_name.par_ids.length;i++) 
				if (document.form_name.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var par_id = document.form_name.par_ids[i].value;
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
			var par_ids = document.getElementById('par_ids').value;
			opener.<cfoutput>#attributes.field_partner_id#</cfoutput>.value = opener.<cfoutput>#attributes.field_partner_id#</cfoutput>.value + ',' +  par_ids;
		</cfif>

		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_name") and attributes.maxrows gt 1>	
			counter = 0;
			for(i=0;i<document.form_name.par_ids.length;i++) 
				if (document.form_name.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var par_name = document.form_name.fullname[i].value+'||'+document.form_name.company_partner_name[i].value+' '+document.form_name.company_partner_surname[i].value;
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
			var par_names = document.getElementById('company_partner_name').value+' '+document.getElementById('company_partner_surname').value;
			opener.document.all.<cfoutput>#attributes.field_name#</cfoutput>.value = opener.document.all.<cfoutput>#attributes.field_name#</cfoutput>.value +  ',' + par_names;
		</cfif>

		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_comp_id") and attributes.maxrows gt 1>	
			counter = 0;
			for(i=0;i<document.form_name.par_ids.length;i++) 
				if (document.form_name.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var comp_id = document.form_name.company_id[i].value;
					if (counter == 1)
					{
						var comp_ids = comp_id;
					}
					else
					{
						var comp_ids = comp_ids + ',' + comp_id;
					}
				}
				opener.<cfoutput>#attributes.field_comp_id#</cfoutput>.value = comp_ids;
		<cfelseif (get_partners.recordcount eq 1 or attributes.maxrows eq 1) and isdefined("attributes.field_comp_id")>
			var comp_ids = document.getElementById('company_id').value;
			opener.<cfoutput>#attributes.field_comp_id#</cfoutput>.value = comp_ids;
		</cfif>

	
		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_comp_name") and attributes.maxrows gt 1>
			counter = 0;
			for(i=0;i<document.form_name.par_ids.length;i++) 
				if (document.form_name.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var comp_name = document.form_name.fullname[i].value;
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
			var comp_names = document.getElementById('fullname').value;
			opener.<cfoutput>#attributes.field_comp_name#</cfoutput>.value = comp_names;
		</cfif>

		<cfif get_partners.recordcount gt 1 and isdefined("attributes.field_address") and attributes.maxrows gt 1>	
			counter = 0;
			for(i=0;i<document.form_name.par_ids.length;i++) 
				if (document.form_name.par_ids[i].checked == true)
				{
					counter = counter + 1;
					var comp_addr = document.form_name.cont[i].value;
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
			var comp_addrs = document.getElementById('cont').value;
			opener.<cfoutput>#attributes.field_address#</cfoutput>.value = comp_addrs;
		</cfif>

		<cfif isdefined("attributes.field_type")>
			opener.<cfoutput>#attributes.field_type#</cfoutput>.value = "partner";
		</cfif>
		<cfif isDefined("attributes.url_direction")>
			<cfoutput>
			document.form_name.action='#request.self#?fuseaction=#attributes.url_direction#&'+document.getElementById('url_string').value;
			</cfoutput>
			document.form_name.submit();
		<cfelse>
			/*window.close();*/
		</cfif>
	}
		
	<cfif isdefined("attributes.table_name")>
		function ekle_str(str_ekle,int_id,int_id2)
		{
			var newRow;
			var newCell;
			<cfoutput>
			newRow = opener.document.all.#attributes.table_name#.insertRow();
			newRow.setAttribute("name","#attributes.table_row_name#" + rowCount);
			newRow.setAttribute("id","#attributes.table_row_name#" + rowCount);		
			newRow.setAttribute("style","display:''");
			newCell = newRow.insertCell(newRow.cells.length);
			str_html = '';
			<cfif isdefined("attributes.field_emp_id")>
				str_html = str_html + '<input type="hidden" name="#attributes.field_emp_id#" id="#attributes.field_emp_id#" value=""><input type="hidden" name="#attributes.field_pos_id#" id="#attributes.field_pos_id#" value="">';	
				str_html = str_html + '<input type="hidden" name="#attributes.field_pos_code#" id="#attributes.field_pos_code#" value="">';	
			</cfif>
			<cfif isdefined("attributes.field_company_id")>		
				str_html = str_html + '<input type="hidden" name="#attributes.field_company_id#" id="#attributes.field_company_id#" value="' + int_id + '"><input type="hidden" name="#attributes.field_par_id#" id="#attributes.field_par_id#" value="' + int_id2 + '">';
			</cfif>
			str_html = str_html +'<input type="hidden" name="#attributes.field_grp_id#" id="#attributes.field_grp_id#" value=""><input type="hidden" name="#attributes.field_wgrp_id#" id="#attributes.field_wgrp_id#" value="">';
			str_del='<a href="javascript://" onClick="#attributes.function_row_name#(' + rowCount +','+int_id+');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;';
			newCell.innerHTML = str_del + str_html + str_ekle;
			</cfoutput>
			return 1;
			
		}
		 //sadece safari için kullanılır...
		 function id_ekle()
		 {
			<cfoutput>
				 if('#attributes.function_row_name#'=='workcube_cc_delRow')
				 {
					 if(window.opener.document.all.cc_par_ids.length==undefined)
					 {
						window.opener.document.upd_work.appendChild(window.opener.document.getElementById("cc_comp_ids"));
						window.opener.document.upd_work.appendChild(window.opener.document.getElementById("cc_par_ids"));
					 }
					 else
					 {
						for(var i=0;i<window.opener.document.all.cc_par_ids.length;i++)
						{
							window.opener.document.upd_work.appendChild(window.opener.document.all.cc_comp_ids[i]);
							window.opener.document.upd_work.appendChild(window.opener.document.all.cc_par_ids[i]);
						}
					 }
				}
				else if('#attributes.function_row_name#'=='workcube_cc2_delRow')
				{
					if(window.opener.document.all.cc2_par_ids.length==undefined)
					 {
						window.opener.document.upd_work.appendChild(window.opener.document.getElementById("cc2_comp_ids"));
						window.opener.document.upd_work.appendChild(window.opener.document.getElementById("cc2_par_ids"));
					 }
					 else
					 {
						for(var i=0;i<window.opener.document.all.cc2_par_ids.length;i++)
						{
							window.opener.document.upd_work.appendChild(window.opener.document.all.cc2_comp_ids[i]);
							window.opener.document.upd_work.appendChild(window.opener.document.all.cc2_par_ids[i]);
						}
					}
				}
				else
				{
					if(window.opener.document.all.to_par_ids.length==undefined)
					 {
						window.opener.document.upd_work.appendChild(window.opener.document.getElementById("to_comp_ids"));
						window.opener.document.upd_work.appendChild(window.opener.document.getElementById("to_par_ids"));
					 }
					 else
					 {
						for(var i=0;i<window.opener.document.all.to_par_ids.length;i++)
						{
							window.opener.document.upd_work.appendChild(window.opener.document.all.to_comp_ids[i]);
							window.opener.document.upd_work.appendChild(window.opener.document.all.to_par_ids[i]);
						}
					 }
				}
			</cfoutput>
		}
		</cfif>
	</script>
</cfif>

<cfset url_string = ''>
<cfif isdefined("attributes.url_params") and Len(attributes.url_params)>
	<cfloop list="#attributes.url_params#" index="urlparam">
		<cfset url_string = "#url_string#&#urlparam#=#evaluate('attributes.'&urlparam)#">
	</cfloop>
</cfif>
<cfif len(attributes.select_list)>
	<cfset url_string = '#url_string#&select_list=#attributes.select_list#'>
</cfif>
<cfif isDefined('attributes.table_name') and len(attributes.table_name)>
	<cfset url_string = '#url_string#&table_name=#attributes.table_name#'>
</cfif>
<cfif isDefined('attributes.table_row_name') and len(attributes.table_row_name)>
	<cfset url_string = '#url_string#&table_row_name=#attributes.table_row_name#'>
</cfif>
<cfif isDefined('attributes.field_grp_id') and len(attributes.field_grp_id)>
	<cfset url_string = '#url_string#&field_grp_id=#attributes.field_grp_id#'>
</cfif>
<cfif isdefined('attributes.field_wgrp_id') and len(attributes.field_wgrp_id)>
	<cfset url_string = '#url_string#&field_wgrp_id=#attributes.field_wgrp_id#'>
</cfif>
<cfif isdefined('attributes.function_row_name') and len(attributes.function_row_name)>
	<cfset url_string = '#url_string#&function_row_name=#attributes.function_row_name#'>
</cfif>
<cfif isdefined('attributes.row_count') and len(attributes.row_count)>
	<cfset url_string = '#url_string#&row_count=#attributes.row_count#'>
</cfif>
<cfif isdefined('attributes.url_direction') and len(attributes.url_direction)>
	<cfset url_string = '#url_string#&url_direction=#attributes.url_direction#'>
</cfif>
<cfif isdefined('attributes.field_address') and len(attributes.field_address)>
	<cfset url_string = '#url_string#&field_address=#attributes.field_address#'>
</cfif>
<cfif isdefined('attributes.field_company_id') and len(attributes.field_company_id)>
	<cfset url_string = '#url_string#&field_company_id=#attributes.field_company_id#'>
</cfif>
<cfif isdefined('attributes.field_par_id') and len(attributes.field_par_id)>
	<cfset url_string = '#url_string#&field_par_id=#attributes.field_par_id#'>
</cfif>
<cfif isdefined('attributes.field_cons_id') and len(attributes.field_cons_id)>
	<cfset url_string = '#url_string#&field_cons_id=#attributes.field_cons_id#'>
</cfif>
<cfif ListFind(attributes.select_list,9) and isDefined('session.pp.userid')>
	<cfset url_string = '#url_string#&comp_id_list=#session.pp.company_id#'>
    <cfset url_string = '#url_string#&related_comp_id=1'>
</cfif> 
<table cellspacing="1" cellpadding="2" border="0" align="center" class="color-border" style="width:100%">
	<tr class="color-row">
		<cfoutput> 
            <td>&nbsp;</td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=A">A</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=B">B</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=C">C</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ç">Ç</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=D">D</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=E">E</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=F">F</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=G">G</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ğ">Ğ</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=H">H</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=I">I</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=İ">İ</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=J">J</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=K">K</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=L">L</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=M">M</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=N">N</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=O">O</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ö">Ö</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=P">P</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Q">Q</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=R">R</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=S">S</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ş">Ş</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=T">T</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=U">U</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ü">Ü</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=V">V</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=W">W</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Y">Y</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Z">Z</a></td>
            <td>&nbsp;</td>
        </cfoutput>
	</tr>
</table>

<cfform name="search_par" action="#request.self#?fuseaction=#attributes.fuseaction##url_string#" method="post"> 
	<input type="hidden" name="form_submit" id="form_submit" value="1">
    <table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
        <tr>
            <td class="headbold">
                <cfoutput>
                    <select name="categories" id="categories" onchange="location.href=this.value;">
						<cfif ListFind(attributes.select_list,1)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_positions_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_positions_multiuser'>selected</cfif>><cf_get_lang_main no='1463.Çalışanlar'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,2)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pars_multiuser'>selected</cfif>>C. <cf_get_lang_main no='1611.Kurumsal Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,3)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_cons_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_cons_multiuser'>selected</cfif>>C. <cf_get_lang_main no='1609.Bireysel Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,4)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_grps_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_grps_multiuser'>selected</cfif>><cf_get_lang no='326.Gruplar'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,5)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pot_cons_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pot_cons_multiuser'>selected</cfif>>P <cf_get_lang_main no='1609.Bireysel Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,6)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pot_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pot_pars_multiuser'>selected</cfif>>P <cf_get_lang_main no='1611.Kurumsal Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,7)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_all_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_all_pars_multiuser'>selected</cfif>><cf_get_lang_main no='1611.Kurumsal Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,8)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_all_cons_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_all_cons_multiuser'>selected</cfif>><cf_get_lang_main no='1609.Bireysel Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,9)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pars_multiuser'>selected</cfif>><cf_get_lang no='281.Kurumsal Üyemin Çalışanları'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,10)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_my_pars#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_my_pars'>selected</cfif>>Kurumsal Üyelerim</option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,11)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_my_cons#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_my_cons'>selected</cfif>>Bireysel Üyelerim</option>
                        </cfif>
                    </select>
                </cfoutput>
            </td>
            <td class="headbold">
                <table align="right">
                    <tr>
                        <td>
                            <cf_get_lang_main no='1173.Kod'> ve <cf_get_lang_main no='162.Şirket'>
                            <input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="255" style="width:120px;">
                        </td>
                        <td>
                            <cf_get_lang_main no='58.Filtre'>
                            <input type="text" name="keyword_partner" id="keyword_partner" value="<cfoutput>#attributes.keyword_partner#</cfoutput>" maxlength="255" style="width:120px;">
                        </td>	  
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button></td>
                        <td><a href="javascript:history.go(-1);"><img src="/images/back.gif" title="<cf_get_lang_main no='20.Geri'>" border="0"></a></td>		  
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        	<td class="headbold" colspan="2">
            	<table align="right">
                    <tr>
                        <td>
                            <select name="companycat" id="companycat" style="width:150px;" tabindex="23">
                                <option value=""><cf_get_lang_main no='1535.Kategori'></option>
                                <cfoutput query="get_companycat">
                                    <option value="#companycat_id#" <cfif attributes.companycat eq companycat_id>selected</cfif>>#companycat#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="company_sector" id="company_sector" tabindex="25" style="width:150px;">
                                <option value=""><cf_get_lang_main no='167.Sektör'>               
                                <cfoutput query="get_company_sector">
                                    <option value="#sector_cat_id#" <cfif attributes.company_sector eq sector_cat_id>selected</cfif>>#sector_cat#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="sales_county" id="sales_county" style="width:130px;" tabindex="27">
                                <option value=""><cf_get_lang_main no='247.Satış Bölgesi'></option>
                                <cfoutput query="sz">
                                    <option value="#sz_id#" <cfif sz_id eq attributes.sales_county>selected</cfif>>#sz_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="customer_value" id="customer_value" style="width:120px;">
                                <option value=""><cf_get_lang_main no='1140.Müşteri Değeri'></option>
                                <cfoutput query="get_customer_value">
                                    <option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value>selected</cfif>>#customer_value#</option>
                                </cfoutput>
                            </select>
                            <!---<cfif xml_related_comp_id eq 1>
                                <cf_get_lang no='58.İlişkili Üyeler'><input type="checkbox" name="related_comp_id" id="related_comp_id" value="1" <cfif attributes.related_comp_id eq 1>checked</cfif>>
                            </cfif>--->
                            <input type="hidden" name="comp_id_list" id="comp_id_list" value="<cfif isDefined('attributes.comp_id_list') and len(attributes.comp_id_list)><cfoutput>#attributes.comp_id_list#</cfoutput></cfif>" />
                            <input type="hidden" name="related_comp_id" id="related_comp_id" value="<cfif isDefined('attributes.related_comp_id') and len(attributes.related_comp_id)><cfoutput>#attributes.related_comp_id#</cfoutput></cfif>" />
                        </td>		  	  
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>

<table cellspacing="1" cellpadding="2" class="color-border" align="center" style="width:98%">	
    <tr class="color-header" style="height:22px;"> 
        <th class="form-title" style="width:25px;"></th>
        <th class="form-title" style="width:40px;"><cf_get_lang_main no='75.No'></th>
        <th class="form-title" style="width:230px;"><cf_get_lang_main no='162.Şirket'></th>
        <th class="form-title"><cf_get_lang_main no='158.Ad Soyad'></th>
        <th class="form-title" style="width:100px;"><cf_get_lang_main no='74.kategorisi'></th>
        <th class="form-title" style="width:80px;"><cf_get_lang_main no='159.ünvan'></th>
        <cfif attributes.fuseaction contains 'multiuser'>
            <th class="form-title" style="width:15px;">
                <cfif get_partners.recordcount>
                    <input type="Checkbox" name="all" id="all" value="1" onclick="javascript: hepsi();">
                </cfif>
            </th>
        </cfif>
    </tr>

	<!--- <cfif isdefined("attributes.form_submit")> --->
    <form action="" method="post" name="form_name">
		<cfif get_partners.recordcount>
			<cfoutput query="get_partners" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                <tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
                    <td align="center"><cf_online id="#partner_id#" zone="pp"></td>
                    <td>#member_code#</td>
                    <td>
                    	<cfif attributes.fuseaction contains 'multiuser'>
							<cfset cont="#company_address# #company_postcode# #county# #city#">
                            <cfset rm = '#chr(13)#'>
                            <cfset cont = ReplaceList(cont,rm,'')>
                            <cfset rm = '#chr(10)#'>
                            <cfset cont = ReplaceList(cont,rm,'')>			  
                            #fullname#
                        <cfelse>
                        	<a href="javascript://" onclick="load_member('#partner_id#','#company_id#','#fullname# || #company_partner_name# #company_partner_surname#');" class="tableyazi">#fullname#</a>
                        </cfif>
                    </td>
                    <td>#company_partner_name# #company_partner_surname#</td>
                    <td>#companycat#</td>
                    <td>#title#</td>
                    <cfif attributes.fuseaction contains 'multiuser'>
                        <td>
                            <input type="checkbox" name="par_ids" id="par_ids" value="#partner_id#">
                            <input type="hidden" name="company_partner_name" id="company_partner_name" value="#company_partner_name#">
                            <input type="hidden" name="company_partner_surname" id="company_partner_surname" value="#company_partner_surname#">
                            <input type="hidden" name="company_id" id="company_id" value="#company_id#">
                            <input type="hidden" name="fullname" id="fullname" value="#fullname#">
                            <input type="hidden" name="cont" id="cont" value="#cont#">
                        </td>
                    </cfif>
                </tr>
            </cfoutput>
            <cfif attributes.fuseaction contains 'multiuser'>
                <tr class="color-list">
                    <td style="text-align:right;" colspan="8"><input type="button" value="<cf_get_lang_main no='49.Kaydet'>" onclick="add_checked();"></td>
                </tr>				
            </cfif>
            <input type="hidden" name="member_type" id="member_type" value="partner">
            <input type="hidden" name="url_string" id="url_string" value="<cfoutput>#url_string#</cfoutput>">					        
        <cfelse>
            <tr class="color-row" style="height:20px;">
                <td colspan="8"><cfif isdefined("attributes.form_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
            </tr>
        </cfif>
    </form>
</table>

<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.keyword_partner") and len(attributes.keyword_partner)>
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

<cfif isdefined("attributes.form_submit") and attributes.totalrecords gt attributes.maxrows>
	<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:99%; height:35px;">
		<tr> 
			<td>
            	<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#attributes.fuseaction##url_string#&form_submit=1">
			</td>
			<!-- sil -->
			<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
		</tr>
	</table>
</cfif>


<script type="text/javascript">
	<cfif isdefined("attributes.form_submit")>
		function hepsi()
		{
			if (document.getElementById('all').checked)
			{			
				<cfif get_partners.recordcount gt 1 and attributes.maxrows gt 1>	
					for(i=0;i<document.form_name.par_ids.length;i++) document.form_name.par_ids[i].checked = true;
				<cfelseif get_partners.recordcount eq 1 or attributes.maxrows eq 1>
					document.getElementById('par_ids').checked = true;
				</cfif>
			}
			else
			{
				<cfif get_partners.recordcount gt 1 and attributes.maxrows gt 1>	
					for(i=0;i<document.form_name.par_ids.length;i++) document.form_name.par_ids[i].checked = false;
				<cfelseif get_partners.recordcount eq 1>
					document.getElementById('par_ids').checked = false;
				</cfif>
			}
		}
	</cfif>
	<cfif not attributes.fuseaction contains 'multiuser'>
		function load_member(parid, compid, compname)
		{
			rowCount = 1;
			if(opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value == 1) 
			{
				var my_element = opener.document.getElementById('workcube_to_row1');
				my_element.parentNode.removeChild(my_element);
			}
			var ss_int = ekle_str(compname,compid,parid);
			opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value = 1;
			window.close();
		}
	</cfif>
	document.getElementById('keyword').focus();
</script>
