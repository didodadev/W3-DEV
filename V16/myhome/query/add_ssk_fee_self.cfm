<cfif isdefined("attributes.workcheck") and isdefined("attributes.ILLNESS")>
  <script type="text/javascript">
    alert("<cf_get_lang no ='1222.İş Kazası veya Meslek Hastalığından Birini Seçiniz'> !");
	history.back();
  </script>
  <cfexit method="exittemplate">
</cfif>

<cfif len(attributes.DATE)>
	<cf_date tarih="attributes.DATE">
</cfif>
<cfif len(attributes.DATEOUT)>
	<cf_date tarih="attributes.DATEOUT">
</cfif>
<cfif isdefined("attributes.DATEEVENT") and len(attributes.DATEEVENT)>
	<cf_date tarih="attributes.DATEEVENT">
</cfif>

<cfif not len(attributes.in_out_id)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1223.Çalışanın Giriş Çıkış Kaydı Bulunamadı'>!");
		history.back();
	</script>
	<cfabort>
</cfif>


<cfquery name="get_in_out" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = #attributes.in_out_id#
</cfquery>

<cfif not get_in_out.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1224.Çalışanın Seçilen Şube İçin Giriş Çıkış Kaydı Bulunamadı'>!");
		history.back();
	</script>
	<cfabort>
</cfif>


<cfquery name="ADD_SSK_FEE" datasource="#DSN#">
	INSERT INTO EMPLOYEES_SSK_FEE
		(
		EMPLOYEE_ID,
		IN_OUT_ID,
		FEE_DATE,
		FEE_HOUR,
		FEE_DATEOUT,
		FEE_HOUROUT,
	<cfif isdefined("attributes.VALIDATOR_POS_CODE") and len(attributes.VALIDATOR_POS_CODE)>
		VALIDATOR_POS_CODE_1,
	<cfelse>
		VALID_1,
		VALID_EMP_1,
		VALID_DATE_1,
	</cfif>
	<cfif isdefined("attributes.VALIDATOR_POS_CODE2") and len(attributes.VALIDATOR_POS_CODE2)>
		VALIDATOR_POS_CODE_2,
	<cfelse>
		VALID_2,
		VALID_EMP_2,
		VALID_DATE_2,
	</cfif>
	<cfif isdefined("attributes.workcheck")>
		ACCIDENT,
		<cfif len(attributes.TOTAL_EMP)>
		TOTAL_EMP,
		</cfif>
		EMP_WORK,
		EVENT,
		PLACE,
		ACCIDENT_TYPE_ID,
		ACCIDENT_SECURITY_ID,
		<cfif len(attributes.DATEEVENT)>
		EVENT_DATE,
		</cfif>
		EVENT_HOUR,
		EVENT_MIN,
		WORKSTART,
		WITNESS1,
		WITNESS2,
	<cfelse>
		ACCIDENT,
	</cfif>
		ILLNESS,
	<cfif LEN(FORM.DETAIL)>
		DETAIL,
	</cfif>
		BRANCH_ID,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
		)
	VALUES
		(
		#attributes.EMPLOYEE_ID#,
		#attributes.IN_OUT_ID#,
		#attributes.DATE#,
		#attributes.HOUR#,
		#attributes.DATEOUT#,
		#attributes.HOUROUT#,
	<cfif isdefined("attributes.VALIDATOR_POS_CODE") and len(attributes.VALIDATOR_POS_CODE)>
		#ATTRIBUTES.VALIDATOR_POS_CODE#,
	<cfelse>
		1,
		#session.ep.userid#,
		#now()#,
	</cfif>
	<cfif isdefined("attributes.VALIDATOR_POS_CODE2") and len(attributes.VALIDATOR_POS_CODE2)>
		#ATTRIBUTES.VALIDATOR_POS_CODE2#,
	<cfelse>
		1,
		#session.ep.userid#,
		#now()#,
	</cfif>
	<cfif isdefined("attributes.workcheck")>
		1,
		<cfif len(attributes.TOTAL_EMP)>
		#attributes.total_emp#,
		</cfif>
		'#attributes.emp_work#',
		'#attributes.EVENT#',
		'#attributes.PLACE#',
		<cfif isdefined("attributes.ACCIDENT_TYPE_ID") and len(attributes.ACCIDENT_TYPE_ID)>
		#attributes.ACCIDENT_TYPE_ID#,
		<cfelse>
		NULL,
		</cfif>
		<cfif isdefined("attributes.ACCIDENT_SECURITY_ID") and len(attributes.ACCIDENT_SECURITY_ID)>
		#attributes.ACCIDENT_SECURITY_ID#,
		<cfelse>
		NULL,
		</cfif>
		<cfif len(attributes.DATEEVENT)>
		#attributes.DATEEVENT#,
		</cfif>
		#attributes.HOUREVENT#,
		'#attributes.EVENT_MIN#',
		'#attributes.workstart#',
		'#attributes.witness1#',
		'#attributes.witness2#',
	<cfelse>
		0,
	</cfif>
	<cfif isDefined("attributes.ILLNESS")>
		1,
	<cfelse>
		0,
	</cfif>
	<cfif LEN(FORM.DETAIL)>
		'#FORM.DETAIL#',
	</cfif>
		#get_in_out.BRANCH_ID#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#
		)
</cfquery>	

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
