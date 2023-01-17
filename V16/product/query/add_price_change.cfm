<cf_date tarih="form.startdate">
<cfset form.startdate = date_add("h", form.start_clock, form.startdate)>
<cfset form.startdate = date_add("n", form.start_min, form.startdate)>
<cfif (not isDefined("attributes.price_cat_list")) or (NOT len(attributes.price_cat_list))>
	<script type="text/javascript">
	alert("<cf_get_lang no ='872.Fiyat Listesi Seçiniz'>!");
	history.back();
	</script>
	<cfabort>
</cfif>
<cfset attributes.rounding = 0>
<cfset price_cat_arr=ListToArray(attributes.price_cat_list,",")>
<cfquery name="GET_MAX_CHANGE_ID" datasource="#DSN3#">
	SELECT
		MAX(SAME_CHANGE_ID) AS SAME_ID
	FROM
		PRICE_CHANGE
</cfquery>
<cfif GET_MAX_CHANGE_ID.RECORDCOUNT AND len(GET_MAX_CHANGE_ID.SAME_ID)>
	<cfset MAX_ID=GET_MAX_CHANGE_ID.SAME_ID+1>	
<cfelse>
	<cfset MAX_ID=1>	
</cfif>
<cfloop from="1" to="#arraylen(price_cat_arr)#" index="i">
	<cfset attributes.price_catid = price_cat_arr[i]>
	<cfset is_kdv_f = 0>
	<cfif isdefined("form.is_kdv") and ListFind(form.is_kdv, attributes.price_catid, ",")>
		<cfset is_kdv_f = 1>
	</cfif>
	<cfif attributes.price_catid eq "-1">
		<cfset end_price = attributes.price_minus_1>
		<cfset gelen_money = attributes.money_minus_1>
		<cfset end_price_with_kdv = end_price+((end_price*attributes.alis_kdv)/100)>
		<cfset end_price_without_kdv = (end_price*100)/(attributes.alis_kdv+100)>
	<cfelseif attributes.price_catid eq "-2">
		<cfset end_price = attributes.price_minus_2>
		<cfset gelen_money = attributes.money_minus_2>
		<cfset end_price_with_kdv = end_price+((end_price*attributes.satis_kdv)/100)>
		<cfset end_price_without_kdv = (end_price*100)/(attributes.satis_kdv+100)>
	<cfelse>
		<cfset end_price = evaluate('attributes.price_#ListGetAt(attributes.price_cat_list,i)#')>
		<cfset gelen_money = evaluate('attributes.money_#ListGetAt(attributes.price_cat_list,i)#')>
		<cfset end_price_with_kdv = end_price+((end_price*attributes.satis_kdv)/100)>
		<cfset end_price_without_kdv = (end_price*100)/(attributes.satis_kdv+100)>
	</cfif>
	<cfquery name="ADD_PRICE" datasource="#dsn3#">
 		INSERT INTO 
			PRICE_CHANGE 
            (
                PRICE_STATUS,
                PRICE_CATID,
                PRODUCT_ID,
                STARTDATE,
                PRICE,
                PRICE_KDV,
                IS_KDV,
                ROUNDING,
                MONEY,
                UNIT,
                REASON,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,
                SAME_CHANGE_ID
             )					 
			VALUES 
            (
                1,
                #attributes.PRICE_CATID#,
                #FORM.PID#,
                #FORM.STARTDATE#,
            <cfif is_kdv_f>
                #end_price_without_kdv#,
                #end_price#,
            <cfelse>
                #end_price#,
                #end_price_with_kdv#,
            </cfif>
                #is_kdv_f#,
                #ATTRIBUTES.ROUNDING#,
                '#gelen_money#',
                #FORM.UNIT_ID#,
                '#FORM.REASON#',
                #NOW()#,
                #SESSION.EP.USERID#,
                '#CGI.REMOTE_ADDR#',
                #MAX_ID#					
            )
     </cfquery>
</cfloop>
<script type="text/javascript">
	location.href = document.referrer;
	window.close();
</script>
