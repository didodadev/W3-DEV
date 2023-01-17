<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<style>
		#btnNext, #btnPrev, #btnNextLast, #btnPrevLast { display:none; }
	</style>
	<cf_get_lang_set module_name="ehesap">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.department" default="">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.page" default="1">
	<cfscript>
		include "../hr/ehesap/query/get_all_branches.cfm";
		include "../hr/ehesap/query/get_code_cat.cfm";
		bu_ay_basi = CreateDate(year(now()),month(now()),1);
		bu_ay_sonu = DaysInMonth(bu_ay_basi);
		cmp = createObject("component","hr.ehesap.cfc.periods_to_in_out");
		get_acc_type = cmp.setup_acc_type();
		cmp_department = createObject("component","hr.cfc.get_departments");
		cmp_department.dsn = dsn;
		get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
	</cfscript>
	<cfparam name="attributes.startdate" default="#date_add('m',-1,bu_ay_basi)#"> 
	<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
	<cfif isdefined("attributes.is_submit") and len(attributes.branch_id)>
		<cf_date tarih="attributes.startdate">
		<cf_date tarih="attributes.finishdate">
		<cfquery name="get_position" datasource="#dsn#">
			SELECT
				E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE_NAME,
				E.EMPLOYEE_ID,
				EIO.IN_OUT_ID,
				D.DEPARTMENT_HEAD,
				B.BRANCH_NAME,
				ISNULL(EP.POSITION_NAME,'') POSITION_NAME,
				ISNULL(EIOP.ACCOUNT_BILL_TYPE,'') ACCOUNT_BILL_TYPE,
				ISNULL(EIOP.EXPENSE_CENTER_ID,'') EXPENSE_CENTER_ID,
				ISNULL(EIOP.EXPENSE_CODE,'') EXPENSE_CODE,
				ISNULL(EIOP.EXPENSE_CODE_NAME,'') EXPENSE_CODE_NAME,
				ISNULL(EIOP.EXPENSE_ITEM_ID,'') EXPENSE_ITEM_ID,
				ISNULL(EIOP.EXPENSE_ITEM_NAME,'') EXPENSE_ITEM_NAME
				<cfif get_acc_type.recordcount>
					<cfoutput query="get_acc_type">
						,ISNULL(ACC_CODE_#currentrow#.ACCOUNT_CODE,'') AS ACCOUNT_CODE_#currentrow#
						,ISNULL(ACC_CODE_#currentrow#.ACCOUNT_NAME,'') AS ACCOUNT_NAME_#currentrow#
						,ISNULL(ACC_CODE_#currentrow#.ACC_TYPE_ID,'#acc_type_id#') AS ACC_TYPE_ID_#currentrow#
					</cfoutput>
				</cfif>
			FROM
				EMPLOYEES_IN_OUT EIO
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID=EIO.EMPLOYEE_ID
				LEFT JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.IS_MASTER = 1
				INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID=EIO.DEPARTMENT_ID
				INNER JOIN BRANCH B ON D.BRANCH_ID=B.BRANCH_ID
				LEFT JOIN EMPLOYEES_IN_OUT_PERIOD EIOP ON EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				<cfif get_acc_type.recordcount>
					<cfoutput query="get_acc_type">
						LEFT JOIN (
							SELECT AP.ACCOUNT_CODE,AP.ACCOUNT_NAME,EA.IN_OUT_ID,EA.EMPLOYEE_ID,EA.ACC_TYPE_ID FROM <cfif fusebox.use_period>#dsn2_alias#.ACCOUNT_PLAN<cfelse>ACCOUNT_PLAN</cfif> AP INNER JOIN EMPLOYEES_ACCOUNTS EA ON AP.ACCOUNT_CODE = EA.ACCOUNT_CODE WHERE EA.PERIOD_ID = #session.ep.period_id# AND EA.ACC_TYPE_ID = #get_acc_type.acc_type_id#
						) AS ACC_CODE_#currentrow# ON ACC_CODE_#currentrow#.IN_OUT_ID = EIO.IN_OUT_ID AND ACC_CODE_#currentrow#.EMPLOYEE_ID = E.EMPLOYEE_ID
					</cfoutput>
				</cfif>
			WHERE
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
				AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
				<cfif len(attributes.department)>
					AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
				</cfif>
			ORDER BY
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
		</cfquery>
	<cfelse>
		<cfset get_position.recordcount=0>
	</cfif>
	<cfscript>
		attributes.totalrecords = get_position.recordcount;
		position_json = '';
		
		if (get_position.recordcount)
		{
			position_json = replace(serializeJson(get_position),'//','');
			position_array = deserializeJSON(position_json).data;
			colList = ArrayToList(deserializeJSON(position_json).COLUMNS);
			inoutid_idx = ListFind(colList, "IN_OUT_ID");
			empname_idx = ListFind(colList, "EMPLOYEE_NAME");
			empid_idx = ListFind(colList, "EMPLOYEE_ID");
			posname_idx = ListFind(colList, "POSITION_NAME");
			accbilltype_idx = ListFind(colList, "ACCOUNT_BILL_TYPE");
			expcenterid_idx = ListFind(colList, "EXPENSE_CENTER_ID");
			expcode_idx = ListFind(colList, "EXPENSE_CODE");
			expcodename_idx = ListFind(colList, "EXPENSE_CODE_NAME");
			expitemid_idx = ListFind(colList, "EXPENSE_ITEM_ID");
			expitemname_idx = ListFind(colList, "EXPENSE_ITEM_NAME");
			if (get_acc_type.recordcount)
			{
				for (i=1;i lte get_acc_type.recordcount; i++)
				{
					"acccode#i#_idx" = ListFind(colList, "ACCOUNT_CODE_#i#");
					"accname#i#_idx" = ListFind(colList, "ACCOUNT_NAME_#i#");
					"acctypeid#i#_idx" = ListFind(colList, "ACC_TYPE_ID_#i#");
				}
			}
		}
		else
		{
			empname_idx = '';
			posname_idx = '';
			accbilltype_idx = '';
			expcodename_idx = '';
			expitemname_idx = '';
			expcenterid_idx = '';
			expitemid_idx = '';
			expcode_idx = '';
			if (get_acc_type.recordcount)
			{
				for (i=1;i lte get_acc_type.recordcount; i++)
				{
					"acccode#i#_idx" = '';
					"accname#i#_idx" = '';
					"acctypeid#i#_idx" = '';
				}
			}
		}
	</cfscript>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			<cfif isdefined("attributes.is_submit")>
				row_count=<cfoutput>#get_position.recordcount#</cfoutput>;
			<cfelse>
				row_count=0;
			</cfif>
			$("#btnNext,#btnNextLast, #btnPrev, #btnPrevLast").bind("click", showBasketItems);
			jsonData = jQuery.parseJSON('<cfoutput>#position_json#</cfoutput>');
			if (jsonData)
			{
				jsonData.scrollIndex = 0;
				jsonData.pageSize = parseFloat('<cfoutput>#attributes.maxrows#</cfoutput>');
				showBasketItems();
			}
		});
		
		function send_json()
		{
			$.ajax({
				type:"post",
				url: "/V16/hr/ehesap/cfc/add_period_account_all.cfc?method=add_period",
				data: JSON.stringify(jsonData),
				cache:false,
				async: false,
				contentType: "application/json",
				success: function(dataread) {
					if (dataread)
						location.reload();
				},
		        error: function(xhr, opt, err)
				{
					alert(err.toString());
				}
	        });
		}
		
		function change_value(row,column,val)
		{
			jsonData.DATA[row][column-1] = val;
		}
		
		function change_cell(row,column,id,column2,id2,column3,id3)
		{
			change_value(row,column,$('#'+id+row).val());
			if (column2 > 0 && id2.length)
				change_value(row,column2,$('#'+id2+row).val());
			if (column3 > 0 && id3.length)
				change_value(row,column3,$('#'+id3+row).val());
		}
		
		function hepsi(satir,nesne,column,baslangic)
		{
			deger=$('#'+nesne);
			for(var i=jsonData.scrollIndex;i<Math.min(jsonData.DATA.length, jsonData.scrollIndex + jsonData.pageSize);i++)
			{
				nesne_=$('#'+nesne+i);
				nesne_.val(deger.val());
				jsonData.DATA[i][column-1] = deger.val();
			}
		}
		
		function expense_code_doldur(expcode_idx,expcodename_idx,expcenterid_idx)
		{
			if(document.getElementById('expense_center_id').value != "" && document.getElementById('expense_code').value != "" && document.getElementById('expense_code_name').value != "")
			{
				hepsi(row_count,'expense_code',expcode_idx);
				hepsi(row_count,'expense_code_name',expcodename_idx);
				hepsi(row_count,'expense_center_id',expcenterid_idx);
			}
		}
		
		function expense_code_bosalt(expcode_idx,expcodename_idx,expcenterid_idx)
		{
			document.getElementById('expense_center_id').value = '';
			document.getElementById('expense_code').value = '';
			document.getElementById('expense_code_name').value = '';
			hepsi(row_count,'expense_code',expcode_idx);
			hepsi(row_count,'expense_code_name',expcodename_idx);
			hepsi(row_count,'expense_center_id',expcenterid_idx);
		}
		
		function expense_item_doldur(expitemid_idx,expitemname_idx)
		{
			if(document.getElementById('expense_item_id').value != "" && document.getElementById('expense_item_name').value != "")
			{
				hepsi(row_count,'expense_item_id',expitemid_idx);
				hepsi(row_count,'expense_item_name',expitemname_idx);
			}
		}
		
		function expense_item_bosalt(expitemid_idx,expitemname_idx)
		{
			document.getElementById('expense_item_id').value = '';
			document.getElementById('expense_item_name').value = '';
			hepsi(row_count,'expense_item_id',expitemid_idx);
			hepsi(row_count,'expense_item_name',expitemname_idx);
		}
		
		function account_code_doldur(id_deger,accode_idx,accname_idx)
		{
			if($("#account_code_"+id_deger+"_").val() != "" && $("#account_name_"+id_deger+"_").val() != "")
			{
				deger1 = "account_code_"+id_deger+"_";
				hepsi(row_count,deger1,accode_idx);
				deger2 = "account_name_"+id_deger+"_";
				hepsi(row_count,deger2,accname_idx);
			}
		}
		
		function account_code_bosalt(id_deger,accode_idx,accname_idx)
		{
			$("#account_code_"+id_deger+"_").val('');
			$("#account_name_"+id_deger+"_").val('');
			deger1 = "account_code_"+id_deger+"_";
			hepsi(row_count,deger1,accode_idx);
			deger2 = "account_name_"+id_deger+"_";
			hepsi(row_count,deger2,accname_idx);
		}
		
		function showDepartment(branch_id)	
		{
			var branch_id = document.getElementById("branch_id").value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,"<cf_get_lang no='1376.İlişkili Departmanlar'>");
			}
		}
		
		function search_kontrol()
		{
			var branch_id = document.getElementById("branch_id").value;
			if(branch_id == "")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='41.Şube'>");
				return false;
			}
			else{return true;}
		}
		
		//position_array - jsonData
		function showBasketItems(e)
		{
			if (e != null && $(e.target).attr("id") == "btnNext") jsonData.scrollIndex = Math.min(jsonData.DATA.length - jsonData.pageSize, jsonData.scrollIndex + jsonData.pageSize);
			if (e != null && $(e.target).attr("id") == "btnNextLast") jsonData.scrollIndex = jsonData.DATA.length - jsonData.pageSize;
	        if (e != null && $(e.target).attr("id") == "btnPrev") jsonData.scrollIndex = Math.max(0, jsonData.scrollIndex - jsonData.pageSize);
	        if (e != null && $(e.target).attr("id") == "btnPrevLast") jsonData.scrollIndex = 0;
	        if (e != null && ($(e.target).attr("id") == "btnNext" || $(e.target).attr("id") == "btnPrev" || $(e.target).attr("id") == "btnPrevLast" || $(e.target).attr("id") == "btnNextLast"))
	        {
	        	$('#period_code_cat').val('');
	        	$('#expense_center_id').val('');
	        	$('#expense_code').val('');
	        	$('#expense_code_name').val('');
	        	$('#expense_item_id').val('');
	        	$('#expense_item_name').val('');
	        	<cfif get_acc_type.recordcount>
		        	<cfloop query="get_acc_type">
		        		$('#account_code_<cfoutput>#get_acc_type.currentrow#</cfoutput>_').val('');
		        		$('#account_name_<cfoutput>#get_acc_type.currentrow#</cfoutput>_').val('');
		        	</cfloop>
		        </cfif>
	        }
	        
	        if((jsonData.scrollIndex+jsonData.pageSize) >= jsonData.DATA.length)
	        {
				$("#btnNext").attr('disabled', 'disabled');
				$("#btnNextLast").attr('disabled', 'disabled');
			}
			else
			{
				$("#btnNext").removeAttr("disabled");
				$("#btnNextLast").removeAttr("disabled");
			}
				
			if(jsonData.scrollIndex == 0)
			{
				$("#btnPrev").attr('disabled', 'disabled');
				$("#btnPrevLast").attr('disabled', 'disabled');
			}
			else
			{
				$("#btnPrev").removeAttr("disabled");
				$("#btnPrevLast").removeAttr("disabled");
			}
	        
	        $("#tblBasket tr[ItemRow]").remove();
	        
			if (jsonData.DATA.length)
			{
				for (var i = jsonData.scrollIndex; i < Math.min(jsonData.DATA.length, jsonData.scrollIndex + jsonData.pageSize); i++)
				{
					$("#tblBasket").append($("#basketItemBase").html());
					var item = $("#tblBasket tr[ItemRow]").last();
					var data = jsonData.DATA[i];
					$(item).attr("itemIndex", i);
					$(item).find("#expense_code_name").attr('id','expense_code_name'+i);
					$(item).find("#expense_code_name"+i).attr('name','expense_code_name'+i);
					$(item).find("#expense_code").attr('id','expense_code'+i);
					$(item).find("#expense_code"+i).attr('name','expense_code'+i);
					$(item).find("#expense_center_id").attr('id','expense_center_id'+i);
					$(item).find("#expense_center_id"+i).attr('name','expense_center_id'+i);
					$(item).find("#exp_code_img").attr('id','exp_code_img'+i);
					$(item).find("#exp_code_img"+i).attr('name','exp_code_img'+i);
					$(item).find("#expense_item_id").attr('id','expense_item_id'+i);
					$(item).find("#expense_item_id"+i).attr('name','expense_item_id'+i);
					$(item).find("#exp_item_img").attr('id','exp_item_img'+i);
					$(item).find("#exp_item_img"+i).attr('name','exp_item_img'+i);
					$(item).find("#expense_item_name").attr('id','expense_item_name'+i);
					$(item).find("#expense_item_name"+i).attr('name','expense_item_name'+i);
					$(item).find("#period_code_cat").attr('id','period_code_cat'+i);
					$(item).find("#period_code_cat"+i).attr('name','period_code_cat'+i);
					$(item).find("#period_code_cat"+i).attr('onchange','change_value('+i+',<cfoutput>#accbilltype_idx#</cfoutput>,this.value)');
					$(item).find("#rowNr").text(i + 1);
					$(item).find("#empName").text(jsonData.DATA[i][<cfoutput>#empname_idx#</cfoutput>- 1]);
					$(item).find("#posName").text(jsonData.DATA[i][<cfoutput>#posname_idx#</cfoutput>- 1]);
					$(item).find("#period_code_cat"+i).val(jsonData.DATA[i][<cfoutput>#accbilltype_idx#</cfoutput>- 1]);
					$(item).find("#expense_code_name"+i).val(jsonData.DATA[i][<cfoutput>#expcodename_idx#</cfoutput>- 1]);
					$(item).find("#expense_center_id"+i).val(jsonData.DATA[i][<cfoutput>#expcenterid_idx#</cfoutput>- 1]);
					$(item).find("#expense_item_id"+i).val(jsonData.DATA[i][<cfoutput>#expitemid_idx#</cfoutput>- 1]);
					$(item).find("#expense_code"+i).val(jsonData.DATA[i][<cfoutput>#expcode_idx#</cfoutput>- 1]);
					$(item).find("#expense_item_name"+i).val(jsonData.DATA[i][<cfoutput>#expitemname_idx#</cfoutput>- 1]);
					$(item).find("#exp_code_img"+i).attr('onclick',"windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=expense_center_id"+i+"&field_code=expense_code"+i+"&field_acc_code_name=expense_code_name"+i+"&call_function=change_cell("+i+",<cfoutput>#expcodename_idx#</cfoutput>,\\'expense_code_name\\',<cfoutput>#expcode_idx#</cfoutput>,\\'expense_code\\',<cfoutput>#expcenterid_idx#</cfoutput>,\\'expense_center_id\\');','list');");
					$(item).find("#exp_item_img"+i).attr('onclick',"windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=expense_item_id"+i+"&field_acc_name=expense_item_name"+i+"&function_name=change_cell("+i+",<cfoutput>#expitemname_idx#</cfoutput>,\\'expense_item_name\\',<cfoutput>#expitemid_idx#</cfoutput>,\\'expense_item_id\\');','list');");
					<cfloop query="get_acc_type">
						$(item).find("#account_name_<cfoutput>#currentrow#</cfoutput>").attr('id','account_name_<cfoutput>#currentrow#</cfoutput>_'+i);
						$(item).find("#account_name_<cfoutput>#currentrow#</cfoutput>_"+i).attr('name','account_name_<cfoutput>#currentrow#</cfoutput>_'+i);
						$(item).find("#account_name_<cfoutput>#currentrow#</cfoutput>_"+i).val(jsonData.DATA[i][<cfoutput>#Evaluate('accname#currentrow#_idx')#</cfoutput> - 1]);
						$(item).find("#acc_type_id_<cfoutput>#currentrow#</cfoutput>").attr('id','acc_type_id_<cfoutput>#currentrow#</cfoutput>_'+i);
						$(item).find("#acc_type_id_<cfoutput>#currentrow#</cfoutput>_"+i).attr('name','acc_type_id_<cfoutput>#currentrow#</cfoutput>_'+i);
						$(item).find("#acc_type_id_<cfoutput>#currentrow#</cfoutput>_"+i).val(jsonData.DATA[i][<cfoutput>#Evaluate('acctypeid#currentrow#_idx')#</cfoutput> - 1]);
						$(item).find("#account_code_<cfoutput>#currentrow#</cfoutput>").attr('id','account_code_<cfoutput>#currentrow#</cfoutput>_'+i);
						$(item).find("#account_code_<cfoutput>#currentrow#</cfoutput>_"+i).attr('name','account_code_<cfoutput>#currentrow#</cfoutput>_'+i);
						$(item).find("#account_code_<cfoutput>#currentrow#</cfoutput>_"+i).val(jsonData.DATA[i][<cfoutput>#Evaluate('acccode#currentrow#_idx')#</cfoutput> - 1]);
						$(item).find("#acc_code_img_<cfoutput>#currentrow#</cfoutput>_").attr('id','acc_code_img_<cfoutput>#currentrow#</cfoutput>_'+i);
						$(item).find("#acc_code_img_<cfoutput>#currentrow#</cfoutput>_"+i).attr('name','acc_code_img_<cfoutput>#currentrow#</cfoutput>_'+i);
						$(item).find("#acc_code_img_<cfoutput>#currentrow#</cfoutput>_"+i).attr('onclick',"windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=account_name_<cfoutput>#currentrow#</cfoutput>_"+i+"&field_id=account_code_<cfoutput>#currentrow#</cfoutput>_"+i+"&function_name=change_cell("+i+",<cfoutput>#Evaluate('accname#currentrow#_idx')#</cfoutput>,\\'account_name_<cfoutput>#currentrow#</cfoutput>_\\',<cfoutput>#Evaluate('acccode#currentrow#_idx')#</cfoutput>,\\'account_code_<cfoutput>#currentrow#</cfoutput>_\\',<cfoutput>#Evaluate('acctypeid#currentrow#_idx')#</cfoutput>,\\'acc_type_id_<cfoutput>#currentrow#</cfoutput>_\\');','list');");
					</cfloop>	
				}
			}
			
			$("#itemCount").text(jsonData.DATA.length);
			
			if (jsonData.DATA.length > jsonData.pageSize)
			{
				$("#btnNext, #btnPrev, #btnNextLast, #btnPrevLast").show();
			} else {
				$("#btnNext, #btnPrev, #btnNextLast, #btnPrevLast").hide();
			}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.form_add_period_account_all';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/form/popup_form_add_period_account_all.cfm';
</cfscript>