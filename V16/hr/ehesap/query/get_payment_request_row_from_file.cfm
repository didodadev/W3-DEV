<cfset kontrol_file = 0>
<cfset upload_folder_ = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#">
<cftry>
	<cffile action = "upload" 
		  fileField = "uploaded_file" 
		  destination = "#upload_folder_#"
		  nameConflict = "MakeUnique"  
		  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#">	
	<!---Script dosyalarını engelle  02092010 ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder_##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>	
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder_##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
	<cfcatch type="Any">
		<cfset kontrol_file = 1>
	</cfcatch>
</cftry>
<cfoutput>#kontrol_file# #upload_folder_#</cfoutput>
<cfif kontrol_file eq 0>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	</cfscript>
	<cfloop from="2" to="#line_count#" index="k">
		<cfscript>
			order_id_="";
			order_row_id_="";
			tc_no = trim(ListGetAt(dosya[k],1,";"));
			total = ListGetAt(dosya[k],2,";");
		</cfscript>
		<cfoutput>		
        	<cfif len(tc_no)>
            	<cfquery name="get_emp_in_out" datasource="#dsn#" maxrows="1">
                	SELECT
                    	E.EMPLOYEE_ID,
                        E.EMPLOYEE_NAME,
						E.EMPLOYEE_SURNAME,
                    	EIO.IN_OUT_ID
                   	FROM
                    	EMPLOYEES_IN_OUT EIO,
                        EMPLOYEES E,
                        EMPLOYEES_IDENTY EI
                  	WHERE
                    	E.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND
                    	EI.EMPLOYEE_ID = E.EMPLOYEE_ID
                        AND EI.TC_IDENTY_NO = '#tc_no#'
                    ORDER BY
                    	EIO.IN_OUT_ID DESC
                </cfquery>
                <cfset emp_in_out_id = get_emp_in_out.in_out_id>
                <cfset emp_id = get_emp_in_out.employee_id>
                <cfset employee = get_emp_in_out.employee_name&' '&get_emp_in_out.employee_surname>
           	<cfelse>
				<cfset emp_in_out_id = ''>
                <cfset emp_id = ''>
                <cfset employee = ''>
            </cfif>
            <cfif not len(total)><cfset total = 0></cfif>
			<script type="text/javascript">
				add_row("#emp_in_out_id#","#emp_id#","#employee#","#total#");
			</script>
		</cfoutput>
	</cfloop>	
</cfif>
