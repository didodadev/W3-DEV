<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="get_cheque_no" returntype="any" output="false">
	<!---
	by :  20040109
	notes : sadece belge_tipi verirsek bize ilgili numarayı döndürür ama aynı anda belge_no da verirsek bu durumda
			güncelleme yapar ve true döndürür...Fonksiyon sorunsuz çalistiginda true veya belge no döndürür.
	önemli : bu fonksiyon mutlaka bir transaction arasındaki kodlar içine konmalı yada transaction yoksa yazılmalı. 

	usage :
	get_cheque_no
		(
		belge_tipi : payroll:çek bordro no,cheque: çek no,voucher_payroll:senet bodro no,voucher:senet no
		belge_no : bir numara alınmış ve arttırılmış ise artmış hali verilir, db güncellenir,
		);
	<cfset belge_no = get_cheque_no(belge_tipi:'payroll')>
	.....işlemler yaptim ve sonunda yine
	<cfset belge_no = get_cheque_no(belge_tipi:'payroll',belge_no:belge_no+1)> diyerek noyu kaldiğim yerde biraktim.
	revisions : 
	--->
	<cfargument name="belge_tipi" required="true" type="any">
	<cfargument name="belge_no" type="numeric">
	<cfif isDefined('arguments.belge_no') and len(arguments.belge_no)>
		<cfquery name="UPDATE_ACTION_NO_" datasource="#dsn2#">
			UPDATE #dsn3_alias#.PAPERS_NO_CHEQUE SET 
				<cfif arguments.belge_tipi is 'payroll'>PAYROLL_NUMBER=#arguments.belge_no#</cfif>
				<cfif arguments.belge_tipi is 'cheque'>CHEQUE_NUMBER=#arguments.belge_no#</cfif>
				<cfif arguments.belge_tipi is 'voucher_payroll'>VOUCHER_PAYROLL_NUMBER=#arguments.belge_no#</cfif>
				<cfif arguments.belge_tipi is 'voucher'>VOUCHER_NUMBER=#arguments.belge_no#</cfif>
		</cfquery>
		<cfreturn true>
	<cfelse>
		<cfquery name="GET_ACTION_NO_" datasource="#dsn2#">
			SELECT 
				<cfif arguments.belge_tipi is 'payroll'>PAYROLL_NUMBER</cfif>
				<cfif arguments.belge_tipi is 'cheque'>CHEQUE_NUMBER</cfif>
				<cfif arguments.belge_tipi is 'voucher_payroll'>VOUCHER_PAYROLL_NUMBER</cfif>
				<cfif arguments.belge_tipi is 'voucher'>VOUCHER_NUMBER</cfif>
				AS BELGE_NUMBER
			FROM
				#dsn3_alias#.PAPERS_NO_CHEQUE 
		</cfquery>
		<cfreturn GET_ACTION_NO_.BELGE_NUMBER>
	</cfif>	
</cffunction>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
