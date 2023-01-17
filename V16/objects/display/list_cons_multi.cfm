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
	for (i=document.cons.target_to.options.length-1; i>=0; i--)
		{
		value_ = value_ + document.cons.target_to.options[i].value + ",";
		<cfif isDefined("attributes.field_td")>
			text_ = text_ + document.cons.target_to.options[i].text + "<br/>";
		</cfif>
		}
	// sondaki virgül atılır
	if (document.cons.target_to.options.length != 0)
		{
		value_ = value_.toString().substr(0,value_.length-1);
		}
	// sayfaya
	/*if (update == 0)
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
		}*/
	window.close();	
	return true;
}
//-->
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></cfsavecontent>
<cf_popup_box title="#message#">
	<form name="cons">
        <table>
            <tr> 
                <td colspan="3"> 
                	<cf_get_lang dictionary_id='57486.Kategori'>
					<cfset names=1>
                    <cfinclude template="../query/get_consumer_cats.cfm">
                    <select name="cat_id" id="cat_id" size="1" onChange="redirect(this.options.selectedIndex)" style="width:150px;"  >
                      <option value=""><cf_get_lang dictionary_id='58947.Kategori Seçiniz'></option>
                      <cfoutput query="get_consumer_cats"> 
                        <cfset attributes.consumer_cat_ID = get_consumer_cats.consCAT_ID>
                        <option value="#consCAT_ID#">#consCAT#</option>
                      </cfoutput> 
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    <select name="source_to" id="source_to" size="10" style="width:150px;" multiple>
                    </select>
                </td>
                <td align="center"> 
                    <a href="#" onclick="add_users(document.cons.source_to, document.cons.target_to);return false;"><img src="/images/list_plus.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0"></a><br/>
                    <a href="#" onclick="remove(document.cons.target_to);return false;"><img src="/images/list_minus.gif" title="<cf_get_lang dictionary_id='32936.Çıkart'>" border="0"></a></td>
                <td>
                    <select name="target_to" id="target_to" size="10" style="width:150px;" multiple>
                    </select>
                </td>
            </tr>
        </table>
		<cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='prepeare(0)'></cf_popup_box_footer>
	</form>	
</cf_popup_box>
<script type="text/javascript">
var groups=document.cons.cat_id.options.length
var group=new Array(groups)
for (i=0; i<groups; i++)
	{
	group[i]=new Array()
	}
group[0][0]=new Option("<cf_get_lang dictionary_id='32972.Önce Kategori Seçiniz'> !"," ");

<cfset sayac1 = 1>
<cfoutput query="get_consumer_cats">
	<cfset attributes.consumer_cat_id = get_consumer_cats.conscat_id>
	<cfinclude template="../query/get_consumers.cfm">
	<cfif get_consumers.recordcount>
		group[#sayac1#][0]=new Option("consumer"," ");
		<cfset sayac2 = 1>
		<cfloop query="get_consumers">
				group[#sayac1#][#sayac2#]=new Option("#consumer_name# #consumer_surname#","#consumer_id#")
				<cfset sayac2 = sayac2 +1>
		</cfloop>
		<cfset sayac1 = sayac1 + 1>
	</cfif>
</cfoutput>

var temp=document.cons.source_to

function redirect(x)
{
for (m=temp.options.length-1;m>=0;m--)
	temp.options[m]=null

if (x!=0)
	{
	for (i=0;i<group[x].length-1;i++)
		temp.options[i]=new Option(group[x][i+1].text,group[x][i+1].value)
	}
else
	{
	temp.options[0]=null
	}
}
</script>
