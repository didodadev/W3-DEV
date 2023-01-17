<meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="css/assets/template/w3-employee-snapshots/style.css?57">
<meta charset="UTF-8">

<!--- INSTANT MESSAGE 1-2 ICON ve ENTEGRASYONU Linki | MG 20101130 --->
<!---<cfscript>
	function IMsgIcon()
	{
		ImSayisi = 2;
		for (Sayac = 1; Sayac <= ImSayisi; Sayac++)
		{
			stil = "style=""cursor: hand;""";
			if (Sayac == 1)
				Say = "";
			else
				Say = Sayac;
			if (Len(Evaluate("IMCAT#Say#_ICON")))
			{
				"Im#Say#Address" = Evaluate("IM#Say#");
				"Link#Say#Type" = Evaluate("IMCAT#Say#_LINK_TYPE");
			}
			else
			{
				"Im#Say#Address" = "Bu Instant Mesajın kategorisi bulunamadı, lütfen IM Bilgilerinizi güncelleyiniz.";
				"IMCAT#Say#_ICON" = "icons_invalid.gif";
				"Link#Say#Type" = "";
			}
			"Link#Say#" = Evaluate("Link#Say#Type") & Evaluate("Im#Say#Address");
			if (Evaluate("Link#Say#Type") == "")
			{
				"Link#Say#" = "##";
				stil = "";
			}
			if (Len(Evaluate("IMCAT#Say#_ID")))
				WriteOutput(" <img onclick=""javascript:location.href='" & Evaluate("Link#Say#") & "';"" src=""/documents/settings/#Evaluate("IMCAT#Say#_ICON")#"" border=""0"" " & stil & " alt=""" & Evaluate("Im#Say#Address") & """>");
		}
	}
</cfscript>--->
<cfparam name="attributes.form_submitted" default="">
<cfinclude template="../query/get_position_cats.cfm">
<cfquery name="TITLES" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.department_id" default="0">
<cfif isdefined("attributes.keyword")>
	<cfset filtered = 1>	
<cfelse>
	<cfset filtered = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.title_id" default="">
<cfset url_str = "">
<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
<cfif len(attributes.hierarchy)>
	<cfset url_str = "#url_str#&hierarchy=#attributes.hierarchy#">
</cfif>
<cfif len(attributes.position_cat_id)>
	<cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
</cfif>
<cfif len(attributes.title_id)>
	<cfset url_str="#url_str#&title_id=#attributes.title_id#">
</cfif>
<cfif isdefined("attributes.branch_id")>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	<cfset attributes.id = attributes.branch_id>
</cfif>

<cfif isdefined("attributes.emp_status") and len(attributes.emp_status)>
	<cfset url_str = "#url_str#&emp_status=#attributes.emp_status#">
</cfif>
<cfinclude template="../query/get_our_comp_and_branchs.cfm">
<cfparam name="attributes.totalrecords" default='0'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif filtered eq 1>
	<cfinclude template="../query/get_hrs.cfm">
	<cfset attributes.totalrecords = get_hrs.recordcount>
<cfelse>
	<cfset get_hrs.recordcount = 0>
</cfif>
<div class="w3-intranet">
    <div class="container-fluid ">
    <cfinclude template="search.cfm">
    <cfsavecontent variable="kategori"><cf_get_lang_main no='725.Kategoriler'>/<cf_get_lang_main no='727.Bölümler'></cfsavecontent>
    
    <cfinclude template="rule_menu.cfm">
		<div class="w3-ruleWho col-12">

			<div class="col-12 who-header">			
				<h4 class="col-12"><cfoutput>#getLang("myhome",1497,"Kim Kimdir?")#</cfoutput></h4>
			</div>
				
			<div class="col-12 who-search">
				<span class="">
					<i class="wrk-search"></i>
					<div class="search-dropdown col-12 px-0 mt-2">
						<div class="container-fluid">
						<form class="form-control" name="employees" method="post" action="#request.self#?fuseaction=rule.list_hr">
						<input type="hidden" name="form_submitted" id="form_submitted" value="1">
													
								<div class="col-12 s-checkbox">
									<label class="form-check-label" name="emp_status" id="emp_status">
										<input class="form-check-input" type="checkbox" value="1" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 1)>selected</cfif>> <cf_get_lang_main no='81.Aktif'>
									</label>

									<label class="form-check-label" name="emp_status" id="emp_status">
										<input class="form-check-input" type="checkbox" value="-1" <cfif isDefined("attributes.emp_status")and(attributes.emp_status eq -1)>selected</cfif>> <cf_get_lang_main no='82.Pasif'>
									</label>
										<label class="form-check-label" name="emp_status" id="emp_status">
										<input class="form-check-input" type="checkbox" value="0" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 0)>selected</cfif>> <cf_get_lang_main no='296.Tümü'>
									</label>
								</div>
								<div class="row p-2">
									<div class="col-3  pr-0">
										<input class="w-100" type="text" name="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="50" placeholder="Kelime Giriniz">
									</div>
									
								
									<div class="col-3 pr-0">
										<select class="w-100" name="title_id" id="title_id">
											<option value=""><cf_get_lang no ='26.Ünvanlar'></option>
											<cfoutput query="titles">
												<option value="#title_id#" <cfif attributes.title_id eq title_id>selected</cfif>>#title#</option>
											</cfoutput>
										</select>
									</div>
									<div class="col-3 pr-0">
										<select class="w-100" name="position_cat_id" id="position_cat_id">
											<option value=""><cf_get_lang_main no ='367.Pozisyon Tipleri'>
											<cfoutput query="GET_POSITION_CATS">
												<option value="#position_cat_id#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#
											</cfoutput>
										</select>
									</div>
									<div class="col-3">
										<select class="w-100" name="branch_id" id="branch_id">
										<option value=""><cf_get_lang_main no='1637.Şubeler'></option>
											<cfoutput query="get_our_comp_and_branchs">
												<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#branch_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<script type="text/javascript">
									document.employees.keyword.focus();
								</script>

								<div class="col-12 d-flex justify-content-end pr-2">
									<button type="submit" class="btn btn-primary">ARA</button>
								</div>
						
						</form>
					</div>
				</div>
				</span>
			</div>

			







<cfif get_hrs.recordcount>
			<cfparam name="attributes.page" default="1">
			<cfparam name="attributes.totalrecords" default='#get_hrs.recordcount#'>
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>		
			<cfset employee_list = ''>
<!---			<cfset im_cats = ''>--->
			<cfset mobiltel_list = "">
			<cfoutput query="get_hrs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(employee_id) and not ListFind(mobiltel_list,employee_id,',')>
					<cfset mobiltel_list = ListAppend(mobiltel_list,employee_id,',')>
				</cfif>
					<cfset employee_list = listappend(employee_list,get_hrs.employee_id,',')>
<!---				<cfif len(IMCAT_ID)>
					<cfset im_cats = listappend(im_cats,IMCAT_ID)>
				</cfif>
				<cfif len(IMCAT2_ID)>
					<cfset im_cats = listappend(im_cats,IMCAT2_ID)>
				</cfif>--->
			</cfoutput>
<!---			<cfif listlen(im_cats)>
				<cfquery name="get_ims" datasource="#DSN#">
					SELECT IMCAT_ICON,IMCAT_LINK_TYPE,IMCAT_ID FROM SETUP_IM WHERE IMCAT_ID IN (#im_cats#)
				</cfquery>
				<cfset im_cats = listsort(listdeleteduplicates(valuelist(get_ims.IMCAT_ID,',')),'numeric','ASC',',')>
			</cfif>--->
			<cfif ListLen(mobiltel_list)>
				<cfquery name="get_employee_detail" datasource="#dsn#">
					SELECT EMPLOYEE_ID,MOBILCODE_SPC, MOBILTEL_SPC FROM EMPLOYEES_DETAIL WHERE EMPLOYEE_ID IN (#mobiltel_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset mobiltel_list = ListSort(ListDeleteDuplicates(ValueList(get_employee_detail.employee_id,",")),"numeric","asc",",")>
			</cfif>
			<cfquery name="GET_POSITIONS" datasource="#dsn#">
				SELECT
					DEPARTMENT.DEPARTMENT_HEAD,
					EMPLOYEE_POSITIONS.POSITION_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_ID,
					SETUP_POSITION_CAT.POSITION_CAT
				FROM
					EMPLOYEE_POSITIONS,
					DEPARTMENT,
					SETUP_POSITION_CAT
				WHERE
					SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
				AND
					EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
				AND
					EMPLOYEE_POSITIONS.POSITION_STATUS = 1
				AND 
					EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#employee_list#)
			</cfquery>	
				














			<div class="row who-content mt-5">
			<cfoutput query="get_hrs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<cfquery name="get_position" dbtype="query" maxrows="1">
						SELECT DEPARTMENT_HEAD,POSITION_NAME,POSITION_CAT FROM GET_POSITIONS WHERE EMPLOYEE_ID = #employee_id#
					</cfquery>

				<div class="col-2 p-2 ">
					<div class="col-12 who-person">
						<cfif len(PHOTO)>
							<cfset photourl = "/documents/hr/#PHOTO#"> 
						<cfelse>
							<cfset photourl = "/images/no_photo.gif"> 
						</cfif>
						<img src="#photourl#" class="img-fluid col-12 px-0 " alt="Responsive image" style="max-height:215px;">
						<a class="" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#employee_name# #employee_surname#</a>
						<span class="col-12"><cfif get_position.recordcount>#get_position.department_head#<cfelse>-</cfif></span>
						<p class="col-12">"<cfif get_position.recordcount>#get_position.position_name#<cfelse>-</cfif>"</p>
					</div>
				</div>
				</cfoutput>
			</div>
			<cfelse>
			<div class="col-12 person-undefined">
				<cfif filtered><cf_get_lang_main no='1074.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif>
			</div>
        </cfif>


		<!-- PAGİNATİON DESIGN 
		<div class="col-12">
			<nav  class="col-12" page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="rule.list_hr#url_str#">
				<ul class="pagination justify-content-center">
					<li class="page-item">
					<a class="page-link" href="#" tabindex="-1">Previous</a>
					</li>
					
					<li class="page-item">
					<a class="page-link" href="#">Next</a>
					</li>
				</ul>
			</nav>
			<script type="text/javascript">
				document.getElementById('keyword').focus();
			</script>
		</div>
		-->


		</div>
    </div>
</div>


<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="rule.list_hr#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>













<cfform name="employees" method="post" action="#request.self#?fuseaction=rule.list_hr"><input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_big_list_search title="#getLang('rule',8)#">
	<cf_big_list_search_area>
		<table>
			<tr> 
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
				<td> <select name="emp_status" id="emp_status">
						<option value="1" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 1)>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
						<option value="-1" <cfif isDefined("attributes.emp_status")and(attributes.emp_status eq -1)>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
						<option value="0" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 0)>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
					</select>
				</td> 			
				<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
				<td><cf_wrk_search_button> </td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>			
			</tr>       
		</table>
	</cf_big_list_search_area>
<script type="text/javascript">
	document.employees.keyword.focus();
</script>
	<cf_big_list_search_detail_area>
		<table>
			<tr> 
				<td>
					<select name="title_id" id="title_id">
						<option value=""><cf_get_lang no ='26.Ünvanlar'></option>
						<cfoutput query="titles">
							<option value="#title_id#" <cfif attributes.title_id eq title_id>selected</cfif>>#title#</option>
						</cfoutput>
					</select>
					<select name="position_cat_id" id="position_cat_id">
						<option value=""><cf_get_lang_main no ='367.Pozisyon Tipleri'>
						<cfoutput query="GET_POSITION_CATS">
							<option value="#position_cat_id#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#
						</cfoutput>
					</select>			  
					<select name="branch_id" id="branch_id">
					<option value=""><cf_get_lang_main no='1637.Şubeler'></option>
						<cfoutput query="get_our_comp_and_branchs">
							<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
		</table>
	</cf_big_list_search_detail_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr> 
			<!-- sil --><th width="15"></th><!-- sil -->
			<th width="35"><cf_get_lang_main no='1165.Sıra'></th>
			<th><cf_get_lang_main no ='1075.Çalışan No'></th>
			<th><cf_get_lang_main no='158.Ad Soyad'></th>
			<th><cf_get_lang_main no='160.Departman'></th>
			<th><cf_get_lang_main no ='1085.Pozisyon'></th>
			<th><cf_get_lang_main no='70.Aşama'></th>
			<!-- sil --><th class="header_icn_none"><cf_get_lang_main no='731.İletişim'></th><!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_hrs.recordcount>
			<cfparam name="attributes.page" default="1">
			<cfparam name="attributes.totalrecords" default='#get_hrs.recordcount#'>
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>		
			<cfset employee_list = ''>
<!---			<cfset im_cats = ''>--->
			<cfset mobiltel_list = "">
			<cfoutput query="get_hrs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(employee_id) and not ListFind(mobiltel_list,employee_id,',')>
					<cfset mobiltel_list = ListAppend(mobiltel_list,employee_id,',')>
				</cfif>
					<cfset employee_list = listappend(employee_list,get_hrs.employee_id,',')>
<!---				<cfif len(IMCAT_ID)>
					<cfset im_cats = listappend(im_cats,IMCAT_ID)>
				</cfif>
				<cfif len(IMCAT2_ID)>
					<cfset im_cats = listappend(im_cats,IMCAT2_ID)>
				</cfif>--->
			</cfoutput>
<!---			<cfif listlen(im_cats)>
				<cfquery name="get_ims" datasource="#DSN#">
					SELECT IMCAT_ICON,IMCAT_LINK_TYPE,IMCAT_ID FROM SETUP_IM WHERE IMCAT_ID IN (#im_cats#)
				</cfquery>
				<cfset im_cats = listsort(listdeleteduplicates(valuelist(get_ims.IMCAT_ID,',')),'numeric','ASC',',')>
			</cfif>--->
			<cfif ListLen(mobiltel_list)>
				<cfquery name="get_employee_detail" datasource="#dsn#">
					SELECT EMPLOYEE_ID,MOBILCODE_SPC, MOBILTEL_SPC FROM EMPLOYEES_DETAIL WHERE EMPLOYEE_ID IN (#mobiltel_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset mobiltel_list = ListSort(ListDeleteDuplicates(ValueList(get_employee_detail.employee_id,",")),"numeric","asc",",")>
			</cfif>
			<cfquery name="GET_POSITIONS" datasource="#dsn#">
				SELECT
					DEPARTMENT.DEPARTMENT_HEAD,
					EMPLOYEE_POSITIONS.POSITION_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_ID,
					SETUP_POSITION_CAT.POSITION_CAT
				FROM
					EMPLOYEE_POSITIONS,
					DEPARTMENT,
					SETUP_POSITION_CAT
				WHERE
					SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
				AND
					EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
				AND
					EMPLOYEE_POSITIONS.POSITION_STATUS = 1
				AND 
					EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#employee_list#)
			</cfquery>	
				<cfoutput query="get_hrs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<cfquery name="get_position" dbtype="query" maxrows="1">
						SELECT DEPARTMENT_HEAD,POSITION_NAME,POSITION_CAT FROM GET_POSITIONS WHERE EMPLOYEE_ID = #employee_id#
					</cfquery>
					<tr>
						<!-- sil --><td><CF_ONLINE id="#employee_id#" zone="ep"></td><!-- sil -->
						<td>#currentrow#</td>
						<td>#employee_no#</td>
						<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
						<td><cfif get_position.recordcount>#get_position.department_head#<cfelse>-</cfif></td>
						<td><cfif get_position.recordcount>#get_position.position_name#<cfelse>-</cfif></td>
						<td><cfinclude template="../query/get_offtime_emp.cfm">
							<cfif get_offtime.recordcount>#get_offtime.offtimecat#
							<cfelseif (not get_offtime.recordcount) and (employee_status is 1)> <cf_get_lang no='6.Çalışıyor'>
							<cfelse><cf_get_lang_main no='82.Pasif'></cfif>
						</td>
                        <!-- sil -->
						<td nowrap="nowrap">
							<cfif len(employee_email)><a href="mailto:#employee_email#"><img src="/images/mail.gif" title="#employee_email#"></a>&nbsp; </cfif>
							<cfif len(mobilcode) and len(mobiltel)>
							<cfif  session.ep.our_company_info.sms eq 1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=employee&member_id=#employee_id#&sms_action=#fuseaction#','small');"><img src="/images/mobil.gif" title="<cf_get_lang_main no ='1178 .SMS Gönder'>"></a>
							<cfelse>
								<img src="/images/mobil.gif" title="<cf_get_lang_main no ='1178 .SMS Gönder'>">
							</cfif>
							<cfelseif Len(mobiltel_list) and Len(get_employee_detail.mobiltel_spc[ListFind(mobiltel_list,employee_id,',')])>
							<cfif  session.ep.our_company_info.sms eq 1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&is_spc=1&member_type=employee&member_id=#employee_id#&sms_action=#fuseaction#','small');"><img src="/images/mobil.gif" title="<cf_get_lang_main no ='1178 .SMS Gönder'>"></a>
							<cfelse>
								<img src="/images/mobil.gif" title="<cf_get_lang_main no ='1178 .SMS Gönder'>">
							</cfif>
							</cfif>
<!---							<cfif Len(IMCAT_ID)>
								<cfset IMCAT_ICON = get_ims.IMCAT_ICON[listfind(im_cats,IMCAT_ID,',')]>
								<cfset IMCAT_LINK_TYPE = get_ims.IMCAT_LINK_TYPE[listfind(im_cats,IMCAT_ID,',')]>
								<cfelse>
								<cfset IMCAT_ICON = "">
								<cfset IMCAT_LINK_TYPE = "">
							</cfif>
							<cfif Len(IMCAT2_ID)>
								<cfset IMCAT2_ICON = get_ims.IMCAT_ICON[listfind(im_cats,IMCAT2_ID,',')]>
								<cfset IMCAT2_LINK_TYPE = get_ims.IMCAT_LINK_TYPE[listfind(im_cats,IMCAT2_ID,',')]>
								<cfelse>
								<cfset IMCAT2_ICON = "">
								<cfset IMCAT2_LINK_TYPE = "">
							</cfif>--->
<!---							#IMsgIcon()#--->
						</td>
                        <!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr> 
					<td colspan="12"><cfif filtered><cf_get_lang_main no='1074.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
				</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="rule.list_hr#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
