<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>

    <cfscript>
		if (isdefined("attributes.is_form_submitted"))
		{
			get_assign_targets = MyAssignTargetModel.list(
				targetEmp	: session.ep.userid,
				keyword		: attributes.keyword
			);
		}
		else
			get_assign_targets.recordcount = 0;
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		if (isdefined("attributes.keyword"))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted))
			url_str = '#url_str#&is_form_submitted=#attributes.is_form_submitted#';
	</cfscript>
    <cfparam name="attributes.totalrecords" default="#get_assign_targets.recordcount#">
<cfelseif attributes.event is 'add'>  
	<cf_get_lang_set module_name="objects">
    <cfparam name="attributes.startdate" default="">
    <cfparam name="attributes.finishdate" default="">
    <cfscript>
		get_money = getMoneyInfo.get(
			dsn 		: dsn,
			moneyStatus	: 1
		);
		get_target_cats = getTargetCat.get(isActive : 1);
	</cfscript>
<cfelseif attributes.event is 'upd' or attributes.event is 'del'>    
    <cf_get_lang_set module_name="objects">
    <cfscript>
		if (isdefined('attributes.fbx') and attributes.fbx eq 'myhome')
		{
			attributes.target_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.target_id,accountKey:'wrk');
			if (len(attributes.position_code))
				attributes.position_code = contentEncryptingandDecodingAES(isEncode:0,content:attributes.position_code,accountKey:'wrk');
		}
		if (not(isDefined("attributes.employee_id") and len(attributes.employee_id)))
		{
			if (not (isDefined("attributes.position_code") and len(attributes.position_code)))
				attributes.position_code = 0;
			get_position = getPosition.get(
				positionCode 	: attributes.position_code,
				positionStatus	: 1
			);
		}
		get_target_cats = getTargetCat.get(isActive : 1);
		get_target = EmployeeTargetModel.get(
			targetId	:attributes.target_id
		);
		get_money = getMoneyInfo.get(
			dsn 		: dsn,
			moneyStatus	: 1
		);
	</cfscript>
</cfif>

<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event') and listFind('add,upd',attributes.event)>
	<cfif attributes.event is 'add'>
		<cfif isDate(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
        <cfif isDate(attributes.finishdate)><cf_date tarih='attributes.finishdate'></cfif>
        <cfif isdefined('attributes.other_date1') and len(attributes.other_date1) and isDate(attributes.other_date1)><cf_date tarih='attributes.other_date1'></cfif>
        <cfif isdefined('attributes.other_date2') and len(attributes.other_date2) and isDate(attributes.other_date2)><cf_date tarih='attributes.other_date2'></cfif>
        <cfif year(attributes.startdate) neq year(attributes.finishdate)>
            <script type="text/javascript">
                alertObject({message: "Eklediğiniz hedefin başlangıç ve bitiş tarihi dönemi aynı olmalıdır !"});
            </script>
            <cfabort>
        </cfif>
        
        <cfif len(attributes.record_num)>
            <cfloop from="1" to="#record_num#" index="i">
                <cfif isdefined("attributes.row_kontrol#i#") and (evaluate("attributes.row_kontrol#i#") neq 0) and len(evaluate("attributes.emp_id#i#"))>
                    <cfscript>
                        get_pos_code = getPosition.get(
                            employeeId 	: evaluate('attributes.emp_id#i#')
                        );
                        attributes.position_code = get_pos_code.position_code;
                        get_total_target_weight = EmployeeTargetModel.get_total_weight(
                            yearFinishDate	: year(attributes.finishdate),
                            yearStartDate	: year(attributes.startdate),
                            empId			: evaluate("attributes.emp_id#i#")
                        );
                        if (len(get_total_target_weight.TOTAL_WEIGHT))
                            temp_total = get_total_target_weight.TOTAL_WEIGHT;
                        else
                            temp_total = 0;
                        if (isdefined('attributes.target_weight') and len(attributes.target_weight))
                            new_weight = attributes.target_weight + temp_total;
                        else
                            new_weight = temp_total;
                    </cfscript>
    
                    <cfif new_weight gt 100>
                        <script type="text/javascript">
                            alertObject({message: "Çalışanın hedef ağırlıkları toplamı 100'den büyük olamaz !"});
                        </script>
                        <cfabort>
                    </cfif>
                </cfif>
            </cfloop>
        <cfelse>
            <cfscript>
                if (not(isdefined('attributes.emp_id') and len(attributes.emp_id)))
                    attributes.emp_id = 0;
                if (not(isdefined('attributes.position_code') and len(attributes.position_code)))
                    attributes.position_code = 0;
                get_total_target_weight = EmployeeTargetModel.get_total_weight(
                    yearFinishDate	: year(attributes.finishdate),
                    yearStartDate	: year(attributes.startdate),
                    empId			: attributes.emp_id,
                    positionCode	: attributes.position_code
                );
                if (len(get_total_target_weight.TOTAL_WEIGHT))
                    temp_total = get_total_target_weight.TOTAL_WEIGHT;
                else
                    temp_total = 0;
                if (isdefined('attributes.target_weight') and len(attributes.target_weight))
                    new_weight = attributes.target_weight + temp_total;
                else
                    new_weight = temp_total;
            </cfscript>
    
            <cfif new_weight gt 100>
                <script type="text/javascript">
                    alertObject({message: "Çalışanın hedef ağırlıkları toplamı 100'den büyük olamaz !"});
                </script>
                <cfabort>
            </cfif>
        </cfif>
    <cfelseif attributes.event is 'upd'>
        <cfscript>
            if (not(isdefined('attributes.emp_id') and len(attributes.emp_id)))
                attributes.emp_id = 0;
            if (not(isdefined('attributes.position_code') and len(attributes.position_code)))
                attributes.position_code = 0;
            get_total_target_weight = EmployeeTargetModel.get_total_weight(
                empId			: attributes.emp_id,
                positionCode	: attributes.position_code,
                targetId		: attributes.target_id
            );
            if (len(get_total_target_weight.TOTAL_WEIGHT))
                temp_total = get_total_target_weight.TOTAL_WEIGHT;
            else
                temp_total = 0;
            if (isdefined('attributes.target_weight') and len(attributes.target_weight))
                new_weight = attributes.target_weight + temp_total;
            else
                new_weight = temp_total;
        </cfscript>
    
        <cfif new_weight gt 100>
            <script type="text/javascript">
                alertObject({message: "Çalışanın hedef ağırlıkları toplamı 100'den büyük olamaz !"});
            </script>
            <cfabort>
        </cfif>
        <cfif isDate(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
        <cfif isDate(attributes.finishdate)><cf_date tarih='attributes.finishdate'></cfif>
        <cfif isdefined('attributes.other_date1') and len(attributes.other_date1) and isDate(attributes.other_date1)><cf_date tarih='attributes.other_date1'></cfif>
        <cfif isdefined('attributes.other_date2') and len(attributes.other_date2) and isDate(attributes.other_date2)><cf_date tarih='attributes.other_date2'></cfif>
    </cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function(e) {
			$('#keyword').focus();
		})
	<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event,',')>
		function check()
		{	
			<cfif attributes.event is 'add'>
				selected_emp=0;
				<cfif not (isDefined("attributes.employee_id") or isDefined("attributes.position_code"))>
					if(row_count >= 1)
					{
						for(i=1; i<=row_count; i++)
						{
							if((eval('$("#row_kontrol' + i + '").val()') == 1) && (eval('$("#emp_id' + i + '").val()') == ""))
							{	
								alert("<cf_get_lang no ='1347.Çalışan Ekleyiniz'>!");
								return false;
							}
							else if ((eval('$("#row_kontrol' + i + '").val()') == 1) && (eval('$("#emp_id' + i + '").val()') != ""))
								selected_emp++;
						}
					}
					
					if (selected_emp == 0)
					{	
						alert("<cf_get_lang_main no='1701.En Az Bir Çalışan Eklemelisiniz'> !");
						return false;
					}
				</cfif>
			</cfif>
		
			if (($('#startdate').val() != "") && ($('#finishdate').val() != ""))
				if (! date_check(search_target.startdate, search_target.finishdate, "<cf_get_lang no ='1317.Başlangıç tarihi bitiş tarihinden küçük olmalıdır '>!"))
					return false;
			$('#target_weight').val(filterNum($('#target_weight').val()));
			$('#target_number').val(filterNum($('#target_number').val()));
			$('#suggested_budget').val(filterNum($('#suggested_budget').val()));
			return true;
		}
		<cfif isdefined("attributes.event") and attributes.event is 'add'>	
			function sil(sy)
			{
				var my_element=eval("search_target.row_kontrol"+sy);
				my_element.value=0;
				var my_element=eval("frm_row"+sy);
				my_element.style.display="none";	
			}
			
			row_count=0;
			
			function add_row()
			{
				row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);
				
				$('#record_num').val(row_count);		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<a style="cursor:pointer" onclick="sil('+ row_count +');"><img src="/images/delete_list.gif" border="0"></a><input type="hidden" name="emp_id' + row_count + '" id="emp_id' + row_count + '">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="employee' + row_count + '" id="employee' + row_count + '" style="width:125px;" readonly class="formfieldright">';	
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" readonly name="pos_name' + row_count + '" id="pos_name' + row_count + '" value="" style="width:125px;">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><input type="text" readonly name="branch_name' + row_count + '" value="" style="width:125px;">';					
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<a onclick="javascript:opage(' + row_count +');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';
			}
			function opage(deger)
			{
				if(document.search_target.fbx.value == 'myhome')
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&call_function=change_upper_pos_codes()&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&field_emp_id=search_target.emp_id' + deger + '&field_name=search_target.employee' + deger +'&field_branch_name=search_target.branch_name'+ deger +'&field_pos_name=search_target.pos_name' + deger,'list');
				else
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&field_emp_id=search_target.emp_id' + deger + '&field_name=search_target.employee' + deger +'&field_branch_name=search_target.branch_name'+ deger +'&field_pos_name=search_target.pos_name' + deger,'list');
			}
		</cfif>
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.my_assign_targets';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/my_assign_targets.cfm';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.my_assign_targets';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/formEmployeeTarget.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.my_assign_targets&event=upd&target_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'search_target';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.my_assign_targets';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'objects/form/formEmployeeTarget.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.my_assign_targets&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'target_id=##attributes.target_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.target_id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'search_target';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_target';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' or attributes.event is 'del' ))
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
			
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=objects.del_target&target_id=#get_target.target_id#&head=#get_target.target_head#&cat=#get_target_cats.targetcat_id#&per_id=#get_target.per_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'objects/query/del_target.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.my_assign_targets';
	}
	
	if (isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd'))
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'TARGET';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'TARGET_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-startdate','item-finishdate','item-targetcat_id','item-target_head','item-target_weight']";
		
		if(attributes.event is 'add')
		{
			if (isdefined('attributes.per_id'))
				per_id = attributes.per_id;
			else
				per_id = '';
			if (isdefined('attributes.emp_id'))
				emp_id = attributes.emp_id;
			else
				emp_id = '';
			target_id = '';
			startdate = '';
			finishdate = '';
			targetcat_id_ = '';
			target_head = '';
			target_number = '';
			calculation_type = '';
			suggested_budget = '';
			target_money = session.ep.money;
			target_weight = '';
			target_emp = session.ep.userid;
			other_date1 = '';
			other_date2 = '';
			target_detail = '';
			
			WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
			WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'check() && validate().check()';
		}
		else if(attributes.event is 'upd')
		{
			per_id = get_target.per_id;
			if (isDefined("attributes.employee_id") and len(attributes.employee_id))
				emp_id = attributes.employee_id;
			else
				emp_id = get_position.employee_id;
			target_id = attributes.target_id;
			startdate = get_target.startdate;
			finishdate = get_target.finishdate;
			targetcat_id_ = get_target.targetcat_id;
			target_head = get_target.target_head;
			target_number = get_target.target_number;
			calculation_type = get_target.calculation_type;
			suggested_budget = get_target.suggested_budget;
			target_money = get_target.target_money;
			target_weight = get_target.target_weight;
			target_emp = get_target.target_emp;
			other_date1 = get_target.other_date1;
			other_date2 = get_target.other_date2;
			target_detail = get_target.target_detail;
			
			if (not isdefined("attributes.per_id"))
			{
				if (session.ep.userid eq get_target.target_emp)
				{
					WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
					WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
					WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'check() && validate().check()';
					WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
				}
			}
			else
			{
				WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['buttons']['info'] = 'Performans Formu Onaylandığı İçin Güncelleme Yapamazsınız !';
			}
		}
	}
	
/**************************************
	modelden CRUD işlemleri yapılıyor...
****************************************/

	if (isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1)
	{
		if (attributes.event is 'add')
		{
			if (not(isdefined('attributes.target_number') and len(attributes.target_number)))
				attributes.target_number = '';
			if (not(isdefined('attributes.other_date1') and len(attributes.other_date1)))
				attributes.other_date1 = '';
			if (not(isdefined('attributes.other_date2') and len(attributes.other_date2)))
				attributes.other_date2 = '';
			if (len(attributes.record_num))
			{
				for(i=1;i<=attributes.record_num;i++)
				{
					if (isdefined("attributes.row_kontrol"&+i) and (evaluate("attributes.row_kontrol"&+i) neq 0) and len(evaluate("attributes.emp_id"&+i)))
					{
						add = EmployeeTargetModel.add (
							perId					: iif(len(attributes.per_id),attributes.per_id,0),
							positionCode			: iif(len(evaluate('attributes.emp_pos_code'&+i)),evaluate('attributes.emp_pos_code'&+i),0),
							empId					: iif(len(evaluate('attributes.emp_id'&+i)),evaluate('attributes.emp_id'&+i),0),
							targetcatId				: attributes.targetcat_id,
							startDate				: attributes.startdate,
							finishDate				: attributes.finishdate,
							targetHead				: attributes.target_head,
							targetNumber			: attributes.target_number,
							targetDetail			: attributes.target_detail,
							calculationType			: attributes.calculation_type,
							suggestedBudget			: attributes.suggested_budget,
							targetEmpId				: attributes.target_emp_id,
							targetWeight			: attributes.target_weight,
							otherDate1				: attributes.other_date1,
							otherDate2				: attributes.other_date2,
							moneyType				: attributes.money_type
						);
						
						attributes.actionId = add;
					}
				}
			}
			else
			{
				if (not(isdefined('attributes.position_code') and len(attributes.position_code)))
					attributes.position_code = 0;
				
				add = EmployeeTargetModel.add (
					perId					: iif(len(attributes.per_id),attributes.per_id,0),
					positionCode			: attributes.position_code,
					empId					: iif(len(attributes.emp_id),attributes.emp_id,0),
					targetcatId				: attributes.targetcat_id,
					startDate				: attributes.startdate,
					finishDate				: attributes.finishdate,
					targetHead				: attributes.target_head,
					targetNumber			: attributes.target_number,
					targetDetail			: attributes.target_detail,
					calculationType			: attributes.calculation_type,
					suggestedBudget			: attributes.suggested_budget,
					targetEmpId				: attributes.target_emp_id,
					targetWeight			: attributes.target_weight,
					otherDate1				: attributes.other_date1,
					otherDate2				: attributes.other_date2,
					moneyType				: attributes.money_type
				);
				
				attributes.actionId = add;
			}
		}
		else if (attributes.event is 'upd')
		{
			if (not(isdefined('attributes.position_code') and len(attributes.position_code)))
				attributes.position_code = 0;
			if (not(isdefined('attributes.target_number') and len(attributes.target_number)))
				attributes.target_number = '';
			if (not(isdefined('attributes.other_date1') and len(attributes.other_date1)))
				attributes.other_date1 = '';
			if (not(isdefined('attributes.other_date2') and len(attributes.other_date2)))
				attributes.other_date2 = '';
			
			upd = EmployeeTargetModel.upd (
				perId					: iif(len(attributes.per_id),attributes.per_id,0),
				positionCode			: attributes.position_code,
				targetCatId				: attributes.targetcat_id,
				startDate				: attributes.startdate,
				finishDate				: attributes.finishdate,
				targetHead				: attributes.target_head,
				targetNumber			: attributes.target_number,
				targetDetail			: attributes.target_detail,
				calculationType			: attributes.calculation_type,
				suggestedBudget			: attributes.suggested_budget,
				targetEmpId				: attributes.target_emp_id,
				targetWeight			: attributes.target_weight,
				otherDate1				: attributes.other_date1,
				otherDate2				: attributes.other_date2,
				targetId				: attributes.target_id
			);
			attributes.actionId = attributes.target_id;
		}
		else if (attributes.event is 'del')
		{
			del = EmployeeTargetModel.del (
				perId					: iif(len(attributes.per_id),attributes.per_id,0),
				targetId				: attributes.target_id
			);
			
			attributes.actionId = attributes.target_id;
		}
	}
</cfscript>
