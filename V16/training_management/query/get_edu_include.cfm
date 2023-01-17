<cfset attributes.tarih_egitim = CreateODBCDatetime('#yil#-#ay#-#gun#')>
<cfset attributes.tarih_egitim_for_query = dateformat(attributes.tarih_egitim,dateformat_style)>
<cfinclude template="../query/get_todays_trainings.cfm">
<cfloop  query="get_tr">
		<cfif NOT LEN(get_tr.FINISH_DATE[currentrow]) and NOT LEN(get_tr.START_DATE[currentrow])>
			<cfset color_="000000" >	
		<cfelse>
			<cfset	compare_tarih=dateformat(get_tr.FINISH_DATE[currentrow],"yyyy-mm-dd")>
			<cfset	start_tarih=dateformat(get_tr.START_DATE[currentrow],"yyyy-mm-dd")>
			<cfif start_tarih eq tarih_bugun or compare_tarih eq tarih_bugun or 
				(start_tarih LT tarih_bugun and compare_tarih GT tarih_bugun )>
				<cfset color_="FF0000" >
			<cfelse>
				<cfset color_="000000" >
			</cfif>
		</cfif>																										
	<cfoutput>	
		<a href="#request.self#?fuseaction=training_management.form_upd_class&class_id=#get_tr.CLASS_ID#" >
			<font  color="#color_#">
				#timeformat(date_add('h',session.ep.time_zone,get_tr.start_date),timeformat_style)#-#get_tr.CLASS_NAME#
			</font>
		</a><br/>							
	</cfoutput>
</cfloop>

