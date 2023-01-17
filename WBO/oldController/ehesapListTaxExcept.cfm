<cfif (isdefined("attributes.event") and listfind('list,add',attributes.event)) or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="ehesap">
	<cfquery name="all_pos_cats" datasource="#DSN#">
		SELECT 
			POSITION_CAT_ID,
			POSITION_CAT
		FROM
			SETUP_POSITION_CAT
		ORDER BY
			POSITION_CAT
	</cfquery>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.odkes" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.department_id" default="">
	<cfparam name="attributes.collar_type" default="">
	<cfparam name="attributes.position_cat_id" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.aylar" default="#month(now())#">
	<cfparam name="attributes.end_mon" default="#month(now())#">
	<cfparam name="attributes.yil" default="#year(now())#">
	<cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
	<cfquery name="get_related_branches" datasource="#DSN#">
		SELECT DISTINCT
			RELATED_COMPANY
		FROM 
			BRANCH
		WHERE 
			BRANCH_ID IS NOT NULL AND
			RELATED_COMPANY IS NOT NULL
		<cfif not session.ep.ehesap>
			AND
			BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
						)
		</cfif>
		ORDER BY
			RELATED_COMPANY
	</cfquery>
	<cfquery name="get_odeneks" datasource="#dsn#">
		SELECT TAX_EXCEPTION FROM TAX_EXCEPTION
	</cfquery>
	<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
		<cfquery name="get_departmant" datasource="#dsn#">
            SELECT * FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = #attributes.branch_id# AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
        </cfquery>
	</cfif>
	<cfscript>
		toplam_tutar=0;
		include "../hr/ehesap/query/get_ssk_offices.cfm";
		if (isdefined('attributes.form_submit'))
			include "../hr/ehesap/query/get_tax_exceptions.cfm";
		else
			get_tax_exceptions.recordcount = 0;
		url_str = "&keyword=#attributes.keyword#";
		if (len(attributes.branch_id))
			url_str = "#url_str#&branch_id=#attributes.branch_id#";
		if (len(attributes.hierarchy))
			url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
		if (len(attributes.department_id))
			url_str = "#url_str#&department_id=#attributes.department_id#";
		if (len(attributes.odkes))
			url_str = "#url_str#&odkes=#attributes.odkes#";
		if (len(attributes.yil))
			url_str = "#url_str#&yil=#attributes.yil#";
		if (len(attributes.aylar))
			url_str = "#url_str#&aylar=#attributes.aylar#";
		if (len(attributes.end_mon))
			url_str = "#url_str#&end_mon=#attributes.end_mon#";
		if (isdefined('attributes.form_submit'))
			url_str = "#url_str#&form_submit=#attributes.form_submit#";
		if (isdefined('attributes.related_company'))
			url_str = "#url_str#&related_company=#attributes.related_company#";
		if (len(attributes.collar_type))
			url_str = "#url_str#&collar_type=#attributes.collar_type#";
		if (len(attributes.position_cat_id))
			url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
	</cfscript>
    <cfparam name="attributes.totalrecords" default="#get_tax_exceptions.recordcount#">
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_get_lang_set module_name="ehesap">
	<cfinclude template="../hr/ehesap/query/get_all_branches.cfm">
	<cfif isdefined("attributes.pos_cat_id")>
		<cfquery name="get_poscat_positions" datasource="#dsn#">
			SELECT
				E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,E.EMPLOYEE_ID,EIO.IN_OUT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
			FROM
				EMPLOYEES_IN_OUT EIO,
				EMPLOYEES E,
				DEPARTMENT D,
				BRANCH B
			WHERE
				<cfif len(attributes.branch_id)>
					B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
				</cfif>
				E.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND
				D.DEPARTMENT_ID=EIO.DEPARTMENT_ID AND
				D.BRANCH_ID=B.BRANCH_ID AND
				<cfif len(attributes.collar_type)>
					EIO.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#"> AND POSITION_STATUS = 1 AND EMPLOYEE_ID > 0) AND
				</cfif>
				<cfif len(attributes.pos_cat_id)>
					EIO.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_cat_id#"> AND POSITION_STATUS = 1 AND EMPLOYEE_ID > 0) AND
				</cfif>
				EIO.FINISH_DATE IS NULL
			ORDER BY
				EMPLOYEE_NAME
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		function showDepartment(branch_id)	
		{
			var branch_id = $("#branch_id").val();
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,"<cf_get_lang no='1376.İlişkili Departmanlar'>");
			}
		}
		function kontrol()
		{
			if($('#aylar').val() <= $('#end_mon').val())
				return true;
			else
			{
				alert("<cf_get_lang no='1377.Ay Değerlerini Kontrol Ediniz'>!");
				return false;
			}
		}
		function change_mon(i)
		{
			$('#end_mon').val(i);
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		$(document).ready(function() {
			<cfif isdefined("get_poscat_positions") and get_poscat_positions.recordcount>
				row_count=<cfoutput>#get_poscat_positions.recordcount#</cfoutput>;
			<cfelse>
				row_count=0;
			</cfif>
		});
		
		function hepsi(satir,nesne,baslangic)
		{
			deger = document.getElementById(nesne + '0');
			if(deger.value.length!=0)/*değer boşdegilse çalıştır foru*/
			{
			if(!baslangic){baslangic=1;}/*başlangıc tüm elemanları değlde sadece bir veya bir kaçtane yapacaksak forun başlayacağı sayıyı vererek okadar dönmesini sağlayabilirz*/
				for(var i=baslangic;i<=satir;i++)
				{
					nesne_tarih=eval('document.getElementById( nesne + i )');
					nesne_tarih.value=deger.value;
				}
			}
		}
		function sil(sy)
		{
			var my_element = document.getElementById('row_kontrol_' + sy);
			my_element.value=0;
			var my_element = document.getElementById('my_row_' + sy);
			my_element.style.display="none";
		}
		function goster(show)
		{
			if(show==1)
			{
				show_img_baslik1.style.display='';
				show_img_baslik2.style.display='';
				for(var i=0;i<=row_count;i++)
				{
					satir=eval("show_img"+i);
					satir.style.display='';
				}
			}
			else
			{
				show_img_baslik1.style.display='none';
				show_img_baslik2.style.display='none';
				for(var i=0;i<=row_count;i++)
				{
					satir=eval("document.getElementById('show_img" + i + "')");
					satir.style.display='none';
				}
			}
		}
		function add_row(tax_exception,sal_year,start_month,finish_month,amount,calc_days,yuzde_sinir,tamamini_ode,is_isveren_,is_ssk_,exception_type,row_id_,tax_exception_id)
		{
			if(row_count == 0)
			{
				alert("<cf_get_lang no='665.Satır Eklemediniz'>!");
				return false;
			}
			if(row_id_ != undefined && row_id_ != '')
			{	
				$('#comment_pay'+row_id_).val(tax_exception);
				$('#term'+row_id_).val(sal_year);
				$('#start_sal_mon'+row_id_).val(start_month);
				$('#end_sal_mon'+row_id_).val(finish_month);
				$('#amount_pay'+row_id_).val(amount);
				$('#tax_exception_id'+row_id_).val(tax_exception_id);
			}
			else
			{
				goster(show);
				hepsi(row_count,'show');
				$('#comment_pay0').val(tax_exception);
				hepsi(row_count,'comment_pay');
				$('#term0').val(sal_year);
				hepsi(row_count,'term');
				$('#start_sal_mon0').val(start_month);
				hepsi(row_count,'start_sal_mon');
				$('#end_sal_mon0').val(finish_month);
				hepsi(row_count,'end_sal_mon');
				$('#amount_pay0').val(amount);
				hepsi(row_count,'amount_pay');
				$('#tax_exception_id0').val(tax_exception_id);
				hepsi(row_count,'tax_exception_id');
			}
		}
		function add_row2()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","my_row_" + row_count);
			newRow.setAttribute("id","my_row_" + row_count);		
			newRow.setAttribute("NAME","my_row_" + row_count);
			newRow.setAttribute("ID","my_row_" + row_count);		
						
			$('#record_num').val(row_count);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img  src="images/delete_list.gif" border="0"></a>';	
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.whiteSpace = 'nowrap';
			newCell.innerHTML = '<input type="hidden" name="employee_in_out_id' + row_count +'" id="employee_in_out_id' + row_count +'" style="width:10px;" value=""><input type="text" name="employee' + row_count +'" id="employee' + row_count +'" onFocus="AutoComplete_Create(\'employee'+ row_count +'\',\'MEMBER_NAME\',\'MEMBER_PARTNER_NAME3\',\'get_member_autocomplete\',\'3\',\'EMPLOYEE_ID,IN_OUT_ID,BRANCH_DEPT\',\'employee_id' + row_count +',employee_in_out_id' + row_count +',department' + row_count +'\',\'my_week_timecost\',3,116);"  style="width:120px;" value=""><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=employee_in_out_id'+row_count+'&field_emp_name=employee'+ row_count + '&field_emp_id=employee_id'+ row_count +'&field_branch_and_dep=department'+ row_count + '\' ,\'list\');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" ></a><input type="Hidden" name="tax_exception_id' + row_count +'" id="tax_exception_id' + row_count +'" value=""><input type="hidden" name="exception_type' + row_count +'" id="exception_type' + row_count +'" value=""><input type="hidden" value="" name="employee_id' + row_count +'" id="employee_id' + row_count +'"><input type="hidden"  value="1"  name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="department' + row_count +'" id="department' + row_count +'" style="width:140px;" readonly value="">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","show_img" + row_count);
			newCell.innerHTML = '<img border="0" src="/images/b_ok.gif" align="absmiddle">';
			if(document.getElementById('show0').value==0)/* eklerken satırı show0 değerini göre resim gözüksün gözükmesin ayarı*/
			{
				satir=eval("show_img"+row_count);
				satir.style.display='none';
			}
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.whiteSpace = 'nowrap';
			newCell.innerHTML = '<input type="hidden" name="show' + row_count +'" id="show' + row_count +'" value="0"><input type="text" name="comment_pay' + row_count +'" id="comment_pay' + row_count +'" style="width:120px;" readonly value=""><a href="javascript://" onClick="send_odenek('+row_count+');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="term' + row_count +'" id="term' + row_count +'"><cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif session.ep.period_year eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="start_sal_mon' + row_count +'" id="start_sal_mon' + row_count +'" style="width:65px;" onchange="change_mon(\'end_sal_mon'+row_count+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="end_sal_mon' + row_count +'" id="end_sal_mon' + row_count +'" style="width:65px;"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input name="amount_pay' + row_count +'" id="amount_pay' + row_count +'" type="text" style="width:90px;" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));">';
			
			hepsi(row_count,'show',row_count);
			hepsi(row_count,'comment_pay',row_count);
			hepsi(row_count,'term',row_count);
			hepsi(row_count,'start_sal_mon',row_count);
			hepsi(row_count,'end_sal_mon',row_count);
			hepsi(row_count,'amount_pay',row_count);
			hepsi(row_count,'tax_exception_id',row_count);
			
			odenek_text=eval("document.add_ext_salary.comment_pay"+ row_count);
			odenek_text.focus();
			return true;
		}
		function send_odenek(row_count)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_tax_exception&row_id_='+ row_count,'medium');
		}
		function kontrol()
		{
			$('#record_num').val(row_count);
			if(row_count == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='137.Kesinti'>");
				return false;
			}
			for(var i=1;i<=row_count;i++)
			{
				if(eval("document.add_ext_salary.amount_pay"+i).value.length == 0)
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='137.Kesinti'>");
					return false;
				}
			}
			for(var i=1;i<=row_count;i++)
			{
				nesne=eval("document.add_ext_salary.amount_pay"+i);
				nesne.value=filterNum(nesne.value);
			}
			return true;
		}
		function change_mon(id,i)
		{
			$('#'+id).val(i);
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_tax_except';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_tax_except.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_tax_exception_all';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/popup_form_add_tax_exception_all.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_tax_exception_all.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_tax_except';
</cfscript>
