<cfset price_limit = 1000>
<cfset validation_status = 1>
<cfset partial_validation = 0>
<cfif isdefined('form.var_')>
<cfset attributes.price = evaluate('session.#var_#_total')>
</cfif>
﻿<!--- tutar --->
<!--- kontrol öncesi islemleri --->

﻿<!--- tutar --->
<!--- olumlu --->
<cfif attributes.price lt price_limit>

﻿	<!--- uretim --->
			<!--- kontrol oncesi islemleri --->


		<!--- urun bilgisi al (tedarik / uretim) --->
		<!--- tüm ürünleri loop et --->
		<cfinclude template="get_product_info.cfm">
﻿	<!--- uretim --->
			<!--- olumlu --->
<cfif get_product_info.IS_PRODUCTION>
﻿	<!--- uretim Emri --->
<cfset process_status = 4>
</cfif>
﻿<!--- tutar --->
<!--- kontrol oncesi islemleri --->

<cfelse>
﻿<!--- tutar --->
<!--- olumsuz --->

﻿<!--- onay --->
<!--- kontrol oncesi islemleri --->
﻿<!--- onay --->
<!--- olumlu --->
<cfif validation_status>
﻿<!--- onay --->
<!--- kontrol oncesi islemleri --->
<cfelse>
﻿	<!--- onay --->
			<!--- olumsuz --->


﻿	<!--- Red --->
<cfset process_status = 7>
</cfif>
﻿	<!--- uretim --->
		<!--- kontrol oncesi islemleri --->


		<!--- urun bilgisi al (tedarik / uretim) --->
		<!--- tum urunleri loop et --->
		<cfinclude template="get_product_info.cfm">
<cfelse>
﻿	<!--- uretim --->
			<!--- olumsuz --->

﻿	<!--- Sevk emri --->
<cfset process_status = 6>
</cfif>

