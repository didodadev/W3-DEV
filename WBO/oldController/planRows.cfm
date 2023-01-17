<cf_get_lang_set module_name="budget">
<cf_xml_page_edit fuseact="budget.add_budget_plan">
<cfif IsDefined("attributes.event")>
	<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)>
    	<cfquery name="get_budget_plan" datasource="#dsn#">
            SELECT
                BUDGET_PLAN_ID,
                BUDGET_ID,
                PROCESS_STAGE,
                PROCESS_TYPE,
                PROCESS_CAT,
                PAPER_NO,
                BUDGET_PLAN_DATE,
                BUDGET_PLANNER_EMP_ID,
                DETAIL,
                INCOME_TOTAL,
                EXPENSE_TOTAL,
                DIFF_TOTAL,
                OTHER_INCOME_TOTAL,
                OTHER_EXPENSE_TOTAL,
                OTHER_DIFF_TOTAL,
                OTHER_MONEY,
                IS_SCENARIO,
                RECORD_EMP,
                RECORD_DATE,
                UPDATE_EMP,
                UPDATE_DATE,
                ACC_DEPARTMENT_ID,
                BRANCH_ID,
                PERIOD_ID,
                OUR_COMPANY_ID,
                UPD_STATUS,
                DOCUMENT_TYPE,
                PAYMENT_METHOD,
                DUE_DATE
            FROM
                BUDGET_PLAN
            WHERE
                BUDGET_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.budget_plan_id#">
        </cfquery>
        <cfset attributes.budget_id = get_budget_plan.budget_id>
        <cfquery name="get_budget_plan_row" datasource="#dsn#">
            SELECT
                BPR.BUDGET_PLAN_ROW_ID,
                BPR.BUDGET_PLAN_ID,
                BPR.PLAN_DATE,
                BPR.DETAIL,
                BPR.EXP_INC_CENTER_ID,
                BPR.BUDGET_ITEM_ID,
                BPR.BUDGET_ACCOUNT_CODE,
                BPR.ACTIVITY_TYPE_ID,
                BPR.RELATED_EMP_ID,
                BPR.RELATED_EMP_TYPE,
                BPR.RELATED_ACCOUNT_CODE,
                BPR.ROW_TOTAL_INCOME,
                BPR.ROW_TOTAL_EXPENSE,
                BPR.ROW_TOTAL_DIFF,
                BPR.OTHER_ROW_TOTAL_INCOME,
                BPR.OTHER_ROW_TOTAL_EXPENSE,
                BPR.OTHER_ROW_TOTAL_DIFF,
                BPR.IS_PAYMENT,
                BPR.WORKGROUP_ID,
                BPR.PROJECT_ID,
                BPR.ACC_TYPE_ID,
                BPR.ASSETP_ID,
                EI.EXPENSE_ITEM_NAME,
                EI.ACCOUNT_CODE,
                EI.EXPENSE_ITEM_ID,
                EC.EXPENSE_CAT_NAME,
                EC.EXPENSE_CAT_ID,
                PP.PROJECT_ID, 
                PP.PROJECT_HEAD,
                A.ASSETP_ID, 
                A.ASSETP
            FROM
                BUDGET_PLAN_ROW BPR
                 LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = BPR.BUDGET_ITEM_ID
                 LEFT JOIN #dsn2_alias#.EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
                 LEFT JOIN PRO_PROJECTS PP ON PP.PROJECT_ID = BPR.PROJECT_ID
                 LEFT JOIN ASSET_P A ON A.ASSETP_ID=BPR.ASSETP_ID
            WHERE
                BPR.BUDGET_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.budget_plan_id#">
            ORDER BY
                BPR.BUDGET_PLAN_ROW_ID
        </cfquery>
    <cfelse>
    	<cfset get_budget_plan.recordcount = 0>
        <cfset get_budget_plan_row.recordcount = 0>
    </cfif>
     <cfquery name="get_branches" datasource="#dsn#">
            SELECT
                BRANCH_ID,BRANCH_NAME
            FROM
                BRANCH
            WHERE
                BRANCH_STATUS = 1
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            ORDER BY
                BRANCH_NAME
        </cfquery>
        <cfquery name="get_expense_center" datasource="#dsn2#">
            SELECT EXPENSE_ID,EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
        </cfquery>
        <cfquery name="get_activity_types" datasource="#dsn#">
            SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
        </cfquery>
        <cfquery name="get_workgroups" datasource="#dsn#">
            SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY HIERARCHY
        </cfquery>
        <cfquery name="get_budget" datasource="#dsn#">
            SELECT 
                BUDGET_NAME 
            FROM 
                BUDGET 
            WHERE
            1=1
             <cfif isdefined("attributes.budget_id") and len(attributes.budget_id)> 
                AND BUDGET_ID = #attributes.budget_id#
             <cfelseif isdefined("get_budget_plan.budget_id") and len(get_budget_plan.budget_id)>
               AND BUDGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_budget_plan.budget_id#">
             </cfif>
        </cfquery>
       <cfif attributes.event eq 'add'>
       	<cf_papers paper_type="budget_plan">
    	<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)>
            <cfquery name="get_money" datasource="#dsn#">
                SELECT MONEY_TYPE AS MONEY,* FROM BUDGET_PLAN_MONEY WHERE ACTION_ID = #attributes.budget_plan_id#
            </cfquery>
            <cfif not get_money.recordcount>
                <cfquery name="get_money" datasource="#dsn2#">
                    SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
                </cfquery>
            </cfif>
        <cfelseif isdefined("attributes.is_rapor") and attributes.is_rapor eq 1>
            <cfscript>
                satir_sayisi = attributes.total_record;
                index = 1;
                get_budget_plan_row = QueryNew("BUDGET_PLAN_ROW_ID,BUDGET_PLAN_ID,PLAN_DATE,DETAIL,EXP_INC_CENTER_ID,BUDGET_ITEM_ID,BUDGET_ACCOUNT_CODE,
                                                ACTIVITY_TYPE_ID,RELATED_EMP_ID,RELATED_EMP_TYPE,ROW_TOTAL_INCOME,ROW_TOTAL_EXPENSE,ROW_TOTAL_DIFF,OTHER_ROW_TOTAL_INCOME,
                                                OTHER_ROW_TOTAL_EXPENSE,OTHER_ROW_TOTAL_DIFF,IS_PAYMENT,WORKGROUP_ID,PROJECT_ID,ASSETP_ID");
                QueryAddRow(get_budget_plan_row,satir_sayisi*2);
        
                for(a=1;a lte attributes.record_num; a=a+1)
                {
                    if (isdefined("attributes.row_check#a#"))
                    {
                        QuerySetCell(get_budget_plan_row,"BUDGET_PLAN_ROW_ID","",index);
                        QuerySetCell(get_budget_plan_row,"BUDGET_PLAN_ID","",index);
                        QuerySetCell(get_budget_plan_row,"PLAN_DATE",now(),index);
                        QuerySetCell(get_budget_plan_row,"DETAIL",evaluate("attributes.detail#a#"),index);
                        QuerySetCell(get_budget_plan_row,"EXP_INC_CENTER_ID",evaluate("attributes.expense_center_id#a#"),index);
                        QuerySetCell(get_budget_plan_row,"BUDGET_ITEM_ID",evaluate("attributes.expense_item_id#a#"),index);
                        QuerySetCell(get_budget_plan_row,"BUDGET_ACCOUNT_CODE",evaluate("attributes.tahakkuk_acc_code#a#"),index);
                        QuerySetCell(get_budget_plan_row,"ACTIVITY_TYPE_ID","",index);
                        QuerySetCell(get_budget_plan_row,"RELATED_EMP_ID","",index);
                        QuerySetCell(get_budget_plan_row,"RELATED_EMP_TYPE","",index);
                        QuerySetCell(get_budget_plan_row,"ROW_TOTAL_INCOME",evaluate("attributes.income_total#a#"),index);
                        QuerySetCell(get_budget_plan_row,"ROW_TOTAL_EXPENSE",evaluate("attributes.expense_total#a#"),index);
                        QuerySetCell(get_budget_plan_row,"ROW_TOTAL_DIFF","",index);
                        QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_INCOME",evaluate("attributes.other_income_total#a#"),index);
                        QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_EXPENSE",evaluate("attributes.other_expense_total#a#"),index);
                        QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_DIFF","",index);
                        QuerySetCell(get_budget_plan_row,"IS_PAYMENT","",index);
                        QuerySetCell(get_budget_plan_row,"WORKGROUP_ID","",index);
                        QuerySetCell(get_budget_plan_row,"PROJECT_ID",evaluate("attributes.project_id#a#"),index);
                        QuerySetCell(get_budget_plan_row,"ASSETP_ID","",index);
                        index ++;
        
                        QuerySetCell(get_budget_plan_row,"BUDGET_PLAN_ROW_ID","",index);
                        QuerySetCell(get_budget_plan_row,"BUDGET_PLAN_ID","",index);
                        QuerySetCell(get_budget_plan_row,"PLAN_DATE",now(),index);
                        QuerySetCell(get_budget_plan_row,"DETAIL",evaluate("attributes.detail#a#"),index);
                        QuerySetCell(get_budget_plan_row,"EXP_INC_CENTER_ID","",index);
                        QuerySetCell(get_budget_plan_row,"BUDGET_ITEM_ID","",index);
                        QuerySetCell(get_budget_plan_row,"BUDGET_ACCOUNT_CODE",evaluate("attributes.account_code#a#"),index);
                        QuerySetCell(get_budget_plan_row,"ACTIVITY_TYPE_ID","",index);
                        QuerySetCell(get_budget_plan_row,"RELATED_EMP_ID","",index);
                        QuerySetCell(get_budget_plan_row,"RELATED_EMP_TYPE","",index);
                        QuerySetCell(get_budget_plan_row,"ROW_TOTAL_INCOME",evaluate("attributes.expense_total#a#"),index);
                        QuerySetCell(get_budget_plan_row,"ROW_TOTAL_EXPENSE",evaluate("attributes.income_total#a#"),index);
                        QuerySetCell(get_budget_plan_row,"ROW_TOTAL_DIFF","",index);
                        QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_INCOME",evaluate("attributes.other_expense_total#a#"),index);
                        QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_EXPENSE",evaluate("attributes.other_income_total#a#"),index);
                        QuerySetCell(get_budget_plan_row,"OTHER_ROW_TOTAL_DIFF","",index);
                        QuerySetCell(get_budget_plan_row,"IS_PAYMENT","",index);
                        QuerySetCell(get_budget_plan_row,"WORKGROUP_ID","",index);
                        QuerySetCell(get_budget_plan_row,"PROJECT_ID",evaluate("attributes.project_id#a#"),index);
                        QuerySetCell(get_budget_plan_row,"ASSETP_ID","",index);
                        index++;
                    }
                }
            </cfscript>
            <cfquery name="get_money" datasource="#dsn2#">
                SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY ORDER BY MONEY_ID
            </cfquery>
        <cfelse>
            <cfquery name="get_money" datasource="#dsn2#">
                SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY ORDER BY MONEY_ID
            </cfquery>
        </cfif>
        
        
        <cfquery name="GET_DEPARTMENT" datasource="#dsn#">
            SELECT
                DEPARTMENT_HEAD,
                DEPARTMENT_ID,
                BRANCH_ID,
                (SELECT BRANCH_NAME FROM BRANCH WHERE DEPARTMENT_ID = BRANCH_ID)
            FROM
                DEPARTMENT
            WHERE
                DEPARTMENT_STATUS = 1
                AND BRANCH_ID IN(SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID=#session.ep.company_id#)
            ORDER BY
                DEPARTMENT_HEAD
        </cfquery>
        <cfscript>
            netbook = createObject("component","account.cfc.netbook");
            netbook.dsn = dsn;
            get_account_card_document_types = netbook.getAccountCardDocumentTypes(is_company : 1, is_active : 1);
            get_account_card_payment_types = netbook.getAccountCardPaymentTypes(is_active : 1);
        </cfscript>
        <cfif isdefined("attributes.budget_id") and len(attributes.budget_id)>
            <cfif get_budget_plan.recordcount neq 0>
            	<cfset budget_id = get_budget_plan.budget_id>
            </cfif>
            <cfset budget_name = get_budget.budget_name>
        <cfelse>
            <cfset budget_id = ''>
            <cfset budget_name = ''>
        </cfif>
        <script type="text/javascript">
			$( document ).ready(function() {
				<cfif isdefined("attributes.is_rapor")>
				for(zzz=1;zzz<=document.getElementById("record_num").value;zzz++)
				{
					if(document.getElementById("row_kontrol"+zzz).value==1)
					{
						hesapla(zzz);
					}
				}
				</cfif>
				<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)>
					row_count=<cfoutput>#get_budget_plan_row.recordcount#</cfoutput>;
				<cfelse>
					row_count=0;
				</cfif>
			});
			
		
			function open_file()
			{
				document.getElementById('budget_file').style.display='';
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=budget.popup_add_budget_file<cfif isdefined("attributes.budget_id")>&budget_id=#attributes.budget_id#</cfif></cfoutput>','budget_file',1);
				return false;
			}
			function check_all(deger)
			{
				if(add_budget_plan.hepsi.checked)
				{
					for(i=1;i<=add_budget_plan.record_num.value;i++)
					{
						if(document.getElementById("row_kontrol"+i).value==1)
						{
							var form_field = document.getElementById("is_payment" + i);
							form_field.checked = true;
							document.getElementById("is_payment"+i).focus();
						}
					}
				}
				else
				{
					for(i=1;i<=add_budget_plan.record_num.value;i++)
					{
						if(document.getElementById("row_kontrol"+i).value==1)
						{
							form_field = document.getElementById("is_payment" + i);
							form_field.checked = false;
							document.getElementById("is_payment"+i).focus();
						}
					}
				}
			}
			
			function add_row(expense_date,row_detail,expense_center_id,expense_item_id,expense_item_name,expense_cat_id,expense_cat_name,account_id,account_code,activity_type,workgroup_id,member_type,company_id,consumer_id,employee_id,authorized,project_id,project_name,income_total,expense_total,diff_total,other_income_total,other_expense_total,other_diff_total,assetp_id,assetp_name)
			{
				//Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
				if(expense_date == undefined)expense_date = '';
				if(row_detail == undefined)row_detail = '';
				if(expense_center_id == undefined)expense_center_id = '';
				if(expense_item_id == undefined)expense_item_id = '';
				if(expense_item_name == undefined)expense_item_name = '';
				if(expense_cat_id == undefined)expense_cat_id = '';
				if(expense_cat_name == undefined)expense_cat_name = '';
				if(account_id == undefined)account_id = '';
				if(account_code == undefined)account_code = '';
				if(activity_type == undefined)activity_type = '';
				if(workgroup_id == undefined)workgroup_id = '';
				if(member_type == undefined)member_type = '';
				if(company_id == undefined)company_id = '';
				if(consumer_id == undefined)consumer_id = '';
				if(employee_id == undefined)employee_id = '';
				if(authorized == undefined)authorized = '';
				if(project_id == undefined) project_id = '';
				if(project_name == undefined) project_name = '';
				if(assetp_id == undefined) assetp_id = '';
				if(assetp_name == undefined) assetp_name = '';
				if(income_total == undefined)income_total = 0;
				if(expense_total == undefined)expense_total = 0;
				if(diff_total == undefined)diff_total = 0;
				if(other_income_total == undefined)other_income_total = 0;
				if(other_expense_total == undefined)other_expense_total = 0;
				if(other_diff_total == undefined)other_diff_total = 0;
		
				row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);
				newRow.className = 'color-row';
				document.getElementById("record_num").value=row_count;
				document.getElementById("record_num_kontrol").value=document.getElementById("record_num_kontrol").value+1;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input type="text" name="satir_no' + row_count +'" id="satir_no' + row_count +'" value=' +row_count+' class="boxtext" style="width:20px;" readonly="yes">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="copy_row(' + row_count + ');" title="Satır Kopyala"><img  src="images/copy_list.gif" alt="Satır Kopyala" border="0"></a>';
				<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
					<cfswitch expression="#xlr#">
						<cfcase value="1">//1.Tarih
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.setAttribute("id","expense_date" + row_count + "_td");
							newCell.innerHTML = '<input type="text" name="expense_date' + row_count +'"id="expense_date'+ row_count +'"class="text" maxlength="10" style="width:95px;" value="' + expense_date +'"> ';
							wrk_date_image('expense_date' + row_count);
						</cfcase>
						<cfcase value="2">//2.Açıklama
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:120px;" class="boxtext" maxlength="300" value="' + row_detail +'">';
						</cfcase>
						<cfcase value="3">//3.Masraf Merkezi
							newCell = newRow.insertCell(newRow.cells.length);
							a = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:100%;" class="boxtext"><option value="">Masraf/Gelir Merkezi</option>';
							<cfoutput query="get_expense_center">
								if('#expense_id#' == expense_center_id)
									a += '<option value="#expense_id#" selected>#expense#</option>';
								else
									a += '<option value="#expense_id#">#expense#</option>';
							</cfoutput>
							newCell.innerHTML =a+ '</select>';
						</cfcase>
						<cfcase value="4">//4.Butce Kategorisi
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.innerHTML = '<input type ="hidden" name="expense_cat_id' + row_count + '" id="expense_cat_id' + row_count + '" value="'+ expense_cat_id +'"><input type="text" name="expense_cat_name'+ row_count +'" id="expense_cat_name'+ row_count +'" value="'+ expense_cat_name +'" class="boxtext">';
						</cfcase>
						<cfcase value="5">//5.Butce Kalemi
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.innerHTML = '<input  type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+expense_item_id+'"><input type="text" style="width:120px;" name="expense_item_name' + row_count +'" id="expense_item_name' + row_count +'" class="boxtext" value="'+expense_item_name+'" onFocus="autocomp_budget('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" alt="" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
						</cfcase>
						<cfcase value="6">//6.Muhasebe Kodu
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.innerHTML = '<input  type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+account_id+'"><input type="text" style="width:120px;" name="account_code' + row_count +'" id="account_code' + row_count +'" class="boxtext"  value="'+account_code+'" onFocus="autocomp_acc_code('+row_count+');" ><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_acc('+ row_count +');" align="absmiddle" border="0"></a>';
						</cfcase>
						<cfcase value="7">//7.Aktivite Tipi
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							b = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:100px;" class="boxtext"><option value="">Aktivite Tipi</option>';
							<cfoutput query="get_activity_types">
								if('#activity_id#' == activity_type)
									b += '<option value="#activity_id#" selected>#activity_name#</option>';
								else
									b += '<option value="#activity_id#">#activity_name#</option>';
							</cfoutput>
							newCell.innerHTML =b+ '</select>';
						</cfcase>
						<cfcase value="8">//8.Is Grubu
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							b = '<select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:100px;;" class="boxtext"><option value=""><cf_get_lang_main no='728.İş Grubu'> </option>';
							<cfoutput query="get_workgroups">
								if('#workgroup_id#' == workgroup_id)
									b += '<option value="#workgroup_id#" selected>#workgroup_name#</option>';
								else
									b += '<option value="#workgroup_id#">#workgroup_name#</option>';
							</cfoutput>
							newCell.innerHTML =b+ '</select>';
						</cfcase>
						<cfcase value="17">//17.Fiziki Varlik
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.innerHTML = '<input type="hidden" name="assetp_id'+ row_count +'" id="assetp_id'+ row_count +'" value="'+assetp_id+'"><input type="text" style="width:105px;" name="assetp_name'+ row_count +'" id="assetp_name'+ row_count +'" onFocus="autocomp_assetp('+row_count+');" value="'+assetp_name+'" class="boxtext"> <a href="javascript://" onClick="pencere_ac_assetp('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
						</cfcase>
						<cfcase value="9">//9.Proje
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+project_id+'"><input type="text" style="width:143px;" name="project_head'+ row_count +'" id="project_head'+ row_count +'" onFocus="autocomp_project('+row_count+');" value="'+project_name+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
						</cfcase>
						<cfcase value="10">//10.Cari Hesap
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value="'+member_type+'"><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value="'+company_id+'"><input type="hidden" name="consumer_id'+ row_count +'" id="consumer_id'+ row_count +'" value="'+consumer_id+'"><input type="hidden" name="employee_id'+ row_count +'" id="employee_id'+ row_count +'" value="'+employee_id+'"><input type="text" style="width:110px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="'+authorized+'" class="boxtext" onFocus="autocomp_cari('+row_count+');">&nbsp;<a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
						</cfcase>
						<cfcase value="11">//11.Gelir TL
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.innerHTML = '<input type="text" name="income_total' + row_count +'" id="income_total' + row_count +'" value="'+income_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
						</cfcase>
						<cfcase value="12">//12.Gider TL
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="expense_total' + row_count +'" id="expense_total' + row_count +'" value="'+expense_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
						</cfcase>
						<cfcase value="13">//13.Fark TL
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="diff_total' + row_count +'" id="diff_total' + row_count +'" value="'+diff_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="hesapla('+row_count+');" readonly="yes">';
						</cfcase>
						<cfcase value="14">//Gelir Doviz
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="other_income_total' + row_count +'" id="other_income_total' + row_count +'" value="'+other_income_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly="yes">';
						</cfcase>
						<cfcase value="15">//Gider Doviz
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="other_expense_total' + row_count +'" id="other_expense_total' + row_count +'" value="'+other_expense_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly="yes">';
						</cfcase>
						<cfcase value="16">//Fark Doviz
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="other_diff_total' + row_count +'" id="other_diff_total' + row_count +'" value="'+other_diff_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly="yes">';
						</cfcase>
					</cfswitch>
				</cfloop>
				hesapla(row_count);
				toplam_hesapla();
			}
			
			
			function pencere_ac_exp(no)
			{
				if(document.getElementById("expense_cat_id" + no) != undefined)
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_budget_plan.expense_item_id' + no +'&field_name=add_budget_plan.expense_item_name' + no +'&field_account_no=add_budget_plan.account_code' + no +'&field_account_no2=add_budget_plan.account_id' + no + '&field_cat_id=add_budget_plan.expense_cat_id' + no + '&field_cat_name=add_budget_plan.expense_cat_name' + no,'list');
				else
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_budget_plan.expense_item_id' + no +'&field_name=add_budget_plan.expense_item_name' + no +'&field_account_no=add_budget_plan.account_code' + no +'&field_account_no2=add_budget_plan.account_id' + no,'list');
			}
			
			function percent_hesapla()
			{
				if(confirm('Yüzdesel Orana Göre Satırdaki Gelir ve Gider Değerleri Yeniden Hesaplanacaktır. Emin misiniz?'))
				{
					if(document.getElementById("rate") != undefined && document.getElementById("rate").value != 0 )
					{
						for(j=1;j<=document.getElementById("record_num").value;j++)
						{
							diff_income_value = parseFloat(parseFloat(filterNum(document.getElementById("income_total"+j).value))*parseFloat(filterNum(document.getElementById("rate").value))/100);
							document.getElementById("income_total"+j).value = commaSplit(parseFloat(diff_income_value+parseFloat(filterNum(document.getElementById("income_total"+j).value))));
							diff_expense_value =  parseFloat(parseFloat(filterNum(document.getElementById("expense_total"+j).value))*parseFloat(filterNum(document.getElementById("rate").value))/100);
							document.getElementById("expense_total"+j).value = commaSplit(parseFloat(diff_expense_value+parseFloat(filterNum(document.getElementById("expense_total"+j).value))));
							document.getElementById("diff_total"+j).value = commaSplit(filterNum(document.getElementById("income_total"+j).value)-filterNum(document.getElementById("expense_total"+j).value));
						}
					}
				}
			}
			function hesapla(row_no)
			{
				if(document.getElementById("diff_total"+row_no) != undefined)
					document.getElementById("diff_total"+row_no).value = commaSplit(filterNum(document.getElementById("income_total"+row_no).value)-filterNum(document.getElementById("expense_total"+row_no).value));
				if(document.getElementById("kur_say").value == 1)
					for (var i=1; i<=document.getElementById("kur_say").value; i++)
					{
						if(document.getElementById("rd_money").checked == true)
						{
							form_txt_rate2_ = filterNum(document.getElementById("txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
							document.getElementById("other_income_total"+row_no).value = commaSplit(filterNum(document.getElementById("income_total"+row_no).value)/form_txt_rate2_);
							if(document.getElementById("expense_total"+row_no) != undefined && document.getElementById("other_expense_total"+row_no) != undefined)
								document.getElementById("other_expense_total"+row_no).value = commaSplit(filterNum(document.getElementById("expense_total"+row_no).value)/form_txt_rate2_);
							if(document.getElementById("diff_total"+row_no) != undefined && document.getElementById("other_diff_total"+row_no) != undefined)
								document.getElementById("other_diff_total"+row_no).value = commaSplit(filterNum(document.getElementById("diff_total"+row_no).value)/form_txt_rate2_);
						}
					}
				else
					for (var i=1; i<=document.getElementById("kur_say").value; i++)
					{
						if(document.add_budget_plan.rd_money[i-1].checked == true)
						{
							form_txt_rate2_ = filterNum(document.getElementById("txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
							document.getElementById("other_income_total"+row_no).value = commaSplit(filterNum(document.getElementById("income_total"+row_no).value)/form_txt_rate2_);
							if(document.getElementById("expense_total"+row_no) != undefined && document.getElementById("other_expense_total"+row_no) != undefined)
								document.getElementById("other_expense_total"+row_no).value = commaSplit(filterNum(document.getElementById("expense_total"+row_no).value)/form_txt_rate2_);
							if(document.getElementById("diff_total"+row_no) != undefined && document.getElementById("other_diff_total"+row_no) != undefined)
								document.getElementById("other_diff_total"+row_no).value = commaSplit(filterNum(document.getElementById("diff_total"+row_no).value)/form_txt_rate2_);
						}
					}
				toplam_hesapla();
			}
			function toplam_hesapla()
			{
				var total_amount = 0;
				var other_total_amount = 0;
				var expense_total = 0;
				var other_expense_total = 0;
				var diff_total = 0;
				var other_diff_total = 0;
				for(j=1;j<=document.getElementById("record_num").value;j++)
				{
					if(document.getElementById("row_kontrol"+j).value==1)
					{
						total_amount = parseFloat(total_amount + parseFloat(filterNum(document.getElementById("income_total"+j).value)));
						other_total_amount = parseFloat(other_total_amount + parseFloat(filterNum(document.getElementById("other_income_total"+j).value)));
						expense_total = parseFloat(expense_total + parseFloat(filterNum(document.getElementById("expense_total"+j).value)));
						if(document.getElementById("other_expense_total"+j) != undefined)
							other_expense_total = parseFloat(other_expense_total + parseFloat(filterNum(document.getElementById("other_expense_total"+j).value)));
						if(document.getElementById("diff_total"+j) != undefined)
							diff_total = parseFloat(diff_total + parseFloat(filterNum(document.getElementById("diff_total"+j).value)));
						if(document.getElementById("other_diff_total"+j) != undefined)
							other_diff_total = parseFloat(other_diff_total + parseFloat(filterNum(document.getElementById("other_diff_total"+j).value)));
					}
				}
				document.getElementById("income_total_amount").value = commaSplit(total_amount);
				document.getElementById("other_income_total_amount").value = commaSplit(other_total_amount);
				document.getElementById("expense_total_amount").value = commaSplit(expense_total);
				document.getElementById("other_expense_total_amount").value = commaSplit(other_expense_total);
				document.getElementById("diff_total_amount").value = commaSplit(diff_total);
				document.getElementById("other_diff_total_amount").value = commaSplit(other_diff_total);
			}
			function toplam_doviz_hesapla()
			{
				if(document.getElementById("kur_say").value == 1)
					for (var t=1; t<=document.getElementById("kur_say").value; t++)
					{
						if(document.document.getElementById("rd_money").checked == true)
						{
							for(k=1;k<=document.getElementById("record_num").value;k++)
							{
								rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
								document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
								if(document.getElementById("other_expense_total"+k) != undefined)
									document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
								if(document.getElementById("diff_total"+k) != undefined && document.getElementById("other_diff_total"+k) != undefined)
									document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
							}
							document.getElementById("other_money_info").value = document.getElementById("rd_money").value;
							if(document.getElementById("other_money_info2") != undefined)
								document.getElementById("other_money_info2").value = document.getElementById("rd_money").value;
							if(document.getElementById("other_money_info3") != undefined)
								document.getElementById("other_money_info3").value = document.getElementById("rd_money").value;
							if(document.getElementById("other_money_info4") != undefined)
								document.getElementById("other_money_info4").value = document.getElementById("rd_money").value;
						}
					}
				else
					for (var t=1; t<=document.getElementById("kur_say").value; t++)
					{
						if(document.add_budget_plan.rd_money[t-1].checked == true)
						{
							for(k=1;k<=document.getElementById("record_num").value;k++)
							{
								rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
								document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
								if(document.getElementById("other_expense_total"+k) != undefined)
									document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
								if(document.getElementById("diff_total"+k) != undefined && document.getElementById("other_diff_total"+k) != undefined)
									document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
							}
							document.getElementById("other_money_info").value = document.add_budget_plan.rd_money[t-1].value;
							if(document.getElementById("other_money_info2") != undefined)
								document.getElementById("other_money_info2").value = document.add_budget_plan.rd_money[t-1].value;
							if(document.getElementById("other_money_info3") != undefined)
								document.getElementById("other_money_info3").value = document.add_budget_plan.rd_money[t-1].value;
							if(document.getElementById("other_money_info4") != undefined)
								document.getElementById("other_money_info4").value = document.add_budget_plan.rd_money[t-1].value;
						}
					}
				toplam_hesapla();
			}
			function kontrol()
			{
				if(!chk_process_cat('add_budget_plan')) return false;
				if(!chk_period(add_budget_plan.record_date,"İşlem")) return false;
				if(!check_display_files('add_budget_plan')) return false;
				if(!paper_control(document.getElementById("paper_number"),'BUDGET_PLAN',true,'','','0','0','0','<cfoutput>#dsn#</cfoutput>')) return false;
				<cfif not isdefined("attributes.from_plan_list")>
					if(document.getElementById("budget_id").value == "")
					{
						alert("<cf_get_lang no='63.Lütfen İlişkili Bütçe Giriniz'>!");
						return false;
					}
				</cfif>
				<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2 and fusebox.circuit is not 'store'> //xmlde muhasebe icin departman secimi zorunlu ise
					if( document.getElementById("acc_department_id").options[document.getElementById("acc_department_id").selectedIndex].value=='')
					{
						alert('Lütfen Departman Seçiniz!');
						return false;
					}
				</cfif>
				if((document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3) && document.getElementById('due_date').value == '')
				{
					alert("Vade Tarihi Giriniz!");
					return false;
				}
				var record_exist=0;
				process = document.getElementById("process_cat").value;
				var selected_ptype = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
				eval('var proc_control = document.add_budget_plan.ct_process_type_'+selected_ptype+'.value');
				var get_process_cat = wrk_safe_query('bdg_get_process_cat','dsn3',0,process);
				var income_total_ = 0;
				var expense_total_ = 0;
				for(r=1;r<=document.getElementById("record_num").value;r++)
				{
					if(document.getElementById("row_kontrol"+r).value==1)
					{
						<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
						var account_code_value = list_getat(document.getElementById("account_code"+r).value,1,'-');
						if(account_code_value != "")
						{
							if(WrkAccountControl(account_code_value,r+'. Satır: Muhasebe Hesabı Hesap Planında Tanımlı Değildir!') == 0)
							return false;
						}
						<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
						record_exist=1;
						if (document.getElementById("expense_date"+r) != undefined && document.getElementById("expense_date"+r).value == "")
						{
							alert ("<cf_get_lang no='32.Satıra Lütfen Tarih Giriniz'>!");
							return false;
						}
						if (document.getElementById("row_detail"+r).value == "")
						{
							alert ("<cf_get_lang no='62.Lütfen Açıklama Giriniz'>!");
							return false;
						}
						if(proc_control != 161)
						{
							x = document.getElementById("expense_center_id"+r).selectedIndex;
							if (document.getElementById("expense_center_id"+r)[x].value == "")
							{
								alert ("<cf_get_lang no='60.Satıra Lütfen Masraf/Gelir Merkezi Seçiniz'>!");
								return false;
							}
							if (get_process_cat.IS_ACCOUNT == 0)
							{
								if (document.getElementById("expense_item_id"+r).value == "")
								{
									alert ("<cf_get_lang no='37.Satıra Lütfen Bütçe Kalemi Seçiniz'>!");
									return false;
								}
							}
							<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),10)>
								if(filterNum(document.getElementById("income_total"+r).value) > 0 && filterNum(document.getElementById("expense_total"+r).value) > 0)
								{
									if(document.getElementById("authorized"+r).value != "")
									{
										alert("<cf_get_lang no='18.Gelir ve Gider Değerlerini Girdiğinizde Cari Hesap Seçemezsiniz'> !");
										return false;
									}
								}
							</cfif>
							if (get_process_cat.IS_ACCOUNT == 1)
							{
								if (document.getElementById("account_code"+r).value == "")
								{
									alert ("<cf_get_lang no='39.Lütfen Muhasebe Kodu Seçiniz'>!");
									return false;
								}
							}
						}
						else
						{
							if ((document.getElementById("expense_item_id"+r).value == "" || document.getElementById("expense_item_name"+r).value == "") && document.getElementById("authorized"+r).value == '' && document.getElementById("account_code"+r).value == '')
							{
								alert ("Bütçe Kalemi , Cari Hesap veya Muhasebe Kodu Seçmelisiniz !");
								return false;
							}
							if ((document.getElementById("expense_item_id"+r).value != "" && document.getElementById("expense_item_name"+r).value != ""))
							{
								x = document.getElementById("expense_center_id"+r).selectedIndex;
								if (document.getElementById("expense_center_id"+r)[x].value == "")
								{
									alert ("<cf_get_lang no='60.Satıra Lütfen Masraf/Gelir Merkezi Seçiniz'>!");
									return false;
								}
							}
							if(filterNum(document.getElementById("income_total"+r).value) > 0 && filterNum(document.getElementById("expense_total"+r).value) > 0)
							{
								alert("Tahakkuk Fişi İçin Gelir ve Gider Değerlerini Aynı Anda Giremezsiniz !");
								return false;
							}
							if(document.getElementById("account_code"+r).value != '')
							{
								income_total_ = parseFloat(income_total_ + parseFloat(filterNum(document.getElementById("income_total"+r).value)));
								expense_total_ = parseFloat(expense_total_ + parseFloat(filterNum(document.getElementById("expense_total"+r).value)));
							}
						}
					}
				}
				if(document.getElementById("paper_number").value == "")
				{
					alert("<cf_get_lang no='28.Lütfen Belge No Giriniz'> !");
					return false;
				}
				if (record_exist == 0)
				{
					alert("<cf_get_lang no='58.Lütfen Plan Giriniz'>!");
					return false;
				}
				<cfif is_kontrol_value eq 1>
					if(proc_control == 161)
					{
						if(filterNum(document.getElementById("income_total_amount").value) != filterNum(document.getElementById("expense_total_amount").value))
						{
							alert("Tahakkuk Fişi İçin Gelir ve Gider Değer Toplamları Eşit Olmalı !");
							return false;
						}
					}
				</cfif>
				if(proc_control == 161 && get_process_cat.IS_ACCOUNT != 0)
				{
					if(commaSplit(income_total_) != commaSplit(expense_total_))
					{
						alert("Muhasebe Hesabı Seçilen Satırların Gelir Gider Toplamları Eşit Olmalı !");
						return false;
					}
				}
				unformat_fields();
				return process_cat_control();
				return true;
			}
			function unformat_fields()
			{
				for(rm=1;rm<=document.getElementById("record_num").value;rm++)
				{
					document.getElementById("income_total"+rm).value =  filterNum(document.getElementById("income_total"+rm).value);
					document.getElementById("other_income_total"+rm).value =  filterNum(document.getElementById("other_income_total"+rm).value);
					document.getElementById("expense_total"+rm).value =  filterNum(document.getElementById("expense_total"+rm).value);
					if(document.getElementById("other_expense_total"+rm) != undefined)
						document.getElementById("other_expense_total"+rm).value =  filterNum(document.getElementById("other_expense_total"+rm).value);
					if(document.getElementById("diff_total"+rm) != undefined)
						document.getElementById("diff_total"+rm).value =  filterNum(document.getElementById("diff_total"+rm).value);
					if(document.getElementById("other_diff_total"+rm) != undefined)
						document.getElementById("other_diff_total"+rm).value =  filterNum(document.getElementById("other_diff_total"+rm).value);
				}
		
				document.getElementById("income_total_amount").value = filterNum(document.getElementById("income_total_amount").value);
				document.getElementById("expense_total_amount").value = filterNum(document.getElementById("expense_total_amount").value);
				document.getElementById("diff_total_amount").value = filterNum(document.getElementById("diff_total_amount").value);
				document.getElementById("other_income_total_amount").value = filterNum(document.getElementById("other_income_total_amount").value);
				document.getElementById("other_expense_total_amount").value = filterNum(document.getElementById("other_expense_total_amount").value);
				document.getElementById("other_diff_total_amount").value = filterNum(document.getElementById("other_diff_total_amount").value);
				for(st=1;st<=document.getElementById("kur_say").value;st++)
				{
					document.getElementById("txt_rate2_"+ st).value = filterNum(document.getElementById("txt_rate2_" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("txt_rate1_"+ st).value = filterNum(document.getElementById("txt_rate1_"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
			
			function autocomp_cari(no)
			{
				<cfif xml_account_code_from_member eq 1>
					AutoComplete_Create("authorized"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'","MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,ACCOUNT_CODE,ACCOUNT_CODE","member_type"+no+",company_id"+no+",consumer_id"+no+",employee_id"+no+",account_code"+no+",account_id"+no,"add_budget_plan",3,250);
				<cfelse>
					AutoComplete_Create("authorized"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'","MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID","member_type"+no+",company_id"+no+",consumer_id"+no+",employee_id"+no,3,250);
				</cfif>
			}
			$( document ).ready(function() {
			    toplam_hesapla();
				toplam_doviz_hesapla();
				
			});
			
		</script>
    </cfif>
    <cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)>
    	<cfif len(attributes.budget_plan_id) and len(get_budget_plan.process_cat) and len(get_budget_plan.process_type)>
            <cfquery name="get_company_period_control" datasource="#dsn#">
                SELECT PERIOD_ID,OUR_COMPANY_ID FROM BUDGET_PLAN WHERE BUDGET_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.budget_plan_id#">
            </cfquery>
            <cfif  len(get_company_period_control.period_id) and (get_company_period_control.period_id neq session.ep.period_id or get_company_period_control.our_company_id neq session.ep.company_id)>
                <script type="text/javascript">
                    alert("<cf_get_lang no='30.Bu Bütçe Çalıştığınız Şirket ve Muhasebe Döneminde Tanımlı Değildir'>!");
                    history.back();
                </script>
                <cfabort>
            </cfif>
        </cfif>
        
        <cfquery name="get_budget_plan_money" datasource="#dsn#">
            SELECT MONEY_TYPE AS MONEY,* FROM BUDGET_PLAN_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.budget_plan_id#">
        </cfquery>
        <cfif not get_budget_plan_money.recordcount>
            <cfquery name="get_budget_plan_money" datasource="#dsn2#">
                SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY ORDER BY MONEY_ID
            </cfquery>
        </cfif>
        
        <cfscript>
            netbook = createObject("component","account.cfc.netbook");
            netbook.dsn = dsn;
            get_account_card_document_types = netbook.getAccountCardDocumentTypes(is_company : 1, is_active : 1);
            get_account_card_payment_types = netbook.getAccountCardPaymentTypes(is_active : 1);
        </cfscript>
         <cfif len(get_budget_plan.budget_id)>
            <cfset budget_id = get_budget_plan.budget_id>
            <cfset budget_name = get_budget.budget_name>
        <cfelse>
            <cfset budget_id = ''>
            <cfset budget_name = ''>
        </cfif>
        <script type="text/javascript">
			
			$( document ).ready(function() {
				row_count=<cfoutput>#get_budget_plan_row.recordcount#</cfoutput>;
			});
			
			function check_all(deger)
			{
				if(add_budget_plan.hepsi.checked)
				{
					for(i=1;i<=document.getElementById("record_num").value;i++)
					{
						if(document.getElementById("row_kontrol"+i).value==1 && document.getElementById("is_payment"+i).disabled==false)
						{
							var form_field = document.getElementById("is_payment" + i);
							form_field.checked = true;
							document.getElementById("is_payment"+i).focus();
						}
					}
				}
				else
				{
					for(i=1;i<=document.getElementById("record_num").value;i++)
					{
						if(document.getElementById("row_kontrol"+i).value==1 && document.getElementById("is_payment"+i).disabled==false)
						{
							form_field = document.getElementById("is_payment" + i);
							form_field.checked = false;
							document.getElementById("is_payment"+i).focus();
						}
					}
				}
			}
			
			function add_row(expense_date,row_detail,expense_center_id,expense_item_id,expense_item_name,expense_cat_id,expense_cat_name,account_id,account_code,activity_type,workgroup_id,member_type,company_id,consumer_id,employee_id,authorized,project_id,project_head,income_total,expense_total,diff_total,other_income_total,other_expense_total,other_diff_total,assetp_id,assetp_name)
			{
				//Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
				if(expense_date == undefined)expense_date = '';
				if(row_detail == undefined)row_detail = '';
				if(expense_center_id == undefined)expense_center_id = '';
				if(expense_item_id == undefined)expense_item_id = '';
				if(expense_item_name == undefined)expense_item_name = '';
				if(expense_cat_id == undefined)expense_cat_id = '';
				if(expense_cat_name == undefined)expense_cat_name = '';
				if(account_id == undefined)account_id = '';
				if(account_code == undefined)account_code = '';
				if(activity_type == undefined)activity_type = '';
				if(workgroup_id == undefined)workgroup_id = '';
				if(member_type == undefined)member_type = '';
				if(company_id == undefined)company_id = '';
				if(consumer_id == undefined)consumer_id = '';
				if(employee_id == undefined)employee_id = '';
				if(authorized == undefined)authorized = '';
				if(project_id == undefined) project_id = '';
				if(project_head == undefined) project_head = '';
				if(assetp_id == undefined) assetp_id = '';
				if(assetp_name == undefined) assetp_name = '';
				if(income_total == undefined)income_total = 0;
				if(expense_total == undefined)expense_total = 0;
				if(diff_total == undefined)diff_total = 0;
				if(other_income_total == undefined)other_income_total = 0;
				if(other_expense_total == undefined)other_expense_total = 0;
				if(other_diff_total == undefined)other_diff_total = 0;
		
				row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);
				newRow.className = 'color-row';
				document.getElementById("record_num").value=row_count;
				document.getElementById("record_num_kontrol").value=document.getElementById("record_num_kontrol").value+1;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="satir_no' + row_count +'" id="satir_no' + row_count +'" value=' +row_count+' class="boxtext" style="width:15px;" readonly="yes">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" value="0" name="budget_plan_row_id' + row_count +'" id="budget_plan_row_id' + row_count +'"><input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img src="images/delete_list.gif" alt="Sil" border="0"></a><a style="cursor:pointer" onclick="copy_row(' + row_count + ');" title="Satır Kopyala"><img  src="images/copy_list.gif" border="0"></a>';
				<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
					<cfswitch expression="#xlr#">
						<cfcase value="1">//1.Tarih
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("id","expense_date" + row_count + "_td");
							newCell.innerHTML = '<input type="text" name="expense_date' + row_count +'" id="expense_date' + row_count +'" class="text" maxlength="10" style="width:95px;" value="' + expense_date +'"> ';
							wrk_date_image('expense_date' + row_count);
						</cfcase>
						<cfcase value="2">//2.Açıklama
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:120px;" class="boxtext" maxlength="300" value="' + row_detail +'">';
						</cfcase>
						<cfcase value="3">//3.Masraf Merkezi
							newCell = newRow.insertCell(newRow.cells.length);
							a = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'"  style="width:100px;" class="boxtext"><option value="">Masraf/Gelir Merkezi</option>';
							<cfoutput query="get_expense_center">
							if('#expense_id#' == expense_center_id)
								a += '<option value="#expense_id#" selected>#expense#</option>';
							else
								a += '<option value="#expense_id#">#expense#</option>';
							</cfoutput>
							newCell.innerHTML =a+ '</select>';
						</cfcase>
						<cfcase value="4">//4.Butce Kategorisi
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type ="hidden" name="expense_cat_id' + row_count + '" id="expense_cat_id' + row_count + '" value="'+ expense_cat_id +'"><input type="text" name="expense_cat_name'+ row_count +'" id="expense_cat_name'+ row_count +'" value="'+ expense_cat_name +'" class="boxtext">';
						</cfcase>
						<cfcase value="5">//5.Butce Kalemi
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input  type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+expense_item_id+'"><input type="text" style="width:105px;" name="expense_item_name' + row_count +'" id="expense_item_name' + row_count +'" class="boxtext" value="'+expense_item_name+'" onFocus="autocomp_budget('+row_count+');"> <a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" alt="" border="0"></a>';
						</cfcase>
						<cfcase value="6">//6.Muhasebe Kodu
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input  type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+account_id+'"><input type="text" style="width:105px;" name="account_code' + row_count +'" id="account_code' + row_count +'" class="boxtext"  value="'+account_code+'" onFocus="autocomp_acc_code('+row_count+');"> <a href="javascript://"><img src="/images/plus_thin.gif" alt="" onclick="pencere_ac_acc('+ row_count +');" align="absmiddle" border="0"></a>';
						</cfcase>
						<cfcase value="7">//7.Aktivite Tipi
							newCell = newRow.insertCell(newRow.cells.length);
							b = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:100px;" class="boxtext"><option value="">Aktivite Tipi</option>';
							<cfoutput query="get_activity_types">
								if('#activity_id#' == activity_type)
									b += '<option value="#activity_id#" selected>#activity_name#</option>';
								else
									b += '<option value="#activity_id#">#activity_name#</option>';
							</cfoutput>
							newCell.innerHTML =b+ '</select>';
						</cfcase>
						<cfcase value="8">//8.Is Grubu
							newCell = newRow.insertCell(newRow.cells.length);
							b = '<select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:100px;" class="boxtext"><option value=""><cf_get_lang_main no='728.İş Grubu'></option>';
							<cfoutput query="get_workgroups">
								if('#workgroup_id#' == workgroup_id)
									b += '<option value="#workgroup_id#" selected>#workgroup_name#</option>';
								else
									b += '<option value="#workgroup_id#">#workgroup_name#</option>';
							</cfoutput>
							newCell.innerHTML =b+ '</select>';
						</cfcase>
						<cfcase value="17">//17.Fiziki Varlik
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute('nowrap','nowrap');
							newCell.innerHTML = '<input type="hidden" name="assetp_id'+ row_count +'" id="assetp_id'+ row_count +'" value="'+assetp_id+'"><input type="text" style="width:105px;" name="assetp_name'+ row_count +'" id="assetp_name'+ row_count +'" onFocus="autocomp_assetp('+row_count+');" value="'+assetp_name+'" class="boxtext"> <a href="javascript://" onClick="pencere_ac_assetp('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
						</cfcase>
						<cfcase value="9">//9.Proje
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+project_id+'"><input type="text" style="width:105px;" name="project_head'+ row_count +'" id="project_head'+ row_count +'" onFocus="autocomp_project('+row_count+');" value="'+project_head+'" class="boxtext"> <a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
						</cfcase>
						<cfcase value="10">//10.Cari Hesap
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value="'+member_type+'"><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value="'+company_id+'"><input type="hidden" name="consumer_id'+ row_count +'" id="consumer_id'+ row_count +'" value="'+consumer_id+'"><input type="hidden" name="employee_id'+ row_count +'" id="employee_id'+ row_count +'" value="'+employee_id+'"><input type="text" style="width:110px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="'+authorized+'" onFocus="autocomp_cari('+row_count+');" class="boxtext">&nbsp;<a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
						</cfcase>
						<cfcase value="11">//11.Gelir TL
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="income_total' + row_count +'" id="income_total' + row_count +'" value="'+income_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
						</cfcase>
						<cfcase value="12">//12.Gider TL
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="expense_total' + row_count +'" id="expense_total' + row_count +'" value="'+expense_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';
						</cfcase>
						<cfcase value="13">//13.Fark TL
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="diff_total' + row_count +'" id="diff_total' + row_count +'" value="'+diff_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="hesapla('+row_count+');" readonly="yes">';
						</cfcase>
						<cfcase value="14">//Gelir Doviz
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="other_income_total' + row_count +'" id="other_income_total' + row_count +'" value="'+other_income_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly="yes">';
						</cfcase>
						<cfcase value="15">//Gider Doviz
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="other_expense_total' + row_count +'" id="other_expense_total' + row_count +'" value="'+other_expense_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly="yes">';
						</cfcase>
						<cfcase value="16">//Fark Doviz
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.innerHTML = '<input type="text" name="other_diff_total' + row_count +'" id="other_diff_total' + row_count +'" value="'+other_diff_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly="yes">';
						</cfcase>
					</cfswitch>
				</cfloop>
				toplam_hesapla();
			}
			
			
			function pencere_ac_exp(no)
			{
				var selected_ptype = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
				eval('var proc_control = document.add_budget_plan.ct_process_type_'+selected_ptype+'.value');
				if(document.getElementById("expense_cat_id" + no) != undefined)
				{
					if(proc_control != 161)
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_budget_plan.expense_item_id' + no +'&field_name=add_budget_plan.expense_item_name' + no + '&field_account_no=add_budget_plan.account_code' + no +'&field_account_no2=add_budget_plan.account_id' + no + '&field_cat_id=add_budget_plan.expense_cat_id' + no + '&field_cat_name=add_budget_plan.expense_cat_name' + no,'list');
					else
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_budget_plan.expense_item_id' + no +'&field_name=add_budget_plan.expense_item_name' + no + '&field_cat_id=add_budget_plan.expense_cat_id' + no + '&field_cat_name=add_budget_plan.expense_cat_name' + no,'list');
				}
				else
				{
					if(proc_control != 161)
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_budget_plan.expense_item_id' + no +'&field_name=add_budget_plan.expense_item_name' + no + '&field_account_no=add_budget_plan.account_code' + no +'&field_account_no2=add_budget_plan.account_id' + no,'list');
					else
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_budget_plan.expense_item_id' + no +'&field_name=add_budget_plan.expense_item_name' + no,'list');
				}
			}
		
			
			function hesapla(row_no)
			{
				if(document.getElementById("diff_total"+row_no) != undefined)
					document.getElementById("diff_total"+row_no).value = commaSplit(filterNum(document.getElementById("income_total"+row_no).value)-filterNum(document.getElementById("expense_total"+row_no).value));
				if(document.getElementById("kur_say").value == 1)
					for (var t=1; t<=document.getElementById("kur_say").value; t++)
					{
						if(document.getElementById("rd_money").checked == true)
						{
							for(k=1;k<=document.getElementById("record_num").value;k++)
							{
								rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
								document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
								if(document.getElementById("other_expense_total"+k) != undefined)
									document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
								if(document.getElementById("other_diff_total"+k) != undefined)
									document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
							}
							document.getElementById("other_money_info").value = document.getElementById("rd_money").value;
							if(document.getElementById("other_money_info2") != undefined)
								document.getElementById("other_money_info2").value = document.getElementById("rd_money").value;
							if(document.getElementById("other_money_info3") != undefined)
								document.getElementById("other_money_info3").value = document.getElementById("rd_money").value;
							if(document.getElementById("other_money_info4") != undefined)
								document.getElementById("other_money_info4").value = document.getElementById("rd_money").value;
						}
					}
				else
					for (var t=1; t<=document.getElementById("kur_say").value; t++)
					{
						if(document.add_budget_plan.rd_money[t-1].checked == true)
						{
							for(k=1;k<=document.getElementById("record_num").value;k++)
							{
								rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
								if(document.getElementById("other_income_total"+k) != undefined)
									document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
								if(document.getElementById("other_expense_total"+k) != undefined)
									document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
								if(document.getElementById("other_diff_total"+k) != undefined)
									document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
							}
							document.getElementById("other_money_info").value = document.add_budget_plan.rd_money[t-1].value;
							if(document.getElementById("other_money_info2") != undefined)
								document.getElementById("other_money_info2").value = document.add_budget_plan.rd_money[t-1].value;
							if(document.getElementById("other_money_info3") != undefined)
								document.getElementById("other_money_info3").value = document.add_budget_plan.rd_money[t-1].value;
							if(document.getElementById("other_money_info4") != undefined)
								document.getElementById("other_money_info4").value = document.add_budget_plan.rd_money[t-1].value;
						}
					}
				toplam_hesapla();
			}
			function toplam_hesapla()
			{
				var total_amount = 0;
				var other_total_amount = 0;
				var expense_total = 0;
				var other_expense_total = 0;
				var diff_total = 0;
				var other_diff_total = 0;
				for(j=1;j<=document.getElementById("record_num").value;j++)
				{
					if(document.getElementById("row_kontrol"+j).value==1)
					{
						total_amount = parseFloat(total_amount + parseFloat(filterNum(document.getElementById("income_total"+j).value)));
						if(document.getElementById("other_income_total"+j) != undefined)
							other_total_amount = parseFloat(other_total_amount + parseFloat(filterNum(document.getElementById("other_income_total"+j).value)));
						expense_total = parseFloat(expense_total + parseFloat(filterNum(document.getElementById("expense_total"+j).value)));
						if(document.getElementById("other_expense_total"+j) != undefined)
							other_expense_total = parseFloat(other_expense_total + parseFloat(filterNum(document.getElementById("other_expense_total"+j).value)));
						if(document.getElementById("diff_total"+j) != undefined)
							diff_total = parseFloat(diff_total + parseFloat(filterNum(document.getElementById("diff_total"+j).value)));
						if(document.getElementById("other_diff_total"+j) != undefined)
							other_diff_total = parseFloat(other_diff_total + parseFloat(filterNum(document.getElementById("other_diff_total"+j).value)));
					}
				}
				document.getElementById("income_total_amount").value = commaSplit(total_amount);
				document.getElementById("other_income_total_amount").value = commaSplit(other_total_amount);
				document.getElementById("expense_total_amount").value = commaSplit(expense_total);
				document.getElementById("other_expense_total_amount").value = commaSplit(other_expense_total);
				document.getElementById("diff_total_amount").value = commaSplit(diff_total);
				document.getElementById("other_diff_total_amount").value = commaSplit(other_diff_total);
			}
			function toplam_doviz_hesapla()
			{
				if(document.getElementById("kur_say").value == 1)
					for (var t=1; t<=document.getElementById("kur_say").value; t++)
					{
						if(document.getElementById("rd_money").checked == true)
						{
							for(k=1;k<=document.getElementById("record_num").value;k++)
							{
								rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
								document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
								if(document.getElementById("other_expense_total"+k) != undefined)
									document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
								if(document.getElementById("other_diff_total"+k) != undefined)
									document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
							}
							document.getElementById("other_money_info").value = document.getElementById("rd_money").value;
							document.getElementById("other_money_info2").value = document.getElementById("rd_money").value;
							if(document.getElementById("other_money_info3") != undefined)
								document.getElementById("other_money_info3").value = document.getElementById("rd_money").value;
							if(document.getElementById("other_money_info4") != undefined)
								document.getElementById("other_money_info4").value = document.getElementById("rd_money").value;
						}
					}
				else
					for (var t=1; t<=document.getElementById("kur_say").value; t++)
					{
						if(document.add_budget_plan.rd_money[t-1].checked == true)
						{
							for(k=1;k<=document.getElementById("record_num").value;k++)
							{
								rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
								if(document.getElementById("other_income_total"+k) != undefined)
									document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
								if(document.getElementById("other_expense_total"+k) != undefined)
									document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
								if(document.getElementById("other_diff_total"+k) != undefined)
									document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
							}
							document.getElementById("other_money_info").value = document.add_budget_plan.rd_money[t-1].value;
							document.getElementById("other_money_info2").value = document.add_budget_plan.rd_money[t-1].value;
							if(document.getElementById("other_money_info3") != undefined)
								document.getElementById("other_money_info3").value = document.add_budget_plan.rd_money[t-1].value;
							if(document.getElementById("other_money_info4") != undefined)
								document.getElementById("other_money_info4").value = document.add_budget_plan.rd_money[t-1].value;
						}
					}
				toplam_hesapla();
			}
			function del_kontrol()
			{
				return control_account_process(<cfoutput>'#attributes.budget_plan_id#','#get_budget_plan.PROCESS_TYPE#'</cfoutput>);
			}
			function kontrol()
			{
				if(!chk_process_cat('add_budget_plan')) return false;
				if(!chk_period(add_budget_plan.record_date,"İşlem")) return false;
				if(!check_display_files('add_budget_plan')) return false;
				if(!paper_control(document.getElementById("paper_number"),'BUDGET_PLAN',true,'<cfoutput>#attributes.budget_plan_id#</cfoutput>','<cfoutput>#get_budget_plan.paper_no#</cfoutput>','0','0','0','<cfoutput>#dsn#</cfoutput>')) return false;
				if(document.getElementById("paper_number").value == "")
				{
					alert("<cf_get_lang no='28.Lütfen Belge No Giriniz'> !");
					return false;
				}
				if((document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3) && document.getElementById('due_date').value == '')
				{
					alert("Vade Tarihi Giriniz!");
					return false;
				}
				var record_exist=0;
				process=document.getElementById("process_cat").value;
				var get_process_cat = wrk_safe_query('bdg_get_process_cat','dsn3',0,process);
				var selected_ptype = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
				eval('var proc_control = document.add_budget_plan.ct_process_type_'+selected_ptype+'.value');
				var income_total_ = 0;
				var expense_total_ = 0;
				<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2 and fusebox.circuit is not 'store'> //xmlde muhasebe icin departman secimi zorunlu ise
					if( document.getElementById("acc_department_id").options[document.getElementById("acc_department_id").selectedIndex].value=='')
					{
						alert('Lütfen Departman Seçiniz!');
						return false;
					}
				</cfif>
				for(r=1;r<=document.getElementById("record_num").value;r++)
				{
					if(document.getElementById("row_kontrol"+r).value==1)
					{
						<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
						var account_code_value = list_getat(document.getElementById("account_code"+r).value,1,'-');
						if(account_code_value != "")
						{
							if(WrkAccountControl(account_code_value,r+'. Satır: Muhasebe Hesabı Hesap Planında Tanımlı Değildir!') == 0)
							return false;
						}
						<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
						record_exist=1;
						if (document.getElementById("expense_date"+r) != undefined && document.getElementById("expense_date"+r).value == "")
						{
							alert ("<cf_get_lang_main no='1091.Lutfen Tarih Giriniz'>!");
							return false;
						}
						if (document.getElementById("row_detail"+r).value == "")
						{
							alert ("<cf_get_lang no='62.Lütfen Açıklama Giriniz'>!");
							return false;
						}
						if(proc_control != 161)
						{
							x = document.getElementById("expense_center_id"+r).selectedIndex;
							if (document.getElementById("expense_center_id"+r)[x].value == "")
							{
								alert ("<cf_get_lang no='60.Lütfen Masraf/Gelir Merkezi Seçiniz'>!");
								return false;
							}
							if (get_process_cat.IS_ACCOUNT == 0)
							{
								if (document.getElementById("expense_item_id"+r).value == "" || document.getElementById("expense_item_name"+r).value == "")
								{
									alert ("<cf_get_lang no='37.Lütfen Bütçe Kalemi Seçiniz'>!");
									return false;
								}
							}
							<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),10)>
								if(filterNum(document.getElementById("income_total"+r).value) > 0 && filterNum(document.getElementById("expense_total"+r).value) > 0)
								{
									if(document.getElementById("authorized"+r).value != "")
									{
										alert("<cf_get_lang no='18.Gelir ve Gider Değerlerini Girdiğinizde Cari Hesap Seçemezsiniz'> !");
										return false;
									}
								}
							</cfif>
							if (get_process_cat.IS_ACCOUNT == 1)
							{
								if (document.getElementById("account_code"+r).value == "")
								{
									alert ("<cf_get_lang no='39.Lütfen Muhasebe Kodu Seçiniz'> !");
									return false;
								}
							}
						}
						else
						{
							if ((document.getElementById("expense_item_id"+r).value == "" || document.getElementById("expense_item_name"+r).value == "") && document.getElementById("authorized"+r).value == '' && document.getElementById("account_code"+r).value == '')
							{
								alert ("Bütçe Kalemi , Cari Hesap veya Muhasebe Kodu Seçmelisiniz !");
								return false;
							}
							if ((document.getElementById("expense_item_id"+r).value != "" && document.getElementById("expense_item_name"+r).value != ""))
							{
								x = document.getElementById("expense_center_id"+r).selectedIndex;
								if (document.getElementById("expense_center_id"+r)[x].value == "")
								{
									alert ("<cf_get_lang no='60.Satıra Lütfen Masraf/Gelir Merkezi Seçiniz'>!");
									return false;
								}
							}
							if(filterNum(document.getElementById("income_total"+r).value) > 0 && filterNum(document.getElementById("expense_total"+r).value) > 0)
							{
								alert("Tahakkuk Fişi İçin Gelir ve Gider Değerlerini Aynı Anda Giremezsiniz !");
								return false;
							}
							if(document.getElementById("account_code"+r).value != '')
							{
								income_total_ = parseFloat(income_total_ + parseFloat(filterNum(document.getElementById("income_total"+r).value)));
								expense_total_ = parseFloat(expense_total_ + parseFloat(filterNum(document.getElementById("expense_total"+r).value)));
							}
						}
					}
				}
				<cfif is_kontrol_value eq 1>
					if(proc_control == 161)
					{
						if(filterNum(document.getElementById("income_total_amount").value) != filterNum(document.getElementById("expense_total_amount").value))
						{
							alert("Tahakkuk Fişi İçin Gelir ve Gider Değer Toplamları Eşit Olmalı !");
							return false;
						}
					}
				</cfif>
				if(proc_control == 161 && get_process_cat.IS_ACCOUNT != 0)
				{
					if(commaSplit(income_total_) != commaSplit(expense_total_))
					{
						alert("Muhasebe Hesabı Seçilen Satırların Gelir Gider Toplamları Eşit Olmalı !");
						return false;
					}
				}
				if (record_exist == 0)
				{
					alert("<cf_get_lang no='58.Lütfen Plan Giriniz'>!");
					return false;
				}
				unformat_fields();
				return process_cat_control();
				return control_account_process(<cfoutput>'#attributes.budget_plan_id#','#get_budget_plan.PROCESS_TYPE#'</cfoutput>);
				return true;
			}
			function unformat_fields()
			{
				for(rm=1;rm<=document.getElementById("record_num").value;rm++)
				{
					document.getElementById("income_total"+rm).value =  filterNum(document.getElementById("income_total"+rm).value);
					if(document.getElementById("other_income_total"+rm) != undefined)
						document.getElementById("other_income_total"+rm).value =  filterNum(document.getElementById("other_income_total"+rm).value);
					document.getElementById("expense_total"+rm).value =  filterNum(document.getElementById("expense_total"+rm).value);
					if(document.getElementById("other_expense_total"+rm) != undefined)
						document.getElementById("other_expense_total"+rm).value =  filterNum(document.getElementById("other_expense_total"+rm).value);
					if(document.getElementById("diff_total"+rm) != undefined)
						document.getElementById("diff_total"+rm).value =  filterNum(document.getElementById("diff_total"+rm).value);
					if(document.getElementById("other_diff_total"+rm) != undefined)
						document.getElementById("other_diff_total"+rm).value =  filterNum(document.getElementById("other_diff_total"+rm).value);
				}
				document.getElementById("income_total_amount").value = filterNum(document.getElementById("income_total_amount").value);
				document.getElementById("expense_total_amount").value = filterNum(document.getElementById("expense_total_amount").value);
				document.getElementById("other_income_total_amount").value = filterNum(document.getElementById("other_income_total_amount").value);
				document.getElementById("other_expense_total_amount").value = filterNum(document.getElementById("other_expense_total_amount").value);
				document.getElementById("diff_total_amount").value = filterNum(document.getElementById("diff_total_amount").value);
				document.getElementById("other_diff_total_amount").value = filterNum(document.getElementById("other_diff_total_amount").value);
				for(st=1;st<=document.getElementById("kur_say").value;st++)
				{
					document.getElementById("txt_rate2_"+ st).value = filterNum(document.getElementById("txt_rate2_" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("txt_rate1_"+ st).value = filterNum(document.getElementById("txt_rate1_"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
		
			}
			
			function autocomp_cari(no)
			{
				<cfif xml_account_code_from_member eq 1>
					AutoComplete_Create("authorized"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","\"1,2,3\",\"\",\"\",\"\",\"\",\"\",\"\",\"1\",\"\",\"\"","MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,ACCOUNT_CODE,ACCOUNT_CODE","member_type"+no+",company_id"+no+",consumer_id"+no+",employee_id"+no+",account_code"+no+",account_id"+no,'add_budget_plan',3,250);
				<cfelse>
					AutoComplete_Create("authorized"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","\"1,2,3\",\"\",\"\",\"\",\"\",\"\",\"\",\"1\"","MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID","member_type"+no+",company_id"+no+",consumer_id"+no+",employee_id"+no,3,250);
				</cfif>
			}
			$( document ).ready(function() {
			    toplam_hesapla();
				toplam_doviz_hesapla();
			});
			
		</script>
    </cfif>
	<script type="text/javascript">
		function display_duedate()
		{
			if(document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3)
			{
				document.getElementById('td_due_date_label').style.display = '';
				document.getElementById('td_due_date_input').style.display = '';
			}
			else
			{
				document.getElementById('td_due_date_label').style.display = 'none';
				document.getElementById('td_due_date_input').style.display = 'none';
			}
		}
		function sil(sy)
		{
			var my_element=document.getElementById("row_kontrol"+sy);
			my_element.value=0;
			var my_element=document.getElementById("frm_row"+sy);
			my_element.style.display="none";
			toplam_hesapla();
			document.getElementById("record_num_kontrol").value=document.getElementById("record_num_kontrol").value-1;
		}
		function copy_row(no)
		{
			if (document.getElementById("expense_date" + no) == undefined) expense_date =""; else expense_date = document.getElementById("expense_date" + no).value;
			if (document.getElementById("row_detail" + no) == undefined) row_detail =""; else row_detail = document.getElementById("row_detail" + no).value;
			if (document.getElementById("expense_center_id" + no) == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id" + no).value;
			if (document.getElementById("expense_item_id" + no) == undefined) expense_item_id =""; else expense_item_id = document.getElementById("expense_item_id" + no).value;
			if (document.getElementById("expense_item_name" + no) == undefined) expense_item_name =""; else expense_item_name = document.getElementById("expense_item_name" + no).value;
			if(document.getElementById("expense_cat_id" + no) != undefined)
			{
				expense_cat_id = document.getElementById("expense_cat_id" + no).value;
				expense_cat_name = document.getElementById("expense_cat_name" + no).value;
			}
			else
			{
				expense_cat_id = '';
				expense_cat_name = '';
			}
			if (document.getElementById("account_id" + no) == undefined) account_id =""; else account_id = document.getElementById("account_id" + no).value;
			if (document.getElementById("account_code" + no) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no).value;
			if (document.getElementById("activity_type" + no) == undefined) activity_type =""; else activity_type = document.getElementById("activity_type" + no).value;
			if (document.getElementById("workgroup_id" + no) == undefined) workgroup_id =""; else workgroup_id = document.getElementById("workgroup_id" + no).value;
			if (document.getElementById("member_type" + no) == undefined) member_type =""; else member_type = document.getElementById("member_type" + no).value;
			if (document.getElementById("company_id" + no) == undefined) company_id =""; else company_id = document.getElementById("company_id" + no).value;
			if (document.getElementById("consumer_id" + no) == undefined) consumer_id =""; else consumer_id = document.getElementById("consumer_id" + no).value;
			if (document.getElementById("employee_id" + no) == undefined) employee_id =""; else employee_id = document.getElementById("employee_id" + no).value;
			if (document.getElementById("authorized" + no) == undefined) authorized =""; else authorized = document.getElementById("authorized" + no).value;
			if(document.getElementById("project_id" + no) != undefined)
			{
				project_id = document.getElementById("project_id" + no).value;
				project_head = document.getElementById("project_head" + no).value;
			}
			else
			{
				project_id = '';
				project_head = '';
			}
			if(document.getElementById("assetp_id" + no) != undefined)
			{
				assetp_id = document.getElementById("assetp_id" + no).value;
				assetp_name = document.getElementById("assetp_name" + no).value;
			}
			else
			{
				assetp_id = '';
				assetp_name = '';
			}
			if (document.getElementById("income_total" + no) == undefined) income_total =""; else income_total = document.getElementById("income_total" + no).value;
			if (document.getElementById("expense_total" + no) == undefined) expense_total =""; else expense_total = document.getElementById("expense_total" + no).value;
			if (document.getElementById("diff_total" + no) == undefined) diff_total =""; else diff_total = document.getElementById("diff_total" + no).value;
			if (document.getElementById("other_income_total" + no) == undefined) other_income_total =""; else other_income_total = document.getElementById("other_income_total" + no).value;
			if (document.getElementById("other_expense_total" + no) == undefined) other_expense_total =""; else other_expense_total = document.getElementById("other_expense_total" + no).value;
			if (document.getElementById("other_diff_total" + no) == undefined) other_diff_total =""; else other_diff_total = document.getElementById("other_diff_total" + no).value;
			add_row(expense_date,row_detail,expense_center_id,expense_item_id,expense_item_name,expense_cat_id,expense_cat_name,account_id,account_code,activity_type,workgroup_id,member_type,company_id,consumer_id,employee_id,authorized,project_id,project_head,income_total,expense_total,diff_total,other_income_total,other_expense_total,other_diff_total,assetp_id,assetp_name);
		}
		function pencere_ac_acc(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_budget_plan.account_id' + no +'&field_name=add_budget_plan.account_code' + no +'','list');
		}
		function pencere_ac_company(no)
		{
			document.getElementById("company_id"+no).value='';
			document.getElementById("authorized"+no).value='';
			document.getElementById("employee_id"+no).value='';
			document.getElementById("consumer_id"+no).value='';
			var send_account_code = '';
			<cfif xml_account_code_from_member eq 1>
				var send_account_code= "&field_member_account_code=add_budget_plan.account_code"+no+"&field_member_account_id=add_budget_plan.account_id"+no;
			</cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1'+send_account_code+'&field_name=add_budget_plan.authorized' + no +'&field_type=add_budget_plan.member_type' + no +'&field_comp_name=add_budget_plan.authorized' + no +'&field_consumer=add_budget_plan.consumer_id' + no + '&field_emp_id=add_budget_plan.employee_id' + no + '&field_comp_id=add_budget_plan.company_id' + no + '&select_list=1,2,3,9','list');
		}
		function change_date_info()
		{
			if(document.getElementById("temp_date").value != '')
				for(tt=1;tt<=document.getElementById("record_num").value;tt++)
					if(document.getElementById("row_kontrol"+tt).value==1)
						document.getElementById("expense_date"+tt).value = document.getElementById("temp_date").value;
		}
		function pencere_ac_project(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_budget_plan.project_id' + no +'&project_head=add_budget_plan.project_head' + no +'','list');
		}
		function autocomp_project(no)
		{
			AutoComplete_Create("project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","project_id"+no,"",3,200);
		}
		function pencere_ac_assetp(no)
		{
			adres = '<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps';
			adres += '&field_id=all.assetp_id' + no +'&field_name=all.assetp_name' + no +'&event_id=0&motorized_vehicle=0';
			windowopen(adres,'list');
		}
		function autocomp_assetp(no)
		{
			AutoComplete_Create("assetp_name"+no,"ASSETP","ASSETP","get_assetp_autocomplete","","ASSETP_ID","assetp_id"+no,"",3,200);
		}
		function autocomp_acc_code(no)
		{
			AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","","ACCOUNT_CODE","account_id"+no,"",3,225);
		}
		function autocomp_budget(no)
		{
			AutoComplete_Create("expense_item_name"+no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE,EXPENSE_CAT_ID,EXPENSE_CAT_NAME","expense_item_id"+no+",account_code"+no+",account_id"+no+",expense_cat_id"+no+",expense_cat_name"+no,3,200);
		}
    </script>

</cfif>

<cfif not IsDefined("attributes.event") or(IsDefined("attributes.event") and attributes.event eq 'list')>
	<cf_xml_page_edit fuseact="budget.add_budget_plan">
    <cfsetting showdebugoutput="yes">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.employee_name" default="">
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.budget_name" default="">
    <cfparam name="attributes.budget_id" default="">
    <cfparam name="attributes.paper_no" default="">
    <cfparam name="attributes.budget_action_type" default="">
    <cfparam name="attributes.search_date1" default="">
    <cfparam name="attributes.search_date2" default="">
    <cfparam name="attributes.listing_type" default="">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfif len(attributes.search_date1)>
        <cf_date tarih='attributes.search_date1'>
    </cfif>
    <cfif len(attributes.search_date2)>
        <cf_date tarih='attributes.search_date2'>
    </cfif>
    <cfquery name="get_process_cat" datasource="#dsn3#">
        SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (160,161)
    </cfquery>
    <cfif isDefined("attributes.form_submitted")>
        <cfquery name="GET_BUDGET_PLAN" datasource="#dsn#">
            SELECT 
                BP.PAPER_NO,
                BP.RECORD_EMP,
                BP.PROCESS_CAT,
                BP.BUDGET_ID,
                BP.BUDGET_PLAN_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_ID,
                B.BUDGET_NAME,
                B.BUDGET_ID,
                B.DETAIL,
                SPC.PROCESS_CAT,
                SPC.PROCESS_CAT_ID,
                BP.OTHER_MONEY
                <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                    ,BPR.BUDGET_PLAN_ID,
                    BPR.PLAN_DATE DATE,
                    BPR.DETAIL,
                    BPR.EXP_INC_CENTER_ID,
                    BPR.BUDGET_ITEM_ID,
                    BPR.ROW_TOTAL_INCOME INCOME,
                    BPR.ROW_TOTAL_EXPENSE EXPENSE,
                    BPR.OTHER_ROW_TOTAL_INCOME OTHER_INCOME,
                    BPR.OTHER_ROW_TOTAL_EXPENSE OTHER_EXPENSE,
                    EC.EXPENSE,
					EC.EXPENSE_ID,
                    EI.EXPENSE_ITEM_NAME,
					EI.EXPENSE_ITEM_ID
                <cfelse>
                    ,BP.INCOME_TOTAL INCOME,
                    BP.EXPENSE_TOTAL EXPENSE,
                    BP.OTHER_INCOME_TOTAL OTHER_INCOME,
                    BP.OTHER_EXPENSE_TOTAL OTHER_EXPENSE,
                    BP.BUDGET_PLAN_DATE DATE,
                    BP.DETAIL
                </cfif>
               
            FROM
                BUDGET_PLAN BP
                <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                    LEFT JOIN BUDGET_PLAN_ROW BPR ON BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID 
                    LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EC ON EC.EXPENSE_ID =  BPR.EXP_INC_CENTER_ID 
                    LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = BPR.BUDGET_ITEM_ID
                </cfif>
                LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = BP.RECORD_EMP
                LEFT JOIN BUDGET B ON B.BUDGET_ID = BP.BUDGET_ID
                LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = BP.PROCESS_CAT
            WHERE
               BP.PROCESS_CAT IN (SELECT PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(160,161))
                AND BP.PERIOD_ID = #session.ep.period_id#
                AND BP.OUR_COMPANY_ID = #session.ep.company_id#
                <cfif len(attributes.keyword)>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                        AND (BPR.DETAIL LIKE #sql_unicode()#'%#attributes.keyword#%'
                        OR BPR.BUDGET_ITEM_ID IN (SELECT EXPENSE_ITEM_ID FROM #dsn2_alias#.EXPENSE_ITEMS WHERE EXPENSE_ITEM_NAME LIKE #sql_unicode()#'%#attributes.keyword#%')
                        OR BPR.EXP_INC_CENTER_ID IN (SELECT EXPENSE_ID FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE LIKE #sql_unicode()#'%#attributes.keyword#%'))
                    </cfif>
                </cfif>
                <cfif len(attributes.paper_no)>
                    AND BP.PAPER_NO LIKE '%#attributes.paper_no#%'
                </cfif>
                <cfif len(attributes.budget_action_type)>
                    AND BP.PROCESS_CAT = #attributes.budget_action_type#
                </cfif>
                <cfif len(attributes.search_date1)>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                        AND BPR.PLAN_DATE >= #attributes.search_date1#
                    <cfelse>
                        AND BP.BUDGET_PLAN_DATE >= #attributes.search_date1#
                    </cfif>
                </cfif>
                <cfif len(attributes.search_date2)>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                        AND BPR.PLAN_DATE <= #attributes.search_date2#
                    <cfelse>
                        AND BP.BUDGET_PLAN_DATE <= #attributes.search_date2#
                    </cfif>
                </cfif>
                <cfif len(attributes.budget_name) and len(attributes.budget_id)>
                    AND BP.BUDGET_ID = #attributes.budget_id#
                </cfif>
                <cfif len(attributes.employee_id)  and len(attributes.employee_name)>
                    AND BP.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                </cfif>
            ORDER BY 
                BP.PAPER_NO
        </cfquery>
    <cfelse>
        <cfset GET_BUDGET_PLAN.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
    <cfparam name="attributes.totalrecords" default="#get_budget_plan.recordcount#">
    
    <script type="text/javascript">
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_plan_rows';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'budget/display/list_plan_rows.cfm';
	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.list_plan_rows';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'budget/form/add_budget_plan.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'budget/query/add_budget_plan.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.list_plan_rows&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('budget_plan','budget_plan_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.list_plan_rows';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'budget/form/add_budget_plan.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'budget/query/upd_budget_plan.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_plan_rows&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'budget_plan_id=##attributes.budget_plan_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.budget_plan_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('budget_plan','budget_plan_bask')";
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' or attributes.event is 'del' ))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'budget.emptypopup_del_budget_plan&budget_plan_id=#attributes.budget_plan_id#&old_process_type=#get_budget_plan.process_type#&budget_id=#get_budget_plan.budget_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'budget/query/del_budget_plan.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'budget/query/del_budget_plan.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'budget.list_plan_rows';
	}
	
	if(attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[1114]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=2',this)";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_digital_documents&budget_plan_id=#attributes.budget_plan_id#','page','add_process')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.budget_plan_id#&action_table=BUDGET_PLAN&process_cat='+upd_budget_plan.old_process_type.value','page','add_process')";
		
		if(len(get_budget_plan.BUDGET_ID))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = 'Butce Detay';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=budget.detail_budget&budget_id=#get_budget_plan.BUDGET_ID#','page','add_process')";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=add&from_plan_list=1";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=budget.list_plan_rows&event=add&from_plan_list=1&budget_plan_id=#attributes.budget_plan_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.budget_plan_id#&print_type=331','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'planRows';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'BUDGET_PLAN';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = '';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-2','item-3']"; 
</cfscript>
