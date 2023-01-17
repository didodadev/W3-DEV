<cfset bakiye = 0 >
 <cfquery name="GET_TOTAL_ALL" DATASOURCE="#DSN2#">
	SELECT 
		SUM(AART.BAKIYE) AS BAKIYE,
		SUM(AART.BORC) AS BORC,
		SUM(AART.ALACAK) AS ALACAK,
		ACCOUNT_CODE
	FROM
	(
		SELECT
			SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
			SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
			SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
			SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2 - ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS BAKIYE_2, 
			SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2) AS BORC_2,
			SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS ALACAK_2, 
			ACCOUNT_PLAN.ACCOUNT_CODE, 
			ACCOUNT_PLAN.ACCOUNT_NAME,
			ACCOUNT_PLAN.ACCOUNT_ID,
			ACCOUNT_PLAN.IFRS_CODE, 
			ACCOUNT_PLAN.IFRS_NAME,
			ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
			ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
			ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID	
		FROM
			ACCOUNT_PLAN,
			(
				SELECT
					0 AS ALACAK,
					0 AS ALACAK_2,
					SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,			
					SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC_2,
					ACCOUNT_CARD_ROWS.ACCOUNT_ID,
					ACCOUNT_CARD.ACTION_DATE,
					ACCOUNT_CARD.CARD_TYPE,
					ACCOUNT_CARD.CARD_CAT_ID
				FROM
					<cfif attributes.table_code_type eq 0>
						ACCOUNT_CARD_ROWS
					<cfelseif attributes.table_code_type eq 1>
						ACCOUNT_ROWS_IFRS ACCOUNT_CARD_ROWS
					</cfif>
					,ACCOUNT_CARD
				WHERE
					BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
					<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
						AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
					</cfif>
					<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
						AND (
						<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
							(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
							<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
						</cfloop>  
							)
					</cfif>	
				GROUP BY
					ACCOUNT_CARD_ROWS.ACCOUNT_ID,
					ACCOUNT_CARD.ACTION_DATE,
					ACCOUNT_CARD.CARD_TYPE,
					ACCOUNT_CARD.CARD_CAT_ID
				
				UNION
				
				SELECT
					SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS ALACAK, 
					SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS ALACAK_2,
					0 AS BORC,
					0 AS BORC_2,
					ACCOUNT_CARD_ROWS.ACCOUNT_ID,
					ACCOUNT_CARD.ACTION_DATE,
					ACCOUNT_CARD.CARD_TYPE,
					ACCOUNT_CARD.CARD_CAT_ID
				FROM
					<cfif attributes.table_code_type eq 0>
						ACCOUNT_CARD_ROWS
					<cfelseif attributes.table_code_type eq 1>
						ACCOUNT_ROWS_IFRS ACCOUNT_CARD_ROWS
					</cfif>,
					ACCOUNT_CARD
				WHERE
					BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
					<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
						AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
					</cfif>
					<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
						AND (
						<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
							(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
							<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
						</cfloop>  
							)
					</cfif>	
				GROUP BY
					ACCOUNT_CARD_ROWS.ACCOUNT_ID,
					ACCOUNT_CARD.ACTION_DATE,
					ACCOUNT_CARD.CARD_TYPE,
					ACCOUNT_CARD.CARD_CAT_ID
			)ACCOUNT_ACCOUNT_REMAINDER
		WHERE
			(
				(ACCOUNT_PLAN.SUB_ACCOUNT=1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'%')
				OR
				(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
			)
			AND CARD_TYPE <> 19
		GROUP BY
			ACCOUNT_PLAN.ACCOUNT_CODE, 
			ACCOUNT_PLAN.ACCOUNT_NAME,
			ACCOUNT_PLAN.IFRS_CODE, 
			ACCOUNT_PLAN.IFRS_NAME,
			ACCOUNT_PLAN.ACCOUNT_ID, 
			ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
			ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
			ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID
	)AART
	<cfif len(attributes.search_date)>
		WHERE ACTION_DATE <= #attributes.search_date#
	</cfif>		
	GROUP BY ACCOUNT_CODE
</cfquery>
<cfif GET_FUND_FLOW.RECORDCOUNT>
	<cfset "_1_borc" = 0 >
	<cfset "_1_alacak" = 0 >
	<cfset "_1_bakiye" = 0 >
	<cfset say = 0 >
	<cfset bakiye = 0 >
	<cfset borc = 0 >
	<cfset alacak = 0 >
	<input type="hidden" name="count" id="count" value="<cfoutput>#GET_FUND_FLOW.recordcount#</cfoutput>">
	<cfset array_len = GET_FUND_FLOW.recordcount>
	<cfset all_code = ValueList(GET_FUND_FLOW.CODE) >
	<cfset all_code_a = ListToArray(all_code)>
	<cfset all_acc_code = ValueList(GET_FUND_FLOW.ACCOUNT_CODE,",")>
	<cfset all_acc_code_a = ListToArray(all_acc_code)>
	<cfset all_code_sign = ValueList(GET_FUND_FLOW.SIGN,",") >
	<cfset all_code_sign_a = ListToArray(all_code_sign)>
	<cfset all_view = ValueList(GET_FUND_FLOW.VIEW_AMOUNT_TYPE,",") >
	<cfset all_view_a = ListToArray(all_view)>

		<cfloop  from="#array_len#" to="1" step="-1" index="i">
			<cfset "general_total#i#"=0>
			<cfif all_acc_code_a[i] neq "bos">
					<cfset aranan_=all_acc_code_a[i]>
			<cfelse>
				<cfset "_#i#_borc" = 0 >
				<cfset "_#i#_alacak" = 0 >
				<cfset "_#i#_bakiye" = 0 >	
			</cfif>					
			<cfif isdefined('aranan_') >
				 <cfquery name="GET_TOTAL" dbtype="query">
					SELECT 
						SUM(BAKIYE) AS BAKIYE,
						SUM(BORC) AS BORC,
						SUM(ALACAK) AS ALACAK
					FROM
						GET_TOTAL_ALL
					WHERE 
						ACCOUNT_CODE LIKE '#aranan_#'
				</cfquery>
				<cfif get_total.bakiye is "">
					<cfset add1=0>
				<cfelse>
					<cfset add1=abs(get_total.bakiye)>
				</cfif>
				<cfset bakiye_total1=abs(add1)>
				<cfif get_total.borc is "">
					<cfset add_b=0>
				<cfelse>
					<cfset add_b=abs(get_total.borc)>
				</cfif>
				<cfset borc=abs(add_b)>
				<cfif get_total.alacak is "">
					<cfset add_a=0>
				<cfelse>
					<cfset add_a=abs(get_total.alacak)>
				</cfif>
				<cfset alacak=abs(add_a)>
				<cfset "_#i#_borc"=abs(borc)>
				<cfset "_#i#_alacak"=abs(alacak)>
				<cfset "_#i#_bakiye"=abs(bakiye_total1)>		
			 </cfif>
			<cfswitch expression="#all_view_a[i]#">
				<cfcase value="0">
					<cfset "general_total#i#"=Evaluate("_#i#_borc")>
				</cfcase>
				<cfcase value="1">
					<cfset "general_total#i#"=Evaluate("_#i#_alacak")>
				</cfcase>
				<cfcase value="2">
					<cfset "general_total#i#"=Evaluate("_#i#_bakiye")>
				</cfcase>
			</cfswitch>
	</cfloop> 
	<cfloop from="#array_len#" to="1" step="-1" index="currentrow">
			<cfset last_to=currentrow+1>
			<cfset kontrol_s=0>
			<cfset find_str=all_code_a[currentrow] & "." >
				<cfif ListLen(all_code_a[currentrow],".") eq 2>
					<cfloop  from="#array_len#" to="#last_to#" step="-1" index="i">
						<cfif Find(find_str,all_code_a[i]) and  ListLen(all_code_a[i],".") eq 3>
							<cfif kontrol_s eq 0>
								<cfset "_#currentrow#_borc"=0>
								<cfset "_#currentrow#_alacak"=0>
								<cfset "_#currentrow#_bakiye"=0>
								<cfset "general_total#currentrow#"=0>	
							</cfif>
							<cfif all_code_sign_a[i] eq "+" >
								<cfset "_#currentrow#_borc"=Evaluate("_#currentrow#_borc")+Evaluate("_#i#_borc")>
								<cfset "_#currentrow#_alacak"=Evaluate("_#currentrow#_alacak")+Evaluate("_#i#_alacak")>
								<cfset "_#currentrow#_bakiye"=Evaluate("_#currentrow#_bakiye")+Evaluate("_#i#_bakiye")>		
								<cfset "general_total#currentrow#"=Evaluate("general_total#currentrow#")+Evaluate("general_total#i#")>
							<cfelse>
								<cfset "_#currentrow#_borc"=Evaluate("_#currentrow#_borc")-Evaluate("_#i#_borc")>
								<cfset "_#currentrow#_alacak"=Evaluate("_#currentrow#_alacak")-Evaluate("_#i#_alacak")>
								<cfset "_#currentrow#_bakiye"=Evaluate("_#currentrow#_bakiye")-Evaluate("_#i#_bakiye")>											
								<cfset "general_total#currentrow#"=Evaluate("general_total#currentrow#")-Evaluate("general_total#i#")>
							</cfif>
							
							<cfset kontrol_s=2>
						</cfif>
					</cfloop>		
				<cfelseif not all_code_a[currentrow] contains "." >			
					<cfloop  from="#array_len#" to="#last_to#" step="-1" index="i">
						<cfif kontrol_s eq 0>
							<cfset "_#currentrow#_borc"=0>
							<cfset "_#currentrow#_alacak"=0>
							<cfset "_#currentrow#_bakiye"=0>
							<cfset "general_total#currentrow#"=0>	
						</cfif>
						<cfif Find(find_str,all_code_a[i]) and ListLen(all_code_a[i],".") eq 2>
							<cfif all_code_sign_a[i] eq "+" >
								<cfset "_#currentrow#_borc"=Evaluate("_#currentrow#_borc")+Evaluate("_#i#_borc")>
								<cfset "_#currentrow#_alacak"=Evaluate("_#currentrow#_alacak")+Evaluate("_#i#_alacak")>
								<cfset "_#currentrow#_bakiye"=Evaluate("_#currentrow#_bakiye")+Evaluate("_#i#_bakiye")>		
								<cfset kontrol_s=2>
								<cfset "general_total#currentrow#"=Evaluate("general_total#currentrow#")+Evaluate("general_total#i#")>
							<cfelse>
								<cfset "_#currentrow#_borc"=Evaluate("_#currentrow#_borc")-Evaluate("_#i#_borc")>
								<cfset "_#currentrow#_alacak"=Evaluate("_#currentrow#_alacak")-Evaluate("_#i#_alacak")>
								<cfset "_#currentrow#_bakiye"=Evaluate("_#currentrow#_bakiye")-Evaluate("_#i#_bakiye")>		
								<cfset kontrol_s=2>
								<cfset "general_total#currentrow#"=Evaluate("general_total#currentrow#")-Evaluate("general_total#i#")>
									
							</cfif>
						</cfif>
						  <cfswitch  expression="#all_code_a[currentrow]#">
							<cfcase value="A">
								<cfset g_tplm=currentrow>
								<cfset "_1_alacak"=Evaluate("_#currentrow#_alacak")>
								<cfset "_1_borc"=Evaluate("_#currentrow#_borc")>
								<cfset "_1_bakiye"=Evaluate("_#currentrow#_bakiye")>
							</cfcase>
							<cfcase value="B">
								<cfset g_tplm_2 = currentrow >
							</cfcase>
						</cfswitch>
					</cfloop>		
				</cfif>
	</cfloop>
</cfif>	
<!--- 
<cfoutput query="get_fund_flow" >
	<cfscript>
		ncode = ListChangeDelims(CODE,"_",".");
		"alacak#ncode#" = Evaluate("_#currentrow#_alacak")/attributes.rate;
		"borc#ncode#" = Evaluate("_#currentrow#_borc")/attributes.rate;
		"bakiye#ncode#" = Evaluate("_#currentrow#_bakiye")/attributes.rate;
	</cfscript>
</cfoutput> --->
