<cf_date tarih="form.startdate">
<cfset form.startdate = date_add("h", form.start_clock, form.startdate)>
<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='862.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı'>...<cf_get_lang no ='863.Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.opener.location.href='<cfoutput>#request.self#?fuseaction=product.list_price_change</cfoutput>';
		<cfif not isDefined('attributes.draggable') or attributes.draggable eq 1>
			window.close();
		</cfif>
	</script>
	<cfabort>
</cfif>
<cfif form.active_year neq session.ep.period_year>
	<cfif ((form.active_year gte 2005) and (session.ep.period_year lte 2004)) or ((form.active_year lte 2004) and (session.ep.period_year gte 2005))>
		<script type="text/javascript">
			alert("İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı...Muhasebe Döneminizi Kontrol Ediniz!");
			window.opener.location.href='<cfoutput>#request.self#?fuseaction=store.prices</cfoutput>';
			<cfif not isDefined('attributes.draggable') or attributes.draggable eq 1>
			window.close();
		</cfif>
		</script>
	<cfabort>
	</cfif>
</cfif>
<cfset form.startdate = date_add("n", form.start_min, form.startdate)>
<cfif (not isDefined("attributes.price_cat_list")) or (NOT len(attributes.price_cat_list))>
	<script type="text/javascript">
	alert("<cf_get_lang no ='872.Fiyat Listesi Seçiniz'>!");
	history.back();
	</script>
	<cfabort>
</cfif>
<cfset price_cat_arr=ListToArray(attributes.price_cat_list,",")>
<cfif not isdefined("form.valid")>
	<cfquery name="GET_PRICE_CHANGE_OLD" datasource="#DSN3#" maxrows="1">
		SELECT
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		FROM
			PRICE_CHANGE
		WHERE
			PRICE_CHANGE_ID = #ATTRIBUTES.PRICE_CHANGE_ID#
		<cfif isdefined("ATTRIBUTES.SAME_CHANGE_ID") and len(ATTRIBUTES.SAME_CHANGE_ID)>
			OR
			SAME_CHANGE_ID = #ATTRIBUTES.SAME_CHANGE_ID#
		</cfif>
	</cfquery>
	<cfif isdefined("ATTRIBUTES.SAME_CHANGE_ID") and len(ATTRIBUTES.SAME_CHANGE_ID)>
		<cfquery name="del_old_rows" datasource="#dsn3#">
			DELETE FROM PRICE_CHANGE WHERE SAME_CHANGE_ID = #ATTRIBUTES.SAME_CHANGE_ID#
		</cfquery>
	</cfif>
	<cfquery name="del_old_rows" datasource="#dsn3#">
		DELETE FROM PRICE_CHANGE WHERE PRICE_CHANGE_ID = #ATTRIBUTES.PRICE_CHANGE_ID#
	</cfquery>
	
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
					UPDATE_DATE,
					UPDATE_EMP,
					UPDATE_IP,
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
					#CreateODBCDateTime(GET_PRICE_CHANGE_OLD.record_date)#,
					#GET_PRICE_CHANGE_OLD.record_emp#,
					'#GET_PRICE_CHANGE_OLD.record_ip#',
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#MAX_ID#					
				)
		</cfquery>
	</cfloop>
	<script type="text/javascript">
		<cfif attributes.draggable eq 1>
			location.href = document.referrer;
		<cfelse>
			wrk_opener_reload();
			window.close();
		</cfif>
	</script>
<cfelse>
	<cfquery name="upd_validation" datasource="#dsn3#">
		UPDATE
			PRICE_CHANGE
		SET
			IS_VALID = <cfif isdefined("form.valid") and len(form.valid)>#form.valid#<cfelse>NULL</cfif>,
			VALID_EMP = #session.ep.userid#,
			VALID_DATE = #now()#
		WHERE
			PRICE_CHANGE_ID = #attributes.price_change_id#
		<cfif isdefined("attributes.same_change_id") and len(attributes.same_change_id)>
			OR SAME_CHANGE_ID = #attributes.same_change_id#
		</cfif>
	</cfquery>
	<cfif FORM.VALID eq 1>
		<cfset pass_dates = 1>
		<cfinclude template="add_price.cfm">
	<cfelse>
		<script type="text/javascript">
			<cfif attributes.draggable eq 1>
				location.href = document.referrer;
			<cfelse>
				wrk_opener_reload();
				window.close();
			</cfif>
		</script>
	</cfif>
</cfif>
