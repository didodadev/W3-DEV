<cfset url_str = "">
<cfparam name="attributes.employee_id" default='#session.ep.userid#'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)> 
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif> 

<cfinclude template="../query/get_emp_mails.cfm">
<cfparam name="attributes.page" default=1>						
<cfparam name="attributes.totalrecords" default="#EMP_MAIL_LIST.recordcount#"><br />
<table border="0" cellspacing="1" cellpadding="2" class="color-border" width="98%" align="center">
    <tr class="color-header">
        <td colspan="5" height="25" class="form-title"><cfoutput><cf_get_lang no='79.Mail Ayarlari'> : #get_emp_info(attributes.employee_id,0,0)#</cfoutput></td>
    </tr>
    <tr height="22" class="color-list"> 
        <td class="txtboldblue" width="200"><cf_get_lang_main no ='16.E-mail'></td>
        <td class="txtboldblue" width="200"><cf_get_lang_main no ='139.Kullanici Adi'></td>
        <td class="txtboldblue" width="200"><cf_get_lang no ='169.POP Sunucusu'></td>
        <td class="txtboldblue"><cf_get_lang no ='170.SMTP Sunucusu'></td>
        <td width="15"><a href="javascript://" onClick="goster(add_mail_addres_);open_add_mail_(<cfoutput>#attributes.employee_id#</cfoutput>);"><img src="/images/plus_list.gif" style="cursor:pointer;"  alt="<cf_get_lang_main no='170.Ekle'>" border="0"></a></td>
    </tr>
	<cfif EMP_MAIL_LIST.recordcount>							
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <cfoutput query="EMP_MAIL_LIST" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">	   
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td><a onClick="open_update_mailbox('#mailbox_id#','#attributes.employee_id#');" style="cursor:pointer;" class="tableyazi">#EMAIL#</a></td>
                <td>#ACCOUNT#</td>
                <td>#POP#</td>
                <td>#SMTP#</td>
                <td><a href="javascript://" onClick="open_update_mailbox('#mailbox_id#','#attributes.employee_id#');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr height="20" class="color-row"> 
            <td colspan="5"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
        </tr>
    </cfif>	
</table>
<br />
<cfquery name="get_signature" datasource="#DSN#">
	SELECT * FROM CUBE_MAIL_SIGNATURE WHERE EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<table border="0" cellspacing="1" cellpadding="2" class="color-border" width="98%" align="center">
    <tr class="color-header">
        <td colspan="2" height="25" class="form-title"><cfoutput><cf_get_lang no='229.Mail İmzaları'> : #get_emp_info(attributes.employee_id,0,0)#</cfoutput></td>
    </tr>
    <tr height="22" class="color-list"> 
        <td class="txtboldblue"><cf_get_lang no='230.İmza Tanımı'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        <td style="width:15px;" width="15"><a href="javascript://" onClick="open_add_mail_signature_(<cfoutput>#attributes.employee_id#</cfoutput>);"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0"></a></td>
    </tr>
	<cfif get_signature.recordcount>
        <cfoutput query="get_signature">	   
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td><a onClick="open_update_signature('#signature_id#','#attributes.employee_id#');" class="tableyazi">#signature_name#</a></td>
                <td style="width:15px; float:right;"><a href="javascript://" onClick="open_update_signature('#signature_id#','#attributes.employee_id#');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a></td>
            </tr>
		</cfoutput>
    <cfelse>
        <tr height="20" class="color-row"> 
            <td colspan="2"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
        </tr>
    </cfif>	
</table>

<br />
<cfinclude template="../query/get_folders.cfm">
<cfquery name="get_rules" datasource="#DSN#">
	SELECT * FROM CUBE_MAIL_RULES WHERE EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<table border="0" cellspacing="1" cellpadding="2" class="color-border" width="98%" align="center">
    <tr class="color-header">
        <td colspan="5" height="25" class="form-title"><cfoutput><cf_get_lang no='224.Mail Kuralları'> : #get_emp_info(attributes.employee_id,0,0)#</cfoutput></td>
    </tr>
    <tr height="22" class="color-list"> 
        <td class="txtboldblue" width="200"><cf_get_lang no='225.Kural Tanımları'></td>
        <td class="txtboldblue" width="200"><cf_get_lang no='226.Arama Tipi'></td>
		<td class="txtboldblue" width="200"><cf_get_lang no='227.Kelime'></td>
        <td class="txtboldblue"><cf_get_lang no='228.Taşınacak Klasör'></td>
        <td width="15"><a href="javascript://" onClick="open_add_mail_rule_(<cfoutput>#attributes.employee_id#</cfoutput>);"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0"></a></td>
    </tr>
	<cfif get_rules.recordcount>
        <cfoutput query="get_rules">	   
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td><a onClick="open_update_rule('#rule_id#','#attributes.employee_id#');" class="tableyazi">#rule_name#</a></td>
                <td>
					  <cfif rule_type eq 1>
						<cf_get_lang no='235.Kimden Satırında Ara'>
						<cfelseif rule_type eq 2>
						<cf_get_lang no='236.Mail İçeriğinde Ara'>
						<cfelseif rule_type eq 3>
						<cf_get_lang no='237.Mail Başlığında Ara'>
						<cfelseif rule_type eq 4>
						<cf_get_lang no='238.Mail Kime Satırında Ara'>
				      </cfif>
			  </td>
					  
       			<td>#RULE_CASE#</td>
                <td>
					<cfquery name="get_this_folder" dbtype="query">
						SELECT * FROM get_folders WHERE FOLDER_ID = #folder_id#
					</cfquery>
					#get_this_folder.folder_name#
				</td>
                <td><a href="javascript://" onClick="open_update_rule('#rule_id#','#attributes.employee_id#');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a></td>
            </tr>
		</cfoutput>
    <cfelse>
        <tr height="20" class="color-row"> 
            <td colspan="5"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
        </tr>
    </cfif>	
</table>
<cfif get_module_power_user(29) or session.ep.admin eq 1>
<br />

<cfquery name="get_main_rules" datasource="#DSN#">
	SELECT * FROM CUBE_MAIL_MAIN_RULES
</cfquery>
<table border="0" cellspacing="1" cellpadding="2" class="color-border" width="98%" align="center">
    <tr class="color-header">
        <td colspan="4" height="25" class="form-title"><cfoutput><cf_get_lang no='252.Genel Mail Kuralları'> : #get_emp_info(attributes.employee_id,0,0)#</cfoutput></td>
    </tr>
    <tr height="22" class="color-list"> 
        <td class="txtboldblue" width="200"><cf_get_lang no='253.İlgili Mail'></td>
		<td class="txtboldblue" width="200"><cf_get_lang_main no='218.Tip'></td>
		<td class="txtboldblue"><cf_get_lang no='254.Aktarılacak Mailler'></td>
        <td width="15">
			<a href="javascript://" onClick="open_add_main_mail_rule('#rule_id#');">
        	<img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
		</td>
    </tr>
	<cfif get_main_rules.recordcount>
	<cfoutput query="get_main_rules">	   
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td><a onClick="open_update_main_rule('#rule_id#','#attributes.employee_id#');" class="tableyazi">#rule_name#</a></td>
                <td>
					<cfif type eq 0>
						<cf_get_lang_main no='1562.Gelen'>
						<cfelseif type eq 1>
						<cf_get_lang_main no='1563.Giden'>
					</cfif>
				</td>
				<td>#ACTION#</td>
				<td>
					<a href="javascript://" onClick="open_update_main_rule('#rule_id#');">
					<img src="/images/update_list.gif" alt="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a>
				</td>
            </tr>
	</cfoutput>
	<cfelse>
        <tr height="20" class="color-row"> 
            <td colspan="4"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
        </tr>
	</cfif>
</table>
</cfif>

<div id="add_mail_addres_" style="left:19px; top:65px; position:absolute; width:0px;"></div>
<div id="add_mail_rule_" style="left:19px; top:65px;;position:absolute; width:0px;"></div>
<div id="add_mail_signature_" style="left:19px; top:65px;;position:absolute; width:0px;"></div>
<div id="add_main_mail_rule_" style="left:19px; top:65px;;position:absolute; width:0px;"></div>

<script type="text/javascript">
	function open_add_mail_(employeeId)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_add_new_mail&employee_id='+employeeId,'add_mail_addres_','1');
	}
	function open_update_mailbox(mailbox_id,employeeId)
	{ 
		AjaxPageLoad( '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_mail_settings&mailbox_id='+mailbox_id+'&employee_id='+employeeId,'add_mail_addres_','1');
	}
	function open_add_mail_rule_(employeeId)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_add_mail_rule&employee_id='+employeeId,'add_mail_rule_','1');
	}
	function open_update_rule(ruleID, employeeId){
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_rule_settings&rule_id=' + ruleID + '&employee_id=' + employeeId, 'add_mail_rule_', '1');
	}
	function open_add_mail_signature_(employeeId)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_add_mail_signature&employee_id='+employeeId,'add_mail_signature_','1');
	}
	function open_update_signature(signatureID,employeeId)
	{ 
		AjaxPageLoad( '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_signature_settings&signature_id='+signatureID+'&employee_id='+employeeId,'add_mail_signature_','1');
	}
	function open_add_main_mail_rule(employeeId)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_add_main_mail_rule','add_main_mail_rule_','1');
	}
	function open_update_main_rule(ruleID,employeeId)
	{ 
		AjaxPageLoad( '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_main_rule_settings&rule_id='+ruleID,'add_main_mail_rule_','1');
	}
</script>             

