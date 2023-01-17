<cfif isdefined('attributes.age') and len(attributes.age)>
	<cfset birthdate = #dateformat(date_add('yyyy',-attributes.age,now()),dateformat_style)#>
	<cf_date tarih = "birthdate">
</cfif>
<cfquery name="GET_OLD_CONSUMER" datasource="#dsn#">
	SELECT 
		CONSUMER_NAME,
		CONSUMER_SURNAME 
	FROM
		CONSUMER
	WHERE
		CONSUMER_NAME = '#attributes.consumer_name#' AND
		CONSUMER_SURNAME = '#attributes.consumer_surname#' AND
		CONSUMER_HOMETELCODE = '#attributes.consumer_hometelcode#' AND
		CONSUMER_HOMETEL = '#attributes.consumer_hometel#'
</cfquery>
<cfif not get_old_consumer.recordcount>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>		
		<cfquery name="ADD_CONSUMER" datasource="#DSN#">
			INSERT INTO
				CONSUMER
			 (						
				CONSUMER_CAT_ID,
				BIRTHDATE,
				CONSUMER_HOMETEL,
				CONSUMER_HOMETELCODE,
				HOMEPOSTCODE,
				HOMESEMT,
				HOME_COUNTY_ID,
				HOME_CITY_ID,
				HOME_COUNTRY_ID,
				CONSUMER_NAME,
				CONSUMER_SURNAME,
				ISPOTANTIAL,
				SECTOR_CAT_ID,
				HOMEADDRESS,
				RECORD_DATE,
				RECORD_MEMBER,
				RECORD_IP
			)
			VALUES 	 
			(
				#attributes.consumer_cat_id#,
				<cfif isdefined("attributes.age") and len(attributes.age)>#birthdate#<cfelse>NULL</cfif>,
				<cfif len(attributes.consumer_hometel)>'#attributes.consumer_hometel#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.consumer_hometelcode")and len(attributes.consumer_hometelcode)>'#attributes.consumer_hometelcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.postcode)>'#attributes.postcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,				
				<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
				'#attributes.consumer_name#',
				'#attributes.consumer_surname#',
				1,
				<cfif len(attributes.sector_cat_id)>#attributes.sector_cat_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.homeaddress)>'#attributes.homeaddress#'<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cfquery name="GET_MAX_CONS" datasource="#DSN#">
			SELECT 
				MAX(CONSUMER_ID) AS MAX_CONS 
			FROM 
				CONSUMER
		</cfquery>
		</cftransaction>
	</cflock>
	<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
		UPDATE
			CONSUMER 
		SET
			MEMBER_CODE = 'C#GET_MAX_CONS.MAX_CONS#'
		WHERE
			CONSUMER_ID = #GET_MAX_CONS.MAX_CONS#
	</cfquery>
<!--- 	<script type="text/javascript">
		window.parent.frame_list_draw.location.reload();
		window.parent.frame_draw.location.href='<cfoutput>#request.self#?fuseaction=member.popup_form_add_draw</cfoutput>&iframe=1';
	</script> --->
	<script type="text/javascript">
		window.parent.close();
	</script>	
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='246.üye'> <cf_get_lang_main no='781.tekrarı'> !");
		history.back();
	</script>
</cfif>

