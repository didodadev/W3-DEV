<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfquery name="get_query" datasource="#dsn#">
	SELECT 
		MARCHING_MONEY_MAIN_ID
	FROM 
		MARCHING_MONEY_MAIN 
	WHERE 
		START_DATE < #DATEADD("d",1,attributes.finishdate)# AND 
		FINISH_DATE > #DATEADD("d",-1,attributes.startdate)# 
	<cfif isdefined('attributes.money_main_id')>	
		AND MARCHING_MONEY_MAIN_ID <> #attributes.money_main_id# 
	</cfif>
</cfquery>
<cfif get_query.recordcount>
		<script type="text/javascript">
			alert('Varolan tarihe tekrar tanım giremezsiniz!');
			history.back();
		</script>
		<cfabort>
</cfif>
<cfif isdefined('attributes.money_main_id')>
	<cfquery name="upd" datasource="#dsn#">
		UPDATE
			MARCHING_MONEY_MAIN
		SET
			START_DATE = #attributes.startdate#,
			FINISH_DATE = #attributes.finishdate#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#'
		WHERE
			MARCHING_MONEY_MAIN_ID = #attributes.money_main_id#
	</cfquery>
	<cfset main_id = attributes.money_main_id>
	<cfquery name="del_pos_cat" datasource="#dsn#">
		DELETE FROM MARCHING_MONEY_POSITION_CATS WHERE MARCH_MONEY_ID IN(SELECT MARCH_MONEY_ID FROM MARCHING_MONEY_FACTORS WHERE MARCHING_MONEY_MAIN_ID = #attributes.money_main_id#)
	</cfquery>
	<cfquery name="del_factor" datasource="#dsn#">
		DELETE FROM MARCHING_MONEY_FACTORS WHERE MARCHING_MONEY_MAIN_ID = #attributes.money_main_id#
	</cfquery>
<cfelse>
	<cfquery name="add_factor_main" datasource="#dsn#" result="MAIN_MAX_ID">
		INSERT INTO
			MARCHING_MONEY_MAIN
			(
				START_DATE,
				FINISH_DATE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)				
			VALUES
			(
				#attributes.startdate#,
				#attributes.finishdate#,
				#session.ep.userid#,
				#now()#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
	<cfset main_id = MAIN_MAX_ID.IDENTITYCOL>
</cfif>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol_#i#") and evaluate("attributes.row_kontrol_#i#") eq 1>
		<cfquery name="add_factor" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				MARCHING_MONEY_FACTORS
			(
				MARCHING_MONEY_MAIN_ID,
				DOMESTIC_FACTOR,
				OVERSEAS_FACTOR,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				#main_id#,
				#evaluate('DOMESTIC_FACTOR#i#')#,
				#evaluate('OVERSEAS_FACTOR#i#')#,
				#session.ep.userid#,
				#now()#,
				'#cgi.REMOTE_ADDR#'
			)
		</cfquery>
		<cfset new_march_money_id = MAX_ID.IDENTITYCOL>
		<cfif isdefined('attributes.title_ids#i#')>
			<cfloop list="#evaluate('attributes.title_ids#i#')#" index="title_id_" delimiters=",">
				<cfquery name="add_position_cat" datasource="#dsn#">
					INSERT INTO
						MARCHING_MONEY_POSITION_CATS
					(
						MARCH_MONEY_ID,
						TITLE_ID,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#new_march_money_id#,
						#title_id_#,
						#now()#,
						#session.ep.userid#,
						'#cgi.REMOTE_ADDR#'
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cfif>
</cfloop>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
