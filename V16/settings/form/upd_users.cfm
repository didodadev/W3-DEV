<cfinclude template="../query/get_users.cfm">
<cfinclude template="../query/get_branches.cfm">
<cfinclude template="../query/get_partner_cats.cfm">
<cfinclude template="../query/get_consumer_cats.cfm">
<script type="text/javascript">
function add_users()
{
	for (i=document.users.source_list.options.length-1; i>=0; i--)
	{
		if (document.users.source_list.options[i].selected)
		{
			source = document.users.source_list;
			target = document.users.target_list;
			var newElem = document.createElement("OPTION")
			newElem.text = source.options[i].text;
			newElem.value= source.options[i].value;
			target.options.add(newElem);
			source.options.remove(i);
		}
	}
}

function remove()
{
	for (i=document.users.target_list.options.length-1; i>=0; i--)
		if (document.users.target_list.options[i].selected)
			document.users.target_list.options.remove(i);
}

function prepeare()
{
	if (document.users.group_name.value == "")
	{
		alert('Grup adı !');
		return false;
	}

	if (document.users.target_list.options.length == 0)
	{
		alert('Üye ekleyin !');
		return false;
	}

	for (i=document.users.source_list.options.length-1; i>=0; i--)
		document.users.source_list.options[i].selected = true;
	for (i=document.users.target_list.options.length-1; i>=0; i--)
		document.users.target_list.options[i].selected = true;
	return true;
}
</script>
<cfsavecontent variable="right">
	<cfif not isdefined("attributes.process")>
        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_users"><span class="icn-md icon-add"  alt="<cf_get_lang dictionary_id='57582.Ekle'>"></span></a>
    <cfelse>
        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_add_users&process=sett"><span class="icn-md icon-add"  alt="<cf_get_lang dictionary_id='57582.Ekle'>"></span></a>
    </cfif>
</cfsavecontent>
<cf_box title="#getLang('settings',673)#" right_images="#right#" closable="0" collapsed="0">
    <form name="users" id="users" method="post" action="<cfoutput>#request.self#?fuseaction=settings.emptypopup_users_upd</cfoutput>" onSubmit="return prepeare();">
		<input type="hidden" name="process" id="process" <cfif isdefined("attributes.process")><cfoutput>value="#attributes.process#"</cfoutput></cfif>>
    	<input type="hidden" name="group_id" id="group_id" value="<cfoutput>#attributes.group_id#</cfoutput>">
		<cf_box_elements>
			<div class="col col-3 col-xs-12">
				<div class="scrollbar" style="max-height:403px;overflow:auto;">
					<div id="cc">
						<cfinclude template="../display/list_users.cfm">
					</div>
				</div>
			</div>
			<div class="col col-4 col-xs-12">
				<div class="form-group" id="item-bank">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58969.Grup Adı'>*</label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="group_name" id="group_name" value="<cfoutput>#get_users.group_name#</cfoutput>" style="width:150px;">
					</div>
				</div>
				<div class="form-group" id="item-bank">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54997.Kimler İçin'></label>
					<div class="col col-8 col-xs-12">
						<input type="Checkbox" name="to_all" id="to_all" value="1" <cfif get_users.to_all eq 1> checked</cfif>><cf_get_lang dictionary_id='46757.Herkese Açık'>
					</div>
				</div>
				<div class="form-group" id="item-bank">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.şube'></label>
					<div class="col col-8 col-xs-12">
						<select name="employeecats" id="employeecats" onChange="if(this.selectedIndex!=0) emp_redirect(this.options.selectedIndex);" style="width:150px;">
							<option value="0"><cf_get_lang dictionary_id='57453.şube'></option>
							<cfoutput query="get_branches">
								<option value="#branch_id#">#branch_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-bank">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
					<div class="col col-8 col-xs-12">
						<select name="partnercats" id="partnercats" onChange="if(this.selectedIndex!=0) par_redirect(this.options.selectedIndex);" style="width:150px;">
							<option value="0"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></option>
							<cfoutput query="get_partner_cats">
								<option value="#companycat_id#">#companycat#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-bank">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></label>
					<div class="col col-8 col-xs-12">
						<select name="consumercats" id="consumercats" onChange="if(this.selectedIndex!=0) con_redirect(this.options.selectedIndex);" style="width:150px;">
							<option value="0"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'>
							<cfoutput query="get_consumer_cats">
								<option value="#conscat_id#">#conscat#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
			<div class="col col-5 col-xs-12">
				<div class="form-group" id="item-bank">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58992.Kullanıcılar'></label>
					<div class="col col-4 col-xs-12">
						<select name="source_list" id="source_list" size="10" style="width:150px;height:100px;" multiple></select>
					</div>
					<div class="col col-1 col-xs-12">
						<a href="#" onClick="add_users();return false;"><span class="icn-md fa fa-arrow-right"  alt="<cf_get_lang dictionary_id='57582.Ekle'>"></span></a><br/>
						<a href="#" onClick="remove();return false;"><span class="icn-md fa fa-arrow-left"  alt="<cf_get_lang dictionary_id='53354.Çıkar'>"></span></a>
					</div>
					<div class="col col-4 col-xs-12">
						<select name="target_list" id="target_list" size="10" style="width:150px;height:100px;" multiple>
							<cfif len(get_users.positions)>
								<cfset attributes.position_codes = get_users.positions>
								<cfinclude template="../query/get_users_pos.cfm">
								<cfoutput query="get_users_pos">
									<option value="pos-#position_code#">#employee_name# #employee_surname#</option>
								</cfoutput>
							</cfif>
							<cfif len(get_users.partners)>
								<cfset attributes.partner_ids = get_users.partners>
								<cfinclude template="../query/get_users_pars.cfm">
								<cfoutput query="get_users_pars">
									<option value="par-#partner_id#">#company_partner_name# #company_partner_surname#</option>
								</cfoutput>
							</cfif>
							<cfif len(get_users.consumers)>
								<cfset attributes.consumer_ids = get_users.consumers>
								<cfinclude template="../query/get_users_cons.cfm">
								<cfoutput query="get_users_cons">
									<option value="con-#consumer_id#">#consumer_name# #consumer_surname#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
			</div>
    	</cf_box_elements>
		<cf_box_footer> 
			<cf_record_info query_name="get_users" record_emp="record_member" update_emp="update_member">                 
			<cf_workcube_buttons type_format="1" is_upd='1' delete_page_url='#request.self#?fuseaction=settings.users_del&group_id=#attributes.group_id#&process=' add_function="kontrol()">
		</cf_box_footer>
    </form>
</cf_box>
<script type="text/javascript">
function kontol(){
	var selected = [];
	for (var option of document.getElementById('target_list').options) {
		if (option.selected) 
		selected.push(option.value);
		
	}
}
/* employeecats*/
var employeecat_groups=document.users.employeecats.options.length;
var employeecat_group=new Array(employeecat_groups);
for (i=0; i<employeecat_groups; i++)
	employeecat_group[i]=new Array();
employeecat_group[0][0]=new Option("----------------------"," ");
<cfloop query="get_branches">
	<cfset attributes.branch_id = branch_id>
	<cfinclude template="../query/get_employees.cfm">
	<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
		SELECT 
			POSITION_CODE,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_POSITIONS
		WHERE 
			DEPARTMENT_ID IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,BRANCH WHERE BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND DEPARTMENT_STATUS = 1 AND BRANCH.BRANCH_ID = #attributes.branch_id#) AND
			POSITION_STATUS = 1
	</cfquery>
	<cfset counter = currentrow>
	<cfoutput query="get_employees">
		employeecat_group[#counter#][#evaluate(currentrow-1)#]=new Option("#employee_name# #employee_surname#","pos-#position_code#");
	</cfoutput>
</cfloop>

var temp=document.users.source_list;

function rem_direct()
{
	var i;
	for(i=temp.options.length-1;i>=0;i--)
	{
		temp.options.remove(i);
	}
}

function emp_redirect(x)
{
	rem_direct();

	for (i=0;i<employeecat_group[x].length;i++)
	{
		newItem = new Option(employeecat_group[x][i].text,employeecat_group[x][i].value);
		temp.options.add(newItem);
	}
}
/*Partnerler Burada Başlıyor*/
var partnercat_groups=document.users.partnercats.options.length;
var partnercat_group=new Array(partnercat_groups);
for (i=0; i<partnercat_groups; i++)
	partnercat_group[i]=new Array();
partnercat_group[0][0]=new Option("----------------------"," ");

<cfloop query="get_partner_cats">
	<cfset attributes.companycat_id = companycat_id>
	<cfinclude template="../query/get_partners.cfm">
	<cfquery name="GET_PARTNERS" datasource="#DSN#">
		SELECT 
			CP.PARTNER_ID,
			CP.COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME
		FROM 
			COMPANY_PARTNER CP,
			COMPANY C
		WHERE
			CP.COMPANY_PARTNER_STATUS = 1 AND
			C.COMPANY_ID = CP.COMPANY_ID AND
			C.COMPANYCAT_ID = #attributes.companycat_id#
	</cfquery>
	<cfset counter = currentrow>
	<cfoutput query="get_partners">
		partnercat_group[#counter#][#evaluate(currentrow-1)#]=new Option("#replacelist(COMPANY_PARTNER_NAME,'",''',' , ')# #replacelist(COMPANY_PARTNER_SURNAME,'",''',' , ')#","par-#PARTNER_ID#");
	</cfoutput>
</cfloop>

function par_redirect(x)
	{
	rem_direct();
	for (i=0;i<partnercat_group[x].length;i++)
		{
		newItem=new Option(partnercat_group[x][i].text,partnercat_group[x][i].value);
		temp.options.add(newItem);
		}
	}

var consumercat_groups=document.users.consumercats.options.length;
var consumercat_group=new Array(consumercat_groups);
for (i=0; i<consumercat_groups; i++)
	consumercat_group[i]=new Array();
consumercat_group[0][0]=new Option("----------------------"," ");

<cfloop query="get_consumer_cats">
	<cfset attributes.consumer_cat_id = conscat_id>
	<cfinclude template="../query/get_consumers.cfm">
	<cfquery name="GET_CONSUMERS" datasource="#dsn#">
		SELECT 
			CONSUMER_ID,
			CONSUMER_NAME,
			CONSUMER_SURNAME
		FROM 
			CONSUMER
		WHERE
			CONSUMER_STATUS = 1 AND
			CONSUMER_CAT_ID = #attributes.CONSUMER_CAT_ID#
	</cfquery>
	<cfset counter = currentrow>
	<cfoutput query="get_consumers">
		consumercat_group[#counter#][#evaluate(currentrow-1)#]=new Option("#consumer_NAME# #consumer_SURNAME#","con-#consumer_ID#");
	</cfoutput>
</cfloop>

function con_redirect(x)
{
	rem_direct();
	for (i=0;i<consumercat_group[x].length;i++)
	{
		newItem=new Option(consumercat_group[x][i].text,consumercat_group[x][i].value);
		temp.options.add(newItem);
	}
}
</script>
