<script type="text/javascript">
	<cfif attributes.action is not 'mail'>
		window.opener.close();
	</cfif>	  
	function waitfor()
		{ window.close(); }
	<cfif attributes.action is not 'print'>
		setTimeout("waitfor()",4000); 
	</cfif>
</script>

<cfif attributes.action is 'print'>
	<cfif not isDefined("attributes.full_operations")>
		<cfsavecontent variable="cont">
			<cfinclude template="dsp_template.cfm"></cfsavecontent>
		<cfoutput>#cont#</cfoutput>
	<cfelse>
		<cfsavecontent variable="cont">
			<cfinclude template="dsp_template.cfm">
		</cfsavecontent>
		<cfsavecontent variable="cont1">
			<cfinclude template="additional_templates.cfm">
		</cfsavecontent>
		<cfoutput>#cont#<br/>#cont1#</cfoutput>		
	</cfif>

    <script type="text/javascript">
	    function afterWhile(){window.close();}
	    setTimeout("afterWhile()",3000);
		function printpreview()
		{
			/*var OLECMDID = 7;
			/* OLECMDID values:
			* 6 - print
			* 7 - print preview
			* 1 - open window
			* 4 - Save As
			*/
			/*var PROMPT = 1; /* 2 DONTPROMPTUSER 
			var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
			try{
				document.body.insertAdjacentHTML('beforeEnd', WebBrowser); 
				WebBrowser1.ExecWB(OLECMDID, PROMPT);
				WebBrowser1.outerHTML = "";
			}
			catch(e){
				window.print();
			}*/
			window.print();
		}
	    printpreview();
	</script>

<cfelseif attributes.action is 'mail'>
    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
		<cfset sender = "#session.ep.company#<#session.ep.company_email#>">
	<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
		<cfset sender = "#session.pp.our_name#<#session.pp.our_company_email#>">
	<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>
		<cfset sender = "#session.cp.our_name#<#session.cp.our_company_email#>">
	<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
		<cfset sender = "#session.ww.our_name#<#session.ww.our_company_email#>">
	</cfif>
	<cfquery name="GET_MAILFROM" datasource="#dsn#">
		SELECT
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_EMAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,COMPANY_PARTNER_EMAIL</cfif>
		FROM
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_POSITIONS<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
		WHERE
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID=#session.ep.USERID#
			<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID=#session.pp.USERID#
			</cfif>
	</cfquery>
	<cfif Len(GET_MAILFROM.EMPLOYEE_EMAIL)>
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
			<cfset sender = "#GET_MAILFROM.EMPLOYEE_NAME# #GET_MAILFROM.EMPLOYEE_SURNAME#<#GET_MAILFROM.EMPLOYEE_EMAIL#>">
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
			<cfset sender = "#GET_MAILFROM.COMPANY_PARTNER_NAME# #GET_MAILFROM.COMPANY_PARTNER_SURNAME#<#GET_MAILFROM.COMPANY_PARTNER_EMAIL#>">
		</cfif>
	</cfif>
    
	<cftry>
		<cfsavecontent variable="content">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			</style>
            <cfif isdefined("attributes.operation") and attributes.operation is 'emptypopup_temp_rule'>
            	<cfinclude template="../../rules/display/temp_rule.cfm">
            </cfif>
		</cfsavecontent>
        
		<cfmail to="#attributes.to_id#" from="#sender#" subject="#attributes.subject#" cc="#attributes.cc_id#" type="HTML">
			<cfoutput>#content#</cfoutput>
		</cfmail>
		<cfset attributes.body = "#content#">
		<cfset attributes.type = 0>
		<cfset attributes.to = attributes.to_id>
		<cfset attributes.cc = attributes.cc_id>
		<cfinclude template="../query/add_mail.cfm">

		<cfsavecontent variable="message"><cf_get_lang dictionary_id='57512.Workcube E-Mail'></cfsavecontent>
        <cf_popup_box title="#message#">
            <table width="100%">
                <tr height="300">
                    <td class="formbold" style="text-align:center"><cf_get_lang dictionary_id='57513.Mail Başarıyla Gönderildi'></td>
                </tr>
            </table>
        </cf_popup_box>
		<cfcatch type="any">
			<cf_popup_box title="#message#">
                <table width="100%">
                    <tr height="300">
                        <td class="formbold" style="text-align:center"><cf_get_lang dictionary_id='57618.Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'></td>
                    </tr>
                </table>
            </cf_popup_box>
		</cfcatch>
	</cftry>				  	
<cfelseif attributes.action is 'pdf'>  	
	<!--- 20060126 modulden gelen cont un iceriginde siller uygun olmadigi icin HTML e sil kondu --->
	<cfsavecontent variable="cont">
		<!-- sil -->
		<cfinclude template="dsp_template.cfm">
		<cfif isDefined("attributes.full_operations")>
			<cfinclude template="additional_templates.cfm">
		</cfif>
		<!-- sil -->
	</cfsavecontent>
	<cfset cont = wrk_content_clear(cont)>
	<cfset filename = "#createuuid()#.pdf">
	
	<!--- cfdocument ile ilgili aciklmalar
	20051223
		pageheight = "800" pagewidth = "600" bu degerler icin hata verdi, en fazla 200 olurlar diyordu hatada.
		name="#attributes.name#" pagetype="custom"  pageheight="100" pagewidth="100"
	20060126 filename : bu eleman dosyayi kaydetmek icin kulllanilmali ve filename="#filename#" degil
		filename="#upload_folder#salespur#dir_seperator##filename#" seklinde olmali kullanilirsa
	20060126 Ayrica bu ekran default A4 basmali olcu elemanlari verilirse alttaki sekilde verilmeli
		pagetype="custom"
		pageheight = "30" 
		pagewidth = "20"
		margintop="2"	
		marginright="2"
		marginleft="2"
		marginbottom="2"
		unit="cm"
	--->
	<cfdocument
		format="#attributes.action#" 
		orientation="PORTRAIT" 
		backgroundvisible="false" 
		encryption="128-bit"
		pagetype="A4">
		<link rel='stylesheet' href='css/win_ie_1.css' type='text/css'>
		<cfoutput>#cont#</cfoutput>
	</cfdocument>
<cfelseif attributes.action is 'excel'>
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=document.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-8">
	<cfif not isDefined("attributes.full_operations")>
		<cfsavecontent variable="cont">
			<cfinclude template="dsp_template.cfm"></cfsavecontent>
		<cfoutput>#cont#</cfoutput>
	<cfelse>
		<cfsavecontent variable="cont">
			<cfinclude template="dsp_template.cfm">
		</cfsavecontent>
		<cfsavecontent variable="cont1">
			<cfinclude template="additional_templates.cfm">
		</cfsavecontent>
		<cfoutput>#cont#<br/>#cont1#</cfoutput>		
	</cfif>
</cfif>
