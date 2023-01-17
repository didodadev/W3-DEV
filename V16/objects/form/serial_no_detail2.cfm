<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.is_del")>
<cfquery name="get_my" datasource="#dsn3#">
    SELECT 
    	GUARANTY_ID,
        SERIAL_NO,
        SG.STOCK_ID,
        S.PRODUCT_NAME 
    FROM 
    	SERVICE_GUARANTY_NEW SG ,STOCKS S
    WHERE 
    	S.STOCK_ID = SG.STOCK_ID
    	AND PROCESS_CAT IN (110,76,77,82,84,114,115,171,811) 
    	AND SERIAL_NO NOT IN (SELECT S2.SERIAL_NO FROM SERVICE_GUARANTY_NEW S2 WHERE S2.IS_SALE = 1 
    	AND S2.SERIAL_NO = SERIAL_NO) AND SERIAL_NO = '#attributes.seri_no#'
</cfquery>
<script type="text/javascript">
<cfoutput>
document.all.speedSeriDiv.style.display= 'block';
document.all.icerik.innerHTML = '<cfloop  query="#get_my#"><a class="tableyazi" onclick="sec(#STOCK_ID#)">#PRODUCT_NAME#</a><br /></cfloop>';		
/*document.getElementById('icerik').innerHTML = "<a onclick="+alert(my_s_query.STOCK_ID)+" href=''>"+my_s_query.PRODUCT_NAME+"</a>";
alert(my_s_query.PRODUCT_NAME);*/
function sec(stock_id)
{
	add_settings('#attributes.amount#',stock_id,'#attributes.ust_seri#','#attributes.spect_id#','#attributes.seri_no#','#attributes.ust_seri#');
	document.all.speedSeriDiv.style.display= 'none';
	}
</cfoutput>
</script>
<cfelse>
    <cfquery name="get_my_serial" datasource="#dsn3#">
        SELECT 
            GUARANTY_ID,
            SERIAL_NO,
            SG.STOCK_ID,
            S.PRODUCT_NAME 
        FROM 
            SERVICE_GUARANTY_NEW SG ,STOCKS S
        WHERE 
            S.STOCK_ID = SG.STOCK_ID
            AND PROCESS_CAT = 111
            AND S.STOCK_ID IN (#attributes.stock_list#)
            AND SERIAL_NO = '#attributes.seri_no#'
    </cfquery>
    <script type="text/javascript">
	<cfoutput>
		document.all.speedSeriDivDel.style.display= 'block';
		document.all.icerik2.innerHTML = '<cfloop  query="#get_my_serial#"><a class="tableyazi" onclick="sec2(#STOCK_ID#)">#PRODUCT_NAME#</a><br /></cfloop>';		
		function sec2(stock_id){
			adres_ = '#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action&action_type=del&process_cat=111&process_id=#attributes.process_id#&process_no=#attributes.process_no#&main_process_no=#attributes.main_process_no#&main_process_id=#attributes.main_process_id#&main_process_cat=#attributes.main_process_cat#&main_serial_no=#attributes.main_serial_no#&serial_no=#attributes.seri_no#&stock_id='+stock_id;
			AjaxPageLoad(adres_,'action_div',1);
			document.all.speedSeriDivDel.style.display= 'none';
		}
	</cfoutput>
	</script>
</cfif>
