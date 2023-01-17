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
				var newElem = document.createElement("OPTION");
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
		str=document.all.module_id.value;
		str2=document.all.module_id.value;
		<cfif isDefined("attributes.field_td")>
			text_ = text_ + document.users.target_to.options[i].text + "<br/>";
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
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT 
		MODULE_ID, 
		MODULE_NAME 
	FROM 
		MODULES 
	ORDER BY
		MODULE_NAME
</cfquery>
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang dictionary_id='33110.Modüller'></td>
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
                    <form name="users" action="">
                      <tr>
                        <td>
                          <table>
                            <tr>
                              <td>
                                <select name="source_to" id="source_to" size="9" style="width:150px;" multiple>
								  <cfoutput query="GET_MODULES">
									    <option value="#MODULE_ID#">#MODULE_NAME#</option> 
                                    </cfoutput>
                                </select>
                              </td>
                              <td align="center"> <a href="#" onclick="add_users(document.users.source_to, document.users.target_to);return false;"><img src="/images/list_plus.gif" title="<cf_get_lang dictionary_id='44630.Ekle'>" border="0"></a><br/>
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
	var to_modulecat_groups=document.users.to_modulecats.options.length;
	var to_modulecat_group=new Array(to_modulecat_groups);
	for (i=0; i<to_modulecat_groups; i++) 
		to_modulecat_group[i]=new Array();
	to_modulecat_group[0][0]=new Option("----------------------"," ");
	<cfoutput query="GET_MODULES">
		to_modulecat_group[#currentrow#][#evaluate(currentrow-1)#]=new Option("#MODULE_NAME#","#MODULE_ID#");
	</cfoutput>
	var temp=document.users.source_to;
	function to_emp_redirect(x){
	clear_source();
	for (i=0;i<to_modulecat_group[x].length;i++)
		{
		newItem = new Option(to_modulecat_group[x][i].text,to_modulecat_group[x][i].value)
		temp.options.add(newItem);
		}
	}
</script>
