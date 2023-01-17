<cfif recordcount.recct>
	<!--- INSTANT MESSAGE ICON ve LINK ENTEGRASYONU | MG 20101130 --->
	<cfobject component="/V16/WMO/GeneralFunctions" name="GnlFunctions">

	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.totalrecords" default="#get_hrs.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>		
		<cfset employee_list = ''>
		<!---<cfset im_cats = ''>--->
		<cfset main_employee_list = ''>
			<cfoutput query="get_hrs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset employee_list = listappend(employee_list,get_hrs.employee_id,',')>
				<!---<cfif len(IMCAT_ID)>
					<cfset im_cats = listappend(im_cats,IMCAT_ID)>
				</cfif>
				<cfif len(IMCAT2_ID)>
					<cfset im_cats = listappend(im_cats,IMCAT2_ID)>
				</cfif>--->
			</cfoutput>
		<!---<cfif listlen(im_cats)>
			<cfquery name="get_ims" datasource="#DSN#">
				SELECT IMCAT_ICON,IMCAT_LINK_TYPE,IMCAT_ID FROM SETUP_IM WHERE IMCAT_ID IN (#im_cats#)
			</cfquery>
			<cfset im_cats = listsort(listdeleteduplicates(valuelist(get_ims.IMCAT_ID,',')),'numeric','ASC',',')>
		</cfif>	--->
		<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
		<cfquery name="GET_IN_OUTS" datasource="#dsn#">
			SELECT
				START_DATE,
				FINISH_DATE,
				IN_OUT_ID,
				EMPLOYEE_ID
			FROM
				EMPLOYEES_IN_OUT
			WHERE
				EMPLOYEE_ID IN (#employee_list#)
				<cfif not session.ep.ehesap>AND BRANCH_ID IN (#my_branch_list#)</cfif>
		</cfquery>
		<cfif attributes.ana_query neq 1>
			<cfquery name="GET_POSITIONS" datasource="#dsn#">
				SELECT
					DEPARTMENT.DEPARTMENT_HEAD,
					EMPLOYEE_POSITIONS.EMPLOYEE_ID,
					EMPLOYEE_POSITIONS.POSITION_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_ID,
					SETUP_POSITION_CAT.POSITION_CAT
				FROM
					EMPLOYEE_POSITIONS,
					DEPARTMENT,
					SETUP_POSITION_CAT
				WHERE
					SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID AND
					EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
					EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND 
					EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#employee_list#) AND
					EMPLOYEE_POSITIONS.IS_MASTER = 1
				ORDER BY
					EMPLOYEE_POSITIONS.EMPLOYEE_ID
			</cfquery>
			<cfset main_employee_list = listsort(listdeleteduplicates(valuelist(GET_POSITIONS.EMPLOYEE_ID,',')),'numeric','ASC',',')>
		</cfif>
				
<cfform name="Form1" action="submit.cfm"> 
    <cfgrid name="employee_grid" selectmode="single" format="html"> 
      	<cfgridcolumn name="online" header="" width="40">
		<cfgridcolumn name="no" header="No" width="70">
		<cfgridcolumn name="photo" header="" width="45">
		<cfgridcolumn name="name" header="Adı"> 
        <cfgridcolumn name="surname" header="Soyadı">
		<cfoutput query="get_hrs">
			<cfsavecontent variable="coloum_online"><CF_ONLINE id="#employee_id#" zone="ep"></cfsavecontent>
			<cfsavecontent variable="photo_">
				<cfif len(GET_HRS.photo) and len(GET_HRS.PHOTO_SERVER_ID)>
					<cf_get_server_file output_file="hr/#photo#" output_server="#PHOTO_SERVER_ID#" output_type="0" image_width="30" image_height="40" image_link="0">
				<cfelse>
					<cfif GET_HRS.sex eq 1>
						<img src="/images/male.jpg" width="30" height="40" title="<cf_get_lang_main no='1134.Yok'>">
					<cfelse>
						<img src="/images/female.jpg" width="30" height="40" title="<cf_get_lang_main no='1134.Yok'>">
					</cfif>
				</cfif>
			</cfsavecontent>
			<cfsavecontent variable="emp_name_"><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#employee_name#</a></cfsavecontent>
			<cfsavecontent variable="emp_surname_"><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#employee_surname#</a></cfsavecontent>
			<cfgridrow data ="#coloum_online#,#employee_no#,#photo_#,#emp_name_#,#emp_surname_#">
		</cfoutput>
    </cfgrid> 
</cfform>
<cfelse>
	<cf_box style="width:98%;"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cf_box>
</cfif>
