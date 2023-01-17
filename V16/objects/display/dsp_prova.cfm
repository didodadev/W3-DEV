<body bgcolor="#FFFFFF" text="#000000">
<cfif fusebox.fuseaction contains "popup_dsp_coupon_temp">
	<cfswitch expression="#template_id#">
		<cfcase value="1">
			<cfinclude template="template/coupon_temp1.cfm">
		</cfcase>

		<cfcase value="2">
			<cfinclude template="template/coupon_temp2.cfm">
		</cfcase>

		<cfcase value="3">
			<cfinclude template="template/coupon_temp3.cfm">
		</cfcase>

	</cfswitch>
</cfif>
