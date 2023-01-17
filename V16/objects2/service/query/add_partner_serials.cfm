<cfloop from="1" to="#attributes.input_count#" index="i">
	<cfset this_serial_no_ = evaluate("attributes.seri_no_#i#")>
	<cfset this_lot_no_ = evaluate("attributes.lot_no_#i#")>
	<cfif len(this_serial_no_) and len(this_lot_no_)>
		<cfquery name="GET_EXITS" datasource="#DSN3#">
			SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_serial_no_#"> AND LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_lot_no_#">
		</cfquery>
		<cfif not get_exits.recordcount>
			<script type="text/javascript">
				alert('Girdiğiniz Barkod İçin Çıkış Kaydı Bulunamadı! Barkod: <cfoutput>#this_serial_no_#</cfoutput>');
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfquery name="GET_INS" datasource="#DSN3#">
			SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW_RETURNS WHERE SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_serial_no_#"> AND LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_lot_no_#">
		</cfquery>
		<cfif get_ins.recordcount>
			<script type="text/javascript">
				alert('Bu barkod daha önce sisteme girilmiştir.\nTekrar Giriş Yapamazsınız! Barkod: <cfoutput>#this_serial_no_#</cfoutput>');
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfloop>

<cfloop from="1" to="#attributes.input_count#" index="i">
	<cfset this_serial_no_ = evaluate("attributes.seri_no_#i#")>
	<cfset this_lot_no_ = evaluate("attributes.lot_no_#i#")>
	<cfif len(this_serial_no_) and len(this_lot_no_)>
		<cfquery name="GET_STOCK" datasource="#DSN3#" maxrows="1">
			SELECT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_serial_no_#"> AND LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this_lot_no_#">
		</cfquery>
		<cfset this_stock_id_ = get_stock.stock_id>
		<cfquery name="ADD_" datasource="#DSN3#">
			INSERT INTO
				SERVICE_GUARANTY_NEW_RETURNS
                (
                    PARTNER_ID,
                    SERIAL_NO,
                    LOT_NO,
                    STOCK_ID,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES
                (
                    #session.pp.userid#,
                    '#this_serial_no_#',
                    '#this_lot_no_#',
                    #this_stock_id_#,
                    #now()#,
                    '#CGI.REMOTE_ADDR#'
                )
		</cfquery>
		<cfquery name="GET_STOCK_POINT" datasource="#DSN1#">
			SELECT
				MAX_POINT_1 AS ADD_USER_POINT
			FROM
				PRODUCT_SEGMENT PS,
				STOCKS S,
				PRODUCT P
			WHERE
				S.PRODUCT_ID = P.PRODUCT_ID AND
				S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_stock_id_#"> AND
				P.SEGMENT_ID = PS.PRODUCT_SEGMENT_ID
		</cfquery>
		<cfif not get_stock_point.recordcount or not len(get_stock_point.add_user_point)>
			<script type="text/javascript">
				alert('Girdiğiniz Seri No İçin Hediye Puan Alamadınız! Seri No: <cfoutput>#this_serial_no_#</cfoutput>');
			</script>
		</cfif>
		<cfif get_stock_point.recordcount and len(get_stock_point.add_user_point)>
			<cfquery name="GET_OLD_POINTS" datasource="#DSN#">
				SELECT USER_POINT FROM COMPANY_PARTNER_POINTS WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			</cfquery>
			<cfif get_old_points.recordcount>
				<cfset new_point_ = get_old_points.user_point + get_stock_point.add_user_point>
				<cfquery name="UPD_OLD_POINTS" datasource="#DSN#">
					UPDATE COMPANY_PARTNER_POINTS SET USER_POINT = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_point_#"> WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
				</cfquery>				
			<cfelse>
				<cfset new_point_ = get_stock_point.add_user_point>
				<cfquery name="ADD_OLD_POINTS" datasource="#DSN#">
					INSERT INTO COMPANY_PARTNER_POINTS (USER_POINT,PARTNER_ID) VALUES (#new_point_#,#session.pp.userid#)
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
</cfloop>
<script type="text/javascript">
	window.location.href='<cfoutput>#cgi.HTTP_REFERER#</cfoutput>';
</script>
