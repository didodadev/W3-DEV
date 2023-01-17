<cfinclude template="../query/get_zones.cfm">
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

function prepeare(update)
{
	text_ = "";
	value_ = "";
	for (i=document.emps.target_to.options.length-1; i>=0; i--)
		{
		value_ = value_ + document.emps.target_to.options[i].value + ",";
		<cfif isDefined("attributes.field_td")>
			text_ = text_ + document.emps.target_to.options[i].text + "<br/>";
		</cfif>
		}
	/* sondaki virgülü at*/
	if (document.emps.target_to.options.length != 0)
		{
		value_ = value_.toString().substr(0,value_.length-1);
		}
	/* sayfaya */
	if (update == 0)
		{
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value = "," + value_ + ",";
		<cfif isDefined("attributes.field_td")>
		opener.<cfoutput>#attributes.field_td#</cfoutput>.innerHTML = text_;
		</cfif>
		}
	else
		{
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value += value_ + ",";
		<cfif isDefined("attributes.field_td")>
		opener.<cfoutput>#attributes.field_td#</cfoutput>.innerHTML += "<br/>"+text_;
		</cfif>
		}
	window.close();	
	return true;
}
</script>

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
                    <FORM name="emps">
    <tr> 
      <td> 
<!--- üçlü 1 --->
<!--- zones --->			
        <table border="0">
          <tr> 
              <td><cf_get_lang dictionary_id='57992.Bölge'></td>
		      <td> 
		        <cfset names=1>
		        <cfinclude template="../query/get_zones.cfm">
		        <select name="zone_id" id="zone_id" size="1" onChange="redirect(this.options.selectedIndex)" style="width:150px;"  >
		          <option value=""><cf_get_lang dictionary_id='32966.Bölge Seçiniz'></option>
		          <cfoutput query="zones"> 
		            <cfset attributes.zone_id = zones.zone_id>
		            <cfinclude template="../query/get_zone_branch_count.cfm">
		            <cfif len(get_zone_branch_count.total)>
		            <option value="#zone_id#">#zone_name#</option>
		            </cfif>
		          </cfoutput> 
		        </select>
		      </td>
          </tr>
<!--- branches --->
          <tr> 
			  <td><cf_get_lang dictionary_id='57453.Şube'></td>
		      <td> 
		        <select name="branch_id" id="branch_id" style="width:150px;" size="1" onChange="redirect1(this.options.selectedIndex)"  >
		          <option value=""><cf_get_lang dictionary_id='53724.Bölge Seçiniz'></option>
		        </select>
		      </td>
          </tr>
<!--- departments --->
          <tr> 
              <td><cf_get_lang dictionary_id='57572.Departman'><font color=red>*</font></td>
		      <td> 
		        <select name="department_id" id="department_id" style="width:150px;" onChange="redirect2(this.options.selectedIndex)"  >
		          <option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
		        </select>
		      </td>
          </tr>
        </table>
		<table>
		  <tr>
			  <td> 
				<select name="source_to" id="source_to" size="10" style="width:150px;" multiple>
				</select>
			  </td>
            <td align="center"> 
				<a href="#" onClick="add_users(document.emps.source_to, document.emps.target_to);return false;"><img src="/images/list_plus.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0"></a><br/>
    	        <a href="#" onClick="remove(document.emps.target_to);return false;"><img src="/images/list_minus.gif" title="<cf_get_lang dictionary_id='32936.Çıkart'>" border="0"></a></td>
			<td>
			<select name="target_to" id="target_to" size="10" style="width:150px;" multiple>
			</select>
			</td>
		  </tr>
          <tr height="30"> 
            <td colspan="3"  style="text-align:right;">
			<cf_workcube_buttons is_upd='0' add_function='prepeare(0)'>
			</td>
		  </tr>
	</table>		
	</td>
	</tr>
</FORM>	
</table>

<script type="text/javascript">
var groups=document.emps.zone_id.options.length;
var group=new Array(groups);
for (i=0; i<groups; i++)
	{group[i]=new Array();}

group[0][0]=new Option("<cf_get_lang dictionary_id='53724.Önce Bölge Seçiniz'>"," ");

<cfset sayac1 = 1>
<cfoutput query="zones">
	<cfset attributes.zone_id = zones.zone_id>
	<cfinclude template="../query/get_branches.cfm">
	<cfif isDefined("NAMES")>
		<cfquery name="BRANCHES" datasource="#dsn#">
			SELECT 
				BRANCH_ID, 
				BRANCH_NAME 
			FROM 
				BRANCH
			<cfif isDefined("attributes.ZONE_ID")>
				WHERE ZONE_ID=#attributes.ZONE_ID#
			</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="BRANCHES" datasource="#dsn#">
			SELECT * FROM BRANCH
			<cfif isDefined("attributes.ZONE_ID")>
				WHERE ZONE_ID=#attributes.ZONE_ID#
			</cfif>
		</cfquery>
	</cfif>
	<cfif branches.recordcount>
		group[#sayac1#][0]=new Option("Şimdi Şube Seçiniz"," ");
		<cfset sayac2 = 1>
		<cfloop query="branches">
			<cfset attributes.branch_id = branches.branch_id>
			<cfinclude template="../query/get_branch_department_count.cfm">
			<cfquery name="GET_BRANCH_DEPARTMENT_COUNT" datasource="#dsn#">
				SELECT 
					BRANCH_ID, 
					COUNT(DEPARTMENT_ID) AS TOTAL
				FROM 
					DEPARTMENT
				WHERE 
					BRANCH_ID=#attributes.BRANCH_ID#
				GROUP BY
					BRANCH_ID
			</cfquery>
			<cfif len(get_branch_department_count.total)>
				group[#sayac1#][#sayac2#]=new Option("#branch_name#","#branch_id#");
				<cfset sayac2 = sayac2 +1>
			</cfif>
		</cfloop>
		<cfset sayac1 = sayac1 + 1>
	</cfif>
</cfoutput>

var temp=document.emps.branch_id;

function redirect(x)
{
	for (m=temp.options.length-1;m>0;m--)
		temp.options[m]=null;
	for (i=0;i<group[x].length;i++){
		temp.options[i]=new Option(group[x][i].text,group[x][i].value);
		}
	temp.options[0].selected=true;
	redirect1(0);
}

var secondGroups=document.emps.branch_id.options.length;
var secondGroup=new Array(groups);
for (i=0; i<groups; i++)  
	{
	secondGroup[i]=new Array(group[i].length);
	for (j=0; j<group[i].length; j++)  
		{
		secondGroup[i][j]=new Array();
		}
	}

<cfset sayac1 = 1>
<cfoutput query="zones">
	<cfset attributes.zone_id = zones.zone_id>
	<cfinclude template="../query/get_branches.cfm">
	<cfif isDefined("NAMES")>
		<cfquery name="BRANCHES" datasource="#dsn#">
			SELECT 
				BRANCH_ID, 
				BRANCH_NAME 
			FROM 
				BRANCH
			<cfif isDefined("attributes.ZONE_ID")>
				WHERE ZONE_ID=#attributes.ZONE_ID#
			</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="BRANCHES" datasource="#dsn#">
			SELECT * FROM BRANCH
			<cfif isDefined("attributes.ZONE_ID")>
				WHERE ZONE_ID=#attributes.ZONE_ID#
			</cfif>
		</cfquery>
	</cfif>
	<cfif branches.recordcount>
		<cfset sayac2 = 1>
		<cfloop query="branches">
			<cfset attributes.branch_id = branches.branch_id>
			<cfinclude template="../query/get_departments2.cfm">
			<cfquery name="GET_DEPARTMENTS2" datasource="#dsn#">
				SELECT 
					DEPARTMENT_ID, 
					DEPARTMENT_HEAD
				FROM 
					DEPARTMENT 
				<cfif isDefined("attributes.BRANCH_ID")>
					WHERE BRANCH_ID = #attributes.BRANCH_ID#
				</cfif>
			</cfquery>
			<cfif get_departments2.recordcount>
				secondGroup[#sayac1#][#sayac2#][0]=new Option("Şimdi department Seçiniz"," ");
				<cfset sayac3 = 1>
				<cfloop query="get_departments2">
					secondGroup[#sayac1#][#sayac2#][#sayac3#]=new Option("#department_head#","#department_id#");
					<cfset sayac3 = sayac3 +1>
				</cfloop>
				<cfset sayac2 = sayac2 +1>
			</cfif>
		</cfloop>
		<cfset sayac1 = sayac1 + 1>
	</cfif>
</cfoutput>

var temp1=document.emps.department_id;

function redirect1(y)
{
	for (m=temp1.options.length-1;m>0;m--)
		temp1.options[m]=null;
	for (i=0;i<secondGroup[document.emps.zone_id.options.selectedIndex][y].length;i++){
		temp1.options[i]=new Option(secondGroup[document.emps.zone_id.options.selectedIndex][y][i].text,secondGroup[document.emps.zone_id.options.selectedIndex][y][i].value);
	}
	temp1.options[0].selected=true;
	temp1.options[0].value="";
}

var thirdGroups=document.emps.department_id.options.length;
var thirdGroup=new Array(groups);
for (i=0; i<groups; i++)  
	{
	thirdGroup[i]=new Array(group[i].length);
	for (j=0; j<group[i].length; j++)  
		{
		thirdGroup[i][j]=new Array(secondGroup[i][j].length);
		for (k=0; k<secondGroup[i][j].length; k++)  
			{
			thirdGroup[i][j][k]=new Array();
			}
		}
	}

<cfset sayac1 = 1>
<cfoutput query="zones">
	<cfset attributes.zone_id = zones.zone_id>
	<cfinclude template="../query/get_branches.cfm">
	<cfif isDefined("NAMES")>
		<cfquery name="BRANCHES" datasource="#dsn#">
			SELECT 
				BRANCH_ID, 
				BRANCH_NAME 
			FROM 
				BRANCH
			<cfif isDefined("attributes.ZONE_ID")>
				WHERE ZONE_ID=#attributes.ZONE_ID#
			</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="BRANCHES" datasource="#dsn#">
			SELECT * FROM BRANCH
			<cfif isDefined("attributes.ZONE_ID")>
				WHERE ZONE_ID=#attributes.ZONE_ID#
			</cfif>
		</cfquery>
	</cfif>
	<cfif branches.recordcount>
		<cfset sayac2 = 1>
		<cfloop query="branches">
			<cfset attributes.branch_id = branches.branch_id>
			<cfinclude template="../query/get_departments2.cfm">
			<cfquery name="GET_DEPARTMENTS2" datasource="#dsn#">
				SELECT 
					DEPARTMENT_ID, 
					DEPARTMENT_HEAD
				FROM 
					DEPARTMENT 
				<cfif isDefined("attributes.BRANCH_ID")>
					WHERE BRANCH_ID = #attributes.BRANCH_ID#
				</cfif>
			</cfquery>
			<cfif get_departments2.recordcount>
				<cfset sayac3 = 1>
				<cfloop query="get_departments2">
					<cfset attributes.department_id = get_departments2.department_id>
					<cfinclude template="../query/get_employees.cfm">
					<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
						SELECT 
							<cfif isDefined("attributes.DEPARTMENT_ID") OR (isDefined("attributes.keyword") and len(attributes.keyword))>
							BRANCH.BRANCH_NAME,
							BRANCH.BRANCH_ID,
							DEPARTMENT.DEPARTMENT_ID,
							DEPARTMENT.DEPARTMENT_HEAD,
							EMPLOYEE_POSITIONS.POSITION_CODE,
							</cfif>
							EMPLOYEES.EMPLOYEE_ID,
							EMPLOYEES.EMPLOYEE_NO,
							EMPLOYEES.EMPLOYEE_NAME, 
							EMPLOYEES.EMPLOYEE_SURNAME,
							EMPLOYEES.DIRECT_TELCODE,
							EMPLOYEES.DIRECT_TEL,
							EMPLOYEES.EXTENSION
						FROM 
							<cfif isDefined("attributes.DEPARTMENT_ID")>
							EMPLOYEE_POSITIONS,
							</cfif>
							<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
							BRANCH,
							</cfif>
							EMPLOYEES
						WHERE
							EMPLOYEES.EMPLOYEE_STATUS = 1
						<cfif isDefined("attributes.EMPLOYEE_IDS")>
							<cfif len(attributes.EMPLOYEE_IDS)>
							AND EMPLOYEES.EMPLOYEE_ID IN (#attributes.EMPLOYEE_IDS#)
							</cfif>
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
								EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
								OR
								EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
								OR
								DEPARTMENT.DEPARTMENT_HEAD LIKE '%#attributes.keyword#%'
								OR
								BRANCH.BRANCH_NAME LIKE '%#attributes.keyword#%'
								)
							</cfif>
						</cfif>
						ORDER BY
							EMPLOYEES.EMPLOYEE_NAME,
							EMPLOYEES.EMPLOYEE_SURNAME
					</cfquery>
					thirdGroup[#sayac1#][#sayac2#][#sayac3#][0]=new Option("employees","0");
					<cfset sayac4 = 1>
					<cfloop query="get_employees">
						thirdGroup[#sayac1#][#sayac2#][#sayac3#][#sayac4#]=new Option("#employee_name# #employee_surname#","#positon_code#");
						<cfset sayac4 = sayac4 +1>
					</cfloop>
					<cfset sayac3=sayac3 +1>
				</cfloop>
				<cfset sayac2 = sayac2 +1>
			</cfif>
		</cfloop>
		<cfset sayac1 = sayac1 + 1>
	</cfif>
</cfoutput>

var temp2=document.emps.source_to;

function redirect2(y)
{
	for (m=temp2.options.length-1;m>0;m--)
		{temp2.options[m]=null;}
	if(y != 0)	
		{
		for (i=0;i<thirdGroup[document.emps.zone_id.options.selectedIndex][document.emps.branch_id.options.selectedIndex][y].length-1;i++)
			{temp2.options[i]=new Option(thirdGroup[document.emps.zone_id.options.selectedIndex][document.emps.branch_id.options.selectedIndex][y][i+1].text,thirdGroup[document.emps.zone_id.options.selectedIndex][document.emps.branch_id.options.selectedIndex][y][i+1].value);}
		temp2.options[0].selected=true;
		temp2.options[0].value="";
		}
	else
		{
		temp2.options[0]=null;
		}
}
</script>         
				</td>
              </tr>
           </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
