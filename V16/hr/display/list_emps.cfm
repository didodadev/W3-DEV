<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.bes_kontrol" default="0">
<cfif not isdefined('attributes.is_form_submitted')>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfset url_string = "">
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.bes_kontrol")>
	<cfset url_string = "#url_string#&bes_kontrol=#attributes.bes_kontrol#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_ssk_no")>
	<cfset url_string = "#url_string#&field_ssk_no=#attributes.field_ssk_no#">
</cfif>
<cfif isdefined("attributes.field_branch_id")>
	<cfset url_string = "#url_string#&field_branch_id=#attributes.field_branch_id#">
</cfif>
<cfif isdefined("attributes.field_branch")>
	<cfset url_string = "#url_string#&field_branch=#attributes.field_branch#">
</cfif>
<cfif isdefined("attributes.field_dept_id")>
	<cfset url_string = "#url_string#&field_dept_id=#attributes.field_dept_id#">
</cfif>
<cfif isdefined("attributes.field_dept_head")>
	<cfset url_string = "#url_string#&field_dept_head=#attributes.field_dept_head#">
</cfif>
<cfif isdefined("attributes.field_tc_no")>
	<cfset url_string = "#url_string#&field_tc_no=#attributes.field_tc_no#">
</cfif>
<cfif isdefined("attributes.field_birth_date")>
	<cfset url_string = "#url_string#&field_birth_date=#attributes.field_birth_date#">
</cfif>
<cfif isdefined("attributes.conf_")>
	<cfset url_string = "#url_string#&conf_=#attributes.conf_#">
</cfif>
<cfif isdefined("attributes.run_function")>
	<cfset url_string = "#url_string#&run_function=#attributes.run_function#">
</cfif>
<cfif not isdefined("attributes.show_all")>
	<cfset attributes.show_all = "">
</cfif>
<cfset url_string = "#url_string#&is_form_submitted=1">
<!--- form değerlerinin öncelikli olması için yapıldı erk 20031229 --->
<!--- <cfset form_url_string = url_string> --->
<cfif arama_yapilmali>
	<cfset GET_EMPLOYEES.recordcount = 0>
<cfelse>
	<cfinclude template="../query/get_employees.cfm">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_employees.recordcount#>	
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	

<cf_box title="#getLang('','Çalışanlar',58875)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_emp" action="#request.self#?fuseaction=hr.popup_list_emps#url_string#" method="post">
		<cf_box_search>
			<div class="form-group">
				<cfinput type="text" value="#attributes.keyword#" name="keyword" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group">
				<select name="show_all" id="show_all">
					<option value=""><cf_get_lang dictionary_id='57569.Görevli'></option>
					<option value="1"<cfif attributes.show_all is "1"> selected</cfif>><cf_get_lang dictionary_id='55541.Dolu'></option>
					<option value="0"<cfif attributes.show_all is "0"> selected</cfif>><cf_get_lang dictionary_id='55552.Boş'></option>
				</select>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_emp' , '#attributes.modal_id#')"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>

	<cf_grid_list>
		<thead>
			<tr>
				<th width="50"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
				<th width="150"><cf_get_lang dictionary_id='55728.Şube / Departman'></th>
				<th width="20" class="text-center"><i class="fa fa-pencil"></i></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_employees.recordcount>
				<cfoutput query="get_employees" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#employee_no#</td>
						<cfquery name="CHK_EMP_POS" datasource="#dsn#">
							SELECT
								POSITION_STATUS,
								POSITION_ID
							FROM
								EMPLOYEE_POSITIONS
							WHERE
								EMPLOYEE_ID=#EMPLOYEE_ID#
						</cfquery>
						<cfif chk_emp_pos.recordcount>
							<cfset pos_id=chk_emp_pos.POSITION_ID>
						<cfelse>
							<cfset pos_id=0>
						</cfif>
						<cfif attributes.bes_kontrol eq 1>
							<cfquery name="CHK_EMP_INFO" datasource="#dsn#">
								SELECT
									BIRTH_DATE
								FROM
									EMPLOYEES_IDENTY
								WHERE
									EMPLOYEE_ID=#EMPLOYEE_ID#
							</cfquery>
						</cfif>
						<cfquery name="GET_POS" datasource="#dsn#">
							SELECT
								BRANCH.BRANCH_ID,
								BRANCH.BRANCH_NAME,
								DEPARTMENT.DEPARTMENT_HEAD,
								EMPLOYEE_POSITIONS.*
							FROM
								EMPLOYEE_POSITIONS,
								DEPARTMENT,
								BRANCH
							WHERE
								EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
								EMPLOYEE_POSITIONS.POSITION_ID=#POS_ID# AND
								DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
						</cfquery>
					<td><a href="javascript://"  onclick="send_info('#employee_id#','#employee_name# #employee_surname#','#pos_id#','#SOCIALSECURITY_NO#','#tc_identy_no#','<cfif bes_kontrol eq 1>#dateformat(CHK_EMP_INFO.birth_date,'yyyy')#</cfif>','#GET_POS.branch_id#','#GET_POS.branch_name#','#GET_POS.department_id#','#GET_POS.department_head#','#bes_kontrol#')" class="tableyazi">#employee_name# #employee_surname#</a></td>
					<td>
						<cfif len(get_pos.department_head)>#get_pos.BRANCH_NAME# / #get_pos.department_head#<cfelse>-</cfif>
					</td>
					<td class="text-center"><cfif len(get_pos.department_head)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#&department_id=#get_pos.department_id#','list')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='49836.Çalışan Detay'>" alt="<cf_get_lang dictionary_id='49836.Çalışan Detay'>"></i></a></cfif></td>
				</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="4"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif len(attributes.show_all)>
		<cfset url_string = "#url_string#&show_all=#attributes.show_all#">
	</cfif>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#&is_form_submitted=1">
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="hr.popup_list_emps#url_string#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function send_info(id,name,pos_id,ssk_no,tc_kimlik,birth_date,branch_id,branch_name,dept_id,dept_head,bes_kontrol)
	{
		/* 45 yaş altı için Otomatik BES Uyarısı Yaş Kontrolü */
		<cfif attributes.bes_kontrol eq 1>
			if((<cfoutput>#year(now())#</cfoutput>-birth_date) < 45){
				birth_date = "İşe girişini yaptığınız personel 45 yaşın altında, otomatik bes tanımı yapılacaksa ücret kartından yapılabilir."
				alert(birth_date);
			}else{
				birth_date = birth_date
			}
		<cfelse>
			birth_date = birth_date
		</cfif>
		<cfif not isdefined("attributes.conf_")>/*pozisyon güncelle haricindeki çaşırımlarda kullnılır erk 20040320*/
			if((pos_id!=0)&&(pos_id!=""))
			{
				if(!confirm("<cf_get_lang dictionary_id ='56776.Bu çalışanın zaten bir pozisyonu var, Bu pozisyon yeni olarak eklenecektir! Emin misiniz'>?"))
				{
					alert("<cf_get_lang dictionary_id ='56777.Başka bir çalışan seçiniz'>.");
					return false;
				}
			}
		</cfif>
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
			<cfif attributes.field_id is "add_pos.conf_employee_id">
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.buton.style.display='';
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value =name;
		</cfif>
		<cfif isdefined("attributes.field_ssk_no")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_ssk_no#</cfoutput>.value = ssk_no;
		</cfif>
		<cfif isdefined("attributes.field_tc_no")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_tc_no#</cfoutput>.value = tc_kimlik;
		</cfif>
		<cfif (attributes.bes_kontrol eq 1) and isdefined("attributes.field_birth_date")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("item-birth_date").style.display = "block";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("birth_date").innerHTML = birth_date;
		</cfif>
		<cfif isdefined("attributes.field_branch_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_branch_id#</cfoutput>.value = branch_id;
		</cfif>
		<cfif isdefined("attributes.field_branch")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_branch#</cfoutput>.value = branch_name;
		</cfif>
		<cfif isdefined("attributes.field_dept_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dept_id#</cfoutput>.value = dept_id;
		</cfif>
		<cfif isdefined("attributes.field_dept_head")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dept_head#</cfoutput>.value = dept_head;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		<cfif isdefined("attributes.run_function")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#run_function#</cfoutput>;
		</cfif>
	}
</script>