<cfquery name="SELECT_REPORT_COLUMN" datasource="#DSN#">

    select MAX(COLUMN_ID) 
	                     as columnID
	                                 from
					                         REPORT_COLUMNS

</cfquery>

<cfif SELECT_REPORT_COLUMN.columnID EQ "">

        <cfset columnID = 0>
		
<cfelse>		 

        <cfset columnID = #SELECT_REPORT_COLUMN.columnID# + 1>       

</cfif>

<cfif (form.In_Report EQ 'E') or (form.In_Report EQ 'e')>
   <cfset inReport = 1>
<cfelseif (form.In_Report EQ 'H') or (form.In_Report EQ 'h')>
   <cfset inReport = 0>
<cfelse>
   <cfset inReport = 0>   
</cfif>

<cfquery name="INSERT_REPORT_COLUMNS" datasource="#DSN#">
	INSERT INTO REPORT_COLUMNS
		(
		TABLE_ID, 
		COLUMN_NAME, 
		COLUMN_INREPORT, 
		COLUMN_NAME_TR, 
		COLUMN_NAME_EN ,
		DETAIL
		)
	values
		(
		#form.Table_ID#, 
		'#form.Field_Name#', 
		#inReport#, 
		'#form.Nick_TR#', 
		'#form.Nick_EN#',
		'#DETAIL#'
		)
</cfquery>
