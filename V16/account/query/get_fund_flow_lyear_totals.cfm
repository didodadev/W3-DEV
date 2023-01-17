<cfset gecensene=SESSION.EP.PERIOD_YEAR-1>
<cfinclude template="../query/get_table.cfm">
<cfif GET_TABLE.RECORDCOUNT>
<!--- 	<cfset DSN_LASTYEAR="#DSN#_#gecensene#_#SESSION.EP.COMPANY_ID#"> --->
	<cfif database_type eq "MSSQL">
		<cfset DSN_LASTYEAR="#DSN#_#gecensene#_#SESSION.EP.COMPANY_ID#">
	<cfelse>
		<cfset DSN_LASTYEAR="#DSN#_#SESSION.EP.COMPANY_ID#_#RIGHT(gecensene,2)#">
	</cfif>	
	<cfquery name="GET_TOTAL_ALL" DATASOURCE="#DSN_LASTYEAR#">
		SELECT 
			SUM(BAKIYE) AS BAKIYE,
			SUM(BORC) AS BORC,
			SUM(ALACAK) AS ALACAK,
			ACCOUNT_CODE
		FROM
			ACCOUNT_ACCOUNT_REMAINDER_TOTAL AART
		GROUP BY ACCOUNT_CODE
	</cfquery>	
	<cfif GET_FUND_FLOW.RECORDCOUNT>
		<cfset "_1_borc_l"=0>
		<cfset "_1_alacak_l"=0>
		<cfset "_1_bakiye_l"=0>
		<cfset say_l=0>
		<cfset bakiye_l=0>
		<cfset borc_l=0>
		<cfset alacak_l=0>
		<input type="hidden" name="count_l" id="count_l" value="<cfoutput>#GET_FUND_FLOW.recordcount#</cfoutput>">
		<cfset array_len_l=GET_FUND_FLOW.recordcount>
		<cfset all_code_l=ValueList(GET_FUND_FLOW.CODE) >
		<cfset all_code_a_l=ListToArray(all_code_l)>
		<cfset all_acc_code_l=ValueList(GET_FUND_FLOW.ACCOUNT_CODE,",")>
		<cfset all_acc_code_a_l=ListToArray(all_acc_code_l)>
		<cfset all_code_sign_l=ValueList(GET_FUND_FLOW.SIGN,",") >
		<cfset all_code_sign_a_l=ListToArray(all_code_sign_l)>
		<cfset all_view_l=ValueList(GET_FUND_FLOW.VIEW_AMOUNT_TYPE,",") >
		<cfset all_view_a_l=ListToArray(all_view_l)>
		
		<cfloop  from="#array_len_l#" to="1" step="-1" index="i">
			<cfset "general_total_l#i#"=0>
	<!--- 	<cfoutput>#all_acc_code_a_l[i]#</cfoutput> --->
			<cfif all_acc_code_a_l[i] neq "bos">
					<cfset aranan_l="">
					<cfset aranan_l=all_acc_code_a_l[i]>
			<cfelse>
					<cfset "_#i#_borc_l"=0>
					<cfset "_#i#_alacak_l"=0>
					<cfset "_#i#_bakiye_l"=0>	
			</cfif>					
			<cfif isdefined('aranan_l') >
				<cfquery name="GET_TOTAL" dbtype="query">
					SELECT 
						SUM(BAKIYE) AS BAKIYE,
						SUM(BORC) AS BORC,
						SUM(ALACAK) AS ALACAK
					FROM
						GET_TOTAL_ALL
					WHERE 
						ACCOUNT_CODE LIKE '#aranan_l#'
				</cfquery>
				<cfif get_total.bakiye is "">
					<cfset add1_l=0>
				<cfelse>
					<cfset add1_l=get_total.bakiye>
				</cfif>
				<cfset bakiye_total1_l=abs(add1_l)>
				<cfif get_total.borc is "">
					<cfset add1_b_l=0>
				<cfelse>
					<cfset add1_b_l=abs(get_total.borc)>
				</cfif>
				<cfset borc_l=add1_b_l>
				<cfif get_total.alacak is "">
					<cfset add1_a_l=0>
				<cfelse>
					<cfset add1_a_l=abs(get_total.alacak)>
				</cfif>
				<cfset alacak_l=abs(add1_a_l)>
				<cfset "_#i#_borc_l"=abs(borc_l)>
				<cfset "_#i#_alacak_l"=abs(alacak_l)>
				<cfset "_#i#_bakiye_l"=abs(bakiye_total1_l)>		
			 </cfif>
			 <cfswitch expression="#all_view_a_l[i]#">
				<cfcase value="0">
					<cfset "general_total_l#i#"=Evaluate("_#i#_borc_l")>
				</cfcase>
				<cfcase value="1">
					<cfset "general_total_l#i#"=Evaluate("_#i#_alacak_l")>
				</cfcase>
				<cfcase value="2">
					<cfset "general_total_l#i#"=Evaluate("_#i#_bakiye_l")>
				</cfcase>
			</cfswitch>	
	</cfloop> 
	<!--- <cfabort> --->
	<cfloop from="#array_len_l#" to="1" step="-1" index="currentrow">
			<cfset last_to=currentrow+1>
			<cfset kontrol_s=0>
			<cfset find_str=all_code_a[currentrow] & "." >
				<cfif ListLen(all_code_a[currentrow],".") eq 2>
					<cfloop  from="#array_len#" to="#last_to#" step="-1" index="i">
						<cfif Find(find_str,all_code_a[i]) and  ListLen(all_code_a[i],".") eq 3>
							<cfif kontrol_s eq 0>
								<cfset "_#currentrow#_borc_l"=0>
								<cfset "_#currentrow#_alacak_l"=0>
								<cfset "_#currentrow#_bakiye_l"=0>
								<cfset "general_total_l#currentrow#"=0>
							</cfif>
							<cfif all_code_sign_a[i] eq "+" >
								<cfset "_#currentrow#_borc_l"=Evaluate("_#currentrow#_borc_l")+Evaluate("_#i#_borc_l")>
								<cfset "_#currentrow#_alacak_l"=Evaluate("_#currentrow#_alacak_l")+Evaluate("_#i#_alacak_l")>
								<cfset "_#currentrow#_bakiye_l"=Evaluate("_#currentrow#_bakiye_l")+Evaluate("_#i#_bakiye_l")>		
								<cfset "general_total_l#currentrow#"=Evaluate("general_total_l#currentrow#")+Evaluate("general_total_l#i#")>
							<cfelse>
								<cfset "_#currentrow#_borc_l"=Evaluate("_#currentrow#_borc_l")-Evaluate("_#i#_borc_l")>
								<cfset "_#currentrow#_alacak_l"=Evaluate("_#currentrow#_alacak_l")-Evaluate("_#i#_alacak_l")>
								<cfset "_#currentrow#_bakiye_l"=Evaluate("_#currentrow#_bakiye_l")-Evaluate("_#i#_bakiye_l")>											
								<cfset "general_total_l#currentrow#"=Evaluate("general_total_l#currentrow#")-Evaluate("general_total_l#i#")>		
							</cfif>
							<cfset kontrol_s=2>
						</cfif>
					</cfloop>		
				<cfelseif not all_code_a[currentrow] contains "." >				
					<cfloop  from="#array_len#" to="#last_to#" step="-1" index="i">
						<cfif kontrol_s eq 0>
							<cfset "_#currentrow#_borc_l"=0>
							<cfset "_#currentrow#_alacak_l"=0>
							<cfset "_#currentrow#_bakiye_l"=0>
							<cfset "general_total_l#currentrow#"=0>						
						</cfif>
						<cfif Find(find_str,all_code_a[i]) and ListLen(all_code_a[i],".") eq 2>
							<cfif all_code_sign_a[i] eq "+" >
								<cfset "_#currentrow#_borc_l"=Evaluate("_#currentrow#_borc_l")+Evaluate("_#i#_borc_l")>
								<cfset "_#currentrow#_alacak_l"=Evaluate("_#currentrow#_alacak_l")+Evaluate("_#i#_alacak_l")>
								<cfset "_#currentrow#_bakiye_l"=Evaluate("_#currentrow#_bakiye_l")+Evaluate("_#i#_bakiye_l")>		
								<cfset kontrol_s=2>
								<cfset "general_total_l#currentrow#"= Evaluate("general_total_l#currentrow#") + Evaluate("general_total_l#i#")>
							<cfelse>
								<cfset "_#currentrow#_borc_l"=Evaluate("_#currentrow#_borc_l")-Evaluate("_#i#_borc_l")>
								<cfset "_#currentrow#_alacak_l"=Evaluate("_#currentrow#_alacak_l")-Evaluate("_#i#_alacak_l")>
								<cfset "_#currentrow#_bakiye_l"=Evaluate("_#currentrow#_bakiye_l")-Evaluate("_#i#_bakiye_l")>		
								<cfset kontrol_s=2>
								<cfset "general_total_l#currentrow#"=Evaluate("general_total_l#currentrow#")-Evaluate("general_total_l#i#")>
							</cfif>	
						</cfif>
						  <cfswitch  expression="#all_code_a[currentrow]#">
								<cfcase value="A">
									<cfset g_tplm=currentrow>
									<cfset "_1_alacak_l"=Evaluate("_#currentrow#_alacak_l")>
									<cfset "_1_borc_l"=Evaluate("_#currentrow#_borc_l")>
									<cfset "_1_bakiye_l"=Evaluate("_#currentrow#_bakiye_l")>
								</cfcase>
								<cfcase value="B">
									<cfset g_tplm_2=currentrow>
								</cfcase>
						</cfswitch>	
					</cfloop>		
			</cfif>
		</cfloop>
 	</cfif>
</cfif>

