<cfinclude template="get_fund_table_setup.cfm">
<cfset select_list="">
<cfoutput>
	<cfloop from="1" to="#attributes.count#" index="i">
		<cfif isdefined("attributes.selected#i#")>
			<cfset select_list=listappend(select_list,evaluate("selected#i#"))>
		</cfif>
	</cfloop>
</cfoutput>
<cfif get_setup.recordcount>
	<cfif isdefined('attributes.listele')>
		<cfquery name="UPD_INFO_DSP" datasource="#DSN2#">
			UPDATE 
				SETUP_FUND_TABLE_LIST
			SET
				DISPLAYS = '#attributes.listele#'
		</cfquery>
	</cfif>
<cfelse>
	<cfif isdefined('attributes.listele')>
		<cfquery name="ADD_INFO_DSP" datasource="#DSN2#">
			INSERT INTO
				SETUP_FUND_TABLE_LIST
			(
				ID,
				DISPLAYS
			)
			VALUES
			(	
				1,
				'#attributes.listele#'
			)
		</cfquery>
	</cfif>
</cfif>

<!--- alan isimleri ve acc kodlari güncellenecek--->
<cfloop from="1" to="#attributes.count#" index="i">
	<cfset acc=evaluate("change_account#i#")>
	<cfset id=evaluate("FUND_FLOW_ID#i#")>
	<cfset name=evaluate("change_name#i#")>
	<cfif isdefined("bakiye#i#")>
		<cfset bakiye=evaluate("bakiye#i#")>
	<cfelse>
		<cfset bakiye="">
	</cfif>
	<cfif isdefined("sign#i#")>
		<cfset sign=evaluate("sign#i#")>
	<cfelse>
		<cfset sign="">
	</cfif>
	<cfif isdefined("view_amount_type#i#")>
		<cfset view_amount_type=evaluate("view_amount_type#i#")>
	<cfelse>
		<cfset view_amount_type=2>
	</cfif>
	<cfquery name="UPD_FUND_FLOW_TABLE" DATASOURCE="#DSN2#" TIMEOUT="3">
		UPDATE
			FUND_FLOW_TABLE
		SET
			<cfif not len(ACC)>ACCOUNT_CODE = NULL,<cfelse>ACCOUNT_CODE = '#ACC#',</cfif>
			<cfif len(BAKIYE) >BA = #BAKIYE#,</cfif>
			<cfif len(SIGN)>SIGN = '#SIGN#',</cfif>		
			NAME = '#NAME#',
			VIEW_AMOUNT_TYPE = #VIEW_AMOUNT_TYPE#,
			NAME_LANG_NO = <cfif isdefined("change_name_lang_no_#i#") and len(evaluate("change_name_lang_no_#i#"))>#evaluate("change_name_lang_no_#i#")#<cfelse>NULL</cfif>
		WHERE
			FUND_FLOW_ID = #ID#
	</cfquery>
</cfloop>
<cfquery name="GET_FORMER_DEF" datasource="#dsn2#">
	SELECT
		DEF_ID
	FROM
		ACCOUNT_DEFINITIONS
	WHERE
		DEF_TYPE_ID=11
</cfquery>
<cfset def_id=get_former_def.DEF_ID>
<cfif def_id is "">
	<cfquery name="ADD_DEF" datasource="#dsn2#">
		INSERT INTO
			ACCOUNT_DEFINITIONS
		(
			DEF_TYPE_ID,
			DEF_TYPE_NAME,
			DEF_SELECTED_ROWS,
			DEF_FORM_TABLE,
			INVERSE_REMAINDER
		)
		VALUES
		(
			11,
			'FON AKIM TABLOSU TANIMLARI',
			'#SELECT_LIST#',
			'CASH_FLOW_TABLE',
			<cfif isDefined("ISINVERSEOK") AND ISINVERSEOK EQ 1>
			#ISINVERSEOK#
			<cfelse>
			0
			</cfif>
		)
	</cfquery>
<cfelse>
	<cfquery name="UPD_DEF" datasource="#dsn2#">
		UPDATE
			ACCOUNT_DEFINITIONS
		SET
			DEF_SELECTED_ROWS = '#SELECT_LIST#',
			INVERSE_REMAINDER = <cfif isDefined("ISINVERSEOK") AND ISINVERSEOK EQ 1>#ISINVERSEOK#<cfelse>0</cfif>
		WHERE
			DEF_ID = #DEF_ID#			
	</cfquery>
</cfif>
<script type="text/javascript">
	window.location.href = "<cfoutput>#cgi.referer#</cfoutput>";
</script>
