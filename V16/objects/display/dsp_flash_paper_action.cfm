<cfsetting showdebugoutput="no">
<cfset attributes.orginal_content = attributes.icerik>
<cfset attributes.icerik = wrk_content_clear(attributes.icerik)>
<cfif attributes.trail>
	<cfsavecontent variable="logo"><cfinclude template="view_company_logo.cfm"></cfsavecontent>
	<cfsavecontent variable="address"><cfinclude template="view_company_info.cfm"></cfsavecontent>	
</cfif>
<cfset ek_bilgi = 0>

<cfif (len(attributes.page_height) and len(attributes.page_width)) or attributes.page_type is 'A3' or attributes.page_type is 'workcubepage'>
	<cfset sayfa_sekli = 'custom'>
	<cfset ek_bilgi = 1>
<cfelse>
	<cfset sayfa_sekli = attributes.page_type>
</cfif>
<cfif attributes.page_type is 'A3'>
	<cfset attributes.page_height = 42>
	<cfset attributes.page_width = 30>
</cfif>
<cfif attributes.page_type is 'workcubepage'>
	<cfset attributes.page_height = 26>
	<cfset attributes.page_width = 26>
</cfif>
<cftry>
<cfif isdefined("is_pdf_header") and is_pdf_header eq 1 and isdefined("session.ep")>
	<cfset pdf_margintop = 0.3>
<cfelse>
	<cfset pdf_margintop = 0.3>
</cfif>
<cfif ek_bilgi>
	<!--- 20060126 name elemani koyulunca nca browser icinde pdf acmiyor
	name="#attributes.name#" pagetype="custom"  pageheight="100" pagewidth="100" --->
	<cfdocument 
		permissions="allowprinting"
		format="#attributes.sayfa_tipi#" 
		orientation="#attributes.Layout#" 
		pagetype="#sayfa_sekli#"
		pageheight = "#attributes.page_height#" 
		pagewidth = "#attributes.page_width#"
		encryption="128-bit"
		backgroundvisible="yes"
		localurl="yes" 
		scale="100"
		unit="cm"
        margintop="#pdf_margintop#"
        marginleft="0"
        marginright="0">
		<link rel='stylesheet' href='css/win_ie_5.css' type='text/css'>
		<cfif isdefined("pdf_header")>
			<cfdocumentitem type="header"><table><tr><td><cfoutput>#session.ep.COMPANY# (#session.ep.period_year#) - #dateformat(now(),dateformat_style)#</cfoutput></td></tr></table></cfdocumentitem>
		</cfif>
		<cfoutput>#attributes.icerik#</cfoutput>
	</cfdocument>
<cfelse>
	<cfif isdefined("attributes.is_related_asset")>
		<cfdocument
			filename="#attributes.name#"
			permissions="allowprinting"
			format="#attributes.sayfa_tipi#" 
			orientation="#attributes.Layout#" 
			pagetype="#sayfa_sekli#"
 			backgroundvisible="yes"
			localurl="yes"
			scale="100"
			encryption="128-bit"
            margintop="#pdf_margintop#"
            marginleft="0"
            marginright="0">
			<link rel='stylesheet' href='css/win_ie_5.css' type='text/css'>
			<cfif isdefined("pdf_header")>
                <cfdocumentitem type="header"><table><tr><td><cfoutput>#session.ep.COMPANY# (#session.ep.period_year#) - #dateformat(now(),dateformat_style)#</cfoutput></td></tr></table></cfdocumentitem>
            </cfif>
		<cfoutput>#attributes.icerik#</cfoutput>
		</cfdocument>
	<cfelse>
    	<cfdocument
				permissions="allowprinting"             
				format="#attributes.sayfa_tipi#" 
				orientation="#attributes.layout#" 
				pagetype="#sayfa_sekli#"
				backgroundvisible="yes"
				encryption="128-bit"
				scale="100"
				mimetype="image/png"
				margintop="#pdf_margintop#"
                localUrl="yes"
                marginleft="0"
                marginright="0"
                marginbottom="0.3"
                >
			<cfif isdefined("attributes.extra_parameters") and attributes.extra_parameters eq 'is_puantaj_print'>
				<style type="text/css">
					.row, .col, .modal-content, label, div {box-sizing: border-box;}				
					.col-6 {width: 50%!important;float: left;}
					.col-12 {width: 100%!important;}
					.ui-table-list{width:100%;border-collapse:collapse;border-spacing:0;font-size:10px;border:1px solid #bbb;}			
					.ui-table-list > thead > tr > th a{color:#555;display:block;text-align:center;transition:.4s;}
					.ui-table-list > thead > tr > th a i{color:#555;font-size:10px;font-weight:normal;transition:.4s;}
					.ui-table-list > tfoot > tr > td, .ui-table-list > tbody > tr > td, .ui-table-list > thead > tr > td{border:1px solid #bbb;font-size:10px;color:#555;min-width:30px;}
					td{font-size:10px!important}
					#wrk_bug_add_div,.portHeadLight,font{ display:none;}				
				</style>
				<cfoutput>#attributes.orginal_content#</cfoutput>
			<cfelse>
                <link rel='stylesheet' href='css/win_ie_special.css' type='text/css'>
				<style>
					table{font-size:8px; font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:#333;}
					tr{font-size:8px;}
					th{font-size:12px;}
					td{font-size:10px;}
					
					tr.color-row td{background-color: #F4F9FD;}
					tr.color-row{background-color: #F4F9FD;}
					.color-row {background-color:#F4F9FD;}
					
					.color-border {background-color:#F4F9FD;}
					
					tr.color-header{background-color: #a7caed;}
					tr.color-header td{background-color: #a7caed;}
					.color-header {background-color: #a7caed;}
					
					.headbold {font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
					.form-title	{font-size:9px;font-family:Geneva, tahoma, arial,  sans-serif;color:white;font-weight : bold;}
					.big_list
					{
					 border:solid 1px #6699CC;	
					}
					.medium_list
					{
					 border:solid 1px #6699CC;	
					}
					thead tr
					{
						background-color:#DAEAF8;
						color:#6699CC;
						font-weight:bold;
						padding:0px;
						border:dotted 1px;
						height:30px;
					}
					thead tr th
					{
						background-color:#DAEAF8;
						color:#6699CC;
						font-weight:bold;
						padding:2px;
						height:22px;
						text-align:left;
					}
					.medium_list
					{
						width:99%;
						border-collapse: collapse;
						background-color:#a7caed;
						clear:both;
						margin-bottom:10px;
					}
					.big_list_header
					{
						font-weight: bold; font-size:12px; white-space: nowrap;
					}
					.medium_list_header
					{
						font-weight: bold; font-size:12px; white-space: nowrap;
					}
					.medium_list_search
					{
						width:100%;
					}		
					.medium_list tbody tr td
					{
						color:#000000;
						height:16px;
						padding:2px;
					}
					.medium_list tbody tr:hover td
					{
						background: #FF6;
					}
					.medium_list tfoot tr
					{
						background-color:#DAEAF8;
						height:30px;
						padding:3px;
						text-align:right;
					}
					.medium_list_header{font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 12px; font-weight: bold; padding-right:1px;}
					.print_layout {
						margin-bottom:20px;
						clear:both;
					}
					table.workDevList {clear: both;background: white;border: 0;border: 1px solid #e5e5e5;}
					table.workDevList thead tr {background: #FFFFFF;}
					table.workDevList thead tr th {color: #607D8B;background: #ffffff;}
					table.workDevList tbody tr td {background: #ffffff;color: #777;}
					table.workDevList tfoot tr td {background: #ECEFF1;color: #263238;}
					.modal{ display:none; }
					.color-darkCyan{ display:none;}
					.modal-title { display:none; }
					img[class=hideable] {display: none;}
					.close{display:none;  }
					.icmal_border  	{  border-left:1px solid #AFBCC7;   		border-top:1px solid #AFBCC7;   		border-bottom:1px solid #AFBCC7;  	}  	
					.icmal_border_last_td  	{  		border-left:1px solid #AFBCC7;   		border-right:1px solid #AFBCC7;   		border-top:1px solid #AFBCC7;   		border-bottom:1px solid #AFBCC7;  	}  	
					.icmal_border_without_top  	{  		border-left:1px solid #AFBCC7;   		border-bottom:1px solid #AFBCC7;  	}  
					.icmal_border_last_td_without_top  	{  		border-left:1px solid #AFBCC7;  		border-right:1px solid #AFBCC7;  		border-bottom:1px solid #AFBCC7;  	}
                </style>
                <cfset attributes.icerik = replaceList(attributes.icerik,'//documents,\/documents,\\documents','/documents,/documents,/documents')>
                <cfif attributes.icerik contains '/CFIDE'>
                    <cfset attributes.icerik = replace(attributes.icerik,'/CFIDE','CFIDE','all')>
                </cfif>
                <cfif attributes.icerik contains ' class="big_list"'>
                    <cfset attributes.icerik = replace(attributes.icerik,'class="big_list"','width="100%" cellpadding="5" class="color-border" style="border:solid 1px ##6699CC;"','all')>
				</cfif>
				<cfif attributes.icerik contains ' class="workDevList"'>
                    <cfset attributes.icerik = replace(attributes.icerik,'class="big_list"','width="100%" cellpadding="5" class="color-border" style="border:solid 1px ##e5e5e5;"','all')>
                </cfif>
                <cfif attributes.icerik contains ' class="medium_list"'>
                    <cfset attributes.icerik = replace(attributes.icerik,'class="medium_list"','width="100%" cellpadding="5" class="color-border" style="border:solid 1px ##6699CC;"','all')>
				</cfif>
                <cfif attributes.icerik contains ' class="detail_basket_list"'>
                    <cfset attributes.icerik = replace(attributes.icerik,'class="detail_basket_list"','cellpadding="5" class="color-border" style="border:solid 1px ##6699CC;"','all')>
                </cfif>             
                <cfif attributes.icerik contains 'style=text-align: right; mso-number-format: "0.00";'>
                    <cfset attributes.icerik = replace(attributes.icerik,'style=text-align: right; mso-number-format: "0.00";','style="text-align: right;"','all')>
                </cfif>
                <cfif attributes.icerik contains ' src="/documents/'>
					<cfset attributes.icerik = Replace(attributes.icerik,' src="/documents/',' src="#listFirst(fusebox.server_machine_list)#/documents/','all')>
                </cfif>
				<cfif isdefined("pdf_header")>
                    <cfdocumentitem type="header"><table cellpadding="0" cellspacing="0"><tr><td><cfoutput>#session.ep.company# (#session.ep.period_year#) - #dateformat(now(),dateformat_style)#</cfoutput></td></tr></table></cfdocumentitem>
                </cfif>
				<cfoutput><div class="print_layout">#replace(attributes.icerik,"<br/><br/>","<br/><font></font><br/>","ALL")#</div></cfoutput>
			</cfif>	
		</cfdocument>
	</cfif>
</cfif>
<cfcatch>
	<script language="javascript">
		alert("<cf_get_lang dictionary_id='60061.Pdf e Dönüştürme İşleminde Sorun Oluştu'>, <cf_get_lang dictionary_id='34563.Lütfen Daha Sonra Tekrar Deneyiniz'>!");
		window.close();
	</script>
	<cfabort>
</cfcatch>
</cftry>
<cfset attributes.icerik = ''>

<cfif isdefined("attributes.is_related_asset")>
	<cfinclude template="../query/add_flash_paper_asset.cfm">
</cfif>
