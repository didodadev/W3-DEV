<cfif not len(serial_no)>
	<script type="text/javascript">
		alert("Ürün seri baş. no giriniz !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif not attributes.serial_no is '#attributes.old_seri_no#'>
	<cfquery name="get_" datasource="#dsn3#">
		SELECT GUARANTY_ID FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO = '#attributes.serial_no#' AND STOCK_ID = #attributes.stock_id#
	</cfquery>
	<cfif get_.recordcount>
		<script type="text/javascript">
			alert('Bu Seri No Kullanılmaktadır!');
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfif len(attributes.guarantycat_id)>
	<cfquery name="get_guaranty_time_" datasource="#dsn#">
		SELECT (SELECT GUARANTYCAT_TIME FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = #attributes.guarantycat_id#
	</cfquery>
</cfif>

<cfif len(attributes.sale_guarantycat_id)>
	<cfquery name="get_sale_guaranty_time_" datasource="#dsn#">
		SELECT (SELECT GUARANTYCAT_TIME FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = #attributes.sale_guarantycat_id#
	</cfquery>
</cfif>

<cfif len(attributes.start_date)>
	<cf_date tarih= "attributes.start_date">
    <cfif get_guaranty_time_.recordcount and len(get_guaranty_time_.GUARANTYCAT_TIME)>
		<cfset finish_date = date_add("m",get_guaranty_time_.GUARANTYCAT_TIME,attributes.start_date)>
	<cfelse>
		<cf_date tarih= "attributes.finish_date">
		<cfset finish_date = attributes.finish_date>
    </cfif>
</cfif>
<cfif len(attributes.sale_start_date)>
	<cf_date tarih= "attributes.sale_start_date">
    <cfif get_sale_guaranty_time_.recordcount and len(get_sale_guaranty_time_.GUARANTYCAT_TIME)>
		<cfset sale_finish_date = date_add("m",get_sale_guaranty_time_.GUARANTYCAT_TIME,attributes.sale_start_date)>
	<cfelse>
		<cf_date tarih= "attributes.sale_finish_date">
		<cfset sale_finish_date = attributes.sale_finish_date>
    </cfif>
</cfif>


<cfquery name="update_seri_no" datasource="#dsn3#">
	UPDATE 
		SERVICE_GUARANTY_NEW 
	SET 
		IN_OUT = <cfif isdefined("attributes.in_out") and len(attributes.in_out)>1<cfelse>0</cfif>,
		IS_PURCHASE = <cfif isdefined("attributes.is_purchase_sales") and len(attributes.is_purchase_sales) and (attributes.is_purchase_sales eq 0)>1<cfelse>0</cfif>, 
		IS_SALE = <cfif isdefined("attributes.is_purchase_sales") and len(attributes.is_purchase_sales) and (attributes.is_purchase_sales eq 1)>1<cfelse>0</cfif>,
		IS_RETURN = <cfif isdefined("attributes.is_return") and len(attributes.is_return)>1<cfelse>0</cfif>,
		IS_RMA = <cfif isdefined("attributes.is_rma") and len(attributes.is_rma)>1<cfelse>0</cfif>,
		IS_SERVICE = <cfif isdefined("attributes.is_service") and len(attributes.is_service)>1<cfelse>0</cfif>,
		IS_TRASH = <cfif isdefined("attributes.is_trash") and len(attributes.is_trash)>1<cfelse>0</cfif>,
		STOCK_ID = #attributes.stock_id#,
		SERIAL_NO = '#attributes.serial_no#',
		LOT_NO = <cfif len(attributes.lot_no)>#attributes.lot_no#<cfelse>NULL</cfif>,
		DEPARTMENT_ID = #attributes.department_id#,
		LOCATION_ID = #attributes.location_id#,
		PURCHASE_GUARANTY_CATID = <cfif len(attributes.guarantycat_id)>#attributes.guarantycat_id#<cfelse>NULL</cfif>,
		PURCHASE_START_DATE = <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
		PURCHASE_FINISH_DATE = <cfif len(finish_date)>#finish_date#<cfelse>NULL</cfif>,
		SALE_GUARANTY_CATID = <cfif len(attributes.sale_guarantycat_id)>#attributes.sale_guarantycat_id#<cfelse>NULL</cfif>,
		SALE_START_DATE = <cfif len(attributes.sale_start_date)>#attributes.sale_start_date#<cfelse>NULL</cfif>,
		SALE_FINISH_DATE = <cfif len(sale_finish_date)>#sale_finish_date#<cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		GUARANTY_ID = #attributes.guaranty_id#
</cfquery>

<script type="text/javascript">
	location.href= document.referrer;
</script>
