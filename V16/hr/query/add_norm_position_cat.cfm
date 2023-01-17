<cfloop from="1" to="#attributes.dept_count#" index="dept_no">
	<cfloop list="#attributes.position_cat_id_list#" index="position_cat_id_">
		<cfif isdefined("attributes.ongorulen_#position_cat_id_#_1_#dept_no#")>
				<cfquery name="control" datasource="#dsn#">
					SELECT POSITION_CAT_ID FROM EMPLOYEE_NORM_POSITIONS WHERE BRANCH_ID = #attributes.BRANCH_ID# AND NORM_YEAR = #attributes.sal_year# AND POSITION_CAT_ID = #position_cat_id_#
				</cfquery>
				<cfif control.recordcount>
					<cfquery name="upd_" datasource="#dsn#">
						UPDATE
							EMPLOYEE_NORM_POSITIONS
						SET
							<cfset count = 0>
							<cfloop from="1" to="12" index="i">
								EMPLOYEE_COUNT#i# = #evaluate("attributes.ongorulen_#position_cat_id_#_#i#_#dept_no#")#,
							</cfloop>
							DETAIL = '#evaluate("attributes.detail_#position_cat_id_#")#',
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.REMOTE_ADDR#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							BRANCH_ID = #attributes.BRANCH_ID# AND 
							NORM_YEAR = #attributes.sal_year# AND 
							POSITION_CAT_ID = #position_cat_id_#
					</cfquery>
				<cfelse>
					<cfquery datasource="#DSN#">
						INSERT INTO EMPLOYEE_NORM_POSITIONS
							(
								BRANCH_ID,
								DETAIL,
								POSITION_CAT_ID, 
								EMPLOYEE_COUNT1, 
								EMPLOYEE_COUNT2, 
								EMPLOYEE_COUNT3, 
								EMPLOYEE_COUNT4, 
								EMPLOYEE_COUNT5, 
								EMPLOYEE_COUNT6, 
								EMPLOYEE_COUNT7, 
								EMPLOYEE_COUNT8, 
								EMPLOYEE_COUNT9, 
								EMPLOYEE_COUNT10, 
								EMPLOYEE_COUNT11, 
								EMPLOYEE_COUNT12,
								NORM_YEAR,
								RECORD_EMP,
								RECORD_DATE,
								RECORD_IP
							)
							VALUES
							(
								#attributes.BRANCH_ID#,
								'#evaluate("attributes.detail_#position_cat_id_#")#',
								#position_cat_id_#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_1_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_2_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_3_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_4_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_5_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_6_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_7_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_8_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_9_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_10_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_11_#dept_no#")#,
								#evaluate("attributes.ongorulen_#position_cat_id_#_12_#dept_no#")#,
								#attributes.sal_year#,
								#session.ep.userid#,
								#now()#,
								'#cgi.REMOTE_ADDR#'
							)
					</cfquery>
				</cfif>
		</cfif>
	</cfloop>
</cfloop>
<cflocation url="#request.self#?fuseaction=hr.list_norm_position_dispersal&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&branch_id=#attributes.branch_id#&position_cat_type=#attributes.position_cat_type#&position_cat_id=#attributes.position_cat_id#&is_form_submit=1" addtoken="No">
