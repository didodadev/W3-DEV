<cfsetting showdebugoutput="no">
<div id='show_list_page'>
<cfquery name="GET_COMMENT_ASSET" datasource="#DSN#">
	SELECT 
		COMMENTS.RECORD_EMP,
		COMMENTS.RECORD_PAR,
		COMMENTS.RECORD_PUB,
		COMMENTS.RECORD_DATE,
		COMMENTS.BODY
	FROM 
		COMMENTS
	WHERE 
		TYPE_ID = 1 AND 
		RELATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.video_id#">
	ORDER BY 
		RECORD_DATE DESC
</cfquery>
<cfif get_comment_asset.recordcount>
	<cfset record_emp_list=''>
	<cfset record_par_list=''>
	<cfset record_cons_list=''>
	<cfoutput query="get_comment_asset">
		<cfif len(record_emp) and not listfind(record_emp_list,record_emp)>
			<cfset record_emp_list = listappend(record_emp_list,record_emp)>
		</cfif>
		<cfif len(record_par) and not listfind(record_par_list,record_par)>
			<cfset record_par_list = listappend(record_par_list,record_par)>
		</cfif>
		<cfif len(record_pub) and not listfind(record_cons_list,record_pub)>
			<cfset record_cons_list = listappend(record_cons_list,record_pub)>
		</cfif>
	</cfoutput>
	<cfif len(record_emp_list)>
		<cfset record_emp_list=listsort(record_emp_list,"numeric","ASC",",")>
		<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
			SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_emp_list#)
		</cfquery>
		<cfset record_emp_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
	</cfif> 
	<cfif len(record_par_list)>
		<cfset record_par_list=listsort(record_par_list,"numeric","ASC",",")>
		<cfquery name="GET_PARTNER" datasource="#DSN#">
			SELECT PARTNER_ID,COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#record_par_list#)
		</cfquery>
		<cfset record_par_list = listsort(listdeleteduplicates(valuelist(get_partner.partner_id,',')),'numeric','ASC',',')>
	</cfif> 
	<cfif len(record_cons_list)>
		<cfset record_cons_list=listsort(record_cons_list,"numeric","ASC",",")>
		<cfquery name="GET_CONSUMER" datasource="#DSN#">
			SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#record_cons_list#)
		</cfquery>
		<cfset record_cons_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
	</cfif> 
</cfif>

<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
    <tr style="height:30px;">
		<td colspan="2"><a onClick="gizle_goster(my_add_comment);" style="cursor:pointer;" class="tableyazi">
			<b>Videoya yorum yapmak için tiklayiniz...<b>
			</a>
		</td>
	</tr>
	<tr style="display:none;" id="my_add_comment">
		<td colspan="2"><cfinclude template="add_video_comment.cfm"></td>
	</tr>
  	<cfoutput query="get_comment_asset">
	  	<tr class="color-row">
			<td><b>
				<cfif len(record_emp)>
                    #get_employee.employee_name[listfind(record_emp_list,record_emp,',')]# #get_employee.employee_surname[listfind(record_emp_list,record_emp,',')]#
                <cfelseif len(record_par)>
                    #get_partner.company_partner_name[listfind(record_par_list,record_par,',')]# #get_partner.company_partner_surname[listfind(record_par_list,record_par,',')]#
                <cfelseif len(record_pub)>
                    #get_consumer.consumer_name[listfind(record_cons_list,record_pub,',')]# #get_consumer.consumer_surname[listfind(record_cons_list,record_pub,',')]#
                </cfif>
                </b>&nbsp;
                (#record_date#)
                  <br/><br />
                  #body#
                  <br /><br />
			</td>
	  	</tr>
  	</cfoutput>
</table>
</div>
