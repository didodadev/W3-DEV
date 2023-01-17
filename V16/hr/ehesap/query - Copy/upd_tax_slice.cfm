<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact='ehesap.personal_payment'>
<cfif isdefined('attributes.is_delete') and attributes.is_delete eq 1>
	<cfquery name="del_tax_slice" datasource="#dsn#">
		DELETE FROM
			SETUP_TAX_SLICES
		WHERE
			TAX_SL_ID = #attributes.TAX_SL_ID#		
	</cfquery>
<cfelse>
	<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
	<cfif year(attributes.startdate) neq year(attributes.finishdate) and tax_year_control eq 1>
		<script type="text/javascript">
			alert("<cf_get_lang no='416.Girilen kaydın başlangıç ve bitiş tarihi aynı yıl içerisinde olmalıdır'>!");
			<cfif not isdefined("attributes.draggable")>
				history.back();
			<cfelseif isdefined("attributes.draggable")>
				$('#tax_box .catalyst-refresh').click();
				closeBoxDraggable( 'add_tax_box' );
			</cfif>
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_query" datasource="#dsn#">
		SELECT 
			TAX_SL_ID, 
			NAME, 
			STARTDATE, 
			FINISHDATE, 
			STATUS, 
			MIN_PAYMENT_1, 
			MAX_PAYMENT_1, 
			RATIO_1,
			MIN_PAYMENT_2, 
			MAX_PAYMENT_2, 
			RATIO_2, 
			MIN_PAYMENT_3, 
			MAX_PAYMENT_3, 
			RATIO_3, 
			MIN_PAYMENT_4, 
			MAX_PAYMENT_4, 
			RATIO_4, 
			MIN_PAYMENT_5, 
			MAX_PAYMENT_5, 
			RATIO_5, 
			MIN_PAYMENT_6,
			MAX_PAYMENT_6,
			RATIO_6, 
			UPDATE_DATE, 
			UPDATE_IP, 
			UPDATE_EMP, 
			SAKAT1, 
			SAKAT2, 
			SAKAT3, 
			SAKAT_STYLE 
		FROM 
			SETUP_TAX_SLICES
		WHERE 
			STARTDATE < #DATEADD("d",1,attributes.finishdate)#  
		AND 
			FINISHDATE > #DATEADD("d",-1,attributes.startdate)# 
		AND 
			TAX_SL_ID <> #attributes.TAX_SL_ID# 
	</cfquery>
	<cfif get_query.recordcount>
			<script type="text/javascript">
				alert('Varolan tarihe tekrar tanım giremezsiniz!');
				<cfif not isdefined("attributes.draggable")>
					history.back();
				<cfelseif isdefined("attributes.draggable")>
					$('#tax_box .catalyst-refresh').click();
					closeBoxDraggable( 'add_tax_box' );
				</cfif>
			</script>
			<cfabort>
	</cfif>
	<cfquery name="upd_olds" datasource="#dsn#">
		UPDATE SETUP_TAX_SLICES SET STATUS = 0
	</cfquery>
	<cfquery name="add_tax_slice" datasource="#dsn#">
		UPDATE
			SETUP_TAX_SLICES
		SET
			NAME = '#NAME#',
			STARTDATE = #attributes.STARTDATE#,
			FINISHDATE = #attributes.FINISHDATE#,
			MIN_PAYMENT_1 = #MIN_PAYMENT_1#,
			MAX_PAYMENT_1 = #MAX_PAYMENT_1#,
			RATIO_1 = #RATIO_1#,
			MIN_PAYMENT_2 = #MIN_PAYMENT_2#,
			MAX_PAYMENT_2 = #MAX_PAYMENT_2#,
			RATIO_2 = #RATIO_2#,
			MIN_PAYMENT_3 = #MIN_PAYMENT_3#,
			MAX_PAYMENT_3 = #MAX_PAYMENT_3#,
			RATIO_3 = #RATIO_3#,
			MIN_PAYMENT_4 = #MIN_PAYMENT_4#,
			MAX_PAYMENT_4 = #MAX_PAYMENT_4#,
			RATIO_4 = #RATIO_4#,
			MIN_PAYMENT_5 = #MIN_PAYMENT_5#,
			MAX_PAYMENT_5 = #MAX_PAYMENT_5#,
			RATIO_5 = #RATIO_5#,
			MIN_PAYMENT_6 = #MIN_PAYMENT_6#,
			MAX_PAYMENT_6 = #MAX_PAYMENT_6#,
			RATIO_6 = #RATIO_6#,
			SAKAT1 = #attributes.SAKAT1#,
			SAKAT2 = #attributes.SAKAT2#,
			SAKAT3 = #attributes.SAKAT3#,
			SAKAT_STYLE = #attributes.sakat_style#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #NOW()#
		WHERE
			TAX_SL_ID = #attributes.TAX_SL_ID#		
	</cfquery>
	<cfset attributes.actionId = attributes.tax_sl_id>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelseif isdefined("attributes.draggable")>
		$('#tax_box .catalyst-refresh').click();
		closeBoxDraggable( 'add_tax_box' );
	</cfif>
</script>