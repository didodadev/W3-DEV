<cfscript>
	to_emps = "";
	to_pars = "";
	to_cons = "";
	to_grps = "";
	to_adrs = "";
	cc_emps = "";
	cc_pars = "";
	cc_cons = "";
	cc_grps = "";
	cc_adrs = "";	
	bcc_emps = "";
	bcc_pars = "";
	bcc_cons = "";
	bcc_grps = "";
	bcc_adrs = "";
</cfscript>	
<cfloop list="#attributes.emp_id#" index="i">
	<cfif i contains "emp">
		<cfset to_emps = listappend(to_emps,listgetat(i,2,"-"))>
	<cfelseif i contains "par">
		<cfset to_pars = listappend(to_pars,listgetat(i,2,"-"))>
	<cfelseif i contains "con">
		<cfset to_cons = listappend(to_cons,listgetat(i,2,"-"))>
	<cfelseif i contains "grp">
		<cfset to_grps = listappend(to_grps,listgetat(i,2,"-"))>
	<cfelseif i contains "adr">
		<cfset to_adrs = listappend(to_adrs,listgetat(i,2,"-"))>
	</cfif>
</cfloop> 

<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.attachment") and len(attributes.attachment)>
	<cftry> 
		<cffile 
			action="upload"
			nameconflict="overwrite"
			filefield="attachment"
			destination="#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
		<cffile 
			action="rename" 
			source="#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator##cffile.serverfile#" 
			destination="#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator##file_name#">	
		<!---Script dosyalarını engelle  02092010 ND --->
        <cfset assetTypeName = listlast(cffile.serverfile,'.')>
        <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
        <cfif listfind(blackList,assetTypeName,',')>
            <cffile action="delete" file="#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator##file_name#">
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='47804.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz'>!!");
                history.back();
            </script>
            <cfabort>
        </cfif>	
		<cfset attributes.attachment = file_name>
		<cfset attributes.attachment_name = cffile.serverfile>
		<cfcatch type="any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='57455.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>	
	</cftry>
	<cfset attributes.attachment_count = 1>
	<cfset this_dosya_1 = attributes.attachment>
	<cfset attributes.file_name1 = attributes.attachment_name>
<cfelse>
	<cfset attributes.attachment_count = 0>
</cfif>
<cfsavecontent variable="css">
	<style type="text/css">
		.color-header{background-color:a7caed;}
		.color-list	{background-color:E6E6FF;}
		.color-border{background-color:6699cc;}
		.color-row{background-color:f1f0ff;}
		.label{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:333333;padding-left: 4px;}
		.form-title{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:white;font-weight : bold;padding-left: 2px;}	
		.tableyazi{font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color:0033CC;}          
		a.tableyazi:visited{font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color:0033CC;} 
		a.tableyazi:active{text-decoration: none;}
		a.tableyazi:hover{text-decoration: underline; color:339900;}  
		a.tableyazi:link{font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;padding-left: 2px;color:0033CC;}
		.headbold{font-family:Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
		th{text-align:left;}
		.modal{ display:none; }
		.color-darkCyan{ display:none;}
		.modal-title { display:none; }
		img[class=hideable] {display: none;}
		.close{display:none;  }
	</style>
</cfsavecontent>
<cfsavecontent variable="ust"><cfinclude template="view_company_logo.cfm"></cfsavecontent> 
<cfsavecontent variable="alt"><cfinclude template="view_company_info.cfm"></cfsavecontent>
<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
	<cfset cont = "">
    <cfquery name="GET_ASSET" datasource="#DSN#">
        SELECT
            ASSET.ASSET_NAME,
            ASSET.ASSET_FILE_NAME,
            ASSET.ASSET_FILE_PATH_NAME,
            ASSET_CAT.ASSETCAT_ID,
            ASSET_CAT.ASSETCAT_PATH
        FROM
            ASSET,
            ASSET_CAT
        WHERE
            ASSET.ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#"> AND 
            ASSET_CAT.ASSETCAT_ID = ASSET.ASSETCAT_ID
    </cfquery>
    <cfif get_asset.assetcat_id gte 0>
		<cfset folder="asset/">
    <cfelse>
        <cfset folder="">
    </cfif>
    <cfif not len(get_asset.asset_file_path_name)>
       <cfset attch = "#upload_folder##folder##get_asset.assetcat_path#/#get_asset.asset_file_name#">
    <cfelse>
        <cfscript>
            get_asset.asset_file_path_name = replacelist(get_asset.asset_file_path_name, "/", "\");
            get_asset.asset_file_path_name = replacelist(get_asset.asset_file_path_name, ":", "$");
        </cfscript>
        <cfset attch = "#upload_folder##folder##get_asset.asset_file_path_name#">
    </cfif>
<cfelse>
	<cfset cont = form.icerik>
    <cfset attch = "">
</cfif>
<cfif cont contains ' class="big_list'>
			<cfset cont = wrk_content_sub_clear (cont,'<!-- sil -->','<!-- sil -->')>
            <cfset cont = wrk_content_sub_clear (cont,'<!-- del -->','<!-- del -->')><!--- Big_list custom tag'inde gizlenen alanlar için düzenleme yapıldı. Böylelikle ekrandan gizlenen alanların excel,pdf'e gelmemesi sağlandı. --->
	<cfif browserDetect() contains 'Chrome'>
		<cfset cont = find_gt_element (cont,'table-layout:fixed;')>
		<cfset cont = find_gt_element (cont,'style="margin: 0px;"')>
		<cfset cont = ReReplaceNoCase(cont,"<link[^>]*>", "", "ALL")>
	</cfif>
	<cfset cont = find_gt_element (cont,'class="big_list_search"')>
	<cfset cont = ReReplaceNoCase(cont,"<a[^>]*>", "", "ALL")>
	<cfset cont = ReReplaceNoCase(cont,"</a>", "", "ALL")>
	<cfset cont = replace(cont,'class="big_list"','width="100%" cellpadding="5" class="color-border" style="border:solid 1px ##6699CC;"','all')>
<cfelseif cont contains ' class="ajax_list ' or cont contains ' class="ui-table-list '>
	<cfset cont = wrk_content_sub_clear (cont,'<!-- sil -->','<!-- sil -->')>
	<cfset cont = wrk_content_sub_clear (cont,'<!-- del -->','<!-- del -->')><!--- Big_list custom tag'inde gizlenen alanlar için düzenleme yapıldı. Böylelikle ekrandan gizlenen alanların excel,pdf'e gelmemesi sağlandı. --->
	<cfif browserDetect() contains 'Chrome'>
		<cfset cont = find_gt_element (cont,'table-layout:fixed;')>
		<cfset cont = find_gt_element (cont,'style="margin: 0px;"')>
		<cfset cont = ReReplaceNoCase(cont,"<a[^>]*>", "", "ALL")>
		<cfset cont = ReReplaceNoCase(cont,"</a>", "", "ALL")>
		<cfset cont = ReReplaceNoCase(cont,"<link[^>]*>", "", "ALL")>
	</cfif>	
<cfelse>
	<cfset cont = wrk_content_clear(cont)>
	<cfif cont contains ' class="medium_list"'>
		<cfset cont = replace(cont,'class="medium_list"','width="100%" cellpadding="5" class="color-border" style="border:solid 1px ##6699CC;"','all')>
	</cfif>
	<cfif cont contains ' class="detail_basket_list"'>
		<cfset cont = replace(cont,'class="detail_basket_list"','cellpadding="5" class="color-border" style="border:solid 1px ##6699CC;"','all')>
	</cfif>
	<cfif cont contains 'style=text-align: right; mso-number-format: "0.00";'>
		<cfset cont = replace(cont,'style=text-align: right; mso-number-format: "0.00";','style="text-align: right;"','all')>
	</cfif>
	<cfif cont contains 'cellSpacing="0" align="center"'>
		<cfset cont = replace(cont,'cellSpacing="0" align="center"','cellSpacing="0"','all')>
	</cfif>
	
</cfif>

<cfif len(attributes.mailFrom)>
	<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
      <cfmail 
            to="#attributes.emp_name#" 
            from="#attributes.mailFrom#" 
            subject="#attributes.subject#" 
            cc="#attributes.emp_name_cc#" 
            bcc="#attributes.emp_name_bcc#" 
            mimeattach="#attch#"
            type="HTML" > 
            <cfif isdefined("attributes.trail") and attributes.trail eq 1>#ust#<br/></cfif> 
            <cfif isdefined("attributes.trail") and attributes.trail eq 1>#alt#</cfif>
         
        </cfmail> 
    <cfelse>
		<cfmail 
            to="#attributes.emp_name#"   
            from="#attributes.mailFrom#" 
            subject="#attributes.subject#" 
            cc="#attributes.emp_name_cc#" 
            bcc="#attributes.emp_name_bcc#" 
            type="HTML" >
		<cfif attributes.fuseaction eq  'objects.popup_mail_act'> 
            #css#<br/>#attributes.mail_detail#<br />
            <cfif isdefined("attributes.trail") and attributes.trail eq 1>#ust#<br/></cfif> 
            #cont#<br/>
            <cfif isdefined("attributes.trail") and attributes.trail eq 1>#alt#</cfif>
        <cfelse>
            #css#
            <cfif isdefined("attributes.trail") and attributes.trail eq 1>#ust#<br/></cfif> 
            #attributes.mail_detail#<br />#cont#<br/>
            <cfif isdefined("attributes.trail") and attributes.trail eq 1>#alt#</cfif>
        </cfif>
        <cfif isdefined("attributes.filename") and len(attributes.filename)>
            <cfmailparam file = "#upload_folder#reserve_files/#attributes.filename#.pdf" type="text/plain">
        </cfif>
        <cfif isdefined("attributes.attachment") and len(attributes.attachment)>
            <cfmailparam file = "#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator##file_name#">
        </cfif>
        </cfmail>
    </cfif>
	<cfset attributes.from = attributes.mailFrom>	
	<cfset attributes.to_ = attributes.emp_name>  
	<cfset attributes.body='#css##ust#<br/>#cont#<br/>#alt#'> 
	<cfset attributes.type = 0>
	<cfif isdefined('session.ep.userid') and not isdefined("attributes.filename")>
		<cfinclude template="../query/add_mail.cfm">
	</cfif>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57512.Workcube E-Mail'></cfsavecontent>
    <cf_popup_box title="#message#">
    	<table width="100%">
        	<tr height="300">
            	<td class="formbold" style="text-align:center"><cf_get_lang dictionary_id='57513.Mail Başarıyla Gönderildi'></td>
            </tr>
        </table>
    </cf_popup_box>
	<script type="text/javascript">
		function waitfor()
		{
			<cfif isDefined("attributes.is_pop") and (attributes.is_pop EQ 1)>
				window.opener.close();
			</cfif>  
			window.close();
		}
		setTimeout("waitfor()",3000);
	</script>
    <cfset sleep(9999)>
    <cftry>
        <cffile action="delete" file="#download_folder##file_web_path#settings/#attributes.filename#.cfm">
        <cffile action="delete" file="#upload_folder#reserve_files/#attributes.filename#.pdf">
        <cfcatch></cfcatch>
    </cftry>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='34243.Mail Adresiniz Tanımlı Değil Mail Gönderemezsiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
