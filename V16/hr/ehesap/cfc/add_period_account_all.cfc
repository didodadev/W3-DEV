<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="add_period" access="remote" returntype="any" returnformat="plain">
		<cfscript>
			cmp = createObject("component","V16.hr.ehesap.cfc.periods_to_in_out");
			get_acc_type = cmp.setup_acc_type();
			
			arg_json = toString(gethttprequestdata().content);
			arg_array = deserializejson(arg_json).data;
			colList = arraytolist(deserializejson(arg_json).columns);
			empid_idx = ListFind(colList, "EMPLOYEE_ID");
			inoutid_idx = listfind(colList, "IN_OUT_ID");
			accbilltype_idx = listfind(colList, "ACCOUNT_BILL_TYPE");
			expitemid_idx = listfind(colList, "EXPENSE_ITEM_ID");
			expitemname_idx = listfind(colList, "EXPENSE_ITEM_NAME");
			expcenterid_idx = listfind(colList, "EXPENSE_CENTER_ID");
			expcode_idx = listfind(colList, "EXPENSE_CODE");
			expcodename_idx = ListFind(colList, "EXPENSE_CODE_NAME");
			activityid_idx = ListFind(colList, "ACTIVITY_TYPE_ID");
			if (get_acc_type.recordcount)
			{
				for (i=1;i lte get_acc_type.recordcount; i++)
				{
					"acccode#i#_idx" = listfind(colList, "ACCOUNT_CODE_#i#");
					"accname#i#_idx" = ListFind(colList, "ACCOUNT_NAME_#i#");
					"acctypeid#i#_idx" = ListFind(colList, "ACC_TYPE_ID_#i#");
				}
			}
			
			if (arraylen(arg_array))
			{
				for (i=1; i lte arraylen(arg_array); i++)
				{
					cmp = createObject("component","V16.hr.ehesap.cfc.periods_to_in_out");
					sonuc = cmp.get_period_control(in_out_id:arg_array[i][inoutid_idx],period_id:session.ep.period_id);
					if (sonuc.recordcount)
					{
						cmp.upd_inout_period(
							period_code_cat:arg_array[i][accbilltype_idx],
							expense_item_id:arg_array[i][expitemid_idx],
							expense_item_name:arg_array[i][expitemname_idx],
							expense_center_id:arg_array[i][expcenterid_idx],
							expense_code:arg_array[i][expcode_idx],
							expense_code_name:arg_array[i][expcodename_idx],
							activity_type_id:arg_array[i][activityid_idx],
							in_out_id:arg_array[i][inoutid_idx],
							period_id:session.ep.period_id);
					}
					else
					{
						cmp.add_inout_period(
							period_code_cat:arg_array[i][accbilltype_idx],
							expense_item_id:arg_array[i][expitemid_idx],
							expense_item_name:arg_array[i][expitemname_idx],
							expense_center_id:arg_array[i][expcenterid_idx],
							expense_code:arg_array[i][expcode_idx],
							expense_code_name:arg_array[i][expcodename_idx],
							activity_type_id:arg_array[i][activityid_idx],
							in_out_id:arg_array[i][inoutid_idx],
							period_id:session.ep.period_id);
					}
					
					/*ilişkili hesaplar ekleme */
					cmp.del_emp_accounts(
						employee_id:arg_array[i][empid_idx],
						in_out_id:arg_array[i][inoutid_idx],
						period_id:session.ep.period_id);
					
					temp_count = 0;
					for (j=1; j lte get_acc_type.recordcount; j++)
					{
						temp_count = temp_count + 1;
						if (len(arg_array[i][Evaluate('acccode#temp_count#_idx')]) and len(arg_array[i][Evaluate('accname#temp_count#_idx')]))
						{
							if (arg_array[i][Evaluate('acctypeid#temp_count#_idx')] eq -1)
							{
								cmp.upd_inout_period_acc_code(
									acc_code:arg_array[i][Evaluate('acccode#temp_count#_idx')],
									in_out_id:arg_array[i][inoutid_idx],
									period_id:session.ep.period_id);
							}
							cmp.add_emp_accounts(
								acc_type_id:arg_array[i][Evaluate('acctypeid#temp_count#_idx')],
								account_code:arg_array[i][Evaluate('acccode#temp_count#_idx')],
								period_id:session.ep.period_id,
								in_out_id:arg_array[i][inoutid_idx],
								employee_id:arg_array[i][empid_idx]);
						}
					}
					/* ilişkili hesaplar son */
				}
			}
		</cfscript>
	    <cfreturn 1>
	</cffunction>
</cfcomponent>
