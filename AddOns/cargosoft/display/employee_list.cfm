<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default="1">

<cfquery name="get_drivers" datasource="#dsn#">
	SELECT 
		*,
		ISNULL(
		(
		SELECT
			USERID
		FROM
			WRK_SESSION 
		WHERE
        	USERID = EMPLOYEES.EMPLOYEE_ID
			AND USER_TYPE = 0
		),0) AS ONLINE
	FROM 
		EMPLOYEES 
	WHERE 
		OZEL_KOD2 = '#attributes.ozel_kod2#' AND
		EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_drivers.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>

<div class="cargo_div_right">
	<input type="button" value="Add a driver" class="cargo_button">
</div>

<table width="100%">
<tr>
<td>
<cfform name="employees" action="#request.self#?fuseaction=#url.fuseaction#">
	<cfoutput>
		<div>
			<input type="text" name="keyword" value="#attributes.keyword#" maxlength="50" class="cargo_input">
			<span class="floating-label">Your email address</span>
		</div>
	</cfoutput>
</cfform>
</td>
<td style="text-align:right;">
	<a href="javascript://" onclick="windowopen('/index.cfm?fuseaction=objects.popup_send_print','small');"><span class="icon-print"></span></a>
	&nbsp;
	<span class="icon-settings"></span>
</td>
</tr>
</table>
<br>
<table id="biglist" class="cargo_table" cellspacing="0">
	<thead>
		<tr>
			<th width="75"><cfoutput>#attributes.list_page_id_header#</cfoutput></th>
			<th>FIRST / LAST NAME</th>
			<th width="100">PHONE</th>
			<th width="125">EMAIL</th>
			<th width="50">STATUS</th>
			<th width="50" class="noborder">ACTION</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_drivers">
		<tr>
			<td>#employee_id#</td>
			<td>#employee_name# #employee_surname#</td>
			<td><cfif len(MOBILCODE)>(#MOBILCODE#)</cfif> #MOBILTEL#</td>
			<td>#employee_email#</td>
			<td><cfif ONLINE gt 0><span class="green">Online</span><cfelse><span class="red">Offline</span></cfif></td>
			<td class="noborder"><a href="index.cfm?fuseaction=cargosoft.upd_driver&driver_id=#employee_id#" class="cargo_link">edit <span class="fa fa-chevron-down" style="color:##000000;"><span></a></td>
		</tr>
		</cfoutput>
	</tbody>
</table>


<cfset url_str = "&keyword=#attributes.keyword#">
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#url.fuseaction##url_str#">