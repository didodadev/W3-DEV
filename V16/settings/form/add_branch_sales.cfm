<cfquery name="TAXS" datasource="#DSN2#">
	SELECT 
    	TAX_ID, 
        TAX, 
        RECORD_DATE, 
        RECORD_EMP,
        RECORD_IP,
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_TAX 
    ORDER BY 
    	TAX_ID
</cfquery>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME
	FROM
		BRANCH
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="get_branch_sales" datasource="#DSN3#">
	SELECT IS_ACC_DISCOUNT,BRANCH_ID FROM SETUP_BRANCH_SALES
</cfquery>
<cfscript>
	for(shp_dd=1; shp_dd lte get_branch_sales.recordcount; shp_dd=shp_dd+1)
	{
		'branch_discount_info_#get_branch_sales.BRANCH_ID[shp_dd]#'=get_branch_sales.IS_ACC_DISCOUNT[shp_dd];
	}
</cfscript>
<cf_box title="#getLang('','Şube Kasa Satış Hesapları',42839)#" >
		<cfform name="add_branch_sales" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_branch_sales">
			<cf_grid_list>
				<thead>
			
				<th ><cf_get_lang_main no='1637.Şubeler'></th>
				<th  title="<cf_get_lang dictionary_id='45040.Muhasebe İşleminde'>"><cf_get_lang no='3054.İskontolar Alınmasın'></th>
			<cfif taxs.recordcount>
				<cfset counter = 0>
				<cfset list_tax = "">
				<cfoutput query="taxs">
				<cfset counter = counter + 1>
				<cfset list_tax = listappend(list_tax,tax_id,',')>
				<th nowrap="nowrap"><cf_get_lang_main no='36.Satış'>(#tax#)</th>
				<th nowrap="nowrap"><cf_get_lang_main no='1621.İade'>(#tax#)</th>
				<th  nowrap="nowrap"><cf_get_lang_main no ='1148.İndirim'> (#tax#)</th>
				</cfoutput>
			<!---kdv oranı tanımlı ise Tax.recordcount querysi dönüyor değilse alert veriyor altta cfelse ve kapsamı 4 satır silinmesi gerekebilir..---> 
			<cfelse>
				<script type="text/javascript">
					alert("<cf_get_lang no='1315.Kdv oranlarını tanımlamadan işlem yapamazsınız'> ! ");
					history.back();
				</script>
				<cfabort>
			</cfif>
		   	
		</thead>
		<tbody>
		<cfif get_branches.recordcount>
			<cfset len_tax = listlen(list_tax,',')>
			<cfoutput query="get_branches">
			<tr>
				<td nowrap>#BRANCH_NAME#</td>
				<td><input type="checkbox" name="iss_acc_d_#BRANCH_ID#" id="iss_acc_d_#BRANCH_ID#" value="1" <cfif isdefined('branch_discount_info_#BRANCH_ID#') and evaluate('branch_discount_info_#BRANCH_ID#') eq 1>checked</cfif>></td>
				 <cfloop from="1" to="#len_tax#" index="i">
					<cfset tax_id = listgetat(list_tax,i,',')>
					<cfquery name="CONTROL" datasource="#DSN3#">
						SELECT 
							S.ACCOUNT_CODE,
							S.ACCOUNT_CODE_IADE,
							S.ACCOUNT_CODE_INDIRIM,
							A.ACCOUNT_NAME 
						FROM 
							SETUP_BRANCH_SALES S,
							#dsn2_alias#.ACCOUNT_PLAN A
						WHERE 
							S.BRANCH_ID = #BRANCH_ID# AND 
							S.TAX_ID = #tax_id# AND 
							S.ACCOUNT_CODE = A.ACCOUNT_CODE
					</cfquery>
					<td nowrap="nowrap">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="accountcode_#BRANCH_ID#_#tax_id#" id="accountcode_#BRANCH_ID#_#tax_id#" value="<cfif (control.recordcount) AND len(control.ACCOUNT_CODE)>#control.ACCOUNT_CODE#</cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac('#BRANCH_ID#','#tax_id#');"></span>
							</div>
						</div>
					</td>
					<td nowrap="nowrap">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="accountcode2_#BRANCH_ID#_#tax_id#" id="accountcode2_#BRANCH_ID#_#tax_id#" value="<cfif (control.recordcount) AND len(control.ACCOUNT_CODE_IADE)>#control.ACCOUNT_CODE_IADE#</cfif>" >
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac2('#BRANCH_ID#','#tax_id#');"></span>
							</div>
						</div>
					</td>
					<td nowrap="nowrap">
						<div class="form-group">
							<div class="input-group">
							<input type="text" name="accountcode3_#BRANCH_ID#_#tax_id#" id="accountcode3_#BRANCH_ID#_#tax_id#" value="<cfif (control.recordcount) AND len(control.ACCOUNT_CODE_INDIRIM)>#control.ACCOUNT_CODE_INDIRIM#</cfif>" style="width:65px;">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac3('#BRANCH_ID#','#tax_id#');"></span>
							</div>
						</div>
					</td>
				  </cfloop>
			   </tr>
		   </cfoutput>
		   </cfif>
		</tbody>
		</cf_grid_list>
		<div><cf_workcube_buttons is_upd='0'></div>
		
		  </cfform>
</cf_box>

<script type="text/javascript">
function pencere_ac(branch,tax)
{
	temp_account_code = eval('add_branch_sales.accountcode_'+branch+'_'+tax);
	if (temp_account_code.value.length != 0)
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_branch_sales.accountcode_' + branch + '_'+ tax +'&account_code=' + temp_account_code.value);
	else
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_branch_sales.accountcode_' + branch + '_'+ tax );
}
function pencere_ac2(branch,tax)
{
	temp_account_code = eval('add_branch_sales.accountcode2_'+branch+'_'+tax);
	if (temp_account_code.value.length != 0)
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_branch_sales.accountcode2_' + branch + '_'+ tax +'&account_code=' + temp_account_code.value);
	else
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_branch_sales.accountcode2_' + branch + '_'+ tax );
}
function pencere_ac3(branch,tax)
{
	temp_account_code = eval('add_branch_sales.accountcode3_'+branch+'_'+tax);
	if (temp_account_code.value.length != 0)
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_branch_sales.accountcode3_' + branch + '_'+ tax +'&account_code=' + temp_account_code.value);
	else
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_branch_sales.accountcode3_' + branch + '_'+ tax );
}
</script>
