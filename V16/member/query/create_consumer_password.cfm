<!--- xml'e bağlı olarak otomatik rastgele password oluşturma MK 13022020 --->
<cfsetting showdebugoutput="no"> 
<cfset letters = "1,2,3,4,5,6,7,8,9,0"> 
<cfset password = ''> 
<cfloop from="1" to="6" index="ind">		     
	<cfset random = RandRange(1, 10)>
	<cfset password = "#password##ListGetAt(letters,random,',')#">
</cfloop> 
<input type="hidden" name="ajax_password" id="ajax_password" value="<cfoutput>#password#</cfoutput>">
<script type="text/javascript">
	function function_load()
		{ 
			if (document.getElementById('ajax_password')) 
			{ 
				document.getElementById('consumer_password').value = document.getElementById('ajax_password').value; 
			} 
			else 
				setTimeout('function_load()',20); 
		} 
		function_load(); 
</script>
