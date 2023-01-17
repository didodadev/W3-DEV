<cfquery name="get_our_companies" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY ORDER BY COMP_ID
</cfquery>
<cfquery name="get_product_our_companies" datasource="#dsn1#">
	SELECT * FROM PRODUCT_OUR_COMPANY WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfset listcompanies = ValueList(get_product_our_companies.our_company_id)>
<cfquery name="get_our_branches" datasource="#dsn1#">
	SELECT * FROM PRODUCT_BRANCH WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfset getComponent = createObject('component','V16.worknet.cfc.product')>
<cfset get_product_action=getComponent.get_product_actions(product_id : attributes.pid)>
<cfset listbranches = ValueList(get_our_branches.branch_id,',')>
<cfinclude template="../query/get_product_name.cfm">
<cfquery name="get_branch_all" datasource="#dsn#">
	SELECT 
		B.BRANCH_ID,
		B.BRANCH_NAME,
		B.COMPANY_ID
	FROM
		BRANCH B,
		EMPLOYEE_POSITION_BRANCHES EPB
	WHERE
		B.BRANCH_ID = EPB.BRANCH_ID AND
        EPB.DEPARTMENT_ID IS NULL AND 
		EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        
UNION ALL

    SELECT 
        BRANCH_ID,
        BRANCH_NAME,
        COMPANY_ID
    FROM
        BRANCH
    WHERE
        <cfif listlen(listbranches,',')>BRANCH_ID IN (#listbranches#)<cfelse>1 = 0</cfif> AND
        BRANCH_ID NOT IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES)
</cfquery>
<cfset old_branch_history_list = "">
<cfset branch_recordcount = 1>

<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="right"><li><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_product_compbranch_history&product_id=#attributes.pid#</cfoutput>','medium','product_compbranch_history');"><i class="fa fa-history" title="<cf_get_lang dictionary_id='57473.Tarihçe'>"></i></a></li></cfsavecontent>
<cf_box title="#getLang('','Ürün Şirketleri ve Şubeleri',37538)#:#get_product_name.product_name#" right_images="#right#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="prod_company" action="#request.self#?fuseaction=product.emptypopup_add_product_companies">
		<table width="100%">
					<tr>
						<input type="hidden" name="branch_recordcount" id="branch_recordcount" value="<cfoutput>#get_branch_all.recordcount#</cfoutput>">
						<input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
						<cfparam name="attributes.mode" default="4">
						<cfparam name="attributes.page" default="1">
						<cfset attributes.startrow=1>
						<cfset attributes.maxrows = get_our_companies.recordcount>
						<cfset branch_currentrow = 1>
						<cfloop query="get_our_companies">
						<td valign="bottom"  class="color-list">
							<input type="checkbox" name="our_company_id" id="our_company_id" value="<cfoutput>#comp_id#</cfoutput>" <cfif ListFind(listcompanies,comp_id)>checked <cfif get_product_action.recordcount> disabled</cfif></cfif>>
							<cfoutput><b>#nick_name#</b></cfoutput>
						</td>
						<cfquery name="get_branch" dbtype="query">
							SELECT * FROM GET_BRANCH_ALL WHERE COMPANY_ID = #comp_id# <!--- <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_id#"> ---> ORDER BY BRANCH_NAME
						</cfquery>
						<cfif get_branch.recordcount>
						<tr>
							<td colspan="2">
								<table>
									<tr>
										<td colspan="2" ><input type="checkbox" name="all_branch_id_<cfoutput>#comp_id#</cfoutput>" id="all_branch_id_<cfoutput>#comp_id#</cfoutput>" value="1" onClick="hepsini_sec_branch(<cfoutput>#comp_id#</cfoutput>);"><i><cf_get_lang dictionary_id='37565.Tüm Şubeleri Seç'></i></td>
									</tr>
									<cfoutput query="get_branch">
										<cfif ListFind(listbranches,branch_id)>
											<!--- history icin subeleri listeye atiyorum queryde karsilastirma yapılabilsin diye FBS 20080702 --->
											<cfset old_branch_history_list = listappend(old_branch_history_list,branch_id,',')>
										</cfif>
										<cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
											<tr>
										</cfif>
										<td><input type="checkbox" name="branch_id_#branch_currentrow#" id="branch_id_#branch_currentrow#" value="#branch_id#" <cfif ListFind(listbranches,branch_id)>checked</cfif>>
											<input type="hidden" name="comp_id_#branch_currentrow#" id="comp_id_#branch_currentrow#" value="#company_id#">
										</td>
										<td width="130" align="left">#branch_name#</td>
										<cfset branch_currentrow = branch_currentrow + 1>
										<cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq recordcount)>
											</tr>
										</cfif>
									</cfoutput>
							</table>
							</td>
						</tr>
						<cfelse>
							<tr>
								<td colspan="2"></td>
							</tr>
						</cfif>
					</cfloop>
			<input type="hidden" name="old_branch_history_list" id="old_branch_history_list" value="<cfoutput>#old_branch_history_list#</cfoutput>">
		</table>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function="remDis()">
		</cf_box_footer>
	</cfform>
</cf_box>		
<script type="text/javascript"><!--- FB & BK 20071204 tum subelerin secilmesi icin eklendi --->
function hepsini_sec_branch(deger)
{
	if(eval("document.prod_company.all_branch_id_"+deger).checked == true)
	{
		for (say=1; say<=<cfoutput>#get_branch_all.recordcount#</cfoutput>;say++)
			if(eval("document.prod_company.comp_id_"+say).value == deger)
				if(eval("document.prod_company.branch_id_"+say).disabled==false)
					eval("document.prod_company.branch_id_"+say).checked = true;		
	}
	else
	{
		for (say=1; say<=<cfoutput>#get_branch_all.recordcount#</cfoutput>;say++)
			if(eval("document.prod_company.comp_id_"+say).value == deger)
				if(eval("document.prod_company.branch_id_"+say).disabled==false)
					eval("document.prod_company.branch_id_"+say).checked = false;		
	}
	return false;
}

function remDis()
{
	<cfoutput>
		<cfif get_our_companies.RecordCount gt 1>
			for (i=0; i<#get_our_companies.RecordCount#; i++)
			{
				prod_company.our_company_id[i].disabled = false;
			}
		<cfelse>
			prod_company.our_company_id.disabled = false;
		</cfif>
		<cfif get_branch_all.recordcount gte 0>
			for (j=1; j<=#get_branch_all.RecordCount#; j++)
				eval('document.prod_company.branch_id_'+j).disabled = false;
		</cfif>
	</cfoutput>
	<cfif isdefined("attributes.draggable")>
		loadPopupBox('prod_company' , <cfoutput>#attributes.modal_id#</cfoutput>)
	</cfif>
	return false;
}
</script>
