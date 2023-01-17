<cfif (isdefined("attributes.event") and (attributes.event is 'list' or attributes.event is 'add')) or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="ehesap">
	<cfscript>
		bu_ay_basi = CreateDate(year(now()),month(now()),1);
		bu_ay_sonu = DaysInMonth(bu_ay_basi);
	</cfscript>
	<cfparam name="attributes.collar_type" default="">
	<cfparam name="attributes.title_id" default="">
	<cfquery name="GET_POSITION_CATS_" datasource="#dsn#">
		SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
	</cfquery>
	<cfquery name="get_title" datasource="#dsn#">
		SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
	</cfquery>
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		<cf_xml_page_edit fuseact="ehesap.list_payments">
		<cfparam name="attributes.start_mon" default="#month(now())#">
		<cfparam name="attributes.end_mon" default="#month(now())#">
		<cfparam name="attributes.yil" default="#year(now())#">
		<cfparam name="attributes.odkes" default="">
		<cfparam name="attributes.keyword" default="">
		<cfparam name="attributes.hierarchy" default="">
		<cfparam name="attributes.tax" default="">
		<cfparam name="attributes.ssk" default="">
		<cfparam name="attributes.position_cat_id" default="">
		<cfparam name="attributes.inout_statue" default="">
		<cfparam name="attributes.startdate" default="">
		<cfparam name="attributes.finishdate" default="">
		<cfparam name="attributes.page" default="1">
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<!--- Pozisyon ekleme sayfasının xml ine göre pozisyon alanını kapatıyoruz --->
		<cfquery name="get_position_list_xml" datasource="#dsn#">
			SELECT 
				PROPERTY_VALUE,
				PROPERTY_NAME
			FROM
				FUSEACTION_PROPERTY
			WHERE
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="hr.form_add_position"> AND
				PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_add_position_name">
		</cfquery>
		<cfscript>
			if ((get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1) or get_position_list_xml.recordcount eq 0)
				show_position = 1;
			else
				show_position = 0;
			url_str = "";
			toplam_tutar = 0;
			url_str = "#url_str#&keyword=#attributes.keyword#";
			if (isdefined("attributes.branch_id") and len(attributes.branch_id))
				url_str = "#url_str#&branch_id=#attributes.branch_id#";
			if (isdefined("attributes.hierarchy") and len(attributes.hierarchy))
				url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
			if (len(attributes.odkes))
				url_str = "#url_str#&odkes=#attributes.odkes#";
			if (len(attributes.yil))
				url_str = "#url_str#&yil=#attributes.yil#";
			if (len(attributes.start_mon))
				url_str = "#url_str#&start_mon=#attributes.start_mon#";
			if (len(attributes.end_mon))
				url_str = "#url_str#&end_mon=#attributes.end_mon#";
			if (len(attributes.ssk))
				url_str = "#url_str#&ssk=#attributes.ssk#";
			if (len(attributes.tax))
				url_str = "#url_str#&tax=#attributes.tax#";
			if (len(attributes.collar_type))
				url_str = "#url_str#&collar_type=#attributes.collar_type#";
			if (len(attributes.position_cat_id))
				url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
			if (len(attributes.title_id))
				url_str = "#url_str#&title_id=#attributes.title_id#";
			if (isdefined('attributes.form_submit'))
				url_str = "#url_str#&form_submit=#attributes.form_submit#";
			if (isdefined("attributes.department_id"))
				url_str = "#url_str#&department_id=#attributes.department_id#";
			if (isdefined("attributes.related_company"))
				url_str="#url_str#&related_company=#attributes.related_company#";
			if (isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_code_name") and len(attributes.expense_code_name))
				url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#&expense_code_name=#attributes.expense_code_name#";
			if (isdefined("attributes.startdate") and len(attributes.startdate))
				url_str="#url_str#&startdate=#dateformat(attributes.startdate)#";
			if (isdefined("attributes.finishdate") and len(attributes.finishdate))
				url_str="#url_str#&finishdate=#dateformat(attributes.finishdate)#";
			if (isdefined("attributes.inout_statue") and len(attributes.inout_statue))
				url_str="#url_str#&inout_statue=#attributes.inout_statue#";
			attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
			cols = 8;
			if (is_expense_center eq 1) cols = cols+1;
			if (is_in_date eq 1) cols = cols+1;
			if (is_out_date eq 1) cols = cols+1;
			if (show_position eq 1) cols = cols+1;
		</cfscript>
		<cfif len(attributes.startdate) and isdate(attributes.startdate)>
			<cf_date tarih="attributes.startdate">
		</cfif>
		<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
			<cf_date tarih="attributes.finishdate">
		</cfif>
		
		<cfif isdefined('attributes.form_submit')>
			<cfinclude template="../hr/ehesap/query/get_payments.cfm">
		<cfelse>
			<cfset get_payments.recordcount = 0>
		</cfif>
		<cfinclude template="../hr/ehesap/query/get_ssk_offices.cfm">
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
			SELECT 
				SO.ODKES_ID,
				SO.COMMENT_PAY
			FROM 
				SETUP_PAYMENT_INTERRUPTION SO
			WHERE
				SO.IS_ODENEK = 1
		</cfquery>
		<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
			<cfquery name="get_departmant" datasource="#dsn#">
				SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
			</cfquery>
		</cfif>
		<cfparam name="attributes.totalrecords" default="#get_payments.recordcount#">
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		<cf_xml_page_edit fuseact="ehesap.popup_form_add_ek_odenek_all">
		<cfparam name="attributes.duty_type" default="">
		<cfparam name="attributes.func_id" default="">
		<cfparam name="attributes.pos_cat_id" default="">
		<cfparam name="attributes.branch_id" default="">
		<cfparam name="attributes.inout_statue" default="2">
		<cfparam name="attributes.startdate" default="1/#month(now())#/#year(now())#">
		<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#year(now())#">
		<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
		<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
		<cfscript>
			duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
			QueryAddRow(duty_type,8);
			QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
			QuerySetCell(duty_type,"DUTY_TYPE_NAME","#lang_array_main.item[164]#",1);
			QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
			QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[194]#',2);
			QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
			QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[604]#',3);
			QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
			QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[206]#',4);
			QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
			QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[232]#',5);
			QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
			QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[223]#',6);
			QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
			QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[236]#',7);
			QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
			QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[253]#',8);
		
			collar_type = QueryNew("COLLAR_TYPE_ID, COLLAR_TYPE_NAME");
			QueryAddRow(collar_type,2);
			QuerySetCell(collar_type,"COLLAR_TYPE_ID",1,1);
			QuerySetCell(collar_type,"COLLAR_TYPE_NAME","#lang_array.item[1109]#",1);
			QuerySetCell(collar_type,"COLLAR_TYPE_ID",2,2);
			QuerySetCell(collar_type,"COLLAR_TYPE_NAME",'#lang_array.item[1110]#',2);
			
			include "../hr/ehesap/query/get_all_branches.cfm";
		</cfscript>
		<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
			<cfquery name="get_poscat_positions" datasource="#dsn#">
				SELECT
					E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,E.EMPLOYEE_ID,E.EMPLOYEE_NO,EIO.IN_OUT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
				FROM
					EMPLOYEES_IN_OUT EIO
					INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID=EIO.EMPLOYEE_ID
		            LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EIO.EMPLOYEE_ID
					LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID=EIO.DEPARTMENT_ID
					LEFT JOIN BRANCH B ON D.BRANCH_ID=B.BRANCH_ID
				WHERE
					1=1
					<cfif len(attributes.pos_cat_id) or len(attributes.collar_type) or len(attributes.title_id) or len(attributes.func_id)>
						AND EP.IS_MASTER = 1
					</cfif>
					<cfif len(attributes.branch_id)>
						AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)
					</cfif>
					<cfif len(attributes.collar_type)>
						AND EP.COLLAR_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.collar_type#">)
					</cfif>
					<cfif len(attributes.pos_cat_id)>
						AND EP.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.pos_cat_id#">) 
					</cfif>
					<cfif len(attributes.title_id)>
						AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.title_id#">) 
					</cfif>
		            <cfif len(attributes.func_id)>
						AND EP.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.func_id#">) 
					</cfif>
					<cfif isdefined("attributes.duty_type") and len(attributes.duty_type)>
						AND EIO.DUTY_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.duty_type#">)
					</cfif>
					<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
						AND E.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.hierarchy#%">
					</cfif>
					<cfif isdefined("attributes.inout_statue") and attributes.inout_statue eq 1><!--- Girişler --->
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 0><!--- Çıkışlar --->
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
						AND	EIO.FINISH_DATE IS NOT NULL
					<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 2><!--- aktif calisanlar --->
						AND 
						(
							<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
								<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
								(
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
									)
									OR
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
									EIO.FINISH_DATE IS NULL
									)
								)
								<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
								(
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
									)
									OR
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
									EIO.FINISH_DATE IS NULL
									)
								)
								<cfelse>
								(
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
									)
									OR
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
									EIO.FINISH_DATE IS NULL
									)
									OR
									(
									EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
									)
									OR
									(
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
									EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
									)
								)
								</cfif>
							<cfelse>
								EIO.FINISH_DATE IS NULL
							</cfif>
						)
					<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
						AND 
						(
							(
								EIO.START_DATE IS NOT NULL
								<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
									AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
								</cfif>
								<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
									AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
								</cfif>
							)
							OR
							(
								EIO.START_DATE IS NOT NULL
								<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
									AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
								</cfif>
								<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
									AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
								</cfif>
							)
						)
					</cfif>
				ORDER BY
					EMPLOYEE_NAME
			</cfquery>
		</cfif>
		<cfquery name="get_func" datasource="#dsn#">
			SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT WHERE IS_ACTIVE = 1 ORDER BY UNIT_NAME
		</cfquery>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfif isdefined("attributes.is_payment")>
		<cfquery name="get_payments" datasource="#DSN#">
			SELECT 
				EMPLOYEE_ID,
				COMMENT_PAY COMMENT,
				AMOUNT_PAY AMOUNT,
				METHOD_PAY METHOD,
				START_SAL_MON,
				END_SAL_MON,
	            RECORD_EMP,
	            RECORD_DATE,
	            UPDATE_EMP,
	            UPDATE_DATE
			FROM 
				SALARYPARAM_PAY
			WHERE
				EMPLOYEE_ID IS NOT NULL AND
				SPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		</cfquery>
	<cfelseif isdefined("attributes.is_interruption")>	
		<cfquery name="get_payments" datasource="#DSN#">
			SELECT 
				EMPLOYEE_ID,
				COMMENT_GET COMMENT,
				AMOUNT_GET AMOUNT,
				METHOD_GET METHOD,
				START_SAL_MON,
				END_SAL_MON,
	            RECORD_EMP,
	            RECORD_DATE,
	            UPDATE_EMP,
	            UPDATE_DATE
			FROM 
				SALARYPARAM_GET
			WHERE
				EMPLOYEE_ID IS NOT NULL AND
				SPG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		</cfquery>
	<cfelseif isdefined("attributes.is_tax_except")>	
		<cfquery name="get_payments" datasource="#DSN#">
			SELECT 
				EMPLOYEE_ID,
				TAX_EXCEPTION COMMENT,
				AMOUNT,
				START_MONTH START_SAL_MON,
				FINISH_MONTH END_SAL_MON,
	            RECORD_EMP,
	            RECORD_DATE,
	            UPDATE_EMP,
	            UPDATE_DATE
			FROM 
				SALARYPARAM_EXCEPT_TAX
			WHERE
				EMPLOYEE_ID IS NOT NULL AND
				TAX_EXCEPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		</cfquery>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add_tax'>
	<cfquery name="all_pos_cats" datasource="#DSN#">
		SELECT 
			POSITION_CAT_ID,
			POSITION_CAT
		FROM
			SETUP_POSITION_CAT
		ORDER BY
			POSITION_CAT
	</cfquery>
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
			var branch_id = $('#branch_id').val();
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
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
			if(deger != undefined && deger.value.length!=0)//değer boşdegilse çalıştır foru
			{
				if(!baslangic){baslangic=1;}//başlangıc tüm elemanları değlde sadece bir veya bir kaçtane yapacaksak forun başlayacağı sayıyı vererek okadar dönmesini sağlayabilirz
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
			var my_element = document.getElementById('my_row_' +sy);
			my_element.style.display="none";
			toplam_hesapla();
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
		
		function add_row(is_damga,is_issizlik,ssk,tax,is_kidem,show,comment_pay,period_pay,method_pay,term,start_sal_mon,end_sal_mon,amount_pay,calc_days,from_salary,row_id_,ehesap,ayni_yardim,ssk_exemption_rate,tax_exemption_rate,tax_exemption_value,money,odkes_id,ssk_exemption_type)
		{
			if(row_count == 0)
			{
				alert("<cf_get_lang no='665.Satır Eklemediniz'>!");
				return false;
			}
			if(row_id_ != undefined && row_id_ != '')
			{	
				$('#show'+row_id_).val(show);
				$('#odkes_id'+row_id_).val(odkes_id);
				$('#comment_pay'+row_id_).val(comment_pay);
				$('#start_sal_mon'+row_id_).val(start_sal_mon);
				$('#end_sal_mon'+row_id_).val(end_sal_mon);
				$('#amount_pay'+row_id_).val(amount_pay);
				$('#term'+row_id_).val(term);
			}
			else
			{
				$('#show0').val(show);
				hepsi(row_count,'show');
				goster(show);
				$('#odkes_id0').val(odkes_id);
				hepsi(row_count,'odkes_id');
				$('#comment_pay0').val(comment_pay);
				hepsi(row_count,'comment_pay');
				$('#term0').val(term);
				hepsi(row_count,'term');
				$('#start_sal_mon0').val(start_sal_mon);
				hepsi(row_count,'start_sal_mon');
				$('#end_sal_mon0').val(end_sal_mon);
				hepsi(row_count,'end_sal_mon');
				$('#amount_pay0').val(amount_pay);
				hepsi(row_count,'amount_pay');
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
						
			document.getElementById('record_num').value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="icon-trash-o btnPointer"></a>';	
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" id="empno' + row_count +'" name="empno' + row_count +'" style="width:135px;" readonly value="">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.whiteSpace = 'nowrap';
			newCell.innerHTML = '<input type="hidden" id="employee_in_out_id' + row_count +'" name="employee_in_out_id' + row_count +'" style="width:10px;" value="employee_in_out_id#currentrow#"><input type="text" id="employee' + row_count +'" name="employee' + row_count +'"  onFocus="AutoComplete_Create(\'employee'+ row_count +'\',\'MEMBER_NAME\',\'MEMBER_PARTNER_NAME3\',\'get_member_autocomplete\',\'3\',\'EMPLOYEE_ID,IN_OUT_ID,BRANCH_DEPT\',\'employee_id' + row_count +',employee_in_out_id' + row_count +',department' + row_count +'\',\'my_week_timecost\',3,116);" style="width:120px;" value=""><i class="icon-ellipsis btnPointer" onClick="windowopen(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=employee_in_out_id'+row_count+'&field_emp_name=employee'+ row_count + '&field_emp_id=employee_id'+ row_count + '&field_emp_no=empno' + row_count + '&field_branch_and_dep=department'+ row_count + '\' ,\'list\');"></i><input type="hidden" value="" name="odkes_id' + row_count + '" id="odkes_id' + row_count + '" /><input  type="hidden" id="employee_id' + row_count +'"  value=""  name="employee_id' + row_count +'"><input  type="hidden"  value="1" id="row_kontrol_' + row_count +'"  name="row_kontrol_' + row_count +'">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" id="department' + row_count +'" name="department' + row_count +'" style="width:135px;" readonly value="">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","show_img" + row_count);
			newCell.innerHTML = '<img border="0" src="/images/b_ok.gif" align="absmiddle">';
			if(document.add_ext_salary.show0.value==0)/* eklerken satırı show0 değerini göre resim gözüksün gözükmesin ayarı*/
			{
				satir=eval("show_img"+row_count);
				satir.style.display='none';
			}
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.whiteSpace = 'nowrap';
			newCell.innerHTML = '<input type="hidden" id="show' + row_count +'" name="show' + row_count +'" value="0"><input type="text" id="comment_pay' + row_count +'" name="comment_pay' + row_count +'" style="width:120px;" readonly value=""><i class="icon-ellipsis btnPointer" onClick="send_odenek('+row_count+');"></i>';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="term' + row_count +'" id="term' + row_count +'"><cfloop from="#year(now())-1#" to="#year(now())+2#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif year(now()) eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select id="start_sal_mon' + row_count +'" name="start_sal_mon' + row_count +'" style="width:65px;" onchange="change_mon(\'end_sal_mon'+row_count+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select id="end_sal_mon' + row_count +'" name="end_sal_mon' + row_count +'" style="width:65px;"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input id="amount_pay' + row_count +'" name="amount_pay' + row_count +'" type="text" style="width:90px;" class="moneybox" value="" onclick="toplam_hesapla();" onchange="toplam_hesapla();" onkeyup="toplam_hesapla();return(FormatCurrency(this,event));">';
			
			hepsi(row_count,'show',row_count);
			hepsi(row_count,'comment_pay',row_count);
			hepsi(row_count,'term',row_count);
			hepsi(row_count,'start_sal_mon',row_count);
			hepsi(row_count,'end_sal_mon',row_count);
			hepsi(row_count,'amount_pay',row_count);
			hepsi(row_count,'odkes_id',row_count);
			
			odenek_text = document.getElementById('document.add_ext_salary.comment_pay' + row_count);
			return true;
		}
		function send_odenek(row_count)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_odenek&row_id_='+ row_count,'medium');
		}
		function kontrol()
		{
			$('#record_num').val(row_count);
			if(row_count == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='136.Ek Ödenek'>");
				return false;
			}
			for(var i=1;i<=row_count;i++)
			{
				if(eval("document.add_ext_salary.amount_pay"+i).value.length == 0)
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='664.Ödenek'>");
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
		function toplam_hesapla()
		{
			var total_amount = 0;
			var sayac = 0;
			for(var i=1;i<=row_count;i++)
			{
				if(eval("add_ext_salary.row_kontrol_"+i).value != 0 && eval("document.add_ext_salary.amount_pay"+i).value != 0)
				{
					nesne_tarih=eval("document.add_ext_salary.amount_pay"+i);
					total_amount += parseFloat(filterNum(nesne_tarih.value));
					sayac++
				}
			}
			$('#total_amount').val(parseFloat(total_amount));
			$('#total_emp').val(sayac);
		}	
		function change_mon(id,i)
		{
			$('#'+id).val(i);
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function kontrol_et()
		{
			if (!document.getElementById('amount_pay').value.length)
			{
				alert("<cf_get_lang dictionary_id='54619.Tutar Girmelisiniz'>");
				return false;
			}
			$('#amount_pay').val(filterNum($('#amount_pay').val(),4));
			return true;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_payments';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_payments.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_ek_odenek_all';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/popup_form_add_ek_odenek_all.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_ek_odenek_all.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_payments&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_payments';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_payment_detail.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/popup_upd_payment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_payments&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_tax_except&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListPayments';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	if(attributes.event is 'upd')
	{
		if(IsDefined("attributes.is_payment")  and attributes.is_payment eq 1)
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALARYPARAM_PAY';
		}
		else if (IsDefined("attributes.is_interruption") and attributes.is_interruption eq 1)
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALARYPARAM_GET';
		}
		else if (IsDefined("attributes.is_tax_except") and attributes.is_tax_except eq 1)
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALARYPARAM_EXCEPT_TAX';
		}
	}
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "[]";
</cfscript>
