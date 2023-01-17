﻿<cfsetting showdebugoutput="yes">
<cfif listlen(attributes.stock_id_list)>
	<cfquery name="DELETE_PACKAGE_LIST" datasource="#DSN3#">
		DELETE EZGI_SHIPPING_PACKAGE_LIST_REPEAT WHERE SHIPPING_ID = #attributes.SHIP_ID# AND TYPE = #attributes.is_type#
	</cfquery>
	<cfloop list="#attributes.stock_id_list#" index="sid">
		<cfquery name="ADD_PACKAGE_LIST" datasource="#dsn3#">
			INSERT INTO 
			EZGI_SHIPPING_PACKAGE_LIST_REPEAT
			(
				SHIPPING_ID,
				STOCK_ID,
				AMOUNT,
				CONTROL_AMOUNT,
                CONTROL_STATUS,
                TYPE,
                RECORD_DATE,
				RECORD_EMP,
                <cfif attributes.mail_gonder gt 0>IS_MAILED,</cfif>
                SHIP_METHOD_ID
			)
			VALUES
			(
				#attributes.SHIP_ID#,
				#sid#,
				#Evaluate('attributes.amount#sid#')#,
				#Evaluate('attributes.control_amount#sid#')#,
                #kontrol_status#,
                #attributes.is_type#,
                #now()#,
				#session.pda.userid#,
                <cfif attributes.mail_gonder gt 0>#attributes.mail_gonder#,</cfif>
                <cfif len(attributes.ezgi_ship_method_id)>#attributes.ezgi_ship_method_id#<cfelse>NULL</cfif>
			)
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined('session.pda')>
	<cflocation url="#request.self#?fuseaction=pda.list_shipping_repeat&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&is_form_submitted=1&kontrol_status=#kontrol_status#" addtoken="no">  
</cfif>