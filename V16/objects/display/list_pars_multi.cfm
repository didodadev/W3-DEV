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
	par_value_ = "";
	cmp_value_ = "";
	for (i=document.pars.target_to.options.length-1; i>=0; i--)
		{
		<cfif isdefined("attributes.field_comp_id")>
			value_ = document.pars.target_to.options[i].value;
			yer = value_.indexOf("-");
			par_value_ = par_value_ + value_.substr(yer+1, value_.length - yer + 1) + ",";
			cmp_value_ = cmp_value_ + value_.substr(0,yer) + ",";
		<cfelse>
			par_value_ = par_value_ + document.pars.target_to.options[i].value + ",";
		</cfif>

		<cfif isDefined("attributes.field_td")>
			text_ = text_ + document.pars.target_to.options[i].text + "<br/>";
		</cfif>
		}
	// sondaki virgül atılır	
	if (document.pars.target_to.options.length != 0)
		{
			par_value_ = par_value_.toString().substr(0,par_value_.length-1);
		<cfif isdefined("attributes.field_comp_id")>
			cmp_value_ = cmp_value_.toString().substr(0,cmp_value_.length-1);
		</cfif>
		}
	// sayfaya yazılır
	if (update == 0)
		{
		opener.<cfoutput>#attributes.field_par_id#</cfoutput>.value = "," + par_value_ + ",";
	
		<cfif isdefined("attributes.field_comp_id")>
			opener.<cfoutput>#attributes.field_comp_id#</cfoutput>.value = "," + cmp_value_ + ",";
		</cfif>
	
		<cfif isDefined("attributes.field_td")>
			opener.<cfoutput>#attributes.field_td#</cfoutput>.innerHTML = text_;
		</cfif>
		}
	else
		{
		opener.<cfoutput>#attributes.field_par_id#</cfoutput>.value += par_value_+ ",";
	
		<cfif isdefined("attributes.field_comp_id")>
			opener.<cfoutput>#attributes.field_comp_id#</cfoutput>.value += cmp_value_ + ",";
		</cfif>
	
		<cfif isDefined("attributes.field_td")>
			opener.<cfoutput>#attributes.field_td#</cfoutput>.innerHTML += "<br/>" + text_;
		</cfif>
		}
	window.close();	
	return true;
}
//-->
</script>

<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border"> 
    <td valign="middle"> 
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle"> 
          <td height="35"> 
            <table width="98%" align="center">
              <tr> 
                <td valign="bottom" class="headbold"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top"> 
          <td> 
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr> 
                <td colspan="2">
				

<!--- _sil
 gelenler:
field_par_id	= form.par_ids
field_comp_id	= form.comp_ids
field_td		= td_id
company_name 	= 1 {partner firmasıyla yazılır verilmezse sadece partner yazılır}
--->

<table border="0" cellpadding="0" cellspacing="0">
<form name="pars">
   <tr> 
      <td> 
<!--- company_cat --->			
        <table border="0">
          <tr> 
              <td><cf_get_lang dictionary_id='57486.Kategori'></td>
		      <td> 
		        <cfset names=1>
		        <cfinclude template="../query/get_partner_cats.cfm">
		        <select name="cat_id" id="cat_id" size="1" onChange="redirect(this.options.selectedIndex)" style="width:150px;"  >
		          <option value=""><cf_get_lang dictionary_id='58947.Kategori Seçiniz'></option>
		          <cfoutput query="get_partner_cats"> 
		            <cfset attributes.COMPANYCAT_ID = get_partner_cats.COMPANYCAT_ID>
		            <cfinclude template="../query/get_cat_comp_count.cfm">
		            <cfif len(get_cat_comp_count.total)>
		            <option value="#COMPANYCAT_ID#">#COMPANYCAT#</option>
		            </cfif>
		          </cfoutput> 
		        </select>
		      </td>
          </tr>
<!--- copmpany --->
          <tr> 
			  <td><cf_get_lang dictionary_id='57658.Üye'></td>
		      <td> 
		        <select name="company_id" id="company_id" style="width:150px;" size="1" onChange="redirect1(this.options.selectedIndex)"  >
		          <option value=""><cf_get_lang dictionary_id='32972.Önce Kategori Seçiniz'></option>
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
				<a href="#" onclick="add_users(document.pars.source_to, document.pars.target_to);return false;"><img src="/images/list_plus.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0"></a><br/>
    	        <a href="#" onclick="remove(document.pars.target_to);return false;"><img src="/images/list_minus.gif" title="<cf_get_lang dictionary_id='32936.Çıkart'>" border="0"></a></td>
			<td>
			<select name="target_to" id="target_to" size="10" style="width:150px;" multiple>
			</select>
			</td>
		  </tr>
          <tr height="30"> 
            <td colspan="3" style="text-align:right;">
			<cf_workcube_buttons is_upd='0' add_function='prepeare(0)' insert_alert=''>
			</td>
		  </tr>
	</table>		
	</td>
	</tr>
</form>	
</table>


<script type="text/javascript">
var groups=document.pars.cat_id.options.length
var group=new Array(groups)
for (i=0; i<groups; i++)
	{
	group[i]=new Array()
	}
group[0][0]=new Option("<cf_get_lang dictionary_id='32972.Önce Kategori Seçiniz'>"," ");

<cfset sayac1 = 1>
<cfoutput query="get_partner_cats">
	<cfset attributes.companycat_id = get_partner_cats.companycat_id>
	<cfinclude template="../query/get_PARTNER_COMPS.cfm">
	<cfif PARTNER_COMPS.recordcount>
		group[#sayac1#][0]=new Option("Şimdi Üye Seçiniz"," ");
		<cfset sayac2 = 1>
		<cfloop query="PARTNER_COMPS">
			<cfset attributes.company_id = PARTNER_COMPS.company_id>
			<cfinclude template="../query/get_cat_comp_count.cfm">
			<cfif len(get_cat_comp_count.total)>
				group[#sayac1#][#sayac2#]=new Option("#fullname#","#company_id#")
				<cfset sayac2 = sayac2 +1>
			</cfif>
		</cfloop>
		<cfset sayac1 = sayac1 + 1>
	</cfif>
</cfoutput>

var temp=document.pars.company_id

function redirect(x){
for (m=temp.options.length-1;m>0;m--)
	temp.options[m]=null
for (i=0;i<group[x].length;i++)
	temp.options[i]=new Option(group[x][i].text,group[x][i].value)
temp.options[0].selected=true
redirect1(0)
}

var secondGroups=document.pars.company_id.options.length
var secondGroup=new Array(groups)
for (i=0; i<groups; i++)  
	{
	secondGroup[i]=new Array(group[i].length)
	for (j=0; j<group[i].length; j++)  
		{
		secondGroup[i][j]=new Array()  
		}
	}

<cfset sayac1 = 1>
<cfoutput query="get_partner_cats">
	<cfset attributes.companycat_id = get_partner_cats.companycat_id>
	<cfinclude template="../query/get_partner_comps.cfm">
	<cfif partner_comps.recordcount>
		<cfset sayac2 = 1>
		<cfloop query="partner_comps">
			<cfset attributes.company_id = partner_comps.company_id>
			<cfinclude template="../query/get_partners.cfm">
			<cfif get_partners.recordcount>
				secondGroup[#sayac1#][#sayac2#][0]=new Option("partner"," ");
				<cfset sayac3 = 1>
				<cfloop query="get_partners">
					secondGroup[#sayac1#][#sayac2#][#sayac3#]=new Option("#company_partner_name# #company_partner_surname#<cfif isdefined("attributes.company_name")> - #partner_comps.nickname#</cfif>","<cfif isdefined("attributes.field_comp_id")>#partner_comps.company_id#-</cfif>#partner_id#")
					<cfset sayac3 = sayac3 +1>
				</cfloop>
				<cfset sayac2 = sayac2 +1>
			</cfif>
		</cfloop>
		<cfset sayac1 = sayac1 + 1>
	</cfif>
</cfoutput>

var temp1=document.pars.source_to

function redirect1(y)
{
for (m=temp1.options.length-1;m>0;m--)
	temp1.options[m]=null
if(y!=0)
	{
	for (i=0;i<secondGroup[document.pars.cat_id.options.selectedIndex][y].length-1;i++)
		temp1.options[i]=new Option(secondGroup[document.pars.cat_id.options.selectedIndex][y][i+1].text,secondGroup[document.pars.cat_id.options.selectedIndex][y][i+1].value)
	}
else
	{
	temp1.options[0]=null
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


