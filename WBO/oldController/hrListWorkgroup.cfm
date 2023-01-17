<cf_get_lang_set module_name="hr">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default=''>
	<cfparam name="attributes.is_hierarchy" default='1'>
	<cfparam name="attributes.listing_type" default="1">

	<cfif isdefined("attributes.is_form_submitted")>
		<cfinclude template="../hr/query/get_workgroups.cfm">
	<cfelse>
		<cfset get_workgroups.recordcount = 0>
	</cfif>
	
	<cfquery name="DEP" datasource="#DSN#">
		SELECT 
			DEPARTMENT.DEPARTMENT_ID, 
			DEPARTMENT.DEPARTMENT_HEAD, 
			DEPARTMENT.ADMIN1_POSITION_CODE,
			DEPARTMENT.ADMIN2_POSITION_CODE,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID
		FROM 
			DEPARTMENT
			INNER JOIN BRANCH ON BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		ORDER BY
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD
	</cfquery>
	
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.totalrecords" default="#get_workgroups.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	
	<cfquery name="get_branch" datasource="#dsn#">
        SELECT BRANCH_NAME,BRANCH_ID,BRANCH_STATUS FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY BRANCH_NAME
    </cfquery>
    
    <cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
		<cfquery name="get_department" datasource="#dsn#">
			SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS = 1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
		</cfquery>
	</cfif>
	
	<cfscript>
		if (not isdefined("attributes.department_id"))
			attributes.department_id="";
		url_string = "";
		if (fusebox.circuit eq 'objects')
		{
			url_string = "#fusebox.circuit#.popup_list_workgroup";
			if (isdefined("attributes.project_id"))
				url_string = "#url_string#&project_id=#attributes.project_id#";
			if (isdefined("field_id"))
				url_string = "#url_string#&field_id=#field_id#";
			if (isdefined("field_name"))
				url_string = "#url_string#&field_name=#field_name#";
		}
		else
			url_string = "#fusebox.circuit#.list_workgroup";
		if (len(attributes.keyword))
			url_string = "#url_string#&keyword=#attributes.keyword#";
		if (len(attributes.is_hierarchy))
			url_string = "#url_string#&is_hierarchy=#attributes.is_hierarchy#";
		if (len(attributes.listing_type))
			url_string = "#url_string#&listing_type=#attributes.listing_type#";
		url_string = "#url_string#&is_form_submitted=1";
	</cfscript>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add_workgroup' or attributes.event is 'upd_workgroup')>
	<cfinclude template="../hr/query/get_workgroup_uppers.cfm">
	<cfif attributes.event is 'add_workgroup'>
		<cfif isdefined("attributes.hierarchy1_code") and len(attributes.hierarchy1_code)>
			<cfquery name="GET_UPPER_GROUP_INFO" datasource="#DSN#">
				SELECT 
		        	WG.WORKGROUP_ID, 
		            WG.WORKGROUP_NAME, 
		            WG.GOAL, 
		            WG.ONLINE_HELP, 
		            WG.ONLINE_SALES, 
		            WG.COMPANY_ID, 
		            WG.PROJECT_ID, 
		            WG.STATUS, 
		            WG.HIERARCHY, 
		            WG.UPPER_WORKGROUP_ID, 
		            WG.WORKGROUP_TYPE_ID, 
		            WG.IS_ORG_VIEW, 
		            WG.MANAGER_ROLE_HEAD, 
		            WG.MANAGER_EMP_ID, 
		            WG.SUB_WORKGROUP, 
		            WG.SPONSOR_EMP_ID, 
		            WG.IS_BUDGET,
		            SH.HEADQUARTERS_ID,
		            SH.NAME,
		            OC.COMPANY_NAME,
		            OC.COMP_ID,
		            D.DEPARTMENT_HEAD,
		            D.DEPARTMENT_ID,
		            D.BRANCH_ID,
		            B.BRANCH_NAME
			    FROM 
		        	WORK_GROUP WG
		        	LEFT JOIN SETUP_HEADQUARTERS SH ON SH.HEADQUARTERS_ID = WG.HEADQUARTERS_ID
		        	LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = WG.OUR_COMPANY_ID
		        	LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = WG.DEPARTMENT_ID
		        	LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
		        WHERE 
		        	WG.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy1_code#">
			</cfquery>
		</cfif>
		<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
			<cfquery name="GET_PROJE" datasource="#DSN#">
				SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfquery>
		</cfif>
	<cfelseif attributes.event is 'upd_workgroup'>
		<cfif isdefined('attributes.project_id')>
			<cfquery name="GET_WORKGROUP" datasource="#DSN#">
				SELECT WORKGROUP_ID FROM WORK_GROUP WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfquery>
			<cfset attributes.workgroup_id=	get_workgroup.workgroup_id>
		</cfif>
		<cfif not len(attributes.workgroup_id)>
			<cflocation url="#request.self#?fuseaction=objects.popup_form_list_pro_group&project_id=#attributes.project_id#" addtoken="no">
		<cfelse>
			<cfquery name="GET_CATEGORY" datasource="#DSN#">
				SELECT
					WG.BRANCH_ID,
					WG.COMPANY_ID,
					WG.DEPARTMENT_ID,
					WG.GOAL,
					WG.HEADQUARTERS_ID,
					WG.HIERARCHY,
					WG.IS_BUDGET,
					WG.IS_ORG_VIEW,
					WG.MANAGER_EMP_ID,
					WG.MANAGER_POSITION_CODE,
					WG.MANAGER_ROLE_HEAD,
					WG.ONLINE_HELP,
					WG.ONLINE_SALES,
					WG.OUR_COMPANY_ID,
					WG.PROJECT_ID,
					WG.RECORD_DATE,
					WG.RECORD_EMP,
					WG.RECORD_IP,
					WG.SPONSOR_EMP_ID,
					WG.STATUS,
					WG.SUB_WORKGROUP,
					WG.UPDATE_DATE,
					WG.UPDATE_EMP,
					WG.UPDATE_IP,
		    	    WG.WORKGROUP_ID, 
		            WG.WORKGROUP_NAME, 
		            WG.WORKGROUP_TYPE_ID,
		            B.BRANCH_NAME,
		            D.DEPARTMENT_HEAD,
		            OC.COMPANY_NAME,
		            SH.NAME
		        FROM 
			        WORK_GROUP WG
			        LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = WG.DEPARTMENT_ID
			        LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
			        LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = WG.OUR_COMPANY_ID
			        LEFT JOIN SETUP_HEADQUARTERS SH ON SH.HEADQUARTERS_ID = WG.HEADQUARTERS_ID
		        WHERE 
		        	WG.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
			</cfquery>
		</cfif>
		<cfquery name="GET_MONEY" datasource="#DSN#">
			SELECT
				MONEY
			FROM
				SETUP_MONEY
			WHERE
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
				MONEY_STATUS = 1
			ORDER BY
				MONEY DESC
		</cfquery>
		<cfif len(attributes.workgroup_id)>
			<cfquery name="GET_PROJECT" datasource="#DSN#">
				SELECT 
					PRO_PROJECTS.PROJECT_HEAD,
					PRO_PROJECTS.PROJECT_ID 
				FROM 
					PRO_PROJECTS
					INNER JOIN WORK_GROUP ON PRO_PROJECTS.PROJECT_ID = WORK_GROUP.PROJECT_ID
				WHERE 
					WORK_GROUP.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
			</cfquery>
		</cfif>
		<cfquery name="GET_EMPS" datasource="#DSN#">
			SELECT 
		    	WEP.WRK_ROW_ID, 
		        WEP.WORKGROUP_ID, 
		        WEP.PARTNER_ID, 
		        WEP.EMPLOYEE_ID, 
		        WEP.POSITION_CODE, 
		        WEP.ROLE_ID, 
		        WEP.PROJECT_ID, 
		        WEP.CONSUMER_ID, 
		        WEP.COMPANY_ID, 
		        WEP.OUR_COMPANY_ID, 
		        WEP.HIERARCHY, 
		        WEP.ROLE_HEAD, 
		        WEP.IS_REAL, 
		        WEP.UPPER_ROW_ID, 
		        WEP.IS_CRITICAL, 
		        WEP.IS_ORG_VIEW, 
		        WEP.PRODUCT_ID, 
		        WEP.PRODUCT_UNIT_PRICE, 
		        WEP.PRODUCT_MONEY, 
		        WEP.PRODUCT_UNIT, 
		        WEP.RECORD_EMP, 
		        WEP.RECORD_IP, 
		        WEP.RECORD_DATE, 
		        WEP.UPDATE_EMP, 
		        WEP.UPDATE_IP,
		        WEP.UPDATE_DATE,
		        SPR.PROJECT_ROLES
		    FROM 
		    	WORKGROUP_EMP_PAR WEP
		    	LEFT JOIN SETUP_PROJECT_ROLES SPR ON SPR.PROJECT_ROLES_ID = WEP.ROLE_ID
		    WHERE 
			    WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
		    ORDER BY 
		    	HIERARCHY
		</cfquery>
		<cfif attributes.workgroup_module is 'objects'>
			<cfset work_group_row=get_emps.recordcount>
		</cfif>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add_worker2'>
	<cfset upper_hierarchy = ''>
	<cfset upper_name = ''>
	<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
		<cfquery name="CATEGORY" datasource="#dsn#">
			SELECT 
				HIERARCHY,
				WORKGROUP_NAME
			FROM 
				WORK_GROUP 
			WHERE 
				WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
		</cfquery>
		<cfset upper_hierarchy = category.hierarchy>
	<cfelse>
		<cfinclude template="../query/get_workgroup_uppers.cfm">
	</cfif>
	<cfif isdefined("attributes.upper_row_id")>
		<cfquery name="upper_rol" datasource="#dsn#">
			SELECT EMPLOYEE_ID,HIERARCHY,PARTNER_ID,ROLE_HEAD FROM WORKGROUP_EMP_PAR WHERE WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_row_id#">
		</cfquery>
		<cfset upper_hierarchy = upper_rol.hierarchy>
		<cfif len(upper_rol.employee_id)>
			<cfset upper_name = upper_rol.role_head & ' ' & get_emp_info(upper_rol.employee_id,0,0)>
		<cfelseif len(upper_rol.partner_id)>
			<cfset upper_name = upper_rol.role_head & ' ' & get_par_info(upper_rol.partner_id,1,1,0)>
		<cfelse>
			<cfset upper_name = upper_rol.role_head>
		</cfif>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_worker2'>
	<cfset upper_name = ''>
	<cfquery name="CATEGORY" datasource="#dsn#">
		SELECT 
			WG.HIERARCHY AS WORKGROUP_HIERARCHY,
			WG.WORKGROUP_NAME,
			WEP.IS_REAL,
			WEP.IS_CRITICAL,
			WEP.IS_ORG_VIEW,
			WEP.ROLE_HEAD,
			WEP.EMPLOYEE_ID,
			WEP.CONSUMER_ID,
			WEP.COMPANY_ID,
			WEP.PARTNER_ID,
			WEP.ROLE_ID,
			WEP.WORKGROUP_ID,
			WEP.UPPER_ROW_ID,
			WEP.ORDER_NO,
			WEP.WRK_ROW_ID,
			WEP.RECORD_DATE,
			WEP.RECORD_EMP,
			WEP.UPDATE_DATE,
			WEP.UPDATE_EMP,
			WEP.HIERARCHY
		FROM 
			WORK_GROUP WG
			INNER JOIN WORKGROUP_EMP_PAR WEP ON WG.WORKGROUP_ID=WEP.WORKGROUP_ID
		WHERE 
			WEP.WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.wrk_row_id#">
	</cfquery>
	
	<cfquery name="CATEGORY_ALTS" datasource="#dsn#" maxrows="1">
		SELECT 
			WG.HIERARCHY AS WORKGROUP_HIERARCHY,
			WG.WORKGROUP_NAME,
			WEP.WORKGROUP_ID
		FROM 
			WORK_GROUP WG
			INNER JOIN WORKGROUP_EMP_PAR WEP ON WG.WORKGROUP_ID = WEP.WORKGROUP_ID
		WHERE 
			WEP.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#category.hierarchy#.%">
	</cfquery>
	<cfset upper_hierarchy = '#category.workgroup_hierarchy#'>
	
	<cfif len(category.upper_row_id)>
		<cfquery name="upper_rol" datasource="#dsn#">
			SELECT HIERARCHY,EMPLOYEE_ID,ROLE_HEAD,PARTNER_ID FROM WORKGROUP_EMP_PAR WHERE WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#category.upper_row_id#">
		</cfquery>
		<cfset upper_hierarchy = upper_rol.hierarchy>
		<cfif len(upper_rol.employee_id)>
			<cfset upper_name = upper_rol.role_head & ' ' & get_emp_info(upper_rol.employee_id,0,0)>
		<cfelseif len(upper_rol.partner_id)>
			<cfset upper_name = upper_rol.role_head & ' ' & get_par_info(upper_rol.partner_id,1,1,0)>
		<cfelse>
			<cfset upper_name = upper_rol.role_head>
		</cfif>
	</cfif>
	<cfset aa=len(category.hierarchy)-len(upper_hierarchy)>
	<cfif aa lt 0>
		<cfset aa=0>
	</cfif>
	<cfset my_hierarchy = mid(category.hierarchy,len(upper_hierarchy)+2,aa)>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		function add_work(id,name)
		{
			<cfif isdefined("attributes.field_name")>
				opener.<cfoutput>#field_name#</cfoutput>.value = name;
			</cfif>
			<cfif isdefined("attributes.field_id")>
				opener.<cfoutput>#field_id#</cfoutput>.value = id;
			</cfif>
			window.close();
		}
		function showDepartment(branch_id)	
		{
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'department_place',1,'İlişkili Departmanlar');
			}
		}
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add_workgroup' or attributes.event is 'upd_workgroup')>
		<cfif attributes.event is 'upd_workgroup' and attributes.workgroup_module is 'objects'>
			$(document).ready(function() {
				row_count=<cfoutput>#work_group_row#</cfoutput>;
				$('#record').val(row_count);
			});
			function add_row(code)
			{
				if (code == undefined) code = "";
				row_count++;
				var newRow;
				var newCell;
				$('#record').val(row_count);
				newRow = document.getElementById("work_group").insertRow(document.getElementById("work_group").rows.length);	
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="code'+ row_count +'" value="'+code+'" style="width:50px;">';
						
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="member_name'+ row_count +'" value="" readonly="yes" style="width:110px;"><input type="hidden" name="consumer_id'+ row_count +'" value=""><input type="hidden" name="company_id'+ row_count +'" value=""><input type="hidden" name="partner_id'+ row_count +'" value=""><input type="hidden" name="member_type'+ row_count +'" value=""><input type="hidden" name="employee_id'+ row_count +'" value=""><a href="javascript://" onClick="pencere_ac1('+ row_count +');" style="cursor:pointer;">&nbsp;&nbsp;<img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="Üye Seç"></a>';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="role_head'+ row_count +'" value="" style="width:100px;" maxlength="100"><input type="hidden" name="role_id'+ row_count +'" value=""><a href="javascript://" onClick="pencere_ac2('+ row_count +');" style="cursor:pointer;"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="Rol Seç"></a>';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" value="" name="product' + row_count +'" style="width:100px;"><input type="hidden" name="stock_id' + row_count +'"><input type="hidden" name="product_id' + row_count +'">&nbsp;<a href="javascript://" onClick="pencere_ac_product(' + row_count + ');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
			
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="unit_name' + row_count +'" value="" readonly style="width:40px;">';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="price' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));"  style="width:80px;">';
						
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="money_type' + row_count +'" style="width:50px;"><cfoutput query="get_money"><option value="#get_money.money#">#get_money.money#</option></cfoutput></select>';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<a href="javascript://" onClick="copy_row('+row_count+');"><img src="images/shema_list.gif" alt="Grafik" border="0" align="absmiddle"></a> ';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count + '"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img src="images/delete_list.gif" alt="Sil" border="0" align="absmiddle"></a>';
			}
			function copy_row(no)
			{	
				code = eval('add_workgroup.code' + no).value;
				add_row(code);
			}
			function pencere_ac1(no)
			{
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_consumer=add_workgroup.consumer_id'+no+'&field_comp_id=add_workgroup.company_id'+no+'&field_partner=add_workgroup.partner_id'+no+'&field_name=add_workgroup.member_name'+no+'&field_emp_id=add_workgroup.employee_id'+no+'&field_type=add_workgroup.member_type'+no+'&select_list=1,2,3'</cfoutput>,'list','popup_list_positions');
			}
			function pencere_ac2(no)
			{
				windowopen('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popup_list_position_names&field_name=add_workgroup.role_head'+no+'</cfoutput>','List','popup_list_position_names');
			}
			function pencere_ac_product(no)
			{
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_price_unit&field_stock_id=add_workgroup.stock_id'+ no +'&field_id=add_workgroup.product_id'+ no +'&field_name=add_workgroup.product'+ no +'&field_unit=add_workgroup.unit_name'+ no+'&field_price=add_workgroup.price'+ no+'&field_money=add_workgroup.money_type'+ no +''</cfoutput>,'medium','popup_product_price_unit');
			}
			function grafik_ciz()
			{
				windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_draw_workgroup&workgroup_id=#attributes.workgroup_id#'</cfoutput>,'list','popup_draw_workgroup');
			}
			function fiyat_hesapla(satir)
			{
				if($("#price"+satir).val().length != 0 && $("#amount"+satir).val().length != 0)
				{
					eval("add_workgroup.total_price" + satir).value =  filterNum(eval("document.add_workgroup.price"+satir).value) * filterNum(eval("document.add_workgroup.amount"+satir).value);
					eval("add_workgroup.total_price" + satir).value = commaSplit(eval("add_workgroup.total_price" + satir).value);
				}
				return true;
			}
			function sil(no)
			{	
			
				$("#row_kontrol"+no).val(0);
				var my_element=$("#frm_row"+no).css('display','none');
			}
		
			function control()
			{
				if(row_count == 0)
				{
					alert("En Az Bir Grup Çalışan Kaydı Giriniz!");
					return false;
				}
				for(row_=1; row_<=row_count; row_++)
				{
					if($("#row_kontrol"+row_).val() == 1)
					{
						if($("#member_name"+row_).val() == "")
						{
							alert("Görevli İsimlerini Kontrol Ediniz!!");
							return false;
						}
						if($("#product"+row_).val() == "")
						{
							alert("Hizmet/Ürün Seçiniz!");
							return false;
						}
					}
				}
				return true;
			}
		<cfelse>
			function kontrol()
			{
				if($("#manager_pos_code").val() == "" || $("#manager_position").val() == "")
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1714.Yönetici'>");
					return false;
				}
				return true;
			}
		</cfif>
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add_worker2' or attributes.event is 'upd_worker2')>
		function rol_getir()
		{
			if($('#workgroup_hierarchy').val() == '')
			{
				alert("<cf_get_lang no ='1008.Önce İş Grubu Seçiniz'>");
				return false;
			}
			<cfif attributes.event is 'add_worker2'>
				<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
					my_workgroup_id = $('#workgroup_id').val();
				<cfelse>
					var run_query = wrk_safe_query('hr_wrk_grp','dsn',0,document.worker.upper_hierarchy.value);
					my_workgroup_id = run_query.WORKGROUP_ID;
				</cfif>
				windowopen('<cfoutput>#request.self#?fuseaction=#attributes.workgroup_module#.popup_list_upper_roles&upper_rol_id=worker.upper_row_id&upper_rol_head=worker.upper_role_head&hierarchy_code=worker.hierarchy1_code&workgroup_id=</cfoutput>'+my_workgroup_id,'list');
			<cfelse>
				my_workgroup_id = document.worker.workgroup_id.value;
				windowopen('<cfoutput>#request.self#?fuseaction=#attributes.workgroup_module#.popup_list_upper_roles&upper_rol_id=worker.upper_row_id&upper_rol_head=worker.upper_role_head&hierarchy_code=worker.hierarchy1_code&workgroup_id=</cfoutput>'+my_workgroup_id+'&aktif_hierarchy='+document.worker.old_hierarchy_code.value,'list');
			</cfif>
		}
		<cfif attributes.event is 'add_worker2'>
			a = "";
			<cfif not (isdefined("attributes.workgroup_id") and len(attributes.workgroup_id))>
				function gonder_code()
				{
					a = document.worker.upper_hierarchy[document.worker.upper_hierarchy.selectedIndex].value;
					document.worker.hierarchy1_code.value = a 
					document.worker.workgroup_hierarchy.value = a;
				}
			</cfif>
			function kontrol()
			{
				if ($('#member_name').val() == "")
				{
					alert("<cf_get_lang no='1268.Çalışan Seçmediniz Lütfen Kontrol Ediniz'>");
					return false;
				}
		
				<cfif not (isdefined("attributes.workgroup_id") and len(attributes.workgroup_id))>
					a = document.worker.upper_hierarchy[document.worker.upper_hierarchy.selectedIndex].value;
					if(a == "")
					{
						alert("<cf_get_lang no='1007.İş Grubu Seçiniz'>!");
						return false;
					}
				</cfif>
				return true;
			}
		<cfelseif attributes.event is 'upd_worker2'>
			function kontrol_et()
			{
				if ($('#member_name').val() == "")
				{
					alert("<cf_get_lang no='1268.Çalışan Seçmediniz Lütfen Kontrol Ediniz'>");
					return false;
				}
			<cfif fusebox.circuit is not 'service'>
				if(document.worker.is_org_view.checked==false)
				{
					if(confirm("<cf_get_lang no ='1304.Organizasyonda Görünmesin Seçerseniz Tüm Alt Pozisyonlarda Bu Özellik Kaldırılacak Emin misiniz'>")) return true; return false;
				}
			</cfif>
			return true;
			}
		</cfif>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_workgroup';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_workgroup.cfm';
	
	WOStruct['#attributes.fuseaction#']['add_workgroup'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_workgroup']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add_workgroup']['fuseaction'] = 'hr.list_workgroup';
	WOStruct['#attributes.fuseaction#']['add_workgroup']['filePath'] = 'hr/form/form_add_workgroups.cfm';
	WOStruct['#attributes.fuseaction#']['add_workgroup']['queryPath'] = 'hr/query/add_workgroup.cfm';
	WOStruct['#attributes.fuseaction#']['add_workgroup']['nextEvent'] = '#fusebox.circuit#.list_workgroup&event=upd_workgroup';
	
	WOStruct['#attributes.fuseaction#']['add_worker2'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_worker2']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add_worker2']['fuseaction'] = 'hr.list_workgroup';
	WOStruct['#attributes.fuseaction#']['add_worker2']['filePath'] = 'hr/form/form_add_worker2.cfm';
	WOStruct['#attributes.fuseaction#']['add_worker2']['queryPath'] = 'hr/query/add_worker2.cfm';
	WOStruct['#attributes.fuseaction#']['add_worker2']['nextEvent'] = '#fusebox.circuit#.list_workgroup&event=upd_workgroup';
	WOStruct['#attributes.fuseaction#']['add_worker2']['Identity'] = '##category.workgroup_name##';
	
	WOStruct['#attributes.fuseaction#']['upd_workgroup'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_workgroup']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd_workgroup']['fuseaction'] = 'hr.list_workgroup';
	WOStruct['#attributes.fuseaction#']['upd_workgroup']['filePath'] = 'hr/form/form_upd_workgroups.cfm';
	WOStruct['#attributes.fuseaction#']['upd_workgroup']['queryPath'] = 'hr/query/upd_workgroup.cfm';
	WOStruct['#attributes.fuseaction#']['upd_workgroup']['nextEvent'] = '#fusebox.circuit#.list_workgroup&event=upd_workgroup';
	WOStruct['#attributes.fuseaction#']['upd_workgroup']['parameters'] = 'workgroup_id=##attributes.workgroup_id##';
	WOStruct['#attributes.fuseaction#']['upd_workgroup']['Identity'] = '##get_category.workgroup_name##';
	
	WOStruct['#attributes.fuseaction#']['upd_worker2'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_worker2']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd_worker2']['fuseaction'] = 'hr.list_workgroup';
	WOStruct['#attributes.fuseaction#']['upd_worker2']['filePath'] = 'hr/form/form_upd_worker2.cfm';
	WOStruct['#attributes.fuseaction#']['upd_worker2']['queryPath'] = 'hr/query/upd_worker2.cfm';
	WOStruct['#attributes.fuseaction#']['upd_worker2']['nextEvent'] = '#fusebox.circuit#.list_workgroup&event=upd_worker2';
	WOStruct['#attributes.fuseaction#']['upd_worker2']['parameters'] = 'workgroup_id=##attributes.workgroup_id##';
	WOStruct['#attributes.fuseaction#']['upd_worker2']['Identity'] = '##category.workgroup_name##';
	
	if(not attributes.event is 'add_workgroup')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_workgroup';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_workgroup.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_workgroup.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_workgroup';
	}
	
	if(attributes.event is 'upd_worker2')
	{
		WOStruct['#attributes.fuseaction#']['del_worker2'] = structNew();
		WOStruct['#attributes.fuseaction#']['del_worker2']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del_worker2']['fuseaction'] = 'hr.list_workgroup';
		WOStruct['#attributes.fuseaction#']['del_worker2']['filePath'] = 'hr/query/del_worker_emp.cfm';
		WOStruct['#attributes.fuseaction#']['del_worker2']['queryPath'] = 'hr/query/del_worker_emp.cfm';
		WOStruct['#attributes.fuseaction#']['del_worker2']['nextEvent'] = 'hr.list_workgroup';
	}
	
	if(attributes.event is 'upd_workgroup')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_workgroup'] = structNew();
		if (fusebox.circuit is not 'service')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_workgroup']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_workgroup']['menus'][0]['text'] = '#lang_array.item[1302]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_workgroup']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_draw_workgroup&workgroup_id=#attributes.workgroup_id#','list');";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_workgroup']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_workgroup']['icons']['add_workgroup']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_workgroup']['icons']['add_workgroup']['href'] = "#request.self#?fuseaction=hr.list_workgroup&event=add_workgroup&workgroup_module=#attributes.workgroup_module#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_workgroup']['icons']['add_workgroup']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if (attributes.event is 'upd_worker2')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_worker2'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_worker2']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_worker2']['icons']['add_worker']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_worker2']['icons']['add_worker']['href'] = "#request.self#?fuseaction=hr.list_workgroup&event=add_worker2&workgroup_module=#attributes.workgroup_module#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_worker2']['icons']['add_worker']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
