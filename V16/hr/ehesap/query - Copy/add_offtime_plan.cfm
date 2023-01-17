<cfif not len(attributes.process_stage)>
Geçerli işlemi yapmak için yetkiniz yok..<cfabort>
</cfif>
<cfloop from="1" to="#attributes.record_num#" index="i">
<cfif isdefined("attributes.row_kontrol_#i#") and len(evaluate("attributes.employee_id#i#")) and evaluate("attributes.row_kontrol_#i#") eq 1>
	<cfset attributes.offtime_cat_id=evaluate("attributes.offtimecat_id#i#")>
	<cfinclude template="get_offtime_cat.cfm">
	
	<cf_date tarih="attributes.startdate#i#">
	<cfset "attributes.startdate#i#" = dateadd("h", evaluate("start_hour#i#")-session.ep.time_zone, evaluate("attributes.startdate#i#"))>
	<cfset "attributes.startdate#i#"= dateadd("n", evaluate("start_min#i#"), evaluate("attributes.startdate#i#"))>
	
	<cf_date tarih="attributes.finishdate#i#">
	<cfset "attributes.finishdate#i#" = dateadd("h", evaluate("end_hour#i#")-session.ep.time_zone, evaluate("attributes.finishdate#i#"))>
	<cfset "attributes.finishdate#i#" = dateadd("n", evaluate("end_min#i#"), evaluate("attributes.finishdate#i#"))>
	
	<cfset "attributes.work_startdate#i#" = dateadd("d",1,evaluate('attributes.finishdate#i#'))>

	<cfif isdefined("GET_OFFTIME_CAT.IS_YEARLY") and GET_OFFTIME_CAT.IS_YEARLY eq 1>
		<cfif datediff("d",evaluate("attributes.startdate#i#"),evaluate("attributes.finishdate#i#")) gt 30>
			<script type="text/javascript">
				alert('30 Günden Fazla Yıllık İzni Tek Kayıtta Giremezsiniz!');
				history.back();
				</script>
				<cfabort>
		</cfif>
		<cfif datecompare(evaluate("attributes.startdate#i#"),evaluate("attributes.finishdate#i#")) eq 1>
				<script type="text/javascript">
				alert('Tarih aralıkları yanlış!');
				history.back();
				</script>
				<cfabort>
		</cfif>
	</cfif>
</cfif>
</cfloop>

<cfset liste="">
<cftransaction>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol_#i#") and len(evaluate("attributes.employee_id#i#")) and evaluate("attributes.row_kontrol_#i#") eq 1>
		<cfif (not isdefined("attributes.startdate#i#")) or (not len(evaluate("attributes.startdate#i#"))) or (not isdate(evaluate("attributes.startdate#i#")))>
			<cfset liste=listappend(liste,'#evaluate("attributes.employee#i#")# İzin Tarihlerinde Hata Var!',',')>
		<cfelse>
			<cfset tarihim = evaluate("attributes.startdate#i#")>
			<cfset tarih2 = evaluate("attributes.finishdate#i#")>				
			<cfscript>
				attributes.employee_id = evaluate("attributes.employee_id#i#");
				attributes.employee_in_out_id = evaluate("attributes.employee_in_out_id#i#");
				attributes.work_startdate=evaluate("attributes.work_startdate#i#");
				start_hour = evaluate("attributes.start_hour#i#");
				start_min = evaluate("attributes.start_min#i#");
				end_hour = evaluate("attributes.end_hour#i#");
				end_min = evaluate("attributes.end_min#i#");
				attributes.offtime_cat_id=evaluate("attributes.offtimecat_id#i#");
				startdate_ = tarihim;
				finishdate_= tarih2;
				//startdate = dateadd('h', start_hour, startdate_);
				//startdate = dateadd('n', start_min, startdate);
				//finishdate = dateadd('h', end_hour, finishdate_);
				//finishdate = dateadd('n', end_min, finishdate);
			</cfscript>
			<cfset attributes.sal_mon = month(startdate_)>
			<cfset attributes.sal_year = year(startdate_)>
				<cfquery name="add_offtime" datasource="#dsn#">
					INSERT INTO
							OFFTIME
							(
							IN_OUT_ID,
							RECORD_IP,
							RECORD_EMP,
							RECORD_DATE,
							IS_PUANTAJ_OFF,
							EMPLOYEE_ID,
							OFFTIMECAT_ID,
							STARTDATE,
							FINISHDATE,
							WORK_STARTDATE,
							IS_PLAN,
							OFFTIME_STAGE
							)
						VALUES
							(
							#attributes.employee_in_out_id#,
							'#CGI.REMOTE_ADDR#',
							#SESSION.EP.USERID#,
							#NOW()#,
							<cfif isdefined("attributes.is_puantaj_off") and len(attributes.is_puantaj_off)>1,<cfelse>0,</cfif>
							#attributes.EMPLOYEE_ID#,
							#attributes.offtime_cat_id#,
							#startdate_#,
							#finishdate_#,
							#attributes.work_startdate#,
							1,
							<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>#attributes.process_stage#</cfif>
							)
				</cfquery>
		</cfif>
	</cfif>
</cfloop>
</cftransaction>

<cfif listlen(liste,',')>
	<cfoutput>
		<cfloop list="#liste#" index="i" delimiters=",">
			#i#<br/>
		</cfloop>
	</cfoutput>
<cfelse>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.offtimes';
	</script>
</cfif>
