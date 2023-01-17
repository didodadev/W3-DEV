<!---örnek kart no 4093640113966652--->
<!--- sanal pos bilgileri dinamik hale getirirldi. Db den çekiliyor. FA28012011 --->
<cfif isdefined('is_iptal') and isdefined('pos_id_') and len(pos_id_)>
	<cfset pos_id = pos_id_>
<cfelse>
	<cfset pos_id = ListGetAt(attributes.action_to_account_id,4,";")>
</cfif>
<!---<cfset pos_id = "2">--->
<cfquery name="getSanalPosType" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY_POS_RELATION WHERE POS_ID = #pos_id#
</cfquery>

<cfif getSanalPosType.recordcount>
	<cfscript>
		//sanal pos sifre ve gerekli bilgileri
		pos_type = getSanalPosType.pos_type;
		pos_user_name = getSanalPosType.user_name;
		pos_user_password = getSanalPosType.password;
		pos_client_id = getSanalPosType.client_id;
		pos_terminal_no = getSanalPosType.terminal_no;
		ssl_ip = getSanalPosType.ssl_ip;
		pos_store_key = getSanalPosType.store_key;
		
		//if(getSanalPosType.is_secure eq 1 and not isdefined("session.ep")) kapatıldı PY
		if(getSanalPosType.is_secure eq 1)
			secure_3d = 1;
		else
			secure_3d = 0;
		
		if(secure_3d eq 0)
			post_adress = getSanalPosType.bank_host;
		else
			post_adress = getSanalPosType.bank_host;

		tutar = attributes.sales_credit;
		if (listfind("8,9,15",pos_type,','))//Vakıfbank,YKB,garanti,ziraat
			tutar = tutar * 100;
		else
		{
			if(int(tutar) eq tutar)
				tutar = tutar & "." & "00"; else tutar = tutar;
		}
		if(not isdefined('is_iptal'))
		{
			if(isdefined('attributes.exp_month') and len(attributes.exp_month))
				expire_month = RepeatString("0",2-Len(attributes.exp_month)) & attributes.exp_month;
			else
				expire_month = RepeatString("0",2-Len(attributes.expire_month)) & attributes.expire_month;
			
			if(pos_type eq 7)
			{
				if(isdefined('attributes.exp_year') and len(attributes.exp_year))
					expire_year = attributes.exp_year;
				else
					expire_year = attributes.expire_year;
			}
			else
			{
				if(isdefined('attributes.exp_year') and len(attributes.exp_year))
					expire_year = Right(attributes.exp_year,2);
				else
					expire_year = Right(attributes.expire_year,2);
			}
	   }
	</cfscript>
	<cfif isdefined('is_iptal')>
	    <cfinclude template="add_online_pos_iptal.cfm">
    <cfelse>
		<cfif listfind("1,2,3,4,5,6,7,8,10,13,14,15,16,17,18",pos_type,',')><!---Akbank,Fortis,İşBank,DenizBank,Finansbank,HSBC,Vakıfbank,Halkbank,Citibank,TEB,Garanti,ING Bank(xml format),Şekerbank--->
            <cfif secure_3d eq 1>
                <cfinclude template="add_online_pos_3d_xml.cfm">
            <cfelse>
                <cfinclude template="add_online_pos_xml.cfm">
            </cfif>
        <cfelseif listfind("9,11,12",pos_type,',')><!---YapıKredi,Türkiye finans, bankasya (dll Format)--->
            <cfif secure_3d eq 1>
                <cfinclude template="add_online_pos_3d_dll.cfm">
            <cfelse>
                <cfinclude template="add_online_pos_dll.cfm">
            </cfif>
        </cfif>
    </cfif>
<cfelse>
	<script type="text/javascript">
		alert('Sanal pos tanımlarınız yapılmamış. Sistem yöneticinize başvurunuz!');
		history.back();
	</script>
</cfif>