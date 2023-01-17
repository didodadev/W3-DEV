<cfquery name="get_class" datasource="#dsn#">
	SELECT 
		START_DATE,
		FINISH_DATE,
		MAX_SELF_SERVICE,
		MAX_PARTICIPATION
	FROM 
		TRAINING_CLASS
	WHERE 
		CLASS_ID = #attributes.CLASS_ID#
</cfquery>
<cfquery name="get_class_quato" datasource="#dsn#">
	SELECT 
		IS_SELFSERVICE
	FROM 
		TRAINING_CLASS_ATTENDER 
	WHERE 
		CLASS_ID = #attributes.CLASS_ID# AND
		IS_SELFSERVICE = 0
</cfquery>
<cfquery name="get_class_quota_self" datasource="#dsn#">
	SELECT 
		IS_SELFSERVICE
	FROM 
		TRAINING_CLASS_ATTENDER 
	WHERE 
		CLASS_ID = #attributes.CLASS_ID# AND
		IS_SELFSERVICE = 1
</cfquery>
<cfset kota = (get_class_quato.recordcount+get_class_quota_self.recordcount)>
<cfif (get_class_quota_self.recordcount gte get_class.MAX_SELF_SERVICE) or (kota gte get_class.MAX_PARTICIPATION)>
	<script type="text/javascript">
		alert("Eğitim için belirlenen kontenjan dolmuştur.");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif isdefined('session.pp')>
	<cfquery name="get_class_par_att" datasource="#dsn#">
		SELECT 
			TRAINING_CLASS.START_DATE ,
			TRAINING_CLASS.FINISH_DATE,
			TRAINING_CLASS.CLASS_ID
		FROM
			TRAINING_CLASS,
			TRAINING_CLASS_ATTENDER 
		WHERE 
			TRAINING_CLASS_ATTENDER.CLASS_ID=TRAINING_CLASS.CLASS_ID 
			AND TRAINING_CLASS_ATTENDER.PAR_ID = #session.pp.userid#
			AND
			 (
			   (
				  TRAINING_CLASS.START_DATE >= #CreateODBCDateTime(get_class.START_DATE)# AND
				  TRAINING_CLASS.START_DATE < #CreateODBCDateTime(get_class.FINISH_DATE)#
				)
				  OR
				(
				  TRAINING_CLASS.FINISH_DATE >= #CreateODBCDateTime(get_class.START_DATE)# AND
				  TRAINING_CLASS.FINISH_DATE < #CreateODBCDateTime(get_class.FINISH_DATE)#
				) 
			 )
	</cfquery>
	<cfif get_class_par_att.recordcount>
		<cfif get_class_par_att.CLASS_ID neq attributes.CLASS_ID>
			<script type="text/javascript">
				alert("<cfoutput>#session.pp.name# #session.pp.surname#</cfoutput> <cf_get_lang no ='518.Bu tarihler arasında başka bir eğitimde katılımcıdır'>");
				window.close();
			</script>
			<cfabort>
		<cfelse>
			<script type="text/javascript">
				alert("<cfoutput>#session.pp.name# #session.pp.surname#</cfoutput> <cf_get_lang no ='519.Seçtiğiniz eğitime zaten katılımcıdır'>");
				window.close();
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#dsn#">
		SELECT PAR_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = #attributes.CLASS_ID# AND PAR_ID = #session.pp.userid#
	</cfquery>
	<cfif not GET_CLASS_POTENTIAL_ATTENDER.RECORDCOUNT>
		<cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#dsn#">
			INSERT INTO
				TRAINING_CLASS_ATTENDER
				(
				CLASS_ID,
				PAR_ID,
				IS_SELFSERVICE	
				)
			VALUES
				(
				#attributes.CLASS_ID#,
				#session.pp.userid#,
				1
				)
		</cfquery>
	</cfif>
</cfif>
<cfquery name="upd_class" datasource="#DSN#">
  UPDATE 
    TRAINING_CLASS_ATTENDER
  SET
    STATUS = 1
  WHERE
     CLASS_ID = #URL.CLASS_ID# AND
	 PAR_ID = #SESSION.PP.USERID#
</cfquery>
<script type="text/javascript">
 wrk_opener_reload();
 window.close();
</script>
