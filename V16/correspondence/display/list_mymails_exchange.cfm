<cfset url_str = "">
<cfparam name="attributes.employee_id" default='#session.ep.userid#'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)> 
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif> 

<cfquery name="EXCHANGE_SETTINGS" datasource="#dsn#">
	SELECT
		SETTING_ID,
		SERVER_ADDRESS,
		USERNAME,
		PORT,
		PROTOCOL
	FROM
		EXCHANGE_SETTINGS
	WHERE 
		USER_ID = #session.ep.userid#
</cfquery>
		
<cfparam name="attributes.page" default=1>						
<cfparam name="attributes.totalrecords" default="#EXCHANGE_SETTINGS.recordcount#"><br />
<table class="dph">
	<tr>
    	<td class="dpht"><cfoutput><cf_get_lang no='79.Mail Ayarlari'> : #get_emp_info(attributes.employee_id,0,0)#</cfoutput></td>
    </tr>
</table>
<cf_big_list>
	<thead>
        <tr> 
            <th width="150"><cf_get_lang dictionary_id="55686.Mail Adresi"></th>
            <th width="150"><cf_get_lang dictionary_id="54828.Mail Sunucusu"></th>        
            <th width="150"><cf_get_lang dictionary_id="54829.PROTOKOL"></th>
            <th width="150"><cf_get_lang dictionary_id="54830.PORT"></th>
            <th class="header_icn_none"><a href="javascript://" onClick="goster(add_mail_addres_);open_add_mail_();"><img src="/images/plus_list.gif" style="cursor:pointer;"  alt="<cf_get_lang_main no='170.Ekle'>" border="0"></a></th>
        </tr>
    </thead>
    <tbody>
		<cfif EXCHANGE_SETTINGS.recordcount>							
            <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
            <cfoutput query="EXCHANGE_SETTINGS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">	   
                <tr>
                    <td><a onClick="open_update_mailbox('#SETTING_ID#');">#USERNAME#</a></td>
                    <td>#SERVER_ADDRESS#</td>
                    <td>#PROTOCOL#</td>
                    <td>#PORT#</td>
                    <td width="1%"><a href="javascript://" onClick="open_update_mailbox('#SETTING_ID#');">
                    <img src="/images/update_list.gif" alt="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr> 
                <td colspan="5"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
            </tr>
        </cfif>	
    </tbody>
</cf_big_list>
<div id="add_mail_addres_" style="position:absolute; right:350px; margin-top:-45px; z-index:1;"></div>
<script type="text/javascript">
	function open_add_mail_()
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.add_exchangemail_settings','add_mail_addres_','1');
	}
	function open_update_mailbox(mailbox_id)
	{ 
		AjaxPageLoad( '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.upd_exchangemail_settings&mailbox_id='+mailbox_id,'add_mail_addres_','1');
	}	
</script>             

