<!--- 
İki tip kullanımı vardır.
-------------------------
1.
Açan penceredeki istenen alana seçilenleri kaydeder !
	to_title: hangi baslik atilacak custom tag icin kullanilir bu
	field_id: 			consumer_id
	field_name:			consumer adı ve soyadı
	field_comp_name:	consumer 'ın şirket full adı
	field_address:		consumer 'ın iş adresi
	field_type:			"consumer"
örnek kullanım :
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_cons_multiuser&field_id=form1.aaa&field_name=form1.bbb&field_comp_id=form1.aaa&field_comp_name=form1.aaa&field_name=form1.aaa&camp_id=2&select_list=2,1,3,4,5,6','list');"> Gidecekler </a>
2.
Açan penceredeki ilgili listeye yeni kişi eklemek için kullanılır ! Url_direction da belirtilen fuseaction'a başta con_id ler olmak üzere hidden inputları gönderir.
	url_direction: 		Submit edilecek yer.. bu adrese url_params eklenecek ve bunun içinde fuseaction hariç diğer url parametrelerinin ismi yazacak virgülle ayrılmış vaziyette
						(Örnek: campaign.emptypopup_add_list&cmp_id=111&asd_id=222&url_params=cmp_id,asd_id)
örnek kullanım :
	<cfset url_direction = 'campaign.emptypopup_add_list&cmp_id=111&asd_id=222&url_params=cmp_id,asd_id'>
	<a href="//" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons_multiuser&url_direction=#url_direction#</cfoutput>','list')"> <img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='170.Ekle'>" align="center" border="0"> </a>
	Submit edilen con_id input'unun ismi attributes.con_ids dir ve içinde virgülle ayrılmış bir liste olarak kişileri tutmaktadır. 
	Ayrıca eğer select_list içinde birden fazla numara varsa o zaman submit edilen değerlerin hangisine ait olduğu hidden input "member_type" ile belirlenir.
	Submit edilen input'lar:
		<input type="checkbox" value="#consumer_id#" name="con_ids">
		<input type="hidden" name="consumer_name" value="#consumer_name#">
		<input type="hidden" name="consumer_surname" value="#consumer_surname#">
		<input type="hidden" name="company" value="#company#">
		<input type="hidden" name="stradres" value="#stradres#">
		<input type="hidden" name="member_type" value="consumer">
	Revizyon:09012003 Arzu BT
	id bilgileriniğ forma gonderirken asagidaki yapida gonderecektir.orn:employee icin emp-employee_id ile birlestirerek.
	EMP-id  employeer icin
	PAR-id partner id icin 
	POS-id position_id icin(employeer position)
	CON-id consumer id icin
	GRP-id group id icin 
	WRK-id	bu yok sanirsam	
--->
<cfif fusebox.fuseaction contains "popup_list_all_cons">
	<cfparam name="attributes.type" default="">
<cfelseif fusebox.fuseaction contains "popup_list_pot_cons">
	<cfparam name="attributes.type" default="1">
<cfelse>
	<cfparam name="attributes.type" default="0">
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined("attributes.form_submit")>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfinclude template="../query/get_consumers.cfm">
    <cfparam name="attributes.totalrecords" default='#get_consumers.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
	<cfset get_consumers.recordcount="0">
</cfif>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME FROM SETUP_CITY
</cfquery>
<cfquery name="GET_COUNTY" datasource="#DSN#">
	SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY 
</cfquery>
<cfif isdefined("attributes.form_submit")>
<script type="text/javascript">
<cfif isdefined("attributes.to_title") and len(attributes.to_title)>to_title = <cfoutput>#attributes.to_title#</cfoutput>;<cfelse>to_title=1;</cfif>
function add_checked()
{
	<cfif isdefined("attributes.row_count")>
		rowCount = parseInt(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.<cfoutput>#attributes.row_count#</cfoutput>.value);
	</cfif>
	var counter = 0;
	<cfif get_consumers.recordcount gt 1 and attributes.maxrows neq 1>	
	for(i=0;i<form_name.con_ids.length;i++) 
		if (form_name.con_ids[i].checked == true)
		{
			counter = counter + 1;
		}
	if (counter == 0)
	{
		alert('<cf_get_lang dictionary_id="33181.Kişi seçmelisiniz"> !');
		return false;
	}
	<cfelseif get_consumers.recordcount eq 1 or  attributes.maxrows eq 1>
	if (form_name.con_ids.checked == true)
	{
		counter = counter + 1;
		con_ids_ =  form_name.con_ids.value;
	}
	if (counter == 0)
	{
		alert('<cf_get_lang dictionary_id="33181.Kişi seçmelisiniz"> !');
		return false;
	}
	</cfif>

	<cfif isdefined("attributes.order_employee") and isdefined("attributes.multi")>
		for(i=0;i<form_name.con_ids.length;i++) 
			if (form_name.con_ids[i].checked == true) 
			{
				x = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.length;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.length = parseInt(x + 1);
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.options[x].value = 'c - '+form_name.con_ids[i].value;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.order_employee#</cfoutput>.options[x].text = form_name.consumer_name[i].value+' '+form_name.consumer_surname[i].value;;
			}
	</cfif>
	<cfif get_consumers.recordcount gt 1 and isdefined("attributes.field_cons_id") and attributes.maxrows neq 1>	
		counter = 0;
		for(i=0;i<form_name.con_ids.length;i++)
		{
			if (form_name.con_ids[i].checked == true)
			{
				counter = counter + 1;
				var con_id = form_name.con_ids[i].value;
				var con_name = form_name.consumer_name[i].value+' '+form_name.consumer_surname[i].value;				
				rowCount = rowCount + 1;
				var ss_int=ekle_str(con_name,con_id);
			}
		}
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.<cfoutput>#attributes.row_count#</cfoutput>.value = rowCount;
	<cfelseif (get_consumers.recordcount eq 1 or  attributes.maxrows eq 1 ) and isdefined("attributes.field_cons_id")>
		var con_ids = form_name.con_ids.value;
		var con_name = form_name.consumer_name.value+' '+form_name.consumer_surname.value;
		rowCount = rowCount + 1;
		var ss_int=ekle_str(con_name,con_ids);
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.<cfoutput>#attributes.row_count#</cfoutput>.value = rowCount;
	</cfif>
	<cfif get_consumers.recordcount gt 1 and isdefined("attributes.field_address") and attributes.maxrows neq 1>	
		counter = 0;
		for(i=0;i<form_name.con_ids.length;i++) 
			if (form_name.con_ids[i].checked == true)
			{
				counter = counter + 1;
				var address = form_name.stradres[i].value;
				if (counter == 1)
				{
					var addresses = address;
				}
				else
				{
					var addresses = addresses + ',' + address;
				}
			}
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_address#</cfoutput>.value = addresses;
		<cfelseif (get_consumers.recordcount eq 1  or  attributes.maxrows eq 1 ) and isdefined("attributes.field_address")>
			var addresses = form_name.stradres.value;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_address#</cfoutput>.value = addresses;
		</cfif>
		
	<cfif isdefined("attributes.field_type")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_type#</cfoutput>.value = "consumer";
	</cfif>
	<cfif isDefined("attributes.url_direction")>
		<cfoutput>
			document.form_name.action='#request.self#?fuseaction=#attributes.url_direction#&'+form_name.url_string.value;
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
			function ekle_str(str_ekle,int_id)
			{
				var newRow;
				var newCell;
				<cfoutput>
					newRow = <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.#attributes.table_name#.insertRow();
					newRow.setAttribute("name","#attributes.table_row_name#" + rowCount);
					newRow.setAttribute("id","#attributes.table_row_name#" + rowCount);		
					newRow.setAttribute("style","display:''");	
					newCell = newRow.insertCell(newRow.cells.length);
					str_html = '';
					
					<cfif isdefined("attributes.field_cons_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_cons_id#" id="#attributes.field_cons_id#" value="' + int_id + '">'
					</cfif>
					str_html = str_html +'<input type="hidden" name="#attributes.field_grp_id#" value=""><input type="hidden" name="#attributes.field_wgrp_id#" value="">';
					str_del='<a href="javascript://" onClick="#attributes.function_row_name#(' + rowCount +','+int_id+');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;';	
					newCell.innerHTML = str_del + str_html + str_ekle  ;
				</cfoutput>
				return 1;
			}
		</cfif>	
	</script>
</cfif>
<cfparam name="select_list" default="1,2,3,4,5,6,7,8">
<cfscript>
	url_string = "";
	if (isdefined('attributes.field_basket_due_value')) url_string = '#url_string#&field_basket_due_value=#field_basket_due_value#';	
	if (isdefined('attributes.field_paymethod_id')) url_string = '#url_string#&field_paymethod_id=#field_paymethod_id#';
	if (isdefined('attributes.field_paymethod')) url_string = '#url_string#&field_paymethod=#field_paymethod#';
	if (isdefined("attributes.function_row_name")) url_string = "#url_string#&function_row_name=#function_row_name#";
	if (isdefined("attributes.field_comp_name")) url_string = "#url_string#&field_comp_name=#field_comp_name#";
	if (isdefined('attributes.action_name')) url_string = '#url_string#&action_name=#action_name#';
	if (isdefined('attributes.action_id')) url_string = '#url_string#&action_id=#action_id#';
	if (isdefined('attributes.sub_url')) url_string = '#url_string#&sub_url=#sub_url#';
	if (isdefined('attributes.sub_url_id')) url_string = '#url_string#&sub_url_id=#sub_url_id#';
	if (isdefined('attributes.field_id')) url_string = '#url_string#&field_id=#field_id#';
	if (isdefined('attributes.to_title')) url_string = '#url_string#&to_title=#to_title#';
	if (isdefined('attributes.field_partner_id')) url_string = '#url_string#&field_partner_id=#field_partner_id#';
	if (isdefined('attributes.field_company_id')) url_string = '#url_string#&field_company_id=#field_company_id#';
	if (isdefined('attributes.field_consumer_id')) url_string = '#url_string#&field_consumer_id=#field_consumer_id#';
	if (isdefined('attributes.field_position_id')) url_string = '#url_string#&field_position_id=#field_position_id#';
	if (isdefined('attributes.field_employee_id')) url_string = '#url_string#&field_employee_id=#field_employee_id#';
	if (isdefined('attributes.field_pos_code')) url_string = '#url_string#&field_pos_code=#field_pos_code#';
	if (isdefined("attributes.field_type")) url_string = "#url_string#&field_type=#field_type#";
	if (isdefined("attributes.field_name")) url_string = "#url_string#&field_name=#field_name#";
	if (isdefined("attributes.field_cons_id")) url_string = "#url_string#&field_cons_id=#field_cons_id#";
	if (isdefined("attributes.field_par_id")) url_string = "#url_string#&field_par_id=#field_par_id#";
	if (isdefined("attributes.field_comp_id")) url_string = "#url_string#&field_comp_id=#field_comp_id#";
	if (isdefined("attributes.field_emp_id")) url_string = "#url_string#&field_emp_id=#field_emp_id#";
	if (isdefined("attributes.field_pos_id")) url_string = "#url_string#&field_pos_id=#field_pos_id#";
	if (isdefined("attributes.field_wgrp_id")) url_string = "#url_string#&field_wgrp_id=#field_wgrp_id#";
	if (isdefined("attributes.field_grp_id")) url_string = "#url_string#&field_grp_id=#field_grp_id#";		
	if (isdefined("attributes.table_name")) url_string = "#url_string#&table_name=#table_name#";
	if (isdefined("attributes.table_row_name")) url_string = "#url_string#&table_row_name=#table_row_name#";
	if (isdefined("attributes.row_count")) url_string = "#url_string#&row_count=#row_count#";	
	if (isdefined('attributes.select_list')) url_string = '#url_string#&select_list=#select_list#';
	if (isdefined("attributes.url_direction")) url_string = "#url_string#&url_direction=#url_direction#";
	if (isdefined("attributes.field_address")) url_string = "#url_string#&field_address=#attributes.field_address#";
	if (isdefined("attributes.url_params")) url_string = "#url_string#&url_params=#attributes.url_params#";
	if (isdefined("attributes.is_branch_control")) url_string = "#url_string#&is_branch_control=1";
	if (isdefined("attributes.order_employee")) url_string = "#url_string#&order_employee=#order_employee#";
	if (isdefined("attributes.multi")) url_string = "#url_string#&multi=#multi#";
</cfscript>
<cfif IsDefined("attributes.url_params") and Len(attributes.url_params)>
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
				<select name="categories" id="categories" onchange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>">
					<cfif ListFind(select_list,1)>
						<cfif isdefined('session.ep.userid')>
							<option value="#request.self#?fuseaction=objects.popup_list_positions_multiuser#url_string#"><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
						<cfelse>
							<option value="#request.self#?fuseaction=objects2.popup_list_positions_multiuser#url_string#"><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
						</cfif>
					</cfif>
					<cfif ListFind(select_list,2)>
						<option value="#request.self#?fuseaction=objects.popup_list_pars_multiuser#url_string#"><cf_get_lang dictionary_id='32995.C Kurumsal Üyeler'></option>
					</cfif>
					<cfif ListFind(select_list,3)>
						<option value="#request.self#?fuseaction=objects.popup_list_cons_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_cons_multiuser"> selected</cfif>><cf_get_lang dictionary_id='32996.C Bireysel Üyeler'></option>
					</cfif>
					<cfif ListFind(select_list,4)>
						<option value="#request.self#?fuseaction=objects.popup_list_grps_multiuser#url_string#"><cf_get_lang dictionary_id='32716.Gruplar'></option>
					</cfif>
					<cfif ListFind(select_list,5)>
						<cfif isdefined('session.ep.userid')>
							<option value="#request.self#?fuseaction=objects.popup_list_pot_cons_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_pot_cons_multiuser"> selected</cfif>>P <cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
						<cfelse>
							<option value="#request.self#?fuseaction=objects2.popup_list_pot_cons_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_pot_cons_multiuser"> selected</cfif>>P <cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>		
						</cfif>
					</cfif>
					<cfif ListFind(select_list,6)>
						<cfif isdefined('session.ep.userid')>
							<option value="#request.self#?fuseaction=objects.popup_list_pot_pars_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_pot_pars_multiuser"> selected</cfif>>P <cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
						<cfelse>
							<option value="#request.self#?fuseaction=objects2.popup_list_pot_pars_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_pot_pars_multiuser"> selected</cfif>>P <cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
						</cfif>
					</cfif>
					<cfif ListFind(select_list,7)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_pars_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_all_pars_multiuser"> selected</cfif>><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
					</cfif>
					<cfif ListFind(select_list,8)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_cons_multiuser#url_string#"<cfif fusebox.fuseaction is "popup_list_all_cons_multiuser"> selected</cfif>><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
					</cfif>
				</select>
			</div>
		</div>
	</cfoutput>
</cfsavecontent>

<cf_box title="#getLang('','Bireysel Üyeler',29406)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_con" action="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#" method="post">
		<input type="hidden" name="form_submit" id="form_submit" value="1">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_search more="0">
			<div class="form-group" id="keyword">
				<cfinput type="text" maxlength="255" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" name="keyword">
				<cfinclude template="../../member/query/get_consumer_cat.cfm">
			</div>		
			<div class="form-group" id="item-consumer_cat">
				<select name="consumer_cat" id="consumer_cat" >
					<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
					<cfoutput query="get_consumer_cat">
						<option value="#get_consumer_cat.CONSCAT_ID#" <cfif isdefined("attributes.consumer_cat") and attributes.consumer_cat eq get_consumer_cat.CONSCAT_ID>selected</cfif>>#get_consumer_cat.CONSCAT#</option>
					</cfoutput>
				</select>
			</div>	
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>	
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_con' , #attributes.modal_id#)"),DE(""))#">
			</div> 
			<div class="form-group">
				<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#?fuseaction=member.consumer_list&event=add&isModule=objects#url_string#</cfoutput>" target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='29407.Bireysel Üye Ekle'>"></i></a>
			</div> 
			<div class="form-group">
				<a class="ui-btn ui-btn-gray2" href="javascript:history.go(-1);"><i class="fa fa-arrow-left" title="<cf_get_lang dictionary_id='57432.Geri'>"></i></a>
			</div> 
		</cf_box_search>
	</cfform>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
	<cfif isdefined("attributes.consumer_cat") and len(attributes.consumer_cat)>
		<cfset url_string = "#url_string#&consumer_cat=#attributes.consumer_cat#">
	</cfif>
	<tbody><cfoutput>#head_#</cfoutput></tbody>
	<form action="" method="post" name="form_name">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cfif get_consumers.recordcount><input type="Checkbox" id="all" name="all" value="1" onclick="javascript: hepsi();"></cfif></th>
					<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='57486.kategori'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<!--- <cfif isdefined("attributes.form_submit")> --->
				<cfif get_consumers.recordcount>
					<cfoutput query="get_consumers">
						<tr>
							<td width="20">
								<input type="checkbox" value="#consumer_id#" name="con_ids" id="con_ids">
							</td>
							<td>#consumer_id#</td>
							<td>
								<cfif len(work_city_id)>
									<cfquery name="GET_CITY_NAME" dbtype="query">
										SELECT CITY_NAME FROM GET_CITY WHERE CITY_ID = #work_city_id#
									</cfquery>
									<cfset value_city_name = get_city_name.city_name>
								<cfelse>
									<cfset value_city_name = ''>	
								</cfif>
								<cfif len(work_county_id)>
									<cfquery name="GET_COUNTY_NAME" dbtype="query">
										SELECT COUNTY_NAME FROM GET_COUNTY WHERE COUNTY_ID = #work_county_id#
									</cfquery>
									<cfset value_county_name = get_county_name.county_name>
								<cfelse>
									<cfset value_county_name = ''>
								</cfif>
								<cfset stradres="#workaddress# #workpostcode# #value_county_name# #value_city_name#">
								<cfset stradres = Replace(stradres,Chr(13)," ","ALL")>
								<cfset stradres = Replace(stradres,Chr(10)," ","ALL")>
								<!--- <a href="javascript://" onClick="add_user('#consumer_id#','#consumer_name# #consumer_surname#','#company#','#stradres#')" class="tableyazi">  --->
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium')">#consumer_name# #consumer_surname#</a>
								<!--- </a> --->
							</td>
							<td>#conscat#</td>
							<td>#company#</td>
							<td>
								<input type="hidden" name="consumer_name" id="consumer_name" value="#consumer_name#">
								<input type="hidden" name="consumer_surname" id="consumer_surname" value="#consumer_surname#">
								<input type="hidden" name="company" id="company" value="#company#">
								<input type="hidden" name="stradres" id="stradres" value="#stradres#">
							</td>
						</tr>
					</tbody>
					</cfoutput>
					<cfelse>
						<tbody>
							<tr>
								<td height="20" colspan="7"><cfif isdefined("attributes.form_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
							</tr>
						</tbody>
					</cfif>
					<cfif get_consumers.recordcount>
						<tr>
							<td colspan="7">
								
									<div class="ui-info-bottom  flex-end">
										<div><a class="ui-btn ui-btn-success" href="javascript://" onclick="add_checked()"><cf_get_lang dictionary_id='57461.Kaydet'></a></div>
									</div>
								
							</td>
						</tr>	
					</cfif> 
					<input type="hidden" name="member_type" id="member_type" value="consumer">
					<input type="hidden" name="url_string" id="url_string" value="<cfoutput>#url_string#</cfoutput>">				
		</cf_grid_list>
	</form>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="objects.#fusebox.fuseaction##url_string#&form_submit=1" isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<cfif isdefined("attributes.form_submit")>
	<script type="text/javascript">
	function hepsi()
	{
		if (document.getElementById('all').checked)
		{
		<cfif get_consumers.recordcount gt 1 and attributes.maxrows neq 1>	
			for(i=0;i<form_name.con_ids.length;i++) form_name.con_ids[i].checked = true;
		<cfelseif get_consumers.recordcount eq 1  or  attributes.maxrows eq 1>
			form_name.con_ids.checked = true;
		</cfif>
		}
		else
		{
		<cfif get_consumers.recordcount gt 1 and attributes.maxrows neq 1>	
			for(i=0;i<form_name.con_ids.length;i++) form_name.con_ids[i].checked = false;
		<cfelseif get_consumers.recordcount eq 1  or  attributes.maxrows eq 1>
			form_name.con_ids.checked = false;
		</cfif>
		}
	}
	</script>
</cfif>
