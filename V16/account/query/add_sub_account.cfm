<cfquery name="CHECK" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		ACCOUNT_PLAN
	WHERE 
		ACCOUNT_CODE = '#ACCOUNT_CODE#.#SUB_ACCOUNT_CODE#'
</cfquery>

<cfif check.recordcount>
	<script type="text/javascript">
		alert("Bu Hesap Kodu Başka Bir Hesap Tarafından Kullanılıyor.Lütfen Kontrol Ediniz !");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfquery name="GET_CHECK" datasource="#DSN2#">
		SELECT
			*
		FROM
			ACCOUNT_CARD_ROWS
		WHERE 
			ACCOUNT_ID='#ACCOUNT_CODE#'	
	</cfquery>
	
	<cfif GET_CHECK.RECORDCOUNT>
		<script type="text/javascript">
			alert("Üst Hesap ile daha önce İşlem yapılmış.Hesabı Başka Bir hesaba aktarınız !");
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cfset list="',""">
		<cfset list2=" , ">
		<cfset ACCOUNT_CODE = replacelist(ACCOUNT_CODE,list,list2)>
		<cfset SUB_ACCOUNT_CODE = replacelist(SUB_ACCOUNT_CODE,list,list2)>	
		<cfquery name="ADD_ACCOUNT" datasource="#dsn2#">
			INSERT INTO 
				ACCOUNT_PLAN 
				(
					ACCOUNT_CODE,
					ACCOUNT_NAME,
					SUB_ACCOUNT,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				)	
			VALUES 
				(
					'#ACCOUNT_CODE#.#SUB_ACCOUNT_CODE#',
					'#SUB_ACCOUNT_NAME#',
					0,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#now()#
				)
		</cfquery>
		<cfquery name="UPD_MAIN_ACCOUNT" datasource="#dsn2#">
			UPDATE 
				ACCOUNT_PLAN 
			SET
				SUB_ACCOUNT = 1,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #now()#
			WHERE
				ACCOUNT_CODE = '#ACCOUNT_CODE#'
		</cfquery>
	</cfif>
</cfif>
<cfif  isdefined('attributes.no_ref') and  LEN(no_ref)>
	<script type="text/javascript">
		window.close();
	</script>
	<cfabort>
<cfelse>
	<script type="text/javascript">
		/*wrk_opener_reload();*/
		window.close();
	</script>
	<cfabort>
</cfif>

