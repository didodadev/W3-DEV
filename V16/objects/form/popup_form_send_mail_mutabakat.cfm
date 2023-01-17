<style>
@media print
 {
	html,body {background: white;}
	table{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
	tr{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
	td{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
}

@media screen
{
	html,body{height: 100%;width:100%;}
	table{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color: #333333;}
	tr{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}
	td{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}
}
</style>
<cfif isdefined('attributes.is_submit') and attributes.is_submit eq 1>
	<cffunction name="make_pdf" output="false">
		<cfargument name="file_name" default="pdf_file">
		<cfargument name="pdf_content" default="">
		<cfdocument format="pdf" pagetype="a4" filename="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##arguments.file_name#.pdf" marginleft="0" marginright="0" margintop="0" overwrite="yes">
			<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			<html xmlns="http://www.w3.org/1999/xhtml">
				<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<title><cf_get_lang dictionary_id='58650.Puantaj'> PDF</title>
				</head>
			<body>
				<cfoutput>#arguments.pdf_content#</cfoutput>
			</body>
		</html>
		</cfdocument>
	</cffunction>  
	<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
	<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
		<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
	</cfif>
    <cfif isdefined("attributes.keyword") and attributes.keyword is 'consumer'>
        <cfquery name="get_cari_rows" datasource="#dsn#">
        	SELECT
           		CONSUMER_EMAIL AS EMAIL,
           		CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS NAME
          	FROM
            	CONSUMER
          	WHERE
             	CONSUMER_ID = <cfqueryparam  cfsqltype="cf_sql_integer" value="#attributes.iid#">
             	AND CONSUMER_EMAIL IS NOT NULL 
             	AND CONSUMER_EMAIL <> ''
        </cfquery>
    <cfelseif isdefined("attributes.keyword") and attributes.keyword is 'partner'>
        <cfquery name="get_cari_rows" datasource="#DSN#">
       		SELECT
          		COMPANY_EMAIL AS EMAIL,
          		FULLNAME AS NAME
         	FROM
             	COMPANY	
       		WHERE
            	COMPANY_EMAIL IS NOT NULL AND
               	COMPANY_EMAIL <> ''
                AND	COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
        </cfquery>
    </cfif>
    <cfoutput query="get_cari_rows">
    	<cfsavecontent variable="mail_cont">
    		<div id="objects">
				<cfif isdefined("attributes.form_type")> 
					<cfquery name="GET_FORM" datasource="#dsn3#">
							SELECT TEMPLATE_FILE,FORM_ID,PROCESS_TYPE,IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = #attributes.form_type# ORDER BY IS_XML,NAME
						</cfquery>
						<cfif isdefined("attributes.iid") and len(attributes.iid) and GET_FORM.PROCESS_TYPE eq 10>
							<cfquery name="GET_PRINT_COUNT" datasource="#dsn2#">
								SELECT PRINT_COUNT FROM INVOICE WHERE INVOICE_ID = #attributes.iid#
							</cfquery>
							<cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
								<cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
							<cfelse>
								<cfset PRINT_COUNT = 1>
							</cfif>	
							<cfquery name="UPD_PRINT_COUNT" datasource="#dsn2#">
								UPDATE INVOICE SET PRINT_COUNT = #PRINT_COUNT#,PRINT_DATE = #now()# WHERE INVOICE_ID = #attributes.iid#
							</cfquery>
						</cfif>								
						<!--- Siparis print sayisi (stock emirler satis siparisi sayfasi print sayisini yazdirmak icin eklendi) Senay 20060704--->
						<cfif isdefined("attributes.action_id") and len(attributes.action_id) and GET_FORM.PROCESS_TYPE eq 73>
							<!--- siparis sayfalarindan alinan ciktilarin emirlerde etki yapmamasi icin eklendi FBS 20080916 --->
							<cfif isdefined("attributes.action_type") and attributes.action_type is "commands">
								<cfquery name="GET_PRINT_COUNT" datasource="#dsn3#">
									SELECT PRINT_COUNT FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
								</cfquery>
								<cfif len(get_print_count.print_count)>
									<cfset PRINT_COUNT = get_print_count.print_count + 1>
								<cfelse>
									<cfset PRINT_COUNT = 1>
								</cfif>	
								<cfquery name="UPD_PRINT_COUNT" datasource="#dsn3#">
									UPDATE ORDERS SET PRINT_COUNT = #PRINT_COUNT# WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
								</cfquery>
							</cfif>
						</cfif>
						<cfif isdefined("attributes.action_id") and len(attributes.action_id) and GET_FORM.PROCESS_TYPE eq 281>
							<cfquery name="GET_PRINT_COUNT" datasource="#dsn3#">
								SELECT PRINT_COUNT FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
							</cfquery>
							<cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
								<cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
							<cfelse>
								<cfset PRINT_COUNT = 1>
							</cfif>	
							<cfquery name="UPD_PRINT_COUNT" datasource="#dsn3#">
								UPDATE PRODUCTION_ORDERS SET PRINT_COUNT = #PRINT_COUNT# WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
							</cfquery>								
						</cfif>
						<cfif get_form.is_standart eq 1>
							<cfinclude template="/#get_form.template_file#">
						<cfelse>
							<cfif ListLast(get_form.template_file,'.') is 'xml'>
					        	<cfinclude template="print_files_xml.cfm">
							<cfelse>
								<cfinclude template="#file_web_path#settings/#get_form.template_file#">
							</cfif>
						</cfif>
					<cfelse>
						<cf_get_lang dictionary_id='32718.Otomatik Baskı Şablonu Oluşturulmamış'>!
					</cfif>
				</div>
		</cfsavecontent>
		<cfif isdefined('attributes.mail_pdf') and mail_pdf eq 1>
			<cfset filename = "#name#_Mutabakat_Mektubu">
    		#make_pdf(file_name:'#filename#',pdf_content:'#mail_cont#')#
		</cfif>
    	<cfmail from="#session.ep.company#<#session.ep.company_email#>" to="#email#" subject="Mutabakat Mektubu" type="html">
    		<cfif isdefined('attributes.mail_pdf') and mail_pdf eq 1>
    			<cfmailparam file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.pdf">
    			<cf_get_lang dictionary_id='60296.Mutabakat Mektubu ektedir'>.
    		<cfelse>
	            #mail_cont#
			</cfif>
      	</cfmail>
    </cfoutput>
    <script type="text/javascript">
		alert("<cf_get_lang dictionary_id='49454.Mail gönderilmiştir'> !");
		window.close();
	</script>
<cfelse>
	<cf_popup_box title='Mutabakat Mektubu'>
    	<cfform name="form_mail" method="post" action="#request.self#?fuseaction=objects.popup_send_mail_mutabakat&is_submit=1">
            <cfif isdefined("attributes.iid") and len(attributes.iid)>
            	<input type="hidden" name="iid" id="iid" value="<cfoutput>#attributes.iid#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            	<input type="hidden" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.form_type") and len(attributes.form_type)>
            	<input type="hidden" name="form_type" id="form_type" value="<cfoutput>#attributes.form_type#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.mail_pdf") and len(attributes.mail_pdf)>
            	<input type="hidden" name="mail_pdf" id="mail_pdf" value="<cfoutput>#attributes.mail_pdf#</cfoutput>" />
            </cfif>
        	<table>
                <tr>
                	<td width="100%">&nbsp;</td>
                    <td align="right" nowrap><cf_workcube_buttons insert_info='Mail Gönder'></td>
                </tr>
            </table>
        </cfform>
  	</cf_popup_box>
</cfif>