<br/>
<br/>
<br/>
<p><cf_get_lang dictionary_id='60143.Ekran Geçici Olarak Kapalı'> </p><!--- 20060311 --->
<cfexit method="exittemplate">
<!--- 
açan penceredeki istenen alana seçilen id leri kaydeder

gerekliler
	field_td : istenen tablo hücresine de değerler yazılabilir ama hücreye id tanımlaması yapılmalıdır
	field_id : form_name.id_field_name

örnek kullanım :
	<a href="#" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_users&field_id=document.form_name.form_id_fieldname&field_td=td_id</cfoutput>','small')"> Gidecekler </a>

id ler
	partnerler ==> par-101-8
	employeelar ==> emp-123
	positionlar ==> pos-5
	consumerlar ==> con-175
	grouplar ==> grp-168,grp-568
	sonuc : field_id = "par-101-8,emp-123,pos-155,con-175,grp-168,grp-568" olur ve bu şekilde açan pencereye atanır

not : partner ın id den sonraki elemanı company_id dir
	
action sayfasında listeyi parse etmek için kod :

			<cfset TO_EMPS = "">
			<cfset TO_POS = "">
			<cfset TO_PARS = "">
			<cfset TO_CONS = "">
			<cfset TO_GRPS = "">
			<cfloop LIST="#FORM.TOS#" INDEX="I">
				<cfif I CONTAINS "EMP">
					<cfset TO_EMPS = LISTAPPEND(TO_EMPS,LISTGETAT(I,2,"-"))>
				<cfelseif I CONTAINS "POS">
					<cfset TO_POS = LISTAPPEND(TO_POS,LISTGETAT(I,2,"-"))>
				<cfelseif I CONTAINS "PAR">
					<cfset TO_PARS = LISTAPPEND(TO_PARS,LISTGETAT(I,2,"-"))>
				<cfelseif I CONTAINS "CON">
					<cfset TO_CONS = LISTAPPEND(TO_CONS,LISTGETAT(I,2,"-"))>
				<cfelseif I CONTAINS "GRP">
					<cfset TO_GRPS = LISTAPPEND(TO_GRPS,LISTGETAT(I,2,"-"))>
				</cfif>
			</cfloop> 

update sayfasında hidden değeri ayarlamak içinse

			<cfset TOS = "">
			<cfloop list="#get_event.event_to_partner#" index="i">
				<cfset TOS = listappend(TOS,"par-#i#")>
			</cfloop>
			<cfloop list="#get_event.event_to_emp#" index="i">
				<cfset TOS = listappend(TOS,"emp-#i#")>
			</cfloop>
			<cfloop list="#get_event.event_to_pos#" index="i">
				<cfset TOS = listappend(TOS,"pos-#i#")>
			</cfloop>
			<cfloop list="#get_event.event_to_con#" index="i">
				<cfset TOS = listappend(TOS,"con-#i#")>
			</cfloop>
			<cfloop list="#get_event.event_to_grp#" index="i">
				<cfset TOS = listappend(TOS,"grp-#i#")>
			</cfloop>
kodu kullanılabir	
 --->
<cfset xfa.add = "objects.add_users">
<script type="text/javascript">
function add_users(source,target)
{
	for (i=source.options.length-1; i>=0; i--)
		{
		if (source.options[i].selected)
			{
			flag = 0;
			for(j=target.options.length-1; j>=0; j--)
				if (target.options[j].value == source.options[i].value)
					flag = 1;
			if (flag == 0)
				{
				var newElem = document.createElement("OPTION")
				newElem.text = source.options[i].text;
				newElem.value= source.options[i].value;
				target.options.add(newElem);
				source.options.remove(i);
				}
			}
		}
}

function remove(target)
{
	for (i=target.options.length-1; i>=0; i--)
		if (target.options[i].selected)
			target.options.remove(i);
}

function prepeare()
{
	text_ = "";
	value_ = "";
	for (i=document.users.target_to.options.length-1; i>=0; i--)
		{
		value_ = value_ + document.users.target_to.options[i].value + ",";
		<cfif isDefined("attributes.field_td")>
		 text_ = text_ + document.users.target_to.options[i].text + "<br/>";
			/*<cfif isdefined("attributes.pro_comp")>
		  		text_ = text_ +"yetkili <input type='checkbox' name='status' value='" + document.users.target_to.options[i].value+"'>"+ document.users.target_to.options[i].text + "<br/>";
			<cfelse>
				text_ = text_ + document.users.target_to.options[i].text + "<br/>";
			</cfif>*/
		<cfelse>
			text_ = text_ + document.users.target_to.options[i].text + ",";
		</cfif>
		
		   
		}
	if (document.users.target_to.options.length != 0)
		{
		value_ = value_.toString().substr(0,value_.length-1);
		}
		
	opener.<cfoutput>#attributes.field_id#</cfoutput>.value = value_;
	
	<cfif isdefined("attributes.field_name")>
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value = text_;
	</cfif>
	
	
	<cfif isDefined("attributes.field_td")>
		opener.<cfoutput>#attributes.field_td#</cfoutput>.innerHTML = text_;
	</cfif>
	<cfif isDefined("attributes.field_td2")>
		opener.<cfoutput>#attributes.field_td2#</cfoutput>.innerHTML = text_;
	</cfif>
	<cfif isdefined("attributes.submit") and isdefined("attributes.form_name")>
		opener.<cfoutput>#attributes.form_name#</cfoutput>.submit();
	</cfif>
	
	window.close();	
	return true;
}
</script>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT
		BRANCH_ID, 
		BRANCH_NAME
	FROM 
		BRANCH
	WHERE  
		BRANCH_STATUS = 1
</cfquery>
<cfparam name="select_list" default="1,2,3,4,5,6">
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang dictionary_id='32553.Kişiler'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td colspan="2">
                  <table border="0" cellpadding="0" cellspacing="0">
                    <form name="users">
                      <tr>
                        <td>
                          <!--- üçlü 1 --->
                          <table border="0">
                            <cfif listcontainsnocase(select_list,"1")>
                              <tr>
                                <td width="75"><cf_get_lang dictionary_id='57576.Çalışan'></td>
                                <td>
                                  <select name="to_employeecats" id="to_employeecats" onChange="if(this.selectedIndex!=0) to_emp_redirect(this.options.selectedIndex);" style="width:250px;">
                                    <option value="0"> 
									<cfoutput query="get_branches">
									    <option value="#branch_id#">#branch_name#</option> 
                                    </cfoutput>
                                  </select>
                                </td>
                              </tr>
                            </cfif>
                            <cfif listcontainsnocase(select_list,"2")>
                              <tr>
                                <td><cf_get_lang dictionary_id='57585.Kurumsal Üye'> </td>
                                <td align="left">
                                  <select name="to_partnercomps" id="to_partnercomps" onChange="if(this.selectedIndex!=0) to_par_redirect(this.options.selectedIndex);" style="width:250px;">
                                    <option value="0">
                                    <cfinclude template="../query/get_partner_comps.cfm">
                                    <cfoutput query="partner_comps">
                                      <option value="#company_id#">#fullname#</option> 
                                    </cfoutput>
                                  </select>
                                </td>
                              </tr>
                            </cfif>
                            <cfif listcontainsnocase(select_list,"3")>
                              <tr>
                                <td><cf_get_lang dictionary_id='57586.Bireysel Üye'></td>
                                <td align="left">
                                  <select name="to_consumercats" id="to_consumercats" onChange="if(this.selectedIndex!=0) to_con_redirect(this.options.selectedIndex);" style="width:250px;">
                                    <option value="0">
                                    <cfinclude template="../query/get_consumer_cats.cfm">
                                    <cfoutput query="get_consumer_cats">
                                      <option value="#conscat_id#">#conscat#</option> 
                                    </cfoutput>
                                  </select>
                                </td>
                              </tr>
                            </cfif>
                            <cfif listcontainsnocase(select_list,"4")>
                              <tr>
                                <td><cf_get_lang dictionary_id='32716.Gruplar'></td>
                                <td align="left">
                                  <select name="to_groups" id="to_groups" onChange="if(this.selectedIndex!=0) add_group(this.options.selectedIndex);" style="width:250px;">
                                    <option value="0">
                                    <cfinclude template="../query/get_emp_groups.cfm">
                                    <cfoutput query="emp_groups">
                                      <option value="#group_id#">#group_name#</option> 
                                    </cfoutput>
                                  </select>
                                </td>
                              </tr>
                            </cfif>
                            <cfif listcontainsnocase(select_list,"5")>
                              <tr>
                                <td><cf_get_lang dictionary_id='29818.İş Grupları'></td>
                                <td align="left">
                                  <select name="to_workgroups" id="to_workgroups" onChange="if(this.selectedIndex!=0) add_workgroup(this.options.selectedIndex);" style="width:250px;">
                                    <option value="0">
                                    <cfinclude template="../query/get_workgroup.cfm">
                                    <cfoutput query="get_workgroup">
                                      <option value="#workgroup_id#">#workgroup_name#</option>
                                    </cfoutput>
                                  </select>
                                </td>
                              </tr>
                            </cfif>
							
                          </table>
                          <table>
                            <tr>
                              <td>
                                <select name="source_to" id="source_to" size="9" style="width:150px;" multiple>
                                </select>
                              </td>
                              <td align="center"> <a href="#" onclick="add_users(document.users.source_to, document.users.target_to);return false;"><img src="/images/list_plus.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0"></a><br/>
                                <a href="#" onclick="remove(document.users.target_to);return false;"><img src="/images/list_minus.gif" title="<cf_get_lang dictionary_id='32936.Çıkart'>" border="0"></a></td>
                              <td>
                                <select name="target_to" id="target_to" size="9" style="width:150px;" multiple>
                                </select>
                              </td>
                            </tr>
                            <tr height="30">
                              <td colspan="3"  style="text-align:right;">
								<cf_workcube_buttons is_upd='0' add_function='prepeare() && false' insert_alert=''>
                              </td>
                            </tr>
                          </table>
                          <!--- //üçlü 1 --->
                        </td>
                      </tr>
                    </form>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function clear_source()
	{
	while (users.source_to.options.length)
		users.source_to.options.remove(0);
	}
<cfif listcontainsnocase(select_list,"1")>
	var to_employeecat_groups=document.users.to_employeecats.options.length;
	var to_employeecat_group=new Array(to_employeecat_groups);
	for (i=0; i<to_employeecat_groups; i++) 
		to_employeecat_group[i]=new Array();
	to_employeecat_group[0][0]=new Option("----------------------"," ");
	<cfloop query="get_branches">
		<cfset attributes.branch_id= get_branches.branch_id>
		<cfinclude template="../query/get_employees2.cfm">
		<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
			SELECT 
				EMPLOYEES.EMPLOYEE_ID,
				EMPLOYEES.EMPLOYEE_NO,
				EMPLOYEES.EMPLOYEE_NAME, 
				EMPLOYEES.EMPLOYEE_SURNAME,
				EMPLOYEES.DIRECT_TELCODE,
				EMPLOYEES.DIRECT_TEL,
				EMPLOYEES.EXTENSION,
				BRANCH.BRANCH_NAME,
				BRANCH.BRANCH_ID,
				DEPARTMENT.DEPARTMENT_ID,
				DEPARTMENT.DEPARTMENT_HEAD,
				/*EMPLOYEES.POSITION_ID,*/
				EMPLOYEE_POSITIONS.POSITION_CODE
			FROM 
				EMPLOYEES,
				BRANCH,
				DEPARTMENT,
				EMPLOYEE_POSITIONS
			WHERE
				EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
				EMPLOYEES.EMPLOYEE_STATUS =1 AND
				DEPARTMENT.DEPARTMENT_STATUS =1 AND
				BRANCH.BRANCH_STATUS =1 AND
				EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
				DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
			<cfif isDefined("attributes.BRANCH_ID")>
				AND BRANCH.BRANCH_ID = #attributes.BRANCH_ID#
			</cfif>
			<cfif isDefined("attributes.EMPLOYEE_IDS") and len(attributes.EMPLOYEE_IDS)>
				AND EMPLOYEES.EMPLOYEE_ID IN (#attributes.EMPLOYEE_IDS#)
			</cfif>
			<cfif isDefined("attributes.DEPARTMENT_ID")>
				AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				<cfif len(attributes.keyword) eq 1>
					AND EMPLOYEES.EMPLOYEE_NAME LIKE '#attributes.keyword#%'
				<cfelse>
					AND
					(
					EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR
					EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' OR
					DEPARTMENT.DEPARTMENT_HEAD LIKE '%#attributes.keyword#%' OR
					BRANCH.BRANCH_NAME LIKE '%#attributes.keyword#%'
					)
				</cfif>
			</cfif>
			ORDER BY
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME
		</cfquery>
		<cfset counter = currentrow>
		<cfif get_employees.recordcount>
			<cfoutput query="get_employees">
				to_employeecat_group[#counter#][#evaluate(currentrow-1)#]=new Option("#employee_name# #employee_surname#","emp-#employee_id#,pos-#position_code#");
			</cfoutput>
		</cfif>
	</cfloop>
	
	var temp=document.users.source_to;
	function to_emp_redirect(x){
	clear_source();
	for (i=0;i<to_employeecat_group[x].length;i++)
		{
		newItem = new Option(to_employeecat_group[x][i].text,to_employeecat_group[x][i].value);
		temp.options.add(newItem);
		}
	}
</cfif>
<cfif listcontainsnocase(select_list,"2")>
	var to_partnercomp_groups = document.users.to_partnercomps.options.length;
	var to_partnercomp_group = new Array(to_partnercomp_groups);
	for (i=0; i<to_partnercomp_groups; i++)
		to_partnercomp_group[i]=new Array();
	to_partnercomp_group[0][0]=new Option("----------------------"," ");
	<cfloop query="partner_comps">
		<cfset attributes.company_id = company_id>
		<cfinclude template="../query/get_partners.cfm">
		<cfquery name="GET_PARTNERS" datasource="#dsn#">
			(
			SELECT 
				COMPANY_PARTNER.PARTNER_ID,
				COMPANY_PARTNER.COMPANY_PARTNER_NAME,
				COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
				COMPANY_PARTNER.COMPANY_PARTNER_EMAIL,
				COMPANY_PARTNER.MISSION,
				COMPANY.FULLNAME,
				COMPANY.NICKNAME,
				COMPANY.COMPANY_ID,
				COMPANY_CAT.COMPANYCAT,
				COMPANY.COMPANY_POSTCODE,
				COMPANY.COMPANY_ADDRESS,
				COMPANY.COUNTY,
				COMPANY.CITY,
				COMPANY.MEMBER_CODE
			FROM 
				COMPANY,
				COMPANY_PARTNER,
				COMPANY_CAT
			WHERE
				COMPANY_PARTNER.COMPANY_PARTNER_STATUS = 1 AND
				COMPANY.COMPANY_STATUS = 1 AND
				COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
				COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID
			<cfif isDefined("attributes.type") and (attributes.type eq 1)>
				AND COMPANY.ISPOTANTIAL = 1
			<cfelseif isDefined("attributes.type") and (attributes.type eq 0)>
				AND COMPANY.ISPOTANTIAL = 0 
			</cfif>
		
			<cfif isDefined("attributes.companycat_id")>
				AND COMPANY.COMPANYCAT_ID = #attributes.companycat_id#
			</cfif>
			<cfif isDefined("attributes.company_id") >
				AND COMPANY_PARTNER.COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
				AND (COMPANY.FULLNAME LIKE '%#attributes.keyword#%' OR COMPANY.MEMBER_CODE LIKE '%#attributes.keyword#%')
			<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1>
				AND COMPANY.FULLNAME LIKE '#attributes.keyword#%' 
			</cfif>
			<cfif isDefined("attributes.partner_name") and len(attributes.partner_name)>
				AND COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '%#attributes.partner_name#%'
			</cfif>
			)
			UNION ALL
			(
			SELECT 
				-1 AS PARTNER_ID,
				'' AS COMPANY_PARTNER_NAME,
				'' AS COMPANY_PARTNER_SURNAME,
				'' AS COMPANY_PARTNER_EMAIL,
				'' AS MISSION,
				COMPANY.FULLNAME,
				COMPANY.NICKNAME,
				COMPANY.COMPANY_ID,
				COMPANY_CAT.COMPANYCAT,
				COMPANY.COMPANY_POSTCODE,
				COMPANY.COMPANY_ADDRESS,
				COMPANY.COUNTY,
				COMPANY.CITY,
				COMPANY.MEMBER_CODE
			FROM 
				COMPANY,
				COMPANY_CAT
			WHERE
				COMPANY.COMPANY_ID NOT IN (SELECT COMPANY_ID FROM COMPANY_PARTNER ) AND
				COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID
			<cfif isDefined("attributes.partner_name") and len(attributes.partner_name) and isDefined("attributes.keyword") and not len(attributes.keyword)>
				AND COMPANY.COMPANY_ID IS NULL
			</cfif>
			<cfif isDefined("attributes.company_id") >
				AND COMPANY.COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif isDefined("attributes.type") and (attributes.type eq 1)>
				AND COMPANY.ISPOTANTIAL = 1
			<cfelseif isDefined("attributes.type") and (attributes.type eq 0)>
				AND COMPANY.ISPOTANTIAL = 0 
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
				AND	COMPANY.FULLNAME LIKE '%#attributes.keyword#%'
			<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1>
				AND	COMPANY.FULLNAME LIKE '#attributes.keyword#%'
			</cfif>
			)
				ORDER BY
					COMPANY.FULLNAME,
					COMPANY.NICKNAME,			
					COMPANY_PARTNER_NAME,
					COMPANY_PARTNER_SURNAME
		</cfquery>
		<cfset counter = currentrow>
		<cfif get_partners.recordcount>
			<cfoutput query="get_partners">
			<cfif PARTNER_ID eq -1>
				to_partnercomp_group[#counter#][#evaluate(currentrow-1)#]=new Option("#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# - #NICKNAME#","par- -#company_id#");
			<cfelse>
				to_partnercomp_group[#counter#][#evaluate(currentrow-1)#]=new Option("#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# - #NICKNAME#","par-#PARTNER_ID#-#company_id#");
			</cfif>
			</cfoutput>
		</cfif>
	</cfloop>
	
	function to_par_redirect(x)
		{
		clear_source();
		for (i=0;i<to_partnercomp_group[x].length;i++)
			{
				newItem = new Option(to_partnercomp_group[x][i].text,to_partnercomp_group[x][i].value);
				temp.options.add(newItem);
			}
		}
</cfif>
<cfif listcontainsnocase(select_list,"3")>
	var to_consumercat_groups=document.users.to_consumercats.options.length;
	var to_consumercat_group=new Array(to_consumercat_groups);
	for (i=0; i<to_consumercat_groups; i++)
		to_consumercat_group[i]=new Array();
	to_consumercat_group[0][0]=new Option("----------------------"," ");
	<cfloop query="get_consumer_cats">
		<cfset attributes.consumer_cat_id = conscat_id>
		<cfinclude template="../query/get_consumers.cfm">
		<cfquery name="GET_CONSUMERS" datasource="#dsn#">
			SELECT 
				CONSUMER.CONSUMER_ID,
				CONSUMER.CONSUMER_NAME,
				CONSUMER.CONSUMER_USERNAME,
				CONSUMER.CONSUMER_EMAIL,
				CONSUMER.CONSUMER_SURNAME,
				CONSUMER_CAT.CONSCAT,
				CONSUMER.COMPANY,
				CONSUMER.WORKADDRESS,
				CONSUMER.WORKPOSTCODE
			FROM 
				CONSUMER,
				CONSUMER_CAT
			WHERE
				CONSUMER.CONSUMER_STATUS = 1 AND
				CONSUMER.CONSUMER_CAT_ID = CONSUMER_CAT.CONSCAT_ID
			<cfif isDefined("attributes.type") and (attributes.type eq 0)>
				AND CONSUMER.ISPOTANTIAL = 0
			<cfelseif isDefined("attributes.type") and (attributes.type eq 1)>
				AND CONSUMER.ISPOTANTIAL = 1
			</cfif>
			<cfif isDefined("attributes.consumer_cat_id")>
				AND CONSUMER.CONSUMER_CAT_ID = #attributes.consumer_cat_id#
			</cfif>
			<cfif isDefined("attributes.cons_ids")>
				AND CONSUMER.CONSUMER_ID IN (#attributes.cons_ids#)
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				<cfif len(attributes.keyword) eq 1>
					AND CONSUMER.CONSUMER_NAME LIKE '#attributes.keyword#%'
				<cfelse>
					AND
					(
						CONSUMER.CONSUMER_NAME LIKE '%#attributes.keyword#%' OR
						CONSUMER.CONSUMER_SURNAME LIKE '%#attributes.keyword#%' OR
						CONSUMER.COMPANY LIKE '%#attributes.keyword#%' OR
						CONSUMER_CAT.CONSCAT LIKE '%#attributes.keyword#%'
					)
				</cfif>
			</cfif>
			<cfif   isDefined("attributes.var_new") and  attributes.var_new eq "invoice_bill" >
				AND IS_CARI =1 
				AND ISPOTANTIAL=0
			</cfif>
			ORDER BY
				CONSUMER_CAT.CONSCAT,
				CONSUMER.CONSUMER_NAME,
				CONSUMER.CONSUMER_SURNAME
		</cfquery>
		<cfset counter = currentrow>
		<cfoutput query="get_consumers">
			to_consumercat_group[#counter#][#evaluate(currentrow-1)#] = new Option("#consumer_name# #consumer_surname#","con-#consumer_id#");
		</cfoutput>
	</cfloop>
	
	function to_con_redirect(x)
		{
		clear_source();
		for (i=0;i<to_consumercat_group[x].length;i++)
			{
			newItem = new Option(to_consumercat_group[x][i].text,to_consumercat_group[x][i].value);
			temp.options.add(newItem);
			}
		}
</cfif>
<cfif listcontainsnocase(select_list,"4")>
	function add_group(yer)
	{
		clear_source();
		var newElem = document.createElement("OPTION");
		source = document.users.to_groups;
		target = document.users.target_to;
		newElem.text = "* " + source.options[yer].text;	
		newElem.value= "grp-" + source.options[yer].value;
		target.options.add(newElem);
	}
</cfif>
<cfif listcontainsnocase(select_list,"5")>
	function add_workgroup(yer2)
	{
		clear_source();
		var newElem = document.createElement("OPTION");
		source = document.users.to_workgroups;
		target = document.users.target_to;
		newElem.text = "* "+source.options[yer2].text;	
		newElem.value= "wrk-"+source.options[yer2].value;
		target.options.add(newElem);
	}
</cfif>
</script>
