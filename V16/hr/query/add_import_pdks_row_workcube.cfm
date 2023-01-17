
<cfloop from="2" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset pdks_no = trim(listgetat(dosya1[i],1,';'))>
		<cfset day_ = trim(listgetat(dosya1[i],2,';'))>
		<cfset sal_mon = trim(listgetat(dosya1[i],3,';'))>
		<cfset sal_year = trim(listgetat(dosya1[i],4,';'))>
		<cfset start_hour = trim(listgetat(dosya1[i],5,';'))>
		<cfset start_min = trim(listgetat(dosya1[i],6,';'))>
		<cfset finish_hour = trim(listgetat(dosya1[i],7,';'))>
		<cfset finish_min = trim(listgetat(dosya1[i],8,';'))>
        <cfset working_type_ = trim(listgetat(dosya1[i],9,';'))>
		<cfcatch type="Any">
			<cfoutput>#i#. Satır Okuma Hatalı!<br/></cfoutput>	
			<cfset kont=0>
		</cfcatch>  
	</cftry>	
	<cftry>
		<cfquery name="get_in_out" datasource="#dsn#" maxrows="1">
			SELECT EMPLOYEE_ID,IN_OUT_ID,BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE PDKS_NUMBER = '#pdks_no#' ORDER BY FINISH_DATE DESC
		</cfquery>
		
		<cfif get_in_out.recordcount>
        <!---  pdks kayıt  --->
        <cfset pdks_working_inout_cmp = createObject("component","V16.hr.ehesap.cfc.pdks_working_inout")>

        <cfset add_pdks_day = pdks_working_inout_cmp.add_pdks_day(
            employee_id : get_in_out.employee_id,
            in_out_id : get_in_out.in_out_id,
            branch_id : get_in_out.branch_id ,
            sal_year : sal_year,
            sal_mon : sal_mon,
            day_ : day_,
            offtimecat_id : working_type_,
            start_hour : start_hour,
            finish_hour : finish_hour,
            start_min : start_min,
            finish_min : finish_min,
            file_id: attributes.i_id
        )> 
		</cfif>	
       
		<cfcatch type="Any">
			<cfoutput>#i#. Satır Yazma Hatalı! (PDKS NO)<br/></cfoutput>	
			<cfset kont=0>
            <cfabort>
		</cfcatch> 
	</cftry>
</cfloop>

