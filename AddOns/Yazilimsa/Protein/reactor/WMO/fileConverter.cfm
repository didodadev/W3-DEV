<cfsetting showdebugoutput="no">
<cfif not isdefined("wrk_content_clear")>
	<cfinclude template="/objects/functions/get_wrk_content_clear.cfm">
</cfif>
<cfsavecontent variable="attributes.icerik"><cfoutput>#pageDetail#</cfoutput></cfsavecontent>
<cfif listfindnocase('1,2,3',attributes.action_type)>
	<cfset attributes.icerik = wrk_content_clear(attributes.icerik)>
    <cfif isdefined("session.ep.userid")>
		<cfset filename = "#fusebox.fuseaction#_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')##session.ep.userid#">
	<cfelse>
		<cfset filename = "#fusebox.fuseaction#_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')#">
	</cfif>	
    <cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
	<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
		<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
	</cfif>
	<cfdirectory action="list" name="get_ds" directory="#upload_folder#reserve_files">
    <cfif get_ds.recordcount>
    	<cfoutput query="get_ds">
        	<cfif type is 'dir' and name is not drc_name_>
                <cftry>
                    <cfset d_name_ = name>
                    <cfdirectory action="list" name="get_ds_ic" directory="#upload_folder#reserve_files#dir_seperator##d_name_#">
                        <cfif get_ds_ic.recordcount>
                            <cfloop query="get_ds_ic">
                                <cffile action="delete" file="#upload_folder#reserve_files#dir_seperator##d_name_##dir_seperator##get_ds_ic.name#">
                            </cfloop>
                        </cfif>
                    <cfdirectory action="delete" directory="#upload_folder#reserve_files#dir_seperator##d_name_#">
                <cfcatch></cfcatch>
                </cftry>
            </cfif>
        </cfoutput>
    </cfif>
</cfif>
<cfif attributes.action_type eq 1>
	<cffile action="write" file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.xls" output="#attributes.icerik#" charset="utf-16"/>
	<cfif isdefined("attributes.is_auto_excel")>
		<script type="text/javascript">
			window.get_wrk_message_div("<cf_get_lang_main no='1931.Dosya İndir'>","<cf_get_lang_main no='1934.Excel'>","<cfoutput>/documents/reserve_files/#drc_name_#/#filename#.xls</cfoutput>");
		</script>
	<cfelse>
		<cfheader name="Content-Disposition" value="attachment;filename=#filename#.xls">
		<cfcontent file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.xls" type="application/octet-stream" deletefile="no">      
	</cfif>
<cfelseif attributes.action_type eq 2>
    <cffile action="write" file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.doc" output="#attributes.icerik#" charset="utf-16"/>
	<script type="text/javascript">
		window.get_wrk_message_div("<cf_get_lang_main no='1931.Dosya İndir'>","<cf_get_lang_main no='1935.Word'>","<cfoutput>/documents/reserve_files/#drc_name_#/#filename#.doc</cfoutput>");
	</script>
<cfelseif attributes.action_type eq 3>
<cfif isdefined("is_pdf_header") and is_pdf_header eq 1 and isdefined("session.ep")>
	<cfset pdf_margintop = 0.15>
<cfelse>
	<cfset pdf_margintop = 0>
</cfif>
	<cfdocument format="pdf" pagetype="a4" filename="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.pdf" marginleft="0" marginright="0" margintop="#pdf_margintop#">
		<style type="text/css">
			table{font-size:8px; font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:#333;width:100%;}
			tr{font-size:10px;}
			th{font-size:10px;}
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
					padding:2px;
					height:auto;
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
				font-weight: bold; font-size:12px;
			}
			.medium_list thead tr th
				{
					
					background-color:#DAEAF8;
					color:#6699CC;
					font-weight:bold;
					padding:2px;
					height:22px;
				}
			.medium_list tbody tr td
				{
					color:#000000;
					background-color:#FFF;
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
		</style>
		<cfif isdefined("is_pdf_header") and is_pdf_header eq 1 and isdefined("session.ep")>
			<cfdocumentitem type="header"><table><tr><td><cfoutput>#session.ep.COMPANY# (#session.ep.period_year#) - #dateformat(now(),'dd/mm/yyyy')#</cfoutput></td></tr></table></cfdocumentitem>
		</cfif>
        
		<cfif attributes.icerik contains ' class="big_list"'>
            <cfset attributes.icerik = replace(attributes.icerik,' class="big_list"',' cellspacing="0" cellpadding="2" class="color-border" style="border:solid 1px ##6699CC; width:100%;"','all')>
        </cfif>
		<cfif attributes.icerik contains ' class="medium_list"'>
            <cfset attributes.icerik = replace(attributes.icerik,' class="big_list"','width="100%" class="color-border" style="border:solid 1px ##6699CC;"','all')>
        </cfif>
		<cfoutput>#attributes.icerik#</cfoutput>
    </cfdocument>
	<script type="text/javascript">
		window.get_wrk_message_div("<cf_get_lang_main no='1931.Dosya İndir'>","<cf_get_lang_main no='1936.Pdf'>","<cfoutput>/documents/reserve_files/#drc_name_#/#filename#.pdf</cfoutput>");
	</script>
<cfelseif attributes.action_type eq 4>
	<cfoutput>
        <div id="action_page_div" style="display:none;">#attributes.icerik#</div>
        <script type="text/javascript">
            window.windowopen('#request.self#?fuseaction=objects.popup_mail&module=action_page_div&trail=1&special_module=1','list','popup_mail');
			gizle(working_div_main);
            //top.geri_al_working();
        </script>
    </cfoutput>
	<cfabort>
<cfelseif attributes.action_type eq 5>
	<cfoutput>
		<cfset attributes.icerik = wrk_content_clear(attributes.icerik)>
		<div id="action_page_div" style="display:none;">#attributes.icerik#</div>
		<script type="text/javascript">
			window.windowopen('#request.self#?fuseaction=objects.popup_send_print&module=action_page_div&trail=1&special_module=1&iframe=1','small','popup_send_print');
			gizle(working_div_main);
		</script>
    </cfoutput>
</cfif>
