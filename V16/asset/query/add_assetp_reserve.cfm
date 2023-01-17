<cfinclude template="upd_date_values.cfm">
<cfinclude template="get_check.cfm">
<cfif check_1.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='184.Lütfen Varlık Teslim Tarihinden Sonra Rezervasyon Yapınız'> !");
		history.back();
	</script>
	<cfabort>
<cfelseif check.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='30.Bu Aralıkta Kaynak Rezervasyon Çakışması Var !'>");
		history.back();
	</script>	
	<cfabort>
<cfelse>
<cfquery name="ADD_ASSETP_RESERVE" datasource="#DSN#">
	INSERT INTO 
		ASSET_P_RESERVE
			(
			ASSETP_ID,
			EVENT_ID,
			CLASS_ID,
			PROJECT_ID,	
			STARTDATE,
			FINISHDATE,
			STATUS,
		<cfif len(res_emp)>
			RES_EMP,
		</cfif>
			DETAIL,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			UPDATE_DATE,
			UPDATE_EMP,
			UPDATE_IP
			)
	VALUES
			(
			#attributes.ASSETP_ID#,
		<cfif isDefined("attributes.EVENT_ID") and len(attributes.EVENT_ID)>
			#attributes.EVENT_ID#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>
			#attributes.CLASS_ID#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isDefined("attributes.PROJECT_ID") and len(attributes.PROJECT_ID)>
			#attributes.PROJECT_ID#,
		<cfelse>
			NULL,
		</cfif>
			#FORM.STARTDATE#,
			#FORM.FINISHDATE#,
			1,
		<cfif len(res_emp)>
			#res_emp#,
		</cfif>
		<cfif len(detail)>
			'#detail#',
		<cfelse>
			NULL,
		</cfif>
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#'
			)
</cfquery>
	<!--- KAYIT BİTER --->
</cfif>
<cfif isDefined("attributes.PROJECT_ID") OR isDefined("attributes.EVENT_ID") OR isDefined("attributes.CLASS_ID")>
	<script type="text/javascript">
		<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
			location.href= document.referrer;
		<cfelse>
			opener.wrk_opener_reload();
			window.opener.close();
			window.close();
		</cfif>
	</script>
<cfelse>
	<script type="text/javascript">
		<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
			location.href= document.referrer;
		<cfelse>
			wrk_opener_reload();
			window.close();
		</cfif>
	</script>
</cfif>



