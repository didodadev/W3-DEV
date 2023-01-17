<!--- arzu bt  --->
  <cfswitch  expression="#ship_type#">
	<cfcase value="76">
		<cfset str_type="Mal Alım İrsaliyesi">
	</cfcase>
	<cfcase value="78">
		<cfset str_type="Alım İade İrsaliyesi">
	</cfcase>
	<cfcase value="77">
		<cfset str_type="Konsinye Giriş">
	</cfcase>
	<cfcase value="79">
		<cfset str_type="Konsinye Giriş İade">
	</cfcase>
	<cfcase value="80">
		<cfset str_type="Müstahsil Makbuz">
	</cfcase>
	<cfcase value="70">
		<cfset str_type="Parekande Satış İrsaliyesi">
	</cfcase>
	<cfcase value="71">
		<cfset str_type="Toptan Satış İrsaliyesi">
	</cfcase>
	<cfcase value="72">
		<cfset str_type="Konsinye Çıkış İrsaliyesi">
	</cfcase>
	<cfcase value="73">
		<cfset str_type="Parekande Satış İade İrsaliyesi">
	</cfcase>
	<cfcase value="74">
		<cfset str_type="Toptan Satış İade İrsaliyesi">
	</cfcase>
	<cfcase value="75">
		<cfset str_type="Konsinye Çıkış İade İrsaliyesi">
	</cfcase>
  </cfswitch>

